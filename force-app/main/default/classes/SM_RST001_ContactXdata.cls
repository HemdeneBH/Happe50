/**
 * @author Sutharsan Pushparajah
 * @date 24/06/2022
 * @description SM_RST001_ContactXdata - Exposed WS to import contact from XDATA
 */
@RestResource(urlMapping='/contact/*')
global with sharing class SM_RST001_ContactXdata {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @param contacts List of contacts with details represented by key/value pairs
     * @description Create or update contact with account and accountcontactroles
     * @return String informations about the processing of the query
     */
	@HttpPost
	global static String importContacts(List<Map<String,String>> contacts) {
		if (FeatureManagement.checkPermission('EN_XDATA_IMPORT_V2')){
            return SM_SM100_ContactImport.importContacts(contacts);
        } else {
            //old implemntation to discontinue later on
            return SM_AP47_XdataImportContact.importContacts(contacts);
        }
    }
}