/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-18-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-18-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest 

public with sharing class HP_EM036_CaseHistory_TEST {

    @testSetup static void dataSetup(){
       
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_PrestationDistributeur', new Map<String, Object> {
            'Status' => 'NEW_CASE',
            'Priority' => 'High',
            'Origin' => 'Télévente Happe COMDATA'
            }, null,null,null);
            insert c1;
    }
    
    @isTest 
    public static void getCaseHistory() {
        Case cas = [select Id from Case limit 1 ];

        HP_CaseHistory__c caseHistory = (HP_CaseHistory__c) HP_UTIL_SmartFactory.createSObject('HP_CaseHistory__c', new Map<String, Object> {
            'Case__c'  => cas.Id,
            'HP_dateAttribution__c'=> DateTime.newInstance(2020, 09, 17, 13, 0, 0) ,
            'HP_type__c' =>'DMT',
            'user__c' => UserInfo.getUserId()}, null);
        insert caseHistory;
        
        Test.startTest();
        HP_EM036_CaseHistory.getCaseHistory(cas.Id,UserInfo.getUserId());

        Test.stopTest();
    }


    @isTest 
    public static void createCaseHistory() {

        Case acase = (Case) HP_UTIL_SmartFactory.createSObject('Case',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
        'OwnerId' => UserInfo.getUserId()
        }, null
        );
        insert acase;
        
        Test.startTest();
        HP_EM036_CaseHistory.creatCaseHistory(acase, null,true);
        Test.stopTest();
    }






    @isTest 
    public static void getCaseHistoryByListCaseAndUser() {

        Case cas = [select Id from Case limit 1 ];

        HP_CaseHistory__c caseHistory = (HP_CaseHistory__c) HP_UTIL_SmartFactory.createSObject('HP_CaseHistory__c', new Map<String, Object> {
            'Case__c'  => cas.Id,
            'HP_dateAttribution__c'=> DateTime.newInstance(2020, 09, 17, 13, 0, 0) ,
            'HP_type__c' =>'DMT',
            'user__c' => UserInfo.getUserId()}, null);
        insert caseHistory;
    
        Set<String> casesId = new Set<String>();
        casesId.add(cas.Id);
        Test.startTest();
        HP_EM036_CaseHistory.getCaseHistoryByListCaseAndUser( UserInfo.getUserId(),casesId);

        Test.stopTest();
    }





    @isTest 
    public static void getCaseHistoryByUsers() {

        Case cas = [select Id from Case limit 1 ];

        HP_CaseHistory__c caseHistory = (HP_CaseHistory__c) HP_UTIL_SmartFactory.createSObject('HP_CaseHistory__c', new Map<String, Object> {
            'Case__c'  => cas.Id,
            'HP_dateAttribution__c'=> DateTime.newInstance(2020, 09, 17, 13, 0, 0) ,
            'HP_type__c' =>'DMT',
            'user__c' => UserInfo.getUserId()}, null);
        insert caseHistory;
    
        List<Id> users = new List<Id>();
        users.add(UserInfo.getUserId());
        Date batchDate  = Date.newInstance(2020, 09, 17);
        Test.startTest();
        HP_EM036_CaseHistory.getCaseHistoryByUsers( users,batchDate);

        Test.stopTest();
    }


    @isTest 
    public static void getCaseHistoryByCasesIds() {
        Case cas = [select Id, Status from Case limit 1 ]; 
        Set<Id> casesId = new Set<Id>();
        casesId.add(cas.Id);

        Test.startTest();
        cas.Status = 'TO_DO';
        update cas;
        List<CaseHistory> result = HP_EM036_CaseHistory.getCaseHistoryByCasesIds(casesId);
        Test.stopTest();
    }



}