/**
 * @author Sutharsan Pushparajah
 * @date 15/04/2022
 * @description SM_WS107_TranquilityContractsGetByAdress - Implement the Tranquility Contracts Get By Adresse remote service
 */
public inherited sharing class SM_WS107_TranquilityContractsGetByAdress {
    
    /* Name of the http request service setting for getting contracts by adresse */
    public static final String SERVICE_NAME = 'TRANQUILITY_CONTRACTS_GETBYADRESSE';

    /* Contracts get by adresse remote service instance */
    private static final SM_DM203_TranquilityRest tranquilityServiceHttp = new SM_DM203_TranquilityRest(SERVICE_NAME);

    /**
     * @author Sutharsan Pushparajah
     * @date 15/04/2022
     * @description Call Contracts get by adresse API
     * @param inputRequest payload object to pass to the body of the request
     * @return Map<String, Object> deserialized response of the WS call
     */
    public static Map<String, Object> getByAdresse(SM_WRP001_AddContrat.RequestOffre inputRequest){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = 'POST';
        httpRequestInfos.body = JSON.serialize(inputRequest);
        
        tranquilityServiceHttp.sendRequest(httpRequestInfos);

        Map<String, Object> resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(httpRequestInfos.httpResponse.getBody());

        return resultAsMap;
    }

}