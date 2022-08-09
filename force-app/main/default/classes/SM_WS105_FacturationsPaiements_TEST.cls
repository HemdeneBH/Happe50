/**
 * @author Sutharsan Pushparajah
 * @date 14/04/2022
 * @description Test class for SM_WS105_FacturationsPaiements
 */
@isTest
private class SM_WS105_FacturationsPaiements_TEST {

    private static final String ID_PORTEFEUILLE_CONTRAT = '251760';

    /**
     * @author Sutharsan Pushparajah
     * @date 14/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
		String payload1 = '{"_data": [{"idPortefeuilleContrat": 251760,"numeroPortefeuilleContrat": "000516675793","modeEncaissement": "P","conditionPaiement": "+14B","dateProchaineFacture": null,"idCoordonneeBancaire": "0312363915-0005","iBAN": "FR7620041000016339472729286","nomInstitutBancaire": "LA BANQUE POSTALE","codeBIC": "PSSTFRPPPAR","idMandat": 405795,"numeroMandat": "00S014580601","codeStatutMandat": "1","libelleStatutMandat": "Actif","idFacture": null,"numeroFacture": null,"dateComptable": null,"dateEcheance": null,"dateImpression": null,"montantTotal": null,"titulaireCompte": "TEST Raouaa SMS","codeMensualisation": "","libelleMensualisation": "n/a"}]}';
        //Changement de iBAN
        String payload2 = '{"_data": [{"idPortefeuilleContrat": 251760,"numeroPortefeuilleContrat": "000516675793","modeEncaissement": "P","conditionPaiement": "+14B","dateProchaineFacture": null,"idCoordonneeBancaire": "0312363915-0005","iBAN": "FR7620041000016339472729287","nomInstitutBancaire": "LA BANQUE POSTALE","codeBIC": "PSSTFRPPPAR","idMandat": 405795,"numeroMandat": "00S014580601","codeStatutMandat": "1","libelleStatutMandat": "Actif","idFacture": null,"numeroFacture": null,"dateComptable": null,"dateEcheance": null,"dateImpression": null,"montantTotal": null,"titulaireCompte": "TEST Raouaa SMS","codeMensualisation": "","libelleMensualisation": "n/a"}]}';

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
     * @date 14/04/2022
     * @description Testing the mock of FacturationsPaiements API
     */
	@isTest
	private static void testGetFacturationsPaiements(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('FACTURATIONS_PAIEMENTS', new TestingMockHttp());

        Test.startTest();

        //1 - Testing null values
        List<Object> results = SM_WS105_FacturationsPaiements.getFacturationsPaiements(null, null);
        System.assertEquals(null, results);

        //2 - Testing with idPortefeuilleContrat
        results = SM_WS105_FacturationsPaiements.getFacturationsPaiements(ID_PORTEFEUILLE_CONTRAT, null);
        System.assertEquals(1, results.size());
        System.assertEquals('FR7620041000016339472729286', ((Map<String, Object>)results.get(0)).get('iBAN'));

        //3 - Testing with idPersonne
        results = SM_WS105_FacturationsPaiements.getFacturationsPaiements(null, ID_PORTEFEUILLE_CONTRAT);
        System.assertEquals(1, results.size());
        System.assertEquals('FR7620041000016339472729287', ((Map<String, Object>)results.get(0)).get('iBAN'));

        //3 - Testing with idPortefeuilleContrat (Priority 1) and idPersonne (Not taken here)
        results = SM_WS105_FacturationsPaiements.getFacturationsPaiements(ID_PORTEFEUILLE_CONTRAT, ID_PORTEFEUILLE_CONTRAT);
        System.assertEquals(1, results.size());
        System.assertEquals('FR7620041000016339472729286', ((Map<String, Object>)results.get(0)).get('iBAN'));

        Test.stopTest();
    }
}