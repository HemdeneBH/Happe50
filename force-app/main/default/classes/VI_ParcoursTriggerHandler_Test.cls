/*
*@Author: Georges Mardini
*@Description: Classe test de CaseHandler.
*@CreatedDate: 15/11/2020
*@LastModified: 15/11/2020
*/
@isTest 
public class VI_ParcoursTriggerHandler_Test {
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
    public static void TriggerHandlerTest() {
        // create Account
        Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        Insert acc;
        
        // Create Case
        Case caseTest = SM_TestDataFactory.createCase('TEST', Acc.Id);
        caseTest.Sous_type__c = 'Changement de fournisseur';
        caseTest.Origin = 'Partner Community';
        insert caseTest;   
        
        // Create Parcours
        User u =[Select id from user where firstname='Test' and lastname='Test' and isActive=true limit 1];
        System.runAs(u){
            Test.startTest();
            //VI_Parcours__c parcrousTest = VI_TestDataFactory.createParcours('CHF', caseTest.id, 'PURE PLAYERS');
            VI_Parcours__c parcrousTest = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcrousTest.VI_ConsentProspectionEngieNonAnalogue__c = 'Non';
            
            insert parcrousTest;   
            VI_Parcours__c parcours1=[Select id,VI_ConsentProspectionEngieNonAnalogue__c from VI_Parcours__c where id=:parcrousTest.id limit 1];
            system.assertEquals(parcours1.VI_ConsentProspectionEngieNonAnalogue__c, 'Non');
            parcrousTest.VI_ConsentProspectionEngieNonAnalogue__c = 'Oui';
            parcrousTest.VI_StatutParcours__c = 'CPV Envoyées: PDL/PCE connu';
            parcrousTest.VI_ChoixParcours__c ='CHF';
            parcrousTest.VI_IndexBaseRechercheLocal__c = '1';
            parcrousTest.VI_IndexHCRechercheLocal__c = '1';
            parcrousTest.VI_IndexHPRechercheLocal__c = '1';
            parcrousTest.VI_ChoixMoyenPaiement__c = 'Prélèvement automatique';
            update parcrousTest; 
            VI_Parcours__c parcours2=[Select id,VI_ChoixMoyenPaiement__c from VI_Parcours__c where id=:parcrousTest.id limit 1];
            system.assertEquals(parcours2.VI_ChoixMoyenPaiement__c,  'Prélèvement automatique');
            Test.stopTest();
        }
        VI_ParcoursTriggerHandler parcoursTriggerHandler = new VI_ParcoursTriggerHandler();
            parcoursTriggerHandler.isDisabled();
    }
}