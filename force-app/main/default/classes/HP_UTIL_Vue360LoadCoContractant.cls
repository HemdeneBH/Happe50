/**
 * @File Name          : HP_UTIL_Vue360LoadCoContractant.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 17/04/2020 à 11:39:29
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_UTIL_Vue360LoadCoContractant implements HP_UTIL_ApexVue360Interface {
    public static Object processing(Object param, Object rootParam) {
        System.System.debug('@@ rootParam ' +rootParam);
        
        Map<String, Object> mapParam = (Map<String, Object>)param;
        mapParam = (Map<String, Object>)+mapParam.get('data');
        List<Object> paramList = (List<Object>)+mapParam.get('_data');
        Map<String, Object> result = new Map<String, Object>();
        Map<Object, Object> rootParamMap = (Map<Object, Object>)rootParam;
        List<Object> rootParamList = (List<Object>)rootParamMap.get('pfcIdList');
        for(Object  item : paramList) {
            boolean exist = false;
            Map<String, Object> itemMap = (Map<String, Object>)item;
            for(Object id : rootParamList) {
                if(String.valueOf(itemMap.get('id')) == String.valueOf(id)) {
                    exist = true;
                    break;
                }
            }  
            if(!exist){
                continue;
            } 
            if(itemMap.get('idPersonneDivergentCocontractant') != null && String.valueOf(itemMap.get('idPersonneDivergentCocontractant')) != '0') {
                HTTPResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_PERSONNE,  '/'+itemMap.get('idPersonneDivergentCocontractant'));   
             
                if(response.getStatusCode() != 200) {
                    HP_UTIL_Vue360Manager.success = false;
                }
                result.put(String.valueOf(itemMap.get('id')), (Object)JSON.deserializeUntyped(response.getBody()));
            } else {
                result.put(String.valueOf(itemMap.get('id')), 'Pas de CoContractant');
            } 
        }
        return result;
    }
}