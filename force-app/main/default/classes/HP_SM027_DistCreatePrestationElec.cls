/**
 * @File Name          : HP_SM027_DistCreatePrestationElec.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 03-14-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_SM027_DistCreatePrestationElec {

	private final static String INDEX_UNIT = 'kWh';
	private static final String UNITE_PUISSANCE_MAXIMUM_SOUSCRITE = 'kVA';
	private static final String END_POINT_PRESTAELEC = 'ES-PrestationServiceElec_v3';


	private enum OctopusIndexType {
		HP,
		HC,
		Base
	}

	private static final Map<String, Set<String> > OCTOPUS_INDEX_TYPE_SET_BY_PRICING_PLAN = new Map<String, Set<String> > {
		'BASE' => new Set<String> {'Base'},
		'VARIABLE' => new Set<String> {'HP', 'HC'}
	};


	public static HP_EnergyContractResponse sendRequest(HP_EnergyContractRequest energyContractRequest, String enrolmentType, final HP_EnergyResponse energyResponse /* null for elec */, final Boolean isKhnownIndex /* null for elec */){
		gdfsuezComBefChpPSEPivot.contextDt context = (gdfsuezComBefChpPSEPivot.contextDt)HP_OctopusUtils.buildContext(HP_OctopusUtils.CONTEXT, HP_OctopusUtils.VERSION1, gdfsuezComBefChpPSEPivot.contextDt.class);
		gdfsuezBefCalypsoPrestationServiceElec.Dependency port =
			(gdfsuezBefCalypsoPrestationServiceElec.Dependency)HP_OctopusUtils.buildPort(END_POINT_PRESTAELEC, gdfsuezBefCalypsoPrestationServiceElec.Dependency.class);
		//gdfsuezBefCalypsoPrestationServiceElec.project = 'HP';
		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt inputDt = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt();

		// DONNEES GENERALES
		inputDt.donneesGenerales = new  gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_donneesGenerales_element();
		inputDt.donneesGenerales.natureDemande = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		//inputDt.donneesGenerales.natureDemande.code =  enrolmentType == 'SWITCH_SUPLIER' ? 'CFN' : enrolmentType == 'MOVING_IN' ? 'MES' : enrolmentType == 'REDUCTION'? 'RPI' : 'SAI';
		inputDt.donneesGenerales.loginUtilisateur = HP_SLCT_User.retriveUser(System.UserInfo.getUserId()).Distributor_Login__c;
		
		if(inputDt.donneesGenerales.loginUtilisateur == null || inputDt.donneesGenerales.loginUtilisateur == '') {
			inputDt.donneesGenerales.loginUtilisateur = HP_UTIL_MetadataManager.getConfigByKey('HP_LOGIN_ELEC');
		}
		
		inputDt.donneesGenerales.idPDLElectricite = energyContractRequest.energyMeterId;
		inputDt.donneesGenerales.dateEffetSouhaitee = (enrolmentType == 'REDUCTION' || enrolmentType == 'COUPURE') ? (Datetime.now().addDays(1)).format(HP_OctopusUtils.DATE_TIME_FORMAT) : ((DateTime)energyContractRequest.contractStartDate).format(HP_OctopusUtils.DATE_TIME_FORMAT);
		inputDt.donneesGenerales.idPersonne = energyContractRequest.personId;

		inputDt.donneesGenerales.idPrestationServiceFournisseurRegroupement = '3';
		
		// CLIENT FINAL
		inputDt.clientFinal = new   gdfsuezBefCalypsoPrestationServiceElec.clientFinalDt();
		inputDt.clientFinal.personnePhysique = new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
		inputDt.clientFinal.personnePhysique.civilite = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		inputDt.clientFinal.personnePhysique.civilite.code = energyContractRequest.salutation;
		inputDt.clientFinal.personnePhysique.nom = energyContractRequest.customerLastName;
		inputDt.clientFinal.personnePhysique.prenom = energyContractRequest.customerFirstName;
		inputDt.clientFinal.coordonneesContact = new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
		inputDt.clientFinal.coordonneesContact.telephone = new List<String> {energyContractRequest.customerMainPhone};
		inputDt.clientFinal.adressePostale = new gdfsuezComBefChpPSECommunadresse.adresseCommunDt();
		inputDt.clientFinal.adressePostale.cP = energyContractRequest.deliveryPointPostalCode;
		inputDt.clientFinal.adressePostale.libelleVoie = energyContractRequest.deliveryPointStreetName;
		inputDt.clientFinal.adressePostale.nVoie = energyContractRequest.deliveryPointStreetNumber;
		inputDt.clientFinal.adressePostale.pays = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		inputDt.clientFinal.adressePostale.pays.code = energyContractRequest.deliveryPointCountryISO2Code;
		inputDt.clientFinal.adressePostale.ville = energyContractRequest.deliveryPointCity;
		inputDt.clientFinal.residencePrincipale = true;
		//PLANIFICATIONEXPRESSSOUHAITEE
		if(enrolmentType == 'SWITCH_SUPLIER' || enrolmentType == 'MOVING_IN'){
			inputDt.planificationExpressSouhaitee = false;
			fillStructureTarifaire(inputDt, energyContractRequest);
			// fillAutoreleve(inputDt, energyContractRequest);
			if(energyResponse.isSmartMeter) {
				inputDt.autoReleve = null;
			} else {
				fillAutoreleve(inputDt, energyContractRequest);
			}
		}
		

		// MISE EN SERVICE OU CHANGEMENTFOURNISSEUR
		if (enrolmentType == 'SWITCH_SUPLIER') {
			inputDt.donneesGenerales.natureDemande.code = 'CFN';
			inputDt.changementFournisseur = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_changementFournisseur_element();
			inputDt.changementFournisseur.releveSpecial = false;
			inputDt.changementFournisseur.correction = false;
			inputDt.changementFournisseur.serviceCalendrierFournisseur = false;
		}
		else if(enrolmentType == 'MOVING_IN'){
			inputDt.donneesGenerales.natureDemande.code = 'MES';
			inputDt.miseEnService = new  gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_miseEnService_element();
			inputDt.miseEnService.urgent = false;
			inputDt.miseEnService.releveSpecial = false;
			inputDt.miseEnService.correction = false;
			inputDt.miseEnService.serviceCalendrierFournisseur = false;
		}else if(enrolmentType == 'REDUCTION'){
			inputDt.donneesGenerales.natureDemande.code = 'RPI';
			inputDt.interlocuteurIntervention = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_interlocuteurIntervention_element();
			inputDt.interlocuteurIntervention.personnePhysique = new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
			inputDt.interlocuteurIntervention.personnePhysique.civilite = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			inputDt.interlocuteurIntervention.personnePhysique.civilite.code = energyContractRequest.salutation;
			inputDt.interlocuteurIntervention.personnePhysique.civilite.libelleCourt = energyContractRequest.salutation;
			inputDt.interlocuteurIntervention.personnePhysique.nom = energyContractRequest.customerLastName;
			inputDt.interlocuteurIntervention.personnePhysique.prenom = energyContractRequest.customerFirstName;
			inputDt.interlocuteurIntervention.coordonneesContact =  new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
			inputDt.interlocuteurIntervention.coordonneesContact.telephone =  new List<String> {energyContractRequest.customerMainPhone};
			inputDt.reductionPuissance = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_reductionPuissance_element();
			inputDt.reductionPuissance.puissanceReduite = new gdfsuezComBefChpPSEDistributeurelec.puissanceDt();
			inputDt.reductionPuissance.puissanceReduite.unite = 'kVA';
			inputDt.reductionPuissance.puissanceReduite.valeur = energyResponse.puissanceReduite;
			inputDt.reductionPuissance.montantCreance = new gdfsuezComBefChpPSEDistributeurelec.deviseDt();
			inputDt.reductionPuissance.montantCreance.unite = 'euro';
			inputDt.reductionPuissance.montantCreance.valeur = energyResponse.montantCreance;

		}
		else if(enrolmentType == 'COUPURE'){
			inputDt.donneesGenerales.natureDemande.code = 'SAI';
			inputDt.interlocuteurIntervention = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_interlocuteurIntervention_element();
			inputDt.interlocuteurIntervention.personnePhysique = new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
			inputDt.interlocuteurIntervention.personnePhysique.civilite = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			inputDt.interlocuteurIntervention.personnePhysique.civilite.code = energyContractRequest.salutation;
			inputDt.interlocuteurIntervention.personnePhysique.civilite.libelleCourt = energyContractRequest.salutation;
			inputDt.interlocuteurIntervention.personnePhysique.nom = energyContractRequest.customerLastName;
			inputDt.interlocuteurIntervention.personnePhysique.prenom = energyContractRequest.customerFirstName;
			inputDt.interlocuteurIntervention.coordonneesContact =  new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
			inputDt.interlocuteurIntervention.coordonneesContact.telephone =  new List<String> {energyContractRequest.customerMainPhone};
			inputDt.suspensionAlimentation =  new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_suspensionAlimentation_element();
			inputDt.suspensionAlimentation.clientAvise = true;
			inputDt.suspensionAlimentation.reductionPuissanceClientAbsent = false;
			inputDt.suspensionAlimentation.deplacementSouhaite = false;
			inputDt.suspensionAlimentation.typeClientPrioritaire = null;
			inputDt.suspensionAlimentation.montantCreance = new gdfsuezComBefChpPSEDistributeurelec.deviseDt();
			inputDt.suspensionAlimentation.montantCreance.unite = 'euro';
			inputDt.suspensionAlimentation.montantCreance.valeur = energyResponse.montantCreance;
		}else if(enrolmentType == 'RETABLISSEMENT'){
			inputDt.donneesGenerales.natureDemande.code = 'RET';
			inputDt.interlocuteurIntervention = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_interlocuteurIntervention_element();
			inputDt.interlocuteurIntervention.personnePhysique = new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
			inputDt.interlocuteurIntervention.personnePhysique.civilite = new gdfsuezComBefChpPSEPivot.listeValeursDt();
			inputDt.interlocuteurIntervention.personnePhysique.civilite.code = energyContractRequest.salutation;
			inputDt.interlocuteurIntervention.personnePhysique.civilite.libelleCourt = energyContractRequest.salutation;
			inputDt.interlocuteurIntervention.personnePhysique.nom = energyContractRequest.customerLastName;
			inputDt.interlocuteurIntervention.personnePhysique.prenom = energyContractRequest.customerFirstName;
			inputDt.interlocuteurIntervention.coordonneesContact =  new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
			inputDt.interlocuteurIntervention.coordonneesContact.telephone =  new List<String> {energyContractRequest.customerMainPhone};
			inputDt.retablissement = new gdfsuezBefCalypsoPrestationServiceElec.retablissementDt();
			inputDt.retablissement.urgent = energyResponse.retablissementUrgent;
		}
		HP_DistributorEnergyContractResponse grdOutput = new  HP_DistributorEnergyContractResponse();
		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element response = port.CreerPrestationServiceElectricite_Http(inputDt, context);
		System.debug('@@@@@@response : '+JSON.serializePretty(response, true));
		gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt elecOutput = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt ();
		elecOutput = response.creerPrestationServiceElectriciteOutput;
		final List<gdfsuezComBefChpPSEPivot.retourTraitementMessageDt> CreatePrestationServiceMessageRetours = response.messageRetours.retourTraitementMessage;
		if(elecOutput != null) {
			grdOutput.prestationServiceDistributeurCree = elecOutput.prestationServiceDistributeurCree;
			//TODO use or remove grdOutput.prestationServiceFournisseurCree = elecOutput.prestationServiceFournisseurCree;
			grdOutput.dateEffetPrevue = elecOutput.dateEffetPrevue;
			if (elecOutput.sequence != null) {
				System.debug('sequence '+elecOutput.sequence);
				grdOutput.idPrestationServiceDistributeur = elecOutput.sequence.idPrestationServiceDistributeur;
			}
		}
		if( CreatePrestationServiceMessageRetours != null) {
			if(CreatePrestationServiceMessageRetours[0].causedBy != null && !elecOutput.prestationServiceDistributeurCree){
				grdOutput.code = CreatePrestationServiceMessageRetours[0].causedBy.code;
				grdOutput.libelle = CreatePrestationServiceMessageRetours[0].causedBy.libelle;
			}else{
				grdOutput.code = CreatePrestationServiceMessageRetours[0].code;
				grdOutput.libelle = CreatePrestationServiceMessageRetours[0].libelle;
			}
		}
		return (grdOutput.toCoreType());
	}

	private static void fillStructureTarifaire(final gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt inputDtRef, HP_EnergyContractRequest energyContractRequest) {
		inputDtRef.structureTarifaire = new gdfsuezBefCalypsoPrestationServiceElec.structureTarifaireCreationDt();
		inputDtRef.structureTarifaire.formulaireTarifaireAcheminement = new  gdfsuezComBefChpPSEPivot.listeValeursDt();
		inputDtRef.structureTarifaire.puissanceMaximumSouscrite = new gdfsuezComBefChpPSEDistributeurelec.puissanceDt();
		inputDtRef.structureTarifaire.puissanceMaximumSouscrite.valeur = (Double)energyContractRequest.electricityPowerRatingKiloVoltAmpere;
		inputDtRef.structureTarifaire.puissanceMaximumSouscrite.unite = UNITE_PUISSANCE_MAXIMUM_SOUSCRITE;
		inputDtRef.structureTarifaire.calendrierFournisseur = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		inputDtRef.structureTarifaire.calendrierFournisseur.code = energyContractRequest.electricityPricingPlan == 'BASE' ? 'FC000018' : 'FC000040';
		inputDtRef.structureTarifaire.formulaireTarifaireAcheminement.code = energyContractRequest.electricityPricingPlan == 'BASE' ? 'BTINFCUST' : 'BTINFMUDT';
	}

	private static void fillAutoReleve(final gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt inputDtRef, HP_EnergyContractRequest energyContractRequest) {
		inputDtRef.autoReleve = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_element();
		inputDtRef.autoReleve.dateAutoReleve =  datetime.now().format(HP_OctopusUtils.DATE_TIME_FORMAT);
		inputDtRef.autoReleve.programmationFournisseur = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt_autoReleve_programmationFournisseur_element();
		inputDtRef.autoReleve.programmationFournisseur.calendrier = new gdfsuezComBefChpPSEPivot.listeValeursDt();

		final Map<String, Integer> indexValueByOctopusType = new Map<String, Integer> {
			'HP' => energyContractRequest.electricityMeterVariablePlanPeakPriceIndex,
			'HC' => energyContractRequest.electricityMeterVariablePlanBottomPriceIndex,
			'Base' => energyContractRequest.electricityMeterBasePlanIndex
		};
		fillProgrammationFournisseur(inputDtRef, energyContractRequest.electricityPricingPlan, indexValueByOctopusType);

		if (inputDtRef.autoReleve.programmationFournisseur.mesuresIndex.mesureIndex.isEmpty()) {
			inputDtRef.autoReleve = null; //Fill only if index are known
		}
	}

	private static void fillProgrammationFournisseur(final gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteInputDt inputDtRef, final String electricityPricingPlan, final Map<String, Integer> indexValueByOctopusType) {
		inputDtRef.autoReleve.programmationFournisseur.calendrier.code =  electricityPricingPlan == 'BASE' ? 'BASE' : 'HPHC';
		inputDtRef.autoReleve.programmationFournisseur.mesuresIndex = new gdfsuezBefCalypsoPrestationServiceElec.mesuresIndexCreationDt();
		inputDtRef.autoReleve.programmationFournisseur.mesuresIndex.mesureIndex = new List <gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt>();
		for (String  octopusIndexType : OCTOPUS_INDEX_TYPE_SET_BY_PRICING_PLAN.get(electricityPricingPlan)) {
			final Integer indexValue = indexValueByOctopusType.get(octopusIndexType);
			if (indexValue != null) { //Fill only if index are known
				inputDtRef.autoReleve.programmationFournisseur.mesuresIndex.mesureIndex.add(buildMesureIndex(octopusIndexType, indexValue));
			}
		}
	}

	private static gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt buildMesureIndex(final String octopusIndexType, final Integer indexValue) {
		gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt mesureIndex = new gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt();
		mesureIndex.mesureIndex = new gdfsuezComBefChpPSEPivot.listeValeursDt();
		mesureIndex.mesureIndex.code = octopusIndexType;
		mesureIndex.index = new gdfsuezBefCalypsoPrestationServiceElec.mesureIndexCreationDt_index_element();
		mesureIndex.index.unite = INDEX_UNIT;
		mesureIndex.index.valeur = indexValue;
		mesureIndex.index.passageZero = false;
		return mesureIndex;
	}

	
}