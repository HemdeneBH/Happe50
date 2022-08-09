/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-08-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   01-08-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public without sharing class HP_SM038_AgentWork_TEST {
    
    
    @isTest static void addCaseHistory(){
        
        HP_UTIL_SmartFactory.insertUserHP();
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Id queueNiveau1Id = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'HP_Niveau_1'].Id;
            Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
                'Status' => 'NEW_CASE',
                    'Priority' => 'High',
                    'OwnerId' => queueNiveau1Id,
                    'HP_TreatmentDate__c' => Date.today().addDays(-2),
                    'Origin' => 'HP_Em2Case_ContactDistributeur'
                    }, null,null,null);           
            insert c1;
            
            PendingServiceRouting psrObj = new PendingServiceRouting(
                CapacityWeight = 2,
                IsReadyForRouting = FALSE,
                RoutingModel  = 'MostAvailable',
                RoutingPriority = 1,
                RoutingType = 'SkillsBased',
                pushTimeout = 50,
                ServiceChannelId = [select Id from ServiceChannel where RelatedEntity = 'Case'].Id,
                WorkItemId = c1.Id
            );
            insert psrObj;   
            
            SkillRequirement srObj = new SkillRequirement(
                RelatedRecordId = psrObj.id,
                SkillId = [select Id from skill where DeveloperName = 'HP_Happe'].Id
            );
            insert srObj;
            
            AgentWork awork = new agentWork();
            try{                
                awork.ServiceChannelId = [select Id from ServiceChannel where RelatedEntity = 'Case'].Id;
                awork.UserId = UserInfo.getUserId();
                awork.WorkItemId = c1.Id;
                insert awork;
            }
            catch(Exception ex){
                //Exception will occur due to the omni channel bug. Ignore it
            }           
            
            Test.startTest();
            HP_SM038_AgentWork.addCaseHistory(new list<AgentWork>{awork});
            Test.stopTest();    
        }   
    }
}