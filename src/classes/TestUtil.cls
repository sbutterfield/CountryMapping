/**
 * @author Sudheer Peddineni
 * @date January 2013
 * @description Contains methods to create, either in memory or by inserting into the database, a new
 * record to be used in unit test.
*/
public with sharing class TestUtil {
       
    //*** ACCOUNT ***
                  
        
    public static List<Account> newAccount(String country,Integer totalAccounts){
        List<Account> accts = new List<Account>();
        for(Integer i = 0; i< totalAccounts ; i++){
        	Account acc = new Account();
	        acc.Name = 'Test Account' + String.valueOf(i);
	        acc.ShippingCountry = country;
	        //acc.ShippingStreet = '123 Main St';
	        //acc.BillingCountry = country ;
	        acc.BillingCountry = 'United States';
	        accts.add(acc);	        
        }
        insert accts;
        system.debug('testutilsacc' + accts);
        return accts;
    }
      
    
    // Contact
     public static List<Contact> newContact(String country,Integer totalContacts){
        List<Contact> conts = new List<Contact>();
        For(Integer i=0; i<totalContacts ; i++){
	        Contact con = new Contact();
	        con.LastName = 'LastName' +String.valueOf(i);
	        con.FirstName = 'FirstName' + String.valueOf(i);
	        con.MailingCountry = country ;
	        con.Email = 'test@test.com' +String.valueOf(i);
	        conts.add(con);
        }
        return conts;
    }
    
     public static List<Lead> newLead(String country,Integer totalLeads){
        List<Lead> leds = new List<Lead>();
        For(Integer i=0; i<totalLeads ; i++){
	        Lead led = new Lead();
	        led.LastName = 'LastName' +String.valueOf(i);
	        led.FirstName = 'FirstName' + String.valueOf(i);
	        led.Country = country ;
	        led.Company  = 'test Company' +String.valueOf(i);
	        led.LeadSource = 'Open - Not Contacted';
	        leds.add(led);
        }
        return leds;
    }
    
}