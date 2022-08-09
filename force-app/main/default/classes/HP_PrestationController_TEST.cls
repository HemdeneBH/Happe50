/**
 * @File Name          : HP_PrestationController_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 24/04/2020 à 17:18:34
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@isTEST
public with sharing class HP_PrestationController_TEST {


    @TestSetUp 
	private static void insertTestData(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Prestation_distributeur__c testpresta = (Prestation_distributeur__c)HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 'HP_PrestationDistributeur', new Map<String, Object>{
                'Numero_PDL_PCE__c' => '230492038433',
                'Statut__c' => 'Terminé',
                'Secteur_activite__c' => 'Elec',
                'Situation_de_vente__c'=>'Changement de fournisseur',
                'Numero_affaire_distributeur__c' => 'QL30DPC4',
                'Statut_dernier_jalon__c'=>'CPE',
                'HP_TECH_toNotify__c' => false
            }, null, null, null);
            insert testpresta;
    
            Prestation_distributeur__c testpresta1 = (Prestation_distributeur__c)HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 'HP_PrestationDistributeur', new Map<String, Object>{
                'Numero_PDL_PCE__c' => '3993028736467',
                'Statut__c' => 'Terminé',
                'Secteur_activite__c' => 'Gaz',
                'Situation_de_vente__c'=>'Emménagement',
                'Numero_affaire_distributeur__c' => 'QL30DPC5',
                'Statut_dernier_jalon__c'=>'022',
                'HP_TECH_toNotify__c' => false
            }, null, null, null);
            insert testpresta1;
        }
    }

    @istest
    static void handleUpdatedOPS() {
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            List <Prestation_distributeur__c> hpUpdatedOps = [Select Id,Situation_de_vente__c,Secteur_activite__c ,Statut__c ,Statut_dernier_jalon__c From Prestation_distributeur__c limit 2];
            Test.startTest();
            HP_PrestationController.handleUpdatedOPS(hpUpdatedOps);
            Test.stopTest();
        }
    }
}