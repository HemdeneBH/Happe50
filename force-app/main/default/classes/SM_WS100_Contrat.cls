/**
 * @author Sutharsan Pushparajah
 * @date 06/10/2021
 * @description SM_WS100_Contrat - Implement the contrat remote service
 */
public inherited sharing class SM_WS100_Contrat {
    /* Name of the http request service setting */
    public static final String SERVICE_NAME = 'RECHERCHER_CONTRAT';
    /* Instance of the Http Request Manager */
    public static ITF004_HttpRequestManager contratServiceHttp = new SM_DM201_OctopusRest(SERVICE_NAME);
    /* Instance of the Soap Request Manager */
    public static ITF005_SoapRequestManager contratServiceSoap = new SM_DM200_OctopusSoap(SERVICE_NAME);               

    /**
     * @author Sutharsan Pushparajah
     * @date 06/10/2021
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param infoArray List of various parameters
     * @description call the soap service to search contrat
     * @return N/A
     */
    public static void search(Object stub, Object request, Map<String,Object> response, List<String> infoArray){
        WRP004_SoapRequest soapRequestInfos = new WRP004_SoapRequest();
        soapRequestInfos.stub = stub;
        soapRequestInfos.request = request;
        soapRequestInfos.response = response;
        soapRequestInfos.infoArray = infoArray;

        contratServiceSoap.sendRequest(soapRequestInfos);
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 06/10/2021
     * @param requestType HTTP Method
     * @param bodyDocument Request content
     * @param bodyNodeKey key to find the body node
     * @param bodyNodeNs Namespace of the body node
     * @param responseNodeKey key to find the response node
     * @param responseNodeNs Namespace of the response node
     * @description call the http service to search contrat
     * @return Dom.XmlNode the node containing the response
     */
    public static Dom.XmlNode search(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = requestType;
        httpRequestInfos.bodyDocument = bodyDocument;

        contratServiceHttp.sendRequest(httpRequestInfos);

        Dom.XmlNode contratResponseNode;
        Dom.Document responseDoc = httpRequestInfos.httpResponse.getBodyDocument();
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        Dom.XmlNode bodyNode = rootNode.getChildElement(bodyNodeKey, bodyNodeNs);

        if (bodyNode == null){
            throw new SM_DM201_OctopusRest.OctopusCustomException('No bodyNode found in response for key/namespace = '+bodyNodeKey+'/'+bodyNodeNs+' : '+ responseDoc);
        } else {
            contratResponseNode = bodyNode.getChildElement(responseNodeKey, responseNodeNs);

            if (contratResponseNode == null){
                throw new SM_DM201_OctopusRest.OctopusCustomException('No responseNode found in body for key/namespace = '+responseNodeKey+'/'+responseNodeNs+' : '+ bodyNode);
            }
        }

        return contratResponseNode;
    }
}