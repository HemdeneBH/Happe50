/** 
* @author Slimen Belhaj Ali 
* @date 14/01/2020  
* @description Classe de test pour HP_SM007_PrestationDistributeurManager_TEST
*/
@IsTest
public with sharing class HP_SM007_PrestDistManager_TEST {
     /** 
    * @author Slimene Belhaj Ali
    * @date 14/01/2020 
    * @description Methode permet de créer les jeux de données
    */
	@TestSetUp 
	private static void insertTestData() {
        List<Prestation_distributeur__c> presList = new List<Prestation_distributeur__c>();
        presList.add((Prestation_distributeur__c) HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 
        new Map<String, Object>{'Statut__c' => 'En cours', 'Numero_affaire_distributeur__c' => '11111111', 'Numero_PDL_PCE__c' => '12'}, null));

         presList.add((Prestation_distributeur__c) HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 
        new Map<String, Object>{'Statut__c' => 'Terminé', 'Numero_affaire_distributeur__c' => '22222222', 'Numero_PDL_PCE__c' => '13'}, null));

         presList.add((Prestation_distributeur__c) HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 
        new Map<String, Object>{'Statut__c' => 'Annulé', 'Numero_affaire_distributeur__c' => '33333333', 'Numero_PDL_PCE__c' => '14'}, null));
        insert presList;
    }

    /** 
    * @author Slimene Belhaj Ali
    * @date 14/01/2020 
    * @description Methode permet tester la methode loadPrestationDistrubuteurToCardService
    */
    @IsTest
	static void loadPrestationDistrubuteurToCardService_TEST(){
        Test.startTest();
        Prestation_distributeur__c resEncours = HP_SM007_PrestationDistributeurManager.loadPrestationDistrubuteurToCardService('12');
        Prestation_distributeur__c resTermine = HP_SM007_PrestationDistributeurManager.loadPrestationDistrubuteurToCardService('13');
        Prestation_distributeur__c resAnnule = HP_SM007_PrestationDistributeurManager.loadPrestationDistrubuteurToCardService('14');
        Prestation_distributeur__c resNull = HP_SM007_PrestationDistributeurManager.loadPrestationDistrubuteurToCardService('15');
        Test.stopTest();

        System.assertNotEquals(null, resEncours, 'Erreur prestation distibuteur en cours');
        System.assertNotEquals(null, resTermine, 'Erreur prestation distibuteur Terminé');
        System.assertNotEquals(null, resAnnule, 'Erreur prestation distibuteur Annulé');
        System.assertEquals(null, resNull, 'Erreur prestation distibuteur introuvable');
    }
}