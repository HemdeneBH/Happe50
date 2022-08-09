/**
 * @File Name          : HP_SM025_CaseAPI_TEST.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 02-15-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/08/2020   Antoine Latour     Initial Version
**/
@isTest
public with sharing class HP_EM010_Case_TEST {

    @testSetup static void dataSetup() {
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            'FirstName' => 'Contact FirstName',
            'LastName' => 'Contact Test',
            'Email' => 'test@gmail.com',
            'Id_Tiers__c' => 1313
        }, null, null,null);
        insert contact;

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
        
        List<Case> caseList = new List<Case>();

        Case c = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
		'ContactId' => contact.Id,
		'Description' => 'Description Test',
		'Origin' => 'Web',
		'Reason' => 'HP_EnrolmentError',
		'Subject' => 'Erreur souscription : création PDL/coordonnéesBC dans Xdata',
		'HP_Type__c' => 'HP_XDATA_ANOMALIE',
		'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_EnrolmentCase'),
		'Status' => 'TO_DO',
        'HP_Souscription__c' => HP_EM005_Souscription.loadSouscriptionList(enrolment.HP_Souscription_Digital_Id__c)[0].Id}, null);
        caseList.add(c);
        
        Case c2 = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
		'Description' => 'Description Test',
		'Origin' => 'TEST',
		'Reason' => 'TEST',
		'Subject' => 'TEST',
		'HP_Type__c' => 'HP_Chat',
		'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Mail'),
		'Status' => 'TO_DO'}, null);
        caseList.add(c2);
        
        HP_Contrat__c contract =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
        new Map<String, Object>{ 
            'HP_Numero_reference_du_Compteur__c' => '423',
			'HP_Id_Compteur__c' => '31431211214068',
            'HP_Contrat_XdataId__c' => 100148,
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Type_de_Compteur__c' => 'GAS'
        }, null);
        insert contract;
        
        Contact contactBis = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
            'FirstName' => 'Contact FirstName2',
            'LastName' => 'Contact Test2',
            'Email' => 'test2@gmail.com',
            'Id_Tiers__c' => 1314
        }, null, null,null);
        insert contactBis;
        
        Case c3 = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
			'Description' => 'Description Test',
			'Origin' => 'TEST',
			'Reason' => 'TEST',
			'Subject' => 'TEST',
			'HP_Type__c' => 'HP_INFORMATION',
            'HP_Contrat__c' => contract.id,
			'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_PrestationDistributeur'),
			'Status' => 'NEW_CASE',
            'HP_Energy__c' => 'Gas',
            'ContactId' => contactBis.Id,
            'HP_index_gaz__c'=> 10,
            'HP_EffectiveDate__c' => date.today().addDays(1)}, null);
        caseList.add(c3);
        
        Case c4 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_ContractCancelationCase', new Map<String, Object> {
        'Status' => 'NEW_CASE',
        'HP_Contrat__c' => contract.id,
        'HP_Energy__c' => 'Electricity',
        'ContactId' => contactBis.Id,
        'HP_index_elec_hc__c' => 12345,
        'HP_index_elec_hp__c' =>  67890,
        'HP_index_gaz__c'=> 10,
        'HP_EffectiveDate__c' => date.today().addDays(1)}, null,null,null);
        caseList.add(c4);
        
        Case c5 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Telephone', new Map<String, Object> {
        'Status' => 'CLOSED',
        'HP_Contrat__c' => contract.id,
        'HP_Energy__c' => 'Electricity',
        'ContactId' => contactBis.Id,
        'HP_index_elec_hc__c' => 12345,
        'HP_index_elec_hp__c' =>  67890,
        'HP_index_gaz__c'=> 10,
        'HP_Type__c' => 'HP_Appel_Diabolocom',
        'HP_EffectiveDate__c' => date.today().addDays(1)}, null,null,null);
        caseList.add(c5);
        
        insert caseList;
    }

    @isTest static void createCaseFromAPICaseOffline() {
        Id contactId = null;
        String context = 'Case offline';
        String description = 'Description TEST';
        String firstname = 'Contact FirstName';
        String lastname = 'Contact Test';
        String email = 'test@gmail.com';

        Id selfcareId = null;

        Test.startTest();
        Case caseCreated = HP_EM010_Case.createCaseFromAPI(contactId, context, description, firstname, lastname, email, selfcareId, null,null,null,null,null);
        Test.stopTest();
        System.assertEquals('Chat indisponible', caseCreated.Subject);
    }

    @isTest static void createCaseFromAPIConsentement() {
        Contact contact = [SELECT Id FROM Contact WHERE FirstName='Contact FirstName' AND
                           LastName = 'Contact Test' AND 
                           Email = 'test@gmail.com' AND
                           Id_Tiers__c = 1313];
        Id contactId = contact.Id;
        String context = 'Consentement';
        String description = 'Description TEST';
        String firstname = null;
        String lastname = null;
        String email = null;

        Id selfcareId = null;

        Test.startTest();
        Case caseCreated = HP_EM010_Case.createCaseFromAPI(contactId, context, description, firstname, lastname, email, selfcareId, null,null,null,null,null);
        Test.stopTest();
        System.assertEquals('Enregistrements consentements Xdata KO', caseCreated.Subject);
    }

    @isTest static void createCaseFromAPIAnomalieXdata() {
        Contact contact = [SELECT Id FROM Contact WHERE FirstName='Contact FirstName' AND
                           LastName = 'Contact Test' AND 
                           Email = 'test@gmail.com' AND
                           Id_Tiers__c = 1313
                          LIMIT 1];
        HP_Souscription__c enrolment = [SELECT Id, HP_Souscription_Digital_Id__c, HP_Statut__c 
                                        FROM HP_Souscription__c 
                                        WHERE HP_Contact__c=:contact.Id
                                        LIMIT 1];
        Id contactId = contact.Id;
        String context = 'Anomalie creation xdata Save2';
        String description = 'Description TEST';
        String firstname = null;
        String lastname = null;
        String email = null;

        Id selfcareId = enrolment.Id;

		Test.startTest();
        Case caseCreated = HP_EM010_Case.createCaseFromAPI(contactId, context, description, firstname, lastname, email, selfcareId, null,null,null,null,null);
        Test.stopTest();
        enrolment = [SELECT Id, HP_Souscription_Digital_Id__c, HP_Statut__c 
                                        FROM HP_Souscription__c 
                                        WHERE HP_Contact__c=:contact.Id
                                        LIMIT 1];
        System.assertEquals('Erreur souscription : création PDL/coordonnéesBC dans Xdata', caseCreated.Subject);
    }

    @istest static void updateXDATAAnomaliesCase() {
        Contact contact = [SELECT Id FROM Contact WHERE FirstName='Contact FirstName' AND
                           LastName = 'Contact Test' AND 
                           Email = 'test@gmail.com' AND
                           Id_Tiers__c = 1313
                          LIMIT 1];
        
        HP_Souscription__c enrolment = [SELECT Id, HP_Souscription_Digital_Id__c, HP_Statut__c 
                                        FROM HP_Souscription__c 
                                        WHERE HP_Contact__c=:contact.Id
                                        LIMIT 1];
        Test.startTest();
        HP_EM010_Case.updateXDATAAnomaliesCase(enrolment);
    	Test.stopTest();
        
        List<Case> caseList = [ SELECT Id, Status
								FROM Case 
								WHERE HP_Souscription__c = :enrolment.Id AND HP_Type__c = 'HP_XDATA_ANOMALIE'];
        for(Case c : caseList) {
            System.assertEquals('CLOSED', c.Status);
        }
    }
    
    @istest static void getEnrolmentCases() {
        Contact contact = [SELECT Id FROM Contact WHERE FirstName='Contact FirstName' AND
                           LastName = 'Contact Test' AND 
                           Email = 'test@gmail.com' AND
                           Id_Tiers__c = 1313
                          LIMIT 1];
        
        HP_Souscription__c enrolment = [SELECT Id, HP_Souscription_Digital_Id__c, HP_Statut__c 
                                        FROM HP_Souscription__c 
                                        WHERE HP_Contact__c=:contact.Id
                                        LIMIT 1];
        
        Test.startTest();
        List<Case> caseList = HP_EM010_Case.getEnrolmentCases(enrolment);
    	Test.stopTest();
        
        System.assertEquals(1, caseList.size());
    }
    
    @istest static void loadCase() {
        
        Contact contact = [SELECT Id FROM Contact 
                           WHERE FirstName='Contact FirstName' AND
                           		LastName = 'Contact Test' AND 
                           		Email = 'test@gmail.com' AND
                           		Id_Tiers__c = 1313
                           LIMIT 1];
        Case c = [SELECT Id FROM Case WHERE ContactId =: contact.Id];
        
        Test.startTest();
        List<Case> caseList = HP_EM010_Case.loadCase(c.Id);
    	Test.stopTest();
        
        System.assertEquals(1, caseList.size());
        System.assertEquals(c.Id, caseList[0].Id);
    }

    @istest static void getMailCaseByCaseId() {
        Contact contact = [SELECT Id FROM Contact 
                           WHERE FirstName='Contact FirstName' AND
                           		LastName = 'Contact Test' AND 
                           		Email = 'test@gmail.com' AND
                           		Id_Tiers__c = 1313
                           LIMIT 1];
        Case c = [SELECT Id FROM Case WHERE HP_Type__c = 'HP_Chat'];
        
        Test.startTest();
        Case cResult = HP_EM010_Case.getMailCaseByCaseId(c.Id);
    	Test.stopTest();
        
        System.assertEquals(c.Id, cResult.Id);
    }
    
    @istest static void getContratCasesPrestation() {
        Test.startTest();
        List<Case> caseList = HP_EM010_Case.getContratCasesPrestation(100148);
    	Test.stopTest();
        
        System.assertEquals(1, caseList.size());
    }
    
    @istest static void updateCaseResiliationIndex() {
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        
        Test.startTest();
        HP_EM010_Case.updateCaseResiliationIndex(100148, 1.0, 1.0, 1.0, response);
    	Test.stopTest();
        
        System.assertEquals('EM010-2', response.infos[0].code);
    }
    
     @istest static void updateCaseResiliationIndexKO() {
        HP_WRP022_SFResponse response = new HP_WRP022_SFResponse (HP_HttpStatus.OK);
        
        Test.startTest();
        HP_EM010_Case.updateCaseResiliationIndex(11111111, 1.0, 1.0, 1.0, response);
    	Test.stopTest();
        
        System.assertEquals('EM010-1', response.errors[0].code);
    }

    @istest static void getCaseOwnerDeveloperName() {
        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, OwnerId FROM Case WHERE HP_Type__c = 'HP_Chat']);

        Test.startTest();
        Map<Id, String> resultMap = HP_EM010_Case.getCaseOwnerDeveloperName(caseMap);
        Test.stopTest();
        
        System.assert(resultMap != null);
    }

    @isTest static void caseBuilder() {
        Id rtChatId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Chat');
        
        Case testCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Chat', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'OwnerId' => UserInfo.getUserId(),
            'RecordTypeId' =>  rtChatId
            }, null,null,null);
  
		System.debug('RecordType : ' + testCase.RecordTypeId);
        Test.startTest();
        testCase = HP_EM010_Case.caseBuilder(testCase, rtChatId);
        Test.stopTest();

        System.assert(testCase.Priority == 'Medium', 'Bad Priority');
        System.assert(testCase.Status == 'TO_DO', 'Bad Status');
        System.assert(testCase.Origin == 'Chat', 'Bad Origin');
        System.assert(testCase.Reason == 'Demande Client', 'Bad Reason');
    }

    @isTest static void escalade() {
        Case caseN1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Chat', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'HP_QueueCible__c' => 'Niveau 1',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);

        Case caseN2 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Chat', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'HP_QueueCible__c' => 'Niveau 2',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);

        Case caseN3 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Chat', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'HP_QueueCible__c' => 'Niveau 3',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);

        Map<String, Group> queueMapGroup = HP_Util_QueueManager.getQueueMapByName();
        Map<String, Id> queueMapId = new Map<String, Id>();

        for(Group queue : queueMapGroup.values()) {
            if(queue.DeveloperName.startsWith('HP')) {
                queueMapId.put(queue.DeveloperName, queue.Id);
            }
        }

        String oldCaseN2Status = caseN2.Status;
        
        Test.startTest();
        caseN1 = HP_EM010_Case.escalade(caseN1, queueMapId);
        caseN2 = HP_EM010_Case.escalade(caseN2, queueMapId);
        caseN3 = HP_EM010_Case.escalade(caseN3, queueMapId);
        Test.stopTest();    
            
        System.assert(caseN1.Status == 'TO_DO');
        System.assert(caseN2.Status == oldCaseN2Status);
        System.assert(caseN3.Status == 'Escaladé (happe)');
    }
    
    @IsTest
    public static void reaffectCase() {
        Case caseN1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Chat', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'HP_QueueCible__c' => 'Niveau 1',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);
        List<Case> caseList = new List<Case>();
        caseList.add(caseN1);
        Id queueNiveau1Id = HP_Util_QueueManager.getQueueIdByName('HP_Niveau_1');
        Map<Id, List<Case>> mapListCase = new Map<Id, List<Case>>();
        mapListCase.put(queueNiveau1Id, caseList);
        Test.startTest();
        insert caseList;
        HP_EM010_Case.reaffectCaseToOwner(mapListCase);
        Test.stopTest();    
        
        Case c = [SELECT Id, OwnerId FROM Case Where Id = :caseN1.Id];
        System.assert(c.OwnerId == queueNiveau1Id);
    }







    @IsTest
    public static void createRappelCaseForSouscription() {
		Id recordTypeIdTest = HP_UTIL_RecordType.getRecordTypeId('Case','HP_Telephone');
        HP_Souscription__c souscription = [SELECT Id FROM HP_Souscription__c WHERE HP_Souscription_Digital_Id__c='test-creation-case'];


        Contact contactTest = [SELECT Id FROM Contact WHERE Id_Tiers__c = 1313];
        Test.startTest();
        Case testCase = HP_EM010_Case.createRappelCaseForSouscription(recordTypeIdTest, souscription.Id, contactTest.Id);


        Test.stopTest();    
        
        System.assert(testCase != null);
    }

    @IsTest
    public static void closeCases() {


		Case caseN1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Telephone', new Map<String, Object> {


            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'HP_QueueCible__c' => 'Niveau 1',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);
        List<Case> caseList = new List<Case>();
        caseList.add(caseN1);
        insert caseList;

        Test.startTest();
        HP_EM010_Case.closeCases(caseList);
        Test.stopTest();    
        Case resultCase = [SELECT Status FROM Case WHERE Id= :caseN1.Id];

        System.assert(resultCase.Status == 'CLOSED');
    }

    @IsTest
    public static void cancelCases() {


		Case caseN1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Telephone', new Map<String, Object> {


            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'HP_QueueCible__c' => 'Niveau 1',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);
        List<Case> caseList = new List<Case>();
        caseList.add(caseN1);
        insert caseList;
        
        Test.startTest();
        HP_EM010_Case.cancelCases(caseList);
        Test.stopTest();    
        Case resultCase = [SELECT Status FROM Case WHERE Id= :caseN1.Id];

        System.assert(resultCase.Status == 'CANCELED');
    }


	@istest static void getTelephoneCaseByCaseId() {
        Case c = [SELECT Id FROM Case WHERE HP_Type__c = 'HP_Appel_Diabolocom'];
        
        Test.startTest();
        Case cResult = HP_EM010_Case.getTelephoneCaseByCaseId(c.Id);
    	Test.stopTest();
        
        System.assertEquals(c.Id, cResult.Id);
    }

}