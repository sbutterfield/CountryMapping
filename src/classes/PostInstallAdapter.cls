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
			success = true;
		}
		else {
			// Upgrading or re-installing, do nothing.
		}
	}
}