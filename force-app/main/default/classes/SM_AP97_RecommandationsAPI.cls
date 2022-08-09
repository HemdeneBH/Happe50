public class SM_AP97_RecommandationsAPI {
    
    public static final String API_RECOMMANDATION_SUFFIX = 'recommandations';
    @AuraEnabled(cacheable=true)
    public static String getServicePriritaire(String numeroBP ){
        String endpointParams = '?numeroBusinessPartner='+numeroBP;
        HttpResponse httpResp = CalloutManager.sendRequest(API_RECOMMANDATION_SUFFIX , endpointParams , 'GET', CalloutManager.Scope.READ,null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            system.debug('##ERROR OCCURED WHEN APPEL API RECOMMANDATION  ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResp.getBody());
        String resultAsMapp = JSON.serialize(resultAsMap.get('_data'));
        List<  Object > resultAsMappp = (List<  Object >  ) JSON.deserializeUntyped(resultAsMapp);
        Map<String ,Object> rest= (Map<String ,Object>) resultAsMappp.get(0);
        system.debug('API RECOMMANDATION RESPONSE '+ resultAsMap.get('_data'));
        system.debug('API RECOMMANDATION RESPONSE 2 '+ resultAsMapp);
        system.debug('test'+ rest.get('service1'));
        String servicePrio = (String )rest.get('service1');
        return servicePrio;
    }}