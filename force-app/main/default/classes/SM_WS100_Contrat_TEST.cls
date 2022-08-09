/**
 * @author Sutharsan Pushparajah
 * @date 06/10/2021
 * @description Test class for SM_WS100_Contrat
 */
@isTest
private class SM_WS100_Contrat_TEST {

    /* Service Id to Mock from HttpRequestService__mdt */
    private static final String SERVICEID_TO_TEST = 'ES-Contrat_V7';

    /* XML payload as WS request */
    private static final String requestXml = '<?xml version="1.0" encoding="UTF-8"?>'+
    '<soapenv:Envelope xmlns:v7="http://gdfsuez/bef/calypso/contrat/v7" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
    '<soapenv:Header /><soapenv:Body><v7:rechercherContrat><rechercherContratInput><idPersonne>306559850</idPersonne>'+
    '<searchControlRequest><pagination><offset>10</offset><from>0</from></pagination></searchControlRequest>'+
    '</rechercherContratInput><context><version>2.0</version><systemPath><system><systemId>Smile</systemId></system>'+
    '</systemPath></context></v7:rechercherContrat></soapenv:Body></soapenv:Envelope>';

    /* XML payload as WS response */
    private static final String responseXml  = '<?xml version="1.0" encoding="UTF-8"?>'+
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
    '<soapenv:Body><tns:rechercherContratResponse xmlns:tns="http://gdfsuez/bef/calypso/contrat/v7">'+
    '<rechercherContratOutput><contrat><idContrat>6011567616</idContrat><compteClient>'+
    '<idCompteClient>000401774057</idCompteClient></compteClient><pack><idPack>DGBUEBUF3A_P</idPack>'+
    '</pack><dateDemenagementSouhaitee>2020-12-21T00:00:00.0</dateDemenagementSouhaitee>'+
    '<dateEmmenagementSouhaitee>2017-08-05T00:00:00.0</dateEmmenagementSouhaitee>'+
    '<dateEcheance>2020-08-31T00:00:00.0</dateEcheance><composanteContrat><numContratISU>6008736637</numContratISU>'+
    '<PDL><idPDL>21343704755814</idPDL></PDL><secteurActivite><libelleCourt>Electricite</libelleCourt><code>5E</code>'+
    '</secteurActivite><historiqueComposante><typeComposante><code>ZNOE</code></typeComposante><statutComposante>'+
    '<libelleCourt>Active</libelleCourt><code>E0004</code></statutComposante>'+
    '<dateDebutContrat>2017-08-05T00:00:00.0</dateDebutContrat><dateFinContrat>2021-01-14T00:00:00.0</dateFinContrat>'+
    '<offre><idOffre>EBUA3</idOffre></offre></historiqueComposante></composanteContrat></contrat>'+
    '<searchControlResponse><pageCount>3</pageCount><totalCount>3</totalCount></searchControlResponse>'+
    '</rechercherContratOutput><messageRetours><retourTraitementMessage><id>5c1b6e5d-0c5d-4286-aff4-bb27beedbf32</id>'+
    '<source>Middleware Octopus</source><libelle>Traitement effectue sans erreur</libelle><classe>Fonctionnelle</classe>'+
    '<type>Information</type><code>OCTOPUS_RechercherContrat_01</code><timestamp>2021-10-11T15:16:41+01:00</timestamp>'+
    '</retourTraitementMessage></messageRetours></tns:rechercherContratResponse></soapenv:Body></soapenv:Envelope>';

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
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(buildResponse().toXmlString());

            return res;
        }
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
    private static void testSearch(){

        DOM.Document inputDoc = new DOM.Document();
        inputDoc.load(requestXml);

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST, new TestingMockHttp());

        MCK002_MultiWebserviceMock multiMockSoap = new MCK002_MultiWebserviceMock();
        Test.setMock(WebServiceMock.class, multiMockSoap);
        multiMockSoap.addRequestMock(SERVICEID_TO_TEST, new TestingMockSoap());

        Test.startTest();

        //Search with HTTP implementation
        Dom.XmlNode rechercherContratResponseNode = SM_WS100_Contrat.search('POST', inputDoc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'rechercherContratResponse', 'http://gdfsuez/bef/calypso/contrat/v7');     
        gdfsuezBefCalypsoContratV7.rechercherContratResponse_element response = new gdfsuezBefCalypsoContratV7.rechercherContratResponse_element(rechercherContratResponseNode);
        
        System.assertEquals('6011567616', response.rechercherContratOutput.contrat[0].idContrat);

        //Checking exception when node are not found
        String message = '';
        try{
            rechercherContratResponseNode = SM_WS100_Contrat.search('POST', inputDoc, 'Bodyfake', 'http://schemas.xmlsoap.org/soap/envelope/', 'rechercherContratResponse', 'http://gdfsuez/bef/calypso/contrat/v7');
        } catch (Exception exp){
            message = exp.getMessage();
        }
        
        System.assertEquals(true, message.startsWith('No bodyNode found in response for key/namespace ='), 'A node with the body key is not found');

        message = '';
        try{
            rechercherContratResponseNode = SM_WS100_Contrat.search('POST', inputDoc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'rechercherContratResponseFake', 'http://gdfsuez/bef/calypso/contrat/v7');
        } catch (Exception exp){
            message = exp.getMessage();
        }
        
        System.assertEquals(true, message.startsWith('No responseNode found in body for key/namespace = '), 'A node with the response key is not found');

        //Search with SOAP implementation
        gdfsuezBefCalypsoContratV7.Dependency dependency = new gdfsuezBefCalypsoContratV7.Dependency();
        gdfsuezBefCalypsoContratV7.rechercherContratInputDt inputDt = new gdfsuezBefCalypsoContratV7.rechercherContratInputDt(inputDoc.getRootElement());
        
        gdfsuezBefCalypsoContratV7.rechercherContrat_element request_x = new gdfsuezBefCalypsoContratV7.rechercherContrat_element();
        request_x.rechercherContratInput = inputDt;

        gdfsuezBefCalypsoContratV7.rechercherContratResponse_element response_x;

        Map<String, gdfsuezBefCalypsoContratV7.rechercherContratResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoContratV7.rechercherContratResponse_element>();
        response_map_x.put('response_x', response_x);

        String[] ns_map_type_info = new String[]{'http://localhost:8080/services/Contrat/v6', 'tns:RechercherContrat', 
                                                'http://gdfsuez/bef/calypso/contrat/v7', 'rechercherContrat',
                                                'http://gdfsuez/bef/calypso/contrat/v7', 'rechercherContratResponse',
                                                'gdfsuezBefCalypsoContratV7.rechercherContratResponse_element'};
        
        SM_WS100_Contrat.search(dependency, request_x, response_map_x, ns_map_type_info);
        response_x = response_map_x.get('response_x');
        
        System.assertEquals('6011567616', response_x.rechercherContratOutput.contrat[0].idContrat);

        Test.stopTest();
    }
}