/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   12-11-2020   Antoine Latour   Initial Version
**/
@isTest 

public with sharing class HP_EM037_AgentWork_TEST {

    @isTest 
    public static void getAgentWork() {

    
        Id queueNiveau1Id = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'HP_Niveau_1'].Id;
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => queueNiveau1Id,
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur'
            }, null,null,null);
           
        insert c1;
         
        AgentWork awork = new AgentWork();
        awork.WorkItemId = c1.Id;

        //je sais que c'est pas propre :(
        for (ServiceChannel sc : [select Id from ServiceChannel limit 10]){
            try {
                System.debug('sc:'+sc);
                awork.ServiceChannelId = sc.Id;
                awork.UserId = UserInfo.getUserId();
                insert awork;
                break;
            }catch(Exception e) {
                System.debug(LoggingLevel.INFO, 'Service channel with id '+sc.Id+' is invalid');
            }
        }
       
        Test.startTest();
        HP_EM037_AgentWork.getAgentWork(queueNiveau1Id, 'Assigned');
        Test.stopTest();
    }

    @istest 
    public static void deleteAgentWork() {
        Id queueNiveau1Id = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperNAME = 'HP_Niveau_1'].Id;
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'OwnerId' => queueNiveau1Id,
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur'
            }, null,null,null);
           
        insert c1;

        PendingServiceRouting psrObj = new PendingServiceRouting(
                CapacityWeight = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_OMNI_CaseWeight')),
                IsReadyForRouting = FALSE,
                RoutingModel  = 'MostAvailable',
                RoutingPriority = 3,
                RoutingType = 'SkillsBased',
                pushTimeout = 60,
                WorkItemId = c1.Id,
                SecondaryRoutingPriority = HP_Constantes.CASE_PRIORITY_ROUTING.get(c1.Priority)
        );

        AgentWork awork = new AgentWork();
        awork.WorkItemId = c1.Id;
        
        for (ServiceChannel sc : [select Id from ServiceChannel limit 10]){
            try {
                System.debug('sc:'+sc);
                psrObj.ServiceChannelId = sc.Id;
                awork.ServiceChannelId = sc.Id;
                awork.UserId = UserInfo.getUserId();
                insert psrObj;
                awork.PendingServiceRoutingId = psrObj.Id;
                insert awork;
                break;
            }catch(Exception e) {
                System.debug(LoggingLevel.INFO, 'Service channel with id '+sc.Id+' is invalid');
            }
        }
        
        Set<Id> psrIds = new Set<Id>();
        psrIds.add(psrObj.Id);

        Test.startTest();
        HP_EM037_AgentWork.deleteAgentWorkListFromPendingServiceRoutingIds(psrIds);
        Test.stopTest();

    }
}