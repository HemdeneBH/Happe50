/**
 * @author Sutharsan Pushparajah
 * @date 10/05/2022
 * @description Test class for SM_WS109_TranquilityOffersGetAvailables
 */
@isTest
private class SM_WS109_TqlityOffersGetAvailables_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 10/05/2022
     * @description Testing the mock of Get Available Offers API
     */
	@isTest
	private static void testGetAvailableOffers(){

        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getOffersAvailableMocks());

        Test.startTest();

        SM_WRP001_AddContrat.RequestOffreAvailables inputRequest = SM_SM004_Tranquility.buildOffresAvailablesBody('2', 'libelleVoie', 'codepostal', 'commune', 'complement', 'batiment', 'bpclient', 'canal');

        Map<String, Object> outMap = SM_WS109_TranquilityOffersGetAvailables.getAvailableOffers(inputRequest);

        System.assertNotEquals(null, outMap);

        Map<String, Object> res = (Map<String, Object>) outMap.get('return');
        Map<String, Object> resOffers = (Map<String, Object>) res.get('retour');
        List<Object> offers = (List<Object>) resOffers.get('offreList');

        System.assertNotEquals(null, offers);
        System.assertEquals(1, offers.size());
        System.assertEquals('ACP', ((Map<String, Object>) offers.get(0)).get('idOffre'));

        Test.stopTest();
    }
}