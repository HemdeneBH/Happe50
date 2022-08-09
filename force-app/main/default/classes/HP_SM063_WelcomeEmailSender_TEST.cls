/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Badr Eddine Belkarchi
 * Modifications Log 
 * Ver   Date         Author                 Modification
 * 1.0   07-13-2021   Hemdene Ben Hammouda   Initial Version
**/
@isTest
public with sharing class HP_SM063_WelcomeEmailSender_TEST {
    @TestSetUp 
	private static void insertTestData() {
        

        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{ 
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;


        HP_Offre__c offre = (HP_Offre__c)HP_UTIL_SmartFactory.createSObject('HP_Offre__c', null, new Map<String, Object>{
           
            // offreCode__c,offreId__c,marqueCode__c,packId__c,offreLibelle__c
            'offreCode__c' => 'EITR2_H',
            'offreId__c'=> 436
            
        }, null, null, null);
        insert offre;

        HP_Offre__c offreGaz = (HP_Offre__c)HP_UTIL_SmartFactory.createSObject('HP_Offre__c', null, new Map<String, Object>{
            'offreCode__c' => 'GITR2_H',
            'offreId__c'=> 435
            
        }, null, null, null);
        insert offreGaz;

        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
            'HP_Contact__c'=>contact.Id,
            'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
            'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
            'HP_Code_postal__c'  => '92160',
            'HP_code_Postal_Insee__c'  => '92002',
            'HP_Date_de_Contractualisation__c'  => Date.newInstance(2019, 12, 22),
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
            'HP_Souscription_Digital_Id__c' =>'testGazElec-01',
            'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
            'HP_type_Souscription__c' =>'MOVING_IN',
            'HP_NumberPCE__c' =>'31431211214068',
            'HP_NumPDL__c' =>'31431211214170',
            'HP_Statut__c' =>'SAVE_3'
		}, null);
        insert enrolment;

       
        HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
            'HP_Contact__c' => contact.id,
            //'Xdata_Id__c' => '1222',
            'HP_Souscription_Digital_Id__c'=>'testGazElec-01'
        }, null, null, null);
        insert porteFeuille;
		


        HP_Contrat__c cgaz =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
        new Map<String, Object>{ 
            'HP_Numero_reference_du_Compteur__c' => '423',
            'HP_Id_Compteur__c' => '31431211214068',
            'HP_Contrat_XdataId__c' => 100148,
            'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'GAS',
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'GAS',
            'HP_Index_de_Compteur__c'=>2323434
        }, null);
        insert cgaz;

        HP_Contrat__c celec =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
        new Map<String, Object>{ 
            'HP_Numero_reference_du_Compteur__c' => '423',
            'HP_Id_Compteur__c' => '31431211214170',
            'HP_Compteur_Base_Plan_Index__c' => 56726,
            'HP_Compteur_Variable_Plan_prix_Index__c' => 34251,
            'HP_Compteur_Plan_Bottom_Price_Index__c' => 78098,
            'HP_Contrat_XdataId__c' => 100149,
            'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'ELEC',
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'ELEC'
        }, null);
        insert celec;

	}

    @isTest
    static void sendSouscriptionEnAttenteDeValidationEmail_TEST(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth.marketingcloudapis.com/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_MarketingCloudAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            '/messaging/v1/email/messages/' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(202,
                                                  'HP_MarketingCloudResponseOk',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        
        HP_Souscription__c souscription = [SELECT Id from HP_Souscription__c limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM063_WelcomeEmailSender.sendSouscriptionEnAttenteDeValidationEmail(souscription.Id, '1278760', '1278758', true, false);
        Test.stopTest();     
    }

    @isTest
    static void sendWelcomeEmailOk_TEST(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth.marketingcloudapis.com/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_MarketingCloudAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            '/messaging/v1/email/messages/' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(202,
                                                  'HP_MarketingCloudResponseOk',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        HP_Souscription__c souscription = [SELECT Id from HP_Souscription__c limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM063_WelcomeEmailSender.sendWelcomeEmail(souscription.Id, '1278760', '1278758', true, false);
        Test.stopTest();     
    }

    @isTest
    static void sendWelcomeEmailOkk_Test(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth.marketingcloudapis.com/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_MarketingCloudAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            '/messaging/v1/email/messages/' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(202,
                                                  'HP_MarketingCloudResponseOk',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        HP_Souscription__c souscription = [SELECT Id from HP_Souscription__c limit 1];
        Contact con = [SELECT Id,Email from Contact limit 1];
        con.Email = 'test_engie@example.com';
        update con;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM063_WelcomeEmailSender.sendWelcomeEmail(souscription.Id, '1278760', '1278758', true, false);
        Test.stopTest();     
    }

    @isTest
    static void sendWelcomeEmailKo_TEST(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'auth.marketingcloudapis.com/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                   'HP_MarketingCloudAccessTokenResponse_MOCK',
                                                   new Map<String, String> {'Content-Type' => 'application/json'}),

            '/messaging/v1/email/messages/' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400,
                                                  'HP_MarketingCloudResponseKo',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}
                                                  )
        };
        HP_Souscription__c souscription = [SELECT Id from HP_Souscription__c limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM063_WelcomeEmailSender.sendWelcomeEmail(souscription.Id, '1278760', '1278758', true, false);
        Test.stopTest();     
    }
}