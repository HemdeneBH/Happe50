/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 01-05-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
global class HP_ResponseMock implements HttpCalloutMock{

    global String body;
    global Integer statusCode;

    global HP_ResponseMock(String body, Integer statusCode) {
        this.body = body != null ? HP_StaticResourceTestUtils_TEST.extractStaticResourceBody(body) : '';
        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {
        if(req.getMethod() == 'GET'){
            HttpResponse resp = new HttpResponse();
            resp.setBody(HP_StaticResourceTestUtils_TEST.extractStaticResourceBody('HP_OktaCreateUser_OK_MOCK'));
            resp.setStatusCode(200);
            return resp;
        }
        HttpResponse response = new HttpResponse();
        response.setBody(body);
        response.setStatusCode(statusCode);
        return response;
    }
}