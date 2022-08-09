/**
 * @author Sutharsan Pushparajah
 * @date 19/04/2022
 * @description Test class for SM_DM203_TranquilityRest
 */
@isTest
private class SM_DM203_TranquilityRest_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 19/04/2022
     * @description Test parsing the response of the callout
     */
    @isTest
    private static void testSendRequest(){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        Boolean isException = false;

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getMocks());
       
        SM_DM203_TranquilityRest restManager = new SM_DM203_TranquilityRest(SM_MCK001_Tranquility.GENERIC_SERVICE_NAME);

        try{
            restManager.sendRequest(httpRequestInfos);
        } catch(Exception exp){
            isException = true;
            System.debug(exp.getMessage());
        }

        System.assertEquals(false, isException, 'No Exception must be thrown');
        System.assertEquals(true, httpRequestInfos.header.containsKey('Content-Length'), 'Header must contain Content-Length');
        System.assertEquals(true, httpRequestInfos.header.containsKey('X-correlation-id'), 'Header must contain X-correlation-id');
        System.assertEquals(true, httpRequestInfos.header.containsKey('x-Authorization'), 'Header must contain x-Authorization');
        System.assertEquals('Bearer theToken', httpRequestInfos.header.get('x-Authorization'), 'Header must contain x-Authorization');
        
        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 20/04/2022
     * @description Test parsing the response of the callout to getToken
     */
    @isTest
    private static void testGetToken(){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        Boolean isException = false;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, SM_MCK001_Tranquility.getMocks());
       
        String token = SM_DM203_TranquilityRest.getToken(httpRequestInfos);
        System.assertEquals('Bearer theToken', token);
        System.assertEquals('gaia=FAKE&mdp=FAKE', httpRequestInfos.httpRequest.getBody());

        Test.stopTest();
    }
}