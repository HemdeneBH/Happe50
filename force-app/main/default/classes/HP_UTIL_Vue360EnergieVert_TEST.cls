/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 04-22-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-22-2021   Slimene Belhaj Ali   Initial Version
**/
@isTest
public with sharing class HP_UTIL_Vue360EnergieVert_TEST {
    @isTest
    public static void processing_TEST() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
               'HP_APIHourAccessTokenResponse_MOCK',
                new Map<String, String> {'Content-Type' => 'application/json'}
            ),
            'propositions/get_options' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(201,
                                                  'null','{"status": "SUCCESS","message": "L","output": {}}',
                                                  new Map<String, String> { 'Content-Type' => 'application/json'})
        
        };

        String param = '{ "data": {"_data": [ { "id": 305936, "idPortefeuilleContrat": 254163, "idPersonne": 204833,  "energie": "Electricité", "statut": "Actif",  "codeStatutCrm": "H0105",'+
            '"libelleStatutCrm": "Activé", "dureeContratEnMois": 24,"dateDebutContrat": "2019-12-16", "dateFinContrat": "2021-12-31","facture": true,"idOffre": 435,"offre": "Happ-e Gaz",'+
            '"codeOffre": "GITR2_H","idInstallation": 314551,"idPointDeLivraison": 254236,"idPack": 433,"dateDebutValidite": "2019-12-16","dateFinValidite": "2021-12-31","idPropositionCommerciale": 763904,'+
            '"idAgence": 0, "_links": {"self": "https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/apiset/0.2/contrats/305936" } },{ "id": 305936, "idPortefeuilleContrat": 254163, "idPersonne": 204833,  "energie": "Gaz Naturel", "statut": "Actif",  "codeStatutCrm": "E0004",'+
            '"libelleStatutCrm": "Activé", "dureeContratEnMois": 24,"dateDebutContrat": "2019-12-16", "dateFinContrat": "2021-12-31","facture": true,"idOffre": 435,"offre": "Happ-e Gaz",'+
            '"codeOffre": "GITR2_H","idInstallation": 314551,"idPointDeLivraison": 254236,"idPack": 433,"dateDebutValidite": "2019-12-16","dateFinValidite": "2021-12-31","idPropositionCommerciale": 763904,'+
            '"idAgence": 0, "_links": {"self": "https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/apiset/0.2/contrats/305936" } }] }}';
        
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_UTIL_Vue360EnergieVert.processing( (Object)System.JSON.deserializeUntyped(param),null);
            Test.stopTest(); 
    }
}