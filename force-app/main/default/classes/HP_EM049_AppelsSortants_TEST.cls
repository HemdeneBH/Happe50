/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-04-2021   Antoine Latour   Initial Version
**/
@IsTest
public inherited sharing class HP_EM049_AppelsSortants_TEST {
    
    @testSetup static void dataSetup(){
        
        Case mailCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
                'Description' => 'Description Test',
                'Subject' => 'TEST',
                'HP_Type__c' => 'HP_RappelLeadNonSigne',
                'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
                'OwnerId' => UserInfo.getUserId(),
                'Status' => 'TO_DO'}, null);
        insert mailCase;

        HP_AppelsSortants__c appelSortant = (HP_AppelsSortants__c) HP_UTIL_SmartFactory.createSObject('HP_AppelsSortants__c', new Map<String, Object> {
                'HP_CaseRappel__c' => mailCase.Id,
                'HP_CommentaireRappel__c' => 'Test Comm',
                'HP_ReponseRappel__c' => 'HP_ReceptionOffreIgnore', 
                'HP_ResultatRappel__c' => 'HP_DemandeRappel'}, null);
        insert appelSortant;
    }

    @IsTest
    public static void loadAppelsSortantsFromCase() {
        List<Case> casesList = [SELECT Id, Status FROM Case WHERE HP_Type__c = 'HP_RappelLeadNonSigne'];
        Set<Id> casesIdSet = new Set<Id>();
        for(Case acase : casesList) {
            casesIdSet.add(acase.Id);
        }
        Test.startTest();
        Map<Id, List<HP_AppelsSortants__c>> result = HP_EM049_AppelsSortants.loadAppelsSortantsFromCase(casesIdSet);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.get(casesList.get(0).Id) != null);
    }
}