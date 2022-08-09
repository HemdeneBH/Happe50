/**
 * @File Name          : HP_EM034_Retractation_TEST.cls
 * @Description        :  
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    11/06/2020   Sara El-Hannaoui     Initial Version
 **/

@isTest
public with sharing class HP_EM034_Retractation_TEST  {

    private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK
    }
    
    @testSetUp private static void insertTestData(){

        HP_Contrat__c contract =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
        new Map<String, Object>{ 
            'HP_Numero_reference_du_Compteur__c' => '423',
			'HP_Id_Compteur__c' => '31431211214068',
            'HP_Contrat_XdataId__c' => 100148,
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Type_de_Compteur__c' => 'GAS'
        }, null);
        insert contract;
        
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
			'LastName' => 'Contact Test',
			'Email' => 'test@gmail.com',
			'Id_Tiers__c' => 1313
		}, null, null,null);
		insert contact;
		
        Case case1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_ContractCancelationCase', new Map<String, Object> {
        'Status' => 'CLOSED',

            'HP_Contrat__c' => contract.id,
            'HP_TECH_ExternalId__c' => 'CONTRACT_CANCELATION/100148',

                'HP_Energy__c' => 'Electricity',
                'ContactId' => contact.Id,
                'HP_index_elec_hc__c' => 12345,
                'HP_index_elec_hp__c' =>  67890,
                'HP_index_gaz__c'=> 10,

        'HP_EffectiveDate__c' => date.today().addDays(1),
        'HP_ResiliationModifierStatutAgilab__c' => false
		}, null,null,null);
		insert case1;
        
        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
                'HP_Canal_de_vente__c'  => 'Vente Online',
                'HP_Contact__c'=> contact.Id,
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
                'HP_Souscription_Digital_Id__c' =>'testGazElec-01',
                'HP_Type_Energie__c' =>'COMBINED_GAS_AND_ELECTRICITY',
                'HP_type_Souscription__c' =>'MOVING_IN',
                'HP_NumberPCE__c' =>'31431211214068',
                'HP_NumPDL__c' =>'31431211214170',
                'HP_Statut__c' =>'SAVE_1',
                'OwnerId' => UserInfo.getUserId()
            }, null);
            insert enrolment;
    }


    @isTest
	public static void loadContractFromXdata(){
		Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  null,'{"id":9789232}',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		RestContext.response= new RestResponse();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
		String body = HP_EM034_Retractation.loadContractFromXdata('9789232');
        Map<String, Object> contMap = (Map<String, Object>) JSON.deserializeUntyped(body);
		Test.stopTest();
		System.assert (String.valueOf(contMap.get('id')) == '9789232');

	}

    @isTest
    public static void createCaseRetractation() {
        String status = 'TO_DO';
        String energie = 'Electricity';
		HP_Souscription__c souscription = [SELECT Id, HP_Contact__c FROM HP_Souscription__c LIMIT 1];
        HP_Contrat__c contrat = [SELECT Id FROM HP_Contrat__c LIMIT 1];
        Test.startTest();
        Case resultCase = HP_EM034_Retractation.createCaseRetractation(souscription.Id, 'test_description', status, contrat.Id, energie);
        Test.stopTest();
        System.assert (resultCase.HP_Type__c == 'HP_Gestion_Contrat');
        System.assert (resultCase.HP_Souscription__c == souscription.Id);
        System.assert (resultCase.ContactId == souscription.HP_Contact__c);
        System.assert (resultCase.Status == status);
		System.assert (resultCase.Origin == 'HP_CRM');
		System.assert (resultCase.Description == 'test_description');
        System.assert (resultCase.HP_Energy__c == energie);
        System.assert (resultCase.HP_Contrat__c == contrat.Id);
    }
    
    @isTest
	public static void cancelXdataPC() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
												  null,
                                                  '',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		RestContext.response= new RestResponse();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        String resultCase = HP_EM034_Retractation.cancelXdataPC('1111');
        Test.stopTest();
        System.assert(resultCase == null);
 
    }  
    
    @isTest
    public Static void cancelXdataContrat() {
         Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204,
												  null,
                                                  '',
												  new Map<String, String> { 'Content-Type' => 'application/json'})
		};

		Test.startTest();
		RestContext.response= new RestResponse();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        String resultCase = HP_EM034_Retractation.cancelXdataContrat('1111');
        Test.stopTest();
        System.assert(resultCase == null);
    }
    
    @isTest
    public static void cancelAgilabContrat() {
         Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'propositions/modifier' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(204, 
                						'HP_ResponseHPSM006FactureManagermodifiermodedenvoiFactures',
                						new Map<String, String> {'Content-Type' => 'application/json'})
		};

		Test.startTest();
		RestContext.response= new RestResponse();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        String resultCase = HP_EM034_Retractation.cancelAgilabContrat('1111');
        Test.stopTest();
        System.assert(resultCase == null);
    }

    @isTest
    public static void loadPropositionCommecrialeXdata() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,null,
                                                                                             '{"id":"9789232"}',
                						new Map<String, String> {'Content-Type' => 'application/json'})
		};

		Test.startTest();
		RestContext.response= new RestResponse();
		Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
       	String body = HP_EM034_Retractation.loadPropositionCommecrialeXdata('9789232');
        Map<String, Object> contMap = (Map<String, Object>) JSON.deserializeUntyped(body);
		Test.stopTest();
		System.assert (String.valueOf(contMap.get('id')) == '9789232');
	}
}