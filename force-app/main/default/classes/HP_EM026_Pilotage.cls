/**
 * @File Name          : HP_EM026_Pilotage.cls
 * @Description        : Data Manager spécifique aux échanges avec Pilotage
 * @Author             : Sara El-Hannaoui
 * @Group              :
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 14/02/2020 à 16:11:25
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    14/02/2020   Sara El-Hannaoui     Initial Version
 **/
public with sharing class HP_EM026_Pilotage {

	/**
	 * @description  permet de récupérer la liste des emails envoyée par Agilab
	 * @author Sara El-Hannaoui | 14/02/2020
	 * @param String startDate
	 * @param String closeDate
	 * @param String numberOfPgae
	 * @param String bpClient
	 * @param String consumer
	 * @return HP_WRP025_PilotageEmails
	 **/
 	public static HP_WRP025_PilotageEmails getEmails(String startDate, String closeDate, String bpClient, String consumer,String numOfPage){
		HP_WRP025_PilotageEmails output ;
		Map<String, Object> params = new Map<String, Object> {
			'application' => 'emailing',
			'dateDeb' => startDate,
			'dateFin' => closeDate,
			'statutEmail' => 'success',
			'numPage' => numOfPage,
			'limite' => '50', 
			'source' => bpClient,
			'consumer' => consumer
		};
		String body =  HP_ParseUtils.serialize(params);
		HTTPResponse httpResponse = HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.PILOTAGE_GET_EMAILS, body);
		output = (HP_WRP025_PilotageEmails) JSON.deserialize(httpResponse.getBody().replace('"date":', '"date_x":'), HP_WRP025_PilotageEmails.class);
		return output;
	} 

}