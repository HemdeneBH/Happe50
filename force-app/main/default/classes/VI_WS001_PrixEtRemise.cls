public class VI_WS001_PrixEtRemise {
    /* Name of the http request service setting */
    public static final String SERVICE_NAME = 'VI_Prix_Et_Remise';
    /* Instance of the Soap Request Manager */
    public static ITF005_SoapRequestManager rechercherPrixEtRemiseServiceSoap = new DM005_SoapRequestService(SERVICE_NAME);               
    
    /**
     * @author Paul Ghoussoub
     * @date 08/12/2021
     * @param stub An instance of the auto-generated class
     * @param request The SOAP Web service request being invoked
     * @param response A collection of key/value pairs representing the response to send for the request
     * @param infoArray List of various parameters
     * @description call the soap service to search contrat
     * @return N/A
     */
    public static void RechercherPrixEtRemises(Object stub, Object request, Map<String,Object> response, List<String> infoArray){
        WRP004_SoapRequest soapRequestInfos = new WRP004_SoapRequest();
        soapRequestInfos.stub = stub;
        soapRequestInfos.request = request;
        soapRequestInfos.response = response;
        soapRequestInfos.infoArray = infoArray;

        rechercherPrixEtRemiseServiceSoap.sendRequest(soapRequestInfos);
    }
}