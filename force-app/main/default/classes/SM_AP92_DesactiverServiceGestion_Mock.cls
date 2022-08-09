/*@Author: ADE
*@Description: mock pour desactivation FEL
*@CreatedDate: 28/10/2020
*/
@isTest
global class SM_AP92_DesactiverServiceGestion_Mock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        res.setBody('<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <SOAP-ENV:Header/><SOAP-ENV:Body> <tns:desactiverServiceGestionResponse xmlns:tns="http://gdfsuez/bef/calypso/compteclient/v6"> <desactiverServiceGestionOutput> <compteClient> <serviceSouscrit> <serviceGestion> <libelleCourt>Ma facture</libelleCourt> <code>ZFACT</code> </serviceGestion> <typeGestion> <libelleCourt>Ma facture en ligne+SMS</libelleCourt> <code>ZFACTLSMS</code> </typeGestion> </serviceSouscrit> </compteClient> </desactiverServiceGestionOutput> <messageRetours> <retourTraitementMessage> <id>3a47c740-b5cc-4e69-ab98-9d39cf326a3d</id> <source>Middleware Octopus</source> <libelle>Erreur pour le compte client : 000516686693 : Etat demandé égal état existant..</libelle> <classe>Fonctionnelle</classe> <type>Erreur</type> <code>OCTOPUS_DesactiverServiceGestion_08</code> <timestamp>2020-10-28T14:13:12+01:00</timestamp> </retourTraitementMessage> <retourTraitementMessage> <id>3a47c740-b5cc-4e69-ab98-9d39cf326a3d</id> <source>Middleware Octopus</source> <libelle>Traitement effectué sans erreur.</libelle> <classe>Fonctionnelle</classe> <type>Information</type> <code>OCTOPUS_DesactiverServiceGestion_01</code> <timestamp>2020-10-28T14:13:12+01:00</timestamp> </retourTraitementMessage> </messageRetours> </tns:desactiverServiceGestionResponse> </SOAP-ENV:Body> </SOAP-ENV:Envelope>');
        res.setStatusCode(200);
        return res;
    }
}