/**
* @author khalil OUKIL
* @date 31/03/2022
* @description SM_WS101_PrestaServiceElec
*/
public inherited sharing class SM_WS101_PrestaServiceElec {
    
    /* Name of the http request service setting */
    public static final String SERVICE_NAME = 'LIRE_PRESTATION_ELEC_APEX';
    public static final String CREATION_SERVICE_NAME = 'CREATION_PRESTATION_ELEC_OFFLINE_APEX';
    public static final String CREATION_SERVICE_ONLINE_NAME = 'CREATION_PRESTATION_ELEC_ONLINE_APEX';
    
    
    /* Instance of the Http Request Manager */
    public static ITF004_HttpRequestManager prestaServiceElecHttp = new SM_DM201_OctopusRest(SERVICE_NAME);
    public static ITF004_HttpRequestManager creerPrestationElecOfflineHttp = new SM_DM201_OctopusRest(CREATION_SERVICE_NAME);
    public static ITF004_HttpRequestManager creerPrestationElecOnlineHttp = new SM_DM201_OctopusRest(CREATION_SERVICE_ONLINE_NAME);
    
    
    /* Instance of the Soap Request Manager */
    public static ITF005_SoapRequestManager prestaServiceElecSoap = new SM_DM200_OctopusSoap(SERVICE_NAME);
    public static ITF005_SoapRequestManager creerPrestationElecOfflineSoap = new SM_DM200_OctopusSoap(CREATION_SERVICE_NAME);           
    public static ITF005_SoapRequestManager creerPrestationElecOnlineSoap = new SM_DM200_OctopusSoap(CREATION_SERVICE_ONLINE_NAME);        
    
    
        /**
     * @author Achraf Sabar
     * @date 15/06/2022
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param infoArray List of various parameters
     * @param soapManager instance of the Soap Handler
     * @description call the soap service to prestation service Elec
     * @return N/A
     */
    private static void opPrestationServiceElec(Object stub, Object request, Map<String,Object> response, List<String> infoArray, ITF005_SoapRequestManager soapManager){
        WRP004_SoapRequest soapRequestInfos = new WRP004_SoapRequest();
        soapRequestInfos.stub = stub;
        soapRequestInfos.request = request;
        soapRequestInfos.response = response;
        soapRequestInfos.infoArray = infoArray;

        soapManager.sendRequest(soapRequestInfos);
    }

    /**
     * @author Achraf Sabar
     * @date 13/05/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @param httpManager instance of the http rrequest manager
     * @description call the http service to prestation service Elec
     * @return Dom.XmlNode the node containing the response
     */
    private static Dom.XmlNode opPrestationServiceElec(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs, ITF004_HttpRequestManager httpManager){
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
     * @author Oukil Khalil
     * @date 15/06/2022
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param infoArray List of various parameters
     * @description call the soap service to Lire prestation service Elec in SOAP
     * @return N/A
     */
    public static void search(Object stub, Object request, Map<String,Object> response, List<String> infoArray){
        opPrestationServiceElec(stub, request, response, infoArray, prestaServiceElecSoap);     
    }
    

    /**
     * @author Oukil Khalil
     * @date 15/06/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @description call the http service to Lire prestation service Elec in REST
     * @return Dom.XmlNode the node containing the response
     */
    public static Dom.XmlNode search(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){    
       return opPrestationServiceElec(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs,prestaServiceElecHttp );   
    }
     
    /**
     * @author Achraf Sabar
     * @date 15/06/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @description call the http service to create prestation service Elec Online in REST
     * @return Dom.XmlNode the node containing the response
     */
    public static Dom.XmlNode createOnline(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){
        return opPrestationServiceElec(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs, creerPrestationElecOnlineHttp);
    }

     /**
     * @author Achraf Sabar
     * @date 15/06/2022
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @description call the http service to create prestation service Elec Offline in REST
     * @return Dom.XmlNode the node containing the response
     */
    public static Dom.XmlNode createOffline(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){
         return opPrestationServiceElec(requestType, bodyDocument, bodyNodeKey, bodyNodeNs, responseNodeKey, responseNodeNs, creerPrestationElecOfflineHttp);
    }
    
	/**
     * @author Achraf Sabar
     * @date 15/06/2022
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param infoArray List of various parameters
     * @description call the soap service to create prestation service Elec Offline in SOAP
     * @return N/A
     */
    public static void createOffline(Object stub, Object request, Map<String,Object> response, List<String> infoArray){       
        opPrestationServiceElec(stub, request, response, infoArray, creerPrestationElecOfflineSoap);    
    }

    /**
     * @author Achraf Sabar
     * @date 15/06/2022
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param infoArray List of various parameters
     * @description call the soap service to create prestation service Elec Online in SOAP
     * @return N/A
     */
    public static void createOnline(Object stub, Object request, Map<String,Object> response, List<String> infoArray){ 
        opPrestationServiceElec(stub, request, response, infoArray, creerPrestationElecOnlineSoap);        
    }
    
 
}