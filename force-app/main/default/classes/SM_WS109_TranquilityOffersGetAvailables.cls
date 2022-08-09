/**
 * @author Sutharsan Pushparajah
 * @date 15/04/2022
 * @description SM_WS109_TranquilityOffersGetAvailables - Implement the Tranquility Offers Get Availables remote service
 */
public inherited sharing class SM_WS109_TranquilityOffersGetAvailables {
    
    /* Name of the http request service setting for getting available offers */
    public static final String SERVICE_NAME = 'TRANQUILITY_OFFERS_GETAVAILABLES';

    /* Offers Get Availables remote service instance */
    private static final SM_DM203_TranquilityRest tranquilityServiceHttp = new SM_DM203_TranquilityRest(SERVICE_NAME);

    /**
     * @author Sutharsan Pushparajah
     * @date 15/04/2022
     * @description Call Offers Get Availables API
     * @param inputRequest payload object to pass to the body of the request
     * @return Map<String, Object> deserialized response of the WS call
     */
    public static Map<String, Object> getAvailableOffers(SM_WRP001_AddContrat.RequestOffreAvailables inputRequest){
        WRP003_HttpRequest httpRequestInfos = new WRP003_HttpRequest();
        httpRequestInfos.requestType = 'POST';
        httpRequestInfos.body = JSON.serialize(inputRequest);
        
        tranquilityServiceHttp.sendRequest(httpRequestInfos);

        Map<String, Object> resultAsMap = (Map<String, Object>) JSON.deserializeUntyped(httpRequestInfos.httpResponse.getBody());

        return resultAsMap;
    }

}