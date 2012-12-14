public with sharing class CountryTriggerHelper {
	
	private static Map<Id,SObject> tMap { get; set; }

	public static String getCountryMapping(String input) {
		return null;
	}
	
	private static String getConfiguration() {
		Map<String, SObject> mapping = CountryMapping__c.getAll();
		return (String)ConfigurationSetting.getSetting('country', mapping);
	}
	
	private CountryTriggerHelper() {}
}