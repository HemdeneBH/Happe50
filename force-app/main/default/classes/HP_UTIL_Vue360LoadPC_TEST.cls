/**
 * @File Name          : HP_UTIL_Vue360LoadPC_TEST.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 17/06/2020 à 01:26:14
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/06/2020   Vincent Albiser     Initial Version
**/
@isTest
public with sharing class HP_UTIL_Vue360LoadPC_TEST {

    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK,
		HP_APIHourCommercialProposition_POST_Object_MOCK
    }

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @isTest static void execute(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
                'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                    200,
                    StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                    new Map<String, String> {'Content-Type' => 'application/json'}
                ),
                'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                      StaticResource.HP_APIHourCommercialProposition_POST_Object_MOCK.name(),
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            
            };
    
            String param = '{ "data": {"_data": [ { "id": 305936, "idPortefeuilleContrat": 254163, "idPersonne": 204833,  "energie": "Gaz Naturel", "statut": "Actif",  "codeStatutCrm": "E00041",'+
            '"libelleStatutCrm": "Activé", "dureeContratEnMois": 24,"dateDebutContrat": "2019-12-16", "dateFinContrat": "2021-12-31","facture": true,"idOffre": 435,"offre": "Happ-e Gaz",'+
            '"codeOffre": "GITR2_H","idInstallation": 314551,"idPointDeLivraison": 254236,"idPack": 433,"dateDebutValidite": "2019-12-16","dateFinValidite": "2021-12-31","idPropositionCommerciale": 763904,'+
            '"idAgence": 0, "_links": {"self": "https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/apiset/0.2/contrats/305936" } },{ "id": 305936, "idPortefeuilleContrat": 254163, "idPersonne": 204833,  "energie": "Gaz Naturel", "statut": "Actif",  "codeStatutCrm": "E0004",'+
            '"libelleStatutCrm": "Activé", "dureeContratEnMois": 24,"dateDebutContrat": "2019-12-16", "dateFinContrat": "2021-12-31","facture": true,"idOffre": 435,"offre": "Happ-e Gaz",'+
            '"codeOffre": "GITR2_H","idInstallation": 314551,"idPointDeLivraison": 254236,"idPack": 433,"dateDebutValidite": "2019-12-16","dateFinValidite": "2021-12-31","idPropositionCommerciale": 763904,'+
            '"idAgence": 0, "_links": {"self": "https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/apiset/0.2/contrats/305936" } }] }}';
        
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_UTIL_Vue360LoadPC.processing( (Object)System.JSON.deserializeUntyped(param),null);
            Test.stopTest(); 
        }
         
}

@isTest static void executeDataNull(){
    System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'propositions-commerciales' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                  StaticResource.HP_APIHourCommercialProposition_POST_Object_MOCK.name(),
                                                  new Map<String, String> { 'Content-Type' => 'application/json'})
        
        };
    
        String param = '{ "data":null}';
    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_UTIL_Vue360LoadPC.processing( (Object)System.JSON.deserializeUntyped(param),null);
        Test.stopTest();
    }
}

}