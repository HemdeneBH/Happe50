/**
 * @File Name          : HP_BAT001_Emailing_TEST.cls
 * @Description        : Classe de test pour le batch Emailing (API Pilotage)
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 02/04/2020 à 13:34:15
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    02/04/2020   Sara El-Hannaoui     Initial Version
**/
@istest
public with sharing class HP_BAT001_Emailing_TEST {

	private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
		HP_EM026_Pilotage_MOCK
	}


	@TestSetup
	static void makeData(){
			HP_Parameters__c param = (HP_Parameters__c)HP_UTIL_SmartFactory.createSObject('HP_Parameters__c', null, new Map<String, Object> {
				'date_Emailing_Batch__c' => Datetime.newInstance(2020, 03, 29, 0, 0, 0),
				'consumer_Emailing_Batch__c' => '545454',
				'source_Emailing_Batch__c' => '0000654321'
			}, null, null,null);
			insert param;
	
			Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
				'LastName' => 'Contact Test',
				'Email' => 'test@gmail.com',
				'Id_Tiers__c' => 1313
			}, null, null,null);
			insert contact;
	}

	@istest
	static void testBatch(){
			Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
				'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													  StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
													  new Map<String, String> {'Content-Type' => 'application/json'}),
	
			   'v1/rest/emails' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													 StaticResource.HP_EM026_Pilotage_MOCK.name(),
													 new Map<String, String> { 'Content-Type' => 'application/json;charset=UTF-8'})
		   };
   
		   Test.startTest();
			   Database.BatchableContext batchableContext;
			   Test.setMock(HttpCalloutMock.class,new HP_UTIL_ResponseRestMock(bodyResponseMap));
			   HP_BAT001_Emailing emailingBatch = new HP_BAT001_Emailing();
			   HP_BAT001_Emailing.execute(1, null, null);
		   Test.stopTest();
		   System.assert([Select count() From EmailMessage ] > 0 , 'EmailMessage created in SF');
	}

}