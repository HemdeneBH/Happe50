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
        
        List<AgentWork> agentWorkList = new List<agentWork>();
        agentWork  awork = new agentWork();
        Id queueNiveau1Id = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'HP_Niveau_1'].Id;
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => queueNiveau1Id,
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'HP_Em2Case_ContactDistributeur'
            }, null,null,null);
           
        insert c1;
        Case cas = [select Id from Case limit 1 ];
           //je sais que c'est pas propre :(
            for (ServiceChannel sc : [select Id from ServiceChannel limit 10]){
                try {
                    System.debug('sc:'+sc);
                    awork.ServiceChannelId = sc.Id;
                    awork.UserId = UserInfo.getUserId();
                    awork.WorkItemId = cas.Id;
                    agentWorkList.add(awork);
                    insert awork;
                    break;
                }catch(Exception e) {
                    System.debug(LoggingLevel.INFO, 'Service channel with id '+sc.Id+' is invalid');
                }
            }
        Test.startTest();
        HP_SM038_AgentWork.addCaseHistory(agentWorkList);
        Test.stopTest();        
    }
}