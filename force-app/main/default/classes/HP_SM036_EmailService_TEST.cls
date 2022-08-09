@isTest
public with sharing class HP_SM036_EmailService_TEST {
    
    @isTest
    static public void handleInboundEmail_TEST() {
    	Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();

        email.subject = 'Create HPTECHLOG';
        email.toAddresses = new List<String>{'happe_crm_technique.esa@engie.com'};
        email.plainTextBody = 'FromEmail';
        env.fromAddress = 'ilovenagpur@gmail.com';
        

        Test.startTest();
        HP_SM036_EmailService creatLog = new HP_SM036_EmailService();
        creatLog.handleInboundEmail(email, env);
        Test.stopTest();
        List<HP_TECH_LOG__c> listLog = [select Id from HP_TECH_LOG__c];
        System.assert(listLog.size() == 1);
    }
}