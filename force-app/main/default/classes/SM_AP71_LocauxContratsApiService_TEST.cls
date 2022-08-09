/**
 * @author Unknown
 * @date 12/04/2022 - Sutharsan Pushparajah : Enforce Unit Testing
 * @description Test class for SM_AP71_LocauxContratsApiService
 */
@isTest
private class SM_AP71_LocauxContratsApiService_TEST{
   
    private static final String ID_PORTEFEUILLE_CONTRAT = '251760';

    /**
     * @author Sutharsan Pushparajah
     * @date 12/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
		String payload = '{"_data":[{"numeroVoie":"1","libelleVoie":"RUE FORTUNA","ville":"TOULON","codeINSEE":"83137","codePostal":"83100","idAdresse":811393,"idBAN":"83137_2897_00001","complementAdresse":"VILLA CLAUDE DENIS"},{"numeroVoie":"1","libelleVoie":"RUE FORTUNA","ville":"TOULON","codeINSEE":"83137","codePostal":"83100","idAdresse":811393,"idBAN":"83137_2897_00001","complementAdresse":"VILLA CLAUDE DENIS","typeOccupation":null,"typeResidence":null,"uniteReleve":"A10131DB","idPointDeLivraison":0,"numeroPointDeLivraison":"F000013833020201116151144"}]}';

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
     * @date 12/04/2022
     * @description Testing the exception when input is not defined
     */
	@isTest
	private static void testInvokeMethod(){

		Test.startTest();

		Boolean result;
		
		SM_AP71_LocauxContratsApiService locauxContratsApi = new SM_AP71_LocauxContratsApiService();
		result = locauxContratsApi.invokeMethod(null, null, null, null);

		System.assertEquals(false, result);

		Test.stopTest();
	}

    /**
     * @author Sutharsan Pushparajah
     * @date 12/04/2022
     * @description Testing the mock of LocauxContrats API from IP
     */
	@isTest
	private static void testCallLocauxContrats_IP(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('LOCAUX_CONTRATS', new TestingMockHttp());

        Test.startTest();

        //1 - Testing null values
        Map<String,Object> outputMap = new Map<String, Object>();
        SM_AP71_LocauxContratsApiService.callLocauxContrats_IP(null, outputMap, null);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //2 - Testing with no ID_PORTEFEUILLE_CONTRAT attribute
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('Id', ID_PORTEFEUILLE_CONTRAT);
        SM_AP71_LocauxContratsApiService.callLocauxContrats_IP(inputMap, outputMap, null);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //3 - Testing with no ID_PORTEFEUILLE_CONTRAT value
        inputMap = new Map<String, Object>();
        inputMap.put('idsPortefeuilleContrat', null);
        SM_AP71_LocauxContratsApiService.callLocauxContrats_IP(inputMap, outputMap, null);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //4 - Testing with correct data
        inputMap = new Map<String, Object>();
        inputMap.put('idsPortefeuilleContrat', ID_PORTEFEUILLE_CONTRAT);
        SM_AP71_LocauxContratsApiService.callLocauxContrats_IP(inputMap, outputMap, null);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(2, ((List<Object>) outputMap.get('resultdata')).size());
		
		SM_AP71_LocauxContratsApiService locauxContratsApi = new SM_AP71_LocauxContratsApiService();
		Boolean result = locauxContratsApi.invokeMethod('callLocauxContrats_IP', inputMap, outputMap, null);

		System.assertEquals(true, result);

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 12/04/2022
     * @description Testing the mock of LocauxContrats API
     */
	@isTest
	private static void testCallLocauxContrats(){
        
        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock('LOCAUX_CONTRATS', new TestingMockHttp());

        Test.startTest();

        //1 - Testing null values
        Map<String,Object> outputMap = new Map<String, Object>();
        outputMap = SM_AP71_LocauxContratsApiService.callLocauxContrats(null);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //2 - Testing with no ID_PORTEFEUILLE_CONTRAT attribute
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('Id', ID_PORTEFEUILLE_CONTRAT);
        outputMap = SM_AP71_LocauxContratsApiService.callLocauxContrats(inputMap);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //3 - Testing with no ID_PORTEFEUILLE_CONTRAT value
        inputMap = new Map<String, Object>();
        inputMap.put('idsPortefeuilleContrat', null);
        outputMap = SM_AP71_LocauxContratsApiService.callLocauxContrats(inputMap);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        //4 - Testing with correct data
        inputMap = new Map<String, Object>();
        inputMap.put('idsPortefeuilleContrat', ID_PORTEFEUILLE_CONTRAT);
        outputMap = SM_AP71_LocauxContratsApiService.callLocauxContrats(inputMap);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(2, ((List<Object>) outputMap.get('resultdata')).size());

        //5 - Empty payload
        multiMockHttp.addRequestMock('LOCAUX_CONTRATS', new TestingMockHttp(true));
        inputMap = new Map<String, Object>();
        inputMap.put('idsPortefeuilleContrat', ID_PORTEFEUILLE_CONTRAT);
        outputMap = SM_AP71_LocauxContratsApiService.callLocauxContrats(inputMap);
        System.assertEquals(true, outputMap.containsKey('resultdata'));
        System.assertEquals(0, ((List<Object>) outputMap.get('resultdata')).size());

        Test.stopTest();
    }
}