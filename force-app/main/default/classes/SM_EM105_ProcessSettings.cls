/**
 * @author Sutharsan Pushparajah
 * @date 24/6/2022
 * @description SM_EM105_ProcessSettings - Entity to manage SM_ProcessSettings__mdt custommetadatatype
 */
public inherited sharing class SM_EM105_ProcessSettings {
    
    /**
     * @author Sutharsan Pushparajah
     * @date 24/06/2022
     * @description get configuration from the SM_ProcessSettings__mdt for the corresponding apiName
     * @param apiName the API Name of the setting
     * @return Map<String, Object> The map contains attribute key and value
     */
    public static Map<String, Object> getProcessSettings(String apiName){
        SM_ProcessSettings__mdt processSettings = SM_ProcessSettings__mdt.getInstance(apiName);
        Map<String, Object> attributes = (Map<String, Object>) JSON.deserializeUntyped(processSettings.JsonAttr__c);
        
        return attributes;
    }
}