@isTest 
public class VI_CaseHandler_Test {
    @isTest
    public static void testTrigger() {
        // create Account
        Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        Insert acc;
        
        // Create Case
        Case caseTest = SM_TestDataFactory.createCase('TEST', Acc.Id);
        caseTest.Sous_type__c = 'Changement de fournisseur';
        caseTest.Origin = 'Partner Community';
        caseTest.CPV_E_Lien_CPV__c = 'test1';
        insert caseTest;   
        caseTest.CPV_E_Lien_CPV__c = 'test';
        update caseTest;   
    }
}