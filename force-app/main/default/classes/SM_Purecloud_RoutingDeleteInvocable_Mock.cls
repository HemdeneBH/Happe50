/*
* @Author: Riadh Dallel
* @Date: 28/06/2021
* @Description: Mock Class for SM_Purecloud_RoutingDeleteInvocable_Test
*/
global class SM_Purecloud_RoutingDeleteInvocable_Mock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // mock service pour /api/v2/conversations/{conversationId}/disconnect
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"test_Genesys"}');
        res.setStatusCode(200);
        return res;
    }
}