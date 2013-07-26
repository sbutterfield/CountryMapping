/**
 * @author Sudheer Peddineni
 * @date January 2013
 * @description to map the  country value to country ISO  
*/
trigger CountryMappingAccountTrigger on Account (after insert, before update) {
/*
	CountryConfig__c cntryconfig = CountryConfig__c.getinstance('Settings'); 	
	if(cntryconfig.Account_Event_Trigger_Enabled__c == True && !ddcLib1.RuntimeState.isInFutureContext){
		
		list<Country_Mapping__CountryFieldSet__c> fieldmapList = new list<Country_Mapping__CountryFieldSet__c>(
		[SELECT Country_Mapping__FieldName__c FROM Country_Mapping__CountryFieldSet__c WHERE Country_Mapping__ObjectName__c = 'Account']);
		map<String,map<Id, String>> actIdAndCountry = new map<String,map<Id,String>>();
		map<String,map<Id, String>> accIdAndCountryISO = new map<String,map<Id, String>>();
		List<Account> afterInsertacts = new List<Account>();
		
		for(Account act: Trigger.new){
			try{
			for(Country_Mapping__CountryFieldSet__c cfs: fieldmapList){
				
				map<Id, String> temp = new map<Id, String>();
				string tempStr = (string)act.get(cfs.Country_Mapping__FieldName__c);
				temp.put(act.id, tempStr.toUppercase());
				actIdAndCountry.put(cfs.Country_Mapping__FieldName__c.toUppercase(),temp);
				system.debug('actIdAndCountry' +actIdAndCountry);
				
				}
			}
			catch (Exception ex){
					system.debug('Please correct the field set in custom settings and make sure the object you are trying to reference is valid!');
				}
		}
		
		Integer i = actIdAndCountry.size();
		for(String fieldName: actIdAndCountry.keyset() ){
			CountryTriggerHelper helper = new CountryTriggerHelper();
			
			if(i==1){
				accIdAndCountryISO.put(fieldName.toUppercase(), helper.getCountryMapping(actIdAndCountry.get(fieldName.toUppercase()), ddcLib1.RuntimeState.getBeforeRunStatus(actIdAndCountry.get(fieldName.toUppercase()).keyset())));
			}
			else 
				accIdAndCountryISO.put(fieldName.toUppercase(), helper.getCountryMapping(actIdAndCountry.get(fieldName.toUppercase()), false));
			i--;			
			system.debug('accIdAndCountryISO' + accIdAndCountryISO);
		}
		if(accIdAndCountryISO.isempty() != true){
			for(Account act: Trigger.new){
				
				for(String fieldName: actIdAndCountry.keyset()){
					if(trigger.isbefore && accIdAndCountryISO.get(fieldName.toUppercase()) != null){
						system.debug('accIdAndCountryISOget' + accIdAndCountryISO.get(fieldName.toUppercase()));
						system.debug('fieldName' + fieldName );
						act.put(fieldName.toUppercase(), accIdAndCountryISO.get(fieldName.toUppercase()).get(act.Id));
					}
					else if(trigger.isAfter && accIdAndCountryISO.get(fieldName.toUppercase()) != null) {
						Account  ac = new Account (Id=act.Id);
						ac.put(fieldName, accIdAndCountryISO.get(fieldName.toUppercase()).get(act.Id));
						afterInsertacts.add(ac);
					}
				 }
				
				
				
			}
			if(afterInsertacts !=  null) update afterInsertacts;
		}
	}
	*/
}