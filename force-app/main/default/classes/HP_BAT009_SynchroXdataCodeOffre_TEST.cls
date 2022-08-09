/**
 * @File Name          : HP_BAT009_SynchroXdataCodeOffre_TEST.cls
 * @Description        : Classe de test pour le batch HP_BAT009_SynchroXdataCodeOffre (API Offre)
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 05/05/2020 à 15:26:28
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    05/05/2020   Sara El-Hannaoui     Initial Version
**/
@istest
public with sharing class HP_BAT009_SynchroXdataCodeOffre_TEST {
   
	private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK,
        HP_APIHourGetOffres_MOCK
	}

	@istest
	static void testBatch(){
			Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
				'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													  StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
													  new Map<String, String> {'Content-Type' => 'application/json'}),
	
			   'offres' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
													 StaticResource.HP_APIHourGetOffres_MOCK.name(),
													 new Map<String, String> { 'Content-Type' => 'application/json;charset=UTF-8'})
		   };
   
		   Test.startTest();
			   Database.BatchableContext batchableContext;
			   Test.setMock(HttpCalloutMock.class,new HP_UTIL_ResponseRestMock(bodyResponseMap));
			   HP_BAT009_SynchroXdataCodeOffre.execute();
		   Test.stopTest();
		   System.assert([Select count() From HP_Offre__c ] > 0 , 'Custom setting Offre inserted in SF');
	}
}