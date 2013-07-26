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
private class TestPostInstallAdapter {

    static testMethod void testPostInstallAdapter() {
    	Test.startTest();
    	// Initialize mock http callout response
    	StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('jsoncontent');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
		
        PostInstallAdapter pia = new PostInstallAdapter();
        Test.testInstall(pia, null);
        Test.stopTest();
        List<Standardized_Country__c> scList = new List<Standardized_Country__c>([Select Id,Name From Standardized_Country__c Where IsDeleted = false]);
        // Callouts not allowed, cannot assert much for behavior here.
        System.assert(pia.success);
    }
}