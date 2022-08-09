@isTest
public with sharing class SM_RGPD_PurgeDonneesInvocable_TEST {
    @testSetup 
    static void dataSetup() {
        Id serviceRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
        
        // create Account
        Account acc = SM_TestDataFactory.createAccount('Smile_Account');
        Insert acc;

        // create Contact
        Contact testContact = SM_TestDataFactory.createContact('testContact', acc.Id);
        Insert testContact;

        // Create Cases
        Case testCase = SM_TestDataFactory.createCase('TEST', acc.Id);
        Insert testCase;

        // create an Email Message
        EmailMessage emg = SM_TestDataFactory.createEmailMessage(acc.Id, testCase.Id, new List<Id>{testContact.id}, 'test@test.com', '0', 'fromAddress@test.com', 'TEST', 'TEST', 'TEST');
        emg.Case__c = testCase.Id;
        insert emg;

        // Create donneé vente
        Donnees_Vente__c dv = SM_TestDataFactory.createDonneeVente(testCase.Id,'Cergy','ABCD','52','Avenue des loups', '95800');
        insert dv;

        // Create order
        Order testOrder = new Order(AccountId=acc.Id,Case__c = testCase.Id, Numero_PC__c='01234',type__c = 'Gaz',EffectiveDate = Date.today(), Status = 'Draft');
        insert testOrder;

        
        MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
        endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
        endpoint.Name = 'api_endpoint';
        insert endpoint;
        
        MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
        sm_api_version.Value__c = '0.1';
        sm_api_version.Name = 'sm_api_version';
        insert sm_api_version;
        
        MP_Xdata_credentials__c sm_api_key = new MP_Xdata_credentials__c();
        sm_api_key.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        sm_api_key.Name = 'sm_api_key_INT';
        insert sm_api_key;


    }
    @isTest
    public static void sM_RGPD_PurgeDonneesInvocable_Test(){

        List<Case> caseList = [SELECT id FROM Case Limit 1];
        List<Contact> contactList = [SELECT id FROM Contact Limit 1];
        SM_RGPD_PurgeDonneesInvocable.Requests request = new SM_RGPD_PurgeDonneesInvocable.Requests();
        request.operation='DeleteRelatedRecords';
        request.contactId=(contactList.size()>0)?contactList[0].Id:'';
        request.casesList=caseList;
        request.tasksList=null;
        Test.startTest();
        SM_RGPD_PurgeDonneesInvocable.execute(new List<SM_RGPD_PurgeDonneesInvocable.Requests>{request});
        Test.stopTest();
        List<EmailMessage> emailMessageList = [SELECT id FROM EmailMessage];
        List<Donnees_Vente__c> donneesVenteList = [SELECT id FROM Donnees_Vente__c];
        List<Order> orderList = [SELECT id FROM Order];

        //vérifier que les enregistrements sont supprimés
        System.assertEquals(0, emailMessageList.size());
        System.assertEquals(0, donneesVenteList.size());
        System.assertEquals(0, orderList.size());
    }
    
    @isTest
    public static void sM_RGPD_sendConfirmation_Test(){

       	SM_RGPD_PurgeDonneesInvocable.Requests request = new SM_RGPD_PurgeDonneesInvocable.Requests();
        request.operation='sendConfirmation';
        request.eventObject=new RGPD_PurgeDonneesIdentification__e();
        Test.startTest();
        SM_RGPD_PurgeDonneesInvocable.execute(new List<SM_RGPD_PurgeDonneesInvocable.Requests>{request});
        Test.stopTest();
        List<SyncEventLog__c> listSyncEventLog = [Select id From SyncEventLog__c limit 1];
        System.assertEquals(0, listSyncEventLog.size());
    }
}