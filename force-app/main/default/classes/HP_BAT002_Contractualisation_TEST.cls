/**
 * @File Name          : HP_BAT002_Contractualisation_TEST.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 01-17-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/02/2020   Vincent Albiser     Initial Version
**/
@isTest
public with sharing class HP_BAT002_Contractualisation_TEST {

	private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
		HP_SendEmail_Mock,
		HP_APIHourCommercialProposition_POST_MOCK
    }

	@testSetup static void dataSetup(){
         
        insert new ByPassSettings__c(
            SetupOwnerId = UserInfo.getUserId(),
            ValidationRule__c 	= true,
            ProcessBuilder__c 	= true,
            CaseTrigger__c 		= true,
            AccountTrigger__c 	= true,
            ContactTrigger__c 	= true
        );

        Account acc = (Account)HP_UTIL_SmartFactory.createSObject('Account','HP_Account' ,new Map<String, Object>{
            'HP_XDataExternalId__c' => 100166,
            'Name' => 'UnitTest',
            'OwnerId' => UserInfo.getUserId()
        },null,null, null);
        insert acc;
        
            Contact acontact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
                'AccountId' => acc.Id,


                'Id_Tiers__c' => 100166,
                'HP_IsHappe__c' => true,

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
                'MailingCity' =>'ANTONY',
                'OwnerId' => UserInfo.getUserId()
            }, null, null, null);
            insert acontact;
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
                'HP_Contact__c'=> acontact.Id,
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
            
            HP_Porte_Feuille_Contrat__c porteFeuille = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                'HP_Contact__c' => acontact.id,
                'Xdata_Id__c' => '1222',
                'HP_Souscription_Digital_Id__c'=>'testGazElec-01',
                'OwnerId' => UserInfo.getUserId()
            }, null, null, null);
            insert porteFeuille;
            
    
            HP_Contrat__c contract =(HP_Contrat__c) HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', 
            new Map<String, Object>{ 
                'HP_Numero_reference_du_Compteur__c' => '423',
                'HP_Id_Compteur__c' => '31431211214068',
                'HP_Porte_Feuille_Contrat__c' => porteFeuille.Id,
                'HP_Contrat_XdataId__c' => 100148,
                'HP_Souscription_Digital_Id__c' => enrolment.HP_Souscription_Digital_Id__c+'GAS',
                'HP_Proposition_Commerciale_XdataId__c'=>'775949',
                'HP_Souscription__c'=> enrolment.id,
                'HP_Type_de_Compteur__c' => 'ELEC',
                'OwnerId' => UserInfo.getUserId()
            }, null);
            insert contract;
            
           
            
            Case aCase = (Case) HP_UTIL_SmartFactory.createSObject('Case', new Map<String, Object> {'Status' => HP_SLCT_Case.Status.HP_PENDING.name(),
            'HP_Contrat__c' => contract.id,
            'HP_Type__c' => 'HP_AUTOMATED_PROCESS',
            'OwnerId' => UserInfo.getUserId(),
            'ContactId' => acontact.Id}, null);
            insert aCase;
    }

	@isTest static void execute(){

            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                      StaticResource.HP_APIHourCommercialProposition_POST_MOCK.name(),
                                                      new Map<String, String> { 'Content-Type' => 'application/json'}),
                'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_SendEmail_Mock.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'ES-PDLGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    201, 
                    'HP_ES_PDLGaz_v2_Mock',
                    new Map<String, String> {'Content-Type' => 'application/xml'})
            };
            Test.startTest();
            Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_BAT002_Contractualisation.execute();
            Test.stopTest();
            List<HP_Souscription__c> listSouscriptions = [SELECT id FROM HP_Souscription__c WHERE HP_Statut__c = 'CANCEL'];
            System.assertEquals(true, listSouscriptions.size()>0, 'La souscription a bien été annulée');
    }

    @isTest static void HP_BAT002_Contractualisation_TEST_Schedule() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                null,
                new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
            ),
            'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                  StaticResource.HP_APIHourCommercialProposition_POST_MOCK.name(),
                                                  new Map<String, String> { 'Content-Type' => 'application/json'}),
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_SendEmail_Mock.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'ES-PDLGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                201, 
                'HP_ES_PDLGaz_v2_Mock',
                new Map<String, String> {'Content-Type' => 'application/xml'})
        };
        Test.startTest();
        final String jobName = 'HP_BAT002_Contractualisation'+System.Math.random()*1000;
        final String cronExp = '0 0 4 ? * * *';
        Test.setMock(WebServiceMock.class, new HP_UTIL_ResponseSoapMock());
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_BAT002_Contractualisation.launchNewScheduler(cronExp,jobName);
        Test.stopTest();
    }
}