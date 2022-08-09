/**
 * @File Name          : HP_WS010_Case_TEST.cls
 * @Description        : Test class for WS caseCreation
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 03-07-2022
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
                'HP_Id_Compteur__c' => '12',
                'HP_Contrat_XdataId__c' => 282713,
                'HP_Souscription_Digital_Id__c' => 'testGazElec-01ELEC',
                'HP_Type_de_Compteur__c' => 'ELEC'
            }, null);
            insert celec;

            HP_Contrat__c cgaz =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '324',
                'HP_Id_Compteur__c' => '13',
                'HP_Contrat_XdataId__c' => 282714,
                'HP_Souscription_Digital_Id__c' => 'testGazElec-01GAS',
                'HP_Type_de_Compteur__c' => 'GAS'
            }, null);
            insert cgaz;

            HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Souscription_Digital_Id__c'  => '123456',
                'HP_Date_de_Contractualisation__c' => System.today().addDays(1),
                'HP_Statut__c' =>'SAVE_3',
                'HP_Contact__c'=> contact.Id
            }, null);
            insert enrolment;

            Case caseElec = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                'Status' => HP_SLCT_Case.Status.HP_PENDING.name(),
                'HP_Contrat__c' => celec.id,
                'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case','HP_Facturation'),
                'HP_Type__c' => 'HP_Coupure_ReductionPuissance',
                'Status' => 'NEW_CASE',
                'OwnerId' => HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1'),
                'ContactId' => contact.Id,
                'Portefeuille_Contrat_Happe__c' => porteFeuille.Id,
                'Origin' => 'HP_BILLING',
                'HP_Energy__c' => 'Electricity'
            }, null);
            insert caseElec;

            Case caseGas = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                'Status' => HP_SLCT_Case.Status.HP_PENDING.name(),
                'HP_Contrat__c' => cgaz.id,
                'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case','HP_Facturation'),
                'HP_Type__c' => 'HP_Coupure_ReductionPuissance',
                'Status' => 'NEW_CASE',
                'OwnerId' => HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1'),
                'ContactId' => contact.Id,
                'Portefeuille_Contrat_Happe__c' => porteFeuille.Id,
                'Origin' => 'HP_BILLING',
                'HP_Energy__c' => 'Gas'
            }, null);
            insert caseGas;

            Prestation_distributeur__c prestationForElec = (Prestation_distributeur__c) HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c','HP_PrestationDistributeur', 
            new Map<String, Object>{
                'Statut__c' => 'En cours',
                'Numero_affaire_distributeur__c' => 'A1234567',
                'Numero_PDL_PCE__c' => '12',
                'Contact__c' => contact.Id,
                'HP_Contrat__c' => celec.Id,
                'Case__c' => caseElec.Id,
                'HP_Effective_Date__c' => Date.newInstance(2021, 09, 22)}, null, null, null);
            insert prestationForElec;

            Prestation_distributeur__c prestationForGas = (Prestation_distributeur__c) HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c','HP_PrestationDistributeur', 
            new Map<String, Object>{
                'Statut__c' => 'En cours',
                'Numero_affaire_distributeur__c' => 'A1234568',
                'Numero_PDL_PCE__c' => '13',
                'Contact__c' => contact.Id,
                'HP_Contrat__c' => celec.Id,
                'Case__c' => caseGas.Id,
                'HP_Effective_Date__c' => Date.newInstance(2021, 09, 22)}, null, null, null);
            insert prestationForGas;
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

            Id recordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_CaseRecontact');
            System.assertEquals(1,[SELECT count() FROM Case WHERE recordTypeId=:recordTypeId], 'SUCCESS case inserted');
        }
    }

    @isTest static void anomalieCreationOK_CaseOffline(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.contactInfo = new HP_WRP034_Case.ContactInfo ();
            req.contactInfo.email = 'test@gmail.com';
            req.contactInfo.firstname = 'test firstname';
            req.contactInfo.lastname = 'test lastname';
            req.contactInfo.xdataId = 195464;
            req.context = 'Anomalie creation xdata Save2';
            req.description = 'test description' ;
            req.selfcareId = '123456';    
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
    
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
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
            Id recordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractErrorSave3');
            System.assertEquals(1,[SELECT count() FROM Case WHERE recordTypeId=:recordTypeId], 'SUCCESS case inserted');
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
            req.pdl = '12';
            req.contactInfo = new HP_WRP034_Case.ContactInfo();
            req.contactInfo.xdataId = 195464;
            req.contactInfo.clientAide = false;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
            Id recordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Facturation');
            System.assertEquals(3,[SELECT count() FROM Case WHERE recordTypeId=:recordTypeId], 'SUCCESS case inserted');
        }
    }

    @isTest static void caseElectricityTraitementMAJCoupure_ETAT1_OK(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.context = 'MAJCoupure_ReductionPuissance';
            req.porteFeuilleContratXdataId = 1222;
            req.contratXdataId = 282713;
            req.energie = 'Electricity';
            req.pdl = '12';
            req.etat = 1;
            
            req.numeroAffaire = 'A1234567';
            req.objectCode = 'SAI';
            req.motifNonRealisationCode = 'motifNonRealisationCode';
            req.motifCode = 'motifCode';
            req.attestationPaiement = true;
            req.remiseChq = true;

            req.contactInfo = new HP_WRP034_Case.ContactInfo();
            req.contactInfo.xdataId = 195464;
            req.contactInfo.clientAide = false;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
        }
    }

    @isTest static void caseGasTraitementMAJCoupure_ETAT1_OK(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.context = 'MAJCoupure_ReductionPuissance';
            req.porteFeuilleContratXdataId = 1222;
            req.contratXdataId = 282713;
            req.energie = 'Gas';
            req.pdl = '13';
            req.etat = 1;
            
            req.numeroAffaire = 'A1234568';
            req.motifNonRealisationCode = 'motifNonRealisationCode';
            req.motifCode = 'motifCode';
            req.attestationPaiement = false;
            req.remiseChq = false;

            req.contactInfo = new HP_WRP034_Case.ContactInfo();
            req.contactInfo.xdataId = 195464;
            req.contactInfo.clientAide = false;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
        }
    }

    @isTest static void caseElectricityTraitementMAJCoupure_ETAT2_OK(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.context = 'MAJCoupure_ReductionPuissance';
            req.porteFeuilleContratXdataId = 1222;
            req.contratXdataId = 282713;
            req.energie = 'Electricity';
            req.pdl = '12';
            req.etat = 2;
            
            req.numeroAffaire = 'A1234567';
            req.objectCode = 'SAI';
            req.motifNonRealisationCode = 'motifNonRealisationCode';
            req.motifCode = 'motifCode';
            req.attestationPaiement = true;
            req.remiseChq = true;

            req.contactInfo = new HP_WRP034_Case.ContactInfo();
            req.contactInfo.xdataId = 195464;
            req.contactInfo.clientAide = false;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
        }
    }

    @isTest static void caseElectricityTraitementMAJCoupure_ETAT3_OK(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.context = 'MAJCoupure_ReductionPuissance';
            req.porteFeuilleContratXdataId = 1222;
            req.contratXdataId = 282713;
            req.energie = 'Electricity';
            req.pdl = '12';
            req.etat = 3;
            
            req.numeroAffaire = 'A1234567';
            req.objectCode = 'SAI';
            req.motifNonRealisationCode = 'motifNonRealisationCode';
            req.motifCode = 'motifCode';
            req.attestationPaiement = true;
            req.remiseChq = true;

            req.contactInfo = new HP_WRP034_Case.ContactInfo();
            req.contactInfo.xdataId = 195464;
            req.contactInfo.clientAide = false;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
        }
    }

    @isTest static void caseElectricityTraitementMAJCoupure_ETAT4_OK(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
            req.context = 'MAJCoupure_ReductionPuissance';
            req.porteFeuilleContratXdataId = 1222;
            req.contratXdataId = 282713;
            req.energie = 'Electricity';
            req.pdl = '12';
            req.etat = 4;
            
            req.numeroAffaire = 'A1234567';
            req.objectCode = 'SAI';
            req.motifNonRealisationCode = 'motifNonRealisationCode';
            req.motifCode = 'motifCode';
            req.attestationPaiement = true;
            req.remiseChq = true;

            req.contactInfo = new HP_WRP034_Case.ContactInfo();
            req.contactInfo.xdataId = 195464;
            req.contactInfo.clientAide = false;
            
            RestRequest reqHttp = new RestRequest();
            RestResponse resHttp = new RestResponse();
            reqHttp.requestBody = Blob.valueof(JSON.serialize(req, false));
            RestContext.request = reqHttp;
            RestContext.response = resHttp;
    
            Test.startTest();
            HP_WS010_Case.caseCreation();
            Test.stopTest();
        }
    }

}