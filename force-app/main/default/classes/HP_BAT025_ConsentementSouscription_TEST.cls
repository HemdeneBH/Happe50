/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-21-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_BAT025_ConsentementSouscription_TEST {

    private static String expectedValue;
	private static String expectedValueConsent;

	private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
		HP_CreerConsentement_Mock,
		HP_PutConsentement_Mock,
        HP_Consentements_Response_MOCK
	}
    
    // @testSetup static void dataSetup(){
        
    //     List<HP_Souscription__c> souscriptions = new List<HP_Souscription__c>();
        
    //     HP_Souscription__c souscription1 = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
    //         'HP_Canal_de_vente__c'  => 'Vente Online',
    //         'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
    //         'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
    //         'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
    //         'HP_Code_postal__c'  => '92160',
    //         'HP_code_Postal_Insee__c'  => '92002',
    //         'HP_Date_de_Contractualisation__c'  => System.today().addDays(1),
    //         'HP_Date_Origine__c'  =>DateTime.newInstance(2019, 10, 9, 13, 0, 0),
    //         'HP_Energie_Verte__c'  => false,
    //         'HP_Estimation_Consommation_electrique__c'  => 6000,
    //         'HP_Estimation_Consommation_gaz__c'  => 13000,
    //         'HP_Jour_de_facturation__c' => 16,
    //         'HP_Lien_enregistrement__c' =>'test.fr',
    //         'HP_Methode_de_paiement__c' =>'BANK_CARD',
    //         'HP_Montant_de_la_facturation_electrique__c' =>58,
    //         'HP_Montant_de_la_facturation_gaz__c' =>120,
    //         'HP_Predecesseur__c' =>'Dupont',
    //         'HP_Nom_de_rue__c' =>'rue des bois',
    //         'HP_Nom_de_ville__c' =>'ANTONY',
    //         'HP_Numero_de_voie__c' =>'15 ter',
    //         'HP_Periode_de_facturation__c' =>'BIMONTHLY',
    //         'HP_Plan_de_Prix_electrique__c' =>'BASE',
    //         'HP_Puissance_Compteur_electrique__c' =>6,
    //         'HP_Souscription_Digital_Id__c' =>'test-rappel-01',
    //         'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
    //         'HP_type_Souscription__c' =>'MOVING_IN',
    //         'HP_NumberPCE__c' =>'31431211214068',
    //         'HP_NumPDL__c' =>'31431211214170',
    //         'HP_Statut__c' => 'SAVE_3',
    //         'Hp_consentementXdata__c'=>false,
    //         'Hp_consentementQ1_1__c' =>true,
    //         'Hp_consentementQ1_2__c' =>true,
    //         'Hp_consentementQ1_3__c' =>true,
    //         'HP_TECH_ConsentementIncrement__c'=>8,
    //         'HP_DigitalDateSave2__c' => Date.today().addDays(-1),
    //         'OwnerId' => UserInfo.getUserId()}, null);    
    
    //     souscriptions.add(souscription1);
           
    //     insert souscriptions;
    // }
    
    @isTest static void HP_BAT025_ConsentementSouscription_TEST_OK(){

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{

            'Id_Tiers__c' => 85192620,

            'HP_IsHappe__c' => true,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'Email'=>'test@email.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        },null, null, null);
        insert contact;

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
            'HP_Statut__c' => 'SAVE_3',
            'Hp_consentementXdata__c'=>false,
            'Hp_consentementQ1_1__c' =>true,
            'Hp_consentementQ1_2__c' =>true,
            'Hp_consentementQ1_3__c' =>true,
            'HP_TECH_ConsentementIncrement__c'=>2,
            'HP_Contact__c'=>contact.Id,
            'HP_DigitalDateSave2__c' => Date.today().addDays(-1),
            'OwnerId' => UserInfo.getUserId()}, null); 
            insert souscription1;
        
        expectedValueConsent = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CreerConsentement_Mock.name());
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'getConsentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
												  null,
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap2 = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  'HP_Consentements_Response_MOCK',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap2));
        
        HP_BAT025_ConsentementSouscription.execute();
        Test.stopTest();   
        HP_Souscription__c sous = [Select Id, Hp_consentementXdata__c from HP_Souscription__c limit 1];
        System.assertEquals(true, sous.Hp_consentementXdata__c, 'MAJ Consentements OK');
    }

    @isTest static void HP_BAT025_ConsentementSouscription_TEST(){

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
            'HP_Statut__c' => 'SAVE_3',
            'Hp_consentementXdata__c'=>false,
            'Hp_consentementQ1_1__c' =>true,
            'Hp_consentementQ1_2__c' =>true,
            'Hp_consentementQ1_3__c' =>true,
            'HP_TECH_ConsentementIncrement__c'=>3,
            'HP_DigitalDateSave2__c' => Date.today().addDays(-1),
            'OwnerId' => UserInfo.getUserId()}, null); 
            insert souscription1;
        
        expectedValueConsent = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CreerConsentement_Mock.name());
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
												  null,
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap2 = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  'HP_SM008_APIHour_ReponsesConsentement',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap2));
        HP_BAT025_ConsentementSouscription.execute();
        Test.stopTest();   
        HP_Souscription__c sous = [Select Id, Hp_consentementXdata__c from HP_Souscription__c limit 1];
        System.assertEquals(true, sous.Hp_consentementXdata__c, 'MAJ Consentements OK');
    }

    @isTest static void HP_BAT025_ConsentementSouscription_TEST_POST(){

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
            'HP_Statut__c' => 'SAVE_3',
            'Hp_consentementXdata__c'=>false,
            'Hp_consentementQ1_1__c' =>true,
            'Hp_consentementQ1_2__c' =>true,
            'Hp_consentementQ1_3__c' =>true,
            'HP_TECH_ConsentementIncrement__c'=>3,
            'HP_DigitalDateSave2__c' => Date.today().addDays(-1),
            'OwnerId' => UserInfo.getUserId()}, null); 
            insert souscription1;
        
        expectedValueConsent = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CreerConsentement_Mock.name());
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
												  null,
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap2 = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  'HP_Consentements_Response_MOCK_KO',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap2));
        HP_BAT025_ConsentementSouscription.execute();
        Test.stopTest();   
        HP_Souscription__c sous = [Select Id, Hp_consentementXdata__c from HP_Souscription__c limit 1];
        System.assertEquals(true, sous.Hp_consentementXdata__c, 'MAJ Consentements OK');
    }

    @isTest static void HP_BAT025_ConsentementSouscription_TEST_KO(){

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
            'HP_Statut__c' => 'SAVE_3',
            'Hp_consentementXdata__c'=>false,
            'Hp_consentementQ1_1__c' =>true,
            'Hp_consentementQ1_2__c' =>true,
            'Hp_consentementQ1_3__c' =>true,
            'HP_TECH_ConsentementIncrement__c'=>8,
            'HP_DigitalDateSave2__c' => Date.today().addDays(-1),
            'OwnerId' => UserInfo.getUserId()}, null); 
            insert souscription1;
        
        expectedValueConsent = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_CreerConsentement_Mock.name());
		//Configurer le Mock
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
												  null,
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap2 = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'consentements' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
												  'HP_SM008_APIHour_ReponsesConsentement',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap2));
        HP_BAT025_ConsentementSouscription.execute();
        Test.stopTest();   
        Case aCase = [SELECT Id, HP_Type__c FROM Case limit 1];
        System.assertEquals('HP_ConsentementsDigital', acase.HP_Type__c, 'a case was created');
    }

    @isTest static void HP_BAT025_ConsentementSouscription_TEST_Schedule() {
        Test.startTest();
        final String jobName = 'HP_BAT025_ConsentementSouscription'+System.Math.random()*1000;
        final String cronExp = '0 0 4 ? * * *';
        HP_BAT019_SouscriptionRappel.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }

    @isTest static void createQuestionPut_TEST() {
        Test.startTest();
        Decimal idXdata = Decimal.ValueOf(123456);
        String question =HP_BAT025_ConsentementSouscription.createQuestionPut(idXdata, 1,true,'qsdf-wxet-aiu2');
        Test.stopTest();
    }

}