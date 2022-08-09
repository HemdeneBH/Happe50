/**
 * @author Unknown
 * @date 11/05/2022 - Refactoring by Sutharsan Pushparajah
 * @description Test class for SM_getOffresServicesPayant
 */
@isTest
private class SM_getOffresServicesPayant_test {

    /**
     * @author Sutharsan Pushparajah
     * @date 11/05/2022
     * @description Testing the mock of Get Available Offers API
     */
	@isTest
	private static void testGetAvailableOffers(){

        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getOffersAvailableMocks());

        Test.startTest();

        Map<String, Object> outMap = new Map<String, Object>();
       
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('numeroVoie', '2');
        inputMap.put('libelleVoie', 'libelleVoie');
        inputMap.put('codePostal', 'codePostal');
        inputMap.put('ville', 'ville');
        inputMap.put('IdBusinessPartner', '1234');
        inputMap.put('canal', 'canal');

        SM_getOffresServicesPayant tqOffresApi = new SM_getOffresServicesPayant();
        tqOffresApi.invokeMethod('getservicespayant', inputMap, outMap, new Map<String, Object>());

        System.assertNotEquals(null, outMap);

        List<Object> offers = (List<Object>) outMap.get('offreList');

        System.assertNotEquals(null, offers);
        System.assertEquals(1, offers.size());
        System.assertEquals('ACP', ((Map<String, Object>) offers.get(0)).get('idOffre'));

        //Checking exception
        Boolean result = tqOffresApi.invokeMethod('getservicespayant', null, null, null);

        System.assertEquals(false, result);

        Test.stopTest();
    }

}