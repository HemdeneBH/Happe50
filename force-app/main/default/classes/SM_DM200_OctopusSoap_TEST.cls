/**
 * @author Sutharsan Pushparajah
 * @date 24/03/2022
 * @description Test class for SM_DM200_OctopusSoap
 */
@isTest
private class SM_DM200_OctopusSoap_TEST {

    @isTest
    private static void testParseSoapResponse(){

        ITF005_SoapRequestManager soapManager = new SM_DM200_OctopusSoap('TestingMockService');
        Boolean isException = false;
        String expMessage = '';

        MCK002_MultiWebserviceMock multiMock = new MCK002_MultiWebserviceMock();
        Test.setMock(WebServiceMock.class, multiMock);
        multiMock.addRequestMock('SID-0000', new MCK001_SoapRequestMock());

        MCK001_SoapRequestMock.SoapRequestPort soapRequestPort = new MCK001_SoapRequestMock.SoapRequestPort();
        MCK001_SoapRequestMock.SoapRequest_element request = soapRequestPort.buildRequest('inputMock');
        Map<String, MCK001_SoapRequestMock.SoapRequestResponse_element> responseMap = soapRequestPort.buildResponseMap('mockResponse');
        String[] ns_map_type_info = soapRequestPort.ns_map_type_info;

        WRP004_SoapRequest soapRequest = new WRP004_SoapRequest();
        soapRequest.stub = soapRequestPort;
        soapRequest.request = request;
        soapRequest.response = responseMap;
        soapRequest.infoArray = ns_map_type_info;

        Test.startTest();

        try{
            soapManager.sendRequest(soapRequest);
        } catch(SM_DM200_OctopusSoap.OctopusCustomException exp){
            isException = true;
            expMessage = exp.getMessage();
        }

        System.assertEquals(false, isException, 'No OctopusCustomException must be thrown');
        System.assertEquals('',expMessage, 'No exception message'); 

        //EXCEPTION 1
        soapRequest.httpRequestInfos.soapResponse = null;
        isException = false;
        expMessage = '';

        try{
            soapManager.parseSoapResponse(soapRequest);
        } catch(SM_DM200_OctopusSoap.OctopusCustomException exp){
            isException = true;
            expMessage = exp.getMessage();
        }

        System.assertEquals(true, isException, 'An OctopusCustomException must be thrown');
        System.assertEquals(true,expMessage.startsWith('No response node found : '), 'Exception message must be same');
        
        //EXCEPTION 2
        soapRequest.httpRequestInfos.soapResponse = null;
        soapRequest.httpRequestInfos.theException = new SM_DM200_OctopusSoap.OctopusCustomException('TheException');
        isException = false;
        expMessage = '';

        try{
            soapManager.parseSoapResponse(soapRequest);
        } catch(SM_DM200_OctopusSoap.OctopusCustomException exp){
            isException = true;
            expMessage = exp.getMessage();
        }

        System.assertEquals(true, isException, 'An OctopusCustomException must be thrown');
        
        //EXCEPTION 3
        soapRequest.httpRequestInfos = null;
        isException = false;
        expMessage = '';

        try{
            soapManager.parseSoapResponse(soapRequest);
        } catch(SM_DM200_OctopusSoap.OctopusCustomException exp){
            isException = true;
            expMessage = exp.getMessage();
        }

        System.assertEquals(true, isException, 'An OctopusCustomException must be thrown');
        System.assertEquals(true,expMessage.startsWith('No Request Information found : '), 'Exception message must be same');
        
        Test.stopTest();
    }
}