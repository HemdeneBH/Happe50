import { LightningElement, api, track } from 'lwc';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import getEstimation from '@salesforce/apex/VI_parcoursConso_Controller.getEstimationLWC';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ParcoursPPEstimationConsommation extends LightningElement {

	MaConsommationEnergie_Bleu = EngieCommunityResource + '/EngieAssets/pictures/CONSO_CONNUE_BLEU.svg';
	MaConsommationEnergie_Blanc = EngieCommunityResource + '/EngieAssets/pictures/CONSO_CONNUE_BLC.svg';
	FaireUneEstimation_Blanc = EngieCommunityResource + '/EngieAssets/pictures/ESTIMATION_BLC.svg';
	FaireUneEstimation_Bleu = EngieCommunityResource + '/EngieAssets/pictures/ESTIMATION_BLEU.svg';
	closeImage = EngieCommunityResource + '/EngieAssets/pictures/close-icon.png';
	iconQuestion = EngieCommunityResource + '/EngieAssets/pictures/icon-question.png';
	imgLinky = EngieCommunityResource + '/EngieAssets/pictures/Linky.png';
	imgGazPar = EngieCommunityResource + '/EngieAssets/pictures/GazPar.png';
	imgCompteurHPHC = EngieCommunityResource + '/EngieAssets/pictures/Compteur_HPHC.png';
	imgCongelateur = EngieCommunityResource + '/EngieAssets/pictures/congelateur_bleu.svg';
	imgSecheLinge = EngieCommunityResource + '/EngieAssets/pictures/seche_linge_bleu.svg';
	imgLaveLinge = EngieCommunityResource + '/EngieAssets/pictures/lave_linge_bleu.svg';
	imgLaveVaisselle = EngieCommunityResource + '/EngieAssets/pictures/lave_vaisselle_bleu.svg';
	imgAppartement_Blanc = EngieCommunityResource + '/EngieAssets/pictures/appartement_blanc.svg';
	imgAppartement_Bleu = EngieCommunityResource + '/EngieAssets/pictures/appartement_bleu.svg';
	imgMaison_Blanc = EngieCommunityResource + '/EngieAssets/pictures/maison_blanc.svg';
	imgMaison_Bleu = EngieCommunityResource + '/EngieAssets/pictures/maison_blanc.svg';
	imgChauffage_Bleu = EngieCommunityResource + '/EngieAssets/pictures/chauffage_indiv_selected.svg';
	imgChauffage_Gris = EngieCommunityResource + '/EngieAssets/pictures/chauffage_indiv_unseleted.svg';
	imgCuisine = EngieCommunityResource + '/EngieAssets/pictures/cuisine_selected.svg';
	imgEauChaude_Bleu = EngieCommunityResource + '/EngieAssets/pictures/eau_chaude_selected.svg';
	imgEauChaude_Gris = EngieCommunityResource + '/EngieAssets/pictures/eau_chaude_unselected.svg';
	hasRendered = false;


	_title = 'Erreur';
	message = 'Sample Message';
	variant = 'error';
	isConnaisMaConso = false;
	isSouhaiteEstimer = false;
	isGaz = false;
	isElectricite = false;
	isGazEtElectricite = false;
	isHPHC = false;
	/* Start DDPCM - 1004 */
	iscompteurLinky = false;
	/* End DDPCM - 1004 */
	isResidencePrincipale = false;
	isResidenceSecondaire = false;
	isTypeMaison = false;
	isTypeAppartement = false;
	StringNombreOccupantLogementSaisieConso = "";
	ChauffageIndividuelGazSaisieConso = false;
	ChauffageIndividuelElecSaisieConso = false;
	CuisineGazSaisieConso = false;
	CuisineElecSaisieConso = false;
	EauChaudeGazSaisieConso = false;
	EauChaudeElecSaisieConso = false;
	DisabledChauffageIndividuelGaz = false;
	DisabledChauffageIndividuelElec = false;
	DisabledEauChaudeGaz = false;
	DisabledEauChaudeElec = false;
	estimationConsoInitialized = false;
	estimationConsoCompleted = false;
	displayError = false;
	displayErrorIdent = false;
	allFieldsNotFilled_MaConso = false;
	/* Start EVOL DDPCM 860*/
	redLabelGazPar = false;
	/* End EVOL DDPCM 860*/
	redLabelLinky = false;
	redLabelHP = false;
	redLabelHC = false;
	redLabelPuissanceCompteur = false;
	redLabelGaz = false;
	redLabelUtilisationGaz = false;
	redLabelUtilisationElec = false;
	greyLabelChauffageElec = false;
	greyLabelChauffageGaz = false;
	greyLabelEauChaudeElec = false;
	greyLabelEauChaudeGaz = false;
	colorGreyPlus = false;
	colorGreyMinus = false;
	isModalOpenBackgroundLinky = false;
	isModalLinkyOpen = false;
	/* Start EVOL DDPCM 860*/
	isModalOpenBackgroundGazPar = false;
	isModalGazparOpen = false;
	/* End EVOL DDPCM 860*/
	isModalOpenBackgroundHPHC = false;
	isModalHPHCOpen = false;
	showFieldErrors = false;


	@api stepsforinfo;

	@api
	get record() {
		return this._record;
	}
	set record(value) {
		if (value) {
			this._record = { ...value };
			this.handleUndefinedValues('VI_ChoixEnergie__c');
			this.handleUndefinedValues('VI_ChoixEstimation__c');
			this.handleUndefinedValues('VI_SaisieConsommationHeuresPleines__c');
			this.handleUndefinedValues('VI_SaisieConsommationHeuresCreuses__c');
			this.handleUndefinedValues('VI_PuissanceCompteurElecSaisieConso__c');
			this.handleUndefinedValues('VI_SaisieConsommationElec_HP_HC__c');
			this.handleUndefinedValues('VI_ConsommationGazKwHSaisieConso__c');
			this.handleUndefinedValues('VI_TypeResidenceSaisieConso__c');
			this.handleUndefinedValues('VI_TypeLogementSaisieConso__c');
			this.handleUndefinedValues('VI_TypeLogementRechercheLocal__c');
			this.handleUndefinedValues('VI_SurfaceLogementSaisieConso__c');
			this.handleUndefinedValues('VI_NombreOccupantLogementSaisieConso__c');
			this.handleUndefinedValues('VI_AnneeConstructionLogementSaisieConso__c');
			this.handleUndefinedValues('VI_DispositifChauffageSaisieConso__c');
			this.handleUndefinedValues('VI_EnergieChauffageSaisieConso__c');
			this.handleUndefinedValues('VI_EnergieCuissonSaisieConso__c');
			this.handleUndefinedValues('VI_DispositifEauChaudeSaisieConso__c');
			this.handleUndefinedValues('VI_EnergieEauChaudeSaisieConso__c');
			this.handleUndefinedValues('VI_CongelateurElecSaisieConso__c');
			this.handleUndefinedValues('VI_SecheLingeElecSaisieConso__c');
			this.handleUndefinedValues('VI_LaveLingeElecSaisieConso__c');
			this.handleUndefinedValues('VI_LaveVaisselleElecSaisieConso__c');
			this.handleUndefinedValues('VI_SaisieEstimationConsoElec_HP_HC__c');
			this.handleUndefinedValues('VI_SaisieEstimationConsoElec_Linky__c');
			/* Start EVOL DDPCM 860*/
			this.handleUndefinedValues('VI_SaisieEstimationConsoElec_GazPar__c');
			/* End EVOL DDPCM 860*/
			/* Start DDPCM 1004 */
			this.handleUndefinedValues('VI_CompteurCommunicantLinkySaisieConso__c');
			console.log('initialisation VI_CompteurCommunicantLinkySaisieConso__c = ', this._record.VI_CompteurCommunicantLinkySaisieConso__c);

			/* End DDPCM 1004 */

			console.log('this._record.VI_ChoixEstimation__c ' + this._record.VI_ChoixEstimation__c);
			//console.log('stepsforinfo :' + this.stepsforinfo);
			if (this._record.VI_ChoixEstimation__c === 'Saisir la consommation d\'énergie') {
				this.isConnaisMaConso = true;
				this.isSouhaiteEstimer = false;
			}
			else if (this._record.VI_ChoixEstimation__c === 'Estimer la consommation d\'énergie') {
				this.isSouhaiteEstimer = true;
				this.isConnaisMaConso = false;
			}
			if (this._record.VI_ChoixEnergie__c === 'Gaz') {
				this.isGaz = true;
				this.isElectricite = false;
				this.isGazEtElectricite = false;
				/* Start DDPCM - 674 */
				if (this._record.VI_typeCompteurGaz__c === 'GAZPAR') {
					this._record.VI_SaisieEstimationConsoElec_GazPar__c = 'Oui';
				}
				else {
					this._record.VI_SaisieEstimationConsoElec_GazPar__c = 'Je ne sais pas';
				}
				/* End DDPCM - 674 */
			}
			else if (this._record.VI_ChoixEnergie__c === 'Electricité') {
				this.isElectricite = true;
				this.isGaz = false;
				this.isGazEtElectricite = false;
				/* Start DDPCM - 674 */
				if (this._record.VI_typeCompteurElec__c  === 'LINKY') {
					this._record.VI_SaisieEstimationConsoElec_Linky__c = 'Oui';
					this._record.VI_CompteurCommunicantLinkySaisieConso__c = true;
					this.iscompteurLinky = true;
				}
				else if (this._record.VI_SaisieEstimationConsoElec_Linky__c !== 'Je ne sais pas' ||
						this._record.VI_CompteurCommunicantLinkySaisieConso__c != false) {
							if (this._record.VI_SaisieEstimationConsoElec_Linky__c === 'Oui' ||
							this._record.VI_CompteurCommunicantLinkySaisieConso__c === true) {
					this.iscompteurLinky = true;
				}
				else {
								this.iscompteurLinky = false;
							}
				}
				else {
					this._record.VI_SaisieEstimationConsoElec_Linky__c = 'Je ne sais pas';
					this._record.VI_CompteurCommunicantLinkySaisieConso__c = false;
					this.iscompteurLinky = false;
				}
				/* End DDPCM - 674 */
			}
			else if (this._record.VI_ChoixEnergie__c === 'Electricité + Gaz') {
				this.isGazEtElectricite = true;
				this.isElectricite = false;
				this.isGaz = false;
				/* Start DDPCM - 674 */
				if (this._record.VI_typeCompteurGaz__c === 'GAZPAR') {
					this._record.VI_SaisieEstimationConsoElec_GazPar__c = 'Oui';
				}
				else {
					this._record.VI_SaisieEstimationConsoElec_GazPar__c = 'Je ne sais pas';
				}
				if (this._record.VI_typeCompteurElec__c  === 'LINKY') {
					this._record.VI_SaisieEstimationConsoElec_Linky__c = 'Oui';
					this._record.VI_CompteurCommunicantLinkySaisieConso__c = true;
					this.iscompteurLinky = true;
				}
				else if (this._record.VI_SaisieEstimationConsoElec_Linky__c !== 'Je ne sais pas' ||
						this._record.VI_CompteurCommunicantLinkySaisieConso__c != false) {
							if (this._record.VI_SaisieEstimationConsoElec_Linky__c === 'Oui' ||
							this._record.VI_CompteurCommunicantLinkySaisieConso__c === true) {
					this.iscompteurLinky = true;
				}
				else {
								this.iscompteurLinky = false;
							}
				}
				else {
					this._record.VI_SaisieEstimationConsoElec_Linky__c = 'Je ne sais pas';
					this._record.VI_CompteurCommunicantLinkySaisieConso__c = false;
					this.iscompteurLinky = false;
				}
				/* End DDPCM - 674 */
			}
			else if (this._record.VI_ChoixEnergie__c === null) {
				this.isGazEtElectricite = true;
				this.isElectricite = false;
				this.isGaz = false;
				/* Start DDPCM - 674 */
				if (this._record.VI_typeCompteurGaz__c === 'GAZPAR') {
					this._record.VI_SaisieEstimationConsoElec_GazPar__c = 'Oui';
				}
				else {
					this._record.VI_SaisieEstimationConsoElec_GazPar__c = 'Je ne sais pas';
				}
				if (this._record.VI_typeCompteurElec__c  === 'LINKY') {
					this._record.VI_SaisieEstimationConsoElec_Linky__c = 'Oui';
					this._record.VI_CompteurCommunicantLinkySaisieConso__c = true;
					this.iscompteurLinky = true;
				}
				else if (this._record.VI_SaisieEstimationConsoElec_Linky__c !== 'Je ne sais pas' ||
						this._record.VI_CompteurCommunicantLinkySaisieConso__c != false) {
							if (this._record.VI_SaisieEstimationConsoElec_Linky__c === 'Oui' ||
							this._record.VI_CompteurCommunicantLinkySaisieConso__c === true) {
					this.iscompteurLinky = true;
				}
				else {
								this.iscompteurLinky = false;
							}
				}
				else {
					this._record.VI_SaisieEstimationConsoElec_Linky__c = 'Je ne sais pas';
					this._record.VI_CompteurCommunicantLinkySaisieConso__c = false;
					this.iscompteurLinky = false;
				}
				/* End DDPCM - 674 */
			}
			if (this._record.VI_SaisieConsommationElec_HP_HC__c === true) {
				this.isHPHC = true;
			}
			/* Start DDPCM 1004 */
			if (this._record.VI_CompteurCommunicantLinkySaisieConso__c === true) {
				this.iscompteurLinky = true;
			}
			else {
				this.iscompteurLinky = false;
			}
			/* End DDPCM 1004 */
			if (this._record.VI_TypeLogementSaisieConso__c === 'Individuel') {
				this.isTypeMaison = true;
				this.isTypeAppartement = false;
			}
			else if (this._record.VI_TypeLogementSaisieConso__c === 'Collectif') {
				this.isTypeMaison = false;
				this.isTypeAppartement = true;
			}
			if (this._record.VI_TypeResidenceSaisieConso__c === 'Principale') {
				this.isResidencePrincipale = true;
				this.isResidenceSecondaire = false;
			}
			else if (this._record.VI_TypeResidenceSaisieConso__c === 'Secondaire') {
				this.isResidencePrincipale = false;
				this.isResidenceSecondaire = true;
			}
			if (this._record.VI_NombreOccupantLogementSaisieConso__c > 1 &&
				this._record.VI_NombreOccupantLogementSaisieConso__c < 10) {
				this.colorGreyPlus = false;
				this.colorGreyMinus = false;
				this.StringNombreOccupantLogementSaisieConso = this._record.VI_NombreOccupantLogementSaisieConso__c.toString();
			}
			else if (this._record.VI_NombreOccupantLogementSaisieConso__c === '1') {
				this.colorGreyMinus = true;
				this.StringNombreOccupantLogementSaisieConso = this._record.VI_NombreOccupantLogementSaisieConso__c.toString();
			}
			else if (this._record.VI_NombreOccupantLogementSaisieConso__c === '10') {
				this.colorGreyPlus = true;
				this.StringNombreOccupantLogementSaisieConso = this._record.VI_NombreOccupantLogementSaisieConso__c.toString();
				this.StringNombreOccupantLogementSaisieConso += "+";
			}
			if (this._record.VI_SaisieEstimationConsoElec_HP_HC__c === null) {
				this._record.VI_SaisieEstimationConsoElec_HP_HC__c = 'Je ne sais pas';
			}
			if (this._record.VI_SaisieEstimationConsoElec_Linky__c === null) {
				this._record.VI_SaisieEstimationConsoElec_Linky__c = 'Je ne sais pas';
			}
			/* Start EVOL DDPCM 860*/
			if (this._record.VI_SaisieEstimationConsoElec_GazPar__c === null) {
				this._record.VI_SaisieEstimationConsoElec_GazPar__c = 'Je ne sais pas';
			}
			/* End EVOL DDPCM 860*/
			if (this._record.VI_EnergieChauffageSaisieConso__c === "Gaz naturel") {
				this.ChauffageIndividuelGazSaisieConso = true;
				if (this.isGazEtElectricite) {
					this.greyLabelChauffageElec = true;
					this.DisabledChauffageIndividuelElec = true;
					this.DisabledChauffageIndividuelGaz = false;
				}
			}
			if (this._record.VI_EnergieChauffageSaisieConso__c === "Electricité") {
				this.ChauffageIndividuelElecSaisieConso = true;
				if (this.isGazEtElectricite) {
					this.greyLabelChauffageGaz = true;
					this.DisabledChauffageIndividuelGaz = true;
					this.DisabledChauffageIndividuelElec = false;
				}
			}
			if (this._record.VI_EnergieCuissonSaisieConso__c === "Mixte") {
				this.CuisineGazSaisieConso = true;
				this.CuisineElecSaisieConso = true;
			}
			if (this._record.VI_EnergieCuissonSaisieConso__c === "Gaz naturel") {
				this.CuisineGazSaisieConso = true;
			}
			if (this._record.VI_EnergieCuissonSaisieConso__c === "Electricité") {
				this.CuisineElecSaisieConso = true;
			}
			if (this._record.VI_EnergieEauChaudeSaisieConso__c === "Gaz naturel") {

				this.EauChaudeGazSaisieConso = true;

				if (this.isGazEtElectricite) {

					this.greyLabelEauChaudeElec = true;
					this.DisabledEauChaudeElec = true;
					this.DisabledEauChaudeGaz = false;

				}
			}
			if (this._record.VI_EnergieEauChaudeSaisieConso__c === "Electricité") {
				this.EauChaudeElecSaisieConso = true;
				if (this.isGazEtElectricite) {
					this.greyLabelEauChaudeGaz = true;
					this.DisabledEauChaudeGaz = true;
					this.DisabledEauChaudeElec = false;
				}

			}
		}
		else {
			this._record = {};
		}
	}

	renderedCallback() {
		if (!this.hasRendered) {
			this.template.querySelector('[data-id="topPage"]').scrollIntoView(true);
			this.hasRendered = true;
		}
	}
	//sets the fields to null if they are empty
	handleUndefinedValues(recordField) {
		if (typeof this._record[recordField] === "undefined") {
			this._record[recordField] = null;
		}
	}

	@api
	get recordupdated() {
		return this._recordupdated;
	}
	set recordupdated(value) {
		this._recordupdated = value;
	}

	handleSaisieConsoElec(event) {
		this._recordupdated = true;
		let field = event.target.name;
		if (field === 'HeuresPleines') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_SaisieConsommationHeuresPleines__c = event.target.value.slice(0, 6);
				this.template.querySelector('[data-id="IndexHP"]').value = this._record.VI_SaisieConsommationHeuresPleines__c;
			}
		}
		if (field === 'HeuresCreuses') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_SaisieConsommationHeuresCreuses__c = event.target.value.slice(0, 6);
				this.template.querySelector('[data-id="IndexHC"]').value = this._record.VI_SaisieConsommationHeuresCreuses__c;
			}
		}
		if (field === 'PuissanceCompteur') {
			console.log('PuissanceCompteur' + event.target.value);
			this._record.VI_PuissanceCompteurElecSaisieConso__c = event.target.value;
		}
		if (field === 'HP/HC') {
			console.log('HP/HC' + event.target.checked);
			console.log(this._record.VI_PuissanceCompteurElecSaisieConso__c === '3');
			console.log(this._record.VI_PuissanceCompteurElecSaisieConso__c === 3);
			console.log(event.target.checked);
			this._record.VI_SaisieConsommationElec_HP_HC__c = event.target.checked;
			if (this._record.VI_PuissanceCompteurElecSaisieConso__c === '3' && event.target.checked) {
				console.log('hp hc changer puissance1');
				this.template.querySelector('[data-id="IndexGaz"]').value = '6';
				console.log('hp hc changer puissance2');
			}

		}
		/* Start DDPCM - 1004 */
		if (field === 'compteurLinky') {
			this.iscompteurLinky = event.target.checked;
			if (this.iscompteurLinky === true) {
				this._record.VI_CompteurCommunicantLinkySaisieConso__c = true;
			}
			else {
				this._record.VI_CompteurCommunicantLinkySaisieConso__c = false;
			}		
		}
		/* Start DDPCM - 1004 */
		if (field === 'ConsommationAnnuelGaz') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_ConsommationGazKwHSaisieConso__c = event.target.value.slice(0, 6);
				this.template.querySelector('[data-id="IndexGaz"]').value = this._record.VI_ConsommationGazKwHSaisieConso__c;
			}
		}
	}

	handleButtonClick(event) {
		console.log('event.target.dataset.id' + event.target.dataset.id);
		this._recordupdated = true;
		if (event.target.dataset.id === 'Connais ma consommation') {
			this.isConnaisMaConso = true;
			this.isSouhaiteEstimer = false;
			this._record.VI_ChoixEstimation__c = 'Saisir la consommation d\'énergie';
			this.showFieldErrors = false;
			this.displayError = false;
			this.checkFieldsConnaisMaConso();
			/* this.isHPHC = event.target.checked; */
		}
		if (event.target.dataset.id === 'Souhaite estimer') {
			this.isSouhaiteEstimer = true;
			this.isConnaisMaConso = false;
			this.showFieldErrors = false;
			this.displayError = false;
			this._record.VI_ChoixEstimation__c = 'Estimer la consommation d\'énergie';
			this.checkFieldsSouhaiteEstimer();

		}
		if (event.target.dataset.id === 'HP/HC') {
			this._record.VI_SaisieConsommationElec_HP_HC__c = event.target.checked;
			this.isHPHC = event.target.checked;
			this.showFieldErrors = false;
			this.displayError = false;
			this.checkFieldsConnaisMaConso();

			console.log('HP/HC' + event.target.checked);
			console.log(this._record.VI_PuissanceCompteurElecSaisieConso__c === '3');
			console.log(this._record.VI_PuissanceCompteurElecSaisieConso__c === 3);
			console.log(event.target.checked);
			if (this._record.VI_PuissanceCompteurElecSaisieConso__c === '3' && event.target.checked) {
				console.log('hp hc changer puissance1');
				this.template.querySelector('[data-id="PuissanceCompteur"]').value = '6';
				this.template.querySelector('[data-id="PuissanceCompteur"]').selected = '6';
				this._record.VI_PuissanceCompteurElecSaisieConso__c='6';
				console.log('hp hc changer puissance2');
			}

		}

		/* Start DDPCM - 1004 */
		if (event.target.dataset.id === 'compteurLinky') {
			this.iscompteurLinky = event.target.checked;
			if (this.iscompteurLinky === true) {
				this._record.VI_CompteurCommunicantLinkySaisieConso__c = true;
			}
			else {
				this._record.VI_CompteurCommunicantLinkySaisieConso__c = false;
			}
		}
		/* End DDPCM - 1004 */

		if (event.target.dataset.id === 'passerEtape') {
			console.log('passerEtape' + event.target.dataset.current);
			this.isConnaisMaConso = false;
			this.isSouhaiteEstimer = false;
			this.displayError = false;
			this._record.VI_ChoixEstimation__c = event.target.dataset.current;
			if (this.stepsforinfo) {
				console.log('passerEtape if');
				/* Start DDPCM 1192 */
				this.emptyConstitutionPanier();
				/* End DDPCM 1192 */

				const dispatchEventSearch = new CustomEvent('passeretape');
				this.dispatchEvent(dispatchEventSearch);
			}
			else {
				console.log('passerEtape else');
				this.displayErrorIdent = true;

				this.ErrorMessageIdent = "Les étapes Identification besoin, client et local ne sont pas complétées. Merci de les compléter pour accéder à la suite du parcours.";
				const dispatchEventSearch = new CustomEvent('estimationdone');
				this.dispatchEvent(dispatchEventSearch);


			}

		}

	}

	handleEstimer(event) {
		this._recordupdated = true;
		let field = event.target.name;
		if (field === 'TypeDeLogement') {
			this._record.VI_TypeLogementSaisieConso__c = event.target.value;
			if (this._record.VI_TypeLogementSaisieConso__c === 'Individuel') {
				this._record.VI_TypeLogementRechercheLocal__c = "Maison";
				this.isTypeMaison = true;
				this.isTypeAppartement = false;
			}
			else if (this._record.VI_TypeLogementSaisieConso__c === 'Collectif') {
				this._record.VI_TypeLogementRechercheLocal__c = "Appartement";
				this.isTypeMaison = false;
				this.isTypeAppartement = true;
			}
		}
		if (field === 'TypeResidence') {
			this._record.VI_TypeResidenceSaisieConso__c = event.target.value;
			if (this._record.VI_TypeResidenceSaisieConso__c === 'Principale') {
				this.isResidencePrincipale = true;
				this.isResidenceSecondaire = false;
			}
			else if (this._record.VI_TypeResidenceSaisieConso__c === 'Secondaire') {
				this.isResidencePrincipale = false;
				this.isResidenceSecondaire = true;
			}
		}
		if (field === 'Surface') {
			event.target.value = event.target.value.replace(/[^0-9]*/g, '');
			//event.target.value = Math.abs(event.target.value);
			this._record.VI_SurfaceLogementSaisieConso__c = event.target.value.slice(0, 4);
			this.template.querySelector('[data-id="Surface"]').value = this._record.VI_SurfaceLogementSaisieConso__c;
		}
		if (field === 'NombreOccupants') {
			event.target.value = event.target.value.replace(/[^0-9]*/g, '');
			this._record.VI_NombreOccupantLogementSaisieConso__c = event.target.value.slice(0, 2);
			this.template.querySelector('[data-id="NombreOccupants"]').value = this._record.VI_NombreOccupantLogementSaisieConso__c;
			this.StringNombreOccupantLogementSaisieConso = this._record.VI_NombreOccupantLogementSaisieConso__c.toString();

			var NbOccupantValue = event.target.value.slice(0, 2);
			if (NbOccupantValue < 10 && NbOccupantValue > 1) {
				this.colorGreyPlus = false;
				this.colorGreyMinus = false;
			}
			else if (NbOccupantValue > 9) {
				this.colorGreyPlus = true;
				this.colorGreyMinus = false;
				this.StringNombreOccupantLogementSaisieConso += "+";
			}
			else if (NbOccupantValue < 2) {
				this.colorGreyMinus = true;
				this.colorGreyPlus = false;
			}

		}
		if (field === 'AnneeConstruction') {
			this._record.VI_AnneeConstructionLogementSaisieConso__c = event.target.value;
		}
		if (field === 'ChauffageIndividuelGaz') {
			this.ChauffageIndividuelGazSaisieConso = event.target.checked;
			this.redLabelUtilisationGaz = false;
			if (this.ChauffageIndividuelGazSaisieConso == true) {
				if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="ChauffageIndividuelElec"]').disabled = true;
					this.greyLabelChauffageElec = true;
				}

				this._record.VI_EnergieChauffageSaisieConso__c = "Gaz naturel";
				this._record.VI_DispositifChauffageSaisieConso__c = "Individuel";

			}
			else {
				if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="ChauffageIndividuelElec"]').disabled = false;
					this.greyLabelChauffageElec = false;
				}
				this._record.VI_EnergieChauffageSaisieConso__c = "Autre";
				this._record.VI_DispositifChauffageSaisieConso__c = "Collectif";
			}
		}
		if (field === 'CuisineGaz') {
			this.CuisineGazSaisieConso = event.target.checked;
			this.redLabelUtilisationGaz = false;
			if (this.isGazEtElectricite == true && this.CuisineElecSaisieConso == true) {
				if (this.CuisineGazSaisieConso == true) {
					this._record.VI_EnergieCuissonSaisieConso__c = "Mixte";
				}
				else {
					this._record.VI_EnergieCuissonSaisieConso__c = "Electricité";
				}
			}
			else {
				if (this.CuisineGazSaisieConso == true) {
					this._record.VI_EnergieCuissonSaisieConso__c = "Gaz naturel";
				}
				else {
					this._record.VI_EnergieCuissonSaisieConso__c = "Je ne sais pas";
				}
			}
		}
		if (field === 'EauChaudeGaz') {
			this.EauChaudeGazSaisieConso = event.target.checked;
			this.redLabelUtilisationGaz = false;
			if (this.EauChaudeGazSaisieConso == true) {
				if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="EauChaudeElec"]').disabled = true;
					this.greyLabelEauChaudeElec = true;
				}
				this._record.VI_EnergieEauChaudeSaisieConso__c = "Gaz naturel";
				this._record.VI_DispositifEauChaudeSaisieConso__c = "Individuel";
			}
			else {
				if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="EauChaudeElec"]').disabled = false;
					this.greyLabelEauChaudeElec = false;
				}
				this._record.VI_EnergieEauChaudeSaisieConso__c = "Autre";
				this._record.VI_DispositifEauChaudeSaisieConso__c = "Collectif";
			}
		}
		if (field === 'ChauffageIndividuelElec') {
			this.ChauffageIndividuelElecSaisieConso = event.target.checked;
			this.redLabelUtilisationElec = false;
			if (this.ChauffageIndividuelElecSaisieConso == true) {
				if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="ChauffageIndividuelGaz"]').disabled = true;
					this.greyLabelChauffageGaz = true;
				}
				this._record.VI_EnergieChauffageSaisieConso__c = "Electricité";
				this._record.VI_DispositifChauffageSaisieConso__c = "Individuel";
			}
			else {
				if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="ChauffageIndividuelGaz"]').disabled = false;
					this.greyLabelChauffageGaz = false;
				}
				this._record.VI_EnergieChauffageSaisieConso__c = "Autre";
				this._record.VI_DispositifChauffageSaisieConso__c = "Collectif";
			}
		}
		if (field === 'CuisineElec') {
			this.CuisineElecSaisieConso = event.target.checked;
			this.redLabelUtilisationElec = false;
			if (this.isGazEtElectricite == true && this.CuisineGazSaisieConso == true) {
				if (this.CuisineElecSaisieConso == true) {
					this._record.VI_EnergieCuissonSaisieConso__c = "Mixte";
				}
				else {
					this._record.VI_EnergieCuissonSaisieConso__c = "Gaz naturel";
				}
			}
			else {
				if (this.CuisineElecSaisieConso == true) {
					this._record.VI_EnergieCuissonSaisieConso__c = "Electricité";
				}
				else {
					this._record.VI_EnergieCuissonSaisieConso__c = "Je ne sais pas";
				}
			}
		}
		if (field === 'EauChaudeElec') {
			this.EauChaudeElecSaisieConso = event.target.checked;
			this.redLabelUtilisationElec = false;
			if (this.EauChaudeElecSaisieConso == true) {
				if (this.isGazEtElectricite) {

					this.template.querySelector('[data-id="EauChaudeGaz"]').disabled = true;
					this.greyLabelEauChaudeGaz = true;
				}
				this._record.VI_EnergieEauChaudeSaisieConso__c = "Electricité";
				this._record.VI_DispositifEauChaudeSaisieConso__c = "Individuel";
			}
			else {
				if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="EauChaudeGaz"]').disabled = false;
					this.greyLabelEauChaudeGaz = false;
				}
				this._record.VI_EnergieEauChaudeSaisieConso__c = "Autre";
				this._record.VI_DispositifEauChaudeSaisieConso__c = "Collectif";
			}
		}
		if (field === 'OptionLinky') {
			this._record.VI_SaisieEstimationConsoElec_Linky__c = event.target.value;
		}
		/* Start EVOL DDPCM 860*/
		if (field === 'OptionGazPar') {
			this._record.VI_SaisieEstimationConsoElec_GazPar__c = event.target.value;
		}
		/* End EVOL DDPCM 860*/
		if (field === 'OptionHPHC') {
			this._record.VI_SaisieEstimationConsoElec_HP_HC__c = event.target.value;
		}
		if (field === 'Congelateur') {
			this._record.VI_CongelateurElecSaisieConso__c = event.target.checked;
		}
		if (field === 'SecheLinge') {
			this._record.VI_SecheLingeElecSaisieConso__c = event.target.checked;
		}
		if (field === 'LaveLinge') {
			this._record.VI_LaveLingeElecSaisieConso__c = event.target.checked;
		}
		if (field === 'LaveVaisselle') {
			this._record.VI_LaveVaisselleElecSaisieConso__c = event.target.checked;
		}
	}

	handleSuivant(event) {
		this._recordupdated = true;
		this.showFieldErrors = true;
		this.displayError = false;
		this.displayErrorIdent = false;
		this.estimationConsoCompleted = false;

		if (this._record.VI_ChoixEstimation__c === 'Passer cette étape') {
			if (!this.stepsforinfo) {
				this.displayErrorIdent = true;
				this.displayError = false;
				this.ErrorMessageIdent = "Les étapes Identification besoin, client et local ne sont pas complétées. Merci de les compléter pour accéder à la suite du parcours.";
			}
			else {
				const dispatchEventSearch = new CustomEvent('passeretape');
				this.dispatchEvent(dispatchEventSearch);
			}
		}
		if (this.isConnaisMaConso) {
			this.checkFieldsConnaisMaConso();

			if (!this.stepsforinfo) {
				this.displayErrorIdent = true;
				this.displayError = false;
				this.ErrorMessageIdent = "Les étapes Identification besoin, client et local ne sont pas complétées. Merci de les compléter pour accéder à la suite du parcours.";
			}
			if (this.allFieldsNotFilled_MaConso && this.stepsforinfo && this.showFieldErrors === true) {
				this.displayError = true;
				this.displayErrorIdent = false;
				this.ErrorMessage = "Merci de renseigner tous les champs avec un format correcte pour valider la saisie de la consommation.";
			}
			if (this.allFieldsNotFilled_MaConso && !this.stepsforinfo) {
				this.displayErrorIdent = true;
				if (this.showFieldErrors === true) {
					this.displayError = true;
					this.ErrorMessage = "Merci de renseigner tous les champs avec un format correcte pour valider la saisie de la consommation.";
				}
				this.ErrorMessageIdent = "Les étapes Identification besoin, client et local ne sont pas complétées. Merci de les compléter pour accéder à la suite du parcours.";
			}
			if (this.estimationConsoAndStepsCompleted) {
				if (this.stepsforinfo) {
					const dispatchEventSearch = new CustomEvent('passeretape');
					/* Start DDPCM 1192 */
					this.emptyConstitutionPanier();
					/* End DDPCM 1192 */
					this.dispatchEvent(dispatchEventSearch);
				}
			}

		}

		if (this.isSouhaiteEstimer) {
			this.checkFieldsSouhaiteEstimer();
			if (this.allFieldsNotFilled_Estimer && this.stepsforinfo && this.showFieldErrors === true) {
				this.displayError = true;
				this.displayErrorIdent = false;
				this.ErrorMessage = "Nous ne pouvons pas faire l’estimation car certains élements sont manquants ou incorrectes.";
			}
			if (!this.stepsforinfo) {
				this.displayErrorIdent = true;
				this.displayError = false;
				this.ErrorMessageIdent = "Les étapes Identification besoin, client et local ne sont pas complétées. Merci de les compléter pour accéder à la suite du parcours.";
			}
			if (this.allFieldsNotFilled_Estimer && !this.stepsforinfo) {
				this.displayErrorIdent = true;
				if (this.showFieldErrors === true) {
					this.displayError = true;
					this.ErrorMessage = "Nous ne pouvons pas faire l’estimation car certains élements sont manquants ou incorrectes.";
				}
				this.ErrorMessageIdent = "Les étapes Identification besoin, client et local ne sont pas complétées. Merci de les compléter pour accéder à la suite du parcours.";
			}
			if (this.estimationConsoAndStepsCompleted) {
				console.log('getEstimationFromApex');
				/* Start DDPCM 1192 */
				this.emptyConstitutionPanier();
				/* End DDPCM 1192 */

				this.getEstimationFromApex();

			}
		}
	}

	checkFieldsConnaisMaConso() {

		if (this.isElectricite) {
			if (this.isHPHC) {
				/*	if (this._record.VI_SaisieConsommationHeuresPleines__c !== null ||
			this._record.VI_SaisieConsommationHeuresCreuses__c !== null ||
			this._record.VI_PuissanceCompteurElecSaisieConso__c !== null) {
*/
				this.estimationConsoInitialized = true;
				this.redLabelHP = false;
				this.redLabelHC = false;
				this.redLabelPuissanceCompteur = false;

				//	console.log('VI_SaisieConsommationHeuresPleines__c : ' + this._record.VI_SaisieConsommationHeuresPleines__c);
				if (this.showFieldErrors === true) {
					if (this._record.VI_SaisieConsommationHeuresPleines__c === null ||
						this._record.VI_SaisieConsommationHeuresPleines__c === '' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '00' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '00000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '000000') {
						this.redLabelHP = true;
						console.log('redLabelHP : ' + this.redLabelHP);
					}
					if (this._record.VI_SaisieConsommationHeuresCreuses__c === null ||
						this._record.VI_SaisieConsommationHeuresCreuses__c === '' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '0' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '00' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '000' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '0000' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '00000' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '000000') {
						this.redLabelHC = true;
					}
					if (this._record.VI_PuissanceCompteurElecSaisieConso__c === null) {
						this.redLabelPuissanceCompteur = true;
					}
				}
				//		}
				if (this._record.VI_SaisieConsommationHeuresPleines__c !== null &&
					this._record.VI_SaisieConsommationHeuresCreuses__c !== null &&
					this._record.VI_PuissanceCompteurElecSaisieConso__c !== null &&
					this._record.VI_SaisieConsommationHeuresPleines__c > 0 &&
					this._record.VI_SaisieConsommationHeuresCreuses__c > 0) {
					this.estimationConsoCompleted = true;
					this.displayError = false;
					this.allFieldsNotFilled_MaConso = false;
					this.redLabelHP = false;
					this.redLabelHC = false;
					this.redLabelPuissanceCompteur = false;

				}
			}
			else {
				/*		if (this._record.VI_SaisieConsommationHeuresPleines__c !== null ||
			this._record.VI_PuissanceCompteurElecSaisieConso__c !== null) {
*/
				this.estimationConsoInitialized = true;
				this.redLabelHP = false;
				this.redLabelPuissanceCompteur = false;
				if (this.showFieldErrors === true) {
					if (this._record.VI_SaisieConsommationHeuresPleines__c === null ||
						this._record.VI_SaisieConsommationHeuresPleines__c === '' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '00' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '00000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0000000') {
						this.redLabelHP = true;
					}
					if (this._record.VI_PuissanceCompteurElecSaisieConso__c === null) {
						this.redLabelPuissanceCompteur = true;
					}
				}

				//		}
				if (this._record.VI_SaisieConsommationHeuresPleines__c !== null &&
					this._record.VI_PuissanceCompteurElecSaisieConso__c !== null &&
					this._record.VI_SaisieConsommationHeuresPleines__c > 0) {
					this.estimationConsoCompleted = true;
					this.displayError = false;
					this.allFieldsNotFilled_MaConso = false;
					this.redLabelHP = false;
					this.redLabelPuissanceCompteur = false;
				}
			}

		}

		if (this.isGaz) {
			//	if (this._record.VI_ConsommationGazKwHSaisieConso__c !== null) {
			this.estimationConsoInitialized = true;
			this.redLabelGaz = false;
			if (this.showFieldErrors === true) {
				if (this._record.VI_ConsommationGazKwHSaisieConso__c === null ||
					this._record.VI_ConsommationGazKwHSaisieConso__c === '' ||
					this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '0' ||
					this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '00' ||
					this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '000' ||
					this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '0000' ||
					this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '00000' ||
					this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '000000') {
					this.redLabelGaz = true;
				}
			}
			//	}

			if (this._record.VI_ConsommationGazKwHSaisieConso__c !== null &&
				this._record.VI_ConsommationGazKwHSaisieConso__c > 0) {
				this.estimationConsoCompleted = true;
				this.displayError = false;
				this.allFieldsNotFilled_MaConso = false;
				this.redLabelGaz = false;
			}
		}

		if (this.isGazEtElectricite) {
			if (this.isHPHC) {
				/*		if (this._record.VI_SaisieConsommationHeuresPleines__c !== null ||
			this._record.VI_SaisieConsommationHeuresCreuses__c !== null ||
			this._record.VI_PuissanceCompteurElecSaisieConso__c !== null ||
			this._record.VI_ConsommationGazKwHSaisieConso__c !== null) {
*/
				this.estimationConsoInitialized = true;
				this.redLabelHP = false;
				this.redLabelHC = false;
				this.redLabelPuissanceCompteur = false;
				this.redLabelGaz = false;
				if (this.showFieldErrors === true) {
					if (this._record.VI_SaisieConsommationHeuresPleines__c === null ||
						this._record.VI_SaisieConsommationHeuresPleines__c === '' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '00' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '00000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '000000') {
						this.redLabelHP = true;
					}
					if (this._record.VI_SaisieConsommationHeuresCreuses__c === null ||
						this._record.VI_SaisieConsommationHeuresCreuses__c === '' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '0' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '00' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '000' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '0000' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '00000' ||
						this._record.VI_SaisieConsommationHeuresCreuses__c.toString() === '000000') {
						this.redLabelHC = true;
					}
					if (this._record.VI_PuissanceCompteurElecSaisieConso__c === null) {
						this.redLabelPuissanceCompteur = true;
					}
					if (this._record.VI_ConsommationGazKwHSaisieConso__c === null ||
						this._record.VI_ConsommationGazKwHSaisieConso__c === '' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '0' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '00' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '000' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '0000' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '00000' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '000000') {
						this.redLabelGaz = true;
					}
				}
				//		}
				if (this._record.VI_SaisieConsommationHeuresPleines__c !== null &&
					this._record.VI_SaisieConsommationHeuresCreuses__c !== null &&
					this._record.VI_PuissanceCompteurElecSaisieConso__c !== null &&
					this._record.VI_ConsommationGazKwHSaisieConso__c !== null &&
					this._record.VI_SaisieConsommationHeuresPleines__c > 0 &&
					this._record.VI_SaisieConsommationHeuresCreuses__c > 0 &&
					this._record.VI_ConsommationGazKwHSaisieConso__c > 0) {
					this.estimationConsoCompleted = true;
					this.displayError = false;
					this.allFieldsNotFilled_MaConso = false;
					this.redLabelHP = false;
					this.redLabelHC = false;
					this.redLabelPuissanceCompteur = false;
					this.redLabelGaz = false;
				}
			}
			else {
				/*		if (this._record.VI_SaisieConsommationHeuresPleines__c !== null ||
			this._record.VI_PuissanceCompteurElecSaisieConso__c !== null ||
			this._record.VI_ConsommationGazKwHSaisieConso__c !== null) {
*/
				this.estimationConsoInitialized = true;
				this.redLabelHP = false;
				this.redLabelPuissanceCompteur = false;
				this.redLabelGaz = false;
				if (this.showFieldErrors === true) {
					if (this._record.VI_SaisieConsommationHeuresPleines__c === null ||
						this._record.VI_SaisieConsommationHeuresPleines__c === '' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '00' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '0000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '00000' ||
						this._record.VI_SaisieConsommationHeuresPleines__c.toString() === '000000') {
						this.redLabelHP = true;
					}
					if (this._record.VI_PuissanceCompteurElecSaisieConso__c === null) {
						this.redLabelPuissanceCompteur = true;
					}
					if (this._record.VI_ConsommationGazKwHSaisieConso__c === null ||
						this._record.VI_ConsommationGazKwHSaisieConso__c === '' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '0' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '00' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '000' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '0000' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '00000' ||
						this._record.VI_ConsommationGazKwHSaisieConso__c.toString() === '000000') {
						this.redLabelGaz = true;
					}
				}
				//			}
				if (this._record.VI_SaisieConsommationHeuresPleines__c !== null &&
					this._record.VI_PuissanceCompteurElecSaisieConso__c !== null &&
					this._record.VI_ConsommationGazKwHSaisieConso__c !== null &&
					this._record.VI_SaisieConsommationHeuresPleines__c > 0 &&
					this._record.VI_ConsommationGazKwHSaisieConso__c > 0) {
					this.estimationConsoCompleted = true;
					this.displayError = false;
					this.allFieldsNotFilled_MaConso = false;
					this.redLabelHP = false;
					this.redLabelPuissanceCompteur = false;
					this.redLabelGaz = false;
				}
			}
		}

		if (this.estimationConsoCompleted === true) {
			this.allFieldsNotFilled_MaConso = false;
			//console.log("sending detailsreleveremplis");
			//		if (this.stepsforinfo) {
			const dispatchEventSearch = new CustomEvent('estimationdone');
			this.dispatchEvent(dispatchEventSearch);
			this.estimationConsoAndStepsCompleted = true;
			/*		}
		else {
			const dispatchEventSearch = new CustomEvent('estimationinitialized');
			this.dispatchEvent(dispatchEventSearch);
		}*/
			//this.estimationConsoCompleted = false;
		}
		else if (this.estimationConsoCompleted === false && this.estimationConsoInitialized === true) {
			this.allFieldsNotFilled_MaConso = true;
			//console.log("sending detailsrelevesinities");
			const dispatchEventSearch = new CustomEvent('estimationinitialized');
			this.dispatchEvent(dispatchEventSearch);
			this.estimationConsoInitialized = false;
		}
		else {
			this.allFieldsNotFilled_MaConso = true;
		}


	}

	checkFieldsSouhaiteEstimer() {
		//console.log('TypeResidence validation' + this._record.VI_TypeResidenceSaisieConso__c);
		//console.log('isResidencePrincipale debut validation' + this.isResidencePrincipale);
		/*			if (this._record.VI_TypeResidenceSaisieConso__c !== null ||
					this._record.VI_TypeLogementSaisieConso__c !== null ||
					this._record.VI_SurfaceLogementSaisieConso__c !== null ||
					(this._record.VI_NombreOccupantLogementSaisieConso__c !== null && this._record.VI_NombreOccupantLogementSaisieConso__c !== '1') ||
					(this._record.VI_AnneeConstructionLogementSaisieConso__c !== null && this._record.VI_AnneeConstructionLogementSaisieConso__c !== 'Je ne sais pas') ||
					this._record.VI_DispositifChauffageSaisieConso__c !== null ||
					this._record.VI_EnergieChauffageSaisieConso__c !== null ||
					this._record.VI_EnergieCuissonSaisieConso__c !== null ||
					this._record.VI_DispositifEauChaudeSaisieConso__c !== null ||
					this._record.VI_EnergieEauChaudeSaisieConso__c !== null ||
					this._record.VI_CongelateurElecSaisieConso__c !== false ||
					this._record.VI_SecheLingeElecSaisieConso__c !== false ||
					this._record.VI_LaveLingeElecSaisieConso__c !== false ||
					this._record.VI_LaveVaisselleElecSaisieConso__c !== false ||
					this._record.VI_SaisieEstimationConsoElec_Linky__c !== null ||
					this._record.VI_SaisieEstimationConsoElec_HP_HC__c !== null) {
*/
		this.estimationConsoInitialized = true;
		this.redLabelTypeResidence = false;
		this.redLabelTypeLogement = false;
		this.redLabelSurfaceLogement = false;
		this.redLabelNombreOccupant = false;
		this.redLabelAnneeConstruction = false;
		this.redLabelUtilisationGaz = false;
		this.redLabelLinky = false;
		/* Start EVOL DDPCM 860*/
		this.redLabelGazPar = false;
		/* End EVOL DDPCM 860*/
		this.redLabelElec_HP_HC = false;
		if (this.showFieldErrors === true) {
			if (this._record.VI_TypeResidenceSaisieConso__c === null) {
				this.redLabelTypeResidence = true;
			}
			if (this._record.VI_TypeLogementSaisieConso__c === null) {
				this.redLabelTypeLogement = true;
			}
			if (this._record.VI_SurfaceLogementSaisieConso__c === null ||
				this._record.VI_SurfaceLogementSaisieConso__c < 1 ||
				this._record.VI_SurfaceLogementSaisieConso__c > 9999) {
				this.redLabelSurfaceLogement = true;
			}
			if (this._record.VI_NombreOccupantLogementSaisieConso__c === null ||
				this._record.VI_NombreOccupantLogementSaisieConso__c < 1 ||
				this._record.VI_NombreOccupantLogementSaisieConso__c > 10) {
				this.redLabelNombreOccupant = true;
			}
			if (this._record.VI_AnneeConstructionLogementSaisieConso__c === null) {
				this.redLabelAnneeConstruction = true;
			}
			if (this.isElectricite === false &&
				this.ChauffageIndividuelGazSaisieConso != true &&
				this.CuisineGazSaisieConso != true &&
				this.EauChaudeGazSaisieConso != true) {
				this.redLabelUtilisationGaz = true;
			}
			/*if(this.isElectricite === true &&
				this.ChauffageIndividuelElecSaisieConso != true &&
				this.CuisineElecSaisieConso != true &&
				this.EauChaudeElecSaisieConso != true) {
					this.redLabelUtilisationElec = true;
			}*/
			if (this._record.VI_SaisieEstimationConsoElec_Linky__c === null) {
				this.redLabelLinky = true;
			}
			/* Start EVOL DDPCM 860*/
			if (this._record.VI_SaisieEstimationConsoElec_GazPar__c === null) {
				this.redLabelGazPar = true;
			}
			/* End EVOL DDPCM 860*/
			if (this._record.VI_SaisieEstimationConsoElec_HP_HC__c === null) {
				this.redLabelElec_HP_HC = true;
			}
		}
		//}

		if (this._record.VI_TypeResidenceSaisieConso__c !== null &&
			this._record.VI_TypeLogementSaisieConso__c !== null &&
			this._record.VI_SurfaceLogementSaisieConso__c !== null &&
			this._record.VI_NombreOccupantLogementSaisieConso__c !== null &&
			this._record.VI_AnneeConstructionLogementSaisieConso__c !== null &&
			this._record.VI_SaisieEstimationConsoElec_HP_HC__c !== null) {
			console.log('All Conditions OK : ' + this.estimationConsoCompleted);
			if (this._record.VI_SurfaceLogementSaisieConso__c > 0 &&
				this._record.VI_SurfaceLogementSaisieConso__c < 10000) {
				if (this._record.VI_NombreOccupantLogementSaisieConso__c > 0 &&
					this._record.VI_NombreOccupantLogementSaisieConso__c < 11) {
					if (this.isElectricite || this._record.VI_DispositifChauffageSaisieConso__c === "Individuel" ||
						this._record.VI_DispositifEauChaudeSaisieConso__c === "Individuel" ||
						(this._record.VI_EnergieCuissonSaisieConso__c === "Gaz naturel" ||
							this._record.VI_EnergieCuissonSaisieConso__c === "Mixte")) {
						this.estimationConsoCompleted = true;
						console.log('this.isSouhaiteEstimer' + this.isSouhaiteEstimer);
						console.log('this.VI_ChoixEstimation__c' + this._record.VI_ChoixEstimation__c);
						this.isSouhaiteEstimer = true;
						console.log('Extra Conditions OK');
						console.log('estimationConsoCompleted : ' + this.estimationConsoCompleted);
					}

				}

			}
		}

		if (this.estimationConsoCompleted === true) {
			this.allFieldsNotFilled_Estimer = false;
			console.log('this.VI_ChoixEstimation__c inside' + this._record.VI_ChoixEstimation__c);
			//			if (this.stepsforinfo) {
			const dispatchEventSearch = new CustomEvent('estimationdone');
			this.dispatchEvent(dispatchEventSearch);
			this.estimationConsoAndStepsCompleted = true;
			/*		}
		else {
			const dispatchEventSearch = new CustomEvent('estimationinitialized');
			this.dispatchEvent(dispatchEventSearch);
		}*/
			//this.estimationConsoCompleted = false;

		}
		else if (this.estimationConsoCompleted === false && this.estimationConsoInitialized === true) {
			this.allFieldsNotFilled_Estimer = true;
			//console.log("sending detailsrelevesinities");
			const dispatchEventSearch = new CustomEvent('estimationinitialized');
			this.dispatchEvent(dispatchEventSearch);
			this.estimationConsoInitialized = false;
		}
		else {
			this.allFieldsNotFilled_Estimer = true;
		}
		//console.log('isResidencePrincipale fin validation' + this.isResidencePrincipale);

	}

	handlePlus(event) {
		if (event.key != 'Enter' && event.key != ' ') {
			event.preventDefault();
			event.stopPropagation();
			this._recordupdated = true;
			var NbOccupant = this._record.VI_NombreOccupantLogementSaisieConso__c;
			//console.log('NbOccupant bef :' +NbOccupant);
			//console.log('this._record.VI_NombreOccupantLogementSaisieConso__c bef : '+this._record.VI_NombreOccupantLogementSaisieConso__c);

			if (NbOccupant < 10) {
				NbOccupant = ++NbOccupant;
				this._record.VI_NombreOccupantLogementSaisieConso__c = NbOccupant.toString();
				this.StringNombreOccupantLogementSaisieConso = this._record.VI_NombreOccupantLogementSaisieConso__c.toString();
				this.template.querySelector('[data-id="NombreOccupants"]').value = this._record.VI_NombreOccupantLogementSaisieConso__c;
				this.colorGreyPlus = false;

				if (NbOccupant == 1) {
					this.colorGreyMinus = true;
				} else {
					this.colorGreyMinus = false;
				}

				if (NbOccupant == 10) {
					this.colorGreyPlus = true;
					this.StringNombreOccupantLogementSaisieConso += "+";
				}
				//console.log('NbOccupant aft :' +NbOccupant);
				//console.log('this._record.VI_NombreOccupantLogementSaisieConso__c aft : '+this._record.VI_NombreOccupantLogementSaisieConso__c);
			}
			else if (NbOccupant > 9) {
				this.colorGreyPlus = true;
				this.StringNombreOccupantLogementSaisieConso = this._record.VI_NombreOccupantLogementSaisieConso__c.toString();
				this.StringNombreOccupantLogementSaisieConso += "+";
			}
		}

	}

	handleMinus(event) {
		event.preventDefault();
		event.stopPropagation();
		this._recordupdated = true;
		var NbOccupant = this._record.VI_NombreOccupantLogementSaisieConso__c;
		//console.log('NbOccupant bef :' +NbOccupant);
		if (NbOccupant > 1) {
			NbOccupant = --NbOccupant;
			this._record.VI_NombreOccupantLogementSaisieConso__c = NbOccupant.toString();
			this.template.querySelector('[data-id="NombreOccupants"]').value = this._record.VI_NombreOccupantLogementSaisieConso__c;
			this.StringNombreOccupantLogementSaisieConso = this._record.VI_NombreOccupantLogementSaisieConso__c.toString();

			this.colorGreyMinus = false;

			if (NbOccupant > 9) {
				this.colorGreyPlus = true;
			} else {
				this.colorGreyPlus = false;
			}

			if (NbOccupant == 1) {
				this.colorGreyMinus = true;
			}
		}
		else if (NbOccupant == 1 || NbOccupant == 0) {
			this.colorGreyMinus = true;
			this.StringNombreOccupantLogementSaisieConso = this._record.VI_NombreOccupantLogementSaisieConso__c.toString();
			//console.log('colorGreyMinus :' +this.colorGreyMinus);
		}

	}

	removeNumberScroll(event) {
		event.target.blur();
	}

	getEstimationFromApex() {
		console.log('entered estimation from apex');
		console.log(this._record);
		getEstimation
			(
				{
					parcours: this._record
				}
			).then(result => {
				console.log('result' + result.parcours);
				console.log('result' + result.message);
				if (result.message != null) {
					console.log('message != null ' + result.message);
					this.error = error;
					this._title = 'Erreur';
					this.message = result.message;
					this.variant = 'error';
					this.showNotification();

				}
				else {
					this._record = result.parcours;
					if (this.stepsforinfo) {
						const dispatchEventSearch = new CustomEvent('passeretape');
						this.dispatchEvent(dispatchEventSearch);
					}
				}

			})
			.catch(error => {
				console.log('error' + error);
				this.error = error;
				this._title = 'Erreur';
				this.message = 'Une erreur s\'est produite lors de l\' estimation de la consommation';
				this.variant = 'error';
				this.showNotification();
			});
	}

	showNotification() {
		const evt = new ShowToastEvent({
			title: this._title,
			message: this.message,
			variant: this.variant,
		});
		this.dispatchEvent(evt);
	}

	// Open / close Modal
	openModalLinky() {
		this.isModalOpenBackgroundLinky = true;
		this.isModalLinkyOpen = true;
	}

	closeModalLinky() {
		this.isModalOpenBackgroundLinky = false;
		this.isModalLinkyOpen = false;
	}

	/* Start EVOL DDPCM 860*/
	openModalGazPar() {
		this.isModalOpenBackgroundGazPar = true;
		this.isModalGazParOpen = true;
	}

	closeModalGazPar() {
		this.isModalOpenBackgroundGazPar = false;
		this.isModalGazParOpen = false;
	}
	/* End EVOL DDPCM 860*/

	openModalHPHC() {
		this.isModalOpenBackgroundHPHC = true;
		this.isModalHPHCOpen = true;
	}

	closeModalHPHC() {
		this.isModalOpenBackgroundHPHC = false;
		this.isModalHPHCOpen = false;
	}

	handleDecimal(event) {
		console.log(event.key);
		if (event.key === ',' || event.key === '.' || event.key === 'Enter' || event.key === ' ') {
			event.preventDefault();
		}
	}

	handlePrecedent() {
		console.log("### précédent : ");
		const dispatchEventSearch = new CustomEvent('precedent');
		this.dispatchEvent(dispatchEventSearch);
		console.log("### précédent FIN : ");
	}

	onFormSubmit(event) {
		console.log('####submit');
		event.preventDefault();
		event.stopPropagation();
	}

	stopRefreshing(event) {
		event.target.blur();
	}

	/* Start DDPCM 1192*/
	emptyConstitutionPanier(){
		/* Start DDPCM 892 */
		this._record.VI_ChoixOffreSurParcoursPanierClient__c = null;
		/* End DDPCM 892 */
		this._record.VI_FinValidity__c = '';
		this._record.VI_DebutValidity__c = '';
		this._record.VI_CanalDeVente__c = '';
		this._record.VI_DescriptifPromotion__c = '';
		this._record.VI_NomPromotion__c = '';
		this._record.VI_LibelleSurFacture__c = '';
		this._record.VI_CodePromo__c = '';
		this._record.VI_NumPromotion__c = '';
		this._record.VI_CodePromoApplied__c = false;
		this.isCodePromo1Applied = false;
		this._record.VI_FinValidity2__c = '';
		this._record.VI_DebutValidity2__c = '';
		this._record.VI_CanalDeVente2__c = '';
		this._record.VI_DescriptifPromotion2__c = '';
		this._record.VI_NomPromotion2__c = '';
		this._record.VI_LibelleSurFacture2__c = '';
		this._record.VI_CodePromo2__c = '';
		this._record.VI_NumPromotion2__c = '';
		this._record.VI_CodePromoApplied2__c = false;
		this.isCodePromo2Applied = false;
	}
	/* End DDPCM 1192 */

}