/**
 * @File Name          : HP_WS010_Case_TEST.cls
 * @Description        : Test class for WS caseCreation
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 03-03-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/04/2020   Sara El-Hannaoui     Initial Version
**/
@isTest
public with sharing class HP_WS010_Case_TEST {

    @testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object>{
                'LastName' => 'Test Lastname',
                'Email' => 'test@gmail.com',
                'Id_Tiers__c' => 195464
            }, null, null, null);
            insert contact;

            HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                'HP_Contact__c' => contact.id,
                'Xdata_Id__c' => '1222',
                'HP_Souscription_Digital_Id__c'=>'testGazElec-01'
            }, null, null, null);
            insert porteFeuille;

            HP_Contrat__c celec =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '423',
                'HP_Id_Compteur__c' => '25461794460830',
                'HP_Contrat_XdataId__c' => 282713,
                'HP_Souscription_Digital_Id__c' => 'testGazElec-01ELEC',
                'HP_Type_de_Compteur__c' => 'ELEC'
            }, null);
            insert celec;
        }
    }

    @isTest static void caseCreationOK_CaseOffline(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.contactInfo = new HP_WRP034_Case.ContactInfo ();
            req.contactInfo.email = 'test@gmail.com';
            req.contactInfo.firstname = 'test firstname';
            req.contactInfo.lastname = 'test lastname';
            req.context = 'Case offline';
            req.description = 'test description' ;
    
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
    
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
            System.assertEquals(1,[SELECT count() FROM Case], 'SUCCESS case inserted');
        }
    }

    @isTest static void caseCreationOK_Consentement(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.contactInfo = new HP_WRP034_Case.ContactInfo ();
            req.context = 'Consentement';
            req.description = 'test description' ;
            req.contactInfo.xdataId = 195464;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
    
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
            System.assertEquals(1,[SELECT count() FROM Case], 'SUCCESS case inserted');
        }
    }
     
    @isTest static void caseCreationPreconditionFailed(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.context = 'Case offline';
            req.contactInfo = new HP_WRP034_Case.ContactInfo ();
    
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
    
            reqHttp.requestBody =  Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
    
            System.assertEquals(400, resHttp.statusCode, 'Precondition Failed');
        }
    }

    @isTest static void caseCreationOK_CoupureReductionPuissance(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.context = 'Coupure_ReductionPuissance';
            req.porteFeuilleContratXdataId = 1222;
            req.contratXdataId = 282713;
            req.energie = 'Electricity';
            req.pdl = '25461794460830';
            req.contactInfo = new HP_WRP034_Case.ContactInfo();
            req.contactInfo.xdataId = 195464;
            req.contactInfo.clientAide = true;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
            System.assertEquals(1,[SELECT count() FROM Case], 'SUCCESS case inserted');
        }
    }

}