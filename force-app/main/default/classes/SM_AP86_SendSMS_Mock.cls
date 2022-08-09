/*
* @Author: Lahoucine Ikerchalene
* @Date: 19/05/2020
* @Description: Mock Class for SM_AP86_SendSMS and SM_AP89_SendMail
*/
global class SM_AP86_SendSMS_Mock implements HttpCalloutMock {
    
    global static HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		DOM.Document responseDoc = new DOM.Document();
		
        String response = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Header /><SOAP-ENV:Body><tns1:envoyerCorrespondanceResponse xmlns:tns1="http://gdfsuez/bef/calypso/Correspondance/v2"><messageRetours><messageRetour><code>OCTOPUS_EnvoyerCorrespondance_01</code><libelle>Traitement effectué sans erreur</libelle><type>Information</type><source>Middleware OCTOPUS</source></messageRetour></messageRetours></tns1:envoyerCorrespondanceResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
		

		responseDoc.load(response);

		System.debug('*** Mock returned : ' + responseDoc.toXmlString());
		res.setBody(responseDoc.toXmlString()); 
		res.setStatusCode(200);
		return res;
	}

}