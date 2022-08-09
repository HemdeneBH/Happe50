/**
 * @File Name          : HP_SM026_DistCreatePrestationGaz.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 26/03/2020 à 14:46:40
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_SM026_DistCreatePrestationGaz {//FIXME rename
	public static final String END_POINT_PRESTAGAS = 'ES-PrestationServiceGaz_v2';

	public static final String CREATE = 'CREER';
	public static final String OCTOPUS_GAS_PRESTATION_CODE = '200000';

	public static final String B2C_CUSTOMER_TYPE = 'RES';//RESIDENTIAL default value (no professional users)
	private static final String SMART_METER_PRESTATION_CODE = '12';
	private static final String BASIC_METER_KNOWN_INDEX_PRESTATION_CODE = '2';
	private static final String BASIC_METER_NO_INDEX_SWITCH_SUPLIER_PRESTATION_CODE = '3';
	private static final String BASIC_METER_NO_INDEX_MOVING_IN_PRESTATION_CODE = '9';
	private static final Boolean LEGACY_PRODUCT = false;
	//CHECK add param T1 si classe de conso gaz = B0 ou B1, T2 sinon // T1 si <= 6000kwh T2 si > nb B1  et B2i > 6000kwh//req.codeTarifAcheminement;
	private static final String HIGH_VOLUME_PRICING_CODE = 'T2';
	private static final String LOW_VOLUME_PRINCING_CODE = 'T1';
	private static final String HIGH_FREQUENCY = '1M';//MONTHLY?
	private static final String LOW_FREQUENCY = '6M';//PER 6 Month

	private enum SuccessResponse {
		OCTOPUS_CreerPrestationServiceGaz_01,
		OCTOPUS_CreerPrestationServiceGaz_02/* ,
		OCTOPUS_CreerPrestationServiceGaz_99 */
	}

	public static HP_EnergyContractResponse sendRequest(HP_EnergyContractRequest energyContractRequest, String enrolmentType, final HP_EnergyResponse energyResponse, final Boolean isKnownIndex) {//HP_OctopusGazInPutData.RequestToGRD req, Boolean isGazPar, Boolean isKhnownIndex){
		gdfsuezComBefChpPivotPrestaGaz.contextDt context = initContext2(HP_OctopusUtils.CONTEXT, HP_OctopusUtils.VERSION1);
		gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
		//gdfsuezBefCalypsoPrestaGaz.project = 'HP';
		port.endpoint_x = HP_OctopusUtils.END_POINT + END_POINT_PRESTAGAS;
		port.inputHttpHeaders_x = new Map<String, String> {HP_OctopusUtils.CONTENT_TYPE => HP_OctopusUtils.CHARSET};

		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_donneesGenerales_element donneesGenerales = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_donneesGenerales_element();
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt optionPrestation = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt codePrestation = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_dateRdv_element rdv =  new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_dateRdv_element();
		gdfsuezBefCalypsoPrestaGaz.contactCourrierDt contactCourrier = new gdfsuezBefCalypsoPrestaGaz.contactCourrierDt();
		gdfsuezBefCalypsoPrestaGaz.identiteContactDt identiteContact = new gdfsuezBefCalypsoPrestaGaz.identiteContactDt();
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt civiliteIdContact  = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		gdfsuezBefCalypsoPrestaGaz.coordonneesContactDt coordonneesContact = new gdfsuezBefCalypsoPrestaGaz.coordonneesContactDt();
		gdfsuezComBefChpCommunadressePrestaGaz.adresseCommunDt adressePostale = new gdfsuezComBefChpCommunadressePrestaGaz.adresseCommunDt();
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt pays = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt natureDemande = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt inputDt = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt();
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt action1 = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_contactIntervention_element contactIntervention = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_contactIntervention_element();
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_utilisateurFinal_element utilisateurFinal = new  gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_utilisateurFinal_element();// TODO
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt categorie = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();

		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_miseEnService_element miseEnService = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_miseEnService_element();
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_changementFournisseur_element changementFournisseur = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazInputDt_changementFournisseur_element();// TODO
		gdfsuezBefCalypsoPrestaGaz.CARDt consommationEstimee = new gdfsuezBefCalypsoPrestaGaz.CARDt();

		gdfsuezBefCalypsoPrestaGaz.indexDt indexClient = new gdfsuezBefCalypsoPrestaGaz.indexDt();
		//TODO MAp of listeValeursDt
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt frequenceReleve = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		gdfsuezComBefChpPivotPrestaGaz.listeValeursDt tarifAcheminement = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		action1.code = CREATE;
		natureDemande.code = enrolmentType == 'SWITCH_SUPLIER' ? 'CHF' : 'MES';//req.codeNatureDemande;
		donneesGenerales.codePrestation = codePrestation;
		codePrestation.code = OCTOPUS_GAS_PRESTATION_CODE;//req.codePrestation;
		optionPrestation.code = (
			(energyResponse.isSmartMeter)
			? (SMART_METER_PRESTATION_CODE)
			: (
				(isKnownIndex)
				? (BASIC_METER_KNOWN_INDEX_PRESTATION_CODE)
				: (
					(enrolmentType == 'SWITCH_SUPLIER')
					? (BASIC_METER_NO_INDEX_SWITCH_SUPLIER_PRESTATION_CODE)
					: (BASIC_METER_NO_INDEX_MOVING_IN_PRESTATION_CODE)
				)
			)
		);

		donneesGenerales.optionPrestation = optionPrestation;
		donneesGenerales.natureDemande = natureDemande;
        
        donneesGenerales.loginUtilisateur = HP_SLCT_User.retriveUser(System.UserInfo.getUserId()).Distributor_Login__c;
		if(donneesGenerales.loginUtilisateur == null || donneesGenerales.loginUtilisateur == '') {
			donneesGenerales.loginUtilisateur = HP_UTIL_MetadataManager.getConfigByKey('HP_LOGIN_GAZ');
		}

		donneesGenerales.idPDLGaz = energyContractRequest.energyMeterId;//req.idPdlGaz;
		rdv.date_x = ((DateTime)energyContractRequest.contractStartDate).format(HP_OctopusUtils.DATE_TIME_FORMAT);//req.dateRdv;//FXIME appropriate name DATE DEBUT CONTRAT

		pays.code = energyContractRequest.deliveryPointCountryISO2Code;//req.codePays;

		adressePostale.cP = energyContractRequest.deliveryPointPostalCode;//req.codePostal;
		adressePostale.libelleVoie = energyContractRequest.deliveryPointStreetName;//req.libelleVoie;
		adressePostale.ville = energyContractRequest.deliveryPointCity;//req.ville;
		adressePostale.pays = pays;

		civiliteIdContact.code = energyContractRequest.salutation;//req.codeCivilite;

		identiteContact.nom = energyContractRequest.customerLastName;//req.contactCourrierNom;
		identiteContact.prenom = energyContractRequest.customerFirstName;//req.identiteContactPrenom;
		identiteContact.civilite = civiliteIdContact;

		utilisateurFinal.nom = energyContractRequest.customerLastName;//req.contactCourrierNom;
		utilisateurFinal.prenom = energyContractRequest.customerFirstName;//req.identiteContactPrenom;
		utilisateurFinal.civilite = civiliteIdContact;
		categorie.code =  B2C_CUSTOMER_TYPE;//RESIDENTIAL default value (no professional users)
		utilisateurFinal.categorie = categorie;

		coordonneesContact.telephone = energyContractRequest.customerMainPhone;

		contactIntervention.identiteContact = identiteContact;
		contactIntervention.coordonneesContact = coordonneesContact;

		contactCourrier.identiteContact = identiteContact;
		contactCourrier.coordonneesContact = coordonneesContact;
		contactCourrier.adressePostale = adressePostale;

		tarifAcheminement.code = (((energyContractRequest.productType == 'HP_GAS_CLASS_B2I') || (energyContractRequest.productType == 'HP_GAS_CLASS_B1'))
			? (HIGH_VOLUME_PRICING_CODE)
			: (LOW_VOLUME_PRINCING_CODE)
		);
		frequenceReleve.code = ((energyResponse.isSmartMeter)? (HIGH_FREQUENCY) : (LOW_FREQUENCY));
		indexClient.dateIndex = ((energyContractRequest.gasMeterIndex != null) ? (System.Datetime.now().format(HP_OctopusUtils.DATE_TIME_FORMAT)) : (null));//req.dateIndex;
		indexClient.valeurIndex = String.valueOf(energyContractRequest.gasMeterIndex);//req.valeurIndex;
		consommationEstimee.valeurCAR = String.valueOf(energyContractRequest.estimatedConsumption);
		if (enrolmentType == 'SWITCH_SUPLIER') {
			changementFournisseur.tarifAcheminement = tarifAcheminement;
			changementFournisseur.frequenceReleve = frequenceReleve;
			changementFournisseur.offreHistorique = LEGACY_PRODUCT;
			changementFournisseur.CAR = consommationEstimee;
			if (isKnownIndex) {
				changementFournisseur.indexClient = indexClient;
			}
			inputDt.changementFournisseur = changementFournisseur;
		}
		else if (enrolmentType == 'MOVING_IN') {
			miseEnService.tarifAcheminement = tarifAcheminement;
			miseEnService.frequenceReleve = frequenceReleve;
			miseEnService.offreHistorique = LEGACY_PRODUCT;
			miseEnService.CAR = consommationEstimee;
			if (isKnownIndex) {
				miseEnService.indexClient = indexClient;
			}
			inputDt.miseEnService = miseEnService;
		}
		inputDt.utilisateurFinal = utilisateurFinal;
		inputDt.action = action1;
		inputDt.donneesGenerales = donneesGenerales;
		inputDt.dateRdv = rdv;
		inputDt.contactCourrier = contactCourrier;
		inputDt.contactIntervention = contactIntervention;
		gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazResponse_element response = port.CreerPrestationServiceGaz_Http(inputDt, context);
		System.debug(JSON.serializePretty(response, true));
		List<gdfsuezComBefChpPivot.retourTraitementMessageDt> msgList = response.messageRetours.retourTraitementMessage;
		if(!msgList.isEmpty()) {
			HP_EnergyContractResponse energyContractResponse = new  HP_EnergyContractResponse();
			gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazOutputDt gazOuput = response.creerPrestationServiceGazOutput;
			//energyContractResponse.code = msgList[0].code;
			//energyContractResponse.libelle = msgList[0].libelle;
			energyContractResponse.isSuccess = false;
			for (SuccessResponse successResponse : SuccessResponse.values()) {
				if (msgList[0].code == successResponse.name()) {
					energyContractResponse.isSuccess = true;
					energyContractResponse.prestationDistributorId = gazOuput.idPrestationServiceDistributeur;
					final String prestationDateTime = gazOuput.planificationIntervention.date_x;
					energyContractResponse.prestationDateTime = ((prestationDateTime != null) ? (((DateTime)Json.deserialize('"' + prestationDateTime + '"', DateTime.class))) : (null));
					break;
				}
			}
			return energyContractResponse;
		}
		return null;
	}

	public static gdfsuezComBefChpPivotPrestaGaz.contextDt initContext2(String application, String version) {
		// Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
		gdfsuezComBefChpPivotPrestaGaz.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotPrestaGaz.contextDt_systemPath_system_element();
		osource.systemId = application;
		gdfsuezComBefChpPivotPrestaGaz.contextDt octx = new gdfsuezComBefChpPivotPrestaGaz.contextDt();
		octx.version = version;
		//  octx.allowCache = false ;
		octx.systemPath = new gdfsuezComBefChpPivotPrestaGaz.contextDt_systemPath_element();
		octx.systemPath.system_x = new gdfsuezComBefChpPivotPrestaGaz.contextDt_systemPath_system_element[] {
			osource
		};
		return octx;
	}
}