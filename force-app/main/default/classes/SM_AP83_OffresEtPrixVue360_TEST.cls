/*@Author: RWA
*@Description: class de test des offres
*@CreatedDate:
*@LastModified: MHA 22/02/2019
*/
@isTest
public class SM_AP83_OffresEtPrixVue360_TEST {

  /*@Author: MBA
  *@Description: test de l'appel
  *@CreatedDate:
  *@LastModified: MBA 10/03/2020
  */

  	@testSetup static void setup() {
		SM_AP08_TestLib.insertCS_SMOCTOPUS();
	}

  	@isTest(SeeAllData = false)
	public static void testCallout_Elec() {
		// Product2  offreDuo = new Product2();
		// offreDuo.FamilyLabel__c = '';
		// offreDuo.name = 'Gaz Ajust 3 ans';
		// offreDuo.Family = 'DGBUEBUF3AK_P';
		// offreDuo.vlocity_cmt__SpecificationType__c = 'Offre poussée';
		// offreDuo.vlocity_cmt__Type__c = 'Gaz';
		// offreDuo.ProductCode = 'EBUKF3V100';
		// offreDuo.IsActive = true;
		
		Product2 offreDuorepli = new Product2();
		offreDuorepli.FamilyLabel__c = 'Duo Energie Garantie 2 ans';
		offreDuorepli.Family = 'DGBUEBUKF2VGO_P';
		offreDuorepli.name = 'Gaz Energie Garantie 2 ans';
		offreDuorepli.vlocity_cmt__SpecificationType__c = 'Offre de repli';
		offreDuorepli.vlocity_cmt__Type__c = 'Elec'; //'Duo';
		offreDuorepli.SM_structureMesureFournisseur__c = 'SMF3C0PM001';
		offreDuorepli.ProductCode = 'DGBUEBUVR3_P';
		offreDuoRepli.TypeOffre__c = 'TradeOFF';
		offreDuorepli.IsActive = true;

		Product2 offreGaz = new Product2();
		offreGaz.FamilyLabel__c = 'Référence Gaz 1 an';
		offreGaz.Family = 'GBUGR1_P';
		offreGaz.name = 'Référence Gaz 1 an';
		offreGaz.vlocity_cmt__Type__c = 'Gaz';
		offreGaz.SM_structureMesureFournisseur__c = 'SMF3C0PM001';
		offreGaz.ProductCode = 'GBUGR1';
		offreDuoRepli.TypeOffre__c = 'TradeOFF';
		offreGaz.IsActive = true;
			
		List<Product2> prodList = new List<Product2>();
		// prodList.add(offreDuo);
		prodList.add(offreDuorepli);
		prodList.add(offreGaz);
		insert prodList;
		
		Choix_Offre__c choixOffre = new Choix_Offre__c();
		choixOffre.debut_Validite_Offre__c = date.today();
		choixOffre.Energie__c = 'Gaz';
		insert choixOffre;
			
		Test.startTest();
		// Test 1
		Map < String, Object > outMap = new Map < String, Object >();
		Map < String, Object > inputMap = new Map < String, Object >();
		inputMap.put('EnergyTypeOptions', 'Elec');
		//ADE correction
		// old value
		// inputMap.put('idOffre', 'EBUKF2V100');
		//inputMap.put('idOffre','TradeOFF');
		inputMap.put('idOffre', 'DGBUEBUVR3_P');
		inputMap.put('idPack', 'EBUAK2_P');
		inputMap.put('typeComptageDifferencie', 'Triple');
		inputMap.put('ftaCode', 'BTINFCUST');
		inputMap.put('CAEElec', 3000);
		inputMap.put('CAR', 5478);
		inputMap.put('Puissance', '3');
		inputMap.put('dateDerniereModificationFormuleTarifaireAcheminement', '2018-07-03 00:00:00');
		inputMap.put('niveauOuvertureServices', '0');
		inputMap.put('datePropositionCommerciale', '2019-11-08T00:00:00');
		inputMap.put('dateEffetContrat', '2019-11-08T00:00:00');
		inputMap.put('codeCommune', '59350');
		inputMap.put('codePostal', '59000');
		inputMap.put('codePlageConso', '3000');
	
		// SM_AP81_OffresEtPrixVue360 service = new SM_AP81_OffresEtPrixVue360() ;
		outMap = SM_AP83_OffresEtPrixVue360.getOffresEtPrix(inputMap);
		system.debug('@outputMap: '+outMap);
		
        Test.stopTest();
	}
	
	@isTest(SeeAllData = false)
	public static void testCallout_Gaz() {
		Product2 offreGaz = new Product2();
		offreGaz.TypeOffre__c = 'TradeOFF';
		offreGaz.FamilyLabel__c = 'Référence Gaz 1 an';
		offreGaz.Family = 'GBUGR1_P';
		offreGaz.name = 'Référence Gaz 1 an';
		offreGaz.vlocity_cmt__Type__c = 'Gaz';
		offreGaz.ProductCode = 'GBUGR1';
		offreGaz.IsActive = true;
			
		List<Product2> prodList = new List<Product2>();
		prodList.add(offreGaz);
		insert prodList;
		
		Choix_Offre__c choixOffre = new Choix_Offre__c();
		choixOffre.debut_Validite_Offre__c = date.today();
		choixOffre.Energie__c = 'Gaz';
		choixOffre.Actif__c = true;
		insert choixOffre;
			
		Test.startTest();
		
		
		// Test 2
		Map < String, Object > outMap2 = new Map < String, Object >();
		Map < String, Object > inputMap2 = new Map < String, Object >();
		inputMap2.put('EnergyTypeOptions', 'Gaz');
		inputMap2.put('idOffre', 'GBUGR1');
		inputMap2.put('idPack', 'GBUGR1_P');
		inputMap2.put('datePropositionCommerciale', '2019-08-07T00:00:00');
		inputMap2.put('dateEffetContrat', '2019-08-07T00:00:00');
		inputMap2.put('codeCommune', '21231');
		inputMap2.put('codePostal', '21000');
		inputMap2.put('codePlageConso', '30000');
	
		// SM_AP81_OffresEtPrixVue360 service = new SM_AP81_OffresEtPrixVue360() ;
		outMap2 = SM_AP83_OffresEtPrixVue360.getOffresEtPrix(inputMap2);
		system.debug('@outputMap: '+outMap2);
		
        Test.stopTest();
	}
	
	@isTest(SeeAllData = false)
	public static void testCallout_Dual() {
		Product2 offreGaz = new Product2();
		offreGaz.TypeOffre__c = 'TradeOFF';
		offreGaz.FamilyLabel__c = 'Référence Gaz 1 an';
		offreGaz.SM_structureMesureFournisseur__c = 'STR_MESURE_SIMPLE';
		offreGaz.Family = 'DGBUEBUGR1_P';
		offreGaz.name = 'Référence Gaz 1 an';
		offreGaz.vlocity_cmt__Type__c = 'Gaz';
		offreGaz.ProductCode = 'GBUGR1';
		offreGaz.IsActive = true;

		Product2 offreElec = new Product2();
		offreElec.TypeOffre__c = 'TradeOFF';
		offreElec.FamilyLabel__c = 'Référence Elec 1 an';
		offreElec.Family = 'DGBUEBUGR1_P';
		offreElec.SM_structureMesureFournisseur__c = 'STR_MESURE_SIMPLE';
		offreElec.name = 'Référence Elec 1 an';
		offreElec.vlocity_cmt__Type__c = 'Elec';
		offreElec.ProductCode = 'EBUGR1';
		offreElec.offreVerte__c = true;
		offreElec.IsActive = true;
			
		List<Product2> prodList = new List<Product2>();
		prodList.add(offreGaz);
		prodList.add(offreElec);
		insert prodList;
		
		Choix_Offre__c choixOffre = new Choix_Offre__c();
		choixOffre.debut_Validite_Offre__c = date.today();
		// choixOffre.Energie__c = 'Dual';
		choixOffre.Actif__c = true;
		insert choixOffre;
			
		Test.startTest();
		
		
		// Test 2
		Map < String, Object > outMap2 = new Map < String, Object >();
		Map < String, Object > inputMap2 = new Map < String, Object >();
		inputMap2.put('EnergyTypeOptions', 'Dual');
		inputMap2.put('idOffre1', 'EBUGR1');
		inputMap2.put('idOffre2', 'GBUGR1');
		inputMap2.put('idPack', 'DGBUEBUGR1_P');
		inputMap2.put('niveauOuvertureServices', '0');
		inputMap2.put('typeComptageDifferencie', 'Simple');
		inputMap2.put('dateDerniereModificationFormuleTarifaireAcheminement', '1971-07-22T00:00:00.000Z');
		inputMap2.put('Puissance', 9);
		inputMap2.put('CAEElec', 4361);
		inputMap2.put('ftaCode', 'BTINFCUST');
		inputMap2.put('datePropositionCommerciale', '2020-04-03T00:00:00');
		inputMap2.put('dateEffetContrat', '2020-04-04T00:00:00');
		inputMap2.put('codeCommune', '37063');
		inputMap2.put('codePostal', '37110');
		inputMap2.put('codePlageConso', '30000');
	
		// SM_AP81_OffresEtPrixVue360 service = new SM_AP81_OffresEtPrixVue360() ;
		outMap2 = SM_AP83_OffresEtPrixVue360.getOffresEtPrix(inputMap2);
		system.debug('@outputMap: '+outMap2);
		
        Test.stopTest();
	}

	@isTest(SeeAllData = false)
	public static void testCallout_HCHP_Elec() {
		Product2 offreElec = new Product2();
		offreElec.TypeOffre__c = 'TradeOFF';
		offreElec.FamilyLabel__c = 'Référence Elec verte 1 an';
		offreElec.SM_structureMesureFournisseur__c = 'STR_MESURE_SIMPLE';
		offreElec.Family = 'EBUVR1_P';
		offreElec.name = 'Référence Elec verte 1 an';
		offreElec.vlocity_cmt__Type__c = 'ELEC';
		offreElec.ProductCode = 'EBUVR1';
		offreElec.offreVerte__c = true;
		offreElec.IsActive = true;

		List<Product2> prodList = new List<Product2>();
		prodList.add(offreElec);
		insert prodList;
		
		Choix_Offre__c choixOffre = new Choix_Offre__c();
		choixOffre.debut_Validite_Offre__c = date.today();
		// choixOffre.Energie__c = 'Dual';
		choixOffre.Actif__c = true;
		insert choixOffre;
			
		Test.startTest();
		
		
		// Test 2
		Map < String, Object > outMap2 = new Map < String, Object >();
		Map < String, Object > inputMap2 = new Map < String, Object >();
		inputMap2.put('EnergyTypeOptions', 'ELEC');
		inputMap2.put('idOffre', 'EBUVR1');
		inputMap2.put('idPack', 'EBUVR1_P');
		inputMap2.put('niveauOuvertureServices', '2');
		inputMap2.put('typeComptageDifferencie', 'Simple');
		inputMap2.put('dateDerniereModificationFormuleTarifaireAcheminement', '2020-01-28T00:00:00.000Z');
		inputMap2.put('Puissance', 6);
		inputMap2.put('CAEElec', 2335);
		inputMap2.put('ftaCode', 'BTINFCU4');
		inputMap2.put('datePropositionCommerciale', '2020-05-05T00:00:00');
		inputMap2.put('dateEffetContrat', '2020-06-04T00:00:00');
		inputMap2.put('codeCommune', '30133');
		inputMap2.put('codePostal', '30240');
	
		outMap2 = SM_AP83_OffresEtPrixVue360.getOffresEtPrix(inputMap2);
		system.debug('@outputMap: '+outMap2);
		
        Test.stopTest();
	}
	
	@isTest(SeeAllData = false)
	public static void testCallout_Elec_NotTradeOFF() {

		Product2 offreElec = new Product2();
		offreElec.TypeOffre__c = '';
		offreElec.FamilyLabel__c = 'Elec Ajust 2 ans';
		offreElec.Family = 'EBUAK2_P';
		offreElec.SM_structureMesureFournisseur__c = 'STR_MESURE_HPHC';
		offreElec.name = 'Elec Ajust 2 ans';
		offreElec.vlocity_cmt__Type__c = 'Elec';
		offreElec.ProductCode = 'EBUA2';
		offreElec.IsActive = true;
			
		List<Product2> prodList = new List<Product2>();
		prodList.add(offreElec);
		insert prodList;
		
		Choix_Offre__c choixOffre = new Choix_Offre__c();
		choixOffre.debut_Validite_Offre__c = date.today();
		choixOffre.Energie__c = 'Elec';
		choixOffre.Actif__c = true;
		insert choixOffre;
			
		Test.startTest();
		
		
		// Test 2
		Map < String, Object > outMap2 = new Map < String, Object >();
		Map < String, Object > inputMap2 = new Map < String, Object >();
		inputMap2.put('EnergyTypeOptions', 'Elec');
		inputMap2.put('idOffre', 'EBUA2');
		inputMap2.put('idPack', 'EBUAK2_P');
		inputMap2.put('niveauOuvertureServices', '1');
		inputMap2.put('typeComptageDifferencie', 'HPHC');
		inputMap2.put('dateDerniereModificationFormuleTarifaireAcheminement', '2011-01-04T00:00:00.000Z');
		inputMap2.put('Puissance', 6);
		inputMap2.put('CAEElec', 1122);
		inputMap2.put('ftaCode', 'BTINFMUDT');
		inputMap2.put('datePropositionCommerciale', '2019-12-02T00:00:00');
		inputMap2.put('dateEffetContrat', '2019-12-02T00:00:00');
		inputMap2.put('codeCommune', '18033');
		inputMap2.put('codePostal', '18000');
	
		// SM_AP81_OffresEtPrixVue360 service = new SM_AP81_OffresEtPrixVue360() ;
		outMap2 = SM_AP83_OffresEtPrixVue360.getOffresEtPrix(inputMap2);
		system.debug('@outputMap: '+outMap2);
		
        Test.stopTest();
    }
}