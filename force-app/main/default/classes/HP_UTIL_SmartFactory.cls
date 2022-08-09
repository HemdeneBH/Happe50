/** 
* @author Slimen Belhaj Ali 
* @date 17/12/2019 
* @description Classe de generer des tests
*/


public with sharing class HP_UTIL_SmartFactory {
	
  //custom exception 
  public class UnsupportedTypeException extends Exception {}
  
   /** 
    * @author Slimene Belhaj Ali
    * @date 17/12/2019 
    * @description Methode permet de créer un record
    * @param objectName, le apiName de l'object
    */
  public static SObject createSObject(string objectName) {
      return createSObject(objectName, null, null, Null, null, null);
  }

 /** 
    * @author Slimene Belhaj Ali
    * @date 17/12/2019 
    * @description Methode permet de créer un record
    * @param objectName, le apiName de l'object
    * @param specificValueMap, Map qui contient les champs qu'il faut les rensegnier avec les valeurs
    */
  public static SObject createSObject(string objectName, Map<String, Object> specificSimpleValueMap, Map<String, SObject> specificExternalObjectValueMap) {
      return createSObject(objectName, null, specificSimpleValueMap, specificExternalObjectValueMap, null, null);
  }

  /** 
    * @author Slimene Belhaj Ali
    * @date 17/12/2019 
    * @description Methode permet de créer un record
    * @param objectName, le apiName de l'object
    * @param recordType, le nom de RT de l'objet à créer
    * @param specificValueMap, Map qui contient les champs qu'il faut les rensegnier avec les valeurs
    * @param randomValueList, List contient les apiname des champs mais sa valeur n'est pas très important
    * @param cascadeFieldList, List contient les apiname des references qu'il fallait créer
    */
  public static SObject createSObject(String objectName, String recordType, Map<String, Object> specificSimpleValueMap, Map<String, SObject> specificExternalObjectValueMap, List<String> randomValueList, List<String> cascadeFieldList) { 
    
    Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe(); 
    
    Schema.sObjectType objectType = globalDescribe.get(objectName);
    if (objectType == null) {throw new UnsupportedTypeException('Unsupported ObjectType ' + objectType);}
    
    SObject obj = Schema.getGlobalDescribe().get(objectName).newSObject();

    if(recordtype != null) {
        try{
            obj.put('RecordTypeId', objectType.getDescribe().getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId());
        } catch(Exception e){
            throw new UnsupportedTypeException('Unsupported RecordType DeveloperName ' + recordType);
        }
        
    } else {
        String defaultRT =  getDefaultRecordTypeId(objectName); 
        if(defaultRT != null) {
            obj.put('RecordTypeId',defaultRT);
        }
    }

    Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

    if(randomValueList != null) {
        for(String fieldName : randomValueList) {
            Schema.DescribeFieldResult  fieldDisc = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
             if(fieldDisc.getType() != Schema.DisplayType.REFERENCE) {
                 obj.put(fieldName, setDynamicField(objectName, fieldName));
             }
        }
    }
    
    if(specificSimpleValueMap != null) {
        for(String fieldName : specificSimpleValueMap.keySet()) {
            obj.put(fieldName, specificSimpleValueMap.get(fieldName));
        }
    }

    if(specificExternalObjectValueMap != null) {
        for(String fieldName : specificExternalObjectValueMap.keySet()) {
            obj.putSObject(fieldName, specificExternalObjectValueMap.get(fieldName));
        }
    }

    if(cascadeFieldList != null) {
        for(String fieldName : cascadeFieldList) {
            Schema.DescribeFieldResult  fieldDisc = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
            if(fieldDisc.getType() == Schema.DisplayType.REFERENCE && obj.get(fieldName) == null) {
                 obj.put(fieldName, setDynamicField(objectName, fieldName));
            }
        }
    }

    for(String fieldName : fieldMap.keySet()) {
         Schema.DescribeFieldResult F = fieldMap.get(fieldName).getDescribe();
         if(!F.isNillable() && F.isAccessible() && F.isUpdateable() && fieldName.toLowerCase() != 'ownerid' && obj.get(fieldName) == null) {
             //hardcoded exclusion
             if(fieldName == 'BusinessHoursId'){
                continue;
             }
             try{
                obj.put(fieldName, setDynamicField(objectName, fieldName));
             } catch(SObjectException e) {
                 System.debug('@@ Worning field not editable ' + objectName + ' => ' + fieldName);
             }
             
         }
    }

    return obj;
  }

    /** 
    * @author Slimene Belhaj Ali
    * @date 17/12/2019 
    * @description Methode permet recuperer de default record type
    * @param objectName, le apiName de l'object qu'on veut recuperer le default recordtype
    */
   public static String getDefaultRecordTypeId(String objectName) {
    List<Schema.RecordTypeInfo> recordTypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos();
    
    if (recordTypes.size() > 1) { // all objects have default Master type
      
      for (Schema.RecordTypeInfo recordType : recordTypes) {
        
        if (recordType.isAvailable() && recordType.isDefaultRecordTypeMapping()) {
           return recordType.getRecordTypeId();
        }
      }
    }
    return null;
    
  }
/** 
    * @author Slimene Belhaj Ali
    * @date 17/12/2019 
    * @description Methode permet recuperer de default picklist value
    * @param objectName, le apiName de l'object
    * @param fieldName, le apiName du champs Picklist qu'on veut recuperer le default value
    */
private static String getDefaultPicklistValue(String objectName, String fieldName) {
    String defaultVal;
    Schema.DescribeFieldResult F = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
    List <Schema.PicklistEntry> pickVals = F.getPicklistValues();        
    for (Schema.PicklistEntry pv: pickVals) {
        if (pv.isDefaultValue()) {
            return pv.getValue();
        }    
    }
    if(pickVals.size() > 0) {
        return pickVals.get(0).getValue();
    }
    return null;
}
    /** 
    * @author Slimene Belhaj Ali
    * @date 17/12/2019 
    * @description Methode permet generer une valeur selon un type données
    * @param objectName, le apiName de l'object
    * @param fieldName, le apiName de du champ
    */
  private static Object setDynamicField(String objectName, String fieldName) {
        Schema.DescribeFieldResult fieldDisc = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        Schema.DisplayType currentType = fieldDisc.getType();

        if(currentType == Schema.DisplayType.STRING 
            ||  currentType == Schema.DisplayType.URL || currentType == Schema.DisplayType.PHONE){
            return 'StringTest';
        }

        if(currentType == Schema.DisplayType.EMAIL){
            return 'test@test.com';
        }

        if(currentType == Schema.DisplayType.PICKLIST){
            return getDefaultPicklistValue(objectName, fieldName);  
        }

        if(currentType == Schema.DisplayType.INTEGER){
            return INTEGER.valueOf(10);  
        }

        if(currentType == Schema.DisplayType.Date){
            return Date.newInstance(2020, 01, 01);
        }

        if(currentType == Schema.DisplayType.DateTime){
            return DateTime.newInstance(2020, 01, 01);
        }
        
        if(currentType == Schema.DisplayType.BOOLEAN){
            return false;
        }
        if(currentType == Schema.DisplayType.CURRENCY){
            return Decimal.valueOf(10);
        }

        if(currentType == Schema.DisplayType.REFERENCE){
            SObject refSObject = createSObject(fieldDisc.getReferenceTo().get(0).getDescribe().getName());
            insert refSObject;
            return refSObject.Id;
        }
        if(currentType == Schema.DisplayType.DOUBLE || currentType == Schema.DisplayType.PERCENT || currentType == Schema.DisplayType.LONG){
            return Double.valueOf(10);
        }

        return null;
  }

    public static User insertUserHP(){
        
        User u = new User(Alias = 'sys', 
            			  Email='sysAdminHP@test.com',
                          EmailEncodingKey='UTF-8',
                          LanguageLocaleKey='en_US',
                          LastName='Testing',
                          LocaleSidKey='en_US',
                          ProfileId = [SELECT Id FROM Profile WHERE Name = 'HP_SystemAdmin'].Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='sysAdminHP@test.com',
                          UserPermissionsKnowledgeUser = true,
                          UserRoleId =[SELECT Id FROM UserRole WHERE DeveloperName = 'HP_HAPPE'].Id);      
        insert u;
        return u;        
    }
    
    public static User runAsUserHP(){
        return [SELECT Id FROM User WHERE UserName='sysAdminHP@test.com'];       
    }
}