//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)

@isTest
global class gdfsuezComBefChpCalypsoReleveV3HttpMock implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req){
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		DOM.Document responseDoc = new DOM.Document();
		DOM.XmlNode envelope = responseDoc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 's');
		DOM.XmlNode bodyNode = envelope.addChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/', null);
        
		DOM.Document reqDoc = req.getBodyDocument();
		DOM.XmlNode rootNode = reqDoc.getRootElement();
		DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
		DOM.XmlNode[] methodNode = reqBodyNode.getChildElements();
		if(methodNode[0].getName() == 'ConsulterReleves'){
			DOM.XmlNode ResponseNode = bodyNode.addChildElement('consulterRelevesResponse', 'http://gdfsuez.com/bef/chp/calypso/releve/v3', null);
		}
		else if(methodNode[0].getName() == 'CreerIndexElec'){
			DOM.XmlNode ResponseNode = bodyNode.addChildElement('creerIndexElecResponse', 'http://gdfsuez.com/bef/chp/calypso/releve/v3', null);
		}
		else if(methodNode[0].getName() == 'CreerIndexGaz'){
			DOM.XmlNode ResponseNode = bodyNode.addChildElement('creerIndexGazResponse', 'http://gdfsuez.com/bef/chp/calypso/releve/v3', null);
		}
		else if(methodNode[0].getName() == 'VerifierFenetreReleve'){
			DOM.XmlNode ResponseNode = bodyNode.addChildElement('verifierFenetreReleveResponse', 'http://gdfsuez.com/bef/chp/calypso/releve/v3', null);
		}
		else if(methodNode[0].getName() == 'VerifierProchaineReleve'){
			DOM.XmlNode ResponseNode = bodyNode.addChildElement('verifierProchaineReleveResponse', 'http://gdfsuez.com/bef/chp/calypso/releve/v3', null);
		}
		res.setBody(responseDoc.toXmlString());
		res.setStatusCode(200);
		return res;
	}
}