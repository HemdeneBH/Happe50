/**
 * @File Name          : HP_UTIL_Vue360ProcessTranquilityContrat.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 27/04/2020 à 09:32:47
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_UTIL_Vue360ProcessTranquilityContrat implements HP_UTIL_ApexVue360Interface {
    private static final String ID_CONSOMATEUR = 'happe';
    public static Object processing(Object param, Object rootParam) {
		
        Map<String, Object> mapParam = (Map<String, Object>)param;
        System.debug('@@@ tranq param : ' +mapParam.get('output'));
		mapParam = (Map<String, Object>)+mapParam.get('data');
		mapParam = (Map<String, Object>)+mapParam.get('output');
		String idPersonne = mapParam.get('id') != null ? String.valueOf(950000000 + Integer.valueOf(mapParam.get('id'))) : 'null';
		System.debug('@@@ IDPersone : ' +idPersonne);
		String body =  HP_ParseUtils.serialize(new HP_WRP0015_TranquilityContractInfo.TranquilityRequest(idPersonne,ID_CONSOMATEUR));
		
		Map<Integer, String> responseMap = HP_UTIL_HTTPUtils.calloutPostToMap(HP_Constantes.TRANQUILITY_GET_CONTRAT, body);
		System.debug('HP_WRP0015_TranquilityContractInfo.getContrat.responseMap : ' + JSON.serialize(responseMap));

		Map<String, Object> responseOK = (Map<String, Object>) System.JSON.deserializeUntyped(HP_HttpUtils.requestGetOutput(responseMap));

		String jsonStringtest = rebuildJSONResponse(responseOK);
		HP_WRP0015_TranquilityContractInfo myoutput = (HP_WRP0015_TranquilityContractInfo) JSON.deserialize(jsonStringtest,HP_WRP0015_TranquilityContractInfo.class);
		System.debug('HP_WRP0015_TranquilityContractInfo.getContrat.response.outputData : ' + JSON.serialize(myoutput));
		
		return myoutput;
    }

    public static String rebuildJSONResponse (Map<String,Object> response){
		Map<String, Object> responsefilterd = (Map<String, Object>) response.get('return');
		Map<String, Object> contratMap = (Map<String, Object>) responsefilterd.get('retour');
		Object messageRetour = responsefilterd.get('messageRetour');
		contratMap.put('messageRetour',messageRetour);
		String jsonRepsonse = HP_ParseUtils.serialize((Object) contratMap);
		return jsonRepsonse;
	}
}