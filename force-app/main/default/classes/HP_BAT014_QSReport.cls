/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   17-11-2020   Antoine Latour   Initial Version
**/
global with sharing class HP_BAT014_QSReport implements  Database.Batchable<SObject>, Schedulable, Database.RaisesPlatformEvents, HP_UTIL_BatchInterface {
    
    public static final Integer BATCH_CHUNK_SIZE = 100;
    
    global String query = 'select Id,HP_TECH_Incoming__c,ReplyToEmailMessageId,HP_QS24__c,HP_QS48__c,HP_ResponseDate__c,ParentId,CreatedById,CreatedDate from EmailMessage';  
    
    public HP_BAT014_QSReport() {
        query = query + ' where HP_isHappe__c = true AND CreatedDate = today';
    }

    public HP_BAT014_QSReport(Date selectedDate) {
        Datetime toFormatDate = selectedDate;
        String dateFormat = toFormatDate.formatGmt('yyyy-MM-dd');
        query = query + ' where HP_isHappe__c = true AND DAY_ONLY(CreatedDate) = ' + dateFormat;
        System.debug('Query : ' + query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_BAT014_QSReport());
    }

    global static void execute(SchedulableContext sc){
        execute();
    }
    
    global static void execute(Date selectedDate) {
        HP_BAT014_QSReport batchQSReport = new HP_BAT014_QSReport(selectedDate);
        Database.executeBatch(batchQSReport, BATCH_CHUNK_SIZE);
    }

    global static void execute(){
        HP_BAT014_QSReport batchQSReport = new HP_BAT014_QSReport();
        Database.executeBatch(batchQSReport, BATCH_CHUNK_SIZE);
    }
    global void execute(Database.BatchableContext bc, List<EmailMessage> emailList) { 
        System.debug('*******list emailmessage:***'+ emailList);
        HP_SM047_QSReport.updateQSResponseTime(emailList);
    }

    global void finish(Database.BatchableContext bc){
        
    }

}