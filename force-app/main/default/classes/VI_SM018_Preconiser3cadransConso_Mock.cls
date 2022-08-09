/*
*@Author: Paul Ghoussoub
*@Description: Mock de l'appel HTTP à la méthode preconiser3cadrans du WS Consommation.
*@CreatedDate: 26/11/2020
*/
@isTest
global class VI_SM018_Preconiser3cadransConso_Mock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        DOM.Document responseDoc = new DOM.Document();
        DOM.Document reqDoc = req.getBodyDocument();
        DOM.XmlNode rootNode = reqDoc.getRootElement(); 
        
        DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        system.debug('reqBodyNode '+reqBodyNode);
        // Début des noeuds spécifiques à EstimerElecConsommation : 
        DOM.XmlNode methodNode = reqBodyNode.getChildElement('PreconiserRepartition3cadransConsommation', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
        system.debug('methodNode '+methodNode);
        DOM.XmlNode PreconiserRepartition3cadransConsommationInputNode = methodNode.getChildElement('PreconiserRepartition3cadransConsommationInput', '');
        DOM.XmlNode inputNode = PreconiserRepartition3cadransConsommationInputNode.getChildElement('donneesOffre', '');
        
        System.debug('EDE Debug mock : ' + inputNode);
        
        DOM.XmlNode localNode = inputNode.getChildElement('local', '');
        DOM.XmlNode listeEquipementsNode = localNode.getChildElement('listeEquipements', '');
        DOM.XmlNode chauffageNode = listeEquipementsNode.getChildElement('chauffage', '');
        DOM.XmlNode energieChauffageNode = chauffageNode.getChildElement('energieChauffage', '');
        DOM.XmlNode codeNode = energieChauffageNode.getChildElement('code', null);
        
        String expectedXML = '';
        
        if(String.isBlank(codeNode.getText())){
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:PreconiserRepartition3cadransConsommationReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><messageRetours><retourTraitementMessage><id>c4b7c763-d083-49e1-bc67-19e6f5c1e92b</id><source>Moteur BRM</source><libelle>Aucun modèle ne correspond aux paramètres d\'entrées envoyées</libelle><classe>Fonctionnelle</classe><type>Erreur</type><code>OCTOPUS_PreconiserRepartition3cadransConsommation_03</code><timestamp>2020-11-26T15:42:46+01:00</timestamp></retourTraitementMessage></messageRetours></tns1:PreconiserRepartition3cadransConsommationReponse></soapenv:Body></soapenv:Envelope>';
        }
        else{
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:PreconiserRepartition3cadransConsommationReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><PreconiserRepartition3cadransConsommationOutput><donneesOffre><idOffre>EBUWEF2</idOffre><estimationConsoParCadran><cadran><libelleCourt>Cadran HP</libelleCourt><code>HP</code></cadran><cleRepartition>0.48</cleRepartition></estimationConsoParCadran><estimationConsoParCadran><cadran><libelleCourt>Cadran HC</libelleCourt><code>HC</code></cadran><cleRepartition>0.22</cleRepartition></estimationConsoParCadran><estimationConsoParCadran><cadran><libelleCourt>Cadran Weekend</libelleCourt><code>WE</code></cadran><cleRepartition>0.3</cleRepartition></estimationConsoParCadran></donneesOffre></PreconiserRepartition3cadransConsommationOutput><messageRetours><retourTraitementMessage><id>9c1f28d1-b3fb-429f-a1a9-762c86bc8d3d</id><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_PreconiserRepartition3cadransConsommation_01</code><timestamp>2020-11-26T15:28:25+01:00</timestamp></retourTraitementMessage></messageRetours></tns1:PreconiserRepartition3cadransConsommationReponse></soapenv:Body></soapenv:Envelope>';
        }
        
        responseDoc.load(expectedXML);
        res.setBody(responseDoc.toXmlString());
        res.setStatusCode(200);
        
        return res;
    }
}