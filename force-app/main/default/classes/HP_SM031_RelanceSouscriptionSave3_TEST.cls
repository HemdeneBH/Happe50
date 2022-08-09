/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-09-2022
 * @last modified by  : Badr Eddine Belkarchi
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-15-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest
public with sharing class HP_SM031_RelanceSouscriptionSave3_TEST {

    private enum StaticResource {
        HP_SM022_SouscriptionSave3_TEST,
        HP_APIHourCommercialProposition_POST_MOCK,
        HP_AGILAB_SOUSCRIPTION_MOCK,
        HP_APIHourAccessTokenResponse_MOCK,
        HP_AGILAB_CONTRACTUALISATION_MOCK,
        HP_ES_PDLGaz_v2_Mock,
        HP_ES_PDLElec_v3_Mock,
        HP_SendEmail_Mock
    }

    @TestSetUp 
	private static void insertTestData() {
      
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{     
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'HP_IsHappe__c' => true,
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

        Case acase = (Case)HP_UTIL_SmartFactory.createSObject('Case','HP_ContractErrorSave3', new Map<String, Object>{
            'HP_EffectiveDate__c' => Date.newInstance(2019, 12, 27),
            'HP_Source__c' => 'HP_CLIENT',
            'HP_Contrat__c' => cgaz.id,
            'Status' => 'NEW_CASE',
            'ContactId' => contact.id,
            'Subject' => 'Case Test',
            'HP_Souscription__c' => enrolment.id,
            'HP_TECH_ExternalId__c' => 'test',
            'HP_Energy__c' => 'Gas'
        }, null,null,null);
        insert acase;

    }
    

    @istest
    static void HP_SM031_RelanceSouscriptionSave3_TEST(){

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


        Case acase = [SELECT id FROM Case WHERE Subject = 'Case Test' LIMIT 1];
        System.debug('case '+acase);

        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
		List<String> resutlts =  HP_SM031_RelanceSouscriptionSave3.rerunContractualisationAgilab(new List<Id>{acase.id});
        Test.stopTest();
        System.assertEquals('Le contrat est créé dans Agilab', resutlts[0]);
      
        
    }
}