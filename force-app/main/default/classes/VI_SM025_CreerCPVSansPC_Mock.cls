/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe Mock de VI_SM025_CreerCPVSansPC
*@CreatedDate: 17/03/2021
*/
@isTest
public class VI_SM025_CreerCPVSansPC_Mock  implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        DOM.Document responseDoc = new DOM.Document();
        DOM.Document reqDoc = req.getBodyDocument();
        system.debug('reqDoc'+ reqDoc.toXmlString());
        DOM.XmlNode rootNode = reqDoc.getRootElement();
        DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        system.debug('reqBodyNode '+reqBodyNode);
        
        DOM.XmlNode methodNode = reqBodyNode.getChildElement('v2:creerCPVSansPC', '');
        system.debug('methodNode '+methodNode);
        DOM.XmlNode inputNode = methodNode.getChildElement('creerCPVSansPCInput', '');
        system.debug('inputNode '+inputNode);
        DOM.XmlNode listeCodeValeurNode = inputNode.getChildElement('listeCodeValeur', '');
        system.debug('listeCodeValeurNode '+listeCodeValeurNode);
        DOM.XmlNode coupleCodeValeurNode = listeCodeValeurNode.getChildElement('coupleCodeValeur', '');
        system.debug('coupleCodeValeurNode '+coupleCodeValeurNode);
        DOM.XmlNode valeurNode = coupleCodeValeurNode.getChildElement('valeur', '');
        system.debug('valeurNode '+valeurNode);
        
        String expectedXML = '';
        
        if(String.isBlank(valeurNode.getText())){
            system.debug('Here');
            expectedXML='<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns:creerCPVSansPCResponse xmlns:tns="http://gdfsuez.com/bef/calypso/cpv/v2"><creerCPVSansPCOutput><documentCree><idDocument>00MPA2107614245908780000</idDocument><revisionDocument>1</revisionDocument><statutDocument><libelleCourt>Brouillon</libelleCourt><code>Validé</code></statutDocument><contenuDocument>JVBERi0xLjQKJeLjz9MNCjExIDAgb2JqCjw8Ci9UeXBlL1hPYmplY3QKL1N1YnR5cGUvSW1hZ2UKL1dpZHRoIDQ3MgovSGVpZ2h0IDI4NAovQml0c1BlckNvbXBvbmVudCA4Ci9Db2xvclNwYWN2JhMzBkNDM1OD5dCj4+CnN0YXJ0eHJlZgozODE4ODEKJSVFT0YK</contenuDocument><nomDocument>ZCPV5001q000008vOIAAA2.pdf</nomDocument><codeLocalite/></documentCree></creerCPVSansPCOutput><messageRetours><retourTraitementMessage><id>6e0bfaf3-a31b-48d7-94cd-da6f7119e358</id><source>Middleware OCTOPUS</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_CreerCPVSansPC_01</code><timestamp>2021-03-17T14:25:04+01:00</timestamp><causedBy><source>MiddlewareOctopus</source><libelle>Traitement effectué sans erreur</libelle><type>Information</type><code>OCTOPUS_CreerDocument_01</code></causedBy></retourTraitementMessage></messageRetours></tns:creerCPVSansPCResponse></soapenv:Body></soapenv:Envelope>e>';
        }
        else{
            expectedXML='<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns:creerCPVSansPCResponse xmlns:tns="http://gdfsuez.com/bef/calypso/cpv/v2"><creerCPVSansPCOutput><documentCree><idDocument>00MPA2107614245908780000</idDocument><revisionDocument>1</revisionDocument><statutDocument><libelleCourt>Brouillon</libelleCourt><code>Validé</code></statutDocument><contenuDocument>JVBERi0xLjQKJeLjz9MNCjExIDAgb2JqCjw8Ci9UeXBlL1hPYmplY3QKL1N1YnR5cGUvSW1hZ2UKL1dpZHRoIDQ3MgovSGVpZ2h0IDI4NAovQml0c1BlckNvbXBvbmVudCA4Ci9Db2xvclNwYWN2JhMzBkNDM1OD5dCj4+CnN0YXJ0eHJlZgozODE4ODEKJSVFT0YK</contenuDocument><nomDocument>ZCPV5001q000008vOIAAA2.pdf</nomDocument><codeLocalite/></documentCree></creerCPVSansPCOutput><messageRetours><retourTraitementMessage><id>6e0bfaf3-a31b-48d7-94cd-da6f7119e358</id><source>Middleware OCTOPUS</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_CreerCPVSansPC_01</code><timestamp>2021-03-17T14:25:04+01:00</timestamp><causedBy><source>MiddlewareOctopus</source><libelle>Traitement effectué sans erreur</libelle><type>Information</type><code>OCTOPUS_CreerDocument_01</code></causedBy></retourTraitementMessage></messageRetours></tns:creerCPVSansPCResponse></soapenv:Body></soapenv:Envelope>';
            system.debug('Here2');
        }
        
        responseDoc.load(expectedXML);
        res.setBody(responseDoc.toXmlString());
        res.setStatusCode(200);
        return res;
    }
}