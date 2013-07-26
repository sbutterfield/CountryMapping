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
@isTest (seealldata = false)
private class CountryTriggerHelperTest {

    /*
    static testMethod void myUnitTestforhelpclass() {
       Test.startTest(); 
       Country_Mapping__Standardized_Country__c country1 = new Country_Mapping__Standardized_Country__c();
       country1.Name = 'Canada';
       country1.Country_Mapping__ISO_3166_1_alpha_2__c = 'CA';
       country1.Country_Mapping__ISO_3166_1_alpha_3__c = 'CAN';
       insert country1;
       country1 = [SELECT id,Country_Mapping__ISO_3166_1_alpha_2__c, Country_Mapping__ISO_3166_1_alpha_3__c, Name from Country_Mapping__Standardized_Country__c WHERE id = : country1.Id];
       Country_Mapping__Standardized_Country__c country2 = new Country_Mapping__Standardized_Country__c();
       country2.Name = 'United States';
       country2.Country_Mapping__ISO_3166_1_alpha_2__c = 'US';
       country2.Country_Mapping__ISO_3166_1_alpha_3__c = 'USA';
       insert country2;
       country2 = [SELECT id,Country_Mapping__ISO_3166_1_alpha_2__c, Country_Mapping__ISO_3166_1_alpha_3__c, Name from Country_Mapping__Standardized_Country__c WHERE id = : country2.Id];
       
     Country_Mapping__Country_Descriptor__c contrydis = new Country_Mapping__Country_Descriptor__c();
       contrydis.Country_Mapping__CountrySoundexKey__c = 'C530';
       contrydis.Country_Mapping__Description__c ='Canada';
       contrydis.Country_Mapping__Standardized_Country__c = country1.Id;
       insert contrydis;
       contrydis = [SELECT Country_Mapping__CountrySoundexKey__c,Country_Mapping__Description__c,Country_Mapping__Standardized_Country__c,Id,Name FROM Country_Mapping__Country_Descriptor__c WHERE Id =: contrydis.Id ];
       Country_Mapping__Country_Descriptor__c  contrydis1 = new Country_Mapping__Country_Descriptor__c();
       contrydis1.Country_Mapping__CountrySoundexKey__c = 'U532';
       contrydis1.Country_Mapping__Description__c ='United States';
       contrydis1.Country_Mapping__Standardized_Country__c = country1.Id;
       insert contrydis1;
       contrydis = [SELECT Country_Mapping__CountrySoundexKey__c,Country_Mapping__Description__c,Country_Mapping__Standardized_Country__c,Id,Name FROM Country_Mapping__Country_Descriptor__c WHERE Id =: contrydis1.Id ];
       
       Country_Mapping__CountryConfig__c cong = new Country_Mapping__CountryConfig__c();
       cong.Country_Mapping__Account_Event_Trigger_Enabled__c = true;
       cong.Country_Mapping__Contact_Event_Trigger_Enabled__c = true;
       cong.Country_Mapping__Fuzzy_Match_Enabled__c = true;
       cong.Country_Mapping__Fuzzy_Match_Threshold__c = 80;
       cong.Country_Mapping__Lead_Event_Trigger_Enabled__c = true;
       cong.Country_Mapping__Selected_Output__c = 'ISO_3166_1_alpha_3__c';
       cong.Name = 'Settings';
       insert cong;
       cong = [SELECT Country_Mapping__Account_Event_Trigger_Enabled__c,Country_Mapping__Contact_Event_Trigger_Enabled__c,Country_Mapping__Fuzzy_Match_Enabled__c,Country_Mapping__Fuzzy_Match_Threshold__c,
       Country_Mapping__Lead_Event_Trigger_Enabled__c,Country_Mapping__Selected_Output__c,Id,Name FROM Country_Mapping__CountryConfig__c WHERE id =: cong.id];
       
       // Field set for Account
       Country_Mapping__CountryFieldSet__c fieldset1= new Country_Mapping__CountryFieldSet__c();
       fieldset1.Country_Mapping__FieldName__c = 'ShippingCountry';
       fieldset1.Country_Mapping__ObjectName__c = 'Account';
       fieldset1.Name = 'testaccount';
       insert fieldset1;
       fieldset1 = [SELECT id, Country_Mapping__FieldName__c,Country_Mapping__ObjectName__c FROM  Country_Mapping__CountryFieldSet__c WHERE id =: fieldset1.id];
       
       // Field set for Contact
       Country_Mapping__CountryFieldSet__c fieldset2 = new Country_Mapping__CountryFieldSet__c();
       fieldset2.Country_Mapping__FieldName__c = 'MailingCountry';
       fieldset2.Country_Mapping__ObjectName__c = 'Contact';
       fieldset2.Name = 'testContact';
       insert fieldset2;
       fieldset2 = [SELECT id, Country_Mapping__FieldName__c,Country_Mapping__ObjectName__c FROM  Country_Mapping__CountryFieldSet__c WHERE id =: fieldset2.id];
       
       // Field set for Lead
       Country_Mapping__CountryFieldSet__c fieldset3= new Country_Mapping__CountryFieldSet__c();
       fieldset3.Country_Mapping__FieldName__c = 'Country';
       fieldset3.Country_Mapping__ObjectName__c = 'Lead';
       fieldset3.Name = 'testLead';
       insert fieldset3;
       fieldset3 = [SELECT id, Country_Mapping__FieldName__c,Country_Mapping__ObjectName__c FROM  Country_Mapping__CountryFieldSet__c WHERE id =: fieldset3.id];
       
       Account acc = new Account();
       acc.Name = 'Test Account' ;
       acc.ShippingCountry = 'cnada';
       acc.BillingCountry = 'United States';
       insert acc;
       acc= [select Name, ShippingCountry, BillingCountry FROM Account WHERE id =: acc.id];
       system.assertequals('CAN', acc.ShippingCountry);
       system.assertequals('United States', acc.BillingCountry);
       
       Country_Mapping__CountryFieldSet__c fieldset1clone = new Country_Mapping__CountryFieldSet__c();
       fieldset1clone.Country_Mapping__FieldName__c = 'BillingCountry';
       fieldset1clone.Country_Mapping__ObjectName__c = 'Account';
       fieldset1clone.Name = 'testAnotherAccount';
       insert fieldset1clone;
       fieldset1clone = [SELECT id, Country_Mapping__FieldName__c,Country_Mapping__ObjectName__c FROM  Country_Mapping__CountryFieldSet__c WHERE id =: fieldset1.id];
       
       acc.ShippingCountry = 'cnada';
       acc.BillingCountry = 'United States'; 
       update acc;
       acc= [select Name, ShippingCountry, BillingCountry FROM Account WHERE id =: acc.id];
       system.assertequals('CAN', acc.ShippingCountry);
       system.assertequals('United States', acc.BillingCountry);
       
       
       fieldset1.Country_Mapping__FieldName__c = 'ShippingCoun';
       update fieldset1;
       Account acc1 = new Account();
       acc1.Name = 'Test Account1' ;
       acc1.ShippingCountry = 'cnada';
       insert acc1;
       acc1= [select Name, ShippingCountry, BillingCountry FROM Account WHERE id =: acc1.id];
       system.assertequals('cnada', acc1.ShippingCountry);
       
       Contact con = new Contact();
       con.LastName = 'LastName';
       con.FirstName = 'FirstName';
       con.MailingCountry = 'Cnada' ;
       con.Email = 'test@test.com';
       insert con;
       con = [SELECT id,LastName, FirstName, MailingCountry, Email FROM Contact WHERE id =: con.Id];
       system.assertequals('CAN', con.MailingCountry);
       
       fieldset2.Country_Mapping__FieldName__c = 'MailingCoun';
       update fieldset2;
       Contact con1 = new Contact();
       con1.LastName = 'LastName1';
       con1.FirstName = 'FirstName1';
       con1.MailingCountry = 'CANADA' ;
       con1.Email = 'test@test.com';
       insert con1;
       con1 = [SELECT id,LastName, FirstName, MailingCountry, Email FROM Contact WHERE id =: con1.Id];
       system.assertequals( 'CANADA', con1.MailingCountry);
       
       Lead led = new Lead();
       led.LastName = 'LastName';
       led.FirstName = 'FirstName';
       led.Country = 'Canada' ;
       led.Company  = 'test Company' ;
       led.LeadSource = 'Open - Not Contacted';
       insert led;
       led = [SELECT id, LastName, FirstName, Country,Company, LeadSource FROM Lead WHERE id =: led.id];
       system.assertequals('CAN', led.Country);
       
          
       fieldset3.Country_Mapping__FieldName__c = 'Count';
       update fieldset3;
       Lead led1 = new Lead();
       led1.LastName = 'LastName1';
       led1.FirstName = 'FirstName1';
       led1.Country = 'Canada' ;
       led1.Company  = 'test Company1' ;
       led1.LeadSource = 'Open - Not Contacted';
       insert led1;
       led1 = [SELECT id, LastName, FirstName, Country,Company, LeadSource FROM Lead WHERE id =: led1.id];
       system.assertequals('Canada', led1.Country);
       Test.stopTest();
        
    }*/
    /*static testMethod void myUnitTestForHelperupdatecalls() {
        
        List<Account> negAct = Testutil.newAccount('jjjjjj', 1);
        List<Contact> negcont = TestUtil.newContact('fdfdfdfs', 1);
        List<Lead>    negled  = TestUtil.newLead('hdhhddh', 1); 
        negAct[0].ShippingCountry = 'Canada';
        negcont[0].MailingCountry = 'United States';
        negled[0].Country = 'Australia';
        update negAct[0];
        update negcont[0];
        update negled[0];
        Test.startTest();
        
        system.assertequals('CAN', negact[0].ShippingCountry);
        system.assertequals('USA', negcont[0].MailingCountry);
        system.assertequals('AUS', negled[0].Country);
        Test.stopTest();
    }*/
}