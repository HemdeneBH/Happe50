/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-22-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
@isTest
public with sharing class HP_SM065_CaseActionsController_TEST {
    @testSetup static void dataSetup(){
        
        Case testCase1 = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                'Description' => 'Description Test Case 1',
                'Subject' => 'TEST 1',
                'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Facturation'),
                'HP_Type__c' => 'HP_Coupure_ReductionPuissance',
                'HP_Contact_pb_paiement_factures__c' => true,
                'OwnerId' => UserInfo.getUserId(),
                'Status' => 'TO_DO'}, null);
        insert testCase1;

        Case testCase2 = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
            'Description' => 'Description Test Case 2',
            'Subject' => 'TEST 2',
            'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Facturation'),
            'HP_Type__c' => 'HP_RappelLeadNonSigne',
            'HP_Contact_pb_paiement_factures__c' => false,
            'OwnerId' => UserInfo.getUserId(),
            'Status' => 'TO_DO'}, null);
    insert testCase2;
    }
    
    @IsTest
    static void loadButtonsForCase1_TEST(){
        Case case1Record = [SELECT Id FROM Case WHERE Subject ='TEST 1' limit 1];
        Test.startTest();
        List<HP_Case_Action__mdt> results = HP_SM065_CaseActionsController.loadButtons(case1Record.Id);
        Test.stopTest();
        System.assert(results.size()>0);
    }

    @IsTest
    static void loadButtonsForCase2_TEST(){
        Case case2Record = [SELECT Id FROM Case WHERE Subject ='TEST 2' limit 1];
        Test.startTest();
        List<HP_Case_Action__mdt> results = HP_SM065_CaseActionsController.loadButtons(case2Record.Id);
        Test.stopTest();
        System.assert(results.size()>0);
    }

    @IsTest
    static void loadButtonsTESTNegative(){
        Test.startTest();
        try {
            List<HP_Case_Action__mdt> results = HP_SM065_CaseActionsController.loadButtons('0011');
        } catch (Exception ex) {
            System.assert(ex.getTypeName().contains('System'));
        }
        
        Test.stopTest();
        
    }
}