/** 
* @author Slimen Belhaj Ali 
* @date 31/12/2019 
* @description Classe permet de gerer les custom metadata
*/
public with sharing class HP_UTIL_MetadataManager {

    private static Map<String, String> metadataMap = null;
    private static String INTEGER_TYPE = 'INTEGER';
    private static String STRING_TYPE = 'STRING';


    private static List<HP_OmniChannelRouting__mdt> routingParameters = null;



    /** 
    * @author Slimene Belhaj Ali
    * @date 31/12/2019 
    * @description Methode permet de recuperer la configuration en fonction de clé
    * @param key, le clé de la config
    */
    @AuraEnabled(cacheable=true)
    public static String getConfigByKey(String key) {
        try {
            HP_Parameter__mdt mdt = [SELECT DeveloperName, value__c, Is_Encrypted__c FROM HP_Parameter__mdt WHERE DeveloperName = :key LIMIT 1];
            if(mdt != null){
                return mdt.Is_Encrypted__c? decrypt(mdt.Value__c) : mdt.Value__c;
            }else {
                return null;
            }
        } catch (Exception ex) {
            System.debug('Exception : '+ex.getMessage());
            return null;
        } 
    }

    public static String decrypt(String value){
        return HP_UTIL_CryptoUtils.decryptData(String.valueOf(value));
        
    }
       
       public static String getContryCode(String indicatif) {
        if(metadataMap == null) {
            metadataMap = new Map<String, String>();
            List<HP_CountryCode__mdt> MDTList = [select IndiFRA__c, IsoFra__c from HP_CountryCode__mdt];
            for(HP_CountryCode__mdt mdt : MDTList) {
                metadataMap.put(mdt.IndiFRA__c, mdt.IsoFra__c);
            }
        }
         System.debug('indicatif '+ indicatif);
        System.debug('MAP '+ metadataMap);
        System.debug('MAP ISO'+ metadataMap.get(indicatif));
        return metadataMap.get(indicatif);
    }




    /**
    * @description 
    * @author Antoine Latour | 27-11-2020 
    * @return List<HP_OmniChannelRouting__mdt> 
    **/
    public static List<HP_OmniChannelRouting__mdt> getOmniChannelRoutingMtd() {
        if(routingParameters == null) {
            routingParameters = [select HP_CritCaseOrigin__c,HP_CritCaseSubType__c,HP_CritCaseType__c,HP_CritQueue__c,HP_CritRecordType__c,HP_CritSkillType__c,HP_ValuePriority__c,HP_ValueSkill__c from HP_OmniChannelRouting__mdt];
        }
        return routingParameters;
    }




    /**
    * @description : Recuperer la configuration en fonction des clées
    * @author Ali AJELLAL | 11-12-2020 
    * @param keys 
    * @return Map<String, Map<object, object>> 
    **/
    public static Map<String, Map<object,object>> getCodification(List<String> keys){

        //get all parents with the children
        List<HP_Codification__mdt> allCodificationWithChild = [select ID,DeveloperName,keyType__c,valueType__c,(select ID,parent__c,DeveloperName, key__c, value__c from HP_CodificationValeurs__r) from HP_Codification__mdt where developername IN:keys];
        Map<String, Map<object,object>> result = new Map<String, Map<object,object>>();

        for (HP_Codification__mdt item : allCodificationWithChild) {
            System.debug('********item ******* '+ item);
            Map<object,object> dataToInsert = new Map<object,object>();
            //loop throw children
            for (HP_CodificationValeur__mdt codificationVal : item.HP_CodificationValeurs__r) {
                dataToInsert.put(extractData(codificationVal.key__c,item.keyType__c),extractData(codificationVal.value__c,item.valueType__c));
            }
            result.put(item.DeveloperName, dataToInsert);
        }

        System.debug('********result******* '+ result);
        return result;
    }

	/**
	* @description 
	* @author Ali AJELLAL | 11-12-2020 
	* @param field 
	* @param type 
	* @return Object 
	**/
	public static Object  extractData(Object field , String type){
		Object currentValue;
		
		if(type.toUpperCase() == INTEGER_TYPE){
		currentValue = Integer.valueOf(field);
		}
		if(type.toUpperCase() == STRING_TYPE){
			currentValue = String.valueOf(field);
		}
		return currentValue;
	}




}