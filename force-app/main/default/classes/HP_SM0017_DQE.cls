/**
 * @File Name          : HP_SM0017_DQE.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 27/01/2020 à 17:59:27
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/01/2020   Mouhamadoune Coulibaly     Initial Version
**/ 
public with sharing class HP_SM0017_DQE {



	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 22/01/2020 
	* @param email 
	* @return Object 
	**/
   @AuraEnabled(cacheable=true)
	public static Object getEmailValidation(String email){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM0017_DQE.getEmailValidation(email)));
	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 22/01/2020 
	* @param telephone 
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object getTelephoneValidation(String telephone,String pays){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM0017_DQE.getTelephoneValidation(telephone,pays)));
	}
}