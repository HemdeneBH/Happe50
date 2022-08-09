@isTest
global class SM_AP85_DisplayDecimals_TEST {
    
    @isTest
	global static void DisplayDecimals_TEST() {
        
        Test.starttest();
		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('offrePrix', 15.50);
		Map<String , object>outputMap = new Map<String, object>() ;
		SM_AP85_DisplayDecimals service = new SM_AP85_DisplayDecimals() ;
        service.invokeMethod('calculMaxMin',inputMap, outputMap, null);
		Test.stopTest();
        
        
    }

}