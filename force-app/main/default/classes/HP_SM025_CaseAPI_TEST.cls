/**
 * @File Name          : HP_SM025_CaseAPI_TEST.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 02-19-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/08/2020   Antoine Latour     Initial Version
**/
@isTest
public with sharing class HP_SM025_CaseAPI_TEST {

    @testSetup static void dataSetup() {
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            'FirstName' => 'Contact FirstName',
            'LastName' => 'Contact Test',
            'Email' => 'test@gmail.com',
            'Id_Tiers__c' => 1313
        }, null, null,null);
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

        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
            'HP_Contact__c'=> contact.Id,
            'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
            'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
            'HP_Code_postal__c'  => '92160',
            'HP_code_Postal_Insee__c'  => '92002',
            'HP_Date_de_Contractualisation__c'  => System.today().addDays(1),
            'HP_Date_Origine__c'  =>DateTime.newInstance(2019, 10, 9, 13, 0, 0),
            'HP_Energie_Verte__c'  => false,
            'HP_Estimation_Consommation_electrique__c'  => 6000,
            'HP_Estimation_Consommation_gaz__c'  => 13000,
            'HP_Jour_de_facturation__c' => 16,
            'HP_Lien_enregistrement__c' =>'test.fr',
            'HP_Methode_de_paiement__c' =>'BANK_CARD',
            'HP_Montant_de_la_facturation_electrique__c' =>58,
            'HP_Montant_de_la_facturation_gaz__c' =>120,
            'HP_Predecesseur__c' =>'Dupont',
            'HP_Nom_de_rue__c' =>'rue des bois',
            'HP_Nom_de_ville__c' =>'ANTONY',
            'HP_Numero_de_voie__c' =>'15 ter',
            'HP_Periode_de_facturation__c' =>'BIMONTHLY',
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_Puissance_Compteur_electrique__c' =>6,
            'HP_Souscription_Digital_Id__c' =>'test-creation-case',
            'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_NumPDL__c' =>'31431211214170',
            'HP_Statut__c' =>'SAVE_1',
            'OwnerId' => UserInfo.getUserId()
        }, null);
        insert enrolment;
    }

    @isTest static void caseCreationConsentements() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Consentement';
        req.description = 'TEST';
        contactInfo.email = 'test@gmail.com';
        contactInfo.lastname = 'Contact Test';
        contactInfo.xdataId = 1313;
        req.contactInfo = contactInfo; 

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-1', response.infos[0].code);
    }

    @isTest static void caseCreationAnomalieXDATA() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Anomalie creation xdata Save2';
        req.description = 'TEST';
        req.selfcareId = 'test-creation-case';
        contactInfo.xdataId = 1313;
        req.contactInfo = contactInfo; 

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-1', response.infos[0].code);
    }

    @isTest static void caseCreationCaseOffline() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context =  'Case offline';
        req.description = 'TEST';
       	contactInfo.email='test@gmail.com';
        contactInfo.firstname='Contact FirstName';
        contactInfo.lastname='Contact Test';
        req.contactInfo = contactInfo;

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-1', response.infos[0].code);
    }

    @isTest static void caseCreationInfosManquante() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        
        System.assertEquals('SM025-2', response.errors[0].code);
    }
    
    @isTest static void caseCreationInfosManquanteConsentement() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Consentement';
        req.description = 'TEST';
        contactInfo.email = 'test@gmail.com';
        contactInfo.lastname = 'Contact Test';
        req.contactInfo = contactInfo; 

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-8', response.errors[0].code);
    }
    
    @isTest static void caseCreationInfosErroneesConsentement() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Consentement';
        req.description = 'TEST';
        contactInfo.xdataId = -1;
        req.contactInfo = contactInfo; 

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-9', response.errors[0].code);
    }
    
    @isTest static void caseCreationInfosManquanteAnomalieXdata() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Anomalie creation xdata Save2';
        req.description = 'TEST';
        req.contactInfo = contactInfo; 

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-8', response.errors[0].code);
        System.assertEquals('SM025-11', response.errors[1].code);
    }
    
    @isTest static void caseCreationInfosErroneesAnomalieXdata() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Anomalie creation xdata Save2';
        req.description = 'TEST';
        req.selfcareId = 'unreal-selfcare-id-TU';
        contactInfo.xdataId = -1;
        req.contactInfo = contactInfo; 

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-9', response.errors[0].code);
        System.assertEquals('SM025-12', response.errors[1].code);
    }
    
    @isTest static void caseCreationInfosManquanteCaseOffline() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context =  'Case offline';
        req.description = 'TEST';
        req.contactInfo = contactInfo;

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-5', response.errors[0].code);
        System.assertEquals('SM025-6', response.errors[1].code);
        System.assertEquals('SM025-7', response.errors[2].code);
    }
    
     @isTest static void caseCreationContexteInconnu() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP034_Case.ContactInfo contactInfo = new HP_WRP034_Case.ContactInfo();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Unreal Case Context';
        req.description = 'TEST';
        req.contactInfo = contactInfo;

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-10', response.errors[0].code);
    }

    @isTest static void caseCreationCoupureReductionPuissance() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Coupure_ReductionPuissance';
        req.porteFeuilleContratXdataId = 1222;
        req.contratXdataId = 282713;
        req.energie = 'Electricity';
        req.pdl = '25461794460830';
        req.contactInfo = new HP_WRP034_Case.ContactInfo();
        req.contactInfo.xdataId = 1313;
        req.contactInfo.clientAide = false;

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-1', response.infos[0].code);
    }

    @isTest static void caseCreationInfosManquanteCoupureReductionPuissance() {
        HP_WRP034_Case.Request req = new HP_WRP034_Case.Request();
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        req.context = 'Coupure_ReductionPuissance';
        req.porteFeuilleContratXdataId = null;
        req.contratXdataId = null;
        req.energie = '';
        req.pdl = '';
        req.contactInfo = null;

        Test.startTest();
        HP_SM025_CaseAPI.caseCreation(req, response);
        Test.stopTest();
        System.assertEquals('SM025-14', response.errors[0].code);
    }
}