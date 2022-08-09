@isTest
global class SM_AP29_PersonnesAPI_TEST {
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

		MP_Xdata_credentials__c sm_api_key = new MP_Xdata_credentials__c();
		sm_api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
		sm_api_key.Name = 'sm_api_key_INT';
		insert sm_api_key;

		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('refClientIdBP','0309980002');
		Map<String , object>outputMap = new Map<String, object>() ;

		SM_AP29_PersonnesAPI service = new SM_AP29_PersonnesAPI() ;

		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null) ;
		service.invokeMethod('callPersonne', inputMap,  outputMap, null) ;

		List<Object> listPersonne = new List<Object>();
		Map<String,Object>mapPersonne = new Map<String, Object>();
		mapPersonne.put('id', 'test');
		mapPersonne.put('idPersonneUnifiee', 'test');
		mapPersonne.put('idBusinessPartner', 'test');
		listPersonne.add(mapPersonne);

		SM_AP29_PersonnesAPI.transformDatatoOmniscript(listPersonne) ;
		HttpRequest request =  SM_AP29_PersonnesAPI.buildHttpRequestHeaders('tokentest',String.valueOf(inputMap.get('refClientIdBP'))) ;
		SM_AP29_PersonnesAPI.sendData(request ) ;
		String json = '{"test":"test"}';
		//      JSONParser parser = JSON.createParser(json);
		// SM_AP26_QuestionConsentementAPI.getJsonFieldAsString(parser , 'test');

		SM_AP29_PersonnesAPI.getResponse('tokentest',String.valueOf(inputMap.get('refClientIdBP'))) ;

		SM_AP29_PersonnesAPI.PersonneModel QuestionConsentementModel = new  SM_AP29_PersonnesAPI.PersonneModel(null,null,null) ;
	}

	@isTest
	global static void test2() {

		MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
		endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
		endpoint.Name = 'api_endpoint';
		insert endpoint;

		MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
		sm_api_version.Value__c = '0.1';
		sm_api_version.Name = 'sm_api_version';
		insert sm_api_version;

		MP_Xdata_credentials__c sm_api_key = new MP_Xdata_credentials__c();
		sm_api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
		sm_api_key.Name = 'sm_api_key_INT';
		insert sm_api_key;

		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('refClientIdBP','309980002');
		Map<String , object>outputMap = new Map<String, object>() ;

		SM_AP29_PersonnesAPI service = new SM_AP29_PersonnesAPI() ;

		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null) ;
		service.invokeMethod('callPersonne', inputMap,  outputMap, null) ;

		List<Object> listPersonne = new List<Object>();
		Map<String,Object>mapPersonne = new Map<String, Object>();
		mapPersonne.put('id', 'test');
		mapPersonne.put('idPersonneUnifiee', 'test');
		mapPersonne.put('idBusinessPartner', 'test');
		listPersonne.add(mapPersonne);

		SM_AP29_PersonnesAPI.transformDatatoOmniscript(listPersonne) ;
		HttpRequest request =  SM_AP29_PersonnesAPI.buildHttpRequestHeaders('tokentest',String.valueOf(inputMap.get('refClientIdBP'))) ;
		SM_AP29_PersonnesAPI.sendData(request ) ;
		String json = '{"test":"test"}';
		//      JSONParser parser = JSON.createParser(json);
		// SM_AP26_QuestionConsentementAPI.getJsonFieldAsString(parser , 'test');

		SM_AP29_PersonnesAPI.getResponse('tokentest',String.valueOf(inputMap.get('refClientIdBP'))) ;

		SM_AP29_PersonnesAPI.PersonneModel QuestionConsentementModel = new  SM_AP29_PersonnesAPI.PersonneModel(null,null,null) ;
	}
}