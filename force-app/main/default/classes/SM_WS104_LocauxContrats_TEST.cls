/**
 * @author Sutharsan Pushparajah
 * @date 13/04/2022
 * @description Test class for SM_WS104_LocauxContrats
 */
@isTest
private class SM_WS104_LocauxContrats_TEST {

    private static final String ID_PORTEFEUILLE_CONTRAT = '251760';

    /**
     * @author Sutharsan Pushparajah
     * @date 13/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
		String payload1 = '{"_data":[{"numeroVoie":"1","libelleVoie":"RUE FORTUNA","ville":"TOULON","codeINSEE":"83137","codePostal":"83100","idAdresse":811393,"idBAN":"83137_2897_00001","complementAdresse":"VILLA CLAUDE DENIS"},{"numeroVoie":"1","libelleVoie":"RUE FORTUNA","ville":"TOULON","codeINSEE":"83137","codePostal":"83100","idAdresse":811393,"idBAN":"83137_2897_00001","complementAdresse":"VILLA CLAUDE DENIS","typeOccupation":null,"typeResidence":null,"uniteReleve":"A10131DB","idPointDeLivraison":0,"numeroPointDeLivraison":"F000013833020201116151144"}]}';
        //Changement de idBAN
        String payload2 = '{"_data":[{"numeroVoie":"1","libelleVoie":"RUE FORTUNA","ville":"TOULON","codeINSEE":"83137","codePostal":"83100","idAdresse":811393,"idBAN":"83137_2897_00002","complementAdresse":"VILLA CLAUDE DENIS"},{"numeroVoie":"1","libelleVoie":"RUE FORTUNA","ville":"TOULON","codeINSEE":"83137","codePostal":"83100","idAdresse":811393,"idBAN":"83137_2897_00001","complementAdresse":"VILLA CLAUDE DENIS","typeOccupation":null,"typeResidence":null,"uniteReleve":"A10131DB","idPointDeLivraison":0,"numeroPointDeLivraison":"F000013833020201116151144"}]}';


		public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);

            if (req.getEndpoint().contains('?idsPortefeuilleContrat=')){
                res.setBody(payload1);
            } else if (req.getEndpoint().contains('?idPersonne=')){
                res.setBody(payload2);
            }

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 13/04/2022
     * @description Testing the mock of LocauxContrats API
     */
	@isTest
	private static void testGetLocauxContrats(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('LOCAUX_CONTRATS', new TestingMockHttp());

        Test.startTest();

        //1 - Testing null values
        List<Object> results = SM_WS104_LocauxContrats.getLocauxContrats(null, null);
        System.assertEquals(null, results);

        //2 - Testing with idPortefeuilleContrat
        results = SM_WS104_LocauxContrats.getLocauxContrats(ID_PORTEFEUILLE_CONTRAT, null);
        System.assertEquals(2, results.size());
        System.assertEquals('83137_2897_00001', ((Map<String, Object>)results.get(0)).get('idBAN'));

        //3 - Testing with idPersonne
        results = SM_WS104_LocauxContrats.getLocauxContrats(null, ID_PORTEFEUILLE_CONTRAT);
        System.assertEquals(2, results.size());
        System.assertEquals('83137_2897_00002', ((Map<String, Object>)results.get(0)).get('idBAN'));

        //3 - Testing with idPortefeuilleContrat (Priority 1) and idPersonne (Not taken here)
        results = SM_WS104_LocauxContrats.getLocauxContrats(ID_PORTEFEUILLE_CONTRAT, ID_PORTEFEUILLE_CONTRAT);
        System.assertEquals(2, results.size());
        System.assertEquals('83137_2897_00001', ((Map<String, Object>)results.get(0)).get('idBAN'));

        Test.stopTest();
    }
}