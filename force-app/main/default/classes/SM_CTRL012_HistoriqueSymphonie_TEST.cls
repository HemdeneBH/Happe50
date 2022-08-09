/**
 * @description       : Test Class for SM_CTRL012_HistoriqueSymphonie
 * @author            : Mohamed Aamer
 * @last modified on  : 06-14-2022
 * @last modified by  : Mohamed Aamer
**/
@isTest
private class SM_CTRL012_HistoriqueSymphonie_TEST {

    /* Service Id to Mock from HttpRequestService__mdt Search Demande */
    private static final String SERVICEID_TO_TEST_SD = 'E-Demande_v4_rechercher';
    /* Service Id to Mock from HttpRequestService__mdt Read Demande */
    private static final String SERVICEID_TO_TEST_RD = 'E-Demande_v4_lire';

    private static DOM.XmlNode populateDoc(DOM.Document doc){
        String env = 'http://schemas.xmlsoap.org/soap/envelope/';
        String v4 = 'http://gdfsuez/bef/calypso/demande/v4';
        
        DOM.XmlNode envelope = doc.createRootElement('soapenv:Envelope', null, null);
        envelope.setNamespace('v4', v4);
        envelope.setNamespace('soapenv', env);
        DOM.XmlNode header = envelope.addChildElement('Header', env, 'soapenv');
        DOM.XmlNode body = envelope.addChildElement('Body', env, 'soapenv');

        return body;
    }

    public inherited sharing class TestingSearchDemandeMockHttp implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns:rechercherDemandeResponse xmlns:tns="http://gdfsuez/bef/calypso/demande/v4"><rechercherDemandeResponseOutput><idPersonne>0316022211</idPersonne><listeDemande><idDemande>1558441264</idDemande><dateCreation><valeurDate>2022-04-05T00:00:00</valeurDate></dateCreation><statutDemande><code>TERM</code></statutDemande><typeDemande><code>ZAPE</code></typeDemande><motifDemande><code>DIVESMIL</code></motifDemande></listeDemande><searchControlResponse/></rechercherDemandeResponseOutput><messageRetours><retourTraitementMessage><id>48a6514e-2aca-4a2d-aed1-f54590c5fc3d</id><source>Middleware Octopus/SAP CRM</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_RechercherDemande_00</code><timestamp>2022-06-13T15:49:18+01:00</timestamp><causedBy><id/><libelle>Traitement effectué sans erreur</libelle><type>S</type><code>0</code></causedBy></retourTraitementMessage></messageRetours></tns:rechercherDemandeResponse></soapenv:Body></soapenv:Envelope>');
            return res;
        }
    }

    public inherited sharing class TestingReadDemandeMockHttp implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><tns:lireDemandeResponse xmlns:tns="http://gdfsuez/bef/calypso/demande/v4"><lireDemandeResponseOutput><listeDemande><idDemande>1558441264</idDemande><prioriteDemande><libelleCourt>Moyenne</libelleCourt><code>5</code></prioriteDemande><complexiteDemande><code>000</code></complexiteDemande><texteLibreDemande>|#Segmentation marketing : Non qualifié #|Référence BP : 0316022211|Nom : FOULOU|</texteLibreDemande><typeDemande><libelleCourt>01-Appel entrant</libelleCourt><code>ZAPE</code></typeDemande><dateCreation>2022-04-05T13:20:21</dateCreation><canalDemande><libelleCourt>Téléphone</libelleCourt><code>TEL</code></canalDemande><motifDemande><libelleCourt>Divers / Expé SMILE</libelleCourt><code>DIVESMIL</code></motifDemande><dateModification>2022-04-05T13:20:21</dateModification><statutDemande><libelleCourt>Terminé</libelleCourt><code>TERM</code></statutDemande><objetLie><URL>http://testmock.coe</URL><idObjetLie>1524240104</idObjetLie><MotifObjetLie/><typeObjetLie/></objetLie><refPersonne><idPersonne>0000173697</idPersonne><rolePersonne><code>ZORIGINE</code></rolePersonne><nom>OCTOPUS</nom><prenom>TECHNICAL USER</prenom></refPersonne><refPersonne><idPersonne>0000165433</idPersonne><rolePersonne><code>RESP</code></rolePersonne><nom>Lemaigre</nom><prenom>Clotaire</prenom></refPersonne><refPersonne><idPersonne>0316022211</idPersonne><rolePersonne><code>CONTRACT</code></rolePersonne><nom>FOULOU</nom><prenom>FOULOU</prenom></refPersonne></listeDemande></lireDemandeResponseOutput><messageRetours><retourTraitementMessage><id>669964d1-e204-462d-938a-fbe29cbb2a53</id><source>Middleware Octopus</source><libelle>Traitement effectué sans erreur</libelle><classe>Fonctionnelle</classe><type>Information</type><code>OCTOPUS_LireDemande_00</code><timestamp>2022-06-13T15:49:23+01:00</timestamp><causedBy><id/><libelle>Traitement effectué sans erreur</libelle><type>S</type><code>00</code></causedBy></retourTraitementMessage></messageRetours></tns:lireDemandeResponse></soapenv:Body></soapenv:Envelope>');
            return res;
        }
    }

    @isTest
    private static void testgetDemandes(){

        String dateDebut='07/05/2021';
        String dateFin='07/05/2022';
        String idPersonne='01234567';

        MCK000_MultiRequestMock multiMockHttp = new MCK000_MultiRequestMock();
        Test.setMock(HttpCalloutMock.class, multiMockHttp);
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST_SD, new TestingSearchDemandeMockHttp());
        multiMockHttp.addRequestMock(SERVICEID_TO_TEST_RD, new TestingReadDemandeMockHttp());

        Test.startTest();

        List<SM_WRP006_HistoriqueSymphonie> response = SM_CTRL012_HistoriqueSymphonie.getDemandes(dateDebut,dateFin,idPersonne);
        System.debug('response: '+response);

        Test.stopTest();
		System.assertEquals('1558441264', response[0].id, 'success');
    }

}