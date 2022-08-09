@isTest
private class SM_CTRL002_CustomFunctionImpl_TEST{


	@isTest static void testTransformPrice() {
		Test.starttest();
        SM_CTRL002_CustomFunctionImpl service = new SM_CTRL002_CustomFunctionImpl() ;
        
		Map<String , object>inputMap = new Map<String, object>() ;
		inputMap.put('arguments', new List<Object>{12.9, 2});
		Map<String , object> outputMap = new Map<String, object>() ;
		service.invokeMethod('transformPrice',inputMap, outputMap, null);
		System.assertEquals('12,90', outputMap.get('result'));
        
        
        Map<String , object> inputMap2 = new Map<String, object>() ;
        Map<String , object> outputMap2 = new Map<String, object>() ;
        inputMap2.put('arguments', new List<Object>{'Test Body Jason'});
        service.invokeMethod('stringBlob',inputMap2, outputMap2, null);


        

        Map<String , object> inputMap3 = new Map<String, object>() ;
        Map<String , object> outputMap3 = new Map<String, object>() ;
        Map<String, Object> arguments1 = new Map<String, Object>{'VLOCITY-FORMULA-LIST' => new List<Object>{'502511667170', '502511667171'}};
            Map<String, Object> arguments2 = new Map<String, Object>{'VLOCITY-FORMULA-LIST' => new List<Object>{'502511667170'}};
                inputMap3.put('arguments', new List<Object>{arguments1,arguments2});
        System.assertEquals(true,service.invokeMethod('checkListInAnother',inputMap3, outputMap3, null));
        



		Test.stopTest();
        
		
        
        
	}
    
    @isTest static void base64Decode() {
        
        
        // no System.runAs because no need for data
        
        //test data 
        String testString    = 'test';
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(testString));
        
		//declare input variables for invokeMethod
        String methodName              =  'base64Decode';
        Map<String , object> inputMap  = new Map<String, object>{
            'arguments' => new List<Object>{encodedString}
        } ;
        Map<String , object> outputMap = new Map<String, object>() ;
        Map<String , object> options   = new Map<String, object>() ;
        
        SM_CTRL002_CustomFunctionImpl service = new SM_CTRL002_CustomFunctionImpl() ;
        service.invokeMethod(methodName, inputMap, outputMap, options);
            
        //check data
        System.assertEquals(testString, String.valueOf(outputMap.get('result')));
        
    }


}