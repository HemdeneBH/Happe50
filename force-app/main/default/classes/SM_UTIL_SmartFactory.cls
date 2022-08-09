/**
 * @description       : Generic Test Data Factory
 * @author            : Amar KAILLO
 * @group             : 
 * @last modified on  : 10-26-2020
 * @last modified by  : David ATTALI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-02-2020   Amar KAILLO      Initial Version
 * 1.1   10-26-2020   David ATTALI     Method createSObjects added
**/

@isTest
public with sharing class SM_UTIL_SmartFactory {
	
  //custom exception 
  public class UnsupportedTypeException extends Exception {}
  
   /** 
   * @author Amar KAILLO 
	* @date 02/10/2020
    * @description Methode permet de créer un record
    * @param objectName, le apiName de l'object
    */
  public static SObject createSObject(string objectName) {
      return createSObject(objectName, null, null, Null, null, null);
  }

 /** 
     * @author Amar KAILLO 
	* @date 02/10/2020
    * @description Methode permet de créer un record
    * @param objectName, le apiName de l'object
    * @param specificValueMap, Map qui contient les champs qu'il faut les rensegnier avec les valeurs
    */
  public static SObject createSObject(string objectName, Map<String, Object> specificSimpleValueMap, Map<String, SObject> specificExternalObjectValueMap) {
      return createSObject(objectName, null, specificSimpleValueMap, specificExternalObjectValueMap, null, null);
  }
    
    /** 
	* @author David ATTALI 
	* @date 26/10/2020
    * @description Méthode qui permet de créer une liste d'enregistrement
    * @param String objectName, Nom API de l'objet
    * @param String recordType, Type d'enregistrement de l'objet
    * @param Map<String, Object> specificValueMap, Map [API du champ:Valeur] utilisée afin d'alimenter des champs spécifiques de l'objet
    * @param Integer n, Nombre d'enregistrements à créer
    * @return List<SObject> Liste des enregistrements créés
    */
  public static List<SObject> createSObjects(String objectName, String recordType, Map<String, Object> specificSimpleValueMap, Integer n) {
      
      List<SObject> sobjects = new List<SObject>();
      
      if(n > 1){
          
          SObject createdSObject = createSObject(objectName, recordType, specificSimpleValueMap, null, null, null);
          sobjects.add(createdSObject);
          
          for(Integer i = 1; i < n ; i++){ // Integer = 1 car un objet a déjà été créé
              SObject clonedSObject = createdSObject.clone(false, true, false, false);
              sobjects.add(clonedSObject);
          }
      } else {
          throw new IllegalArgumentException('Le paramètre n doit être supérieur à 1');
      }
      
      return sobjects;
  }

  /** 
     * @author Amar KAILLO 
	* @date 02/10/2020
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
    * @author Amar KAILLO 
	* @date 02/10/2020 
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
     * @author Amar KAILLO 
	* @date 02/10/2020
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
     * @author Amar KAILLO 
	* @date 02/10/2020
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

}