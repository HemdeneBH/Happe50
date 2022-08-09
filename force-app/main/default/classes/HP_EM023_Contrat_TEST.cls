/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   27-04-2021   Antoine Latour   Initial Version
**/
@isTest

public with sharing class HP_EM023_Contrat_TEST {

	private enum StaticResource {
        HP_SM020_SouscriptionSave1_TEST
	}

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

	@istest
	public static void upsertContratIndexByXdataId(){
			Test.startTest();
			HP_EM023_Contrat.upsertContratIndexByXdataId(123, 1, 2, 3, 4);
			Test.stopTest();

			HP_Contrat__c acontrat = [SELECT Id, HP_Index_de_Compteur__c FROM HP_Contrat__c WHERE HP_Contrat_XdataId__c = 123];
			System.assert(acontrat.HP_Index_de_Compteur__c == 1);
	}

	@isTest
	public static void saveContrat() {
		final String enrolmentRestResourceSave1Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM020_SouscriptionSave1_TEST.name());
		HP_EnrolmentRestResourceModel enrolmentReq = (HP_EnrolmentRestResourceModel) JSON.deserialize(enrolmentRestResourceSave1Json, HP_EnrolmentRestResourceModel.class);		
		HP_Souscription__c enrolment = [SELECT Id FROM HP_Souscription__c WHERE HP_Souscription_Digital_Id__c = '123456'];

		Test.startTest();
		List<String> idList = HP_EM023_Contrat.saveContrat(enrolmentReq.selfcareLead.firstSave_v0_1, enrolment.Id);
		Test.stopTest();
		System.assert(idList.size() > 0);
	}

	@isTest
	public static void buildContract() {
		Test.startTest();
		HP_Contrat__c cont = HP_EM023_Contrat.buildContract(1111, HP_EnrolmentRestResourceModel.EnergyType.ELECTRICITY);
		Test.stopTest();
		 
		System.assert(cont != null);
	}

	@isTest
	public static void buildElecContract() {
		final String enrolmentRestResourceSave1Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM020_SouscriptionSave1_TEST.name());
		HP_EnrolmentRestResourceModel enrolmentReq = (HP_EnrolmentRestResourceModel) JSON.deserialize(enrolmentRestResourceSave1Json, HP_EnrolmentRestResourceModel.class);		
		HP_Souscription__c enrolment = [SELECT Id FROM HP_Souscription__c WHERE HP_Souscription_Digital_Id__c = '123456'];
		Test.startTest();
		HP_Contrat__c cont = HP_EM023_Contrat.buildElecContract(enrolmentReq.selfcareLead.firstSave_v0_1, enrolment.Id);
		Test.stopTest();
		 
		System.assert(cont != null);
	}

	@isTest
	public static void buildGazContract() {
		final String enrolmentRestResourceSave1Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM020_SouscriptionSave1_TEST.name());
		HP_EnrolmentRestResourceModel enrolmentReq = (HP_EnrolmentRestResourceModel) JSON.deserialize(enrolmentRestResourceSave1Json, HP_EnrolmentRestResourceModel.class);		
		HP_Souscription__c enrolment = [SELECT Id FROM HP_Souscription__c WHERE HP_Souscription_Digital_Id__c = '123456'];
		Test.startTest();
		HP_Contrat__c cont = HP_EM023_Contrat.buildGazContract(enrolmentReq.selfcareLead.firstSave_v0_1, enrolment.Id);
		Test.stopTest();
		 
		System.assert(cont != null);
	}
	
	@isTest
	public static void loadContrat() {
		Test.startTest();
		List<HP_Contrat__c> contList = HP_EM023_Contrat.loadContrat('123456');
		Test.stopTest();
		 
		System.assert(contList.size() > 0);
	}

	@isTest
	public static void loadContratByEnergy() {
		Test.startTest();
		List<HP_Contrat__c> contList = HP_EM023_Contrat.loadContratByEnergy('123456', 'ELEC');
		Test.stopTest();
		 
		System.assert(contList.size() > 0);
	}

	@isTest
	public static void loadContratByXdataId() {
		Test.startTest();
		HP_Contrat__c cont = HP_EM023_Contrat.loadContratByXdataId(123);
		Test.stopTest();
		 
		System.assert(cont != null);
	}

	@isTest
	public static void loadContratListByXdataId() {
		Test.startTest();
		List<HP_Contrat__c> contList = HP_EM023_Contrat.loadContratListByXdataId(123);
		Test.stopTest();
		 
		System.assert(contList.size() > 0);
	}
}