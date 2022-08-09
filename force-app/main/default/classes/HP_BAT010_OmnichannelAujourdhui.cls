/**
 * @File Name          : HP_BAT010_OmnichannelAujourdhui.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 16/06/2020 à 00:45:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/06/2020   Vincent Albiser     Initial Version
**/
global class HP_BAT010_OmnichannelAujourdhui implements Database.Batchable<sObject>, System.Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{

    global static void launchNewScheduler(String schedule,String jobName){
		  System.schedule(jobName, schedule, new HP_BAT010_OmnichannelAujourdhui());
    }

    global void execute(SchedulableContext sc){
		  execute();
    }
    
    public static void execute(){
		HP_BAT010_OmnichannelAujourdhui batch = new HP_BAT010_OmnichannelAujourdhui();
		Database.executeBatch(batch, 20); 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Set<Id> queueIds = HP_Util_QueueManager.getQueueMapById().keySet();
        Time currentTimePlus15 = System.now().time().addMinutes(15);




        return Database.getQueryLocator(
            [SELECT Id FROM Case 
            WHERE HP_isHappe__c = true 
            AND IsClosed = false 
            AND OwnerId IN : queueIds 
            AND (HP_TreatmentDate__c = null OR HP_TreatmentDate__c <= TODAY)
            AND (HP_TreatmentTime__c = null OR HP_TreatmentTime__c <= :currentTimePlus15)]
        );
    }

    global void execute(Database.BatchableContext bc, List<Case> scope) {

        List<String> casesId = new List<String>();
        for(Case c : scope){
            casesId.add(c.Id);
        }
        if(!casesId.isEmpty()){
            HP_SM032_OmnichannelSkillsRoutage.routeUsingSkills(casesId);
        }
    }

    global void finish(Database.BatchableContext bc){
    }
}