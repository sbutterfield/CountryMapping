/**
 *	This is a static utility with methods that are invoked from a triggered or batch runtime. The methods allow any given input SObject series to have an unknown number and name of country fields at runtime.
 *	The utility reads a series of settings to gather field names for this SObject and fetches the values for those field names.
 *	Once values are known a collection is built and standardized values are looked up using simple Soundex keys.
 *	Those values are then used to build a mapping between input values and their standardized values if exists. This mapping is returned to the client thread and each object with the corresponding key input is given a standardized output value.
 *	A mapping of each SObject's Id value and the map of it's corresponding field to standardized value is cached in this utility in case the requestor needs to perform additional processing in a separate thread.
 *	@Author: Shawn Butterfield, Salesforce.com, Inc.
 *	@Date: 5/4/2013
 */

global class CountryMappingHelperUtil {

	// SObject cache that is globally accessible
	/**
	 *	(key 1) SObject = the object that was submitted for transformation, represented in its standardized state
	 *	(key 2) String = the original input string provided for transformation
	 *	(key 3) String = the soundex key generated from the input
	 *	(value 1) String = the standardized output returned to the sobject
	 */
	global static Map<SObject, Map<String,Map<String,String>>> outputCache;
	
	public static String STANDARDIZED_FIELD;
	static {
		CountryConfig__c settings = CountryConfig__c.getInstance('Settings');
		if(settings != null) {
			STANDARDIZED_FIELD = settings.Selected_Output__c;
		}
	}
	
	private CountryMappingHelperUtil() {
		// Object instances of CountryMappingHelperUtil are not allowed.
	}
	
	
	/**
	 *	Called to set the country value on a list of SObjects
	 */
	global static void standardizeCountries(List<SObject> inputObjects, List<CountryFieldSet__c> inputSettings) {
		if(inputObjects == null || inputSettings == null) {
			return;
		}
		
		Set<String> countryValues = new Set<String>();
		for(CountryFieldSet__c setting : inputSettings) {
			for(SObject obj : inputObjects) {
				try {
					countryValues.add(String.valueOf(obj.get(setting.FieldName__c)).toLowerCase());
				}
				catch(NullPointerException npe) {
					// do nothing, a null pointer just means the field doesn't exist or was blank, catch the exception and debug it.
					System.debug('There was a NullPointerException thrown while trying to get the value of a field for object: ' + setting.ObjectName__c + ' for field: ' + setting.FieldName__c + ' ..... The description of the error is:' +npe.getMessage());
				}
			}
		}
		
		Map<String,Map<String,String>> mappings = getMappings(countryValues);
		if(mappings != null) {
			outputCache = new Map<SObject, Map<String,Map<String,String>>>();
			for(SObject obj : inputObjects) {
				String denormCountry;
				String normCountry;
				List<String> temp;
				for(CountryFieldSet__c setting : inputSettings) {
					// Check to see if we can get the requested value from the field in the setting and that there's something there. If not, break to the next record in the top-level iterable.
					if(String.isBlank((String)obj.get(setting.FieldName__c))) {
						break;
					}
					
					denormCountry = String.valueOf(obj.get(setting.FieldName__c)).toLowerCase();
					if(denormCountry != null) {
						// For each unique raw value we would only ever have one soundex mapping key, so get normalized value by looking at first index value
						normCountry = mappings.get(denormCountry).values()[0];
					}
					// As long as we have a normalized country, set the value for the original object and then load the temporary index with the soundex key for this particular fields value
					if(normCountry != null) {
						obj.put(setting.FieldName__c, normCountry);
						temp = new List<String>();
						temp.addAll(mappings.get(denormCountry).keySet());
					}
				}
				// Here we are loading the output cache
				if(denormCountry != null && normCountry != null & temp != null) {
					outputCache.put(obj,
					new Map<String,Map<String,String>>{
						denormCountry =>
						new Map<String,String>{
							temp[0] => 
							normCountry
						}
					}
					);
				}
			}
		}
	}
	
	
	/**
	 *	Called with a unique series of input values that will be keyed using Soundex and then organized into an I/O hashmap so the client thread can use it for transforming non-standardized country values to standard ones.
	 */
	private static Map<String,Map<String,String>> getMappings(Set<String> inputCountries) {
		if(inputCountries == null) return null;
		
		// Eventual response from method. Only initialized if we are able to return a result. Otherwise we want to send back a null.
		Map<String,Map<String,String>> result = new Map<String,Map<String,String>>();
		
		Set<String> lookupKeys = new Set<String>();
		ddcLib2.Soundex soundexService = new ddcLib2.Soundex();
		for(String raw : inputCountries) {
			System.debug('raw value from input in lower case = ' +raw);
			String key = soundexService.compute(raw);
			System.debug('computed fuzzy match key to be indexed = ' +key);
			lookupKeys.add(key);
			result.put(raw, new Map<String,String>{key => null});
		}
		
		List<Country_Descriptor__c> descriptors = new List<Country_Descriptor__c>([SELECT CountrySoundexKey__c,Standardized_Country__r.ISO_3166_1_alpha_3__c,Standardized_Country__r.ISO_3166_1_alpha_2__c,Standardized_Country__r.FIPS_10_4__c FROM Country_Descriptor__c WHERE CountrySoundexKey__c IN :lookupKeys]);
		if(descriptors.size() > 0) {
			for(Map<String,String> m : result.values()) {
				System.debug('Current row within inner map = ' +m);
				for(Country_Descriptor__c cd : descriptors) {
					System.debug('Current descriptor to check = ' +cd);
					if(m.keySet().contains(cd.CountrySoundexKey__c)) {
						try {
							m.put(cd.CountrySoundexKey__c,(String)cd.Standardized_Country__r.get(STANDARDIZED_FIELD));
						}
						catch(System.SObjectException sobjex) {
							throw new ddcLib1.FatalException('The query to fetch information from Country Descriptor and Standardized Country succeeded, but an illegal field reference was made: /n' +sobjex.getMessage());
						}
						catch(Exception e) {
							throw new ddcLib1.FatalException('Standardized Country desired output settings are not properly configured. Please select the correct desire output in custom settings and then try again: /n' +e.getMessage());
						}
					}
				}
			}
		}
		return result;
	}
	
}