@isTest
global class SM_CreerPersonne_Utilies_TEST {
	@isTest
	global static void globalTest() {
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object>outputMap = new Map<String, object>();
		inputMap.put('canalCommunication#telephone1', '0678954387');
        inputMap.put('canalCommunication#telephone4', '0167840246');
        inputMap.put('canalCommunication#mail7', 'test@gmail.com');
        inputMap.put('canalCommunication#type#code1', 'ZMT');
        inputMap.put('canalCommunication#type#code4', 'TEL');
        inputMap.put('canalCommunication#type#code7', 'INT');
        
        inputMap.put('profilMarketing#designation#code1', 'stopPhoning');
        inputMap.put('profilMarketing#valeurDesignation1', 'true');
        
        SM_CreerPersonne_Utilies service = new SM_CreerPersonne_Utilies();
		service.invokeMethod('transformInputsWS', inputMap,  outputMap, null);
        System.assertEquals(outputMap.size(), 2);
    }
}