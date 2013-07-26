/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CountryMappingHelperUtilTest {

    static testMethod void testStandardizeCountry() {
        System.assert(setUpTest());
        String inputCountry = 'United States';
        Account a = new Account(Name='ABC Company',BillingCountry=inputCountry);
        insert a;
        List<Account> accountList = new List<Account>{a};
        List<CountryFieldSet__c> settings = new List<CountryFieldSet__c>([SELECT Id,Name,ObjectName__c,FieldName__c FROM CountryFieldSet__c WHERE ObjectName__c = 'Account']);
        CountryMappingHelperUtil.standardizeCountries(accountList, settings);
        System.debug(accountList[0]);
        System.assertNotEquals(CountryMappingHelperUtil.outputCache, null);
    }
    
    static testMethod void testStandardizeCountryPassingNull() {
    	System.assert(setUpTest());
    	List<CountryFieldSet__c> settings = new List<CountryFieldSet__c>([SELECT Id,Name,ObjectName__c,FieldName__c FROM CountryFieldSet__c WHERE ObjectName__c = 'Account']);
        CountryMappingHelperUtil.standardizeCountries(null, settings);
        System.assertEquals(CountryMappingHelperUtil.outputCache, null);
    }
    
    static Boolean setUpTest() {
    	CountryFieldSet__c setting = new CountryFieldSet__c(Name='Account Billing Country',ObjectName__c='Account',FieldName__c='BillingCountry');
    	insert setting;
    	CountryConfig__c config = new CountryConfig__c(Name='Settings',Selected_Output__c='ISO_3166_1_alpha_3__c',Fuzzy_Match_Enabled__c=true);
    	insert config;
    	Standardized_Country__c stdCountry = new Standardized_Country__c(Name='United States',ISO_3166_1_alpha_2__c='US',ISO_3166_1_alpha_3__c='USA',ISO_3166_1_numeric__c='530');
    	insert stdCountry;
    	Country_Descriptor__c cDesc = new Country_Descriptor__c(Standardized_Country__c=stdCountry.Id,Description__c='United States');
    	insert cDesc;
    	return true;
    }
}