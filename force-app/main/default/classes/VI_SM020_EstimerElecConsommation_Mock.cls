/*
*@Author: Eloi Dereeper
*@Description: Mock de l'appel HTTP à la méthode EstimerElecConsommation du WS Consommation.
*@CreatedDate: 26/11/2020
*@LastModified: 26/11/2020
*/
@isTest
global class VI_SM020_EstimerElecConsommation_Mock implements HttpCalloutMock{
    
	global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'text/xml');
		DOM.Document responseDoc = new DOM.Document();
		DOM.Document reqDoc = req.getBodyDocument();
        system.debug('reqDoc'+ reqDoc.toXmlString());
		DOM.XmlNode rootNode = reqDoc.getRootElement();
		DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        
        // Début des noeuds spécifiques à EstimerElecConsommation : 
		DOM.XmlNode methodNode = reqBodyNode.getChildElement('EstimerElecConsommation', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
		DOM.XmlNode inputNode = methodNode.getChildElement('EstimerElecConsommationInput', '');
        
        System.debug('EDE Debug mock : ' + inputNode);
        
		DOM.XmlNode localNode = inputNode.getChildElement('local', '');
		DOM.XmlNode codePostalNode = localNode.getChildElement('codePostal', '');
		DOM.XmlNode codeNode = codePostalNode.getChildElement('code', null);
        System.debug('codeNode'+ codeNode);
        
        String expectedXML = '';
        
        if(String.isBlank(codeNode.getText())){
            system.debug('Here');
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:EstimerElecConsommationReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><EstimerElecConsommationOutput><estimationConso><consommationEstimee/></estimationConso></EstimerElecConsommationOutput><messageRetours><retourTraitementMessage><source>Moteur BRM</source><libelle>Le service a terminé son exécution, la zone de logement doit être renseignée</libelle><type>Erreur</type><code>OCTOPUS_EstimerElecConsommation_05</code></retourTraitementMessage></messageRetours></tns1:EstimerElecConsommationReponse></soapenv:Body></soapenv:Envelope>';
        }
        else{
            system.debug('Here2');
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:EstimerElecConsommationReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><EstimerElecConsommationOutput><estimationConso><consommationEstimee>4415</consommationEstimee></estimationConso></EstimerElecConsommationOutput><messageRetours><retourTraitementMessage><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur</libelle><type>Information</type><code>OCTOPUS_EstimerElecConsommation_01</code></retourTraitementMessage></messageRetours></tns1:EstimerElecConsommationReponse></soapenv:Body></soapenv:Envelope>';
        }

		responseDoc.load(expectedXML);
		res.setBody(responseDoc.toXmlString());
		res.setStatusCode(200);
        
        return res;
    }
}