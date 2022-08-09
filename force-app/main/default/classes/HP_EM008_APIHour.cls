/**
 * @File Name          : HP_EM008_APIHour.cls
 * @Description        : Data Manager spécifique aux échanges avec APIHour 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    08/01/2020   Sara El-Hannaoui     Initial Version
 **/
public with sharing class HP_EM008_APIHour  {

	/**
	* @description Récupérer les zones de distributions API Zones distributions
	* @author Sara El-Hannaoui | 14/01/2020 
	* @param String postCode 
	* @param String cityCode 
	* @return List<HP_WRP008_APIHourZoneDistribution> 
	**/
	public static List<HP_WRP008_APIHourZoneDistribution> requestZonesDistributions(String postCode, String cityCode){
		//TEST DATA
		//  FIXME
		HP_EM008_APIHour emAPIHour = new HP_EM008_APIHour();
		Map<String, String> params= new Map<String, String> {'codePostal' => postCode, 'codeInsee' => cityCode};
		String body = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_ZONE_DISTRIBUTION, '?codePostal=' + postCode + '&codeInsee=' + cityCode).getBody();
		Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(body);
		List<Object> listresponse = (List<Object>) resultAsMap.get('_data');
		List<HP_WRP008_APIHourZoneDistribution> result = (List<HP_WRP008_APIHourZoneDistribution>)HP_ParseUtils.convert(listresponse,List<HP_WRP008_APIHourZoneDistribution>.class );

		return result;

	}
	public static Integer updatePersonne(String idXdata,String infoPersonne){

		HTTPResponse response= HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_PERSONNE, infoPersonne, '/'+idXdata);
		return response.getStatusCode();
		// System.debug('UPDATE: '+res);

	}

	/**
	* @description API Personne de XDATA 
	* @author Sara El-Hannaoui | 25/03/2020 
	* @param String idXdata 
	* @return Object 
	**/
	public static Object getPersonne(String idXdata){
		HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_PERSONNE, '/' + idXdata);
		System.debug('httpResponse: '+response);
		System.debug('data: '+ response.getBody());
        if (response.getStatusCode() == HP_HttpStatus.OK) {
            return (Object)JSON.deserializeUntyped(response.getBody());
        }
        return null;
	}


	/**
	 * @description Permet de remonter le code commune en se basant sur le couple(code postal, ville)
	 * @author Sara El-Hannaoui | 03/02/2020
	 * @param String postCode
	 * @return void
	 **/
	public static List<Object> getCommunes(String postalCode){
		List<Object> communes;
		Map<String, String> parameters = new Map<String, String> {'codePostal' => postalCode };
		HTTPResponse httpResponse = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_CODEPOSTAUX_VILLES, parameters);
		if (httpResponse.getStatusCode() == HP_HttpStatus.OK) {
			Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
			communes = (List<Object>) results.get('_data');
		}
		return communes;
	}

	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @param idPersonne 
	* @return List<HP_WRP029_APIHourCoordonneesBancaires> 
	**/
	public static List<HP_WRP029_APIHourCoordonneesBancaires> getCoordonneesBancaires(String idPersonne){

		String body = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_COORDONNEES_BANCAIRES, '?idPersonne='+ idPersonne).getBody();
		Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(body);
		List<Object> listresponse = (List<Object>) resultAsMap.get('_data');
		List<HP_WRP029_APIHourCoordonneesBancaires> result = (List<HP_WRP029_APIHourCoordonneesBancaires>)HP_ParseUtils.convert(listresponse,List<HP_WRP029_APIHourCoordonneesBancaires>.class );

		return result;

	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @param clientId 
	* @return List<HP_WRP031_APIHourConsentements> 
	**/
	public static List<HP_WRP031_APIHourConsentements> getReponsesConsentement(Integer idPersonne){

		String body = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_CONSENTEMENTS, '?idPersonne='+idPersonne).getBody();
		Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(body);
		List<Object> listresponse = (List<Object>) resultAsMap.get('_data');
		List<HP_WRP031_APIHourConsentements> result = (List<HP_WRP031_APIHourConsentements>)HP_ParseUtils.convert(listresponse,List<HP_WRP031_APIHourConsentements>.class );

		return result;

}	
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @param consentList 
	* @return void 
	**/
	public static void sendConsent(final List<HP_WRP031_APIHourConsentements.HP_Consentements> consentList) {
		System.debug('consentList=====>: '+consentList);
		for (HP_WRP031_APIHourConsentements.HP_Consentements consent : consentList) {
			System.debug('+=========>>'+ new HP_WRP031_APIHourConsentements(consent));
			HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.XDATA_CONSENTEMENTS, JSON.serialize(new HP_WRP031_APIHourConsentements(consent)));
		}
	} 
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @param consentList 
	* @return void 
	**/
 	public static void updateConsent(final List<HP_WRP031_APIHourConsentements.HP_Consentements> consentList,final List<HP_WRP033_APIHourConsentementsPost.HP_ConsentementsPost> consentListPost) {
		
		for (HP_WRP031_APIHourConsentements.HP_Consentements consent : consentList) {
				System.debug('Service consentId: '+consent.id);
				System.debug('consent: '+consent);
				System.debug('new HP_WRP031_APIHourConsentements(consent): '+new HP_WRP031_APIHourConsentements(consent));
				HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_CONSENTEMENTS, JSON.serialize(new HP_WRP031_APIHourConsentements(consent)), '/' + consent.id);
		
		}
		for (HP_WRP033_APIHourConsentementsPost.HP_ConsentementsPost consent : consentListPost) {
				System.debug('consent: '+consent);
				System.debug('new HP_WRP033_APIHourConsentementsPost(consent): '+new HP_WRP033_APIHourConsentementsPost(consent));
				HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.XDATA_CONSENTEMENTS, JSON.serialize(new HP_WRP033_APIHourConsentementsPost(consent)));
				
		}
	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @param consentToSend 
	* @return List<Object> 
	**/
	 public static List<Object> creerConsentement(String consentToSend) {
		System.debug('creerConsentement');
		List<Object> listTosend = (List<Object>)JSON.deserializeUntyped(consentToSend);
		System.debug('listTosend: '+listTosend);
		final List<HP_WRP031_APIHourConsentements.HP_Consentements> consentList = new List<HP_WRP031_APIHourConsentements.HP_Consentements>();
		for (Object consentObj : listTosend) {
			System.debug('consentObj: '+consentObj);

			Map<String, Object> consentMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(consentObj));
			consentList.add(
			new HP_WRP031_APIHourConsentements.HP_Consentements(
			(Integer)consentMap.get('idPersonne'),
			(Integer)consentMap.get('idQuestionnaire'),
			(Integer)consentMap.get('idQuestion'),
			(Boolean)consentMap.get('consent'),
			(String)consentMap.get('canal'),
			(String)consentMap.get('application')));
		}
		System.debug('consentList: '+consentList);
		HP_EM008_APIHour.sendConsent(consentList);
		return listTosend;
	} 
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @param consentToSend 
	* @return List<Object> 
	**/
 	public static List<Object> sendConsentResponses(String consentToSend) {
		 System.debug('@@ consentToSend ' + consentToSend);
		List<Object> listTosend = (List<Object>)JSON.deserializeUntyped(consentToSend);
		final List<HP_WRP031_APIHourConsentements.HP_Consentements> consentList = new List<HP_WRP031_APIHourConsentements.HP_Consentements>();
		final List<HP_WRP033_APIHourConsentementsPost.HP_ConsentementsPost> consentListPost = new List<HP_WRP033_APIHourConsentementsPost.HP_ConsentementsPost>();
		for (Object consentObj : listTosend) {
			Map<String, Object> consentMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(consentObj));
				if(String.isNotBlank((String)consentMap.get('id'))){
					consentList.add(new HP_WRP031_APIHourConsentements.HP_Consentements(
						(String)consentMap.get('id'),
						(Integer)consentMap.get('idPersonne'),
						(Integer)consentMap.get('idQuestionnaire'),
						(Integer)consentMap.get('idQuestion'),
						(Boolean)consentMap.get('consent'),
						(String)consentMap.get('canal'),
						(String)consentMap.get('application')));
				}	else{
					consentListPost.add(
							new HP_WRP033_APIHourConsentementsPost.HP_ConsentementsPost(
							(Integer)consentMap.get('idPersonne'),
							(Integer)consentMap.get('idQuestionnaire'),
							(Integer)consentMap.get('idQuestion'),
							(Boolean)consentMap.get('consent'),
							(String)consentMap.get('canal'),
							(String)consentMap.get('application')));
					}
		}
		HP_EM008_APIHour.updateConsent(consentList,consentListPost);
		return listTosend;
	} 


	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @return List<HP_WRP032_APIHourConsentementsQuestions> 
	**/
	public static List<HP_WRP032_APIHourConsentementsQuestions> getQuestionsConsentement(){

		String body = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_QUESTION_CONSENTEMENT, '?idQuestionnaire=1').getBody();
		Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(body);
		List<Object> listresponse = (List<Object>) resultAsMap.get('_data');
		List<HP_WRP032_APIHourConsentementsQuestions> result = (List<HP_WRP032_APIHourConsentementsQuestions>)HP_ParseUtils.convert(listresponse,List<HP_WRP032_APIHourConsentementsQuestions>.class );

		return result;
		
	}

	
	/**
	* @description récupére les offres disponibles pour happ-e dans xdata
	* @author Sara El-Hannaoui | 05/05/2020 
	* @return List<HP_WRP036_APIHourCodeOffre> 
	**/
	public static List<HP_WRP036_APIHourCodeOffre> getCodeOffre(){
		String body = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_CODE_OFFRE, new Map<String, String>{'codeMarque' => 'HAP'}).getBody();
		Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(body);
		List<Object> listresponse = (List<Object>) resultAsMap.get('_data');
		List<HP_WRP036_APIHourCodeOffre> result = (List<HP_WRP036_APIHourCodeOffre>)HP_ParseUtils.convert(listresponse,List<HP_WRP036_APIHourCodeOffre>.class);
		return result;
	}

	/**
	* @description met à jour les champs codeStatutCRM et Statut d'un contrat dans Xdata
	* @author Antoine Latour | 28/08/2020 
	* @return Integer 
	**/
	public static Integer updateContract(String id, String codeStatutCRM, String statut) {
		String bodyString = System.JSON.serialize(new HP_ContractToUpdate(codeStatutCRM, statut));
		HTTPResponse response = HP_UTIL_HTTPUtils.calloutPut(HP_Constantes.XDATA_CONTRATS, bodyString, '/' + id);
		return response.getStatusCode();
	}
}