/**
 * @author Vincent Albiser
 * @date Creation 28/11/2019
 * @description Service Manager spécifique aux échanges avec Agilab
 */
public without sharing class HP_SM001_Agilab {

    /**
    * @author Vincent Albiser
    * @date Creation 28/11/2019
    * @description Récupérer la grille tarifaire d'un contrat
    * @param idContrat
    * @param dateContrat
    * @return Strucure de réponse d'une grille tarifaire : HP_WRP001_AgilabGrillePrix
    */
    @AuraEnabled(cacheable=true)
    public static Object getGrilleTarifaire(String idContrat, String dateContrat){
        try {
            return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getGrilleTarifaire(idContrat, dateContrat)));
        } catch(Exception e) {
            return new Map<String, Object>{'error' => true,'errorMessage' =>e.getMessage(),'stack' =>e.getStackTraceString(),'type' => e.getTypeName(),'transactionId' => HP_UTIL_HTTPUtils.getTransactionId()};
        }
        
    }

    /**
    * @author Vincent Albiser
    * @date Creation 29/11/2019
    * @description Récupérer les informations d'un contrat
    * @param idContrat
    * @return Strucure de réponse des infos de contrat Agilab
    */
    @AuraEnabled(cacheable=true)
    public static Object getContratInfo(String idContrat){
        return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getContratInfo(idContrat)));
    }
    /**
    * @description 
    * @author Mouhamadoune Coulibaly | 14/02/2020 
    * @param personId 
    * @return Object 
    **/
    @AuraEnabled(cacheable=true)
    public static Object getClientInfo(String personId){
        return (Object)JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getClientInfo(personId)));
    }

    @AuraEnabled(cacheable=true)
    public static Boolean setClientInfo(String informationAide){
        return HP_EM001_Agilab.setClientInfo(informationAide);
    }

    @AuraEnabled(cacheable=true)
    public static List<HP_WRP047_InformationsAideRelatedCases> getRelatedCases(String contactId){
        return HP_EM001_Agilab.getRelatedCases(contactId);
    }

    @AuraEnabled
    public static List<Case> getOpenRelatedCases(String contactId){
        return HP_EM001_Agilab.getOpenRelatedCases(contactId); 
    }
    

 
    /**
    * @description Récuperer les information sur les rembourcements
    * @author Mouhamadoune Coulibaly | 17/12/2019 
    * @param idPortefeuilleContrat 
    * @return Strucure de réponse des infos de renboursements Agilab 
    **/
    @AuraEnabled(cacheable=true)
    public static Object getRemboursement(String idPortefeuilleContrat){

        return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getRemboursement(idPortefeuilleContrat)));
    }

    /**
	 * @description Récupérer l'id Agilab
	 * @author Sara El-Hannaoui | 24/12/2019
	 * @param Integer idPersonne
	 * @return Object
	 **/
	@AuraEnabled(cacheable=true)
	public static Object getPersonne(Integer idPersonne){

		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getPersonne(String.valueOf(idPersonne))));
    }
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 18/02/2020 
	* @param idContratXdata 
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object getEcheance(Integer idContratXdata){

		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getEcheance(idContratXdata)));
    }
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 18/02/2020 
	* @param idContratXdata 
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object getSolde(Integer idClient){

		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getSolde(idClient)));
    }
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 18/02/2020 
	* @param idPfContrat 
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object getFacture(Integer idPorteFueilleContrat){

		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getFacture(idPorteFueilleContrat)));
	}

    @AuraEnabled(cacheable=true)
	public static Object getClienOffline(Integer idClient){

		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getClienOffline(idClient)));
	}

    /**
	* @description 
	* @author Badr Eddine Belkarchi | 13/03/2022
	* @param idContratXdata 
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object getPaiement(Integer idContratXdata){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getPaiement(idContratXdata)));
	}

    @AuraEnabled(cacheable=true)
	public static Object getPlansApurement(Integer idPorteFueilleContrat){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getPlansApurement(idPorteFueilleContrat)));
	}

    /**
	* @description 
	* @author Badr Eddine Belkarchi | 21/03/2022 
	* @param idContratXdata 
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object getAutoReleve(Integer idContratXdata){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getAutoReleve(idContratXdata)));
	}

    /**
	* @description 
	* @author Badr Eddine Belkarchi | 31/03/2022  
	* @param idContratXdata 
    * @param type_releve 
    * @param indexhc 
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object agilabEnvoiIndexBase(Integer idContratXdata, Integer type_releve, Integer indexhc){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.agilabEnvoiIndexBase(idContratXdata,type_releve,indexhc)));
	}

    /**
	* @description 
	* @author Badr Eddine Belkarchi | 31/03/2022 
	* @param idContratXdata
    * @param type_releve 
    * @param indexhc
    * @param indexhp
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object agilabEnvoiIndexHPHC(Integer idContratXdata, Integer type_releve, Integer indexhc, Integer indexhp){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.agilabEnvoiIndexHPHC(idContratXdata,type_releve,indexhc,indexhp)));
	}

    /**
	* @description récupère la liste des documents  dans Agilab par rapport à son ID XDATA
	* @author Clément Bauny | 21-04-2022 
	* @param String idXdataPersonne 
	* @return Object
	**/
	public static Object getDocumentsAgilab(String idPortfolio) {
		Object data = null;
		HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_DOCUMENTS, 'id_portefeuille_contrat_xdata=' + idPortfolio);
		if (response.getStatusCode() == HP_HttpStatus.OK) {
			data = (Object)JSON.deserializeUntyped(response.getBody());
		}
		return data;
    }	

    /**
	* @description 
	* @author Badr Eddine Belkarchi | 20/07/2022 
	* @param id_client_xdata 
	* @return Object 
	**/
    @AuraEnabled(cacheable=true)
	public static Object getCoTitulaires(Integer id_client_xdata){
		return (Object) JSON.deserializeUntyped(JSON.serialize(HP_EM001_Agilab.getCoTitulaires(id_client_xdata)));
	}
}