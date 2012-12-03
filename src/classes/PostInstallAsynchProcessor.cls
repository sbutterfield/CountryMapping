/**
 *	@author: Shawn Butterfield, Salesforce.com Inc.
 *	This class is called from an Installation Context Adapter to automatically create some standardized 'out-of-the-box' Country Mappings
 */
public virtual class PostInstallAsynchProcessor {
	
	private static String endpoint = 'http://api.edoceo.com/iso/3166/1?f=json';
	
	@future(Callout=true)
	public static void setCountryMappings() {
		if(endpoint != null && !RuntimeState.isInFutureContext) {
			RuntimeState.isInFutureContext = true;
			List<CountryMapping> countries = parseResponse(getCountries());
			if(countries != null && countries.size() > 1) {
				List<Standardized_Country__c> stdCountriesToInsert = new List<Standardized_Country__c>();
				Map<String, String> codeDesc = new Map<String, String>();
				for(CountryMapping c : countries) {
					stdCountriesToInsert.add(new Standardized_Country__c(ISO_3166_1_numeric__c = c.code, ISO_3166_1_alpha_3__c = c.iso3, ISO_3166_1_alpha_2__c = c.iso2));
					codeDesc.put(c.code,c.name_en);
				}
				List<Database.SaveResult> sr;
				try{
					sr = Database.insert(stdCountriesToInsert, true);
				}
				catch(DMLException d) {
					System.debug(LoggingLevel.ERROR,'Error while trying to insert Standardized Countries, cannot continue. ' +d.getStackTraceString());
					return;
				}
				Set<Id> scRows;
				if(sr != null) {
					scRows = new Set<Id>();
					for(Database.SaveResult r : sr) {
						if(r.isSuccess()) {
							scRows.add(r.getId());
						}
					}
				}
				
				List<Standardized_Country__c> stdCountries;
				if(scRows != null) {
					 stdCountries = new List<Standardized_Country__c>([Select s.Id, s.Name, s.ISO_3166_1_numeric__c, s.ISO_3166_1_alpha_3__c, s.ISO_3166_1_alpha_2__c, s.FIPS_10_4__c From Standardized_Country__c s Where Id IN :scRows]);
				}
				
				List<Country_Descriptor__c> descList;
				if(stdCountries != null) {
					descList = new List<Country_Descriptor__c>();
					for(Standardized_Country__c c : stdCountries) {
						System.debug('std country in iterable: ' +c);
						String descriptor = codeDesc.get(c.ISO_3166_1_numeric__c);
						descList.add(new Country_Descriptor__c(Standardized_Country__c = c.Id, Description__c = descriptor));
					}
				}
				
				if(descList != null) {
					try {
						Database.insert(descList, true);
					}
					catch(DMLException d) {
						System.debug('Error while trying to insert Country_Descriptors, exiting gracefully ' +d.getStackTraceString());
					}
				}
			}
			else {
				System.debug(LoggingLevel.ERROR,'Fatal Error: Could not create any sample country mappings, didn not receive anything from the parser!');
			}
		}
	}
	
	private static HttpResponse getCountries() {
		HttpRequest req = createRequest(endpoint, null, 'GET', false, 20000);
		HttpResponse res;
		if(req != null) {
			Http http = new Http();
			res = new HttpResponse();
			try {
				res = http.send(req);
			}
			catch (Exception e) {
				System.debug(LoggingLevel.ERROR,'Exception making callout: ' +e.getStackTraceString());
			}
		}
		return res;
	}
	
	private static List<CountryMapping> parseResponse(HTTPResponse res) {
		List<CountryMapping> countries;
		if(res != null) {
			String jsonContent = res.getBody();
			if(jsonContent.countMatches('}') > 0) {
				// JSON from the standard API sucks, we have to fix it first before the Apex parser will eat it.
				jsonContent = jsonContent.replaceAll('(\\})', '},');
				jsonContent = jsonContent.replaceAll('(\\},\\])', '}]');
				System.debug('Json content \n ' +jsonContent);
			}
			JSONParser parser = JSON.createParser(jsonContent);
			countries = new List<CountryMapping>();
			while(parser.nextToken() != null) {
				if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
					while(parser.nextToken() != null) {
						if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
							CountryMapping country = (CountryMapping)parser.readValueAs(CountryMapping.class);
							String s = JSON.serialize(country);
							countries.add(country);
						}
					}
				}
			}
		}
		return countries;
	}
	
	/**
	 * Safely creates an http request
	 */
	private static HttpRequest createRequest(String url, String body, String method, Boolean compressed, Integer timeout) {
        if (url == null) {
            return null;
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        
        if (body != null) {
            req.setBody(body);
        }
        
        // NOTE: Method is case sensitive.
        if ('GET'.equals(method) || 'POST'.equals(method)) {
            req.setMethod(method);
        }
        else {
            req.setMethod('GET');
        }
        
        if (compressed != null) {
            req.setCompressed(compressed);
        }
        
        // HttpRequest allows a timeout value between 1ms and 60000ms.
        if (timeout != null && timeout > 0 && timeout <= 60000) {
            req.setTimeout(timeout);
        }
        
        return req;
    }
}