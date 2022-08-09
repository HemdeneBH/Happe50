@isTest
public class VI_SM037_ComposerMandat_Mock implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        
        DOM.Document responseDoc = new DOM.Document();
        DOM.Document reqDoc = req.getBodyDocument();
        DOM.XmlNode rootNode = reqDoc.getRootElement();
        system.debug('rootNode '+rootNode);
        DOM.XmlNode reqBodyNode = rootNode.getChildElement('soapenv:Body', null);
        system.debug('reqBodyNode '+reqBodyNode);
        // Début des noeuds spécifiques à EstimerElecConsommation : 
        DOM.XmlNode composerMandatNode = reqBodyNode.getChildElement('v1:composerMandat', null);
        system.debug('composerMandatNode '+composerMandatNode);
        DOM.XmlNode inputNode = composerMandatNode.getChildElement('composerMandatInput', null);
        system.debug('inputNode '+inputNode);
        DOM.XmlNode idFormulaireNode = inputNode.getChildElement('idFormulaire', null);
        DOM.XmlNode codeNode = idFormulaireNode.getChildElement('code', null);
        
        String expectedXML = '';
        
        if(String.isBlank(codeNode.getText())){
            expectedXML = '<?xml version=\'1.0\' encoding=\'UTF-8\'?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:composerMandatResponse xmlns:tns1="http://gdfsuez/bef/calypso/mandat/v1"><composerMandatOutput><mandatCompose><idDocument>00MPA2112619234606130000</idDocument><revisionDocument>1</revisionDocument><statutDocument><code>Brouillon</code></statutDocument><contenuDocument>JVBERi0jU0IDAwMDAwIG4NCjAwMDAwMTU0MjYgMDAwMDAgbg0KMDAwMDAxNjE0OCAwMDAwMCBuDQowMDAwMDE2MzE0IDAwMDAwIG4NCnRyYWlsZXIKPDwKL1NpemUgMjgKL1Jvb3QgMjcgMCBSCi9JbmZvIDE5IDAgUgovSUQgWzwwOTU1NTgzMTYyNDIwOTE2YmRiZjU5YmU0MDE3NDM1OD4gPDA5NTU1ODMxNjI0MjA5MTZiZGJmNTliZTQwMTc0MzU4Pl0KPj4Kc3RhcnR4cmVmCjE2NDI2CiUlRU9GCg==</contenuDocument><nomDocument>out.pdf</nomDocument></mandatCompose></composerMandatOutput><messageRetours><retourTraitementMessage><id>10cc4c5b-8b22-4e42-bacf-3390c9688428</id><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_ComposerMandat_01</code><timestamp>2021-05-06T19:23:47+01:00</timestamp><causedBy><id>cc9525cf-5964-41d6-9b33-42a25cf831ec</id><source>MiddlewareOctopus</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_ComposerDocument_01</code><timestamp>2021-05-06T19:23:47+01:00</timestamp></causedBy></retourTraitementMessage></messageRetours></tns1:composerMandatResponse></soapenv:Body></soapenv:Envelope>';        }
        else{
            expectedXML = '<?xml version=\'1.0\' encoding=\'UTF-8\'?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:composerMandatResponse xmlns:tns1="http://gdfsuez/bef/calypso/mandat/v1"><composerMandatOutput><mandatCompose><idDocument>00MPA2112619234606130000</idDocument><revisionDocument>1</revisionDocument><statutDocument><code>Brouillon</code></statutDocument><contenuDocument>JVBERi0jU0IDAwMDAwIG4NCjAwMDAwMTU0MjYgMDAwMDAgbg0KMDAwMDAxNjE0OCAwMDAwMCBuDQowMDAwMDE2MzE0IDAwMDAwIG4NCnRyYWlsZXIKPDwKL1NpemUgMjgKL1Jvb3QgMjcgMCBSCi9JbmZvIDE5IDAgUgovSUQgWzwwOTU1NTgzMTYyNDIwOTE2YmRiZjU5YmU0MDE3NDM1OD4gPDA5NTU1ODMxNjI0MjA5MTZiZGJmNTliZTQwMTc0MzU4Pl0KPj4Kc3RhcnR4cmVmCjE2NDI2CiUlRU9GCg==</contenuDocument><nomDocument>out.pdf</nomDocument></mandatCompose></composerMandatOutput><messageRetours><retourTraitementMessage><id>10cc4c5b-8b22-4e42-bacf-3390c9688428</id><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_ComposerMandat_01</code><timestamp>2021-05-06T19:23:47+01:00</timestamp><causedBy><id>cc9525cf-5964-41d6-9b33-42a25cf831ec</id><source>MiddlewareOctopus</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_ComposerDocument_01</code><timestamp>2021-05-06T19:23:47+01:00</timestamp></causedBy></retourTraitementMessage></messageRetours></tns1:composerMandatResponse></soapenv:Body></soapenv:Envelope>';
            
        }
        
        responseDoc.load(expectedXML);
        res.setBody(responseDoc.toXmlString());
        res.setStatusCode(200);
        
        return res;
    }
}