/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-16-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-16-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class HP_BAT005_SynchroXdataAgilab_TEST {

    private enum StaticResource {
        HP_APIHourCommercialProposition_POST_MOCK,
        HP_APIHourAccessTokenResponse_MOCK
	}

    @testSetup static void dataSetup(){
            HP_Contrat__c contrat = (HP_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Contrat__c', null, new Map<String, Object>{
                'HP_Contrat_XdataId__c' => 282535
                }, null, null, null);
            insert contrat;
    
            HP_Porte_Feuille_Contrat__c pfc = (HP_Porte_Feuille_Contrat__c)HP_UTIL_SmartFactory.createSObject('HP_Porte_Feuille_Contrat__c', null, new Map<String, Object>{
                'Xdata_Id__c' => '1235'
                }, null, null, null);
            insert pfc;
           
        
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
			'LastName' => 'Contact Test',
			'Email' => 'test@gmail.com',
			'Id_Tiers__c' => 1313
		}, null, null,null);
		insert contact;
        
        Case case1 = (Case) HP_UTIL_SmartFactory.createSObject('Case','HP_ContractCancelationCase', new Map<String, Object> {
        'Status' => 'CLOSED',
'HP_TECH_ExternalId__c' => 'CONTRACT_CANCELATION/1561',
                'HP_Energy__c' => 'Electricity',
                'ContactId' => contact.Id,
                'HP_index_elec_hc__c' => 12345,
                'HP_index_elec_hp__c' =>  67890,
                'HP_index_gaz__c'=> 10,

        'HP_EffectiveDate__c' => date.today().addDays(1),
        'HP_ResiliationModifierStatutAgilab__c' => false
		}, null,null,null);
        insert case1;
        
         Prestation_distributeur__c testpresta = (Prestation_distributeur__c)HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 'HP_PrestationDistributeur', new Map<String, Object>{
                'Numero_PDL_PCE__c' => '230492038433',
                'Statut__c' => 'En cours',
                'Secteur_activite__c' => 'Gaz',
                'Numero_affaire_distributeur__c' => 'QL30DPC4',
                'HP_TECH_toNotify__c' => true,
                    'Case__c' => case1.Id
            }, null, null, null);
            insert testpresta;

	}

	@isTest static void execute(){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200, 
                    'HP_APIHourAccessTokenResponse_MOCK',
                    new Map<String, String> {'Content-Type' => 'application/json'}),
                'auth/oauth/v2/token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}),
    
                'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    201,
                    null,'{"energie":"Electricité", "idPortefeuilleContrat": 1235,"idPersonne": 1313}',
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                      StaticResource.HP_APIHourCommercialProposition_POST_MOCK.name(),
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
            HP_BAT005_SynchroXdataAgilab.execute();
            Test.stopTest();
                  
	}

}