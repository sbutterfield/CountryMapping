public with sharing class CleanUp {
	public static void cleanShitUp() {
		List<Standardized_Country__c> scList = new List<Standardized_Country__c>([Select Id,Name From Standardized_Country__c Where IsDeleted = false]);
		Database.delete(scList);
		System.debug('deleted stuff successfully...');
	}
}