@isTest
global class SM_AP86_FillInteractionDetails_Test {
    
    @isTest
    global static void testInteractionDetails() {
        Map<String , object>inputMap = new Map<String, object>() ;
        Map<String , object>outMap = new Map<String, object>() ;
        Map<String , object>inputMapParam = new Map<String, object>() ;
        inputMapParam.put('value1','value1');
            
        inputMap.put('parcours', 'acquisition') ;
        inputMap.put('interactionDetailsParam', inputMapParam) ;

        SM_AP86_FillInteractionDetails interactionDetails = new SM_AP86_FillInteractionDetails();
        
        interactionDetails.invokeMethod('FillInteractionDetails', inputMap, outMap,null);
        
        
    }
}