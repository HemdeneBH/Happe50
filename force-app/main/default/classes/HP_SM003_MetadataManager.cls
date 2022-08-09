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
    public static String getEspaceClientURL(Id contactId) {
        if (contactId == null) {
            return null;
        }
        
        User contactUser = [SELECT id FROM USER WHERE contactId = :contactId LIMIT 1][0];
        if (contactUser == null) {
            return null;
        }

        NetworkMember contactMember = [SELECT networkId FROM NetworkMember WHERE memberId = :contactUser.id AND networkId IN (SELECT id FROM Network WHERE name = 'HP Client Portal') LIMIT 1][0];
        if (contactMember == null || contactMember.networkId == null) {
            return null;
        }

        string configUrl = HP_UTIL_MetadataManager.getConfigByKey('HP_EC_PORTAL_URL');
        if (configUrl == null) {
            return null;
        }

        configUrl = configUrl.replace('{yourdomain}', URL.getOrgDomainUrl().toExternalForm());
        configUrl = configUrl.replace('{contactId}', String.valueOf(contactId));
        configUrl = configUrl.replace('{orgId}', UserInfo.getOrganizationId());
        configUrl = configUrl.replace('{networkId}', String.valueOf(contactMember.networkId));
        configUrl = configUrl.replace('{userId}', String.valueOf(contactUser.Id));

        return configUrl;
    }
    
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