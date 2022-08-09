/**
 * @File Name          : HP_BAT002_Contractualisation_TEST.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 02-02-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/02/2020   Vincent Albiser     Initial Version
**/
@isTest
public with sharing class HP_SM024_Case_TEST {

    private enum StaticResource {
        HP_SM020_SouscriptionSave1_TEST,
        HP_SM020_SouscriptionSave1KO_TEST,
        HP_SM021_SouscriptionSave2_TEST,
        HP_SM021_SouscriptionSave2Case_TEST,
        HP_SM022_SouscriptionSave3_TEST,
        HP_APIHourCommercialProposition_POST_MOCK,
        HP_AGILAB_SOUSCRIPTION_MOCK,
        HP_APIHourAccessTokenResponse_MOCK,
        HP_AGILAB_CONTRACTUALISATION_MOCK,
        HP_ES_PDLGaz_v2_Mock,
        HP_PrestaGazOk_Mock,
        HP_ES_PDLElec_v3_Mock,
        HP_SendEmail_Mock
    }

    @TestSetUp 
	private static void insertTestData() {
    }
    


    @istest
    static void save3ToDay(){
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
            'HP_Date_de_Contractualisation__c'  => System.today(),
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
            'HP_Statut__c' =>'SAVE_1'
		}, null);
        insert enrolment;



       
        HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
            'HP_Contact__c' => contact.id,
            'Xdata_Id__c' => '1222',
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


        
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),

            'propositions/souscription' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			'HP_AGILAB_SOUSCRIPTION_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
           
            'ES-PDLGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLGaz_v2_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),

            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLGaz_v2_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaGazMock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),

            'propositions/contractualisation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			'HP_AGILAB_CONTRACTUALISATION_MOCK',
			new Map<String, String> {'Content-Type' => 'application/json'}),

			'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			null,
            new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
			'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_APIHourCommercialProposition_POST_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'})
            };
           

        final String enrolmentRestResourceSave3Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM022_SouscriptionSave3_TEST.name());
		RestRequest reqSave3 = new RestRequest();
		reqSave3.requestURI = '/services/apexrest/v1/enrolment';
		reqSave3.httpMethod = 'POST';
		reqSave3.requestBody = Blob.valueof(enrolmentRestResourceSave3Json);
		RestContext.request = reqSave3;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		RestContext.response= new RestResponse();
		HP_WS007_Souscription.post();
        Test.stopTest();
        

    }


    @istest
    static void save3After42Days(){
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
            'HP_Date_de_Contractualisation__c'  => System.today().addDays(43),
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
            'HP_Statut__c' =>'SAVE_1'
		}, null);
        insert enrolment;



       
        HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
            'HP_Contact__c' => contact.id,
            'Xdata_Id__c' => '1222',
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


        
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),

            'propositions/souscription' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			'HP_AGILAB_SOUSCRIPTION_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
           
            'ES-PDLGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLGaz_v2_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),

            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLGaz_v2_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaGazMock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),

            'propositions/contractualisation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			'HP_AGILAB_CONTRACTUALISATION_MOCK',
			new Map<String, String> {'Content-Type' => 'application/json'}),

			'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			null,
            new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
			'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_APIHourCommercialProposition_POST_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'})
            };
           

        final String enrolmentRestResourceSave3Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM022_SouscriptionSave3_TEST.name());
		RestRequest reqSave3 = new RestRequest();
		reqSave3.requestURI = '/services/apexrest/v1/enrolment';
		reqSave3.httpMethod = 'POST';
		reqSave3.requestBody = Blob.valueof(enrolmentRestResourceSave3Json);
		RestContext.request = reqSave3;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		RestContext.response= new RestResponse();
		HP_WS007_Souscription.post();
        Test.stopTest();
        

    }
    
    @istest
    static void save3After12Days(){
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
            'HP_Date_de_Contractualisation__c'  => System.today().addDays(12),
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
            'HP_Statut__c' =>'SAVE_1'
		}, null);
        insert enrolment;



       
        HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
            'HP_Contact__c' => contact.id,
            'Xdata_Id__c' => '1222',
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


        
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),

            'propositions/souscription' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			'HP_AGILAB_SOUSCRIPTION_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
           
            'ES-PDLGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLGaz_v2_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),

            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLGaz_v2_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaGazMock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),

            'propositions/contractualisation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			'HP_AGILAB_CONTRACTUALISATION_MOCK',
			new Map<String, String> {'Content-Type' => 'application/json'}),

			'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			null,
            new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
            'ES-PrestationServiceGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                StaticResource.HP_PrestaGazOk_Mock.name(),
                new Map<String, String> {'Content-Type' => 'text/xml'}
            ),
			'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_APIHourCommercialProposition_POST_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'})
            };
           

        final String enrolmentRestResourceSave3Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM022_SouscriptionSave3_TEST.name());
		RestRequest reqSave3 = new RestRequest();
		reqSave3.requestURI = '/services/apexrest/v1/enrolment';
		reqSave3.httpMethod = 'POST';
		reqSave3.requestBody = Blob.valueof(enrolmentRestResourceSave3Json);
		RestContext.request = reqSave3;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		RestContext.response= new RestResponse();
		HP_WS007_Souscription.post();
        Test.stopTest();
        

    }
    
    @isTest 
    public static void createPrestation() {
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

        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Canal_de_vente__c'  => 'Vente Online',
            'HP_Contact__c'=>contact.Id,
            'HP_Classe_de_la_consommation_Gaz__c'  => 'B0',
            'HP_Code_Gaz_Produit__c'  => 'GITR2_H',
            'HP_Code_Electrique_Produit__c'  => 'EITR2_H',
            'HP_Code_postal__c'  => '92160',
            'HP_code_Postal_Insee__c'  => '92002',
            'HP_Date_de_Contractualisation__c'  => System.today().addDays(12),
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
            'HP_Statut__c' =>'SAVE_1'
		}, null);
        insert enrolment;	


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

        Test.startTest();
        Prestation_distributeur__c presta = HP_SM024_Case.createPrestation(enrolment, contact, celec, 'test');
        Test.stopTest();
        System.assert(presta != null);
    }
    
    
    @istest
    public static void loadReclamationCaseTest(){
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
        HP_SM024_Case.loadReclamationCase(contact.Id);
    }


    
    @istest
    static void saveException(){
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
            'HP_Date_de_Contractualisation__c'  => System.today(),
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
            'HP_Statut__c' =>'SAVE_1'
		}, null);
        insert enrolment;



       
        HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
            'HP_Contact__c' => contact.id,
            'Xdata_Id__c' => '1222',
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


        
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
			StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
            new Map<String, String> {'Content-Type' => 'application/json'}),
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
            'HP_APIHourAccessTokenResponse_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),

            'propositions/souscription' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
			'HP_AGILAB_SOUSCRIPTION_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'}),
           
            'ES-PDLGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
			'HP_ES_PDLGaz_v2_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),

            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
			'HP_ES_PDLGaz_v2_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
			'HP_PrestaGazMock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),

            'propositions/contractualisation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
			'HP_AGILAB_CONTRACTUALISATION_MOCK',
			new Map<String, String> {'Content-Type' => 'application/json'}),

			'portefeuilles-contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
			null,
            new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/xml'}
            ),
			'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
			'HP_APIHourCommercialProposition_POST_MOCK',
            new Map<String, String> {'Content-Type' => 'application/json'})
            };
           

        final String enrolmentRestResourceSave3Json = HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(StaticResource.HP_SM022_SouscriptionSave3_TEST.name());
		RestRequest reqSave3 = new RestRequest();
		reqSave3.requestURI = '/services/apexrest/v1/enrolment';
		reqSave3.httpMethod = 'POST';
		reqSave3.requestBody = Blob.valueof(enrolmentRestResourceSave3Json);
		RestContext.request = reqSave3;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		RestContext.response= new RestResponse();
		HP_WS007_Souscription.post();
        Test.stopTest();
        

    }

    @istest
    static void reaffectCase(){
         Case caseN1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Chat', new Map<String, Object> {
            'Status' => 'TO_DO',
            'Priority' => 'High',
            'HP_QueueCible__c' => 'Niveau 1',
            'OwnerId' => UserInfo.getUserId()
            }, null,null,null);
        List<Case> caseList = new List<Case>();
        caseList.add(caseN1);
        Test.startTest();
        insert caseList;
        HP_SM024_Case.reaffectCase(caseList);
        Test.stopTest();
    }

}