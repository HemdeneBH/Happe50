@isTest
global class SM_AP89_GestionSouscriptionService_mock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		DOM.Document responseDoc = new DOM.Document();
		DOM.Document reqDoc = req.getBodyDocument();
		DOM.XmlNode rootNode = reqDoc.getRootElement();
		DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		DOM.XmlNode[] methodNode = reqBodyNode.getChildElements();

		

        String expectedResult = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header/><soapenv:Body><tns1:demanderSouscriptionServiceResponse xmlns:tns1="http://www.gdfsuez.com/bef/chp/calypso/GestionSouscriptionService/v1"><messageRetours><messageRetour><id>d1bf4e1e-4b83-4213-8cf9-f5cff1f41f79</id><code>OCTOPUS_DemanderSouscriptionService_01</code><libelle>Traitement effectué sans erreur</libelle><type>Information</type><source>Middleware Octopus</source><classe>Fonctionnelle</classe><timestamp>2015-05-29T18:22:31+01:00</timestamp></messageRetour></messageRetours></tns1:demanderSouscriptionServiceResponse></soapenv:Body></soapenv:Envelope>' ;
        responseDoc.load(expectedResult);
		res.setBody(responseDoc.toXmlString());
		res.setStatusCode(200);
		return res;
    }
}