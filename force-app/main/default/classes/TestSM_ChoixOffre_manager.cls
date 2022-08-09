/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* this test class is to test the class 'SM_ChoixOffre_manager' 
*
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Zouhair BOUKHRISS   
* @modifiedBy     Zouhair BOUKHRISS   
* @maintainedBy   Zouhair BOUKHRISS   
* @version        1.0
* @created        2020-03-03
* @modified       
*/


@isTest
public class TestSM_ChoixOffre_manager {
    
    @testSetup static void disableOldChoixOffreByEnergieTest(){
        List<Choix_Offre__c> listCo = new List<Choix_Offre__c>();
        
        Choix_Offre__c record = new Choix_Offre__c( Actif__c = true, Energie__c = 'Elec', OffrePousse__c ='', Contexte_de_souscription__c = 'CHO', Compteur_Linky__c =true);
        Choix_Offre__c record2 = new Choix_Offre__c( Actif__c = true, Energie__c = 'Gaz', OffrePousse__c ='', Contexte_de_souscription__c = 'CHO');
        Choix_Offre__c record3 = new Choix_Offre__c( Actif__c = false, Energie__c = 'Elec', OffrePousse__c ='', Contexte_de_souscription__c = 'PP-EM');
        
        listCo.add(record);
        listCo.add(record2);
        listCo.add(record3);
        
        insert listCo;
        
    }
    @isTest static void testDisableOldChoixOffreByEnergie() {
        Choix_Offre__c recordtest = new Choix_Offre__c( Actif__c = true, Energie__c = 'Elec', OffrePousse__c ='', Contexte_de_souscription__c = 'CHO');
        Test.startTest();
        Choix_Offre__c recordNotUpdated = [SELECT Id, Compteur_Linky__c, Actif__c FROM Choix_Offre__c where Compteur_Linky__c = true];
        System.assertEquals(true, recordNotUpdated.Actif__c);
        insert recordtest;
        Test.stopTest();
        Choix_Offre__c recordUpdated = [SELECT Id, Compteur_Linky__c, Actif__c FROM Choix_Offre__c where Compteur_Linky__c = true];
        System.assertEquals(false, recordUpdated.Actif__c);
    }
}