/*
* @Author: Riadh Dallel
* @Date: 26/06/2020
* @Description: Test Class for SM_AP90_AgentWorkInvocable (Process builder Invocable)
*/
@isTest
public with sharing class SM_AP90_AgentWorkInvocable_Test {
    Static Id acquisitionRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Acquisition').getRecordTypeId();
    @testSetup 
    static void setup() {

        // create Account
        Account acc = SM_TestDataFactory.createAccount('Smile_Account');
        Insert acc;
       
        // create Contact
        Contact testContact = SM_TestDataFactory.createContact('testContact', acc.Id);
        Insert testContact;

        // Create Case
        Case testCase = SM_TestDataFactory.createCase('TEST', acc.Id);
        testCase.RecordTypeId = acquisitionRT;
        insert testCase;

        // Create Interventions
        Intervention__c intervention= new Intervention__c(
            Case__c=testCase.Id,
            Contact__c=testContact.Id,
            Escalade_justifie__c=Intervention__c.Escalade_justifie__c.getDescribe().getPicklistValues()[0].getValue(),
            Type__c='Blocage sur MES/RES/CHO',
            Description__c ='Test',
            Statut__c='Nouveau'
        );
        insert intervention;

        // Create User
        User u= SM_TestDataFactory.createUser('sm90test','sm90test@engie.com','Test','sm90testt@engie.com','SM_SystemAdmin');
        insert u; 

    }

    @isTest
    public static void testAgentWorkInvocable(){

        //Récuperer les inputs du methode invocable
        Case testCase= [Select id from Case Limit 1];
        User u= [Select id from User where Email='sm90test@engie.com' Limit 1];
        SM_AP90_AgentWorkInvocable.Request request = new SM_AP90_AgentWorkInvocable.Request();
        request.caseId=testCase.Id;
        request.ownerId=u.Id;
        Test.startTest();
        SM_AP90_AgentWorkInvocable.execute(new List<SM_AP90_AgentWorkInvocable.Request>{request});
        Test.stopTest();

        // vérification des résultats
        Intervention__c testIntervention = [Select id,Statut__c,Case__c from Intervention__c Limit 1];
        System.assertEquals(testIntervention.Statut__c,'En cours');
    }  
}