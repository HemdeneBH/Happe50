/**
 * @author Sutharsan Pushparajah
 * @date 04/04/2022
 * @description SM_WS102_Personne - Implement the Personne remote service
 */
public inherited sharing class SM_WS102_Personne {
    /* Name of the http request service setting */
    public static final String SERVICE_NAME = 'PERSONNES';
    /* Root node of the response payload */
    private static final String ROOT_NODE = '_data'; 

    /**
     * @author Sutharsan Pushparajah
     * @date 04/04/2022
     * @description Call Personnes API to get record based on idBusinessPartner
     * @param idBusinessPartner Id of the Personne record to retrieve
     * @param version the API version number in uppercase (ex:V0,V1...)
     * @return List of record corresponding to the filter
     */
    public static List<Object> getPersonnes(String idBusinessPartner, String version){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = 'GET';
        httpRequestInfos.queryParameters  = '?idBusinessPartner='+String.escapeSingleQuotes(idBusinessPartner);

        ITF004_HttpRequestManager personneServiceHttp = new SM_DM202_ApigeeRest(SERVICE_NAME+'_'+version);
        personneServiceHttp.sendRequest(httpRequestInfos);

        Map<String, Object> resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(httpRequestInfos.httpResponse.getBody());
		List<Object> personnesList = (List< Object>) resultAsMap.get(ROOT_NODE);

        return personnesList;
    }
}