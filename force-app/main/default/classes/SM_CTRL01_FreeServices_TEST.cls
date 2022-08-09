@isTest
private class SM_CTRL01_FreeServices_TEST {
    
    @isTest
    static void testSetEdocumentStatus_Activate() {
        
        Map<String, Object> inputMap = new Map<String, Object> ();
        
        inputMap.put('eDocumentChoices', true);
        inputMap.put('refClientIdBP', '0312376423');
        
        Test.startTest();
        Map<String, Object> response = SM_CTRL01_FreeServices.setEdocumentStatus(inputMap);
        Test.stopTest();
        
        System.assertEquals('OCTOPUS_MAJPersonne_01', response.get('code'));
    }
    
    @isTest
    static void testSetEdocumentStatus_Desactivate() {
        
        Map<String, Object> inputMap = new Map<String, Object> ();
        
        inputMap.put('eDocumentChoices', false);
        inputMap.put('refClientIdBP', '0312376423');
        
        Test.startTest();
        Map<String, Object> response = SM_CTRL01_FreeServices.setEdocumentStatus(inputMap);
        Test.stopTest();
        
        System.assertEquals('OCTOPUS_MAJPersonne_01', response.get('code'));
    }
}