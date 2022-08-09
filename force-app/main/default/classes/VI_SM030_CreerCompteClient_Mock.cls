/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe Mock de VI_SM030_CreerCompteClient
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM030_CreerCompteClient_Mock implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        DOM.Document responseDoc = new DOM.Document();
        DOM.Document reqDoc = req.getBodyDocument();
        system.debug('reqDoc'+ reqDoc.toXmlString());
        DOM.XmlNode rootNode = reqDoc.getRootElement();
        DOM.XmlNode reqBodyNode = rootNode.getChildElement('soapenv:Body', null);
        system.debug('reqBodyNode '+reqBodyNode);
        
        DOM.XmlNode methodNode = reqBodyNode.getChildElement('v6:creerCompteClient', null);
        DOM.XmlNode inputNode = methodNode.getChildElement('creerCompteClientInput', null);
        DOM.XmlNode compteClientNode = inputNode.getChildElement('compteClient', '');
        system.debug('compteClientNode '+compteClientNode);
        DOM.XmlNode conditionPaiementNode = compteClientNode.getChildElement('conditionPaiement', null);
        system.debug('conditionPaiementNode '+conditionPaiementNode);
        DOM.XmlNode codeNode = conditionPaiementNode.getChildElement('code', null);
        System.debug('codeNode'+ codeNode);
        
        String expectedXML = '';
        
        if(String.isBlank(codeNode.getText())){
            system.debug('Here');
            expectedXML='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Header/><SOAP-ENV:Body><tns:creerCompteClientResponse xmlns:tns="http://gdfsuez/bef/calypso/compteclient/v6"><creerCompteClientOutput><compteClient><idCompteClient>000516694472</idCompteClient></compteClient></creerCompteClientOutput><messageRetours><retourTraitementMessage><id>9b35d251-7793-4324-997c-f34f5ad8932a</id><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur.</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_CreerCompteClient_01</code><timestamp>2021-03-16T16:57:44+01:00</timestamp></retourTraitementMessage></messageRetours></tns:creerCompteClientResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        }
        else{
            expectedXML='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><SOAP-ENV:Header/><SOAP-ENV:Body><tns:creerCompteClientResponse xmlns:tns="http://gdfsuez/bef/calypso/compteclient/v6"><creerCompteClientOutput><compteClient><idCompteClient>000516694472</idCompteClient></compteClient></creerCompteClientOutput><messageRetours><retourTraitementMessage><id>9b35d251-7793-4324-997c-f34f5ad8932a</id><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur.</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_CreerCompteClient_01</code><timestamp>2021-03-16T16:57:44+01:00</timestamp></retourTraitementMessage></messageRetours></tns:creerCompteClientResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
            system.debug('Here2');
        }
        
        responseDoc.load(expectedXML);
        res.setBody(responseDoc.toXmlString());
        res.setStatusCode(200);
        
        return res;
    }
}