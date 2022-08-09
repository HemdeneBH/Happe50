/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 01-12-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   12-08-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public without sharing class HP_SM038_AgentWork {
    
    @InvocableMethod
    public static void addCaseHistory(List<AgentWork> agentWorkList){
        System.debug('111');
        
        List<HP_CaseHistory__c> caseHistoryList = new List<HP_CaseHistory__c>();
        String userId = UserInfo.getUserId();
        String userAssigne;
        
        for(AgentWork agentWork : agentWorkList){
            HP_CaseHistory__c caseHistory = new HP_CaseHistory__c();
            boolean isQqueue =  string.valueOf(agentWork.UserId).startsWith('00G');
            
            if(agentWork.Status =='Opened' && agentWork.UserId == userId && !isQqueue ){
                caseHistory = HP_EM036_CaseHistory.creatCaseHistory(null,agentWork, false );
                caseHistoryList.add(caseHistory);
                userAssigne = agentWork.UserId;
            }
        }
        System.debug('caseHistoryList:'+caseHistoryList);
        if(caseHistoryList.size() > 0)  Database.insert(caseHistoryList);
        
        Set<Id> ids = new Set<Id>();
        for (AgentWork agentWork : agentWorkList) {
            ids.add(agentWork.WorkItemId);
        }
        System.debug('******ids**********:'+ids);
		createCaseSkills(ids, userAssigne);        
    }
    
    //trick pour pouvoir appeler cette méthode dans une classe de test
    public static void createCaseSkills(Set<Id> ids, Id userId){
        
        List<HP_CaseSkill__c> caseSkills = new List<HP_CaseSkill__c>();
        List<PendingServiceRouting> existingPsrList = [SELECT Id, WorkItemId, (select id, Skill.DeveloperName from SkillRequirements) FROM PendingServiceRouting WHERE WorkItemId IN :ids];
        
        for (PendingServiceRouting exist : existingPsrList) {
            
            for(SkillRequirement skreq : exist.SkillRequirements){
                HP_CaseSkill__c caseSkill = new HP_CaseSkill__c();
                caseSkill.Case__c = exist.WorkItemId;
                caseSkill.User_assign__c = userId;
                caseSkill.Skill_label__c = skreq.Skill.DeveloperName;
                System.debug('******skreq.Skill.DeveloperName**********:'+skreq.Skill.DeveloperName);
                
                caseSkills.add(caseSkill);
            }            
        }
        
        System.debug('******does caseSkills**********:'+caseSkills);
        if(caseSkills.size()>0) Database.insert(caseSkills);
    }
}