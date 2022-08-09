/** 

 * @description       : Utility class for extracting values of a Map object
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 2020-12-08
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-02-2020   Patrick THAI     Initial Version
**/
public class COE_UTIL_Map {

    ////////////////////////////////////////////////////////////////////////////////////////////
    // @author Patrick THAI
    // @date 2020-12-08
    // @description Copies the field values of a record to another record. 
    //              Both records can be different sObjects, but the field 
    //              API Name must be the same
    // @param fieldNames API Names of the fields to be copied 
    // @param sourceRecord Record from which the fields are copied
    // @param targetRecord Record where  the fields are copied (field name must be the same, minus the namespace)
    // @param sourceNS Namespace of the source record if necessary
    public static void copyFields(Set<String> fieldNames, sObject sourceRecord, sObject targetRecord, String sourceNS) {
        for(String fieldName : fieldNames){
            String nsFieldName = String.isEmpty(sourceNS) ? fieldName : sourceNS + '__' + fieldName;
            targetRecord.put(fieldName, sourceRecord.get(nsFieldName));
        }
    }
 
    //////////////////////////////////////////////////////////////////////////////////////////// 
    // @author Patrick THAI
    // @date 2020-12-08
    // @description Copies the values of a Map to the custom fields of a record. 
    //              The keys of the Map must match the field Names (not API Name)
    // @param properties Set of keys for which the values are copied
    // @param sourcePropSet Map from which the values are copied
    // @param targetRecord Salesforce record where the values are copied
    public static void copyProperties(Set<String> properties, Map<String, Object> sourcePropSet, sObject targetRecord) {
        for(String prop : properties){
            String fieldName  = prop + '__c';
            if(sourcePropSet.containsKey(prop))
                targetRecord.put(fieldName, sourcePropSet.get(prop));
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////// 
    // @author Patrick THAI
    // @date 2020-12-08
    // @description Checks if values of a Map are not null and copy the results in custom fields of a record. 
    //              The keys of the Map must match the field Names (not API Name)
    // @param properties Set of keys for which the values are checked
    // @param sourcePropSet Map from which the values are checked
    // @param targetRecord Salesforce record where the results are stored  
    public static void checkProperties(Set<String> properties, Map<String, Object> sourcePropSet, sObject targetRecord) {
        for(String prop : properties){
            String fieldName  = 'Has' + prop + '__c';
            if(sourcePropSet.containsKey(prop)){
                targetRecord.put(fieldName, !String.isEmpty(String.valueOf(sourcePropSet.get(prop))));
            }
        } 
    }
}