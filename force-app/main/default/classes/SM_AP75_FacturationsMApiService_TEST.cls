/**
 * @author Unknown
 * @date 14/04/2022 - Sutharsan Pushparajah : Enforce Unit Testing
 * @description Test class for SM_AP75_FacturationsMApiService
 */
@isTest
private class SM_AP75_FacturationsMApiService_TEST {

    private static final String ID_PORTEFEUILLE_CONTRAT = '251760';

    /**
     * @author Sutharsan Pushparajah
     * @date 14/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
		String payload = '{"_data": [{"idPortefeuilleContrat": 251760,"numeroPortefeuilleContrat": "000516675793","modeEncaissement": "P","conditionPaiement": "+14B","dateProchaineFacture": null,"idCoordonneeBancaire": "0312363915-0005","iBAN": "FR7620041000016339472729286","nomInstitutBancaire": "LA BANQUE POSTALE","codeBIC": "PSSTFRPPPAR","idMandat": 405795,"numeroMandat": "00S014580601","codeStatutMandat": "1","libelleStatutMandat": "Actif","idFacture": null,"numeroFacture": null,"dateComptable": null,"dateEcheance": null,"dateImpression": null,"montantTotal": null,"titulaireCompte": "TEST Raouaa SMS","codeMensualisation": "","libelleMensualisation": "n/a"}]}';
        
        TestingMockHttp(){
            this(false);
        }

        TestingMockHttp(Boolean isEmpty){
            if (isEmpty){
                payload = '{"_data":[]}';
            }
        }

		public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(payload);

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 14/04/2022
     * @description Testing the mock of FacturationsMensualisees API
     */
    @isTest
    private static void testCallFacturationsMensualisees(){
        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('FACTURATIONS_MENSUALISEES', new TestingMockHttp());

        Test.startTest();

        //1 - Testing null values
        Map<String,Object> outputMap = new Map<String, Object>();
        outputMap = SM_AP75_FacturationsMApiService.callFacturationsMensualisees(null);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //2 - Testing with no ID_PORTEFEUILLE_CONTRAT attribute
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('Id', ID_PORTEFEUILLE_CONTRAT);
        outputMap = SM_AP75_FacturationsMApiService.callFacturationsMensualisees(inputMap);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //3 - Testing with no ID_PORTEFEUILLE_CONTRAT value
        inputMap = new Map<String, Object>();
        inputMap.put('idsPortefeuilleContrat', null);
        outputMap = SM_AP75_FacturationsMApiService.callFacturationsMensualisees(inputMap);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //4 - Testing with correct data
        inputMap = new Map<String, Object>();
        inputMap.put('idsPortefeuilleContrat', ID_PORTEFEUILLE_CONTRAT);
        outputMap = SM_AP75_FacturationsMApiService.callFacturationsMensualisees(inputMap);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(1, ((List<Object>) outputMap.get('resultdata')).size());

        //5 - Empty payload
        multiMockHttp.addRequestMock('FACTURATIONS_MENSUALISEES', new TestingMockHttp(true));
        inputMap = new Map<String, Object>();
        inputMap.put('idsPortefeuilleContrat', ID_PORTEFEUILLE_CONTRAT);
        outputMap = SM_AP75_FacturationsMApiService.callFacturationsMensualisees(inputMap);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        Test.stopTest();
    }
}