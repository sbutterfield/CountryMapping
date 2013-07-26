/**
 * Salesforce.com, Inc.
 * @date January 2013
 * @description It takes sobject Id, related country values and return same Sobject Id and country ISO values
*/
global with sharing class CountryTriggerHelper {
/*
    private map<String,Id> coutryMap = new map<String, Id>();
    private map<Id,Id> sobjectIdCountryId = new map<Id, Id>();
    private map<Id,string> sobjectIsoCountry = new map<Id,String>();
    private map<String,String> missingCountries = new map<String,String>();
    private map<String,String> missingCountriesWithMaching = new map<String,String>();
    
    private ddcLib2.Soundex algo = new ddcLib2.Soundex();
    
    global  Map<Id, String>  getCountryMapping(Map<Id, String> input, Boolean runtimeState) {
    
        CountryConfig__c cntryconfig = CountryConfig__c.getinstance('Settings');    
        if(runtimeState == false){
            
            for(Country_Descriptor__c country: [SELECT Description__c,Id,Standardized_Country__c FROM Country_Descriptor__c WHERE Description__c IN : input.Values()]) {

                coutryMap.put(country.Description__c.toUpperCase(), country.Standardized_Country__c);
            }
            
            for(String s: input.Values()){
            
                if(!coutryMap.containsKey(s.toUpperCase())){
            
                    missingCountries.put(s.toUpperCase(),algo.compute(s));
                }
            }
            
            for(Country_Descriptor__c country: [SELECT c.Description__c, c.CountrySoundexKey__c, c.Id,c.Standardized_Country__c FROM Country_Descriptor__c c WHERE c.CountrySoundexKey__c  IN : missingCountries.Values()]){
                
                coutryMap.put(country.Description__c.toUpperCase(), country.Standardized_Country__c);
                missingCountriesWithMaching.put(country.CountrySoundexKey__c.toUpperCase(), country.Description__c.toUpperCase());
            }
                for(Id idValue : input.keyset()) {
                    
                    String TempInputCountry = input.get(idValue).toUpperCase();
                    if(missingCountries.containsKey(TempInputCountry)){
                        
                        String temp = missingCountries.get(TempInputCountry).toUpperCase();
                        TempInputCountry = missingCountriesWithMaching.get(temp);
                    }
                    
                    if(coutryMap.get(TempInputCountry) != null) {
                    
                        sobjectIdCountryId.put(idValue,coutryMap.get(TempInputCountry));
                    }
                }
                
                if(sobjectIdCountryId.isEmpty() != true){
                
                    Map<Id,Standardized_Country__c> stndcountryMap = new Map<Id,Standardized_Country__c> 
                                                                     ([SELECT FIPS_10_4__c,Id,ISO_3166_1_alpha_2__c,ISO_3166_1_alpha_3__c,ISO_3166_1_numeric__c,Name 
                                                                     FROM Standardized_Country__c WHERE id IN : sobjectIdCountryId.values()]);
                   
                   Id tempId;
                   for(Id idValue: input.keyset()) {
                    
                        tempId = sobjectIdCountryId.get(idValue);   
                        String selectedOutput = cntryconfig.Selected_Output__c;     
                        if(tempId !=null)
                            sobjectIsoCountry.put(idValue, (string)stndcountryMap.get(tempId).get(selectedOutput)); 
                        
                   }
            }
            return sobjectIsoCountry; 
        }
        else return null;
    }
    */
}