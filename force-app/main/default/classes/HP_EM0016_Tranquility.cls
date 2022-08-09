/**
 * @author Sara El-Hannaoui
 * @date Creation 12/12/2019
 * @description Data Manager spécifique aux échanges avec Tranquility
 */
public with sharing class HP_EM0016_Tranquility  {

	private static final String ID_CONSOMATEUR = 'happe';

	public HP_EM0016_Tranquility(){
		
	}

	/**
	 * @description Récupérer les contrats Tranquillity (card Service)
	 * @author Sara El-Hannaoui | 24/12/2019
	 * @param String idPersonne
	 * @return HP_WRP0015_TranquilityContractInfo
	 **/
	public static HP_WRP0015_TranquilityContractInfo getContrat(String idPersonne){

		String body =  HP_ParseUtils.serialize(new HP_WRP0015_TranquilityContractInfo.TranquilityRequest(idPersonne,ID_CONSOMATEUR));

		Map<Integer, String> responseMap = HP_UTIL_HTTPUtils.calloutPostToMap(HP_Constantes.TRANQUILITY_GET_CONTRAT, body);
		System.debug('HP_WRP0015_TranquilityContractInfo.getContrat.responseMap : ' + JSON.serialize(responseMap));

		Map<String, Object> responseOK = (Map<String, Object>) System.JSON.deserializeUntyped(HP_HttpUtils.requestGetOutput(responseMap));

		String jsonStringtest = rebuildJSONResponse(responseOK);
		HP_WRP0015_TranquilityContractInfo myoutput = (HP_WRP0015_TranquilityContractInfo) JSON.deserialize(jsonStringtest,HP_WRP0015_TranquilityContractInfo.class);
		System.debug('HP_WRP0015_TranquilityContractInfo.getContrat.response.outputData : ' + JSON.serialize(myoutput));

		return myoutput;
	}


	/**
	 * @description Reconstruire la réponse pour fonctionner avec le Wrapper
	 * @author Sara El-Hannaoui | 24/12/2019
	 * @param Map<String Object> response
	 * @return String
	 **/
	public static String rebuildJSONResponse (Map<String,Object> response){
		Map<String, Object> responsefilterd = (Map<String, Object>) response.get('return');
		Map<String, Object> contratMap = (Map<String, Object>) responsefilterd.get('retour');
		Object messageRetour = responsefilterd.get('messageRetour');
		contratMap.put('messageRetour',messageRetour);
		String jsonRepsonse = HP_ParseUtils.serialize((Object) contratMap);
		return jsonRepsonse;
	}

}