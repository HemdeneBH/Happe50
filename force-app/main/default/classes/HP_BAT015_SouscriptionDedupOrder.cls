/**
 * @description       : 
 * @author            : Ali AJELLAL
 * @last modified on  : 03-23-2021
 * Modifications Log 
 * 1.0   12-02-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

global with sharing class HP_BAT015_SouscriptionDedupOrder implements  Database.Batchable<SObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
   
    public static final Integer BATCH_CHUNK_SIZE = 100;
    public static Date dateQuery = System.now().date().addDays(-30);
    private Date  souscriptionDate;

    global String query = 'select id , HP_NumPDL__c, HP_NumberPCE__c, HP_TECH_FormulaConcatField__c, HP_Statut__c from hp_souscription__c';  


    public HP_BAT015_SouscriptionDedupOrder() {
    
        query = query + '  where  DAY_ONLY(HP_Date_Origine__c ) >= :dateQuery';
        souscriptionDate = dateQuery;

    }

    public HP_BAT015_SouscriptionDedupOrder(Date selectedDate) {
        Datetime toFormatDate = selectedDate;
        souscriptionDate = selectedDate;
        String dateFormat = toFormatDate.formatGmt('yyyy-MM-dd');
        query = query + ' where  DAY_ONLY(HP_Date_Origine__c ) >= ' + dateFormat;
        System.debug('Query : ' + query);
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT015_SouscriptionDedupOrder());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }

    global static void execute(){
        HP_BAT015_SouscriptionDedupOrder batchQsouscriptionDedupOrder = new HP_BAT015_SouscriptionDedupOrder();
        Database.executeBatch(batchQsouscriptionDedupOrder, BATCH_CHUNK_SIZE);
    }

    global static void execute(Date selectedDate) {
        HP_BAT015_SouscriptionDedupOrder batchQsouscriptionDedupOrder = new HP_BAT015_SouscriptionDedupOrder(selectedDate);
        Database.executeBatch(batchQsouscriptionDedupOrder, BATCH_CHUNK_SIZE);
    }

    global void execute(Database.BatchableContext bc, List<hp_souscription__c> souscriptions) { 
        System.debug('*******list usesouscriptionsrs:***'+souscriptions);
       HP_SM048_SouscriptionDedupOrder.updateSouscriptionWithHighestStatus(souscriptions, souscriptionDate);
    }


    global void finish(Database.BatchableContext bc){
        
    }

}