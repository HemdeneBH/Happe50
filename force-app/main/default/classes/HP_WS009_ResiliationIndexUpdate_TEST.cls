/**
 * @File Name          : HP_WS009_ResiliationIndexUpdate_TEST.cls
 * @Description        : Class test for resiliation index
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 15/04/2020 à 11:22:38
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/04/2020   Sara El-Hannaoui     Initial Version
**/

@isTest
public with sharing class HP_WS009_ResiliationIndexUpdate_TEST {

    @testSetup static void initData() {
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){      
            HP_Contrat__c acontrat = (HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', null,new Map<String, Object> {'HP_Contrat_XdataId__c'=>123},null, null, null);
            insert acontrat;
    
            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('HP_ContractCancelationCase').getRecordTypeId();
            Case acase=(Case)HP_UTIL_SmartFactory.createSObject('Case', null,new Map<String, Object> {'HP_Contrat__c'=>acontrat.Id, 'RecordTypeId' =>caseRecordTypeId},null, null,null);
            insert acase;    
        } 
    }

    @isTest
    public static void updateIndexOK() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP009_IndexUpdate.Request req = new HP_WRP009_IndexUpdate.Request();
            req.xDataContractId=123;
            req.energie = 'electricite';
            req.indexElec = 12;
            req.indexElecHC = 11;
    
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            RestContext.request = reqHttp;
            RestContext.response= resHttp;
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            
            Test.startTest();
            HP_WS009_ResiliationIndexUpdate.setIndex();
            Test.stopTest();
            System.assertEquals(200, resHttp.statusCode , 'SUCCESS index case resiliation updated.');
        }
    }

    @isTest
    public static void updateIndexPreconditionFailed() {
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP009_IndexUpdate.Request req = new HP_WRP009_IndexUpdate.Request();
            req.xDataContractId=124;
            req.energie = 'gaz';
            req.indexGaz = null;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            RestContext.request = reqHttp;
            RestContext.response= resHttp;
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            
            Test.startTest();
            HP_WS009_ResiliationIndexUpdate.setIndex();
            Test.stopTest();
            System.assertEquals (400, resHttp.statusCode , 'SF Standard');
        }
    }
}