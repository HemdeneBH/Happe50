/** 
* @author Slimen Belhaj Ali 
* @date 14/01/2020  
* @description Classe de test pour HP_SM007_PrestationDistributeurManager_TEST
*/
@IsTest
public with sharing class HP_SM007_PrestationDistManager_TEST {
    /** 
    * @author Slimene Belhaj Ali
    * @date 14/01/2020 
    * @description Methode permet de créer les jeux de données
    */
	@TestSetUp 
	private static void insertTestData() {
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Prestation_distributeur__c pres = (Prestation_distributeur__c) HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 
            new Map<String, Object>{
                'Statut__c' => 'En cours',
                'Numero_affaire_distributeur__c' => 'A1234567',
                'Numero_PDL_PCE__c' => '12'}, null);
            insert pres;
        }
    }

    /** 
    * @author Slimene Belhaj Ali
    * @date 14/01/2020 
    * @description Methode permet tester la methode loadPrestationDistrubuteurToCardService
    */
    @IsTest
	static void loadPrestationDistrubuteurToCardService_TEST(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            HP_SM007_PrestationDistributeurManager.loadPrestationDistrubuteurToCardService('12');
        }
    }
}