/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-04-2021   Antoine Latour   Initial Version
**/
@isTest
public with sharing  class HP_BAT018_CaseRappel_TEST {
   
    @testSetup static void dataSetup(){
        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;
        List<Case> caseList = new List<Case>();

        Case case1 = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
            'Description' => 'Description Test 1',
            'Subject' => 'TEST',
            'HP_Type__c' => 'HP_RappelLeadNonSigne',
            'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
            'OwnerId' => UserInfo.getUserId(),
            'Status' => 'TO_DO'}, null);
        caseList.add(case1);
        
        Case case2 = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
            'Description' => 'Description Test 2',
            'Subject' => 'TEST',
            'HP_Type__c' => 'HP_RappelLeadNonSigne',
            'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
            'OwnerId' => UserInfo.getUserId(),
            'Status' => 'TO_DO'}, null);
        caseList.add(case2);
        
        Case case3 = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {
            'Description' => 'Description Test 3',
            'Subject' => 'TEST',
            'HP_Type__c' => 'HP_RappelLeadNonSigne',
            'RecordTypeId' => HP_UTIL_RecordType.getRecordTypeId('Case', 'HP_Telephone'),
            'OwnerId' => UserInfo.getUserId(),
            'Status' => 'TO_DO'}, null);
        caseList.add(case3);
        
        insert caseList;

        HP_AppelsSortants__c appelSortant = (HP_AppelsSortants__c) HP_UTIL_SmartFactory.createSObject('HP_AppelsSortants__c', new Map<String, Object> {
            'HP_CaseRappel__c' => case1.Id,
            'HP_CommentaireRappel__c' => 'Test Comm',
            'HP_ReponseRappel__c' => 'HP_ReceptionOffreIgnore', 
            'HP_ResultatRappel__c' => 'HP_DemandeRappel'}, null);
        insert appelSortant;

        EmailMessage originMessage = (EmailMessage) HP_UTIL_SmartFactory.createSObject('EmailMessage', new Map<String, Object> {
            'Status' => '3',
            'RelatedToId' => acc.Id,
            'FromAddress' => 'sender@clients.happ-e.fr', 
            'FromName' => 'Dan Perkins', 
            'Subject' =>'This is the Subject!', 
            'HtmlBody' => '<html><body><b>Hello</b></body></html>',
            'ToAddress' => 'emailnotinsalesforce@toexample.com, anotherone@toexample.com',
            'ParentId' => case2.Id}, null);
        insert originMessage;

        Test.setCreatedDate(case1.Id, DateTime.newInstance(2012,12,12));
        Test.setCreatedDate(case2.Id, DateTime.newInstance(2013,12,12));
        Test.setCreatedDate(case3.Id, DateTime.newInstance(2014,12,12));
    }

    @isTest 
    public static void  closeOldCases() {
    
        Test.startTest();
        HP_BAT018_CaseRappel.execute();
        Test.stopTest();

        List<Case> caseList = [SELECT Id, Status FROM Case WHERE HP_Type__c = 'HP_RappelLeadNonSigne' ORDER BY CreatedDate ASC];
        System.assert(caseList.get(0).Status == 'CLOSED');
        System.assert(caseList.get(1).Status == 'CLOSED');
        System.assert(caseList.get(2).Status == 'CANCELED');

    }

}