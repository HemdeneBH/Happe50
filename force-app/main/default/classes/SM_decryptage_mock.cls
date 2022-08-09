@isTest
global class SM_decryptage_mock implements HttpCalloutMock {

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint().contains('?urlParamsCrypt=')){
            res.setBody('ibandecrypte');
            res.setStatusCode(200);
        }
        if(req.getEndpoint().contains('ES-CoordonneesBancaires_v2')){
            res.setBody('');
            res.setStatusCode(200);
        }
        
        return res;
    }
}