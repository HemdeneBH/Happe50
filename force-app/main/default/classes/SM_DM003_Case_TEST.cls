/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 03-04-2022
 * @last modified by  : Mohamed Aamer
**/
@IsTest
public with sharing class SM_DM003_Case_TEST {

    @testSetup static void dataSetup(){

        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'lastName', 'username_Test@username-engie.com', 'System administrator');
        insert user;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        
        Case testCase = new Case(Subject = 'test', AccountId = testAccount.Id);
        insert testCase;

        Order orderTest = new Order();
        orderTest.AccountId = testAccount.Id;
        orderTest.EffectiveDate = Date.today();
        orderTest.Status = 'Draft';
        orderTest.Case__c = testCase.Id;
        orderTest.Numero_PC__c = '0123456';
        insert orderTest;
    }

    @isTest static void retrieveCasesByPcIdsTest(){
        
        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Set<String> pcIds = new Set<String> {'0123456'};
        String subject = 'test';
        System.runAs(user){
            Test.startTest();
            List<Case> cases = SM_DM003_Case.retrieveCasesByPcIds(pcIds);
            Case casetest = cases.get(0);
            System.assertEquals(subject, casetest.Subject,'case retreived');
            Test.stopTest();
        }
    }
}