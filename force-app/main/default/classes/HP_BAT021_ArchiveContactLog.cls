/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-10-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

global class HP_BAT021_ArchiveContactLog implements Database.Batchable<sObject>, System.Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface{

    public static final Integer BATCH_CHUNK_SIZE = 1;

    
    global String query = 'select id,AccountId, name from contact where name =\'Tel Sans Contact Diabolocom\'' ;  

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT021_ArchiveContactLog());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){
        HP_BAT021_ArchiveContactLog archiveContact = new HP_BAT021_ArchiveContactLog();
        Database.executeBatch(archiveContact, BATCH_CHUNK_SIZE);
    }

    global void execute(Database.BatchableContext bc, List<contact> contacts) { 
        System.debug('contacts :'+ contacts);
        HP_SM61_ArchiveContactLog.archiveContact(contacts);
    }

    global void finish(Database.BatchableContext bc){
        
    }   
}