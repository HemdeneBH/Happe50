global class SM_AP31_LocauxApiService_Ref implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equals('callLocaux')) {
            try {
                callLocaux(inputMap, outMap, options);
            } catch (Exception e) {
                return false;
            }
        }
        else if(methodName.equals('getIdNewLocal')){
            try {
                getIdNewLocal(inputMap, outMap, options);
            } catch (Exception e) {
                return false;
            }
        }
        return true;
    }
    
    public static void callLocaux(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        if (inputMap.get('idLocal') == null || String.valueOf(inputMap.get('idLocal')).length() == 0) {
            return;
        }
        
        HttpResponse httpResponse = getResponse(String.valueOf(inputMap.get('idLocal')),false);
        if(httpResponse!=null){
            Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
            if (resultAsMap.Size() == 0) {              
                outMap.put('numeroLocal', null);     
            }
            else {
                outMap.put('numeroLocal', String.ValueOf(resultAsMap.get('numeroLocal')));     
            } 
        }
        else{
            outMap.put('numeroLocal', null);     
        }
        
    }
    
    public static void getIdNewLocal(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        if (inputMap.get('numeroLocal') == null || String.valueOf(inputMap.get('numeroLocal')).length() == 0) {
            throw new IOException('Numero du local non trouvé');
        }
        
        HttpResponse httpResponse = getResponse(String.valueOf(inputMap.get('numeroLocal')),true);
        if(httpResponse!=null){
            Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
            if (resultAsMap.Size() == 0) {              
                throw new IOException('Local non trouvé');
            }
            else {
                List < Object > listeRetourAPI = (List < Object > ) resultAsMap.get('_data');
                if(listeRetourAPI.size()==0){
                    throw new IOException('Local non trouvé');
                }
                Map<String, Object> localAPI = (Map<String,Object>) listeRetourAPI.get(0);
                outMap.put('idLocal',  String.valueOf(localAPI.get('id')));
            }
        }
        else{
            throw new IOException('Problème lors de la récupération des données du local');
        }
        
    }
    
    public class IOException extends Exception {
    }
    
    public static String buildRequestParams(String uriParam,String queryParam) {
        String endpointParams='';
        if(!String.isBlank(uriParam))
            endpointParams += '/'+uriParam;
        else if(!String.isBlank(queryParam))
            endpointParams += '?numeroLocal=' + queryParam;
        return endpointParams;
    }
    
    public static HttpResponse getResponse(String numeroLocal,Boolean isNewLocal) {
        String endpointParams = isNewLocal ? buildRequestParams(null,numeroLocal) : buildRequestParams(numeroLocal,null) ;
        HttpResponse httpResp = CalloutManager.sendRequest('Locaux', endpointParams, 'GET', CalloutManager.Scope.READ, null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            return null;
        }
        return httpResp;
    }
    
}