/**
 * @File Name          : HP_WS004_IndexUpdate_TEST.cls
 * @Description        : Test class for update index
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 15/04/2020 à 11:22:29
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    15/04/2020   Sara El-Hannaoui     Initial Version
**/

@isTest
public with sharing class HP_WS004_IndexUpdate_TEST {
    
    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Souscription_Digital_Id__c'  => '123456'
                }, null);
            insert enrolment;
            
            HP_Contrat__c acontrat = (HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 'HP_Contrat_XdataId__c' => 123,
            'HP_Souscription_Digital_Id__c' => 123+'ELEC',
            'HP_Proposition_Commerciale_XdataId__c'=>'12345',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'ELEC'
        }, null);
            insert acontrat;
            
            final Id prestationRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_PrestationDistributeur');
            Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case',null,new  Map<String, Object> {
            'RecordTypeId' => prestationRecordTypeId,
            'HP_Contrat__c'=> acontrat.Id}, null,null,null);
            insert aCase;
		} 
    }

    @isTest static void updateIndexOK(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP009_IndexUpdate.Request req = new HP_WRP009_IndexUpdate.Request();
            req.xDataContractId = 123;
            req.energie = 'electricite';
            req.indexElec = 12;
            req.indexElecHC = 11;
    
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
    
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS004_IndexUpdate.setIndex();
            Test.stopTest();
            System.assertEquals(200,resHttp.statusCode, 'SUCCESS index HP et HC updated.');
        }
    }
     
    @isTest static void updateIndexPreconditionFailed(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP009_IndexUpdate.Request req = new HP_WRP009_IndexUpdate.Request();
            req.xDataContractId= null;
            req.energie = 'electricite';
            req.indexElec = null;
            req.indexElecHC = null;
    
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
    
            reqHttp.requestBody =  Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS004_IndexUpdate.setIndex();
            Test.stopTest();
    
            System.assertEquals(400, resHttp.statusCode, 'SF Standard');
        }  
    } 
}