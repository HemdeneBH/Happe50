/*
*@Author: Eloi Dereeper
*@Description: Mock de l'appel HTTP à la méthode EstimerGazConsommation du WS Consommation.
*@CreatedDate: 26/11/2020
*@LastModified: 26/11/2020
*/
@isTest
global class VI_SM019_EstimerGazConsommation_Mock implements HttpCalloutMock{
	global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'text/xml');
		DOM.Document responseDoc = new DOM.Document();
		DOM.Document reqDoc = req.getBodyDocument();
		DOM.XmlNode rootNode = reqDoc.getRootElement();        
        
		DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        
        // Début des noeuds spécifiques à EstimerElecConsommation : 
		DOM.XmlNode methodNode = reqBodyNode.getChildElement('EstimerGazConsommation', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
		DOM.XmlNode inputNode = methodNode.getChildElement('EstimerGazConsommationInput', '');
        
        System.debug('EDE Debug mock : ' + inputNode);
        
		DOM.XmlNode localNode = inputNode.getChildElement('local', '');
		DOM.XmlNode codePostalNode = localNode.getChildElement('codePostal', '');
		DOM.XmlNode codeNode = codePostalNode.getChildElement('code', null);
        
        String expectedXML = '';
        
        if(String.isBlank(codeNode.getText())){
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:EstimerGazConsommationReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><EstimerGazConsommationzOutput><estimationConso><consommationEstimee>0</consommationEstimee></estimationConso></EstimerGazConsommationzOutput><messageRetours><retourTraitementMessage><source>Moteur BRM</source><libelle>Aucun modèle ne correspond aux paramètres d entrées envoyées </libelle><type>Erreur</type><code>OCTOPUS_EstimerGazConsommation_04</code></retourTraitementMessage></messageRetours></tns1:EstimerGazConsommationReponse></soapenv:Body></soapenv:Envelope>';
        }
        else{
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:EstimerGazConsommationReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><EstimerGazConsommationzOutput><estimationConso><consommationEstimee>1000</consommationEstimee></estimationConso></EstimerGazConsommationzOutput><messageRetours><retourTraitementMessage><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur</libelle><type>Information</type><code>OCTOPUS_EstimerGazConsommation_01</code></retourTraitementMessage></messageRetours></tns1:EstimerGazConsommationReponse></soapenv:Body></soapenv:Envelope>';
        }

		responseDoc.load(expectedXML);
		res.setBody(responseDoc.toXmlString());
		res.setStatusCode(200);
        
        return res;
    }
}