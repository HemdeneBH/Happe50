@isTest
global class SM_AP26_QuestionConsentementAPI_TEST {
	@isTest
	global static void test() {

		MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
		endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
		endpoint.Name = 'api_endpoint';
		insert endpoint;

		MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
		sm_api_version.Value__c = '0.1';
		sm_api_version.Name = 'sm_api_version';
		insert sm_api_version;

		MP_Xdata_credentials__c sm_api_key_INT = new MP_Xdata_credentials__c();
		sm_api_key_INT.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
		sm_api_key_INT.Name = 'sm_api_key_INT';
		insert sm_api_key_INT;

		Map<String , object>inputMap = new Map<String, object>() ;
		Map<String , object>outputMap = new Map<String, object>() ;

		SM_AP26_QuestionConsentementAPI service = new SM_AP26_QuestionConsentementAPI() ;

		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null) ;
		service.invokeMethod('callQuestionConsentement', inputMap,  outputMap, null) ;

		List<Object> listQuestions = new List<Object>();
		Map<String,Object>mapQuestions = new Map<String, Object>();
		mapQuestions.put('id', 'test');
		mapQuestions.put('idQuestionnaire', 'test');
		mapQuestions.put('codeQuestionnaireQuestion', 'test');
		mapQuestions.put('libelleQuestion', 'test');
		mapQuestions.put('detailQuestion', 'test');
		listQuestions.add(mapQuestions);



		SM_AP26_QuestionConsentementAPI.transformDatatoOmniscript(listQuestions) ;

		String json = '{"test":"test"}';
		//      JSONParser parser = JSON.createParser(json);
		// SM_AP26_QuestionConsentementAPI.getJsonFieldAsString(parser , 'test');

		SM_AP26_QuestionConsentementAPI.getResponse() ;

		SM_AP26_QuestionConsentementAPI.QuestionConsentementModel QuestionConsentementModel = new  SM_AP26_QuestionConsentementAPI.QuestionConsentementModel(null,null,null,null,null) ;
	}

}