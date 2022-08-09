/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   25-11-2020   Antoine Latour   Initial Version
**/
@isTest
public class HP_EM031_HPLogTech_TEST {
    
    @isTest static void buildHPLogTechFromAsyncApexJob(){
        String project = 'Happe';
        String status = 'Nouveau';
        String erreur = 'erreur_TEST';
        String type = 'type_TEST';
        String metadata = 'metadata_TEST';
        String message = 'message_TEST';
        String phase = 'phase_TEST';

        Test.startTest();
        HP_TECH_LOG__c techLog = HP_EM031_HPLogTech.buildHPLogTechFromAsyncApexJob(project, status, erreur, type, metadata, message, phase);
        Test.stopTest();

        System.assert(techLog.Project__c ==  project);
        System.assert(techLog.Status__c == status);
        System.assert(techLog.Metadata__c == metadata);
        System.assert(techLog.Type__c == type);
        System.assert(techLog.ErrorLine__c == erreur);          
        System.assert(techLog.ErrorMessage__c == message);
        System.assert(techLog.Phase__c == phase);
    }


    @isTest static void buildHPLogTechFromGenericApexError() {
       
        String project = 'Happe';
        String status = 'Nouveau';
        String type = 'type_TEST';
        String metadata = 'metadata_TEST';
        String comment = 'comment_TEST';
        
        Test.startTest();
        HP_TECH_LOG__c techLog = HP_EM031_HPLogTech.buildHPLogTechFromGenericApexError(project, status, metadata, type, comment);
        Test.stopTest();

        System.assert(techLog.Project__c ==  project);
        System.assert(techLog.Status__c == status);
        System.assert(techLog.Metadata__c == metadata);
        System.assert(techLog.Type__c == type);
        System.assert(techLog.Comment__c == comment);          
    }

    @istest static void buildHPLogTechFromEmailService() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();

        email.subject = 'HP_Create HPTECHLOG';
        email.toAddresses = new List<String>{'happe_crm_technique.esa@engie.com'};
        email.plainTextBody = 'FromEmail';
        env.fromAddress = 'ilovenagpur@gmail.com';

        Test.startTest();
        HP_TECH_LOG__c techLog = HP_EM031_HPLogTech.buildHPLogTechFromEmailService(email);
        Test.stopTest();

        System.assert(techLog.Project__c == 'Happe');
        System.assert(techLog.Status__c == 'Nouveau');
    }
}