/**
 * @author Unknown
 * @date 06/04/2022 - Refactoring by Sutharsan Pushparajah
 * @description SM_AP29_PersonnesAPI - Controller class to access the Personnes API
 */
global with sharing class SM_AP29_PersonnesAPI implements vlocity_cmt.VlocityOpenInterface {
	
	/**
     * @author Sutharsan Pushparajah
     * @date 06/04/2022
     * @description PersonnesException - Custom Exception to fire message for Personnes API
     */
	public class PersonnesException extends Exception{}

	/**
     * @author Unknown
     * @date DD/MM/YYYY
     * @description PersonneModel - Wrapper class to store response from Personnes API
     */
	public class PersonneModel {
		public String id;
		public String idPersonneUnifie;
		public String idBusinessPartner;

		public PersonneModel(String id, String idPersonneUnifie, String idBusinessPartner ) {
			this.id = id;
			this.idPersonneUnifie = idPersonneUnifie;
			this.idBusinessPartner = idBusinessPartner;
		}
	}
	
	/**
     * @author Unknown
     * @date 06/04/2022
     * @description Expose Personnes API to IP
     * @param methodName the name of the method to call
     * @param inputMap Input parameters
	 * @param outMap results from API call
	 * @param options options parameters from IP
     * @return Boolean true if the call succeeds
     */
	global Boolean invokeMethod(String methodName, Map <String, Object> inputMap, Map <String, Object> outMap, Map <String, Object> options){

		try{
			if (methodName.equals('callPersonne')) {
				callPersonne(inputMap, outMap, options);
			} else if (methodName.equals('callPersonneApi')) {
				callPersonneApi(inputMap);
			}
		} catch (Exception exp) {
			APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP29_PersonnesAPI', 'callPersonneApi', exp.getMessage());
			return false;
		}

		return true;
	}

	/**
     * @author Unknown
     * @date 06/04/2022
     * @description Parse & format the identifiant business partner field 
     * @param idBusinessPartner the id of the personne
     * @return String formatted value of the input field
     */
	@TestVisible
	private static String formatIdentifiantBusinessPartner(String idBusinessPartner){
		
		Integer size;

		if (String.isEmpty(idBusinessPartner)) {
			throw new PersonnesException('idBusinessPartner is not found');
		}
		
		size = idBusinessPartner.length();

        if(size <10){
            Integer difference = 10 -size;

            for(Integer i = 0; i<difference; i++ ){
                idBusinessPartner = '0'+idBusinessPartner;
            }
        }

		return idBusinessPartner;
	}

	/**
     * @author Unknown
     * @date 06/04/2022
     * @description Search Personnes API V1
     * @param inputMap Input parameters
     * @return Map<String, Object> results from the Personnes API call
     */
	@AuraEnabled(cacheable=false)
    public static Map<String, Object> callPersonneApi(Map<String, Object> inputMap){
        
		try {
			String idContact = String.valueOf(inputMap.get('idContact'));
			//If no contact then it will go into the exception and return null
			Contact contact = SM_EM100_Contact.getByIds('Id, Identifiant_Buisness_Partener__c', new List<Id>{idContact}).get(0);
			
			String idBusinessPartner = formatIdentifiantBusinessPartner(contact.Identifiant_Buisness_Partener__c);
			
			List <Object> clientAccounts = SM_WS102_Personne.getPersonnes(idBusinessPartner, 'V1');

			return (clientAccounts.size() == 0) ? null : (Map <String, Object>) clientAccounts[0];
		} catch (Exception exp){
			APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP29_PersonnesAPI', 'callPersonneApi', exp.getMessage());
		}

		return null;
	}

	/**
     * @author Unknown
     * @date 06/04/2022
     * @description Search Personnes API V0
     * @param inputMap Input parameters
     * @return N/A
     */
	public static void callPersonne(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
		
		try {
			String idBusinessPartner = formatIdentifiantBusinessPartner(String.valueOf(inputMap.get('refClientIdBP')));

			List <Object> clientAccounts = SM_WS102_Personne.getPersonnes(idBusinessPartner, 'V0');

			if (clientAccounts.size() == 0) {
				throw new PersonnesException('No data to get the idBusinessPartner ' + idBusinessPartner);
			}
			// methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
			Map<String, Object> transformedData =  transformDatatoOmniscript(clientAccounts) ;
			outMap.put('personnes', transformedData);
		} catch (Exception exp){
			APU000_Logger.log(LoggingLevel.ERROR, 'SM_AP29_PersonnesAPI', 'callPersonneApi', exp.getMessage());
		}
	}

	/**
     * @author Unknown
     * @date 06/04/2022
     * @description Transform results from Personnes API into Custom PersonneModel wrapper 
     * @param apiData List of Personnes API call result
     * @return Map<String, Object> All Personne records returned by the Personnes API call into Custom PersonneModel wrapper 
     */
	public static Map<String, Object> transformDatatoOmniscript(List<Object> apiData){

		Map<String, Object> transformeDataStructure = new Map <String, Object>();
		List <Object> listTemp = new List<Object>();
		Integer i = 1;

		for (Object obj : apiData) {
			Map<String, Object> objectX = (Map<String, Object>) obj;
			PersonneModel personneValue = new PersonneModel(String.valueOf(objectX.get('id')), String.valueOf(objectX.get('idPersonneUnifiee')), String.valueOf(objectX.get('idBusinessPartner')));
			transformeDataStructure.put('personne'+i, personneValue);
			i++;
		}
		
		return transformeDataStructure ;
	}
}