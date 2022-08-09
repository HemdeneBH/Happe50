@isTest
global class SM_AP90_BPMfelModifStatut_Mock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        res.setBody('<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header/><SOAP-ENV:Body><tns1:demanderSouscriptionServiceResponse xmlns:tns1="http://www.gdfsuez.com/bef/chp/calypso/GestionSouscriptionService/v1"><messageRetours><messageRetour><id>d1bf4e1e-4b83-4213-8cf9-f5cff1f41f79</id><code>OCTOPUS_DemanderSouscriptionService_01</code><libelle>Traitement effectué sans erreur</libelle><type>Information</type><source>Middleware Octopus</source><classe>Fonctionnelle</classe><timestamp>2015-05-29T18:22:31+01:00</timestamp></messageRetour></messageRetours></tns1:demanderSouscriptionServiceResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>');
        res.setStatusCode(200);
        return res;
    }
}