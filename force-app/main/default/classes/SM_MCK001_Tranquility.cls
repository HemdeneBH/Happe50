/**
 * @author Sutharsan Pushparajah
 * @date 20/04/2022
 * @description SM_MCK001_Tranquility - Mock class Tranquility API
 */
@isTest
public class SM_MCK001_Tranquility {
    
    public static String LOGIN_SERVICE_ID = 'TRANQUILITY_USERS_LOGIN';
    public static String GENERIC_SERVICE_ID = 'SID-0000';
    public static String GENERIC_SERVICE_NAME = 'TestingMockService';
    public static String CONTRACTSBYADRESSE_SERVICE_ID = 'TRANQUILITY_CONTRACTS_GETBYADRESSE';
    public static String CONTRACTSADD_SERVICE_ID = 'TRANQUILITY_CONTRACTS_ADD';
    public static String OFFERSGETAVAILABLES_SERVICE_ID = 'TRANQUILITY_OFFERS_GETAVAILABLES';

    /**
     * @author Sutharsan Pushparajah
     * @date 20/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class Login implements HttpCalloutMock{

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"success": true, "data": {"token": "Bearer theToken", "expire": 1658162007}}');

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 20/04/2022
     * @description Mocking callout in test context
     */
    public inherited sharing class Generic implements HttpCalloutMock{

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"message":"This is a mock"}');

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 20/04/2022
     * @description Mocking Get Contracts By Adresse callout in test context
     */
    public inherited sharing class GetContractsByAdresse implements HttpCalloutMock{
		String payload = '{"return": {"retour": {"contratList": null}, "messageRetour": {"code": "SUCCESS", "libelle": "La demande a \u00e9t\u00e9 trait\u00e9e avec succ\u00e8s", "erreurList": null}}}';

		public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(payload);

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 10/05/2022
     * @description Mocking Add Contract callout in test context
     */
    public inherited sharing class AddContract implements HttpCalloutMock{
        String payload = '{ "return": { "retour": { "contratList": [ { "idContrat": 3834230, "modifiable": 0, "statutContrat": 1, "coupon": null, "idOffre": "ACP", "libOffre": "Aide coup de pouce", "prixAn": "3120.00", "prixMois": "65.00", "prixAn2": "0.00", "prixMois2": "0.00", "canal": "pap", "dateCreation": "2019-02-26T16:57:10", "dateModification": "2019-02-26T16:57:10", "dateResiliation": null, "heureEffet": "04:03:10", "dateEffet": "2019-02-26", "conseillerDetail": { "nom": "ELMEKACHER", "prenom": "Afef", "bpConseiller": 999888777, "gaia": "LS5139" }, "etatContrat": { "etat": 1, "libEtat": "Accepté" }, "idParent": null, "order_id": null, "client": { "bpClient": "1759533", "nom": "?", "prenom": "?", "civilite": "MR", "numRue": "?", "rue": "147test57", "codePostal": "94170", "commune": "?", "pays": "FR", "telmobile": null, "telDomicile": null, "email": null }, "localAssure": { "numRue": "?", "rue": "test", "codePostal": 94470, "commune": "?", "pays": "FR", "complement": null, "batiment": null, "escalier": null }, "paiementMode": { "libellePaiement": "CH", "modePrelevement": null }, "signatureElec": { "signature": null, "acceptCg": true, "acceptDateEffet": true, "acceptAdresse": true, "acceptModePaiement": true }, "metaValues": [ { "fieldName": "age_logement", "fieldValue": "Maison individuelle >15 ans" }, { "fieldName": "age_chaudiere", "fieldValue": "+ 12ans" }, { "fieldName": "double_sortie_air", "fieldValue": "OUI" }, { "fieldName": "Statut_occupants", "fieldValue": "Propriétaire occupant" }, { "fieldName": "pret_taux_zero", "fieldValue": "Oui" }, { "fieldName": "equipement", "fieldValue": "Chaudière fioul" }, { "fieldName": "equipement_a_venir", "fieldValue": "Chaudière gaz à condensation THPE" }, { "fieldName": "code_postal", "fieldValue": "Région Ile-de-France" }, { "fieldName": "nombre_personne_foyer", "fieldValue": "11" }, { "fieldName": "revenux_fiscaux", "fieldValue": "11111" }, { "fieldName": "statut_logement", "fieldValue": "Résidence principale" } ], "motifResiliation": null } ] }, "messageRetour": { "code": "SUCCESS", "libelle": "La demande a été traiter avec succès", "erreurList": null } }}';
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(payload);

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 10/05/2022
     * @description Mocking Add Contract callout in test context
     */
    public inherited sharing class OffersAvailable implements HttpCalloutMock{
        String payload = '{"return": {  "retour": { "offreList": [{ "idOffre": "ACP","libelle": "Aide coup de pouce"}] } }}';
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody(payload);

            return res;
        }
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 20/04/2022
     * @description Adding Login and Generic Mock to the context
     * @return HttpCalloutMock Instance of multiRequestMock
     */
    public static HttpCalloutMock getMocks(){
        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        multiMock.addRequestMock(SM_MCK001_Tranquility.LOGIN_SERVICE_ID, new SM_MCK001_Tranquility.Login());
        multiMock.addRequestMock(SM_MCK001_Tranquility.GENERIC_SERVICE_ID, new SM_MCK001_Tranquility.Generic());

        return multiMock;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 20/04/2022
     * @description Adding Login and GetContractsByAdresse Mock to the context
     * @return HttpCalloutMock Instance of multiRequestMock
     */
    public static HttpCalloutMock getContractsByAdresseMocks(){
        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        multiMock.addRequestMock(SM_MCK001_Tranquility.LOGIN_SERVICE_ID, new SM_MCK001_Tranquility.Login());
        multiMock.addRequestMock(SM_MCK001_Tranquility.CONTRACTSBYADRESSE_SERVICE_ID, new SM_MCK001_Tranquility.GetContractsByAdresse());

        return multiMock;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 10/05/2022
     * @description Adding Login and Add Contract Mock to the context
     * @return HttpCalloutMock Instance of multiRequestMock
     */
    public static HttpCalloutMock getAddContractMocks(){
        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        multiMock.addRequestMock(SM_MCK001_Tranquility.LOGIN_SERVICE_ID, new SM_MCK001_Tranquility.Login());
        multiMock.addRequestMock(SM_MCK001_Tranquility.CONTRACTSADD_SERVICE_ID, new SM_MCK001_Tranquility.AddContract());

        return multiMock;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 10/05/2022
     * @description Adding Login and Add Offers Available Mock to the context
     * @return HttpCalloutMock Instance of multiRequestMock
     */
    public static HttpCalloutMock getOffersAvailableMocks(){
        MCK000_MultiRequestMock multiMock = new MCK000_MultiRequestMock();
        multiMock.addRequestMock(SM_MCK001_Tranquility.LOGIN_SERVICE_ID, new SM_MCK001_Tranquility.Login());
        multiMock.addRequestMock(SM_MCK001_Tranquility.OFFERSGETAVAILABLES_SERVICE_ID, new SM_MCK001_Tranquility.OffersAvailable());

        return multiMock;
    }
}