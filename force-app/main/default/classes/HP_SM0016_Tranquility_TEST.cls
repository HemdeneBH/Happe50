/**
 * @File Name          : HP_SM0016_Tranquility_TEST.cls
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Mohamed Aamer
 * @Last Modified On   : 20/01/2020 à 15:56:28
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/01/2020   Mohamed Aamer     Initial Version
**/
@isTest
public with sharing class HP_SM0016_Tranquility_TEST {

	private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
		HP_SM008_APIHour_ZoneDistribution_TEST,
		HP_SM003_Tranquility_Contrat_TEST,
		HP_AgilabAccessTokenResponse_MOCK,
		HP_TokenHappeProtected

	}

	@testSetup static void dataSetup(){
		HP_UTIL_SmartFactory.insertUserHP();
	}


	@isTest static void getContrat(){
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
			Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
				'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													   StaticResource.HP_TokenHappeProtected.name(),
													   new Map<String, String> {'Content-Type' => 'application/json'}),
	
				'v2/rest/tranquillity/Contracts/getContrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
																  StaticResource.HP_SM003_Tranquility_Contrat_TEST.name(),
																  new Map<String, String> { 'Content-Type' => 'application/json'})
			};
	
			Test.startTest();
			RestContext.response= new RestResponse();
			Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
			String res = JSON.serialize(HP_SM0016_Tranquility.getContrat(3834200));
			HP_WRP0015_TranquilityContractInfo response = (HP_WRP0015_TranquilityContractInfo) JSON.deserialize(res,HP_WRP0015_TranquilityContractInfo.class);
			Test.stopTest();
			System.assert (response.contratList.size()>0, 'le client a un contrat');
			System.assert (response.messageRetour.code == 'SUCCESS', 'code SUCCESS');
		}
	}

}