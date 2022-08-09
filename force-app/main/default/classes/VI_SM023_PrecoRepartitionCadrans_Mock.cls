/*
*@Author: Eloi Dereeper
*@Description: Classe mock de VI_SM023_PrecoRepartitionCadrans
*@CreatedDate: 25/11/2020
*@LastModified: 25/11/2020
*/
@isTest
public class VI_SM023_PrecoRepartitionCadrans_Mock  implements HttpCalloutMock{
    
	public HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'text/xml');
        
		DOM.Document responseDoc = new DOM.Document();
		DOM.Document reqDoc = req.getBodyDocument();
		DOM.XmlNode rootNode = reqDoc.getRootElement();
		DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        
        // Début des noeuds spécifiques à EstimerElecConsommation : 
		DOM.XmlNode methodNode = reqBodyNode.getChildElement('PreconiserRepartitionCadransDistributeur', 'http://gdfsuez.com/bef/chp/calypso/Consommation/v3');
		DOM.XmlNode inputNode = methodNode.getChildElement('PreconiserRepartitionCadransDistributeurInput', '');
        DOM.XmlNode ftaNode = inputNode.getChildElement('formuleTarifaireAcheminement', '');
		DOM.XmlNode codeNode = ftaNode.getChildElement('code', null);
        
        String expectedXML = '';
        
        if(String.isBlank(codeNode.getText())){
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:PreconiserRepartitionCadransDistributeurReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><PreconiserRepartitionCadransDistributeurOuput/><messageRetours><retourTraitementMessage><source>Middleware Octopus</source><libelle>La FTA fournie ne correspond à aucun code tarifaire distributeur connu</libelle><type>Erreur</type><code>OCTOPUS_PreconiserRepartitionCadransDistributeur_03</code></retourTraitementMessage></messageRetours></tns1:PreconiserRepartitionCadransDistributeurReponse></soapenv:Body></soapenv:Envelope>';
        }
        else{
            expectedXML = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns1:PreconiserRepartitionCadransDistributeurReponse xmlns:tns1="http://gdfsuez.com/bef/chp/calypso/Consommation/v3"><PreconiserRepartitionCadransDistributeurOuput><estimationCadransDistributeur><FTA><code>BTINFMU4</code></FTA><idLocal>23</idLocal><estimationConsoDistributeurParCadran><cadran><libelleCourt>Cadran Saison Haute HP</libelleCourt><code>HPH</code></cadran><cleRepartition>0.35454</cleRepartition></estimationConsoDistributeurParCadran><estimationConsoDistributeurParCadran><cadran><libelleCourt>Cadran Saison Basse HP</libelleCourt><code>HPB</code></cadran><cleRepartition>0.21492</cleRepartition></estimationConsoDistributeurParCadran><estimationConsoDistributeurParCadran><cadran><libelleCourt>Cadran Saison Haute HC</libelleCourt><code>HCH</code></cadran><cleRepartition>0.24639</cleRepartition></estimationConsoDistributeurParCadran><estimationConsoDistributeurParCadran><cadran><libelleCourt>Cadran Saison Basse HC</libelleCourt><code>HCB</code></cadran><cleRepartition>0.18415</cleRepartition></estimationConsoDistributeurParCadran></estimationCadransDistributeur></PreconiserRepartitionCadransDistributeurOuput><messageRetours><retourTraitementMessage><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur</libelle><type>Information</type><code>OCTOPUS_PreconiserRepartitionCadransDistributeur_01</code></retourTraitementMessage></messageRetours></tns1:PreconiserRepartitionCadransDistributeurReponse></soapenv:Body></soapenv:Envelope>';
        }

		responseDoc.load(expectedXML);
		res.setBody(responseDoc.toXmlString());
		res.setStatusCode(200);
        
        return res;
    }

}