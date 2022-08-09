/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-05-2021   Antoine Latour   Initial Version
**/
@IsTest
public with sharing class HP_SM060_CaseOwnerHistory_TEST {
    private enum StaticResource {
		HP_CaseOwnerHistoryTest
	}
    
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
    public static void upsertCaseOwnerHistory() {
        List<Case> casesList = [SELECT Id, IsClosed, HP_TECH_CaseOwnerHistoryCheck__c, CreatedDate 
        FROM Case WHERE HP_isHappe__c = true 
        AND HP_TECH_CaseOwnerHistoryCheck__c = false];
        List<CaseHistory> ch = Test.loadData(CaseHistory.SObjectType, 'HP_CaseOwnerHistoryTest');
		System.debug('Case History : ' + ch);
        Test.startTest();
        HP_SM060_CaseOwnerHistory.upsertCaseOwnerHistory(casesList);
        Test.stopTest();
    }
    
    @IsTest
    public static void upsertCaseOwner() {
        List<Case> casesList = [SELECT Id, IsClosed, HP_TECH_CaseOwnerHistoryCheck__c, CreatedDate FROM Case WHERE HP_isHappe__c = true AND HP_TECH_CaseOwnerHistoryCheck__c = false];
        
        List<CaseHistory> ch = Test.loadData(CaseHistory.SObjectType, 'HP_CaseOwnerHistoryTest');
        Map<Id, List<CaseHistory>> mapCaseHistoryByCase = new Map<Id, List<CaseHistory>>();
        mapCaseHistoryByCase.put(casesList.get(0).Id, ch);

        Map<Id, Group> mapQueueById = HP_UTIL_QueueManager.getQueueMapById();
        
        Set<Id> userIds = new Set<Id>();
        userIds.add(UserInfo.getUserId());
        Map<Id, User> mapUserByUserId = HP_UTIL_ProfileManager.getUsersProfiles(userIds);
        
        HP_CaseOwner__c hpCaseOwner = new HP_CaseOwner__c();
        hpCaseOwner.Case__c = casesList.get(0).Id;
        hpCaseOwner.HP_ElapsedTime__c = 0;
        hpCaseOwner.ProfileName__c = 'TEST';
        List<HP_CaseOwner__c> listhpCO = new List<HP_CaseOwner__c>();
        listhpCO.add(hpCaseOwner);
        Map<Id, List<HP_CaseOwner__c>> mapCaseOwnerByCase = new Map<Id, List<HP_CaseOwner__c>>();
        mapCaseOwnerByCase.put(casesList.get(0).Id, listhpCO);
        Test.startTest();
        HP_SM060_CaseOwnerHistory.upsertCaseOwner(casesList, mapCaseHistoryByCase, mapCaseOwnerByCase, mapQueueById, mapUserByUserId);
        Test.stopTest();
    }
    
    @isTest
    public static void updateMapCaseHistory() {
        List<CaseHistory> ch = Test.loadData(CaseHistory.SObjectType, 'HP_CaseOwnerHistoryTest');
        Map<Id, List<CaseHistory>> mapCaseHistoryByCase = new Map<Id, List<CaseHistory>>();

        Test.startTest();
        HP_SM060_CaseOwnerHistory.updateMapCaseHistory(ch, mapCaseHistoryByCase);
        Test.stopTest();
        
        System.assert(mapCaseHistoryByCase.keySet().size() > 0);
    }


    @isTest
    public static void mapQueueTouserProfiles() {
        Test.startTest();
        final String result1 = HP_SM060_CaseOwnerHistory.mapQueueTouserProfiles('HP_Niveau_1');
        final String result2 = HP_SM060_CaseOwnerHistory.mapQueueTouserProfiles('HP_Niveau_2');
        final String result3 = HP_SM060_CaseOwnerHistory.mapQueueTouserProfiles('HP_Niveau_3');
        final String result4 = HP_SM060_CaseOwnerHistory.mapQueueTouserProfiles('HP_Niveau_4');
        Test.stopTest();
        
        System.assert(result1 == 'HP_Conseiller Niveau 1');
        System.assert(result2 == 'HP_Conseiller Niveau 2');
        System.assert(result3 == 'HP_Conseiller Niveau 3');
        System.assert(result4 == 'Queue indéfinie');
    }


}