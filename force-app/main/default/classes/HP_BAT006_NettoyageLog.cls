/**
 * @File Name          : HP_BAT006_NettoyageLog.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 27/04/2020 à 13:31:46
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/03/2020   Mouhamadoune Coulibaly     Initial Version
**/
global   class HP_BAT006_NettoyageLog  implements Database.Batchable<sObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {

    public static final Integer BATCH_CHUNK_SIZE = 2000;
    DateTime nowDateTime = System.now();
    HP_Parameters__c param = [Select id,Cycle_Purge_Log__c from HP_Parameters__c];
    final Integer cyclepurge = (Integer)param.Cycle_Purge_Log__c;
    final DateTime periode = nowDateTime.addDays(- cyclepurge);
    final String dateTimeFormat = periode.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
    global final  String query = 'Select Id ,Date__c from HP_LOG_WS__c where Date__c <= :periode limit 40000';  
   
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT006_NettoyageLog());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }
    
    global static void execute(){
        HP_BAT006_NettoyageLog batchNettoyage = new HP_BAT006_NettoyageLog();
        Database.executeBatch(batchNettoyage, BATCH_CHUNK_SIZE);
    }
    global void execute(Database.BatchableContext bc, List<HP_LOG_WS__c> hpLogWS) { 
        delete hpLogWS;
       
    }
    global void finish(Database.BatchableContext bc){
        List<HP_LOG_WS__c> logList = [select id from HP_LOG_WS__c where Date__c <= :periode limit 1];
        if(logList.size() > 0) {
            Database.executeBatch(new HP_BAT006_NettoyageLog());
            return;
        }
        if(!Test.isRunningTest()){
            Database.executeBatch(new HP_BAT008_NettoyageLogCallOut());
        }
    }
}