/**
 * @File Name          : HP_CancelationCaseUtils_TEST.cls
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-02-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/01/2020   Mohamed Aamer     Initial Version
**/
@IsTest
public with sharing class HP_CancelationCaseUtils_TEST {

    private enum StaticResource {
		HP_CancelationCaseRestResourceGaz_TEST,
        HP_CancelationCaseRestResourceElec_TEST,
        HP_CONTRAT_XDATA_BY_PERSONNE_MOCK,
        HP_APIHourAccessTokenResponse_MOCK
	}

    @TestSetUp 
	private static void insertTestData() {
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            String caseRecorTypeId = HP_UTIL_SmartFactory.getDefaultRecordTypeId('Case');
        
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object>{
                'LastName' => 'Contact Test',
                'Id_Tiers__c' => 195464
            }, null, null, new List<String>{'AccountId'});
            insert contact;
            
            HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Canal_de_vente__c'  => 'Vente Online',
                'HP_Contact__c'=>contact.Id,
                'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
                'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
                'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
                'HP_Code_postal__c'  => '92160',
                'HP_code_Postal_Insee__c'  => '92002',
                'HP_Date_de_Contractualisation__c'  => Date.newInstance(2019, 12, 22),
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
                'HP_Souscription_Digital_Id__c' =>'testGazElec-01',
                'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
                'HP_type_Souscription__c' =>'MOVING_IN',
                'HP_NumberPCE__c' =>'31431211214068',
                'HP_NumPDL__c' =>'31431211214170',
                'HP_Statut__c' =>'SAVE_3'
            }, null);
            insert enrolment;
            
            List<HP_Contrat__c> contratList = new List<HP_Contrat__c>();
            contratList.add((HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 'HP_Contrat_XdataId__c' => 100148,
            'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'ELEC',
            'HP_Proposition_Commerciale_XdataId__c'=>'12345',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'ELEC'
        }, null));
    
            contratList.add((HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 'HP_Contrat_XdataId__c' => 100147,
            'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'GAS',
            'HP_Proposition_Commerciale_XdataId__c'=>'54321',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'GAS'
        }, null));
    
            insert contratList;
    
            Case caseTask = (Case)HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object>{
                'HP_EffectiveDate__c' => Date.newInstance(2019, 12, 27),
                'HP_Source__c' => 'HP_CLIENT',
                'RecordTypeId' => caseRecorTypeId,
                'Status' => 'NEW_CASE',
                'Origin'=>'HP_SELFCARE',
                'ContactId' => contact.id,
                'Subject' => 'Case Test'
            }, null);
            insert caseTask;

        }
      
    }

    @IsTest
	static void handleCancelationCaseGaz(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            final String cancelationCaseRestResourceModelGazJson = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CancelationCaseRestResourceGaz_TEST.name());
            final HP_CancelationCaseRestResourceModel cancelationCaseRestResourceGaz = (HP_CancelationCaseRestResourceModel)HP_ParseUtils.parse(
                cancelationCaseRestResourceModelGazJson, HP_CancelationCaseRestResourceModel.class
            );
            System.debug('==========>' +cancelationCaseRestResourceGaz);
            List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> cancelationCaseList_v0_1 = new List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1>{
                cancelationCaseRestResourceGaz.SelfcareCase.CancelationCase_v0_1
            };
            Contact primaryContact = [SELECT LastName, Id_Tiers__c FROM Contact WHERE LastName='Contact Test' LIMIT 1];
            Date effectiveDate = Date.newInstance(2020, 12, 27);
            HP_WRP022_SFResponse sfResponse =new HP_WRP022_SFResponse(200);
            Case aCase = [SELECT Id, HP_TECH_ExternalId__c from Case limit 1];
            aCase.HP_TECH_ExternalId__c = 'CONTRACT_CANCELATION/100147';
            update aCase;
            Test.startTest();
            HP_CancelationCaseUtils.handleCancelationCase(cancelationCaseList_v0_1,primaryContact,effectiveDate,null,sfResponse);
            Test.stopTest();
            List<Case> caseList = [SELECT Id, Status FROM Case WHERE HP_TECH_ExternalId__c='CONTRACT_CANCELATION/100147'];
            System.assertEquals(1,caseList.size(),'OK');
            System.assertEquals('TO_DO', caseList[0].Status, 'OK');
            
        }
       
    }

    @IsTest
	static void handleCancelationCaseElec(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            final String cancelationCaseRestResourceModelElecJson = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CancelationCaseRestResourceElec_TEST.name());
            final HP_CancelationCaseRestResourceModel cancelationCaseRestResourceElec = (HP_CancelationCaseRestResourceModel)HP_ParseUtils.parse(
                cancelationCaseRestResourceModelElecJson, HP_CancelationCaseRestResourceModel.class
            );
            System.debug('==========>' +cancelationCaseRestResourceElec);
            List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1> cancelationCaseList_v0_1 = new List<HP_CancelationCaseRestResourceModel.CancelationCase_v0_1>{
                cancelationCaseRestResourceElec.SelfcareCase.CancelationCase_v0_1
            }; //
            Contact primaryContact = [SELECT LastName, Id_Tiers__c FROM Contact WHERE LastName='Contact Test' LIMIT 1];
            Date effectiveDate = Date.newInstance(2019, 12, 27);
            Date processingDate = Date.newInstance(2019, 12, 28);
            Case aCase = [SELECT Id, HP_TECH_ExternalId__c, Status from Case limit 1];
            aCase.HP_TECH_ExternalId__c = 'CONTRACT_CANCELATION/100148';
            aCase.Status = 'CLOSED';
            update aCase;
            HP_WRP022_SFResponse sfResponse =new HP_WRP022_SFResponse(200);
            Test.startTest();
            HP_CancelationCaseUtils.handleCancelationCase(cancelationCaseList_v0_1,primaryContact,effectiveDate,processingDate,sfResponse);
            Test.stopTest();
            List<Case> caseList = [SELECT Id FROM Case WHERE HP_TECH_ExternalId__c='CONTRACT_CANCELATION/100148'];
            System.assertEquals(1,caseList.size(),'OK');
            System.assert(sfResponse.warnings[0].message.contains('Case Closed'), 'OK');
       }
        
    }

    @IsTest
    static void createTask(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            String caseId = String.valueOf([SELECT Id FROM Case WHERE Subject='Case Test' LIMIT 1].Id);
            Date processingDate = Date.newInstance(2019, 12, 28);
            Test.startTest();
            HP_CancelationCaseUtils.createTask(caseId,processingDate);
            Test.stopTest();
            Task task = [SELECT ActivityDate, WhatId FROM Task WHERE WhatId=:caseId LIMIT 1];
            System.assertEquals(caseId,task.WhatId,'OK');
        }
        
    }

    @IsTest
    static void rescheduleCaseGaz(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            String caseId = String.valueOf([SELECT Id FROM Case WHERE Subject='Case Test' LIMIT 1].Id);
            String energy = 'GAS';
            Integer energyContractXdataId = 100147;
            Integer energyMeterIndex = 93;
            Integer electricityMeterVariablePlanBottomPriceIndex = 23;
            Id primaryContactId = [SELECT Id FROM Contact WHERE LastName='Contact Test' LIMIT 1].Id;
            String effectiveDateStr = '01/02/2021';
            String processingDateStr = '01/02/2021';
            String caseStatusStr = 'TO_DO';
            String sourceCaseStr = 'HP_CLIENT';
            String originStr = 'HP_CRM';
            HP_WRP022_SFResponse SFResponse =new HP_WRP022_SFResponse(200);
            Test.startTest();
            HP_CancelationCaseUtils.rescheduleCase(caseId,energy,energyContractXdataId,energyMeterIndex,electricityMeterVariablePlanBottomPriceIndex,primaryContactId,effectiveDateStr,
            processingDateStr,caseStatusStr,sourceCaseStr,originStr,SFResponse);
            Test.stopTest();
        }
    }
}