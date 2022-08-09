/**
 * @author Sutharsan Pushparajah
 * @date 12/04/2022
 * @description SM_WS104_LocauxContrats - Implement the LocauxContrats remote service
 */
public inherited sharing class SM_WS104_LocauxContrats {
    
    /* Name of the http request service setting */
    public static final String SERVICE_NAME = 'LOCAUX_CONTRATS';
    /* Root node of the response payload */
    private static final String ROOT_NODE = '_data';
    /* Size of the response */
    private static final String RESPONSE_SIZE = '50';
    /* NotesDebitsCredits remote service instance */
    private static final ITF004_HttpRequestManager locauxContratsServiceHttp = new SM_DM202_ApigeeRest(SERVICE_NAME);

    /**
     * @author Sutharsan Pushparajah
     * @date 11/04/2022
     * @description Call LocauxContrats API to get record based on idPortefeuilleContrat or idPersonne
     * @param idPortefeuilleContrat Id of the Contract record to identify the LocauxContrats record
     * @param idPersonne id of the Contact record related to LocauxContrats
     * @return List<Object> response from WS call into a wrapper class
     */
    public static List<Object> getLocauxContrats(String idPortefeuilleContrat, String idPersonne){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = 'GET';

        if (String.isNotEmpty(idPortefeuilleContrat)){
            httpRequestInfos.queryParameters = '?idsPortefeuilleContrat='+String.escapeSingleQuotes(idPortefeuilleContrat)+'&size='+RESPONSE_SIZE;
        } else if (String.isNotEmpty(idPersonne)){
            httpRequestInfos.queryParameters = '?idPersonne=' + String.escapeSingleQuotes(idPersonne);
        } else {
            return null;
        }
        
        locauxContratsServiceHttp.sendRequest(httpRequestInfos);

        Map<String, Object> resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(httpRequestInfos.httpResponse.getBody());
		List<Object> resultList = (List< Object>) resultAsMap.get(ROOT_NODE);

        return resultList;
    }

}