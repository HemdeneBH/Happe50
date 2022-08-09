/**
 * @File Name          : HP_SM0017_DQE_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 01/04/2020 à 10:20:16
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/01/2020   Mouhamadoune Coulibaly     Initial Version
**/ 
@isTest
public with sharing class HP_SM0017_DQE_TEST {

    private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
		HP_SM0017_DQE_Email_MOCK,
		HP_SM0017_DQE_Telephone_MOCK,
		HP_AgilabAccessTokenResponse_MOCK

	}

	@testSetup static void dataSetup(){
		HP_UTIL_SmartFactory.insertUserHP();
	}

    @isTest static void getEmailValidation(){
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
			Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
				'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
													   new Map<String, String> {'Content-Type' => 'APPLICATION/JSON'}),
	
			   'protected-dqe' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
																 StaticResource.HP_SM0017_DQE_Email_MOCK.name(),
																 new Map<String, String> { 'Content-Type' => 'APPLICATION/JSON'})
		   };
   
		   Test.startTest();
		   RestContext.response= new RestResponse();
		   Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		   // Object res = HP_SM0017_DQE.getEmailValidation('testmail@hotmail.com');
		   String res = JSON.serialize(HP_SM0017_DQE.getEmailValidation('testmail@hotmail.com'));
		   HP_WRP0017_DQEemail response = (HP_WRP0017_DQEemail) JSON.deserialize(res,HP_WRP0017_DQEemail.class);
		   Test.stopTest();
		   System.assert (response.eMail == 'testmail@hotmail.com', 'eMail testmail@hotmail.com');
		}
	}

    @isTest static void getTelephoneValidation(){
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
			Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
				'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
													   new Map<String, String> {'Content-Type' => 'APPLICATION/JSON'}),
	 
				'protected-dqe' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
																  StaticResource.HP_SM0017_DQE_Telephone_MOCK.name(),
																  new Map<String, String> { 'Content-Type' => 'APPLICATION/JSON'})
			};
	
			Test.startTest();
			RestContext.response= new RestResponse();
			Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
			// Object res = HP_SM0017_DQE.getTelephoneValidation('0613035600');
			String res = JSON.serialize(HP_SM0017_DQE.getTelephoneValidation('0613035600','FRA'));
			HP_WRP0018_DQEtelephone response = (HP_WRP0018_DQEtelephone) JSON.deserialize(res,HP_WRP0018_DQEtelephone.class);
			Test.stopTest();
			System.assert (response.TelOrigine == '0613035600', 'TelOrigine 0613035600');
		}	
	}
    
  
}