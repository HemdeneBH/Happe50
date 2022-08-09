/**
 * @author Vincent Albiser
 * @date Creation 26/11/2019
 * @description Data Manager spécifique aux échanges avec Agilab
 */
public with sharing class HP_EM001_Agilab {
	/**
	 * @author Vincent Albiser
	 * @date Creation 26/11/2019
	 * @description Récupérer la grille tarifaire d'un contrat
	 * @param idContrat
	 * @param dateContrat
	 * @return Strucure de réponse d'une grille tarifaire
	 */
	public static HP_WRP001_AgilabGrillePrix getGrilleTarifaire(String idContrat, String dateContrat){

		//TEST DATA
		//  GAZ
		//idContrat = '282644';
		//dateContrat = '06/11/2019';
		//  ELEC
		//idContrat = '282533';
		//dateContrat = '22/10/2019';

		String resources = '/grille_pricings/getGrille?id_contrat_xdata='+idContrat+'&date_proposition='+dateContrat;
		String body = null;
		Map<Integer, String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_GRILLE_PRICINGS_GET, 'id_contrat_xdata='+idContrat+'&date_proposition='+dateContrat);
		System.debug('HP_EM001_Agilab.getGrille.responseMap : ' + JSON.serialize(responseMap));

		HP_WRP001_AgilabGrillePrix outputData = new HP_WRP001_AgilabGrillePrix(responseMap.get(200));
		outputData.transactionId = HP_UTIL_HTTPUtils.getTransactionId();
		//calcul de outputData.reductionEnCours
		Date debutContrat = Date.newinstance(Integer.ValueOf(dateContrat.substring(6, 10)), Integer.ValueOf(dateContrat.substring(3, 5)), Integer.ValueOf(dateContrat.substring(0, 2)));
		//System.debug('HP_EM001_Agilab.getGrille.response.outputData : ' + debutContrat + ' ' + JSON.serialize(outputData.periodes));
		Date dateDebutIntervalle = debutContrat;
		Date dateFinIntervalle;
		if(outputData != null && outputData.periodes != null) {
			for(HP_WRP001_AgilabGrillePrix.Periode p : outputData.periodes) {
				List<String> parametresDuree = p.duree.split(' ');
				Integer duree = Integer.valueOf(parametresDuree[0]);
				switch on parametresDuree[1] {
					when 'jours','jour' {
						dateFinIntervalle = dateDebutIntervalle.addDays(duree);
					}
					when 'mois' {
						dateFinIntervalle = dateDebutIntervalle.addMonths(duree);
					}
					when 'ans','an' {
						dateFinIntervalle = dateDebutIntervalle.addYears(duree);
					}
				}
				System.debug('Intervalle : ' + dateDebutIntervalle + ' ' + System.today() + ' ' +dateFinIntervalle);
				if(dateDebutIntervalle <= System.today() && System.today() < dateFinIntervalle) {
					outputData.reductionEnCours = p.reduction;
					break;
				}
				dateDebutIntervalle = dateFinIntervalle;
			}
		}

		System.debug('HP_EM001_Agilab.getGrille.response.outputData : ' + JSON.serialize(outputData));
		return outputData;
	}

	/**
	 * @author Vincent Albiser
	 * @date Creation 29/11/2019
	 * @description Récupérer les informations d'un contrat
	 * @param idContrat
	 * @return Strucure de réponse des infos de contrat Agilab
	 */
	public static HP_WRP002_AgilabContratInfo getContratInfo(String idContrat){

		//TEST DATA
		//  GAZ
		//idContrat = '282644';
		//  ELEC
		//idContrat = '282533';

		String resources = '/propositions/afficher_informations_contrat?id_contrat_xdata='+idContrat;
		String body = null;
		Map<Integer, String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_AFFICHIER_INFORMATION_CONTRAT, 'id_contrat_xdata='+idContrat);
		System.debug('HP_WRP002_AgilabContratInfo.getGrille.responseMap : ' + JSON.serialize(responseMap));

		HP_WRP002_AgilabContratInfo outputData =HP_WRP002_AgilabContratInfo.parse(responseMap.get(200));

		System.debug('HP_WRP002_AgilabContratInfo.getGrille.response.outputData : ' + JSON.serialize(outputData));
		return outputData;
	}

	/**
	* @description Permet de récupérer les informations concernant le statut d'un client aidé  API afficher_informations_aide 
	* @author Sara El-Hannaoui | 16/01/2020 
	* @param String personId 
	* @return HP_WRP013_AgilabClientInfo 
	**/
	public static HP_WRP013_AgilabClientInfo getClientInfo(String personId){
		System.debug('HP_EM001_Agilab.getClientInfo | Method Start');
		HP_WRP013_AgilabClientInfo outputData ;
		try {
			Map<Integer, String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_AFFICHIER_INFORMATION_AIDE, 'id_client_xdata=' + personId);
			System.debug('HP_EM001_Agilab.getClientInfo.responseMap : ' + JSON.serialize(responseMap));
			if(responseMap.containsKey(200)){
				Map<String,Object> resultMap = (Map<String,Object>) JSON.deserializeUntyped(responseMap.get(200));
				outputData = HP_WRP013_AgilabClientInfo.parseMap(resultMap);
			}else {
				throw new System.CalloutException('Appel en erreur à AGILAB');
			}
		} catch (Exception ex) {
			System.debug('HP_EM001_Agilab.getClientInfo | Exception : '+ ex.getMessage());
		}
		System.debug('HP_EM001_Agilab.getClientInfo.response.outputData : ' + JSON.serialize(outputData));
		System.debug('HP_EM001_Agilab.getClientInfo | Method Exit');
		return outputData;
	}

	public static Boolean setClientInfo(String informationAide){
		System.debug('HP_EM001_Agilab.setClientInfo | Method Start');
		HP_WRP045_InformationsAide informationAideWrapper = (HP_WRP045_InformationsAide)System.JSON.deserialize(informationAide, HP_WRP045_InformationsAide.class);
		String params = 'id_client_xdata='+informationAideWrapper.idClientXdata+'&id_contrat_xdata='+informationAideWrapper.idContratXdata+'&aide_used=true&date_de_debut_aide='+informationAideWrapper.dateDebutAide+'&date_de_fin_aide='+informationAideWrapper.dateFinAide+'&en_attente_dattribution_daide_sociale=false';
		HttpResponse response;
		try{
			response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_MODIFIER_INFORMATION_AIDE, params);
		}catch(Exception ex){
			System.debug('HP_EM001_Agilab.setClientInfo | Exception : '+ ex.getMessage());
		}
		System.debug('HP_EM001_Agilab.setClientInfo | Response Code : '+response.getStatusCode());
		System.debug('HP_EM001_Agilab.setClientInfo | Response : '+response.getBody());
		System.debug('HP_EM001_Agilab.setClientInfo | Method Exit');
		return (response.getStatusCode() == 200);
	}

	public static List<HP_WRP047_InformationsAideRelatedCases> getRelatedCases(String contactId){
		System.debug('HP_EM001_Agilab.getRelatedCases | Method Start');
		if(contactId == null){
			throw new AuraHandledException('le contact Id ne doit pas être null');
		}
		List<HP_WRP047_InformationsAideRelatedCases> relatedCases = new List<HP_WRP047_InformationsAideRelatedCases>();
		try {
			for(Case aCase : [SELECT Id, CaseNumber, toLabel(HP_Type__c), CreatedDate, toLabel(Status), SuppliedName, Subject from Case WHERE HP_Aide_Contact__c = :contactId AND HP_Type__c = :HP_Constantes.DOSSIER_AIDE AND HP_isHappe__c = true]){
				relatedCases.add(new HP_WRP047_InformationsAideRelatedCases(aCase));
			}
		} catch (Exception ex) {
			System.debug('HP_EM001_Agilab.getRelatedCases | Exception : '+ ex.getMessage());
		}
		System.debug('HP_EM001_Agilab.getRelatedCases | Method Exit');
		return relatedCases;
	}

	public static List<Case> getOpenRelatedCases(String contactId){
		System.debug('HP_EM001_Agilab.getOpenRelatedCases | Method Start');
		if(contactId == null){
			throw new AuraHandledException('le contact Id ne doit pas être null');
		}
		List<Case> openRelatedCases = new List<Case>();
		try {
			for(Case aCase : [SELECT Id, CaseNumber from Case WHERE HP_Aide_Contact__c = :contactId AND IsClosed != true AND HP_Type__c = :HP_Constantes.DOSSIER_AIDE AND HP_isHappe__c = true]){
				openRelatedCases.add(aCase);
			}
		} catch (Exception ex) {
			System.debug('HP_EM001_Agilab.getOpenRelatedCases | Exception : '+ ex.getMessage());
		}
		System.debug('HP_EM001_Agilab.getOpenRelatedCases | Method Exit');
		return openRelatedCases;
	}


	/**
	 * @description Récupérer l'id Agilab
	 * @author Sara El-Hannaoui | 24/12/2019
	 * @param String idPersonne
	 * @return HP_WRP004_AgilabPersonne
	 **/
	public static HP_WRP004_AgilabPersonne getPersonne(String idPersonne){
		String resources = '/personnes/show?id_client_xdata='+idPersonne;
		String body = null;
		Map<Integer, String> responseMap =HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_AFFICHIER_PERSONNE, 'id_client_xdata='+idPersonne);
		System.debug('HP_WRP004_AgilabPersonne.responseMap : ' + JSON.serialize(responseMap));
		HP_WRP004_AgilabPersonne outputData = (HP_WRP004_AgilabPersonne)HP_ParseUtils.parse(responseMap.get(200),HP_WRP004_AgilabPersonne.class);
		if (outputData != null) {
			outputData.functionalIdHandler();  // add functional id for API Tranquillity card Service
		}
		return outputData;
	}


	/**
	 * @description Récuperer les information sur les rembourcements
	 * @author Mouhamadoune Coulibaly | 17/12/2019
	 * @param idPortefeuilleContrat
	 * @return Strucure de réponse des infos de renboursements Agilab
	 **/
	public static HP_WRP004_AgilabRemboursement getRemboursement(String idPortefeuilleContrat){
		String param = 'id_portefeuille_contrat_xdata='+idPortefeuilleContrat+'&sort=date_creation,desc';// Ajout d'un filtre sure les remboutrsements on retour le plus recent
		String body = null;
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_VOIR_REMBOURSEMENT, param);
		System.debug('HP_WRP004_AgilabRemboursement.getRemboursement.responseMap : ' + JSON.serialize(responseMap));

		HP_WRP004_AgilabRemboursement outputData = (HP_WRP004_AgilabRemboursement)HP_ParseUtils.parse(responseMap.get(200),HP_WRP004_AgilabRemboursement.class);
		System.debug('HP_WRP002_AgilabContratInfo.getRemboursement.response.outputData : ' + JSON.serialize(outputData));
		return outputData;

	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 18/02/2020 
	* @param idContratXdata 
	* @return HP_WRP026_AgilabEcheance 
	**/
	public static HP_WRP026_AgilabEcheance getEcheance(Integer idContratXdata){
	
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_AFFICHER_ECHENACE_CONTRAT,'id_contrat_xdata='+idContratXdata );
		System.debug('HP_WRP026_AgilabEcheance.getEcheance.responseMap : ' + JSON.serialize(responseMap));

		// HP_WRP026_AgilabEcheance outputData = HP_WRP026_AgilabEcheance.parse(responseMap.get(200));
		HP_WRP026_AgilabEcheance outputData = (HP_WRP026_AgilabEcheance)HP_ParseUtils.parse(responseMap.get(200),HP_WRP026_AgilabEcheance.class);
		System.debug('HP_WRP026_AgilabEcheance.getEcheance.response.outputData : ' + JSON.serialize(outputData));
		return outputData;

	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 18/02/2020 
	* @param idClient 
	* @return HP_WRP027_AgilabSolde 
	**/
	public static HP_WRP027_AgilabSolde getSolde(Integer idClient){
	
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_SOLDE_EFFECTIF,'id_client_xdata='+idClient);
		System.debug('HP_WRP027_AgilabSolde.getEcheance.responseMap : ' + JSON.serialize(responseMap));

		// HP_WRP027_AgilabSolde outputData = HP_WRP027_AgilabSolde.parse(responseMap.get(200));
		HP_WRP027_AgilabSolde outputData = (HP_WRP027_AgilabSolde)HP_ParseUtils.parse(responseMap.get(200),HP_WRP027_AgilabSolde.class);
		System.debug('HP_WRP027_AgilabSolde.getEcheance.response.outputData : ' + JSON.serialize(outputData));
		return outputData;

	}
	/**
	* @description 
	* @author Mouhamadoune Coulibaly | 18/02/2020 
	* @param idClient 
	* @return HP_WRP028_AgilabFactures 
	**/
	public static HP_WRP028_AgilabFactures getFacture(Integer idPorteFueilleContrat){
	
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_PORTFEUILLE_CONTRACT_FACTURE,'id_portefeuille_contrat_xdata='+idPorteFueilleContrat);
		System.debug('HP_WRP028_AgilabFactures.getEcheance.responseMap : ' + JSON.serialize(responseMap));

		// HP_WRP028_AgilabFactures outputData = HP_WRP028_AgilabFactures.parse(responseMap.get(200));
		HP_WRP028_AgilabFactures outputData = (HP_WRP028_AgilabFactures)HP_ParseUtils.parse(responseMap.get(200),HP_WRP028_AgilabFactures.class);
		System.debug('HP_WRP028_AgilabFactures.getEcheance.response.outputData : ' + JSON.serialize(outputData));
		return outputData;

	}
	public static HP_WRP030_AgilabClientOffline getClienOffline(Integer idClient){
	
	Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_PERSONNE_CLIENT_OFFLINE, 'id_client_xdata='+idClient);
	System.debug('HP_WRP030_AgilabClientOffline.getClienOffline.responseMap : ' + JSON.serialize(responseMap));

	
	HP_WRP030_AgilabClientOffline outputData = HP_WRP030_AgilabClientOffline.parse(responseMap.get(200));

		System.debug('HP_WRP002_AgilabClientInfo.getGrille.response.outputData : ' + JSON.serialize(outputData));
		return outputData;

}
	
	/**
	* @description 
	* @author Badr Eddine Belkarchi | 13/03/2022
	* @param idContratXdata 
	* @return HP_WRP044_AgilabPaiements 
	**/
	public static HP_WRP044_AgilabPaiements getPaiement(Integer idContratXdata){
	
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_CONTRAT_PAIEMENT,'id_contrat_xdata='+idContratXdata);
		System.debug('HP_WRP044_AgilabPaiements.getPaiement.responseMap : ' + JSON.serialize(responseMap));

		// HP_WRP044_AgilabPaiements outputData = HP_WRP044_AgilabPaiements.parse(responseMap.get(200));
		try {
			HP_WRP044_AgilabPaiements outputData = (HP_WRP044_AgilabPaiements)HP_ParseUtils.parse(responseMap.get(200),HP_WRP044_AgilabPaiements.class);
			System.debug('HP_WRP044_AgilabPaiements.getPaiement.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		} catch(NullPointerException e) {
			HP_WRP044_AgilabPaiements outputData = (HP_WRP044_AgilabPaiements)HP_ParseUtils.parse(responseMap.get(422),HP_WRP044_AgilabPaiements.class);
			System.debug('HP_WRP044_AgilabPaiements.getPaiement.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		}

	}

	/**
	* @description 
	* @author Zaatouche Younes | 17/03/2022 
	* @param idPorteFueilleContrat 
	* @return HP_WRP049_AgilabPlansApurement 
	**/
	public static HP_WRP049_AgilabPlansApurement getPlansApurement(Integer idPorteFueilleContrat){

		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_VOIR_PLANS_APUREMENT,'id_portefeuille_contrat_xdata='+idPorteFueilleContrat);
		try{
			HP_WRP049_AgilabPlansApurement outputData = (HP_WRP049_AgilabPlansApurement)HP_ParseUtils.parse(responseMap.get(200),HP_WRP049_AgilabPlansApurement.class);
			System.debug('HP_WRP049_AgilabPlansApurement.getPlansApurement.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		} catch(NullPointerException e) {
			HP_WRP049_AgilabPlansApurement outputData = (HP_WRP049_AgilabPlansApurement)HP_ParseUtils.parse(responseMap.get(422),HP_WRP049_AgilabPlansApurement.class);
			System.debug('HP_WRP049_AgilabPlansApurement.getPlansApurement.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		}
	}

	/**
	* @description 
	* @author Badr Eddine Belkarchi | 21/03/2022 
	* @param idContratXdata 
	* @return HP_WRP051_AgilabAutoReleve 
	**/
	public static HP_WRP051_AgilabAutoReleve getAutoReleve(Integer idContratXdata){
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_AFFICHER_AUTO_RELEVE,'id_contrat_xdata='+idContratXdata);
		System.debug('HP_WRP051_AgilabAutoReleve.getAutoReleve.responseMap : ' + JSON.serialize(responseMap));

		try {
			HP_WRP051_AgilabAutoReleve outputData = HP_WRP051_AgilabAutoReleve.parse(responseMap.get(200));
			System.debug('HP_WRP051_AgilabAutoReleve.getAutoReleve.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		} catch(NullPointerException e) {
			HP_WRP051_AgilabAutoReleve outputData = HP_WRP051_AgilabAutoReleve.parse(responseMap.get(422));
			System.debug('HP_WRP051_AgilabAutoReleve.getAutoReleve.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		}
	}


	/**
	* @description 
	* @author Badr Eddine Belkarchi | 31/03/2022 
	* @param idContratXdata 
	* @param indexhc 
	* @param type_releve 
	* @return HP_WRP052_AgilabEnvoiIndexes 
	**/
	public static HP_WRP052_AgilabEnvoiIndexes agilabEnvoiIndexBase(Integer idContratXdata, Integer type_releve, Integer indexhc){
		String param = 'id_contrat_xdata='+idContratXdata+'&type_releve='+type_releve+'&indexhc='+indexhc+'';
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_ENVOI_INDEXES, param);
		System.debug('HP_WRP052_AgilabEnvoiIndexes.agilabEnvoiIndexBase.responseMap : ' + JSON.serialize(responseMap));

		try {
			HP_WRP052_AgilabEnvoiIndexes outputData = HP_WRP052_AgilabEnvoiIndexes.parse(responseMap.get(201));
			System.debug('HP_WRP052_AgilabEnvoiIndexes.agilabEnvoiIndexBase.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		} catch(NullPointerException e) {
			HP_WRP052_AgilabEnvoiIndexes outputData = HP_WRP052_AgilabEnvoiIndexes.parse(responseMap.get(422));
			System.debug('HP_WRP052_AgilabEnvoiIndexes.agilabEnvoiIndexBase.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		}
	}

	/**
	* @description 
	* @author Badr Eddine Belkarchi | 31/03/2022 
	* @param idContratXdata 
	* @param indexhc 
	* @param type_releve 
	* @return HP_WRP052_AgilabEnvoiIndexes 
	**/
	public static HP_WRP052_AgilabEnvoiIndexes agilabEnvoiIndexHPHC(Integer idContratXdata, Integer type_releve, Integer indexhc, Integer indexhp){
		String param = 'id_contrat_xdata='+idContratXdata+'&type_releve='+type_releve+'&indexhc='+indexhc+'&indexhp='+indexhp+'';
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_ENVOI_INDEXES, param);
		System.debug('HP_WRP052_AgilabEnvoiIndexes.agilabEnvoiIndexHPHC.responseMap : ' + JSON.serialize(responseMap));

		try {
			HP_WRP052_AgilabEnvoiIndexes outputData = HP_WRP052_AgilabEnvoiIndexes.parse(responseMap.get(201));
			System.debug('HP_WRP052_AgilabEnvoiIndexes.agilabEnvoiIndexHPHC.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		} catch(NullPointerException e) {
			HP_WRP052_AgilabEnvoiIndexes outputData = HP_WRP052_AgilabEnvoiIndexes.parse(responseMap.get(422));
			System.debug('HP_WRP052_AgilabEnvoiIndexes.agilabEnvoiIndexHPHC.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		}
	}
	/**
	* @description 
	* @author Badr Eddine Belkarchi | 20/07/2022
	* @param id_client_xdata 
	* @return HP_WRP053_AgilabCoTitulaires 
	**/
	public static HP_WRP053_AgilabCoTitulaires getCoTitulaires(Integer id_client_xdata){	
		Map<Integer,String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_CO_TITULAIRES,'id_client_xdata='+id_client_xdata);
		System.debug('HP_WRP053_AgilabCoTitulaires.getCoTitulaires.responseMap : ' + JSON.serialize(responseMap));

		try {
			HP_WRP053_AgilabCoTitulaires outputData = HP_WRP053_AgilabCoTitulaires.parse(responseMap.get(200));
			System.debug('HP_WRP053_AgilabCoTitulaires.getCoTitulaires.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		} catch(NullPointerException e) {
			HP_WRP053_AgilabCoTitulaires outputData = HP_WRP053_AgilabCoTitulaires.parse(responseMap.get(422));
			System.debug('HP_WRP053_AgilabCoTitulaires.getCoTitulaires.response.outputData : ' + JSON.serialize(outputData));
			return outputData;
		}
	}
}