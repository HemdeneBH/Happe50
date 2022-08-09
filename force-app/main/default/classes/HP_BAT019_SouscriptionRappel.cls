/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   06-04-2021   Antoine Latour   Initial Version
**/
global with sharing class HP_BAT019_SouscriptionRappel implements  Database.Batchable<SObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
   
    public static final Integer BATCH_CHUNK_SIZE = 100;

    final String fields = 'Id, HP_Contact__c';

    final String whereCondition = 'HP_DigitalDateSave2__c = YESTERDAY AND HP_Statut__c = \'SAVE_2_CONFIRMED\' AND HP_Canal_de_vente__c != \'TELEVENTE\'' ;
    global String query = 'select ' + fields + ' from HP_Souscription__c where ' + whereCondition;  

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT019_SouscriptionRappel());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){
        HP_BAT019_SouscriptionRappel batchCaseDedup = new HP_BAT019_SouscriptionRappel();
        Database.executeBatch(batchCaseDedup, BATCH_CHUNK_SIZE);
    }

    global void execute(Database.BatchableContext bc, List<HP_Souscription__c> souscriptionList) { 
        HP_SM059_SouscriptionRappel.createRappelCase(souscriptionList);
    }

    global void finish(Database.BatchableContext bc){
        
    }
}