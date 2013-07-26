/**
 * Calculates the soundex encoding for each country descriptor for easy reference in future runtimes
 */
trigger EncodeSoundex on Country_Descriptor__c (before insert, before update) {

    for (Country_Descriptor__c coun:Trigger.new){
    	ddcLib2.Soundex algo = new ddcLib2.Soundex();
        coun.CountrySoundexKey__c = algo.compute(coun.Description__c);
    }
}