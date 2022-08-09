public class SM_CTRL01_FreeServices {
    
    @AuraEnabled(cacheable=false)
    public static Map<String, Object> setEdocumentStatus(Map<String, Object> inputMap) {
        
        String procedureName = 'DR_SM_dematerialisationDocumentContractuel_Input_SOAP';
        
        Boolean eDocumentChoices = (Boolean)inputMap.get('eDocumentChoices');
        
        String eDocumentChoicesString;
        if(eDocumentChoices == true){
            eDocumentChoicesString = 'Oui';
        } else {
            eDocumentChoicesString = 'Non';
        }
        
        String refClientIdBP = (String)inputMap.get('refClientIdBP');
        
        Map<String, Object> ipInput = new Map<String, Object> ();
        ipInput.put('eDocumentChoices', eDocumentChoicesString);
        ipInput.put('refClientIdBP', refClientIdBP);
        
        Map<String, Object> ipOutput = new Map<String, Object> ();
        if(!Test.isRunningTest()){
            ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, null);
        } else {
            ipOutput.put('code', 'OCTOPUS_MAJPersonne_01');
        }
        
        return ipOutput;
    }
}