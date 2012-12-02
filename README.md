#Simple Country Mapping application for Force.com

##Introduction
This application is focused on a simplified approach towards mapping country keyword text and patterns to a configurable standardized format:

- ISO 3166-1 alpha-2
- ISO 3166-1 alpha-3
- ISO 3166-1 numeric
- FIPS 10-4 alpha-2

The application uses a system of two related objects to manage keyword to value relational mapping. It uses highly optimized algorithms to account for I/O normaliztion and mis-spellings.

##License
This is free software, but I sincerely hope that you show credit and maintain the open license if you decide to use this in a project or use concepts derrived from it.
If you do make improvements to the software, I hope that you will create a pull request so that those improvements can be merged and used for the benefit of everyone.


    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

##AppExchange
Country Mapping application is distributed as both a managed and un-managed 'apex certified' package. Here are the installation links:
Managed:  
Un-managed:  

##Set-up and Use

###Object-model Glossary

    Standardized_Country__c
Parent object to Country_Descriptor__c containing indexed fields of standardized country representations.

    Country_Descriptor__c
Child object to Standardized_Country__c containing an indexed descriptor field used to represent any valid input pattern which could represent it's Standardized_Country__c parent.

    global virtual CountryMapping{}
Apex wrapper object used for parsing and combined representation of a matched and mapped keyword-->standardized country format. This class was made virtual to support overrides in managed package environments.

    global virtual RuntimeState{}
Apex object that is initialized and used at the opening of each runtime to maintain a description of this applications stateful presence and operating order throughout mult-context runtimes. This class was made virtual to support overrides in managed package environments.

###Installation Routine
Usually this application's security controls will limit use and visibility only to administrators and/or operations users. Follow the typical set-up routine and you should be fine.

Upon installing a packaged version of this application, a post-installation script will execute and pre-populate the Standardized_Country__c, and Country_Descriptor__c child-object with 'out-of-the-box' data.
The script will populate a new Standardized_Country__c row for each unique:
- ISO 3166-1 alpha-2 (ex: US)
- ISO 3166-1 alpha-3 (ex: USA)
- ISO 3166-1 numeric (ex: 840)

The script will then populate a new Country_Descriptor__c row for each Standardized_Country__c with it's generally accepted, normalized text descriptor:
- Descriptor (ex: United States)

Once the installation script finishes successfully, it will notify the installing Adminstrator via e-mail.

_Note:_  
>To acquire and load the FIPS mapping for Standardized_Country__c records, I suggest manually loading the mapping from:
>http://opengeocode.org/download/fips2iso.txt

>For a comprehensive mapping file, including multi-lingual standardization:  
>http://opengeocode.org/download/countrynames.txt



###Configuration, tuning and usage
The application contains triggers for Lead, Contact and Account standard SObjects. When a record gets inserted or updated, these triggers will fire and attempt to map a non-standardized value to a standardized one.

You must start by telling the application which standardized value you want to use. Country Mapping uses a public configuration setting to control both application behavior and standardization settings. You are allowed to turn individual triggers on-or-off, control literal text matching or allow for fuzzing matching which accounts for mis-spellings, and finally tune the weight for a fuzzy match.

_Note:_  
>You can also create your own triggers and/or batch classes and reference a helper class which calls to global method signature:

    CountryTriggerHelper.getCountryMapping(String input)
>and retreives the appropriate country mapping from an `input` country string.

