@isTest
global class SM_AP80_CodePostauxVilles_Test {
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
		inputMap.put('ville','Bagneux');
		inputMap.put('codePostal','');
		Map<String,Object> outputMap = new Map<String,Object>();
		
		SM_AP80_CodePostauxVilles service = new SM_AP80_CodePostauxVilles() ;
		
		service.invokeMethod('codePostauxVilles', inputMap,  outputMap, null) ;
		
	}
}