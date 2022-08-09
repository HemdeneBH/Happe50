/**
 * @description       : Test class for the batch SM_BAT06_CaseTraitementDLP
 * @author            : FT2-AE
 * @group             : SMILE FT2
 * @last modified on  : 03-08-2022
 * @last modified by  : FT2-AE
**/
@IsTest
public with sharing class SM_BAT06_CaseTraitementDLP_Test {

    @testSetup 
    static void dataSetup() {
        Id ServiceRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(System.Label.SM_CL41_RT_Service).getRecordTypeId();
        // create Accounts
        Account acc = SM_TestDataFactory.createAccount('Smile_Account');
        Insert acc;
        Account acc2 = SM_TestDataFactory.createAccount('Smile_Account2');
        Insert acc2;
        Account acc3 = SM_TestDataFactory.createAccount('Smile_Account3');
        Insert acc3;
        // create Contacts
        Contact testContact = SM_TestDataFactory.createContact('testContact', acc.Id);
        testContact.Salutation='MR';
        testContact.Adresse_Mail_Principale__c='Adresse Mail 1';
        testContact.Email='EngieTest@TestEmail.com';
        insert testContact;
        Contact testContact2 = SM_TestDataFactory.createContact('testContact2', acc2.Id);
        testContact2.Salutation='MME';
        testContact2.MobilePhone='+33666663333';
        testContact2.Mobile_Principal__c='Mobile 1';
        insert testContact2;
        Contact testContact3 = SM_TestDataFactory.createContact('testContact3', acc3.Id);
        testContact3.Salutation='MME';
        insert testContact3;
        // Create Cases
        List<Case> casesToInsert = new List<Case>();
        Case testCase1 = SM_TestDataFactory.createCase('TEST1', acc.Id);
        testCase1.ContactId= testContact.Id;
        testCase1.RecordTypeId = ServiceRT;
        testCase1.Status=System.Label.SM_CL20_CaseStatusToBeProcessed;
        testCase1.SM_DLP__c=date.today();
        testCase1.Sous_type__c='Délai de paiement / plan d\'apurement';
        testCase1.Type='Paiement';
        testCase1.TECH_DPSendRefusStatusCode__c='';
        testCase1.SM_Adresse_Concernee__c='12 rue des bois 91000 Bis Paris';
        casesToInsert.add(testCase1);
        Case testCase2 = SM_TestDataFactory.createCase('TEST2', acc2.Id);
        testCase2.RecordTypeId = ServiceRT;
        testCase2.ContactId= testContact2.Id;
        testCase2.Status=System.Label.SM_CL20_CaseStatusToBeProcessed;
        testCase2.SM_DLP__c=date.today();
        testCase2.SM_Adresse_Concernee__c='22 rue des bois 92160 Paris';
        testCase2.Sous_type__c='Délai de paiement / plan d\'apurement';
        testCase2.Type='Paiement';
        testCase2.TECH_DPSendRefusStatusCode__c='';
        casesToInsert.add(testCase2);
        Case testCase3 = SM_TestDataFactory.createCase('TEST3', acc3.Id);
        testCase3.RecordTypeId = ServiceRT;
        testCase3.ContactId= testContact3.Id;
        testCase3.Status=System.Label.SM_CL20_CaseStatusToBeProcessed;
        testCase3.SM_DLP__c=date.today();
        testCase3.Sous_type__c='Délai de paiement / plan d\'apurement';
        testCase3.Type='Paiement';
        testCase3.SM_Adresse_Concernee__c='17 rue des fleurs 69000 Bis Lyon';
        testCase3.TECH_DPSendRefusStatusCode__c='';
        casesToInsert.add(testCase3);
        insert casesToInsert; 
    }
    @isTest 
    static void testBatchMethod() {
        SM_BAT06_CaseTraitementDLP batchClass=new SM_BAT06_CaseTraitementDLP();
        Test.startTest();
        database.executebatch(batchClass,200);
		Test.stopTest();
        Integer casesUpdated = [SELECT count() FROM Case 
                                WHERE Status =:System.Label.SM_CL21_Case_status_PreCloturee AND SM_StatusDuDelaiDePaiement__c='REFUS du Délai de Paiement' AND TECH_DPSendRefusStatusCode__c='EmailOuSMSEnvoye'];
        System.assertEquals(2, casesUpdated,'Batch Failed returning the 2 case updates for the cases requiring it');
        Case caseUpdated = [SELECT Id,Status,Sous_statut__c,SM_StatusDuDelaiDePaiement__c FROM Case 
                                WHERE subject='TEST1'];
        System.assertEquals(System.Label.SM_CL21_Case_status_PreCloturee,caseUpdated.status,'The status of the case is updated to the correct value');
        System.assertEquals(System.Label.SM_CL21_CaseSubStatusConforme,caseUpdated.Sous_statut__c, 'the sous status of the case is updated to the correct value');
        System.assertEquals('REFUS du Délai de Paiement',caseUpdated.SM_StatusDuDelaiDePaiement__c,'Status délai de paiement is updated to the correct value');
        Case caseDML = [SELECT Id,subject  FROM Case WHERE subject='TEST3'];
        caseDML.subject = 'TESTDMLKO';
        caseDML.Status = System.Label.SM_CL20_CaseStatusToBeProcessed;
        caseDML.SM_StatusDuDelaiDePaiement__c = '';
        caseDML.TECH_DPSendRefusStatusCode__c = '';
        update caseDML;
        Case caseSMS = [SELECT Id,subject  FROM Case WHERE subject='TEST2'];
        caseSMS.subject='TESTSMSKO';
        caseSMS.Status = System.Label.SM_CL20_CaseStatusToBeProcessed;
        caseSMS.SM_StatusDuDelaiDePaiement__c = '';
        caseSMS.TECH_DPSendRefusStatusCode__c='';
        update caseSMS;
        database.executebatch(batchClass,200);
    }
}