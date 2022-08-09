@isTest
public class Prestation_distributeur_Trigger_Test {
	@isTest
    static void preclotureTest() {
        Case myCase = new Case();
        myCase.subject = 'test';
        myCase.RecordTypeId	= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        insert myCase;


        Prestation_distributeur__c ops = new Prestation_distributeur__c(Case__c = myCase.Id, Numero_affaire_distributeur__c = '12345678');

        insert ops;
        
        //Test.startTest();
        ops.Statut__c = 'Terminé';
        update ops;
        myCase = [select status, Sous_statut__c from Case where Id=:myCase.Id];
        //Test.stopTest();

        System.assertEquals('Pré-clôturé', myCase.Status);
        System.assertEquals('Conforme', myCase.Sous_statut__c);
    }
}