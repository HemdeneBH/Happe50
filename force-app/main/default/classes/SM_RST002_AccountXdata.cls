/**
 * @author Sutharsan Pushparajah
 * @date 24/06/2022
 * @description SM_RST002_AccountXdata - Exposed WS to import Account from XDATA
 */
@RestResource(urlMapping='/account/*')
global with sharing class SM_RST002_AccountXdata {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @param accounts List of accounts with details represented by key/value pairs
     * @description Create or update account with account
     * @return String informations about the processing of the query
     */
	@HttpPost
	global static String importAccounts(List<Map<String,String>> accounts) {
		if (FeatureManagement.checkPermission('EN_XDATA_IMPORT_V2')){
            return SM_SM101_AccountImport.importAccounts(accounts);
        } else {
            //old implemntation to discontinue later on
            return SM_AP46_XdataImportAccount.importAccounts(accounts);
        }
    }
}