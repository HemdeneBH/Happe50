@IsTest
public class SM_BAT03_CaseEnTraitement_TEST {
    @testSetup 
    static void dataSetup() {
        Id acquisitionRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Acquisition').getRecordTypeId();
        //create User
        User testUser = SM_TestDataFactory.createUser('alias', 'email@email.com', 'lastName', 'username_Test@username-engie.com', 'System administrator');
        insert testUser;
        // create Account
        Account acc = SM_TestDataFactory.createAccount('Smile_Account');
        Insert acc;
        // Create Cases
        List<Case> casesToInsert = new List<Case>();
        Case testCase1 = SM_TestDataFactory.createCase('TEST1', acc.Id);
        testCase1.RecordTypeId = acquisitionRT;
        testCase1.Status='En Traitement';
        testCase1.Last_Modified_By_Custom__c=testUser.Id;
        casesToInsert.add(testCase1);
        Case testCase2 = SM_TestDataFactory.createCase('TEST2', acc.Id);
        testCase2.RecordTypeId = acquisitionRT;
        testCase2.Status='En Traitement';
        testCase2.Last_Modified_By_Custom__c=testUser.Id;
        casesToInsert.add(testCase2);
        insert casesToInsert;
    }
    @isTest 
    static void testBatchBAT03() {
        Test.startTest();
        database.executebatch(new SM_BAT03_CaseEnTraitement(),200);
		Test.stopTest();
        Id userId = [select id from User where alias like 'alias' limit 1 ].id;
        Integer casesUpdated = [SELECT count() FROM Case WHERE OwnerId =: userId AND Status='Préclôturé'AND Sous_statut__c='Abandon'];
        System.assertEquals(2, casesUpdated);


        // Pour couverture de la classe test
        SM_BAT03_CaseEnTraitementSchedule batchSch=new SM_BAT03_CaseEnTraitementSchedule();
        batchSch.execute(null);

    }

}