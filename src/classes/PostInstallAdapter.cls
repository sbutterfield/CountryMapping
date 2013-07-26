/**
 *	@author: Shawn Butterfield, Salesforce.com Inc.
 *	Installation adapter class implements the InstallHandler interface and runs a post installation script to fire an asynchronous process and populate Country mapping data to:
 *	Standardized_Country__c && Country_Descriptor__c
 *	Uses http://api.edoceo.com/iso/3166/1?f=json
 */
global class PostInstallAdapter implements InstallHandler {
	
	global Boolean success;
	
	global void onInstall(InstallContext context) {
		if(context.previousVersion() == null) {
			PostInstallAsynchProcessor.setCountryMappings();
			User u = [Select Id, Email from User where Id =:context.installerID()];   
			String toAddress= u.Email;
			String[] toAddresses = new String[]{toAddress};
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(toAddresses);
			mail.setReplyTo('support@salesforce.com');
			mail.setSenderDisplayName('Package Support');
			mail.setSubject('Post-Install script ran successfully');
			mail.setPlainTextBody('Post-Install script created 249 country mappings for you.');
			Messaging.sendEmail(new Messaging.Email[] { mail });
			createCustomSetting();
			success = true;
		}
		else {
			// Upgrading or re-installing, do nothing.
		}
	}
	
    private static void createCustomSetting() {
    	CountryConfig__c config;
    	try {
    		config = CountryConfig__c.getInstance('Settings');
    		if(config == null){
	    		config = new CountryConfig__c();
	    		config.Name = 'Settings';
		    	config.Selected_Output__c = 'Country_Mapping__ISO_3166_1_alpha_3__c';
		    	insert config;
    		}
    	}
    	catch (Exception e) {
    		System.debug(LoggingLevel.Error,'Error while trying to create custom setings. ' +e);
    	}
    	
    }
}