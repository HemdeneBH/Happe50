@isTest
global class SM_AP06_MandatsApiService_TEST {
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
		inputMap.put('IdBusinessPartner', '0309981403') ;
		Map<String , object>outputMap = new Map<String, object>() ;

		SM_AP06_MandatsApiService service = new SM_AP06_MandatsApiService() ;

		service.invokeMethod('methodenotCovered', inputMap,  outputMap, null) ;
		service.invokeMethod('callMandats', inputMap,  outputMap, null) ;


		List<Object> listMandats = new List<Object>();
		Map<String, Object> mandatsTest = new Map<String, Object>() ;
		mandatsTest.put('dateSignature', '2019/01/01') ;
		listMandats.add(mandatsTest) ;

		SM_AP06_MandatsApiService.callMandats(inputMap,outputMap,null);
		SM_AP06_MandatsApiService.transformDatatoOmniscript(listMandats) ;
		HttpRequest request =  SM_AP06_MandatsApiService.buildHttpRequestHeaders('tokentest', '0309981403') ;
		SM_AP06_MandatsApiService.sendData(request ) ;

		String json = '{"test":"test"}';
		//      JSONParser parser = JSON.createParser(json);
		// SM_AP06_MandatsApiService.getJsonFieldAsString(parser , 'test');

		SM_AP06_MandatsApiService.getResponse('tokentest', '0309981403') ;

		SM_AP06_MandatsApiService.MandatsModel MandatsModel = new  SM_AP06_MandatsApiService.MandatsModel('0309981403','2019/01/01','Valider', 'UrlTest') ;
	}
    
    
    @isTest
    global static void SendFact_Test() {
         // Test Method sendDuplicata
      Map < String, Object > SendFact_inputMap = new Map < String, Object >();
		Map < String, Object > SendFact_outMap = new Map < String, Object >();
        Map < String, Object > ContactFields = new Map < String, Object >();
              
      ContactFields.put('Prenom','Mohamed');
      ContactFields.put('Nom','Troudi');
      ContactFields.put('Civilite','MR');
      ContactFields.put('Email','mohamed.troudi@external.engie.com');
      ContactFields.put('Adresse','102 AVENUE ARISTIDE BRIAND BAGNEUX');
      
      SendFact_inputMap.put('ContextId', '0123456789');
      SendFact_inputMap.put('IdBusinessPartner', '0206611342');
      SendFact_inputMap.put('ContactFields', ContactFields);
      SendFact_inputMap.put('getUrlMandats', '(url1, url2)');
      SendFact_inputMap.put('getDateMandats', '(Facture du 01/04/2019, Facture du 02/04/2019)'); 
        
        
        
        SM_AP06_MandatsApiService service = new  SM_AP06_MandatsApiService();
        
        service.invokeMethod('sendDuplicata',SendFact_inputMap, SendFact_outMap, null);      
    }
    
}