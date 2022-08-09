/**
 * @author Sutharsan Pushparajah
 * @date 12/05/2022
 * @description SM_WS110_PrestationGaz - Implement the Prestation Gaz remote service
 */
public inherited sharing class SM_WS110_PrestationGaz {
    /* Name of the http request service setting for create prestation service gaz offline */
    public static final String CREATE_PSG_OFFLINE_SERVICE_NAME = 'CREER_PRESTATION_SERVICE_GAZ_OFFLINE';
    /* Name of the http request service setting for create prestation service gaz */
    public static final String CREATE_PSG_SERVICE_NAME = 'CREER_PRESTATION_SERVICE_GAZ';
    /* Name of the http request service setting for read prestation service gaz */
    public static final String READ_PSG_SERVICE_NAME = 'LIRE_PRESTATION_SERVICE_GAZ';
    /* Name of the http request service setting for modify prestation service gaz */
    public static final String MODIFY_PSG_SERVICE_NAME = 'MODIFIER_PRESTATION_SERVICE_GAZ';
    /* Instance of the Http Request Manager for create prestation service gaz */
    public static ITF004_HttpRequestManager createPrestationServiceGazHttp = new SM_DM201_OctopusRest(CREATE_PSG_SERVICE_NAME);
    /* Instance of the Http Request Manager for create prestation service gaz offline */
    public static ITF004_HttpRequestManager createPrestationServiceGazOfflineHttp = new SM_DM201_OctopusRest(CREATE_PSG_OFFLINE_SERVICE_NAME);
    /* Instance of the Http Request Manager for read prestation service gaz */
    public static ITF004_HttpRequestManager readPrestationServiceGazHttp = new SM_DM201_OctopusRest(READ_PSG_SERVICE_NAME);
    /* Instance of the Http Request Manager for modify prestation service gaz */
    public static ITF004_HttpRequestManager modifyPrestationServiceGazHttp = new SM_DM201_OctopusRest(MODIFY_PSG_SERVICE_NAME);
    /* Instance of the Soap Request Manager for create prestation service gaz offline */
    public static ITF005_SoapRequestManager createPrestationServiceGazOfflineSoap = new SM_DM200_OctopusSoap(CREATE_PSG_OFFLINE_SERVICE_NAME);               

    /**
     * @author Sutharsan Pushparajah
     * @date 13/05/2022
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param infoArray List of various parameters
     * @param soapManager instance of the Soap Handler
     * @description call the soap service to prestation service gaz
     * @return N/A
     */
    private static void opPrestationServiceGaz(Object stub, Object request, Map<String,Object> response, List<String> infoArray, ITF005_SoapRequestManager soapManager){
        WRP004_SoapRequest soapRequestInfos = new WRP004_SoapRequest();
        soapRequestInfos.stub = stub;
        soapRequestInfos.request = request;
        soapRequestInfos.response = response;
        soapRequestInfos.infoArray = infoArray;

        soapManager.sendRequest(soapRequestInfos);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 13/05/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @param httpManager instance of the http rrequest manager
     * @description call the http service to prestation service gaz
     * @return Dom.XmlNode the node containing the response
     */
    private static Dom.XmlNode opPrestationServiceGaz(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs, ITF004_HttpRequestManager httpManager){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = requestType;
        httpRequestInfos.bodyDocument = bodyDocument;

        httpManager.sendRequest(httpRequestInfos);

        Dom.XmlNode responseNode;
        Dom.Document responseDoc = httpRequestInfos.httpResponse.getBodyDocument();
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        Dom.XmlNode bodyNode = rootNode.getChildElement(bodyNodeKey, bodyNodeNs);

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

    /**
     * @author Sutharsan Pushparajah
     * @date 13/05/2022
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param infoArray List of various parameters
     * @description call the soap service to create prestation service gaz offline in SOAP
     * @return N/A
     */
    public static void createPrestationServiceGazOffline(Object stub, Object request, Map<String,Object> response, List<String> infoArray){
        opPrestationServiceGaz(stub, request, response, infoArray, createPrestationServiceGazOfflineSoap);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 13/05/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @description call the http service to create prestation service gaz offline in REST
     * @return Dom.XmlNode the node containing the response
     */
    public static Dom.XmlNode createPrestationServiceGazOffline(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){
        return opPrestationServiceGaz(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs, createPrestationServiceGazOfflineHttp);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 13/05/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @description call the http service to create prestation service gaz in REST
     * @return Dom.XmlNode the node containing the response
     */
    public static Dom.XmlNode createPrestationServiceGaz(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){
        return opPrestationServiceGaz(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs, createPrestationServiceGazHttp);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 13/05/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @description call the http service to read prestation service gaz in REST
     * @return Dom.XmlNode the node containing the response
     */
    public static Dom.XmlNode readPrestationServiceGaz(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){
        return opPrestationServiceGaz(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs, readPrestationServiceGazHttp);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 13/05/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @description call the http service to modify prestation service gaz in REST
     * @return Dom.XmlNode the node containing the response
     */
    public static Dom.XmlNode modifyPrestationServiceGaz(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){
        return opPrestationServiceGaz(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs, modifyPrestationServiceGazHttp);
    }
}