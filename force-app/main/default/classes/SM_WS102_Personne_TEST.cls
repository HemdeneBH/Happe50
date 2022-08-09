/**
 * @author Sutharsan Pushparajah
 * @date 07/04/2022
 * @description Test class for SM_WS102_Personne
 */
@isTest
private class SM_WS102_Personne_TEST {

    private static final String ID_BUSINESS_PARTNER = '0312386733';

    /**
     * @author Sutharsan Pushparajah
     * @date 07/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
		String payload = '{"_data": [{"id": 68491001,"civilite": "MME","nom": "MOUCHET","prenom": "Gaëlle","idBusinessPartner": "'+ID_BUSINESS_PARTNER+'","idPersonneUnifiee": 0}]}';

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
     * @date 06/04/2022
     * @description Testing the Personnes API
     */
    @isTest
    private static void testGetPersonnes(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('PERSONNES_V0', new TestingMockHttp());
        multiMockHttp.addRequestMock('PERSONNES_V1', new TestingMockHttp());

        Test.startTest();

        List<Object> result1 = SM_WS102_Personne.getPersonnes(ID_BUSINESS_PARTNER, 'V0');
        List<Object> result2 = SM_WS102_Personne.getPersonnes(ID_BUSINESS_PARTNER, 'V1');

        System.assertNotEquals(null, result1);
        System.assertNotEquals(null, result2);

        Map<String, Object> result1Map = (Map<String, Object>) result1.get(0);
        Map<String, Object> result2Map = (Map<String, Object>) result2.get(0);

        System.assertNotEquals(null, result1Map);
        System.assertNotEquals(null, result2Map);

        System.assertEquals(68491001, result1Map.get('id'));
        System.assertEquals('MME', result1Map.get('civilite'));
        System.assertEquals('MOUCHET', result1Map.get('nom'));
        System.assertEquals('Gaëlle', result1Map.get('prenom'));
        System.assertEquals(ID_BUSINESS_PARTNER, result1Map.get('idBusinessPartner'));
        System.assertEquals(0, result1Map.get('idPersonneUnifiee'));

        System.assertEquals(68491001, result2Map.get('id'));
        System.assertEquals('MME', result2Map.get('civilite'));
        System.assertEquals('MOUCHET', result2Map.get('nom'));
        System.assertEquals('Gaëlle', result2Map.get('prenom'));
        System.assertEquals(ID_BUSINESS_PARTNER, result2Map.get('idBusinessPartner'));
        System.assertEquals(0, result2Map.get('idPersonneUnifiee'));

        Test.stopTest();
    }
}