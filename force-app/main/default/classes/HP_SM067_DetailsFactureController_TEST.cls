/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 08-23-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_SM067_DetailsFactureController_TEST {
    @testSetup static void dataSetup(){
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_RappelLeadNonSigne', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='NEW_CASE',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='Service', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='DELAYED_PROCESS',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_CONTRACT_DATA', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='HP_PENDING',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_ENROLMENT_MOVING_OUT', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='CLOSED',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_BILLING', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='CANCELED',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_TECHNICAL_ISSUE', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='HP_Refused',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='INVALID_DATA', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='Escaladé (happe)',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_RappelLeadNonSigne', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='CONTRACT_CANCELATION', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_INFORMATION', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_MANUAL_PROCESS', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_Contractualization', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_Chat', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_AUTOMATED_PROCESS', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_SouscriptionDigital', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_Form_Site', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_Flux_GRD', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_INSATISFACTION_CLIENT', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_Mediation', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_TIC_TAC', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_Appel_Diabolocom', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        caseList.add(new Case(Status ='TO_DO',HP_Numero_de_facture__c ='FACT367350', HP_Type__c ='HP_Rappel_planifie', Description = 'Description Test',Subject = 'TEST',RecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone')));
        insert caseList;
    }

    @IsTest
    static void getRelatedCasesByRefFactureTest(){
        
        Test.startTest();
        List<HP_SM067_DetailsFactureController.HP_WRP042_RelatedCasesFactures> resultList = HP_SM067_DetailsFactureController.getRelatedCasesByRefFacture('FACT367350');
        Test.stopTest();
        System.assert(resultList.size()>0);
        
    }
}