/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-27-2021
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
            String rtDevNameCondition = '%'+[SELECT RecordType.DeveloperName,Id from Case where Id = :caseId limit 1 ].RecordType.DeveloperName+'%' ;
            caseActions = [SELECT DeveloperName, HP_Button_Label__c, HP_Has_Paramater__c, HP_Paramater__c, HP_Is_Active__c, HP_LWC_Name__c, HP_Order__c, HP_Record_Type__c,HP_Type__c from HP_Case_Action__mdt where HP_Record_Type__c like :rtDevNameCondition Order By HP_Order__c ASC];
            System.debug('HP_SM065_CaseActionsController.loadButtons() | Method Start');
            return caseActions;
            
        }catch (Exception ex) {
            System.debug('HP_SM065_CaseActionsController.loadButtons() | Error : ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }

}