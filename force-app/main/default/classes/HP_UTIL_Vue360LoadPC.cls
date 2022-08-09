/**
 * @File Name          : HP_UTIL_Vue360LoadPC.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 10/06/2020 à 10:36:13
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_UTIL_Vue360LoadPC implements HP_UTIL_ApexVue360Interface {
    public static  Object processing(Object param, Object rootParam) {
        Map<String, Object> mapParam = (Map<String, Object>)param;
        if(mapParam.get('data') == null) {
            return null;
        }
        mapParam = (Map<String, Object>)mapParam.get('data');
        List<Object> contratList = (List<Object>)mapParam.get('_data');
        Map<String, Object> result = new Map<String, Object>();
    
        for(Object item : contratList) {
           
            Map<String, Object> cont = (Map<String, Object>) item;
            String status = String.valueOf(cont.get('codeStatutCrm'));
            if(status == 'H0105' || status == 'H0101' || status == 'H0102' || status == 'E0004' || status == 'E0007') {
                continue;
            }
            HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_PROPOSITIONS_COMMERCIALES, '/' + cont.get('idPropositionCommerciale'));
            result.put(String.valueOf(cont.get('id')), (Object)JSON.deserializeUntyped(response.getBody()));
        
        }

        return result;
    }
}