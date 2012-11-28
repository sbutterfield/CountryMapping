/**
 *	@author: Shawn Butterfield, Salesforce.com Inc
 *	Apex object coniner for de-serialized country representation from JSON or XML response
 */
global virtual class CountryMapping {
	
	global String code;
	global String iso2;
	global String iso3;
	global String name_en;
}