@isTest
global class SM_AP05_PortefeuilleContratApi_TEST {
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
		inputMap.put('idPortefeuilleContrat', 'idPortefeuilleContrat');
		Map<String , object>outputMap = new Map<String, object>();

		SM_AP05_PortefeuilleContratApiService service = new SM_AP05_PortefeuilleContratApiService();

		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null);
		service.invokeMethod('callPortefeuilleContrat', inputMap,  outputMap, null);


		List<Object> listRythmeFacturation = new List<Object>();
		Map<String, Object> factureTest = new Map<String, Object>();
		facturetest.put('idPortefeuilleContrat', '5584');
		listRythmeFacturation.add(factureTest);

		HttpRequest request =  SM_AP05_PortefeuilleContratApiService.buildHttpRequestHeaders('tokentest', '0309981403');
		SM_AP05_PortefeuilleContratApiService.sendData(request );

		String json = '{"test":"test"}';

		SM_AP05_PortefeuilleContratApiService.getResponse('tokentest', '0309981403');

		SM_AP05_PortefeuilleContratApiService.PortefeuilleContratModel portefeuilleContratModel = new SM_AP05_PortefeuilleContratApiService.PortefeuilleContratModel('+148');
        
        SM_AP05_PortefeuilleContratApiService.callPortefeuilleContrat(facturetest, new Map<String,Object>(), null);
        SM_AP05_PortefeuilleContratApiService.callPortefeuilleContrat(new Map<String,Object>(), new Map<String,Object>(), null);
	}
}