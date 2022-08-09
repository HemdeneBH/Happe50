/*
*@Author: Georges Mardini
*@Description: Classe test de CaseHandler.
*@CreatedDate: 12/11/2020
*@LastModified: 16/11/2020
*/
@isTest 
public class VI_SM035_NotifyListCase_Test {
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        insert u;
    }
    @isTest
    public static void sendCaseTest() {
        User u =[Select id from user where firstname='Test' and lastname='Test' limit 1];
        System.runAs(u){
            Test.startTest();
            // create Account
            Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
            Insert acc;
            // Create Case
            Id CaseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
            Case caseTest = SM_TestDataFactory.createCase('TEST', Acc.Id);
            caseTest.recordTypeId=CaseRTId;
            caseTest.Sous_type__c = 'Changement de fournisseur';
            caseTest.Origin = 'Partner Community';
            caseTest.CPV_E_Lien_CPV__c = 'test1';
            insert caseTest;   
            system.assertEquals('test1', caseTest.CPV_E_Lien_CPV__c);
            caseTest.CPV_E_Lien_CPV__c = 'test';
            system.assertEquals('test', caseTest.CPV_E_Lien_CPV__c);
            update caseTest;   
            Test.stopTest();
        }
    }
}