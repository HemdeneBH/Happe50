/**
 * @File Name          : HP_UTIL_Vue360ProcessProcessPFCID.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 30/04/2020 à 16:49:07
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_UTIL_Vue360ProcessProcessPFCID implements HP_UTIL_ApexVue360Interface {
    public static Object processing(Object param, Object rootParam) {
        Map<String, Object> mapParam = (Map<String, Object>)param;
        
        if(mapParam.get('data') == null) {
            return null;
        }
        mapParam = (Map<String, Object>)mapParam.get('data');
        List<Object> contratList = (List<Object>)mapParam.get('_data');
       
        if(contratList == null || contratList.size() == 0){
            return null;
        }
        Set<String> pfcIdList = new Set<String>();
        for(Object item : contratList) {
            Map<String, Object> cont = (Map<String, Object>) item;
            

            pfcIdList.add(String.valueOf(cont.get('idPortefeuilleContrat')));
        }

       
        return new Map<String, String>{'pfcIdList' => String.join(new List<String>(pfcIdList),',')};
    }
}