/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-27-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_SM065_CaseActionsController_TEST {
    @testSetup static void dataSetup(){
        
        Case mailCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                'Description' => 'Description Test',
                'Subject' => 'TEST',
                'HP_Type__c' => 'HP_RappelLeadNonSigne',
                'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
                'OwnerId' => UserInfo.getUserId(),
                'Status' => 'TO_DO'}, null);
        insert mailCase;
    }
    
    @IsTest
    static void loadButtonsTEST(){
        Case caseRecord = [SELECT Id from Case limit 1];
        Test.startTest();
        List<HP_Case_Action__mdt> results = HP_SM065_CaseActionsController.loadButtons(caseRecord.Id);
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