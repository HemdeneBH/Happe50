/**
 * @author Sara El-Hannaoui
 * @date Creation 12/12/2019
 * @description Service Manager spécifique aux échanges avec Tranquility
 */
public with sharing class HP_SM0016_Tranquility {


	/**
	 * @description Récupérer les contrats Tranquillity (card Service)
	 * @author Sara El-Hannaoui | 13/12/2019
	 * @param String bpClient
	 * @return Object
	 **/
	@AuraEnabled(cacheable=true)
	public static Object getContrat(Integer idPersonne){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM0016_Tranquility.getContrat(String.valueOf(idPersonne))));
	}

}