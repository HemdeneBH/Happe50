/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-07-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-31-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_AgentWorkHandler extends TriggerHandler {
    private List<AgentWork> newList;
    
    private Map<Id,AgentWork> newMap;
    private Map<Id,AgentWork> oldMap;
    public HP_AgentWorkHandler() {
        this.newList = (List<AgentWork>) Trigger.New;
        this.newMap = (Map<Id,AgentWork>) Trigger.newMap;
        this.oldMap = (Map<Id,AgentWork>) Trigger.oldMap;


    }

    public override void beforeInsert(){
       
       /* System.debug('HP_AgentWorkHandler before insert****:'+newList);*/
        
    }

    public override void afterInsert() {
       /* System.debug('3');
        System.debug('HP_AgentWorkHandler after insert****:'+newList);

        // ALIMENTER HP_CaseHistory__c lors de la creation des cases Happe

        List<HP_CaseHistory__c> caseHistoryList = new List<HP_CaseHistory__c>();
        System.debug('newList:'+newList);
        for(AgentWork agentWork : newList){
            System.debug('agentWork:'+agentWork);
                HP_CaseHistory__c caseHistory = new HP_CaseHistory__c();
                caseHistory.Case__c = agentWork.WorkItemId;
                caseHistory.HP_DateAttribution__c = DateTime.now();
                caseHistory.User__c = agentWork.UserId;
                caseHistoryList.add(caseHistory);
            }
        
            System.debug('caseHistoryList:'+caseHistoryList);
        if(caseHistoryList.size() > 0)  Database.insert(caseHistoryList);*/

    }
}