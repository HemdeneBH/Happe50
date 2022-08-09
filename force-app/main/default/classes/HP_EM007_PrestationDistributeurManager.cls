/**
 * @File Name          : HP_EM007_PrestationDistributeurManager.cls
 * @Description        : class permet de gerer les prestations distributeur
 * @Author             : Slimene Belhaj Ali
 * @Group              : 
 * @Created On         : 10/01/2020
**/
public with sharing class HP_EM007_PrestationDistributeurManager {

	private static final String STATUS_IN_PROGRESS_API_NAME = 'En cours';

     /**
    * @description charger la prestation en fonction de priorité définie
    * @author Slimene Belhaj Ali | 10/01/2020
    * @param String numeroCompteur Xdata numero compteur
    * @return Prestation_distributeur__c 
    **/
    public static Prestation_distributeur__c loadPrestationDistrubuteurToCardService(String numeroCompteur) {
		System.debug('@@@@ param presta ss: ' + numeroCompteur);
        List<Prestation_distributeur__c> presDisList = [select Id, Date_de_prestation__c, Statut__c, Situation_de_vente__c, Secteur_activite__c , Numero_PDL_PCE__c
        from Prestation_distributeur__c where Numero_PDL_PCE__c = :numeroCompteur and Statut__c = 'En cours' order by CreatedDate desc];
        if(presDisList.size() > 0) {
            return presDisList.get(0);
        }
        presDisList = [select Id, Date_de_prestation__c, Statut__c, Situation_de_vente__c, Secteur_activite__c , Numero_PDL_PCE__c
        from Prestation_distributeur__c where Numero_PDL_PCE__c = :numeroCompteur and Statut__c = 'Terminé' order by CreatedDate desc];
        if(presDisList.size() > 0) {
            return presDisList.get(0);
        }

        presDisList = [select Id, Date_de_prestation__c, Statut__c, Situation_de_vente__c , Secteur_activite__c, Numero_PDL_PCE__c
        from Prestation_distributeur__c where Numero_PDL_PCE__c = :numeroCompteur and Statut__c = 'Annulé' order by CreatedDate desc];
        if(presDisList.size() > 0) {
            return presDisList.get(0);
        }

        return null;
	}

    public static Boolean isExistBussinessNum(String businessNum, String pdlPce){
		Boolean isExist = false;
		String queryPresta = 'SELECT Id, Numero_affaire_distributeur__c, Numero_PDL_PCE__c, Statut__c FROM Prestation_distributeur__c WHERE (Numero_affaire_distributeur__c = \''+businessNum+'\' OR Numero_PDL_PCE__c= \''+pdlPce+'\') AND Statut__c = \''+STATUS_IN_PROGRESS_API_NAME+'\'';
		List<Prestation_distributeur__c> prestaList = (List<Prestation_distributeur__c>)Database.query(queryPresta);
		System.debug(prestaList.isEmpty()+' Presta size Cancel==='+prestaList.size());
		isExist = prestaList.isEmpty();
		return isExist;
    }
	
	/**
	* @description 
	* @author Antoine Latour | 08-02-2021 
	* @param Set<String> idAffaireList 
	* @return List<Prestation_distributeur__c> 
	**/
	public static List<Prestation_distributeur__c> loadPrestationsDistributeurFromListIdAffaire(Set<String> idAffaireList) {
		if(idAffaireList != null && idAffaireList.size() > 0) {
			return [SELECT Id, Name, RecordTypeId, Case__c, Situation_de_vente__c, Numero_PDL_PCE__c ,
			Secteur_activite__c, Numero_affaire_distributeur__c, Telephone_intervention__c, Statut_dernier_jalon__c,
			 Nom_contact_d_intervention__c, Date_statut_prestation__c, Creneau__c, Prenom_contact_d_intervention__c,
			  Civilite_interlocuteur_intervention__c, Numero_dernier_jalon__c, Statut__c, Date_de_prestation__c,
			 Identifiant_ENGIE__c FROM Prestation_distributeur__c WHERE Numero_affaire_distributeur__c IN: idAffaireList];
		}
		return null;
	}

	/**
	* @description 
	* @author Antoine Latour | 08-02-2021 
	* @param List<Prestation_distributeur__c> prestaDistribToUpdate 
	* @return Database.SaveResult[] 
	**/
	public static Database.SaveResult[] updatePrestationsDistributeur(List<Prestation_distributeur__c> prestaDistribToUpdate) {
		Database.SaveResult[] srList ;
		if(!prestaDistribToUpdate.isEmpty()){
			srList  = Database.update(prestaDistribToUpdate, true);   
		}                 
		return srList;
	}

	/**
	* @description 
	* @author Badr Eddine Belkarchi | 03-03-2022
	* @param String numeroAffaire 
	* @return Prestation_distributeur__c 
	**/
	public static Prestation_distributeur__c loadPrestationDistributeur(String numeroAffaire) {
		try {
			List<Prestation_distributeur__c> prestations = [SELECT Id, Name, RecordTypeId, Numero_PDL_PCE__c, Statut__c, Numero_affaire_distributeur__c, Case__c FROM Prestation_distributeur__c WHERE Numero_affaire_distributeur__c = :numeroAffaire LIMIT 1];
			return prestations[0];
		} catch (Exception e) {
			return null;
		}
	}
}