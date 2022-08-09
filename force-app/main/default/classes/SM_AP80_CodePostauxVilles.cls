/*
*   @description : Classe qui retourne la liste des ville pour un code postal ou l'inverse
*   @author : Marouane BEN ATIA
*   @sprint : 8 FT3
*   @Date: 20/01/2020    
*/
global with sharing  class SM_AP80_CodePostauxVilles implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('codePostauxVilles')) {
            try {
                callCodePostauxVilles(inputMap, outMap, options);
              } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }            
        }
        return true;
    }
    public static void callCodePostauxVilles(Map<String,Object> inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        system.debug('@@ SM_AP80 inputMap ' +inputMap);
        if ((inputMap.get('ville') == null || String.valueOf(inputMap.get('ville')).length() == 0) && (inputMap.get('codePostal') == null || String.valueOf(inputMap.get('codePostal')).length() == 0)) {
            system.debug('No input Data City ans ZipCode');
            return ;
        }

        String ville = null, codePostal = null;
        if (inputMap.get('ville') != null || String.valueOf(inputMap.get('ville')).length() > 0) {
            ville = String.valueOf(inputMap.get('ville'));
        }
        if (inputMap.get('codePostal') != null || String.valueOf(inputMap.get('codePostal')).length() > 0) {
            codePostal = String.valueOf(inputMap.get('codePostal'));
        }
        HttpResponse httpResponse = getResponse(ville, codePostal);
        system.debug('@@ httpResponse '+httpResponse);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());
        system.debug('@@ resultAsMap '+resultAsMap);
        List<Object> CodePostauxVilles = (List <Object> ) resultAsMap.get('_data');
        system.debug('@@ CodePostauxVilles '+CodePostauxVilles);
        if (CodePostauxVilles.Size() == 0) {
            system.debug('No data to get the city ' + inputMap.get('ville') + 'Or zipCode ' + inputMap.get('codePostal'));
            outMap.put('resultdata', new  List<Object>());
        }
       else{
            // List<Object> transformedData = transformDataToCard(contracts) ;
            outMap.put('resultdata', CodePostauxVilles);
            // outMap.put('nombreRythmeFacturation',transformedData.size() == 1 ? 'OK' :'NOK' ) ;
    
            
        }
        system.debug('### MGH :: ' + outMap);
        // return outMap;
    }

    public static HttpResponse getResponse(String ville, String codePostal) {
        String endpointParams = buildRequestParams(ville, codePostal);
        HttpResponse httpResp = CalloutManager.sendRequest('codesPostauxVilles', endpointParams, 'GET', CalloutManager.Scope.READ, null,null);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('## [codesPostaux ville] error occured when sending data ##');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            return null;
        }
        return httpResp;
    }

    public static String buildRequestParams(String ville, String codePostal) {
        String endpointParams = '';
        if(!String.isBlank(ville)){
            endpointParams += '?ville=' + ville + '&size=50';
        } else if (!String.isBlank(codePostal)){
            endpointParams += '?codePostal=' + codePostal + '&size=50';
        }
        return endpointParams;
    }

}