/**
 * @description       : EM de HP_TECH_LOG__c 
 * @author            : Vincent Albiser
 * @group             : 
 * @last modified on  : 08-18-2020
 * @last modified by  : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   07-15-2020   Sara El-Hannaoui   Initial Version
**/
public with sharing class HP_EM031_HPLogTech {

    public static HP_TECH_LOG__c buildHPLogTechFromAsyncApexJob(String project, String status, String erreur, String type, String metadata, String message, String phase) {
       
        HP_TECH_LOG__c log = new HP_TECH_LOG__c();
        log.Project__c =  project;
        log.Status__c = 'Nouveau';
        log.Metadata__c  = metadata;
        log.Type__c = type;

        //specific
        log.ErrorLine__c = erreur;                
        log.ErrorMessage__c =  message;
        log.Phase__c = phase;

        return log;
    }

    public static HP_TECH_LOG__c buildHPLogTechFromGenericApexError(String  projet, String status, String metadata, String type, String comment) {
       
        HP_TECH_LOG__c log = new HP_TECH_LOG__c();
        log.Project__c =  projet;
        log.Status__c = status;
        log.Metadata__c  = metadata;
        log.Type__c = type;
        log.Comment__c = comment;
        return log;
    }

    public static HP_TECH_LOG__c buildHPLogTechFromEmailService(Messaging.InboundEmail email){

        String project  = email.subject.contains('HP_') ? 'Happe' : email.subject.contains('SM_') ? 'Smile' : 'Non identifié';
        String metadata  = email.subject.subStringBetween('"') != null ? email.subject.subStringBetween('"')  :email.subject.subStringBetween(':');
        String body = !String.isBlank(email.htmlBody) ? email.htmlBody : email.plainTextBody;
        String type = email.subject.contains('Une erreur s\'est produite durant le flux') || email.subject.contains('Error Occurred During Flow') ? 'Process Builder' : '';				
        		        
        HP_TECH_LOG__c log = new HP_TECH_LOG__c();
        log.Project__c =  project;
        log.Status__c = 'Nouveau';
        log.Metadata__c = metadata;
        log.Type__c = type;

        //specific    
        log.EmailSubject__c = email.subject;    
        log.EmailBody__c = body;

        return log;
    }
    
}