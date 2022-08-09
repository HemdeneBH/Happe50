@isTest
public class SM_AP97_RecommandationsAPI_TEST {
    
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
        String payload = '{"_data": [{"idPersonne": 280361,"numeroBusinessPartner": "0200000033","numeroLocal": "0700000033","idLocal": 112, "service1": "code_1_821","service2": "code_2_956", "service3": "code_3_319","poserQuestionDemenagement": 1}]}';
        
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
    
    @isTest
    private static void getServicePriritaireTest(){
        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, new TestingMockHttp());
        // multiMockHttp.addRequestMock('', new TestingMockHttp());
        Test.startTest();
        String returnedData = SM_AP97_RecommandationsAPI.getServicePriritaire('0200000033');
        System.assertEquals('code_1_821', returnedData);
        System.debug('test doha api recommandations'+returnedData);
        Test.stopTest();
    }
    
    
}