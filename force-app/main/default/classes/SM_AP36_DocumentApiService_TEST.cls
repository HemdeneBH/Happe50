@isTest
global class SM_AP36_DocumentApiService_TEST {

	@isTest
	global static void global_Test() {
		// Implement test code
		
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_FacturationsPaiementsApi_Mock');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // system.debug('@@ mock '+mock);
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

		Test.starttest();
		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('idFacture', '202000001');
		Map<String , object>outputMap = new Map<String, object>() ;
		SM_AP36_DocumentApiService.callFacture( inputMap, outputMap, null);
		SM_AP36_DocumentApiService.FactureModel factureModel = new SM_AP36_DocumentApiService.FactureModel('test','test');
		Test.stopTest();
	}

	@isTest
	global static void global_Test1() {
		// Implement test code
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
		
		Test.starttest();
		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('idMandat', '202000001');
		Map<String , object>outputMap = new Map<String, object>() ;
		SM_AP36_DocumentApiService.callMandats( inputMap, outputMap, null);
		SM_AP36_DocumentApiService.FactureModel factureModel = new SM_AP36_DocumentApiService.FactureModel('test','test');
		Test.stopTest();
	}

    
    	@isTest
	global static void global_TestFactureLWC() {
		// Implement test code
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

		Test.starttest();
		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('idFacture', '202000001');
		Map<String , object>outputMap = new Map<String, object>() ;
		SM_AP36_DocumentApiService.callFactureLWC( inputMap);
        
    }
}