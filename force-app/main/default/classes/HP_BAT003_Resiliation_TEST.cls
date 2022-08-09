/**
 * @File Name          : HP_BAT003_Resiliation_TEST.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 24/04/2020 à 13:28:03
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/02/2020   Vincent Albiser     Initial Version
**/

@isTest
public with sharing class HP_BAT003_Resiliation_TEST {

	private enum StaticResource {		
        HP_SendEmail_Mock,
        HP_APIHourAccessTokenResponse_MOCK
    }

	@testSetup 
	static void setup() {
		Integer numberCases = 1;
		final Id caseRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase');
		final String contactRecorTypeId = HP_UTIL_SmartFactory.getDefaultRecordTypeId('Contact');
		List<HP_Contrat__c> contrats = new List<HP_Contrat__c>();
		List<Case> cases = new List<Case>();
		
		List<String> status = new List<String>{						HP_SLCT_Case.Status.NEW_CASE.name(),	HP_SLCT_Case.Status.NEW_CASE.name(),	HP_SLCT_Case.Status.NEW_CASE.name(),
																	HP_SLCT_Case.Status.NEW_CASE.name(),	HP_SLCT_Case.Status.NEW_CASE.name(),	HP_SLCT_Case.Status.NEW_CASE.name(),
																	HP_SLCT_Case.Status.NEW_CASE.name(),
																	HP_SLCT_Case.Status.HP_PENDING.name(),	HP_SLCT_Case.Status.HP_PENDING.name(),	HP_SLCT_Case.Status.HP_PENDING.name(),
																	HP_SLCT_Case.Status.HP_PENDING.name(),	HP_SLCT_Case.Status.HP_PENDING.name(),	HP_SLCT_Case.Status.HP_PENDING.name(),
																	HP_SLCT_Case.Status.HP_PENDING.name(),
																	HP_SLCT_Case.Status.TO_DO.name(),		HP_SLCT_Case.Status.TO_DO.name()};

		List<Integer> quantities = new List<Integer>{				12,										null,									null,
																	null,									null,									null,
																	null,
																	324,									null,									null,
																	null,									null,									null,
																	null,
																	null,									null};

		List<Integer> daysBeforeEffectiveDate = new List<Integer>{	1,										4,										4,
																	8,										8,										15,
																	15,
																	1,										4,										4,
																	8,										8,										15,
																	15,
																	1,										2};

		List<Boolean> isSmart = new List<Boolean>{					true,									true,									false,
																	true,									false,									true,
																	false,
																	true,									true,									false,
																	true,									false,									true,
																	false,
																	true,									false};

		Contact cont = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{
																		'Id_Tiers__c' => 100166,
																		'HP_IsHappe__c' => true,
																		'LastName' => 'last',
																		'firstname' => 'first',
																		'Email' => 'test@gmail.com',
																		'Salutation' => ' Mr',
																		'RecordTypeId' => contactRecorTypeId
																	},null,null,null);
		insert cont;
	}

   
	@isTest static void test() {

			Contact cont = [select Id from Contact limit 1];       	
			Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'HP_Type__c' =>  HP_SLCT_Case.Type.CONTRACT_CANCELATION.name(), 

			'Subject' => 'case ' ,
			'HP_Energy__c' => 'Electricity',
			'RecordTypeId'  => HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase'),
			'HP_CompteurCommunicant__c'=> true,
			'HP_EffectiveDate__c' => date.today().addDays(1)
			}, null
			);

		insert acase;
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
             'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };

		// start the tests
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		HP_BAT003_Resiliation.execute();
		Test.stopTest();


	}

    @isTest static void test2() {


			Contact cont = [select Id , Email, firstname, Id_Tiers__c, lastname, salutation from Contact limit 1];
			Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,
			'Type' =>  HP_SLCT_Case.Type.CONTRACT_CANCELATION.name(), 
			'Subject' => 'case ' ,
			'HP_Energy__c' => 'Electricity',

			'RecordTypeId'  => HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase'),
			'HP_CompteurCommunicant__c'=> false,
			'HP_EffectiveDate__c' => date.today().addDays(1)
			}, null
			);

		insert acase;


		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
             'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };

		Test.startTest();
		// start the tests
	
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		HP_BAT003_Resiliation.execute();
		Test.stopTest();
	}

	@isTest static void test3() {
			Contact cont = [select Id from Contact limit 1];       	
			Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => cont.Id,

			'Type' =>  HP_SLCT_Case.Type.CONTRACT_CANCELATION.name(), 
			'Subject' => 'case ' ,
			'HP_Energy__c' => 'Electricity',
		//	'HP_Contrat__c' => contrats[i].Id,
			'RecordTypeId'  => HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase'),
			'HP_CompteurCommunicant__c'=> false,
			'HP_EffectiveDate__c' => date.today().addDays(6)
			}, null
			);

		insert acase;
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
             'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        };

		// start the tests
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		HP_BAT003_Resiliation.execute();
		Test.stopTest();


		}

}