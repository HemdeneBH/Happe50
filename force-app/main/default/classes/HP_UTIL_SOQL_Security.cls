/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 01-26-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_UTIL_SOQL_Security {
    
    public static boolean isSafeField(String fieldName, String objName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if (myObj != null ) { 
            SObjectField myField = myObj.getDescribe().fields.getMap().get(fieldName);
            if(myField != null){
                return true;
            }else{
                return false; 
            } 
        }else{
            return false;
        }
    }

    public static boolean isSafeObject(String objName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if(myObj != null){
            return true;
        }else{
            return false;
        }  
    }

    public static boolean checkFields(String fields, String objName){
        List<String> fieldsList;
        if(fields != null){
            fieldsList = fields.split(',');
            if(fieldsList.size() > 0 && !fieldsList.isEmpty()){
                for(String field : fieldsList){
                    if(isSafeField(field.trim(),objName) == false){
                        return false;
                    }else{
                        continue;
                    }
                }
            } 
            return true;
        }else{
            return false;
        } 
    }
}