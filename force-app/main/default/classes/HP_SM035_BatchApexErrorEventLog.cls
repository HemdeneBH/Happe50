/**
 * @description       : Service Manager spécifique à BatchApexErrorEvent

 * @author            : Vincent Albiser
 * @group             : 
 * @last modified on  : 08-18-2020
 * @last modified by  : Vincent Albiser

 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   07-09-2020   Sara El-Hannaoui   Initial Version
**/
public with sharing class HP_SM035_BatchApexErrorEventLog {
  
    public static void insertLog(List<BatchApexErrorEvent> events){
        Set<Id> asyncApexJobIds = new Set<Id>();
        for(BatchApexErrorEvent evt: events){
            asyncApexJobIds.add(evt.AsyncApexJobId);
        }
    
        Map<Id,AsyncApexJob> jobs = new Map<Id,AsyncApexJob>(
            [SELECT id, ApexClass.Name, JobType, Status FROM AsyncApexJob WHERE Id IN :asyncApexJobIds]
        );
    
        List<HP_TECH_LOG__c> records = new List<HP_TECH_LOG__c>();
    
        for(BatchApexErrorEvent evt : events){  
            String project = jobs.get(evt.AsyncApexJobId).ApexClass.Name.startsWith('HP') ? 'Happe' : jobs.get(evt.AsyncApexJobId).ApexClass.Name.startsWith('SM') ? 'Smile' : 'Non identifié';

            HP_TECH_LOG__c log = HP_EM031_HPLogTech.buildHPLogTechFromAsyncApexJob(project,jobs.get(evt.AsyncApexJobId).status, evt.StackTrace, jobs.get(evt.AsyncApexJobId).JobType ,jobs.get(evt.AsyncApexJobId).ApexClass.Name, evt.ExceptionType+' '+ evt.Message ,evt.Phase);

            records.add(log);        
        }
        upsert records;
    }
}