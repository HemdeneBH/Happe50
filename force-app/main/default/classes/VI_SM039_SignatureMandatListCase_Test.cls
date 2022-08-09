@isTest
public class VI_SM039_SignatureMandatListCase_Test {

   	@isTest
    static void signedCaseTest() {
        // create Account
        Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        Insert acc;
        
        // Create Case
        Id CaseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        Case caseTest = SM_TestDataFactory.createCase('TEST', Acc.Id);
        caseTest.recordTypeId=CaseRTId;
        caseTest.Origin = 'Partner Community';
        caseTest.VI_StatutMandat__c = 'Delivered';
        insert caseTest;   
        
         VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', caseTest.id, 'PURE PLAYERS');
        insert parcours;
        
        caseTest.VI_StatutMandat__c = 'Signed';
        update caseTest;   
    }
    
}