/**
 * @File Name          : HP_BAT004_CaseResiliationNotif_TEST.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10-26-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/06/2020   Vincent Albiser     Initial Version
**/
@isTest
public with sharing class HP_BAT004_CaseResiliationNotif_TEST {
  
    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK,

		HP_AgilabHappeResiliationCreate_MOCK,
        HP_AgilabHappeResiliation_MOCK_OK,
        HP_AgilabHappeResiliation_MOCK_47

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


    }

    @isTest static void HP_BAT004_CaseResiliationNotification(){
            
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                null,'{"energie":"Electricité", "idPortefeuilleContrat": 1235,  "idPersonne": 1313, "idPointDeLivraison": 123456}',
                new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
			),
            'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                null,'{"numeroPointDeLivraison":"1231546"}',
                new Map<String, String> {'Location' => 'http/123456', 'Content-Type' => 'application/json'}
			),
            
			'happe_resiliations/create' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
												  StaticResource.HP_AgilabHappeResiliationCreate_MOCK.name(),
												  new Map<String, String> { 'Content-Type' => 'application/json'})
        };
		Case caseToUpdate = [SELECT Id, HP_ResiliationAgilabTraitement__c FROM Case];
        caseToUpdate.HP_ResiliationAgilabTraitement__c = true;
        update caseToUpdate;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_BAT004_CaseResiliationNotification.execute();
        Test.stopTest(); 


        System.assert( [SELECT HP_ResiliationModifierStatutAgilab__c FROM Case limit 1].HP_ResiliationModifierStatutAgilab__c == true , 'Case resiliation Notification sent');
        System.assert( [SELECT Status, HP_ResiliationModifierStatutAgilab__c FROM Case limit 1].Status == 'CLOSED' , 'Case status est fermé');

    }
    
    @isTest static void HP_BAT004_CaseResiliation47(){
            
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,'{"energie":"Electricité", "idPortefeuilleContrat": 1235,  "idPersonne": 1313}',
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                	200,
                	null,'{"numeroPointDeLivraison":"1231546"}',
                	new Map<String, String> {'Location' => 'http/123456', 'Content-Type' => 'application/json'}
				),
                'happe_resiliations/create' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                      StaticResource.HP_AgilabHappeResiliation_MOCK_47.name(),
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_BAT004_CaseResiliationNotification.execute();
            Test.stopTest(); 
    }
    
    @isTest static void HP_BAT004_CaseResiliationOK(){
            
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,'{"energie":"Electricité", "idPortefeuilleContrat": 1235,  "idPersonne": 1313}',
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                	200,
                	null,'{"numeroPointDeLivraison":"1231546"}',
                	new Map<String, String> {'Location' => 'http/123456', 'Content-Type' => 'application/json'}
				),'happe_resiliations/create' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                      StaticResource.HP_AgilabHappeResiliation_MOCK_OK.name(),
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };


            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_BAT004_CaseResiliationNotification.execute();
            Test.stopTest(); 
    }

    @isTest static void HP_BAT004_CaseResiliationFail(){
        
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    null,'{"energie":"Electricité", "idPortefeuilleContrat": 1235,  "idPersonne": 1313}',
                    new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
                ),
                'elec-points-de-livraison' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                	200,
                	null,'{"numeroPointDeLivraison":"1231546"}',
                	new Map<String, String> {'Location' => 'http/123456', 'Content-Type' => 'application/json'}
				)
            };
         Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_BAT004_CaseResiliationNotification.execute();
            Test.stopTest();
        
    }
}