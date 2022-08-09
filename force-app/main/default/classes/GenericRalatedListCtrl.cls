/**
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Name			GenericRalatedListDisplayCtr	
* @Author		Slimene BELHAJ ALI
* @Version		v1.0
* @CreatedDate	17/06/2019
* @UsedBy		Lightning component GenericRelatedList
* @TestClass    GenericRalatedListDisplayCtr_Test	
* ---------------------------------------------------------------------------------------------------------------------------------------------------	
* @Description
* Generate data table with the columns
* ---------------------------------------------------------------------------------------------------------------------------------------------------	
**/
/*
Les inputs sont accessibles seulement pour les Admin à partir de l'interface App Builder
Suppression des warning PMD.ApexSOQLInjection pour cette raison
 */
@SuppressWarnings('PMD.ApexSOQLInjection')
public without sharing class GenericRalatedListCtrl {
    
    /**
	* @Method: loadDataFromConfig
	* @Description: This method load data and columns and data
	* @param fieldSetName: field Set Name
	* @param whereClause: wher eClause
	* @param objectName: object Name
	* @param parentName: parent Name
	* @param recordId: parent Id
	* @return Map: contains data and columns list
	*/
    
    @AuraEnabled 
    public static Map<String, Object> loadDataFromConfig(String fieldSetName, String typeFieldSource, String whereClause, String objectName, String parentName, String recordId, String importantField, String searchFilds,String operator,String pageSize, String pageNumber) {
        
		System.debug('CTS Variables ' + fieldSetName + ' ' + typeFieldSource + ' ' + whereClause + ' ' + objectName + ' ' + parentName + ' ' + recordId + ' ' + pageSize + ' ' + pageNumber);

		Map<String, Object> globalResult = new Map<String, Object>(); 

        Map<String, String> globalQuery = buildQuery(fieldSetName, typeFieldSource, whereClause, objectName, parentName, recordId, searchFilds, operator);

        //load data by generic query
        List<SObject> data = Database.query(globalQuery.get('query'));
        Integer count = Database.countQuery(globalQuery.get('countQuery'));

        List<SObject> resultData = new List<SObject>();
        if(importantField == null) {
            resultData = data;
        }
        else
        for(SObject item : data) {
            if(item.get(importantField) != null)
            resultData.add(item);
        }
        List<Id> dataIdList = extractIdFromSObject(data);
        globalResult.put('editAccess', loadPermissionRecord(dataIdList, 'HasEditAccess'));
        globalResult.put('deleteAccess', loadPermissionRecord(dataIdList, 'HasDeleteAccess'));
        globalResult.put('data', resultData);
        globalResult.put('count', count);
        //load columns
        globalResult.put('columns', getColumnsFormat(fieldSetName, typeFieldSource, ObjectName));
        //retun map data + column
        return globalResult;
    }
    
    
    /**
	* @Method: buildQuery
	* @Description: This method build query
	* @param fieldSetName: field Set Name
	* @param whereClause: wher eClause
	* @param objectName: object Name
	* @param parentName: parent Name
	* @param recordId: parent Id
	* @return String: return query
	*/
    private static Map<String, String> buildQuery(String fieldSetName, String typeFieldSource, String whereClause, String objectName, String parentName, String recordId, String searchFilds,String operator){
        
        Map<String, String> globalQuery = new Map<String, String>(); 

        String query = '';
        String countQuery = '';
        String[] souscriptionSearchFileds =  splitString(searchFilds,',');
        if(HP_UTIL_SOQL_Security.isSafeObject(objectName) ){
            if(searchFilds != null  && whereClause !=null){
                if(HP_UTIL_SOQL_Security.checkFields(searchFilds,objectName)){
                    String customWhereQuery = '';
                    String queryPart ='';
                    searchFilds= searchFilds.replaceAll( '\\s+', '');
                    String objectQuery = 'select '+ searchFilds  +' from  ' + objectName + ' where (' + String.escapeSingleQuotes(parentName) + ' =  :recordId )';
                    SObject data = Database.query(objectQuery);
                    Map<String,String> fieldValueMap = new  Map<String,String>();
                    for (String item : souscriptionSearchFileds) {
                        // champ texte only
                        fieldValueMap.put(item, (String) data.get(item)); 
                    }
                    
                    System.debug('@@@ fieldValueMap ' +fieldValueMap);
    
                    if(data != null && souscriptionSearchFileds != null)  {
                        
                        if(souscriptionSearchFileds.size () > 1){
                                //get the key,value from the current object
                            for (String item : souscriptionSearchFileds) {
                            queryPart = queryPart + item +' =\''+  (String) data.get(item) + '\' '+ operator +' ';
                            }
                            queryPart = queryPart.removeEnd(operator+' ');
                        }else {
                            queryPart =  searchFilds +' =\''+  (String) data.get(searchFilds) + '\' ';
                        }
                        
                        customWhereQuery = '( '+ queryPart+ ' )  AND ( '+ whereClause +' )';
                        String excludeCurrentId = 'ID !=\'' + recordId +  '\'';
                        query = 'select ' + readFieldSet(fieldSetName,typeFieldSource, objectName) + ' from  ' + objectName + ' where (' + customWhereQuery + ' AND ' + excludeCurrentId +')';
                        countQuery = 'select count() from  ' + objectName + ' where (' + customWhereQuery + ' AND ' + excludeCurrentId +')';
                    }
                } 
            }else{
                query = 'select ' + readFieldSet(fieldSetName,typeFieldSource, objectName) + ' from  ' + objectName + ' where '+((whereClause == null ||  whereClause.trim() == '' )? '' : ('(' + whereClause + ') and ')) + String.escapeSingleQuotes(parentName) + ' = :recordId ';
                countQuery = 'select count() from  ' + objectName + ' where '+((whereClause == null ||  whereClause.trim() == '' )? '' : ('(' + whereClause + ') and ')) + String.escapeSingleQuotes(parentName) + ' = :recordId ';
            }
        }
		System.debug('@@@ Query ' + query);
        System.debug('@@@ CountQuery ' + countQuery);

        globalQuery.put('query', query);
        globalQuery.put('countQuery', countQuery);

    	return globalQuery;
    }
    
    
    /**
	* @Method: readFieldSet
	* @Description: This method read field set
	* @param fieldSetName: field Set Name
	* @param ObjectName: Object Name
	* @return String: return fild list
	*/
    private static String readFieldSet(String fieldSetName,String typeFieldSource, String ObjectName) {
        String resultField = '';
        //load all SObject fields
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap();
         if(typeFieldSource == 'Field Set') {
        //load all field set members by object name and field set name
            for(Schema.FieldSetMember item : Schema.getGlobalDescribe().get(ObjectName).getDescribe().FieldSets.getMap().get(fieldSetName).getFields()) {
                //if field is a relationsip field
                if(fieldMap.get(item.getFieldPath()).getDescribe().getRelationshipName() != null) {
                    //load relationship name
                    resultField +=fieldMap.get(item.getFieldPath()).getDescribe().getRelationshipName() + '.Name,';
                    continue;
                }
                //Load field set member
                resultField +=item.getFieldPath() + ',';
            }
         }else {
         	fieldMap = toLowerCaseMapFields(fieldMap);
            for(String item : fieldSetName.split(',')){
            	item = item.trim().toLowerCase();
            	System.debug('@@ item ' + item);


                 if(fieldMap.get(item.replace('tolabel(', '').replace(')','')).getDescribe().getRelationshipName() != null) {
                    //load relationship name
                    resultField +=fieldMap.get(item.replace('tolabel(', '').replace(')','')).getDescribe().getRelationshipName() + '.Name,';


                    continue;
                }
                //Load field set member
                resultField +=item + ',';
            }
        }
        return resultField.removeEnd(',');
    } 
    
    /**
	* @Method: getColumnsFormat
	* @Description: This method generate columns list
	* @param fieldSetName: field Set Name
	* @param ObjectName: Object Name
	* @return String: return column list
	*/
    private static List<ColumnWrapper> getColumnsFormat(String fieldSetName, String typeFieldSource, String ObjectName) {
        List<ColumnWrapper> columnList = new List<ColumnWrapper>();
        //load all SObject fields
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap();
       
        if(typeFieldSource == 'Field Set') {
            //load all field set members by object name and field set name
            for(Schema.FieldSetMember item : Schema.getGlobalDescribe().get(ObjectName).getDescribe().FieldSets.getMap().get(fieldSetName).getFields()) {
                //build columnWrapper and add if in result value
                columnList.add(new ColumnWrapper(item.getLabel(), item.getFieldPath(), getType(item.getType()), fieldMap.get(item.getFieldPath()).getDescribe()));
            }
        } else {
        	fieldMap = toLowerCaseMapFields(fieldMap);
            for(String item : fieldSetName.split(',')){


            	item = item.trim().toLowerCase().replace('tolabel(', '').replace(')','');


                Schema.DescribeFieldResult currentDesc = fieldMap.get(item).getDescribe();
                 columnList.add(new ColumnWrapper(currentDesc.getLabel(), currentDesc.getName(),getType(currentDesc.getType()),currentDesc));
            }
        }
       
        return columnList;
    }
    
    private static Map<String, Schema.SObjectField> toLowerCaseMapFields(Map<String, Schema.SObjectField> mapField){
    	Map<String, Schema.SObjectField> result = new Map<String, Schema.SObjectField>();
    	
    	for(String key : mapField.KeySet()) {
    		result.put(key.toLowerCase(), mapField.get(key));
    	}
    	return result;
    }
    
    /**
	* @Method: getType
	* @Description: This method return string type
	* @param fielddataType: display type
	* @return String: retun string type
	*/
    private static String getType(schema.displaytype fielddataType) {
        //test if filed is number
        if(fielddataType == Schema.DisplayType.Integer || fielddataType == Schema.DisplayType.Double || fielddataType == Schema.DisplayType.Percent) {
            return 'number';
        }
        //test if filed is data or data type
        if(fielddataType == Schema.DisplayType.Date) {
            return 'date';
        }

        if(fielddataType == Schema.DisplayType.DateTime) {
            return 'datetime';
        }
         //test if filed is boolean
        if(fielddataType == Schema.DisplayType.Boolean) {
            return 'boolean';
        }
		//test if filed is currency
        if(fielddataType == Schema.DisplayType.Currency) {
            return 'currency';
        }
        
        return 'text';
    }
    
    /**
	* @Method: loadPermissionRecord
	* @Description: This method return permission for current user
	* @param recordIdList: record Id List
	* @param permissionField: permission edit or delete
	* @return List<Id>: retun list Id for records that we have access
	*/
    private static List<Id> loadPermissionRecord(List<Id> recordIdList, String permissionField) {
    	
        return new  List<Id>();
    }
  
    private static String buildQueryPermission(String permissionField) {
        return 'SELECT RecordId FROM UserRecordAccess WHERE UserId= :userId AND '+String.escapeSingleQuotes(permissionField)+' = true AND RecordId IN :recordIdList LIMIT 200';
    }
    /**
	* @Method: extractIdFromSObject
	* @Description: This method extract list Id from objectList
	* @param sobjectList: list sobject
	* @return List<Id>: retun list Id for records
	*/
    private static List<Id> extractIdFromSObject(List<SObject> sobjectList) {
        List<Id> listId = new List<Id>();
        if(sobjectList == null ||sobjectList.size() == 0) {
            return listId;
        }
        
        for(SObject item : sobjectList) {
            listId.add(item.Id);
        }
        
        return listId;
    }
    
    /**
	* @Method: deleteRecord
	* @Description: This method delete record
	* @param recordId: record Id
	* @param objectName: object name
	*/
    @AuraEnabled 
    public static void deleteRecord(String recordId, String objectName) {
        
    	SObject currentObject = Database.query(buildQueryDelete(objectName));

		if(objectName=='AccountPartner'){
            currentObject = [SELECT Id from Partner WHERE Id = :recordId];
        }
        Schema.DescribeSObjectResult r = Schema.getGlobalDescribe().get(ObjectName).getDescribe();
        if (r.isDeletable()) {
            delete currentObject;
        }
    }
    
    private static String buildQueryDelete(String objectName) {
        if(HP_UTIL_SOQL_Security.isSafeObject(objectName)){
            return 'select Id from ' + objectName + ' where Id = :recordId';
        }else{
            return null;
        }
    }
    /**
	* @Class: ColumnWrapper
	* @Description: This class contain all infromations about column (label, type, filedName...)
	*/
    public class ColumnWrapper {
        @AuraEnabled  
        public String label {get;set;}
        @AuraEnabled 
        public String fieldName {get;set;}
        @AuraEnabled 
        public String type {get;set;}
        @AuraEnabled 
        public Boolean sortable {get;set;}
        @AuraEnabled
        public Map<String, Object> typeAttributes {get;set;}
        /**
	* @Constructor: ColumnWrapper
	* @Description: This Constructor initialize data.
	* @param label: label
	* @param fieldName:fiel dName
	* @param type: type
	* @param fieldDescription: field Description
	*/
        public ColumnWrapper(String label, String fieldName, String type, Schema.DescribeFieldResult fieldDescription) {
           //init data
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
            this.sortable = true;
            typeAttributes = new Map<String, Object>();
            //if field is a relationsip field
            if(fieldDescription.getRelationshipName() != null) {
                //change label field
                this.label = fieldDescription.getLabel().replace(' ID', '');
       
                //change field name 
                this.fieldName = fieldDescription.getRelationshipName() + 'Name';
                this.type = 'url';
                Map<String, String> labels = new Map<String, String>();
                labels.put('fieldName',  this.fieldName + 'Label');
                typeAttributes.put('label', labels);
                
            }
             	
            //if type is currency
            if(type == 'currency') {
              
                //set static currency
                typeAttributes.put('currencyCode','EUR');
            }
        }
    }


    /**
    * @description 
    * @author Ali AJELLAL | 11-16-2020 
    * @param str 
    * @param separator 
    * @return String[] 
    **/
    private static String[] splitString(String str, String separator) {
		if(str != null){
            str= str.replaceAll( '\\s+', '');
            return str.split(separator);
        }
        return null;
	}
}