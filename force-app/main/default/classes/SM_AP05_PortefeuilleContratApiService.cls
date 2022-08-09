global class SM_AP05_PortefeuilleContratApiService implements vlocity_cmt.VlocityOpenInterface{

    global Boolean invokeMethod (String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equals('callPortefeuilleContrat')) {
            try {
                callPortefeuilleContrat(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }
        return true;
    }

    public static void callPortefeuilleContrat (Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (inputMap.get('idPortefeuilleContrat') == null || String.valueOf(inputMap.get('idPortefeuilleContrat')).length() == 0) {
            system.debug('idPortefeuilleContrat is not found ...');
            return;
        }
        HttpResponse httpResponse = getResponse((String) inputMap.get('idPortefeuilleContrat'));
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        if (resultAsMap.Size() == 0) {
            system.debug('No data to get the idPortefeuilleContrat ' + inputMap.get('idPortefeuilleContrat'));
            return;
        }
        outMap.put('data', new PortefeuilleContratModel((String) resultAsMap.get('conditionPaiement')));
        system.debug('## [idPortefeuilleContrat] Result te be returned ' + outMap);
    }

    public class PortefeuilleContratModel {
        public String conditionPaiement;

        public PortefeuilleContratModel(String conditionPaiement) {
            this.conditionPaiement = conditionPaiement;
        }
    }

    public static HttpResponse getResponse(String idPortefeuilleContrat) {
        String endpointParams = '/' + idPortefeuilleContrat;
        HttpResponse httpResp = CalloutManager.sendRequest('Portefeuilles_Contrats',endpointParams, 'GET', CalloutManager.Scope.READ,null,null);
        System.debug(httpResp);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [PortefeuilleContrat] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        return httpResp;
    }
}