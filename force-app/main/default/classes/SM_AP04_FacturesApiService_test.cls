@isTest
global class SM_AP04_FacturesApiService_test {

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
	inputMap.put('IdBusinessPartner', '324566777') ;
	inputMap.put('IdPortefeuilleContrat', '4545') ;
    inputMap.put('excludeSomeBillsType', true) ;
	Map<String , object>outputMap = new Map<String, object>() ;

    Test.startTest();
	SM_AP04_FacturesApiService service = new SM_AP04_FacturesApiService() ;

	service.invokeMethod('methodenotCovered', inputMap, outputMap, null) ;
	service.invokeMethod('callFacture', inputMap,  outputMap, null) ;
    
    SM_AP04_FacturesApiService.callFactureLWC(inputMap) ;
      
	SM_AP04_FacturesApiService.callFacture( inputMap, outputMap, null);
	Double value = 70;
	List<Object> listFactures = new List<Object>();
	Map<String, Object> factureTest = new Map<String, Object>() ;
	facturetest.put('dateComptable', '2018-09-18T14:27:06.8410095+02:00') ;
	facturetest.put('montantTotal',value);
	listFactures.add(factureTest) ;

	SM_AP04_FacturesApiService.transformDatatoOmniscript(listFactures) ;
	HttpRequest request =  SM_AP04_FacturesApiService.buildHttpRequestHeaders('tokentest', '0324566777', '4545') ;
	SM_AP04_FacturesApiService.sendData(request ) ;

	//String json = '{"test":"test"}';
	//      JSONParser parser = JSON.createParser(json);
	// SM_AP04_FacturesApiService.getJsonFieldAsString(parser , 'test');

	SM_AP04_FacturesApiService.getResponse('tokentest', '0324566777', '4545') ;

	SM_AP04_FacturesApiService.FactureModel factureModel = new  SM_AP04_FacturesApiService.FactureModel('test','2018-09-18T14:27:06.8410095+02:00', String.valueOf(value), null) ;
	  
	Test.stopTest();
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
	  
	  SendFact_inputMap.put('ContextId', '0123459999');
	  SendFact_inputMap.put('IdBusinessPartner', '0206611333');
	  SendFact_inputMap.put('ContactFields', ContactFields);
	  SendFact_inputMap.put('getUrlFactures', '(url1, url2)');
	  SendFact_inputMap.put('getDateFactures', '(Facture du 01/04/2019, Facture du 02/04/2019)'); 
		
	  SendFact_inputMap.put('getUrlMandats', '(url4, url5, url6)');
		
		
		SM_AP04_FacturesApiService service = new  SM_AP04_FacturesApiService();
		
		service.invokeMethod('sendDuplicata',SendFact_inputMap, SendFact_outMap, null); 
		
	}
}