/**
 * @File Name          : HP_SM008_APIHour.cls
 * @Description        :  Service Manager spécifique aux échanges avec APIHour
 * @Author             : Sara El-Hannaoui
 * @Group              :
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 03-14-2022
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    08/01/2020   Sara El-Hannaoui     Initial Version
 **/
public with sharing class HP_SM008_APIHour {

	/**
	* @description Récuperer les zones de distributions API Zones Distributions
	* @author Sara El-Hannaoui | 14/01/2020 
	* @param String postalCode 
	* @param String cityCode 
	* @return List<Object> 
	**/
	@AuraEnabled(cacheable=true)
	public static List<HP_WRP008_APIHourZoneDistribution> getZonesDistributions(String postalCode, String cityCode){
		return HP_CALL001_XDATA.requestZonesDistributions(postalCode, cityCode);
	}
	
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 31/01/2020 
	* @param idXdata 
	* @param infoPersonne 
	* @return void 
	**/
	@AuraEnabled(cacheable=true)
	public static Integer  updatePersonne(String idXdata,String infoPersonne){
		System.debug(infoPersonne);
		return HP_CALL001_XDATA.updatePersonne(idXdata, infoPersonne);
	}

	/**
	* @description 
	* @author Sara El-Hannaoui | 25/03/2020 
	* @param String idXdata 
	* @return Object 
	**/
	@AuraEnabled(cacheable=true)
	public static Object  getPersonne(String idXdata){
		return HP_CALL001_XDATA.getPersonne(idXdata);
	}

	/**
	* @description Permet de remonter le code commune en se basant sur le couple(code postal, ville)
	* @author Sara El-Hannaoui | 07/02/2020 
	* @param String postalCode 
	* @return List<Object> 
	**/
	@AuraEnabled(cacheable=true)
	public static List<Object> getCommunes(String postalCode){
		return HP_CALL001_XDATA.getcommunes(postalCode);
	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @param idPersonne 
	* @return List<HP_WRP029_APIHourCoordonneesBancaires> 
	**/
	@AuraEnabled
	public static List<HP_WRP029_APIHourCoordonneesBancaires> getCoordonneesBancaires(String idPersonne){
		return HP_CALL001_XDATA.getCoordonneesBancaires(idPersonne);
		
	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @param clientId 
	* @return List<HP_WRP031_APIHourConsentements> 
	**/
	@AuraEnabled
	public static List<HP_WRP031_APIHourConsentements> getReponsesConsentement(Integer idPersonne){
		return HP_CALL001_XDATA.getReponsesConsentement(idPersonne);
		
	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 20/02/2020 
	* @return List<HP_WRP032_APIHourConsentementsQuestions> 
	**/
	@AuraEnabled
	public static List<HP_WRP032_APIHourConsentementsQuestions> getQuestionsConsentement(){
		return HP_CALL001_XDATA.getQuestionsConsentement();
		
	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 21/02/2020 
	* @param consentToSend 
	* @return List<Object> 
	**/
	@AuraEnabled
	public static List<Object> creerConsentement(String consentToSend) {
		return HP_CALL001_XDATA.creerConsentement(consentToSend);
	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 21/02/2020 
	* @param consentToSend 
	* @return List<Object> 
	**/
	@AuraEnabled(cacheable=true)
	public static List<Object> sendConsentResponses(String consentToSend) {
		return HP_CALL001_XDATA.sendConsentResponses(consentToSend);
	}

	
	/**
	* @description 
	* @author Sara El-Hannaoui | 05/05/2020 
	* @return List<HP_WRP036_APIHourCodeOffre> 
	**/
	public static List<HP_WRP036_APIHourCodeOffre> getCodeOffre() {
		return HP_CALL001_XDATA.getCodeOffre();
	}

	/**
	* @description Met à jour les champs d'un contrat dans XDATA
	* @author Antoine Latour | 28/08/2020 
	* @param id 
	* @param codeStatutCRM 
	* @param statut
	* @return Boolean 
	**/
	public static Boolean updateContratByResiliationBatch(String id, String codeStatutCRM, String statut, String dateFinValidite){
		Integer codeRetour = HP_CALL001_XDATA.updateContract(id, codeStatutCRM, statut, dateFinValidite);
		return codeRetour > = 200 && codeRetour < 400;
	}

	/**
	* @description Récupération d'un PDL dans XDATA par ID et energie 
	* @author Antoine Latour | 01-06-2021 
	* @param String idPDL 
	* @param Boolean elec 
	* @return Map<String, Object> 
	**/
	public static Map<String, Object> getPDL(String idPDL, Boolean elec) {
		return HP_CALL001_XDATA.getPDL(idPDL, elec);
	}

	/**
	* @description 
	* @author Badr Eddine Belkarchi | 14/03/2022
	* @param String contractPortfolioXdataId 
	* @return Object 
	**/
	@AuraEnabled(cacheable=true)
	public static Object getPorteFeuilleContratXdata(String contractPortfolioXdataId){
		return HP_CALL001_XDATA.getPorteFeuilleContratXdata(contractPortfolioXdataId);
	}
}