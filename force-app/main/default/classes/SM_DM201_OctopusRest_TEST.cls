/**
 * @author Sutharsan Pushparajah
 * @date 24/03/2022
 * @description Test class for SM_DM201_OctopusRest
 */
@isTest
private class SM_DM201_OctopusRest_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 24/03/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('<mock>This is a mock</mock>');

            return res;
        }
    }

    @isTest
    private static void testParseHttpResponse(){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        ITF004_HttpRequestManager restManager = new SM_DM201_OctopusRest('TestingMockService');
        Boolean isException = false;

        Test.startTest();

        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMock);
        multiMock.addRequestMock('SID-0000', new TestingMock());

        try{
            restManager.sendRequest(httpRequestInfos);
        } catch(SM_DM201_OctopusRest.OctopusCustomException exp){
            isException = true;
        }

        System.assertEquals(false, isException, 'No OctopusCustomException must be thrown');

        //TESTING 1ST EXCEPTION : Exception caught
        httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.theException = new SM_DM201_OctopusRest.OctopusCustomException('Something wrong');
        isException = false;

        try{
            restManager.parseHttpResponse(httpRequestInfos);
        } catch(SM_DM201_OctopusRest.OctopusCustomException exp){
            isException = true;
        }

        System.assertEquals(true, isException, 'An OctopusCustomException must be thrown');

        //TESTING 2ND EXCEPTION : Missing Response
        httpRequestInfos = new WRP003_HttpRequest();
        isException = false;
        String expMesssage = '';

        try{
            restManager.parseHttpResponse(httpRequestInfos);
        } catch(SM_DM201_OctopusRest.OctopusCustomException exp){
            isException = true;
            expMesssage = exp.getMessage();
        }

        System.assertEquals(true, isException, 'An OctopusCustomException must be thrown');
        System.assertEquals(true, expMesssage.startsWith('Error in response node : '), 'An OctopusCustomException must be thrown');

        Test.stopTest();
    }
}