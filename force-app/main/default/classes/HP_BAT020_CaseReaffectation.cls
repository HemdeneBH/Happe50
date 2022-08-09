/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   06-04-2021   Antoine Latour   Initial Version
**/
global class HP_BAT020_CaseReaffectation implements Database.Batchable<sObject>, System.Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{

    global static void launchNewScheduler(String schedule,String jobName){
		  System.schedule(jobName, schedule, new HP_BAT020_CaseReaffectation());
    }

    global void execute(SchedulableContext sc){
		  execute();
    }
    
    public static void execute(){
		HP_BAT020_CaseReaffectation batch = new HP_BAT020_CaseReaffectation();
		Database.executeBatch(batch, 20); 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [SELECT Id, Status, OwnerId FROM Case 
            WHERE HP_isHappe__c = true 
            AND Owner.Type = 'USER'
            AND IsClosed = false 
            AND (HP_TreatmentDate__c < TODAY OR HP_TreatmentDate__c=null)]
        );
    }

    global void execute(Database.BatchableContext bc, List<Case> scope) {
        if(!scope.isEmpty()){
            System.debug('scope : ' + scope);
            HP_SM024_Case.reaffectCase(scope);
        }
    }

    global void finish(Database.BatchableContext bc){
    }
}