/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-04-2021   Antoine Latour   Initial Version
**/

global with sharing class HP_BAT018_CaseRappel implements  Database.Batchable<SObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
   
    public static final Integer BATCH_CHUNK_SIZE = 100;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        final Datetime tenDayAgo = Datetime.now().addDays(-10);
        return Database.getQueryLocator(
            [SELECT Id, Status FROM Case 
            WHERE HP_isHappe__c = true 
            AND IsClosed = false 
            AND HP_Type__c = 'HP_RappelLeadNonSigne'
            AND CreatedDate  <= :tenDayAgo]
        );    
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT018_CaseRappel());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){
        HP_BAT018_CaseRappel batchCaseDedup = new HP_BAT018_CaseRappel();
        Database.executeBatch(batchCaseDedup, BATCH_CHUNK_SIZE);
    }

    global void execute(Database.BatchableContext bc, List<Case> casesList) { 
        HP_SM059_SouscriptionRappel.closeOdlCases(casesList);
    }

    global void finish(Database.BatchableContext bc){
        
    }
}