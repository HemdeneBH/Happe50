public class VI_ObjectUtils {
    /**
* @description : Returns the Record Type Id for a specific Record Type Developer Name
* @param String objectName and String recordTypeDevName
* @return Id
**/
    @AuraEnabled(cacheable = true)
    public static Id getRecordTypeId(String objectName, String recordTypeDevName) {
        Id recordTypeId = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();
        
        return recordTypeId;
    }
    
    /**
* @description : Returns all Record Type in a map for a specific Object Name
* @param String objectName and String recordTypeDevName
* @return Id
**/
    public static Map<String, Schema.RecordTypeInfo> getRecordTypesMap(String objectName) {
        Map<String, Schema.RecordTypeInfo> recordTypesMap = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName();
        
        return recordTypesMap;
    }
    
    /**
* @description Method to check if the current Org is a Sandbox or Production
* @return Boolean 
**/
    public static Boolean isSandboxOrg() {
        Boolean isSandbox = true; //Par sécurité, on renvoie isSandbox par défaut
        List<Organization> orgs = [SELECT IsSandbox FROM Organization LIMIT 1];
        if(!orgs.isEmpty()) {
            isSandbox = orgs.get(0).IsSandbox;
        }
        
        return isSandbox;
    }
    
    
    /**
* @description Returns any picklist value visible to current User
* @param String sObjectName
* @param String picklistFieldName
* @return List<Schema.PicklistEntry>
**/
    public static List<Schema.PicklistEntry> getPicklistOptionsBySObjectName(String sObjectName, String picklistFieldName) {
        Schema.SObjectType globalDescription = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult objDescrResult = globalDescription.getDescribe();
        Map<String, Schema.SObjectField> fields = objDescrResult.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(picklistFieldName).getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        return picklistEntries;
    }
}