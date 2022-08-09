@isTest
global class SM_IndexElec_Utilies_Test {
   
    @isTest
    global static void globalTest() {
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object> outputMap = new Map<String, object>();
		inputMap.put('cadran#code1', 'test');
        inputMap.put('index#valeur1', 'test');
        inputMap.put('index#passageAzero', 'test');
        
        
        SM_IndexElec_Utilies service = new SM_IndexElec_Utilies();
		service.invokeMethod('transformInputsWS', inputMap,  outputMap, null);
        System.assertEquals(outputMap.size(), 1);
        
        service.invokeMethod('inconnu', inputMap,  outputMap, null);
    }

}