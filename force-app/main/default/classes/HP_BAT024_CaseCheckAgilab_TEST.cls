/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-16-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_BAT024_CaseCheckAgilab_TEST {
    
    private enum StaticResource {
   	 	 HP_APIHourAccessTokenResponse_MOCK
    }
    
    @testSetup 
    static void dataSetup(){

        insert new ByPassSettings__c(
            SetupOwnerId = UserInfo.getUserId(),
            ValidationRule__c 	= true,
            ProcessBuilder__c 	= true,
            CaseTrigger__c 		= true,
            AccountTrigger__c 	= true,
            ContactTrigger__c 	= true
        );

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
            'HP_Souscription_Digital_Id__c' => 'testGazElec-01',
            'HP_Proposition_Commerciale_XdataId__c'=>'775949',
            'HP_Souscription__c'=> enrolment.id,
            'HP_Type_de_Compteur__c' => 'GAS',
            'HP_Index_de_Compteur__c'=>2323434,
            'HP_Porte_Feuille_Contrat__c' => porteFeuille.Id
        }, null);
        insert cgaz;
        
        List<Case> cases = new List<Case>();
        
        Case c1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_ContractErrorSave3', new Map<String, Object> {
            'ContactId' => contact.id,
            'HP_Souscription__c'=> enrolment.id,
            'Contact__c' => contact.id,
            'Status' => 'NEW_CASE',
            'Description' => 'Endpoint request timed out',
            'Priority' => 'High',
            'HP_type__c' => 'HP_Contractualization',
            'OwnerId' => UserInfo.getUserId(),
            'HP_TreatmentDate__c' => Date.today().addDays(-2),
            'Origin' => 'Contact distributeur',
            'HP_Contrat__c'=>cgaz.id,
            'HP_TECH_ExternalId__c' => '983354454'
            }, null,null,null);
        cases.add(c1);

        insert cases;
           
    }
    
    @isTest static void HP_BAT024_CaseCheckAgilabOK(){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			 'propositions/contractualisation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
                           	null, '{"message":"existing id_contrat_xdata"}',
                            new Map<String, String> {'Content-Type' => 'application/json'}),
              'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
               )
        };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        HP_BAT024_CaseCheckAgilab.execute();
        Test.stopTest();       
        List<Case> prestaCases = [SELECT Id FROM Case WHERE HP_Type__c = 'HP_AUTOMATED_PROCESS'];
        Case contractualisationCase = [SELECT Id, Status FROM Case WHERE HP_Type__c = 'HP_Contractualization'];
        System.assert(prestaCases.size() == 1);
        System.assert(contractualisationCase.Status == 'CLOSED');
    }
    
    @isTest static void HP_BAT024_CaseCheckAgilab_ErrorContracRandom(){   
        
        Case caseInitial = [SELECT Id FROM Case WHERE HP_Type__c = 'HP_Contractualization'];
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			 'propositions/contractualisation' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(400, 
                           	null, '{"message":"random agilab error"}',
                            new Map<String, String> {'Content-Type' => 'application/json'}),
              'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
               )
        };

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        HP_BAT024_CaseCheckAgilab.execute();
        Test.stopTest();       
        List<Case> prestaCases = [SELECT Id, Description FROM Case WHERE HP_Type__c = 'HP_Contractualization'];
        System.assert(prestaCases.size() == 1 && prestaCases.get(0).Description == 'random agilab error');
    }

}