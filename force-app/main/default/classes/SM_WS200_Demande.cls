/**
 * @description       : Implement the Demande remote service
 * @author            : Mohamed Aamer
 * @last modified on  : 06-13-2022
 * @last modified by  : Mohamed Aamer
**/
public inherited sharing class SM_WS200_Demande {

    /* Name of the http request service setting for searching demande service */
    public static final String RECHERCHER_DEMANDE_SERVICE = 'RECHERCHER_DEMANDE_SERVICE';
    /* Name of the http request service setting for reading demande service */
    public static final String LIRE_DEMANDE_SERVICE = 'LIRE_DEMANDE_SERVICE';

    /* Instance of the Http Request Manager for searching a demande */
    public static ITF004_HttpRequestManager rechercherDemandeServiceHttp = new SM_DM201_OctopusRest(RECHERCHER_DEMANDE_SERVICE);
    /* Instance of the Http Request Manager for reeading a demande */
    public static ITF004_HttpRequestManager lireDemandeServiceHttp = new SM_DM201_OctopusRest(LIRE_DEMANDE_SERVICE);
    
    private static Dom.XmlNode demandeService(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs, ITF004_HttpRequestManager httpManager){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = requestType;
        httpRequestInfos.bodyDocument = bodyDocument;
        System.debug('httpRequestInfos: '+httpRequestInfos);

        httpManager.sendRequest(httpRequestInfos);

        Dom.XmlNode responseNode;
        Dom.Document responseDoc = httpRequestInfos.httpResponse.getBodyDocument();
        System.debug('httpResponse body: '+httpRequestInfos.httpResponse.getBody());
        System.debug('httpResponse body doc: '+responseDoc);

        Dom.XmlNode rootNode = responseDoc.getRootElement();
        Dom.XmlNode bodyNode = rootNode.getChildElement(bodyNodeKey, bodyNodeNs);

        System.debug('rootNode: '+rootNode);
        System.debug('bodyNode: '+bodyNode);

        if (bodyNode == null){
            throw new SM_DM201_OctopusRest.OctopusCustomException('No bodyNode found in response for key/namespace = '+bodyNodeKey+'/'+bodyNodeNs+' : '+ responseDoc);
        } else {
            responseNode = bodyNode.getChildElement(responseNodeKey, responseNodeNs);

            if (responseNode == null){
                throw new SM_DM201_OctopusRest.OctopusCustomException('No responseNode found in body for key/namespace = '+responseNodeKey+'/'+responseNodeNs+' : '+ bodyNode);
            }
        }

        return responseNode;
    }

    public static Dom.XmlNode rechercherDemandeService(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){

        return demandeService(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs, rechercherDemandeServiceHttp);
    }

    public static Dom.XmlNode lireDemandeService(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){

        return demandeService(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs, lireDemandeServiceHttp);
    }
}