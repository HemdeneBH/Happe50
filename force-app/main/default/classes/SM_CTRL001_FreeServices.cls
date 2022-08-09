/**
 * @description       : LWC Controller for free services screen
 * @author            : David Attali
 * @group             : 
 * @last modified on  : 10-26-2020
 * @last modified by  : David ATTALI
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   10-26-2020   David ATTALI    Initial Version
**/
public class SM_CTRL001_FreeServices {
    
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

    @AuraEnabled(cacheable=true)
    public static Map<String, Object>  getKnowledge(Map<String, Object> inputMap) {

        String felMigrationKey = (String)inputMap.get('felMigrationKey');
        String eDocumentMigrationKey = (String)inputMap.get('eDocumentMigrationKey');

        List<Knowledge__kav> knowledges = [SELECT Cle_Migration__c, Consigne__c FROM Knowledge__kav
        WHERE RecordType.DeveloperName = 'Insert_Omniscript' AND PublishStatus = 'Online'
        AND Cle_Migration__c IN (:felMigrationKey, :eDocumentMigrationKey)];
        
        Map<String, Object> mapMigrationKeyToInstruction = new Map<String, Object>();
        
        for(Knowledge__kav knowledge : knowledges){
            if(knowledge.Cle_Migration__c == '000001045'){
                mapMigrationKeyToInstruction.put('felInstruction', knowledge.Consigne__c);
            } else if(knowledge.Cle_Migration__c == '000001405'){
                mapMigrationKeyToInstruction.put('eDocumentInstruction', knowledge.Consigne__c);
            }
        }

        return mapMigrationKeyToInstruction;
    }
}