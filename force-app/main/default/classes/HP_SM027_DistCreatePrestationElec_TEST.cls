/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 03-15-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_SM027_DistCreatePrestationElec_TEST {
    
    private enum StaticResource {
        HP_PrestaElecMock,
        HP_ES_PDLElec_v3_Mock
    }


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

        HP_Souscription__c souscription = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
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
        insert souscription;

        HP_Contrat__c contrat_elec =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
        new Map<String, Object>{ 
            'HP_Numero_reference_du_Compteur__c' => '423',
            'HP_Id_Compteur__c' => '31431211214170',
            'HP_Compteur_Base_Plan_Index__c' => 56726,
            'HP_Compteur_Variable_Plan_prix_Index__c' => 34251,
            'HP_Compteur_Plan_Bottom_Price_Index__c' => 78098,
            'HP_Contrat_XdataId__c' => 100149,
            'HP_Souscription_Digital_Id__c' => souscription.HP_Souscription_Digital_Id__c+'ELEC',
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Souscription__c'=> souscription.id,
            'HP_Type_de_Compteur__c' => 'ELEC'
        }, null);
        insert contrat_elec;

    }


    @istest
    static void sendRequestMovingINEnroll(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLElec_v3_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'})
            };

        Contact contact = [SELECT Id_Tiers__c,Salutation,lastName,firstName,email,mobilePhone,
        Phone,No_Voie__c,MailingStreet,MailingPostalCode,Complement_adresse__c,MailingCity 
        FROM Contact LIMIT 1];

        HP_Souscription__c souscription = [SELECT HP_Canal_de_vente__c,HP_Contact__c,HP_Classe_de_la_consommation_Gaz__c,HP_Code_Gaz_Produit__c,
        HP_Code_Electrique_Produit__c,HP_Code_postal__c,HP_code_Postal_Insee__c,HP_Date_de_Contractualisation__c,HP_Date_Origine__c,
        HP_Energie_Verte__c,HP_Estimation_Consommation_electrique__c,HP_Estimation_Consommation_gaz__c,HP_Jour_de_facturation__c,HP_Lien_enregistrement__c,
        HP_Methode_de_paiement__c,HP_Montant_de_la_facturation_electrique__c,HP_Montant_de_la_facturation_gaz__c,HP_Predecesseur__c,HP_Nom_de_rue__c,
        HP_Nom_de_ville__c,HP_Numero_de_voie__c,HP_Periode_de_facturation__c,HP_Plan_de_Prix_electrique__c,HP_Puissance_Compteur_electrique__c,
        HP_Souscription_Digital_Id__c,HP_Type_Energie__c,HP_type_Souscription__c,HP_NumberPCE__c,HP_NumPDL__c,HP_Statut__c
        FROM HP_Souscription__c LIMIT 1];

        HP_Contrat__c contrat_elec = [SELECT HP_Numero_reference_du_Compteur__c,HP_Id_Compteur__c,HP_Compteur_Base_Plan_Index__c,HP_Compteur_Variable_Plan_prix_Index__c,HP_Compteur_Plan_Bottom_Price_Index__c,
        HP_Contrat_XdataId__c,HP_Souscription_Digital_Id__c,HP_Proposition_Commerciale_XdataId__c,HP_Souscription__c,HP_Type_de_Compteur__c,HP_Index_de_Compteur__c 
        FROM HP_Contrat__c LIMIT 1];


        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 

        HP_EnergyRequest energyRequest = new HP_EnergyRequest(souscription.HP_type_Souscription__c, contrat_elec.HP_Id_Compteur__c,
								     (Integer)(contrat_elec.HP_Type_de_Compteur__c == 'GAS' ? contrat_elec.HP_Index_de_Compteur__c :
									       contrat_elec.HP_Compteur_Base_Plan_Index__c != null ?  contrat_elec.HP_Compteur_Base_Plan_Index__c :
									       contrat_elec.HP_Compteur_Variable_Plan_prix_Index__c ));
        HP_EnergyResponse energyResponse = HP_SM024_Case.precontratOCTOPUS(souscription, contrat_elec, energyRequest);

        HP_EnergyContractRequest energyContractRequest = HP_EM023_Contrat.energyContractRequestBuilder(contact, souscription, contrat_elec);

        HP_EnergyContractResponse energyContractResponse = HP_SM027_DistCreatePrestationElec.sendRequest(energyContractRequest, 'MOVING_IN', energyResponse, null);
        Test.stopTest();

        System.assert(energyContractResponse!=null, 'Test OK, Object Non NUll');

    }

    @istest
    static void sendRequestSwitchEnroll(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLElec_v3_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'})
            };

        Contact contact = [SELECT Id_Tiers__c,Salutation,lastName,firstName,email,mobilePhone,
        Phone,No_Voie__c,MailingStreet,MailingPostalCode,Complement_adresse__c,MailingCity 
        FROM Contact LIMIT 1];

        HP_Souscription__c souscription = [SELECT HP_Canal_de_vente__c,HP_Contact__c,HP_Classe_de_la_consommation_Gaz__c,HP_Code_Gaz_Produit__c,
        HP_Code_Electrique_Produit__c,HP_Code_postal__c,HP_code_Postal_Insee__c,HP_Date_de_Contractualisation__c,HP_Date_Origine__c,
        HP_Energie_Verte__c,HP_Estimation_Consommation_electrique__c,HP_Estimation_Consommation_gaz__c,HP_Jour_de_facturation__c,HP_Lien_enregistrement__c,
        HP_Methode_de_paiement__c,HP_Montant_de_la_facturation_electrique__c,HP_Montant_de_la_facturation_gaz__c,HP_Predecesseur__c,HP_Nom_de_rue__c,
        HP_Nom_de_ville__c,HP_Numero_de_voie__c,HP_Periode_de_facturation__c,HP_Plan_de_Prix_electrique__c,HP_Puissance_Compteur_electrique__c,
        HP_Souscription_Digital_Id__c,HP_Type_Energie__c,HP_type_Souscription__c,HP_NumberPCE__c,HP_NumPDL__c,HP_Statut__c
        FROM HP_Souscription__c LIMIT 1];

        HP_Contrat__c contrat_elec = [SELECT HP_Numero_reference_du_Compteur__c,HP_Id_Compteur__c,HP_Compteur_Base_Plan_Index__c,HP_Compteur_Variable_Plan_prix_Index__c,HP_Compteur_Plan_Bottom_Price_Index__c,
        HP_Contrat_XdataId__c,HP_Souscription_Digital_Id__c,HP_Proposition_Commerciale_XdataId__c,HP_Souscription__c,HP_Type_de_Compteur__c,HP_Index_de_Compteur__c 
        FROM HP_Contrat__c LIMIT 1];


        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 

        HP_EnergyRequest energyRequest = new HP_EnergyRequest(souscription.HP_type_Souscription__c, contrat_elec.HP_Id_Compteur__c,
								     (Integer)(contrat_elec.HP_Type_de_Compteur__c == 'GAS' ? contrat_elec.HP_Index_de_Compteur__c :
									       contrat_elec.HP_Compteur_Base_Plan_Index__c != null ?  contrat_elec.HP_Compteur_Base_Plan_Index__c :
									       contrat_elec.HP_Compteur_Variable_Plan_prix_Index__c ));
        HP_EnergyResponse energyResponse = HP_SM024_Case.precontratOCTOPUS(souscription, contrat_elec, energyRequest);

        HP_EnergyContractRequest energyContractRequest = HP_EM023_Contrat.energyContractRequestBuilder(contact, souscription, contrat_elec);

        HP_EnergyContractResponse energyContractResponse = HP_SM027_DistCreatePrestationElec.sendRequest(energyContractRequest, 'SWITCH_SUPLIER', energyResponse, null);
        Test.stopTest();

        System.assert(energyContractResponse!=null, 'Test OK, Object Non NUll');

    }

    @istest
    static void sendRequestCoupure(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLElec_v3_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'})
            };

        Contact contact = [SELECT Id_Tiers__c,Salutation,lastName,firstName,email,mobilePhone,
        Phone,No_Voie__c,MailingStreet,MailingPostalCode,Complement_adresse__c,MailingCity 
        FROM Contact LIMIT 1];

        HP_Souscription__c souscription = [SELECT HP_Canal_de_vente__c,HP_Contact__c,HP_Classe_de_la_consommation_Gaz__c,HP_Code_Gaz_Produit__c,
        HP_Code_Electrique_Produit__c,HP_Code_postal__c,HP_code_Postal_Insee__c,HP_Date_de_Contractualisation__c,HP_Date_Origine__c,
        HP_Energie_Verte__c,HP_Estimation_Consommation_electrique__c,HP_Estimation_Consommation_gaz__c,HP_Jour_de_facturation__c,HP_Lien_enregistrement__c,
        HP_Methode_de_paiement__c,HP_Montant_de_la_facturation_electrique__c,HP_Montant_de_la_facturation_gaz__c,HP_Predecesseur__c,HP_Nom_de_rue__c,
        HP_Nom_de_ville__c,HP_Numero_de_voie__c,HP_Periode_de_facturation__c,HP_Plan_de_Prix_electrique__c,HP_Puissance_Compteur_electrique__c,
        HP_Souscription_Digital_Id__c,HP_Type_Energie__c,HP_type_Souscription__c,HP_NumberPCE__c,HP_NumPDL__c,HP_Statut__c
        FROM HP_Souscription__c LIMIT 1];

        HP_Contrat__c contrat_elec = [SELECT HP_Numero_reference_du_Compteur__c,HP_Id_Compteur__c,HP_Compteur_Base_Plan_Index__c,HP_Compteur_Variable_Plan_prix_Index__c,HP_Compteur_Plan_Bottom_Price_Index__c,
        HP_Contrat_XdataId__c,HP_Souscription_Digital_Id__c,HP_Proposition_Commerciale_XdataId__c,HP_Souscription__c,HP_Type_de_Compteur__c,HP_Index_de_Compteur__c 
        FROM HP_Contrat__c LIMIT 1];


        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 

        HP_EnergyRequest energyRequest = new HP_EnergyRequest(souscription.HP_type_Souscription__c, contrat_elec.HP_Id_Compteur__c,
								     (Integer)(contrat_elec.HP_Type_de_Compteur__c == 'GAS' ? contrat_elec.HP_Index_de_Compteur__c :
									       contrat_elec.HP_Compteur_Base_Plan_Index__c != null ?  contrat_elec.HP_Compteur_Base_Plan_Index__c :
									       contrat_elec.HP_Compteur_Variable_Plan_prix_Index__c ));
        HP_EnergyResponse energyResponse = HP_SM024_Case.precontratOCTOPUS(souscription, contrat_elec, energyRequest);

        HP_EnergyContractRequest energyContractRequest = HP_EM023_Contrat.energyContractRequestBuilder(contact, souscription, contrat_elec);

        HP_EnergyContractResponse energyContractResponse = HP_SM027_DistCreatePrestationElec.sendRequest(energyContractRequest, 'COUPURE', energyResponse, null);
        Test.stopTest();

        System.assert(energyContractResponse!=null, 'Test OK, Object Non NUll');

    }

    @istest
    static void sendRequestReduction(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLElec_v3_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'})
            };

        Contact contact = [SELECT Id_Tiers__c,Salutation,lastName,firstName,email,mobilePhone,
        Phone,No_Voie__c,MailingStreet,MailingPostalCode,Complement_adresse__c,MailingCity 
        FROM Contact LIMIT 1];

        HP_Souscription__c souscription = [SELECT HP_Canal_de_vente__c,HP_Contact__c,HP_Classe_de_la_consommation_Gaz__c,HP_Code_Gaz_Produit__c,
        HP_Code_Electrique_Produit__c,HP_Code_postal__c,HP_code_Postal_Insee__c,HP_Date_de_Contractualisation__c,HP_Date_Origine__c,
        HP_Energie_Verte__c,HP_Estimation_Consommation_electrique__c,HP_Estimation_Consommation_gaz__c,HP_Jour_de_facturation__c,HP_Lien_enregistrement__c,
        HP_Methode_de_paiement__c,HP_Montant_de_la_facturation_electrique__c,HP_Montant_de_la_facturation_gaz__c,HP_Predecesseur__c,HP_Nom_de_rue__c,
        HP_Nom_de_ville__c,HP_Numero_de_voie__c,HP_Periode_de_facturation__c,HP_Plan_de_Prix_electrique__c,HP_Puissance_Compteur_electrique__c,
        HP_Souscription_Digital_Id__c,HP_Type_Energie__c,HP_type_Souscription__c,HP_NumberPCE__c,HP_NumPDL__c,HP_Statut__c
        FROM HP_Souscription__c LIMIT 1];

        HP_Contrat__c contrat_elec = [SELECT HP_Numero_reference_du_Compteur__c,HP_Id_Compteur__c,HP_Compteur_Base_Plan_Index__c,HP_Compteur_Variable_Plan_prix_Index__c,HP_Compteur_Plan_Bottom_Price_Index__c,
        HP_Contrat_XdataId__c,HP_Souscription_Digital_Id__c,HP_Proposition_Commerciale_XdataId__c,HP_Souscription__c,HP_Type_de_Compteur__c,HP_Index_de_Compteur__c 
        FROM HP_Contrat__c LIMIT 1];


        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 

        HP_EnergyRequest energyRequest = new HP_EnergyRequest(souscription.HP_type_Souscription__c, contrat_elec.HP_Id_Compteur__c,
								     (Integer)(contrat_elec.HP_Type_de_Compteur__c == 'GAS' ? contrat_elec.HP_Index_de_Compteur__c :
									       contrat_elec.HP_Compteur_Base_Plan_Index__c != null ?  contrat_elec.HP_Compteur_Base_Plan_Index__c :
									       contrat_elec.HP_Compteur_Variable_Plan_prix_Index__c ));
        HP_EnergyResponse energyResponse = HP_SM024_Case.precontratOCTOPUS(souscription, contrat_elec, energyRequest);

        HP_EnergyContractRequest energyContractRequest = HP_EM023_Contrat.energyContractRequestBuilder(contact, souscription, contrat_elec);

        HP_EnergyContractResponse energyContractResponse = HP_SM027_DistCreatePrestationElec.sendRequest(energyContractRequest, 'REDUCTION', energyResponse, null);
        Test.stopTest();

        System.assert(energyContractResponse!=null, 'Test OK, Object Non NUll');

    }

    @istest
    static void sendRequestRetablissement(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PDLElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_ES_PDLElec_v3_Mock',
            new Map<String, String> {'Content-Type' => 'application/xml'}),
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201, 
			'HP_PrestaElecMock',
            new Map<String, String> {'Content-Type' => 'application/xml'})
            };

        Contact myContact = [SELECT Id_Tiers__c,Salutation,lastName,firstName,email,mobilePhone,
        Phone,No_Voie__c,MailingStreet,MailingPostalCode,Complement_adresse__c,MailingCity 
        FROM Contact LIMIT 1];

        HP_Souscription__c mySouscription = [SELECT HP_Canal_de_vente__c,HP_Contact__c,HP_Classe_de_la_consommation_Gaz__c,HP_Code_Gaz_Produit__c,
        HP_Code_Electrique_Produit__c,HP_Code_postal__c,HP_code_Postal_Insee__c,HP_Date_de_Contractualisation__c,HP_Date_Origine__c,
        HP_Energie_Verte__c,HP_Estimation_Consommation_electrique__c,HP_Estimation_Consommation_gaz__c,HP_Jour_de_facturation__c,HP_Lien_enregistrement__c,
        HP_Methode_de_paiement__c,HP_Montant_de_la_facturation_electrique__c,HP_Montant_de_la_facturation_gaz__c,HP_Predecesseur__c,HP_Nom_de_rue__c,
        HP_Nom_de_ville__c,HP_Numero_de_voie__c,HP_Periode_de_facturation__c,HP_Plan_de_Prix_electrique__c,HP_Puissance_Compteur_electrique__c,
        HP_Souscription_Digital_Id__c,HP_Type_Energie__c,HP_type_Souscription__c,HP_NumberPCE__c,HP_NumPDL__c,HP_Statut__c
        FROM HP_Souscription__c LIMIT 1];

        HP_Contrat__c contrat_elec = [SELECT HP_Numero_reference_du_Compteur__c,HP_Id_Compteur__c,HP_Compteur_Base_Plan_Index__c,HP_Compteur_Variable_Plan_prix_Index__c,HP_Compteur_Plan_Bottom_Price_Index__c,
        HP_Contrat_XdataId__c,HP_Souscription_Digital_Id__c,HP_Proposition_Commerciale_XdataId__c,HP_Souscription__c,HP_Type_de_Compteur__c,HP_Index_de_Compteur__c 
        FROM HP_Contrat__c LIMIT 1];
        Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_Facturation',new  Map<String, Object> {'Status' =>  HP_SLCT_Case.Status.NEW_CASE.name(),
			'ContactId' => myContact.Id,
			'HP_Energy__c' => 'Gas',
            'HP_Type__c' =>'HP_Retablissement',
            'Status' => 'NEW_CASE',
            'HP_Client_Aide__c' => true,
            'HP_Souscription__c' => mySouscription.Id,
            'HP_Contrat__c' => contrat_elec.Id
            ,'HP_PDL_PCE__c' => '21101817687620'
			}, null,null,null);
        insert aCase;

        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 

        HP_EnergyRequest energyRequest = new HP_EnergyRequest(mySouscription.HP_type_Souscription__c, contrat_elec.HP_Id_Compteur__c,
								     (Integer)(contrat_elec.HP_Type_de_Compteur__c == 'GAS' ? contrat_elec.HP_Index_de_Compteur__c :
									       contrat_elec.HP_Compteur_Base_Plan_Index__c != null ?  contrat_elec.HP_Compteur_Base_Plan_Index__c :
									       contrat_elec.HP_Compteur_Variable_Plan_prix_Index__c ));
        HP_EnergyResponse energyResponse = HP_SM024_Case.precontratOCTOPUS(mySouscription, contrat_elec, energyRequest);

        HP_EnergyContractRequest energyContractRequest = HP_EM054_CoupureReduction.energyContractRequestBuilder(aCase, myContact, energyResponse, contrat_elec, false);

        HP_EnergyContractResponse energyContractResponse = HP_SM027_DistCreatePrestationElec.sendRequest(energyContractRequest, 'RETABLISSEMENT', energyResponse, null);
        Test.stopTest();

        System.assert(energyContractResponse!=null, 'Test OK, Object Non NUll');

    }
}