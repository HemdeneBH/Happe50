/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-11-2022
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                 Modification
 * 1.0   07-22-2021   Hemdene Ben Hammouda   Initial Version
**/
public with sharing class HP_SM065_CaseActionsController {

    @AuraEnabled(cacheable=true)
    public static List<HP_Case_Action__mdt> loadButtons(String caseId){
        System.debug('HP_SM065_CaseActionsController.loadButtons() | Method Start');
        List<HP_Case_Action__mdt> caseActions = new List<HP_Case_Action__mdt>(); 
        try{
            Case c = [SELECT Id, RecordTypeId, RecordType.DeveloperName, HP_Type__c, HP_Contact_pb_paiement_factures__c from Case where Id = :caseId limit 1];
           
            String rtDevNameCondition = '%'+c.RecordType.DeveloperName+'%' ;
            caseActions = [SELECT DeveloperName, HP_Button_Label__c, HP_Has_Paramater__c, HP_Paramater__c, HP_Is_Active__c, HP_LWC_Name__c, HP_Order__c, HP_Record_Type__c,HP_Type__c from HP_Case_Action__mdt where HP_Record_Type__c like :rtDevNameCondition Order By HP_Order__c ASC];
            
            for (Integer i = (caseActions.size()-1) ; i>= 0 ; i--){
                if (c.HP_Type__c =='HP_Coupure_ReductionPuissance') {
                    if(caseActions[i].DeveloperName == 'HP_Traitement_Preliminaire' && c.HP_Contact_pb_paiement_factures__c == true){
                        caseActions.remove(i);
                        continue;
                    }
                } else {
                    if(caseActions[i].DeveloperName == 'HP_Traitement_Preliminaire' || caseActions[i].DeveloperName == 'HP_Inversion_PDL'){
                        caseActions.remove(i);
                        continue;
                    }
                }
                
                if(c.HP_Type__c != 'HP_Retablissement' && caseActions[i].DeveloperName == 'HP_Retablissement') {
                    caseActions.remove(i);
                    continue;
                }
            } 

            return caseActions;
        }catch (Exception ex) {
            System.debug('HP_SM065_CaseActionsController.loadButtons() | Error : ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

}