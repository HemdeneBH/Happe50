/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_WS002_GestionPrelevement
*@CreatedDate: 15/02/2021
*/
@isTest
public class VI_WS002_GestionPrelevement_Test {
    /* Service Id to Mock from HttpRequestService__mdt */
    private static final String SERVICEID_TO_TEST = 'VI_SERV_0001_V1';
    /* XML payload as WS request */
    private static final String requestXml = '<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"> <soap:Body><demanderPrelevementInput><idPersonne>312414551</idPersonne><idCompteClient>000516724867</idCompteClient><coordonneesBancaires><idCoordonneeBancaire>0312414551-0001</idCoordonneeBancaire></coordonneesBancaires><changementPayeur>false</changementPayeur></demanderPrelevementInput><context><version>2.0</version><systemPath><system_x><systemId>PP</systemId></system_x></systemPath></context></soap:Body> </soap:Envelope>';
    /* XML payload as WS response */
    private static final String responseXml  = '<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"> <soap:Body><messageRetours><messageRetour><type_x>Information</type_x><timestamp>2021-12-10T16:19:22.000Z</timestamp><source>Middleware OCTOPUS</source><libelle>Information remontée par le service CreerMandat : Mandat au statut "A confirmer" en attente dactivation, existe déjà pour le BP et IBAN renseigné.</libelle><id>39cf437c-c9d2-4576-9633-9fc0785fc57f</id><code>OCTOPUS_DemanderPrelevement_02</code><classe>Fonctionnelle</classe></messageRetour><messageRetour><type_x>Information</type_x><timestamp>2021-12-10T16:19:22.000Z</timestamp><source>Middleware OCTOPUS</source><libelle>Information remontée par le service ActiverServiceGestion : DP activée avec succès.</libelle><id>39cf437c-c9d2-4576-9633-9fc0785fc57f</id><code>OCTOPUS_DemanderPrelevement_05</code><classe>Fonctionnelle</classe></messageRetour><messageRetour><type_x>Information</type_x><timestamp>2021-12-10T16:19:22.000Z</timestamp><source>Middleware OCTOPUS</source><libelle>Information remontée par le service ActiverServiceGestion : DP activée avec succès.</libelle><id>39cf437c-c9d2-4576-9633-9fc0785fc57f</id><code>OCTOPUS_DemanderPrelevement_05</code><classe>Fonctionnelle</classe></messageRetour><messageRetour><type_x>Information</type_x><timestamp>2021-12-10T16:19:22.000Z</timestamp><source>Middleware OCTOPUS</source><libelle>Traitement effectué sans erreur</libelle><id>39cf437c-c9d2-4576-9633-9fc0785fc57f</id><code>OCTOPUS_DemanderPrelevement_01</code><classe>Fonctionnelle</classe></messageRetour></messageRetours><demanderPrelevementOutput><mandat><statutMandat><libelleCourt>A confirmer</libelleCourt><code>2</code></statutMandat><idPersonne>0312414551</idPersonne><idMandat>00S014584380</idMandat><idCoordonneeBancaire>0312414551-0001</idCoordonneeBancaire></mandat><compteClient><listeServicesGestion><serviceGestion><libelleCourt>Demande prélèvement</libelleCourt><code>DP</code></serviceGestion></listeServicesGestion><idCompteClient>000516724867</idCompteClient></compteClient></demanderPrelevementOutput></soap:Body> </soap:Envelope>';
    
    /**
* @author Sutharsan Pushparajah
* @date 11/10/2021
* @description Mocking callout in test context
* @return DOM.Document the response in XML
*/
    private static DOM.Document buildResponse(){
        
        DOM.Document doc = new DOM.Document();
        doc.load(responseXml);
        
        return doc;
    }
    
    /**
* @author Sutharsan Pushparajah
* @date 11/10/2021
* @description Mocking callout in test context
*/
    public inherited sharing class TestingMockSoap implements WebServiceMock{
        
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                             String requestName, String responseNS, String responseName, String responseType) {
                                 
                                 Dom.Document responseDoc = buildResponse();
                                 Dom.XmlNode rootNode = responseDoc.getRootElement();
                                 Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
                                 Dom.XmlNode contratResponseNode = bodyNode.getChildElement(responseName, responseNS);
                                 
                                 gdfsuezBefCalypsoContratV7.rechercherContratResponse_element responsex = new gdfsuezBefCalypsoContratV7.rechercherContratResponse_element(contratResponseNode);
                                 response.put('response_x', responsex);
                             }
    }
    
    @isTest
    private static void testGestionPrelevement(){
        DOM.Document inputDoc = new DOM.Document();
        inputDoc.load(requestXml);
        MCK002_MultiWebserviceMock multiMockSoap = new MCK002_MultiWebserviceMock();
        Test.setMock(WebServiceMock.class, multiMockSoap);
        multiMockSoap.addRequestMock(SERVICEID_TO_TEST, new TestingMockSoap());
        
        Test.startTest();
        VI_gdfsuezComBefChpPivot_Prelevement1.contextDt octx = VI_SM031_GestionPrelevement.initContext('PP', '2.0');
        VI_gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort port = new VI_gdfsuezComBefChpCalypsoGestionprele.GestionPrelevementPort();
        port.endpoint_x =    'callout:VI_AuthOctopus' + '/ES-GestionPrelevement_v1';
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };
                    VI_gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt coordonneesBancairesInput = new VI_gdfsuezComBefChpCalypsoGestionprele.coordonneeBancaireDt();
        coordonneesBancairesInput.idCoordonneeBancaire = '0304596236-0002';
        VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt input = new VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementInputDt();
        input.idPersonne = '0304596236';
        input.coordonneesBancaires = coordonneesBancairesInput;
        input.idCompteClient = '000506631943';
        input.changementPayeur = false; // getChangementPayeur;
        VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevement_element request_x = new VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevement_element();
        request_x.demanderPrelevementInput = input;
       VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element response_x;
        Map<String, VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element> response_map_x = new Map<String, VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element>();
        response_map_x.put('response_x', response_x);
        String[] ns_map_type_info = new String[]{'tns:DemanderPrelevement',
                    'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
                    'demanderPrelevement',
                    'http://gdfsuez.com/bef/chp/calypso/GestionPrelevement/v1',
                    'demanderPrelevementResponse',
                    'VI_gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element'};

        VI_WS002_GestionPrelevement.GestionPrelevement(port, request_x, response_map_x, ns_map_type_info);
        //VI_SM031_GestionPrelevement.mandatRetour retour=VI_SM031_GestionPrelevement.demandePrelevement(null,'0304596236-0002','0304596236','000506631943','callout:VI_AuthOctopus');

        response_x = response_map_x.get('response_x');
        Test.stopTest();
    }
    
    
}