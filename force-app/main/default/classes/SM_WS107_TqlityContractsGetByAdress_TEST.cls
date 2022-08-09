/**
 * @author Sutharsan Pushparajah
 * @date 20/04/2022
 * @description Test class for SM_WS107_TranquilityContractsGetByAdress
 */
@isTest
private class SM_WS107_TqlityContractsGetByAdress_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 20/04/2022
     * @description Testing the mock of Contracts Get By Adresse API
     */
	@isTest
	private static void testGetByAdresse(){

        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getContractsByAdresseMocks());

        Test.startTest();

        SM_WRP001_AddContrat.RequestOffre inputRequest;
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();	

        inputMap.put('bpClient','1234');
        inputMap.put('rue','test rue');
        inputMap.put('codePostal','92100');
        inputMap.put('commune','92');
        
        inputRequest = SM_SM004_Tranquility.buildContratBody(inputMap);

        outMap = SM_WS107_TranquilityContractsGetByAdress.getByAdresse(inputRequest);

        System.assertNotEquals(null, outMap);

        Map<String, Object> res = (Map<String, Object>) outMap.get('return');
        Map<String, Object> resContrat = (Map<String, Object>) res.get('retour');
        List<Object> contracts = (List<Object>) resContrat.get('contratList');

        System.assertEquals(null, contracts);
        
        Test.stopTest();
    }
}