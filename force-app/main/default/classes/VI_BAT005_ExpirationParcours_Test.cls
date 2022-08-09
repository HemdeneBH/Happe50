/*
*@Auhtor: Clément Bouquin
*@Description: Classe de test de VI_BAT005_ExpirationParcours
*@CreatedDate: 06/07/2021
*/

@isTest
public class VI_BAT005_ExpirationParcours_Test {

    @testSetup
    static void testSetup1(){
        Case casex= VI_TestDataFactory.createCase();
        casex.VI_StatutEnveloppe__c='Sent';
        casex.VI_DateEnvoiEnveloppe__c=system.today().adddays(-32) ;
        insert casex;
        VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', casex.id, 'PURE PLAYERS');
        insert parcours;
    }
    
	 @isTest
    static void testBatch(){
		Test.startTest();
        system.debug('Test Start');
        VI_BAT005_ExpirationParcours.execute();
        system.debug('Test END');
        Test.stopTest();
        /*List<VI_Parcours__c> listParcours =[SELECT id,VI_StatutParcours__c from VI_Parcours__c];
        system.debug('listParcours '+listParcours);
        for(VI_Parcours__c parcours:listParcours){
            system.debug('parcours.VI_StatutParcours__c :'+ parcours.VI_StatutParcours__c);
            System.assert(parcours.VI_StatutParcours__c=='Expiré');
        }*/
        
        List<Case> listcase=new List<Case>();
        listcase=[SELECT Id, Status, Sous_statut__c FROM Case];
        system.debug('listcase '+listcase);
        
        for(Case cases:listcase){
            system.debug('cases.Status :'+ cases.Status);
            System.assert(cases.Status=='Pré-clôturé');
            system.debug('cases.Sous_statut__c :'+ cases.Sous_statut__c);
            System.assert(cases.Sous_statut__c=='Abandon');
        }
	}
}