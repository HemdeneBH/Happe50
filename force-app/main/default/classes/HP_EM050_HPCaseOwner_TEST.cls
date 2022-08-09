/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-05-2021   Antoine Latour   Initial Version
**/

@IsTest
public inherited sharing class HP_EM050_HPCaseOwner_TEST {
    
    @testSetup static void dataSetup(){
        
        Case mailCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                'Description' => 'Description Test',
                'Subject' => 'TEST',
                'HP_Type__c' => 'HP_RappelLeadNonSigne',
                'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
                'OwnerId' => UserInfo.getUserId(),
                'Status' => 'TO_DO'}, null);
        insert mailCase;

        HP_CaseOwner__c history = (HP_CaseOwner__c) HP_UTIL_SmartFactory.createSObject('HP_CaseOwner__c', new Map<String, Object> {
            'Case__c' => mailCase.Id}, null);
        insert history;
        
    }

    @IsTest
    public static void getCaseOwnerMap() {
        List<Case> casesList = [SELECT Id, Status FROM Case];
        Set<Id> casesIdSet = new Set<Id>();
        for(Case acase : casesList) {
            casesIdSet.add(acase.Id);
        }
        Test.startTest();
        Map<Id, List<HP_CaseOwner__c>> result = HP_EM050_HPCaseOwner.getCaseOwnerMap(casesIdSet);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.keySet().size() > 0);
    }
}