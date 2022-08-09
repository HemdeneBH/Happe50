@isTest
public with sharing class HP_UTIL_Vue360LoadMandat_TEST {
/*
    private enum StaticResource {
        HP_APIHourAccessTokenResponse_MOCK
    }


    @isTest static void execute(){

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
                new Map<String, String> {'Content-Type' => 'application/json'}
            )
        
        };

        String param = '{ "data": {"_data": [ { "id": 254164, "idPersonne": 204833,"idCoordonneeBancaireEncaissement": 170969,"idCoordonneeBancaireDecaissement": 0,'+
        '"libelle": "test Nico","idPersonneDivergentPayeur": 204833,"idPersonneDivergentRelance": 204833,"idPersonneDivergentPaiement": 204833,"idPersonneDivergentCocontractant": 0,'+
        '"codeModeEncaissement": "5","libelleModeEncaissement": "Prélèvement","libelleEtatProcedureRelance": "","libelleModePaiement": "","libelleConditionPaiement": "",'+
        '"libelleCaracteristiquePrelevement": "","codeClientMaReleve": false,"libelleMaReleve": "","codeClientZenbox": false,"libelleZenbox": "","codeClientCapEcoConso": false,"libelleCapEcoConso": "",'+
        '"codeFactureEnLigne": "0002","libelleFactureEnLigne": "Ma facture en Ligne + SMS","codeRythmeFacturation": "A","libelleRythmeFacturation": "Annuel","codeAlerting": "",'+
        '"blocageRelance": false,"blocageFacturation": false,"blocageDecaissement": false,"blocagePrelevement": "field","codeMarque": "HAP","libelleMarque": "HAPP-E","_links": {"self": "https://qa-rec-dmzint-gtw.api.engie.fr:8500/api/apiset/0.3/portefeuilles-contrats/254164"}}] }}';
    
        String rootParam = '{"pfcIdList": "254163,260981,254164,254168, 254172,254171, 915344"}';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_UTIL_Vue360LoadMandat.processing( (Object)System.JSON.deserializeUntyped(param),(Object)System.JSON.deserializeUntyped(rootParam));
        Test.stopTest();  */
}