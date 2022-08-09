@isTest
global class SM_BAT08_GenesysDeleteRequest_Mock implements HttpCalloutMock { 
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"status":"test_Genesys OK"}');
        response.setStatusCode(200);
        return response; 
    }
}