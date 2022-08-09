/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-05-2021   Antoine Latour   Initial Version
**/
global class HP_BAT021_CaseOwnerHistory implements Database.Batchable<sObject>, System.Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{

    global static void launchNewScheduler(String schedule,String jobName){
		  System.schedule(jobName, schedule, new HP_BAT021_CaseOwnerHistory());
    }

    global void execute(SchedulableContext sc){
		  execute();
    }
    
    public static void execute(){
		HP_BAT021_CaseOwnerHistory batch = new HP_BAT021_CaseOwnerHistory();
		Database.executeBatch(batch, 20); 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [SELECT Id, IsClosed, HP_TECH_CaseOwnerHistoryCheck__c, CreatedDate FROM Case 
            WHERE HP_isHappe__c = true 
            AND HP_TECH_CaseOwnerHistoryCheck__c = false]
        );
    }

    global void execute(Database.BatchableContext bc, List<Case> scope) {
        if(!scope.isEmpty()){
            HP_SM060_CaseOwnerHistory.upsertCaseOwnerHistory(scope);
        }
    }

    global void finish(Database.BatchableContext bc){
    }
}