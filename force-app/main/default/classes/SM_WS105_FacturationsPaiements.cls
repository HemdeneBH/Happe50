/**
 * @author Sutharsan Pushparajah
 * @date 14/04/2022
 * @description SM_WS105_FacturationsPaiements - Implement the FacturationsPaiements remote service
 */
public inherited sharing class SM_WS105_FacturationsPaiements {
    
    /* Name of the http request service setting */
    public static final String SERVICE_NAME = 'FACTURATIONS_PAIEMENTS';
    /* Root node of the response payload */
    private static final String ROOT_NODE = '_data';
    /* FacturationsPaiements remote service instance */
    private static final ITF004_HttpRequestManager facturationsPaiementsServiceHttp = new SM_DM202_ApigeeRest(SERVICE_NAME);

    /**
     * @author Sutharsan Pushparajah
     * @date 14/04/2022
     * @description Call FacturationsPaiements API to get record based on idPortefeuilleContrat or idPersonne
     * @param idPortefeuilleContrat Id of the Contract record to identify the FacturationsPaiements record
     * @param idPersonne id of the Contact record related to FacturationsPaiements
     * @return List<Object> response from WS call into a wrapper class
     */
    public static List<Object> getFacturationsPaiements(String idPortefeuilleContrat, String idPersonne){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = 'GET';

        if (String.isNotEmpty(idPortefeuilleContrat)){
            httpRequestInfos.queryParameters = '?idsPortefeuilleContrat='+String.escapeSingleQuotes(idPortefeuilleContrat);
        } else if (String.isNotEmpty(idPersonne)){
            httpRequestInfos.queryParameters = '?idPersonne=' + String.escapeSingleQuotes(idPersonne);
        } else {
            return null;
        }
        
        facturationsPaiementsServiceHttp.sendRequest(httpRequestInfos);

        Map<String, Object> resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(httpRequestInfos.httpResponse.getBody());
		List<Object> resultList = (List< Object>) resultAsMap.get(ROOT_NODE);

        return resultList;
    }

}