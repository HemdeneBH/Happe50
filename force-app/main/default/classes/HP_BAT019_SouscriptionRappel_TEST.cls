/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   06-04-2021   Antoine Latour   Initial Version
**/
@isTest
public class HP_BAT019_SouscriptionRappel_TEST {
    
    @testSetup static void dataSetup(){
        
        List<HP_Souscription__c> souscriptions = new List<HP_Souscription__c>();
        
        HP_Souscription__c souscription1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
            'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
            'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
            'HP_Code_postal__c'  => '92160',
            'HP_code_Postal_Insee__c'  => '92002',
            'HP_Date_de_Contractualisation__c'  => System.today().addDays(1),
            'HP_Date_Origine__c'  =>DateTime.newInstance(2019, 10, 9, 13, 0, 0),
            'HP_Energie_Verte__c'  => false,
            'HP_Estimation_Consommation_electrique__c'  => 6000,
            'HP_Estimation_Consommation_gaz__c'  => 13000,
            'HP_Jour_de_facturation__c' => 16,
            'HP_Lien_enregistrement__c' =>'test.fr',
            'HP_Methode_de_paiement__c' =>'BANK_CARD',
            'HP_Montant_de_la_facturation_electrique__c' =>58,
            'HP_Montant_de_la_facturation_gaz__c' =>120,
            'HP_Predecesseur__c' =>'Dupont',
            'HP_Nom_de_rue__c' =>'rue des bois',
            'HP_Nom_de_ville__c' =>'ANTONY',
            'HP_Numero_de_voie__c' =>'15 ter',
            'HP_Periode_de_facturation__c' =>'BIMONTHLY',
            'HP_Plan_de_Prix_electrique__c' =>'BASE',
            'HP_Puissance_Compteur_electrique__c' =>6,
            'HP_Souscription_Digital_Id__c' =>'test-rappel-01',
            'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_NumPDL__c' =>'31431211214170',
            'HP_Statut__c' => 'SAVE_2_CONFIRMED',
            'HP_DigitalDateSave2__c' => Date.today().addDays(-1),
            'OwnerId' => UserInfo.getUserId()}, null);    
    
        souscriptions.add(souscription1);
           
        insert souscriptions;
    }
    
    @isTest static void HP_BAT019_SouscriptionRappel_TEST(){
        
        Test.startTest();
        HP_BAT019_SouscriptionRappel.execute();
        Test.stopTest();
        
        HP_Souscription__c souscription = [SELECT Id FROM HP_Souscription__c Where HP_Souscription_Digital_Id__c='test-rappel-01'];
        Case testCase = [SELECT Id FROM Case WHERE HP_Souscription__c = :souscription.Id];
        System.assert(testCase != null);
    }

    @isTest static void HP_BAT019_SouscriptionRappel_TEST_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT019_SouscriptionRappel'+String.valueOf(Integer.valueof((Math.random() * 100)));
        final String cronExp = '0 0 4 ? * * *';
        HP_BAT019_SouscriptionRappel.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}