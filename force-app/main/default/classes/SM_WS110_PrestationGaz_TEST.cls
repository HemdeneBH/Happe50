/**
 * @author Sutharsan Pushparajah
 * @date 16/05/2022
 * @description Test class for SM_WS110_PrestationGaz
 */
@isTest
private class SM_WS110_PrestationGaz_TEST {

    /* Service Id to Mock from HttpRequestService__mdt Create Prestation Gaz Offline */
    private static final String SERVICEID_TO_TEST_CPSGO = 'ES-PrestationServiceGazOffline_v2';
    /* Service Id to Mock from HttpRequestService__mdt Create Prestation Gaz */
    private static final String SERVICEID_TO_TEST_CPSG = 'ES-PrestationServiceGaz_v2';
    /* Service Id to Mock from HttpRequestService__mdt Read Prestation Gaz */
    private static final String SERVICEID_TO_TEST_RPSG = 'ES-LirePrestationServiceGaz_v2';
    /* Service Id to Mock from HttpRequestService__mdt Modify Prestation Gaz */
    private static final String SERVICEID_TO_TEST_MPSG = 'ES-ModifierPrestationServiceGaz_v2';

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @param doc Document body
     * @description Complete the doucment payload
     * @return Dom.XmlNode the node containing the response
     */
    private static DOM.XmlNode populateDoc(DOM.Document doc){
        String env = 'http://schemas.xmlsoap.org/soap/envelope/';
        String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
        String xsd = 'http://www.w3.org/2001/XMLSchema';
        String v2 = 'http://gdfsuez/bef/calypso/prestationservicegaz/v2';
        
        DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
        envelope.setNamespace('v2', v2);
        DOM.XmlNode header = envelope.addChildElement('Header', env, 'soapenv');
        DOM.XmlNode body = envelope.addChildElement('Body', env, 'soapenv');

        return body;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockSoap implements WebServiceMock{

        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                                String requestName, String responseNS, String responseName, String responseType) {
            	
            response.put('response_x', new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineResponse_element());
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingCreateOfflineMockHttp implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v2="http://gdfsuez/bef/calypso/prestationservicegaz/v2"><soapenv:Header/><soapenv:Body><v2:creerPrestationServiceGazOfflineResponse><creerPrestationServiceGazOfflineOutput><idPrestationServiceFournisseur>A123456789</idPrestationServiceFournisseur></creerPrestationServiceGazOfflineOutput><messageRetours><retourTraitementMessage><code>OCTOPUS_CreerPrestationServiceGazOffline_01</code></retourTraitementMessage></messageRetours></v2:creerPrestationServiceGazOfflineResponse></soapenv:Body></soapenv:Envelope>');

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingCreateMockHttp implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v2="http://gdfsuez/bef/calypso/prestationservicegaz/v2"><soapenv:Header/><soapenv:Body><v2:creerPrestationServiceGazResponse><creerPrestationServiceGazOutput><idPrestationServiceFournisseur>A123456789</idPrestationServiceFournisseur></creerPrestationServiceGazOutput><messageRetours><retourTraitementMessage><code>OCTOPUS_CreerPrestationServiceGaz_01</code></retourTraitementMessage></messageRetours></v2:creerPrestationServiceGazResponse></soapenv:Body></soapenv:Envelope>');

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingReadMockHttp implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            
            String LIREONLINE_CRENEAU_RETENU = 'Après-midi';
            String LIREONLINE_CRENEAU_RETENU_CODE = 'APM';
            String LIREONLINE_PDL = '1234';
            String LIREONLINE_DATE_PREVUE = '2018-09-10T00:00:00Z';
            String LIREONLINE_REF_EXT = 'D123';
            String LIREONLINE_COM = 'NPO : présence non obligatoire';

            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v2="http://gdfsuez/bef/calypso/prestationservicegaz/v2"><soapenv:Header/><soapenv:Body><v2:lirePrestationServiceGazResponse><lirePrestationServiceGazOutput><prestationServiceLire><idPrestationServiceDistributeur>1234</idPrestationServiceDistributeur><idPrestationServiceFournisseur>A123456789</idPrestationServiceFournisseur><donneesGenerales><dateEffetDemandee><date>' + LIREONLINE_DATE_PREVUE+ '</date><creneauHoraire><code>'+ LIREONLINE_CRENEAU_RETENU + '</code><libelleCourt>'+ LIREONLINE_CRENEAU_RETENU + '</libelleCourt></creneauHoraire></dateEffetDemandee><donneesPDL><idPDLGaz>' + LIREONLINE_PDL + '</idPDLGaz></donneesPDL></donneesGenerales><interventions><intervention><planification><datePrevue>'+ LIREONLINE_DATE_PREVUE + '</datePrevue><creneauHoraire><code>' + LIREONLINE_CRENEAU_RETENU_CODE + '</code><libelleCourt>' + LIREONLINE_CRENEAU_RETENU + '</libelleCourt></creneauHoraire></planification><commentaireIntervention>'+ LIREONLINE_COM+  '</commentaireIntervention></intervention></interventions></prestationServiceLire></lirePrestationServiceGazOutput><messageRetours><retourTraitementMessage><code>OCTOPUS_LirePrestationServiceGaz_01</code></retourTraitementMessage></messageRetours></v2:lirePrestationServiceGazResponse></soapenv:Body></soapenv:Envelope>');

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingModifyMockHttp implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v2="http://gdfsuez/bef/calypso/prestationservicegaz/v2"><soapenv:Header/><soapenv:Body><v2:modifierPrestationServiceGazResponse><modifierPrestationServiceGazOutput><dateDemandee>2018-09-10T00:00:00Z</dateDemandee><planificationIntervention><datePrevue>2018-09-10T00:00:00Z</datePrevue><creneauHoraire><libelleCourt>Après-midi</libelleCourt><code>APM</code></creneauHoraire></planificationIntervention><tableauDeCharges><creneauDisponible><date>2018-09-10T00:00:00Z</date><creneauHoraire><libelleCourt>Après-midi</libelleCourt><code>APM</code></creneauHoraire></creneauDisponible></tableauDeCharges></modifierPrestationServiceGazOutput><messageRetours><retourTraitementMessage><code>OCTOPUS_ModifierPrestationServiceGaz_01</code></retourTraitementMessage></messageRetours></v2:modifierPrestationServiceGazResponse></soapenv:Body></soapenv:Envelope>');
            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Testing createPrestationServiceGazOffline
     */
    @isTest
    private static void testCreatePrestationServiceGazOffline(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST_CPSGO, new TestingCreateOfflineMockHttp());

        MCK002_MultiWebserviceMock multiMockSoap = new MCK002_MultiWebserviceMock();
        Test.setMock(WebServiceMock.class, multiMockSoap);
        multiMockSoap.addRequestMock(SERVICEID_TO_TEST_CPSGO, new TestingMockSoap());

        Test.startTest();

        //SOAP IMPLEMENTATION
        gdfsuezBefCalypsoPrestaGaz.Dependency testObject = new gdfsuezBefCalypsoPrestaGaz.Dependency();
        gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineInputDt input = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineInputDt();
        
        gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOffline_element request_x = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOffline_element();
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineResponse_element response_x;
        request_x.creerPrestationServiceGazOfflineInput = input;
        request_x.context = null;
        Map<String, gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineResponse_element>();
        response_map_x.put('response_x', response_x);

        SM_WS110_PrestationGaz.createPrestationServiceGazOffline(testObject,
            request_x,
            response_map_x,
            new String[]{'endpoint_x',
            'tns:CreerPrestationServiceGazOffline',
            'http://gdfsuez/bef/calypso/prestationservicegaz/v2',
            'creerPrestationServiceGazOffline',
            'http://gdfsuez/bef/calypso/prestationservicegaz/v2',
            'creerPrestationServiceGazOfflineResponse',
            'gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineResponse_element'}
        );

        response_x = response_map_x.get('response_x');

        System.assertNotEquals(null, response_x);

        //HTTP Implementation
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('v2:creerPrestationServiceGazOffline', null, null);           
        Dom.XmlNode creerPrestationServiceGazOfflineResponseNode = SM_WS110_PrestationGaz.createPrestationServiceGazOffline('POST', doc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'creerPrestationServiceGazOfflineResponse', 'http://gdfsuez/bef/calypso/prestationservicegaz/v2');

        response_x = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOfflineResponse_element(creerPrestationServiceGazOfflineResponseNode);
		System.assertEquals('A123456789', response_x.creerPrestationServiceGazOfflineOutput.idPrestationServiceFournisseur);

        //Checking Exception
        Boolean exceptionThrown = false;
        String message = '';

        doc = new DOM.Document();
        body = populateDoc(doc);
        methodNode = body.addChildElement('v2:creerPrestationServiceGazOffline', null, null);
        
        try{
            creerPrestationServiceGazOfflineResponseNode = SM_WS110_PrestationGaz.createPrestationServiceGazOffline('POST', doc, 'BodyFake', 'http://schemas.xmlsoap.org/soap/envelope/', 'creerPrestationServiceGazOfflineResponse', 'http://gdfsuez/bef/calypso/prestationservicegaz/v2');
        } catch(Exception exp){
            exceptionThrown = true;
            message = exp.getMessage();
        }

        System.assertEquals(true, exceptionThrown);
        System.assertEquals(true, message.startsWith('No bodyNode found in response for key/namespace = '));

        exceptionThrown = false;
        message = '';

        try{
            creerPrestationServiceGazOfflineResponseNode = SM_WS110_PrestationGaz.createPrestationServiceGazOffline('POST', doc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'creerPrestationServiceGazOfflineResponseFake', 'http://gdfsuez/bef/calypso/prestationservicegaz/v2');
        } catch(Exception exp){
            exceptionThrown = true;
            message = exp.getMessage();
        }

        System.assertEquals(true, exceptionThrown);
        System.assertEquals(true, message.startsWith('No responseNode found in body for key/namespace = '));

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Testing createPrestationServiceGaz
     */
    @isTest
    private static void testCreatePrestationServiceGaz(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST_CPSG, new TestingCreateMockHttp());

        Test.startTest();
        
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('v2:creerPrestationServiceGaz', null, null);			
        
        Dom.XmlNode creerPrestationServiceGazResponseNode = SM_WS110_PrestationGaz.createPrestationServiceGaz('POST', doc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'creerPrestationServiceGazResponse', 'http://gdfsuez/bef/calypso/prestationservicegaz/v2');

        gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazResponse_element response_x = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazResponse_element(creerPrestationServiceGazResponseNode);     
        System.assertEquals('A123456789', response_x.creerPrestationServiceGazOutput.idPrestationServiceFournisseur);
    
        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Testing readPrestationServiceGaz
     */
    @isTest
    private static void testReadPrestationServiceGaz(){
        
        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST_RPSG, new TestingReadMockHttp());

        Test.startTest();

        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('v2:lirePrestationServiceGaz', null, null);           
        
        Dom.XmlNode lirePrestationServiceGazResponseNode = SM_WS110_PrestationGaz.readPrestationServiceGaz('POST', doc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'lirePrestationServiceGazResponse', 'http://gdfsuez/bef/calypso/prestationservicegaz/v2');
        
        gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element response_x = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element(lirePrestationServiceGazResponseNode);
        System.assertEquals('A123456789', response_x.lirePrestationServiceGazOutput.prestationServiceLire.get(0).idPrestationServiceFournisseur);
    
        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 16/05/2022
     * @description Testing readPrestationServiceGaz
     */
    @isTest
    private static void testModifyPrestationServiceGaz(){
        
        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST_MPSG, new TestingModifyMockHttp());

        Test.startTest();

        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('v2:modifierPrestationServiceGaz', null, null);            
        
        Dom.XmlNode modifierPrestationServiceGazResponseNode = SM_WS110_PrestationGaz.modifyPrestationServiceGaz('POST', doc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'modifierPrestationServiceGazResponse', 'http://gdfsuez/bef/calypso/prestationservicegaz/v2');
        
        gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazResponse_element response_x = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazResponse_element(modifierPrestationServiceGazResponseNode);

        System.assertEquals('APM', response_x.modifierPrestationServiceGazOutput.tableauDeCharges.creneauDisponible.get(0).creneauHoraire.code);
        
        Test.stopTest();
    }
        
}