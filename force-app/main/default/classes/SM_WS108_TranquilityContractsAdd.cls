/**
 * @author Sutharsan Pushparajah
 * @date 15/04/2022
 * @description SM_WS108_TranquilityContractsAdd - Implement the Tranquility Contracts Add remote service
 */
public inherited sharing class SM_WS108_TranquilityContractsAdd {
    
    /* Name of the http request service setting for adding contracts */
    public static final String SERVICE_NAME = 'TRANQUILITY_CONTRACTS_ADD';

    /* Contracts Add remote service instance */
    private static final SM_DM203_TranquilityRest tranquilityServiceHttp = new SM_DM203_TranquilityRest(SERVICE_NAME);

    /**
     * @author Sutharsan Pushparajah
     * @date 15/04/2022
     * @description Call Add Contrat API
     * @param body payload String to pass to the body of the request
     * @return Map<String, Object> deserialized response of the WS call
     */
    private static Map<String, Object> addContrat(String body){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = 'POST';
        httpRequestInfos.body = body;
        
        tranquilityServiceHttp.sendRequest(httpRequestInfos);

        Map<String, Object> resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(httpRequestInfos.httpResponse.getBody());

        return resultAsMap;
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 15/04/2022
     * @description Call Add Contrat API
     * @param inputRequest payload object to pass to the body of the request
     * @return Map<String, Object> deserialized response of the WS call
     */
    public static Map<String, Object> addContrat(SM_WRP001_AddContrat.RequestAddContrat inputRequest){
        return addContrat(JSON.serialize(inputRequest));
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 15/04/2022
     * @description Call Add Contrat Detection Projet API
     * @param inputRequest payload object to pass to the body of the request
     * @return Map<String, Object> deserialized response of the WS call
     */
    public static Map<String, Object> addContratDetectionProjet(SM_WRP002_AddContrat.RequestAddContrat inputRequest){
        return addContrat(JSON.serialize(inputRequest));
    }
}