/**
 * @author Sutharsan Pushparajah
 * @date 24/06/2022
 * @description SM_RST003_RoleXdata - Exposed WS to import Role from XDATA
 */
@RestResource(urlMapping='/role/*')
global with sharing class SM_RST003_RoleXdata {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @param accountContactRelations List of accountContactRelations with details represented by key/value pairs
     * @description Create or update accountContactRelations with account and contact
     * @return String informations about the processing of the query
     */
	@HttpPost
	global static String importRoles(List<Map<String,String>> accountContactRelations) {
		if (FeatureManagement.checkPermission('EN_XDATA_IMPORT_V2')){
            return SM_SM102_RoleImport.importRoles(accountContactRelations);
        } else {
            //old implemntation to discontinue later on
            return SM_AP48_XdataImportRole.importRoles(accountContactRelations);
        }
    }
}