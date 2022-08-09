/**
 * @File Name          : HP_UTIL_Vue360LoadPrestationDist_TEST.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-09-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/06/2020   Vincent Albiser     Initial Version
**/
@isTest
public with sharing class HP_UTIL_Vue360LoadPrestationDist_TEST {

    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK
    }

    @TestSetUp 
	private static void insertTestData(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact','HP_Contact', new Map<String, Object>{'HP_IsHappe__c' => true,  'Id_Tiers__c' => 100166,'lastName' => 'testnicot'}, null,null, null);
            insert contact;

            Prestation_distributeur__c prestastionEnCours = (Prestation_distributeur__c)HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 'HP_PrestationDistributeur', new Map<String, Object>{
                'Numero_PDL_PCE__c' => '21101817254193',
                'Statut__c' => 'En cours',
                'Secteur_activite__c' => 'Gaz',
                'Numero_affaire_distributeur__c' => 'QL30DPC5',
                'Situation_de_vente__c'=>'Resiliation',
                'HP_TECH_toNotify__c' => false,
                'Contact__c' => contact.Id
            }, null, null, null);
            insert prestastionEnCours;
    
            Prestation_distributeur__c prestastionTermine = (Prestation_distributeur__c)HP_UTIL_SmartFactory.createSObject('Prestation_distributeur__c', 'HP_PrestationDistributeur', new Map<String, Object>{
                'Numero_PDL_PCE__c' => '21331238214925',
                'Statut__c' => 'Terminé',
                'Secteur_activite__c' => 'Elec',
                'Numero_affaire_distributeur__c' => 'QL30DPC4',
                'Situation_de_vente__c'=>'Resiliation',
                'HP_TECH_toNotify__c' => false,
                'Contact__c' => contact.Id
            }, null, null, null);
            insert prestastionTermine;

            
        }
    }

    
    @isTest static void execute(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                )
            
            };
    
            String param = '{ "data": {"_data": [{"idPortefeuilleContrat": 254163,"locaux": [{ "idLocal": 241043, "codePostal": "75003", "libelleVoie": "rue des lilas", "numeroVoie": "68",'+
            ' "codeINSEE": "75103","ville": "Paris", "complementAdresse": "","pointsDeLivraison": [{"idPointDeLivraison": 254236,"numeroPointDeLivraison": "21101817254193","typeCompteur": "",'+
            '"etatPCE": "0", "secteurActivite": "gaz" },{ "idPointDeLivraison": 306363,"numeroPointDeLivraison": "21331238214925","systemeInfoContractuel": "DISCO","codeNiveau": "0","secteurActivite": "elec"}]}]}]}}';
            Contact cont = [SELECT Id FROM Contact limit 1];
            String contactId = String.valueOf(cont.Id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            Object result = HP_UTIL_Vue360LoadPrestationDist.processing( (Object)System.JSON.deserializeUntyped(param),contactId);
            Test.stopTest(); 
            system.assert(result instanceof Map<String, Object>, 'Ok');
        }     
    }


}