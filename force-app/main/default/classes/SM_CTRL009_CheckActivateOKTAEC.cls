global class SM_CTRL009_CheckActivateOKTAEC implements vlocity_cmt.VlocityOpenInterface {
    /*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 19/10/2021
* @Description: check if creation EC is activated in OKTA 
*/
    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        
        if (methodName.equals('checkActivateOKTAEC')) {
            try {
                
                outMap.put('Activer_OKTAEC', checkActivateOKTAEC());
                
            } catch (Exception ex) {
                System.debug(ex);
                return false;
            }
        }
        
        return true;
    }
    @AuraEnabled(cacheable=true)
    public static Boolean checkActivateOKTAEC() {    
        return [select id,Activer_OKTAEC__c from activateOKTAEC__mdt limit 1].Activer_OKTAEC__c;
        
    }     
}