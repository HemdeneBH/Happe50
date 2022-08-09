/**
 * @author khalil OUKIL
 * @date 01/04/2022
 * @description Test class for SM_WS101_PrestaServiceElec
 */
@isTest
private class SM_WS101_PrestaServiceElec_TEST {

    /* Service Id to Mock from HttpRequestService__mdt */
    private static final String SERVICEID_TO_TEST = 'ES-PrestaElecApex_v3';
    /* Service Id to Mock from HttpRequestService__mdt Create Prestation Elec Offline */
    private static final String SERVICEID_TO_TEST_CREATE = 'ES-CreatePrestaElecOfflineApex_v3';
    /* Service Id to Mock from HttpRequestService__mdt Create Prestation Elec Online */
    private static final String SERVICEID_TO_TEST_CPSEO = 'ES-CreatePrestaElecOnlineApex_v3';
    
    /* XML payload as WS request for Lire Presta Elec */
    private static final String REQUESTXML = '<?xml version="1.0" encoding="utf-8"?>'+
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v3="http://gdfsuez/bef/calypso/prestationserviceelectricite/v3">'+
        '<soapenv:Body><v3:lirePrestationServiceElectricite><lirePrestationServiceElectriciteInput><online>false</online><typeOffre><code>INDUSTRIELLE</code></typeOffre>'+
        '<prestationServiceElectricite><idPrestationServiceFournisseur>0104187102</idPrestationServiceFournisseur></prestationServiceElectricite></lirePrestationServiceElectriciteInput>'+
        '<context><version>3</version><systemPath><system><systemId>Smile</systemId></system></systemPath></context></v3:lirePrestationServiceElectricite></soapenv:Body></soapenv:Envelope>';
    
    /* XML payload as WS request for Create Presta Elec Offline */
    private static final String CREATE_REQUEST_XML='<?xml version="1.0" encoding="utf-8"?>'+
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v3="http://gdfsuez/bef/calypso/prestationserviceelectricite/v3">'+
        '<soapenv:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" soapenv:mustUnderstand="0">'+
        '<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="UsernameToken-1"><wsse:Username>PN6261</wsse:Username>'+
        '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">9843e698-0ae4-44ea-93ad-3f4675d3b78b</wsse:Password></wsse:UsernameToken></wsse:Security>'+
        '</soapenv:Header><soapenv:Body><v3:creerPrestationServiceElectriciteOffline><creerPrestationServiceElectriciteOfflineInput><typeOffre><code>INDUSTRIELLE</code></typeOffre><donneesGenerales>'+
        '<idPrestationServiceDistributeur>A6287489</idPrestationServiceDistributeur><natureDemande/><idPDLElectricite>25362662622789</idPDLElectricite><idPersonne>0316028947</idPersonne><idPersonneResponsable>173277</idPersonneResponsable>'+
        '<idContrat>6025091227</idContrat><typePrestationService><code>Z002</code></typePrestationService></donneesGenerales></creerPrestationServiceElectriciteOfflineInput><context>'+
        '<version>2.0</version><systemPath><system><systemId>Smile</systemId></system></systemPath></context></v3:creerPrestationServiceElectriciteOffline></soapenv:Body></soapenv:Envelope>';
    
    /* XML payload as WS response for Lire Presta Elec Online  */
    private static final String RESPONSE_XML  = '<?xml version="1.0" encoding="utf-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
        '<soapenv:Body><tns:lirePrestationServiceElectriciteResponse xmlns:tns="http://gdfsuez/bef/calypso/prestationserviceelectricite/v3"><lirePrestationServiceElectriciteOutput><prestationServiceLire>'+
        '<idPrestationServiceDistributeur>A05P2SB7</idPrestationServiceDistributeur><idPrestationServiceFournisseur>0104187102</idPrestationServiceFournisseur><donneesGenerales><statutPrestationService>'+
        '<libelleCourt>Termin\u00e9</libelleCourt><code>E0004</code></statutPrestationService><typePrestationService><libelleCourt>Elec : MES avec d\u00e9placement</libelleCourt><code>Z002</code></typePrestationService>'+
        '<idPersonneResponsable>SJ6114</idPersonneResponsable><idContrat>519990032</idContrat><jalons><jalon><numeroJalon>1</numeroJalon><dateHeure>2022-03-30T17:54:52</dateHeure><etatJalon><libelleCourt>Programm\u00e9e chez EGD</libelleCourt>'+
        '<code>E0005</code></etatJalon></jalon></jalons><donneesPDL><idPDLElectricite>24562518056573</idPDLElectricite></donneesPDL></donneesGenerales><interventions><intervention><operations><teleoperables>false</teleoperables></operations>'+
        '<planifications><planification><datePrevue>2021-03-29</datePrevue><surSite><heureDebutPrevue>073000</heureDebutPrevue><heureFinPrevue>173000</heureFinPrevue></surSite></planification></planifications></intervention></interventions><demande>'+
        '<donneesGeneralesDemande><typePrestationService><codeProduit><libelleCourt>MES sur raccordement existant</libelleCourt><code>300227</code></codeProduit></typePrestationService><solde><fraisPrestation>16.79</fraisPrestation>'+
        '<montantPrevisionnelPrestation>16.79</montantPrevisionnelPrestation><montantMinAPercevoir>0.00</montantMinAPercevoir><soldeDu>0.00</soldeDu><dateDette>2021-03-26T00:00:00</dateDette></solde><idPDLElectricite>24562518056573</idPDLElectricite>'+
        '<idPrestationServiceDistributeur>A05P2SB7</idPrestationServiceDistributeur><dateEffetSouhaitee>2021-03-26T00:00:00</dateEffetSouhaitee><dateCreationPrestationService>2021-03-24T16:57:02</dateCreationPrestationService><commentaire>PNO:</commentaire>'+
        '<origineDemande>CLIENT</origineDemande></donneesGeneralesDemande><planificationExpressSouhaitee>false</planificationExpressSouhaitee><planificationUrgenteSouhaitee>false</planificationUrgenteSouhaitee><donneesAutoReleve><dateAutoReleve>0002-11-30T00:00:00</dateAutoReleve>'+
        '</donneesAutoReleve><donneesReleve><dateReleve>0002-11-30T00:00:00</dateReleve><mesureIndex><mesureIndex><libelleCourt>Cadran HP</libelleCourt><code>HP</code></mesureIndex><index><valeur>000000</valeur><unite>kWh</unite></index></mesureIndex><mesureIndex><mesureIndex>'+
        '<libelleCourt>Cadran HC</libelleCourt><code>HC</code></mesureIndex><index><valeur>000000</valeur><unite>kWh</unite></index></mesureIndex></donneesReleve><clientFinal><idPersonne>315047337</idPersonne></clientFinal></demande></prestationServiceLire></lirePrestationServiceElectriciteOutput>'+
        '<messageRetours><retourTraitementMessage><id>f8256c05-d5fa-4dee-ae4b-49168a884af4</id><source>Middleware Octopus</source><libelle>Traitement effectu\u00e9 sans erreur pour lidPrestationServiceDistributeur = A05P2SB7</libelle><classe>Fonctionnelle</classe><type>Information</type>'+
        '<code>OCTOPUS_LirePrestationServiceElectricite_01</code><timestamp>2022-03-30T17:54:52+01:00</timestamp></retourTraitementMessage></messageRetours></tns:lirePrestationServiceElectriciteResponse></soapenv:Body></soapenv:Envelope>';
     
     /* XML payload as WS response for Create Presta Elec Offline */   
     private static final String CREATE_RESPONSE_XML  ='<?xml version="1.0" encoding="utf-8"?>'+
         '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
         '<soapenv:Body><tns:creerPrestationServiceElectriciteOfflineResponse xmlns:tns="http://gdfsuez/bef/calypso/prestationserviceelectricite/v3">'+
         '<creerPrestationServiceElectriciteOfflineOutput><idPrestationServiceFournisseur>0106279344</idPrestationServiceFournisseur>'+
         '</creerPrestationServiceElectriciteOfflineOutput><messageRetours><retourTraitementMessage><id>945a77fd-479f-4866-92fe-5f2e7dfa3368</id><source>SAP CRM</source>'+
         '<libelle>Traitement effectu\u00e9 sans erreur.</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_CreerPrestationServiceElectriciteOffline_01</code>'+
         '<timestamp>2022-04-19T10:12:46+01:00</timestamp></retourTraitementMessage></messageRetours></tns:creerPrestationServiceElectriciteOfflineResponse></soapenv:Body></soapenv:Envelope>';
     
    /* XML payload as WS response for Create Presta Elec Online */ 
    private static final String CREATE_PRESTA_ONLINE_RESPONSE_XML ='<?xml version="1.0" encoding="utf-8"?>'+
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'+
        '<soapenv:Body><tns:creerPrestationServiceElectriciteResponse xmlns:tns="http://gdfsuez/bef/calypso/prestationserviceelectricite/v3">'+
        '<creerPrestationServiceElectriciteOutput><sequence><idPrestationServiceDistributeur>A05Z8SVH</idPrestationServiceDistributeur>'+
        '</sequence><idPDLElectricite>25347033267672</idPDLElectricite><prestationServiceDistributeurCree>true</prestationServiceDistributeurCree>'+
        '<prestationServiceFournisseurCree>true</prestationServiceFournisseurCree><idPrestationServiceFournisseur>0106279683</idPrestationServiceFournisseur>'+
        '</creerPrestationServiceElectriciteOutput><messageRetours><retourTraitementMessage><id>db1e7d90-a5ca-4011-b1ee-fefb645af199</id><source>Middleware Octopus</source>'+
        '<libelle>Traitement effectu\u00e9 sans erreur.</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_CreerPrestationServiceElectricite_01</code>'+
        '<timestamp>2022-06-14T17:56:54+01:00</timestamp></retourTraitementMessage></messageRetours></tns:creerPrestationServiceElectriciteResponse></soapenv:Body></soapenv:Envelope>';
 
    /**
     * @author khalil OUKIL
     * @date 01/04/2022
     * @description Mocking callout in test context
     * @return DOM.Document the response in XML
    */
    private static DOM.Document buildResponse(String Res){
        
        DOM.Document doc = new DOM.Document();
        doc.load(Res);

        return doc;
    }

    /**
     * @author khalil oukil
     * @date 01/04/22
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockHttp implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(buildResponse(RESPONSE_XML).toXmlString());

            return res;
        }
    }
    
    /**
     * @author khalil oukil
     * @date 01/04/22
     * @description Mocking callout in test context
     */
    public inherited sharing class TestingMockSoap implements WebServiceMock{

        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                                String requestName, String responseNS, String responseName, String responseType) {
            	
            Dom.Document responseDoc = buildResponse(RESPONSE_XML);
            Dom.XmlNode rootNode = responseDoc.getRootElement();
            Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            Dom.XmlNode PrestaelecResponseNode = bodyNode.getChildElement(responseName, responseNS);
			gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element responsex = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element(PrestaelecResponseNode);
            response.put('response_x', responsex);
           
        }
    }
    
     /**
     * @author Achraf Sabar
     * @date 01/04/22
     * @description Mocking callout in test context
     */
     public inherited sharing class TestingMockHttp_CreateOffline implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(buildResponse(CREATE_RESPONSE_XML).toXmlString());

            return res;
        }
    }
    
     /**
     * @author Achraf Sabar
     * @date 01/04/22
     * @description Mocking callout in test context
     */
     public inherited sharing class TestingMockSoap_CreateOffline implements WebServiceMock{

        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                                String requestName, String responseNS, String responseName, String responseType) {
            	
            Dom.Document responseDoc = buildResponse(CREATE_RESPONSE_XML);
            Dom.XmlNode rootNode = responseDoc.getRootElement();
            Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            Dom.XmlNode PrestaelecResponseNode = bodyNode.getChildElement(responseName, responseNS);
            gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element responsex= new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element(PrestaelecResponseNode) ;
            response.put('response_x', responsex);
           
        }
    }
    
     /**
     * @author Achraf Sabar
     * @date 01/04/22
     * @description Mocking callout in test context
     */
     public inherited sharing class TestingMockSoap_CreateOnline implements WebServiceMock{

        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, 
                                String requestName, String responseNS, String responseName, String responseType) {
            	
            response.put('response_x', new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element());
        }
    }
    
     /**
     * @author Achraf Sabar
     * @date 01/04/22
     * @description Mocking callout in test context
     */
     public inherited sharing class TestingMockHttp_CreateOnline implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(buildResponse(CREATE_PRESTA_ONLINE_RESPONSE_XML).toXmlString());

            return res;
        }
    }
    
    /**
    * @author khalil oukil
    * @date 01/04/22
    * @description Test methode de Search Prestation Elec Online
    */
    @isTest
    private static void testSearch(){

        DOM.Document inputDoc = new DOM.Document();
        inputDoc.load(REQUESTXML);

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST, new TestingMockHttp());

        MCK002_MultiWebserviceMock multiMockSoap = new MCK002_MultiWebserviceMock();
        Test.setMock(WebServiceMock.class, multiMockSoap);
        multiMockSoap.addRequestMock(SERVICEID_TO_TEST, new TestingMockSoap());

        Test.startTest();

        //Search with HTTP implementation
        Dom.XmlNode lirePrestationServiceElectriciteResponseNode = SM_WS101_PrestaServiceElec.search('POST', inputDoc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'lirePrestationServiceElectriciteResponse', 'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3');   
  		gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element response = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element(lirePrestationServiceElectriciteResponseNode);
        System.assertEquals('A05P2SB7', response.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].idPrestationServiceDistributeur); 

        //Checking exception when node are not found
       String message = '';
        try{
            lirePrestationServiceElectriciteResponseNode = SM_WS101_PrestaServiceElec.search('POST', inputDoc, 'Bodyfake', 'http://schemas.xmlsoap.org/soap/envelope/', 'lirePrestationServiceElectriciteResponse', 'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3');
        } catch (Exception exp){
            message = exp.getMessage();
        }
        System.assertEquals(true, message.startsWith('No bodyNode found in response for key/namespace ='), 'A node with the body key is not found');

		
        message = '';
        try{
            lirePrestationServiceElectriciteResponseNode = SM_WS101_PrestaServiceElec.search('POST', inputDoc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'lirePrestationServiceElectriciteResponseFake', 'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3');

        } catch (Exception exp){
            message = exp.getMessage();
        } 
        System.assertEquals(true, message.startsWith('No responseNode found in body for key/namespace = '), 'A node with the response key is not found');
        
        //Search with SOAP implementation
        gdfsuezBefCalypsoPrestationServiceElec.Dependency dependency = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
        gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt inputDt = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt(inputDoc.getRootElement());
        
        gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectricite_element request_x = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectricite_element();
        request_x.lirePrestationServiceElectriciteInput = inputDt;

        gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element response_x;

        Map<String, gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element>();
        response_map_x.put('response_x', response_x);

        String[] ns_map_type_info = new String[]{'http://localhost:8080/services/PrestationServiceElectricite/v3', 'tns:LirePrestationServiceElectricite', 
                                                'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3', 'lirePrestationServiceElectricite',
                                                'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3', 'lirePrestationServiceElectriciteResponse',
                                                'gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectricite_element'};
        
        SM_WS101_PrestaServiceElec.search(dependency, request_x, response_map_x, ns_map_type_info);
        response_x = response_map_x.get('response_x');
        System.assertEquals('A05P2SB7', response_x.lirePrestationServiceElectriciteOutput.prestationServiceLire[0].idPrestationServiceDistributeur);         
        
        Test.stopTest();        
    }
        
     /**
     * @author Achraf Sabar
     * @date 01/04/22
     * @description Test methode de Create Prestation Elec Offline
     */
      @isTest
   	  private static void testCreatePrestationElecOffline(){

        DOM.Document inputDoc = new DOM.Document();
        inputDoc.load(CREATE_REQUEST_XML);

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST_CREATE, new TestingMockHttp_CreateOffline());
        
        MCK002_MultiWebserviceMock multiMockSoap = new MCK002_MultiWebserviceMock();
        Test.setMock(WebServiceMock.class, multiMockSoap);
        multiMockSoap.addRequestMock(SERVICEID_TO_TEST_CREATE, new TestingMockSoap_CreateOffline());
  
        Test.startTest();
        
        //Search with HTTP implementation
        Dom.XmlNode creerPrestationServiceElectriciteOfflineResponseNode = SM_WS101_PrestaServiceElec.createOffline('POST', inputDoc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'creerPrestationServiceElectriciteOfflineResponse', 'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3');   
  		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element response = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element(creerPrestationServiceElectriciteOfflineResponseNode);
        System.assertEquals('OCTOPUS_CreerPrestationServiceElectriciteOffline_01',response.messageRetours.retourTraitementMessage[0].code ); 

        //Checking exception when node are not found
        String message = '';
        try{
            creerPrestationServiceElectriciteOfflineResponseNode = SM_WS101_PrestaServiceElec.createOffline('POST', inputDoc, 'Bodyfake', 'http://schemas.xmlsoap.org/soap/envelope/', 'creerPrestationServiceElectriciteOfflineResponse', 'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3');
        } catch (Exception exp){
            message = exp.getMessage();
        }
        System.assertEquals(true, message.startsWith('No bodyNode found in response for key/namespace ='), 'A node with the body key is not found');

         //Create with SOAP implementation
        gdfsuezBefCalypsoPrestationServiceElec.Dependency dependency = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
        gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineInputDt inputDt = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineInputDt(inputDoc.getRootElement());
        
        gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOffline_element request_x = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOffline_element();
        gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element response_x;

        request_x.creerPrestationServiceElectriciteOfflineInput = inputDt;


        Map<String, gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element>();
       

        String[] ns_map_type_info = new String[]{'http://localhost:8080/services/PrestationServiceElectricite/v3', 'tns:creerPrestationServiceElectriciteOffline', 
                                                'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3', 'creerPrestationServiceElectriciteOffline',
                                                'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3', 'creerPrestationServiceElectriciteOfflineResponse',
                                                'gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOfflineResponse_element'};
        response_map_x.put('response_x', response_x);
        SM_WS101_PrestaServiceElec.createOffline(dependency, request_x, response_map_x, ns_map_type_info);
        response_x = response_map_x.get('response_x');
        System.assertEquals('OCTOPUS_CreerPrestationServiceElectriciteOffline_01', response_x.messageRetours.retourTraitementMessage[0].code); 

       Test.stopTest();
    }
    
    /**
     * @author Achraf Sabar
     * @date 15/06/2022
     * @description Testing createPrestationServiceElec
     */
    @isTest
    private static void testCreatePrestationElecOnline(){

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST_CPSEO, new TestingMockHttp_CreateOnline());
        
        MCK002_MultiWebserviceMock multiMockSoap = new MCK002_MultiWebserviceMock();
        Test.setMock(WebServiceMock.class, multiMockSoap);
        multiMockSoap.addRequestMock(SERVICEID_TO_TEST_CPSEO, new TestingMockSoap_CreateOnline());

        Test.startTest();
        
        
        //SOAP IMPLEMENTATION
        gdfsuezBefCalypsoPrestationServiceElec.Dependency testObject = new gdfsuezBefCalypsoPrestationServiceElec.Dependency();
        gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt();
        
        gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectricite_element request_x = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectricite_element();
		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element response_x;
        request_x.creerPrestationServiceElectriciteInput = input;
        request_x.context = null;
        Map<String, gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element> response_map_x = new Map<String, gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element>();
        response_map_x.put('response_x', response_x);

        SM_WS101_PrestaServiceElec.createOnline(testObject,
            request_x,
            response_map_x,
            new String[]{'endpoint_x',
            'tns:CreerPrestationServiceElectricite',
            'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3',
            'creerPrestationServiceElectricite',
            'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3',
            'creerPrestationServiceElectriciteResponse',
            'gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element'}
        );

        response_x = response_map_x.get('response_x');

        System.assertNotEquals(null, response_x);
        
        //HTTP Implementation
        DOM.Document doc = new DOM.Document();
        DOM.XmlNode body = populateDoc(doc);
        DOM.XmlNode methodNode = body.addChildElement('v3:creerPrestationServiceElectricite', null,null);			
        
        Dom.XmlNode creerPrestationServiceElecResponseNode = SM_WS101_PrestaServiceElec.createOnline('POST', doc, 'Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'creerPrestationServiceElectriciteResponse', 'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3');

        response_x = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element(creerPrestationServiceElecResponseNode);     
        System.assertEquals('0106279683', response_x.creerPrestationServiceElectriciteOutput.idPrestationServiceFournisseur);
    
        Test.stopTest();
    }
    
    /**
    * @author Achraf Sabar
    * @date 15/06/2022
    * @param doc Document body
    * @description Complete the doucment payload
    * @return Dom.XmlNode the node containing the response
    */
    private static DOM.XmlNode populateDoc(DOM.Document doc){
        String env = 'http://schemas.xmlsoap.org/soap/envelope/';
        String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
        String xsd = 'http://www.w3.org/2001/XMLSchema';
        String v3 = 'http://gdfsuez/bef/calypso/prestationserviceelectricite/v3';

        DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
        envelope.setNamespace('v3', v3);
        DOM.XmlNode header = envelope.addChildElement('Header', env, 'soapenv');
        DOM.XmlNode body = envelope.addChildElement('Body', env, 'soapenv');

        return body;
    }
    
}