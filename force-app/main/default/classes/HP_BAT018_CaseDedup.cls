/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   22-02-2021   Antoine Latour   Initial Version
**/
global with sharing class HP_BAT018_CaseDedup implements  Database.Batchable<SObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
   
    public static final Integer BATCH_CHUNK_SIZE = 100;
    final String fields = 'Id, Contact.id_tiers__c, Status, Description, Subject, CreatedDate, SuppliedEmail, HP_isHappe__c';
    final String whereCondition = 'HP_isHappe__c = True and Status != \'CLOSED\' and Status != \'CANCELED\'';
    global String query = 'select ' + fields + ' from Case where ' + whereCondition;  

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT018_CaseDedup());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){
        HP_BAT018_CaseDedup batchCaseDedup = new HP_BAT018_CaseDedup();
        Database.executeBatch(batchCaseDedup, BATCH_CHUNK_SIZE);
    }

    global void execute(Database.BatchableContext bc, List<Case> casesList) { 
        HP_SM055_CaseDedup.updateDuplicatedCases(casesList);
    }

    global void finish(Database.BatchableContext bc){
        
    }
}