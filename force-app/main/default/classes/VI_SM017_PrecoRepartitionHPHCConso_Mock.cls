/*
*@Author: Eloi Dereeper
*@Description: Mock de l'appel HTTP à la méthode PreconiserRepartitionHPHCConsommation du WS Consommation.
*@CreatedDate: 26/11/2020
*@LastModified: 26/11/2020
*/
@isTest
public class VI_SM017_PrecoRepartitionHPHCConso_Mock  implements HttpCalloutMock{
   
    public HTTPResponse respond(HTTPRequest req) {
        system.debug('inside respond');
        HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'text/xml');
		DOM.Document responseDoc = new DOM.Document();
		DOM.Document reqDoc = req.getBodyDocument();
        system.debug('reqDoc'+ reqDoc.toXmlString());
		DOM.XmlNode rootNode = reqDoc.getRootElement();        
        DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        
        // Début des noeuds spécifiques à PreconiserRepartitionHPHCConsommation : 
		DOM.XmlNode methodNode = reqBodyNode.getChildElement('PreconiserRepartitionHPHCConsommation', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
        DOM.XmlNode inputNode = methodNode.getChildElement('PreconiserRepartitionHPHCConsommationInput', '');
        DOM.XmlNode localNode = inputNode.getChildElement('local', '');
		DOM.XmlNode listeEquipementsNode = localNode.getChildElement('listeEquipements', '');
		DOM.XmlNode chauffageNode = listeEquipementsNode.getChildElement('chauffage', '');
		DOM.XmlNode energieChauffageNode = chauffageNode.getChildElement('energieChauffage', '');
        system.debug('energieChauffageNode'+ energieChauffageNode);
        DOM.XmlNode codeNode = energieChauffageNode.getChildElement('code', null);
        
        String expectedXML = '';
        system.debug('### codeNode : '+ codeNode);
        system.debug('### localNode : '+ localNode);
        system.debug('### methodNode : '+ methodNode);
        system.debug('### chauffageNode : '+ chauffageNode);
        system.debug('### energieChauffageNode : '+ energieChauffageNode);
        system.debug('### listeEquipementsNode : '+ listeEquipementsNode);
        if(String.isBlank(codeNode.getText())){
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:PreconiserRepartitionHPHCConsommationReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><PreconiserRepartitionHPHCConsommationOuput><estimationConso><cleRepartitionHP>0.0</cleRepartitionHP><cleRepartitionHC>0.0</cleRepartitionHC></estimationConso></PreconiserRepartitionHPHCConsommationOuput><messageRetours><retourTraitementMessage><source>Moteur BRM</source><libelle>Aucun modèle ne correspond au paramètres d entrées envoyées </libelle><type>Erreur</type><code>OCTOPUS_PreconiserRepartitionHPHCConsommation_03</code></retourTraitementMessage></messageRetours></tns1:PreconiserRepartitionHPHCConsommationReponse></soapenv:Body></soapenv:Envelope>';
        }
        else{
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:PreconiserRepartitionHPHCConsommationReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><PreconiserRepartitionHPHCConsommationOuput><estimationConso><cleRepartitionHP>0.68</cleRepartitionHP><cleRepartitionHC>0.32</cleRepartitionHC></estimationConso></PreconiserRepartitionHPHCConsommationOuput><messageRetours><retourTraitementMessage><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur</libelle><type>Information</type><code>OCTOPUS_PreconiserRepartitionHPHCConsommation_01</code></retourTraitementMessage></messageRetours></tns1:PreconiserRepartitionHPHCConsommationReponse></soapenv:Body></soapenv:Envelope>';
        }

		responseDoc.load(expectedXML);
		res.setBody(responseDoc.toXmlString());
		res.setStatusCode(200);
        
        return res;
    }

}