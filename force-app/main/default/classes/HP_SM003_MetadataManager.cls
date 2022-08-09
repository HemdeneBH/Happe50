/** 
* @author Slimen Belhaj Ali 
* @date 09/01/2020 
* @description Classe permet de gerer les custom metadata
*/ 
public with sharing class HP_SM003_MetadataManager {

    /** 
    * @author Slimene Belhaj Ali
    * @date 09/01/2020 
    * @description Methode permet de URL de Agilab
    * @param key, le clé de la config
    */
    @AuraEnabled(cacheable=true)
    public static String getAgilabEspaceClientURL() {
        Organization org = [select IsSandbox from Organization where Id =:UserInfo.getOrganizationId()];
        if(org.IsSandbox) {
            return HP_UTIL_MetadataManager.getConfigByKey('HP_AGILAB_RECETTE_URL');
        } else {
            return HP_UTIL_MetadataManager.getConfigByKey('HP_AGILAB_PROD_URL');
        }
    }
    

    @AuraEnabled	
    public static Object getCodeOffre(){	
        HP_UTIL_CustomSetting.loadCustomSettingOffre();	
        return HP_UTIL_CustomSetting.codeOffreByXdataId;        	
    }
    

    @AuraEnabled
    public static string getContryCode(String indicatif){
        return HP_UTIL_MetadataManager.getContryCode(indicatif);
    }

    @AuraEnabled
    public static string getConfigurationGenerique(String cleConfiguration){
        return HP_UTIL_MetadataManager.getConfigByKey(cleConfiguration);
    }

    @AuraEnabled(cacheable=true)
    public static string getURLPortailAdmin(String keyPortailAdmin){
        return HP_UTIL_MetadataManager.getConfigByKey(keyPortailAdmin);
    }
}