@isTest
global class SM_AP31_LocauxApiService_Ref_TEST {
	@isTest
	global static void test() {
		
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiLocal');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        system.debug('sendData mock : '+mock);
        Test.setMock(HttpCalloutMock.class, mock);
        
		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('idLocal',25972);
		
		Map<String,Object> outputMap = new Map<String,Object>();
		
		SM_AP31_LocauxApiService_Ref service = new SM_AP31_LocauxApiService_Ref() ;
		
		service.invokeMethod('callLocaux', inputMap,  outputMap, null) ;
		
	}
	
	
	@isTest
	global static void testGetIdLocal() {

		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('numeroLocal','0713911170');
		
		Map<String,Object> outputMap = new Map<String,Object>();
		
		SM_AP31_LocauxApiService_Ref service = new SM_AP31_LocauxApiService_Ref() ;
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('SM_MockResponseApiLocal');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, mock);
		
		// WHEN
		service.invokeMethod('getIdNewLocal', inputMap,  outputMap, null) ;
		
		//THEN 
		System.assertEquals('230195',outputMap.get('idLocal'));
		
	}
}