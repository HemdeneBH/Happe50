import { LightningElement, wire, api, track } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import getParcours from '@salesforce/apex/VI_parcoursPurePlayersContent_Controller.getParcours';
import getParcoursDonnee from '@salesforce/apex/VI_parcoursPurePlayersContent_Controller.getParcoursDonnee';
import createParcours from '@salesforce/apex/VI_parcoursPurePlayersContent_Controller.createParcours';
import updateParcours from '@salesforce/apex/VI_parcoursPurePlayersContent_Controller.updateParcours';
import updateParcoursSF from '@salesforce/apex/VI_parcoursPurePlayersContent_Controller.updateParcoursWrapper';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ParcoursPurePlayersContent extends NavigationMixin(LightningElement) {
	modifSituation;
	modifClient;
	modifLocal;
	//Start DDPCM - 304
	modifEstimation;
	//End DDPCM - 304
	modifPanier;
	modifContrat;
	@track allIsCompleted = false;
	@api recordId;
	stepsForSubscription = true;
	stepsForRecap = true;
	stepsForInfoComplementaires = false;
	isDataLoaded = false;
	recordName;
	@track _stepInfo = stepInfo;
	record;
	error;
	recorddonnee;
	searchKey;
	stepOneDone = true;
	componentSouhait = false;
	componentBesoin = false;
	isFirstRender = true;
	currentStepValue;
	canChangePage = true;
	infosComplementairesStatutReleveEnCours = false;
	infosComplementairesStatutReleveTermine = false;
	estimationConsommationEnCours = false;
	checksaisie = false;
	estimationConsommationTermine = false;
	isClickBouttonPaiement = false;
	isPrelevementAuto = false;
	/* Start DDPCM 786 */
	reopenPopUpMensualisation = false;
	/* End DDPCM 786 */


	_title = 'Erreur';
	message = 'Erreur';
	variant = 'error';
	checkStepStatus() {
		if (this.record.VI_ChoixParcours__c != "") {
			this._stepInfo.steps[0].status = "completed";
		}
	}
	recordUpdated = false;
	emailChangedOnly = true;
	// Start DDPCM 1156
	gestionChangedOnly = true;
	// End DDPCM 1156
	connectedCallback() {
		if (this.recordId !== undefined) {
			getParcours({
				parcoursID: this.recordId
			})
				.then(data => {
					this.record = data;
					//this.handleUndefinedValues('VI_TelephoneRechercheClient__c');
					this.error = undefined;
					this.recordName = data.Name;
					this.currentStep = this._stepInfo[0].steps[0].name;
					this.isDataLoaded = true;
					//Check identification besoin etape status
					if (this.record.VI_ChoixParcours__c != null) {
						this._stepInfo[0].steps[0].status = "completed";
					}
					else {
						this._stepInfo[0].steps[0].status = "nonInitialized";
					}
					if (this.record.VI_ChoixEnergie__c != null) {
						this._stepInfo[0].steps[1].status = "completed";
					}
					else {
						this._stepInfo[0].steps[1].status = "nonInitialized";
					}
					if (this.record.VI_ChoixEnergie__c != null && this.record.VI_ChoixParcours__c != null) {
						this._stepInfo[0].status = "completed";
					}
					else if ((this.record.VI_ChoixEnergie__c == null && this.record.VI_ChoixParcours__c != null)
						|| (this.record.VI_ChoixEnergie__c != null && this.record.VI_ChoixParcours__c == null)) {
						this._stepInfo[0].status = "available";
					}
					else {
						this._stepInfo[0].status = "nonInitialized";
					}

					//Check Identification client etape status
					if (this.record.VI_Contact__c != null) {
						this._stepInfo[1].status = "completed";
					}
					else if (this.record.Tech_IdentificationClientInitiee__c === true) {
						this._stepInfo[1].status = "available";
					}
					else {
						this._stepInfo[1].status = "nonInitialized";
					}

					//Check Identification Local etape status
					if (this.record.VI_PDLRechercheLocal__c != null || this.record.VI_PCERechercheLocal__c != null
						|| this.record.VI_LocalNonIdentifieGenerationCase__c === true) {
						this._stepInfo[2].status = "completed";
					}
					else if (this.record.VI_TypeRechercheLocal__c != null) {
						this._stepInfo[2].status = "available";
					}
					else {
						this._stepInfo[2].status = "nonInitialized";
					}
					//Check if we can access infos supplementaires && Constitution Panier
					if (this._stepInfo[0].status === "completed" &&
						this._stepInfo[1].status === "completed" &&
						this._stepInfo[2].status === "completed") {
						this.stepsForInfoComplementaires = true;
						if (this.record.VI_InfosCompl_ChoixReleveCompteur__c === "Passer cette étape") {
							this._stepInfo[5].steps[1].status = "completed";
						}
						else {
							this.checkInfosComplementairesReleve();
						}
						this.checkInfosComplementairesDate();
						if (this.record.VI_ChoixOffreSurParcoursPanierClient__c != null) {
							this._stepInfo[4].steps[0].status = "completed";
						}
						else {
							this._stepInfo[4].steps[0].status = "nonInitialized";
						}
						this._stepInfo[4].steps[1].status = "completed";
						if (this.record.VI_AssuranceFactureCocheeAF__c === true &&
							this.record.VI_AF_Enregistre__c === false) {
							this._stepInfo[4].steps[1].status = "available";
						}
						if (this._stepInfo[4].steps[1].status === "available") {
							this._stepInfo[4].status = "available";
						}
						else {
							if (this._stepInfo[4].steps[0].status === "nonInitialized") {
								this._stepInfo[4].status = "available";
							}
							else {
								this._stepInfo[4].status = "completed";
							}
						}
					}
					else {
						this._stepInfo[5].status = "disabled";
						this._stepInfo[5].steps[0].status = "disabled";
						this._stepInfo[5].steps[1].status = "disabled";
						this._stepInfo[4].status = "disabled";
						this._stepInfo[4].steps[0].status = "disabled";
						this._stepInfo[4].steps[1].status = "disabled";
					}
					//Check Estimation de la consommation etape status
					this._stepInfo[3].status = "nonInitialized";
					if (this.record.VI_ChoixEstimation__c === 'Passer cette étape') {
						this._stepInfo[3].status = "completed";
					}
					else {
						this.handleEstimationConso();
						if (this.estimationConsommationTermine === true) {
							this._stepInfo[3].status = "completed";
						}
						else if (this.estimationConsommationEnCours === true) {
							this._stepInfo[3].status = "available";
						}
						else {
							this._stepInfo[3].status = "nonInitialized";
						}
					}

					//Check if we can access subscripton
					if (this._stepInfo[0].status === "completed" &&
						this._stepInfo[1].status === "completed" &&
						this._stepInfo[2].status === "completed" &&
						this._stepInfo[3].status === "completed" &&
						this._stepInfo[4].status === "completed") {
						this.stepsForSubscription = false;
					}

					//check if we can access paiement
					if (this._stepInfo[5].status === 'disabled') {
						this._stepInfo[6].status = 'disabled';
						this._stepInfo[7].status = "disabled";
					}
					else if (this.record.VI_ChoixMoyenPaiement__c === 'Autre' ||
						(this.record.VI_IBANMoyendePaiement__c !== 'Autre' && this.record.VI_Id_coordonnees_bancaires__c != null) ||
						this.record.VI_IBANEnSelfCare__c === true) {
						this._stepInfo[6].status = "completed";
					}
					else if (this.record.VI_NomTitulaireMoyendePaiement__c != null && this.record.VI_IBANMoyendePaiement__c != null) {
						this._stepInfo[6].status = 'available';
						this._stepInfo[7].status = "disabled";
					}

					/* Start DDPCM - 787 */
					if (this.record.VI_TypeParcours__c != 'PURE PLAYERS') {
						this._stepInfo[6].label = 'Services de gestion';
					}
					/* End DDPCM - 787 */

					/* Start DDPCM 1586 */
					if ((this.record.VI_EdocsMoyensPaiement__c == 'Oui' || this.record.VI_EdocsMoyensPaiement__c == 'Non') || 
							(this.record.VI_ChoixMensualisation__c == 'Oui' || this.record.VI_ChoixMensualisation__c == 'Non')) {
							this._stepInfo[6].status = "available";
					}
					if ((this.record.VI_EdocsMoyensPaiement__c == 'Oui' || this.record.VI_EdocsMoyensPaiement__c == 'Non') && 
						(this.record.VI_ChoixMensualisation__c == 'Oui' || this.record.VI_ChoixMensualisation__c == 'Non')) {
							this._stepInfo[6].status = "completed";
					}	
					/* End DDPCM 1586 */

					//Check if we can access recap
					if (this._stepInfo[0].status === "completed" &&
						this._stepInfo[1].status === "completed" &&
						this._stepInfo[2].status === "completed" &&
						this._stepInfo[3].status === "completed" &&
						this._stepInfo[4].status === "completed" &&
						this._stepInfo[5].status === "completed" &&
						this._stepInfo[6].status === "completed") {
						this.stepsForRecap = false;
						this.currentStep = 'Recapitulatif';
						if (this.record.VI_EmailEnvoye__c === true) {
							this._stepInfo[7].status = 'completed';
						}
						else {
							this._stepInfo[7].status = 'nonInitialized';
						}
					}
					else {
						this._stepInfo[7].status = 'disabled';
					}

					//current step definition
					if (this._stepInfo[0].steps[0].status != "completed") {
						this.currentStep = this._stepInfo[0].steps[0].name;
					}
					else if (this._stepInfo[0].steps[1].status != "completed") {
						this.currentStep = this._stepInfo[0].steps[1].name;
					}
					else if (this._stepInfo[1].status != "completed") {
						this.currentStep = this._stepInfo[1].name;
					}
					else if (this._stepInfo[2].status != "completed") {
						this.currentStep = this._stepInfo[2].name;
					}
					else if (this._stepInfo[3].status != "completed") {
						this.currentStep = this._stepInfo[3].name;
					}
					else if (this._stepInfo[4].steps[0].status != "completed") {
						this.currentStep = this._stepInfo[4].steps[0].name;
					}
					else if (this._stepInfo[4].steps[1].status != "completed") {
						this.currentStep = this._stepInfo[4].steps[1].name;
					}
					else if (this._stepInfo[5].status != "completed") {
						this.currentStep = this._stepInfo[5].name;
					}
					else if (this._stepInfo[6].status != "completed") {
						this.currentStep = this._stepInfo[6].name;
					}
					else {
						this.currentStep = this._stepInfo[7].name;
					}
				})
				.catch(error => {
					console.log('ERROR')
					this.error = error;
					console.error(this.error);
					console.error('e.name => ' + this.error.name);
					console.error('e.message => ' + this.error.message);
					console.error('e.stack => ' + this.error.stack);
				});
		}
		else {
			this.navigateToParcoursPage();
		}

		getParcoursDonnee()
			.then(data => {
				console.log("#### getParcoursDonnee data : ")
				console.log(data)

				this.recorddonnee = data;
			})
			.catch(error => {
				console.log('ERROR')
				this.error = error;
				console.error(this.error);
				console.error('e.name => ' + this.error.name);
				console.error('e.message => ' + this.error.message);
				console.error('e.stack => ' + this.error.stack);
			});
	}

	handleUndefinedValues(recordField) {
		if (typeof this.record[recordField] === "undefined") {
			this.record[recordField] = '';
		}
	}


	checkStatutRecap() {
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed" &&
			this._stepInfo[3].status === "completed" &&
			this._stepInfo[4].status === "completed" &&
			this._stepInfo[5].status === "completed" &&
			this._stepInfo[6].status === "completed") {
			if (this.record.VI_EmailEnvoye__c === true) {
				this._stepInfo[7].status = 'completed';
			}
			else {
				this._stepInfo[7].status = 'nonInitialized';
			}
		}
	}

	/* Start DDPCM 1586 */
	recolorateFormerStatus() {
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
				//Check status serives de paiement ou gestion de paiement
				if (this.record.VI_TypeParcours__c != 'PURE PLAYERS') {
					if ((this.record.VI_EdocsMoyensPaiement__c == 'Oui' || this.record.VI_EdocsMoyensPaiement__c == 'Non') || 
						(this.record.VI_ChoixMensualisation__c == 'Oui' || this.record.VI_ChoixMensualisation__c == 'Non')) {
						this._stepInfo[6].status = "available";
					}
					if ((this.record.VI_EdocsMoyensPaiement__c == 'Oui' || this.record.VI_EdocsMoyensPaiement__c == 'Non') && 
						(this.record.VI_ChoixMensualisation__c == 'Oui' || this.record.VI_ChoixMensualisation__c == 'Non')) {
							this._stepInfo[6].status = "completed";
					}
				}
				else {
					if (this.record.VI_ChoixMoyenPaiement__c === 'Autre' ||
					(this.record.VI_IBANMoyendePaiement__c !== 'Autre' && this.record.VI_Id_coordonnees_bancaires__c != null) ||
					(this.record.VI_IBANEnSelfCare__c === true)) {
						this._stepInfo[6].status = "completed";
					}
				}
				//Check status infos supplementaires
				this.stepsForInfoComplementaires = true;
				if (this.record.VI_InfosCompl_ChoixReleveCompteur__c === "Passer cette étape") {
					this._stepInfo[5].steps[1].status = "completed";
				}
				else {
					this.checkInfosComplementairesReleve();
				}
				this.checkInfosComplementairesDate();
		}
	}
	/* End DDPCM 1586 */

	navigateToParcoursPage() {
		createParcours()
			.then(result => {
				this.recordId = result;
				this[NavigationMixin.Navigate]({
					type: 'standard__recordPage',
					attributes: {
						recordId: result,
						objectApiName: 'VI_Parcours__c',
						actionName: 'view'
					}
				});
			})
			.catch(error => {
				this.error = error;
			});

	}

	/******Choix de la situation Methods******/
	//On SouhaitChange make the current Step completed and move the next step
	handleSouhaitChange(event) {
		this.emailChangedOnly = false;
		// Start DDPCM 1156
		this.gestionChangedOnly = false;
		// End DDPCM 1156
		let souhait = event.detail.detail.value;
		this.record = { ...this.record, VI_ChoixParcours__c: souhait };
		if (souhait != null) {
			this._stepInfo[0].steps[0].status = "completed";
		}
		if (this._stepInfo[0].steps[1].status === "completed") { //if choix de l'énergie is completed move the parent step to completed ( green)
			this._stepInfo[0].status = "completed";
			if (this._stepInfo[1].status === "completed" && this._stepInfo[2].status === "completed"
				&& this._stepInfo[5].status === "disabled") {
				this._stepInfo[5].steps[0].status = "nonInitialized";
				this._stepInfo[5].steps[1].status = "nonInitialized";
				this._stepInfo[5].status = "nonInitialized";
				this._stepInfo[4].status = "available";
				this._stepInfo[4].steps[0].status = "nonInitialized";
				this._stepInfo[4].steps[1].status = "completed";
				this._stepInfo[6].status = "nonInitialized";

			}
		}
		else {
			this._stepInfo[0].status = "available";
		}
		if (this._stepInfo[5].status !== "disabled") {
			this.record.VI_InfosCompl_DateContratEffectif__c = null;
			this.record.VI_InfosCompl_MiseEnServiceUrgente__c = false;
			this._stepInfo[5].steps[0].status = "nonInitialized";
			if (this._stepInfo[5].steps[1].status === 'nonInitialized') {
				this._stepInfo[5].status = 'nonInitialized';
				this._stepInfo[7].status = "disabled";
			}
			else if (this._stepInfo[5].steps[1].status === 'available' ||
				this._stepInfo[5].steps[1].status === 'completed') {
				this._stepInfo[5].status = 'available';
				this._stepInfo[7].status = "disabled";
			}
		}

		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
			this.stepsForInfoComplementaires = true;
		}

		this._stepInfo[7].status = "disabled";

		this.updateCompleteParcours();
		this.checkStatutRecap();
		this.currentStep = "energy";
	}

	handleSuivantSouhait(event) {
		this.currentStep = "energy";
	}

	//Check infos complementaires status
	checkInfosComplementairesReleve() {
		this.infosComplementairesStatutReleveTermine = false;
		this.infosComplementairesStatutReleveEnCours = false;
		if (this.record.VI_ChoixEnergie__c === "Gaz") {
			if (this.record.VI_InfosCompl_IndexGaz__c !== undefined &&
				this.record.VI_InfosCompl_IndexGaz__c !== null) {
				if (this.record.VI_InfosCompl_IndexGaz__c.toString().length >= 1) {
					this.infosComplementairesStatutReleveTermine = true;
				}
				else {
					this.infosComplementairesStatutReleveEnCours = true;
				}
			}
		}
		else if (this.record.VI_ChoixEnergie__c === "Electricité") {
			if (this.record.VI_InfosCompl_HP_HC__c) {
				if ((this.record.VI_InfosCompl_HeuresPleinesElec__c !== undefined && this.record.VI_InfosCompl_HeuresPleinesElec__c !== null) ||
					(this.record.VI_InfosCompl_HeuresCreusesElec__c !== undefined && this.record.VI_InfosCompl_HeuresCreusesElec__c !== null)) {
					this.infosComplementairesStatutReleveEnCours = true;
				}
				if ((this.record.VI_InfosCompl_HeuresPleinesElec__c !== undefined && this.record.VI_InfosCompl_HeuresPleinesElec__c !== null) &&
					(this.record.VI_InfosCompl_HeuresCreusesElec__c !== undefined && this.record.VI_InfosCompl_HeuresCreusesElec__c !== null)) {

					if (this.record.VI_InfosCompl_HeuresPleinesElec__c.toString().length >= 1 &&
						this.record.VI_InfosCompl_HeuresCreusesElec__c.toString().length >= 1) {
						this.infosComplementairesStatutReleveTermine = true;
					}
				}
			}
			else {
				if (this.record.VI_InfosCompl_IndexElec__c !== undefined && this.record.VI_InfosCompl_IndexElec__c !== null) {
					if (this.record.VI_InfosCompl_IndexElec__c.toString().length >= 1) {
						this.infosComplementairesStatutReleveTermine = true;
					}
					else {
						this.infosComplementairesStatutReleveEnCours = true;
					}
				}
			}
		}
		else if (this.record.VI_ChoixEnergie__c === "Electricité + Gaz") {
			if (this.record.VI_InfosCompl_HP_HC__c) {
				if ((this.record.VI_InfosCompl_HeuresPleinesElec__c !== undefined && this.record.VI_InfosCompl_HeuresPleinesElec__c !== null) ||
					(this.record.VI_InfosCompl_HeuresCreusesElec__c !== undefined && this.record.VI_InfosCompl_HeuresCreusesElec__c !== null) ||
					(this.record.VI_InfosCompl_IndexGaz__c !== undefined && this.record.VI_InfosCompl_IndexGaz__c !== null)) {
					this.infosComplementairesStatutReleveEnCours = true;
				}

				if ((this.record.VI_InfosCompl_HeuresPleinesElec__c !== undefined && this.record.VI_InfosCompl_HeuresPleinesElec__c !== null) &&
					(this.record.VI_InfosCompl_HeuresCreusesElec__c !== undefined && this.record.VI_InfosCompl_HeuresCreusesElec__c !== null) &&
					(this.record.VI_InfosCompl_IndexGaz__c !== undefined && this.record.VI_InfosCompl_IndexGaz__c !== null)) {
					if (this.record.VI_InfosCompl_HeuresPleinesElec__c.toString().length >= 1 &&
						this.record.VI_InfosCompl_HeuresCreusesElec__c.toString().length >= 1 &&
						this.record.VI_InfosCompl_IndexGaz__c.toString().length >= 1) {
						this.infosComplementairesStatutReleveTermine = true;
					}
				}
			}
			else {
				if ((this.record.VI_InfosCompl_IndexElec__c !== undefined && this.record.VI_InfosCompl_IndexElec__c !== null) ||
					(this.record.VI_InfosCompl_IndexGaz__c !== undefined && this.record.VI_InfosCompl_IndexGaz__c !== null)) {
					this.infosComplementairesStatutReleveEnCours = true;
				}
				if ((this.record.VI_InfosCompl_IndexElec__c !== undefined && this.record.VI_InfosCompl_IndexElec__c !== null) &&
					(this.record.VI_InfosCompl_IndexGaz__c !== undefined && this.record.VI_InfosCompl_IndexGaz__c !== null)) {
					if (this.record.VI_InfosCompl_IndexElec__c.toString().length >= 1 &&
						this.record.VI_InfosCompl_IndexGaz__c.toString().length >= 1) {
						this.infosComplementairesStatutReleveTermine = true;
					}
				}
			}
		}
		if (this.infosComplementairesStatutReleveTermine === true) {
			this.handleDetailsReleveRemplis();
		}
		else if (this.infosComplementairesStatutReleveTermine === false && this.infosComplementairesStatutReleveEnCours === true) {
			this.handleDetailsRelevesInities();
		}
		else {
			this._stepInfo[5].steps[1].status = "nonInitialized";
			if (this._stepInfo[5].steps[0].status === "completed" || this._stepInfo[5].steps[0].status === "available") {
				this._stepInfo[5].status = "available";
				this._stepInfo[7].status = "disabled";
			}
			else {
				this._stepInfo[5].status = "nonInitialized";
				this._stepInfo[7].status = "disabled";
			}
		}
	}

	udParcours() {
		let paiementEtape = this.template.querySelector('c-parcours-p-p-saisie-paiements');
		this.record = paiementEtape.record;
		if (paiementEtape.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = true;
			// End DDPCM 1156
			this.updateCompleteParcours();
		}
	}

	/* Start DDPCM-901 */

	saveRecord() {
		let x = '';
		if (this.currentStep === "situation") {
			x = 'c-parcours-pp-ident-souhait';
		}
		if (this.currentStep === "energy") {
			x = 'c-parcours-pp-ident-besoin';
		}
		if (this.currentStep === "client_energy") {
			x = 'c-parcours-p-p-recherche-client';
		}
		if (this.currentStep === "identification_local") {
			x = 'c-parcours-p-p-identification-local';
		}
		if (this.currentStep === "EstimationConsommation") {
			x = 'c-parcours-p-p-estimation-consommation';
		}
		if (this.currentStep === "ConstitutionPanier") {
			x = 'c-parcours-p-p-constitution-panier';
		}
		if (this.currentStep === "DateEffetContrat") {
			x = 'c-parcours-p-p-info-complementaires';
		}
		if (this.currentStep === "Saisie_moyen_de_paiement") {
			x = 'c-parcours-p-p-saisie-paiements';
		}
		if (this.currentStep === "Recapitulatif") {
			x = 'c-parcours-p-p-recap-souscription';
		}
		let roundbutton = this.template.querySelector(x);
		this.record = roundbutton.record;
		if (roundbutton.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
			this.updateCompleteParcours();
		}
	}

	/* End DDPCM-901 */
	//update parcours from recap
	updateParcoursRecap() {
		let recapSouscription = this.template.querySelector('c-parcours-p-p-recap-souscription');
		this.record = recapSouscription.record;
		if (recapSouscription.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
			this.updateCompleteParcours();
		}
	}

	checkInfosComplementairesDate() {
		if (this.record.VI_InfosCompl_DateContratEffectif__c !== undefined &&
			this.record.VI_InfosCompl_DateContratEffectif__c !== null) {
			this.handleDateContratRemplie();
		}
		else {
			this._stepInfo[5].steps[0].status = "nonInitialized";
			if (this._stepInfo[5].steps[1].status === "completed" || this._stepInfo[5].steps[1].status === "available") {
				this._stepInfo[5].status = "available";
				this._stepInfo[7].status = "disabled";
			}
			else {
				this._stepInfo[5].status = "nonInitialized";
				this._stepInfo[7].status = "disabled";
			}
		}
	}

	handledateContratVide(event) {
		this._stepInfo[5].steps[0].status = "nonInitialized";
		if (this._stepInfo[5].steps[1].status === "completed" ||
			this._stepInfo[5].steps[1].status === "available") {
			this._stepInfo[5].status = "available";
			this._stepInfo[7].status = "disabled";
		}
		else {
			this._stepInfo[5].status = "nonInitialized";
			this._stepInfo[7].status = "disabled";
		}
	}

	handlePasserEtapeInfoCompl(event) {
		this.handleChange(event);
		this.currentStep = "Saisie_moyen_de_paiement";
		this._stepInfo[5].steps[1].status = "completed";
		this._stepInfo[6].steps[1].status = "nonInitialized";
		if (this._stepInfo[5].steps[0].status === "completed") {
			this._stepInfo[5].status = "completed";
			this.checkStatutRecap();
		}
		else {
			this._stepInfo[5].status = "available";
			this._stepInfo[7].status = "disabled";
		}
	}

	//statut estimation conso
	handleEstimationConso() {
		if (this.record.VI_ChoixEstimation__c === 'Saisir la consommation d\'énergie') {
			this.checkFieldsConnaisMaConso();
		}

		else if (this.record.VI_ChoixEstimation__c === 'Estimer la consommation d\'énergie') {
			this.checkFieldsSouhaiteEstimer();
		}
	}

	checkFieldsConnaisMaConso() {
		if (this.record.VI_ChoixEnergie__c === 'Electricité') {
			if (this.record.VI_SaisieConsommationElec_HP_HC__c === true) {
				if (this.record.VI_SaisieConsommationHeuresPleines__c !== undefined ||
					this.record.VI_SaisieConsommationHeuresCreuses__c !== undefined ||
					this.record.VI_PuissanceCompteurElecSaisieConso__c !== undefined) {
					this.estimationConsommationEnCours = true;
				}
				if (this.record.VI_SaisieConsommationHeuresPleines__c !== undefined &&
					this.record.VI_SaisieConsommationHeuresCreuses__c !== undefined &&
					this.record.VI_PuissanceCompteurElecSaisieConso__c !== undefined &&
					this.record.VI_SaisieConsommationHeuresPleines__c > 0 &&
					this.record.VI_SaisieConsommationHeuresCreuses__c > 0 &&
					this.stepsForInfoComplementaires) {
					this.estimationConsommationTermine = true;
				}
			}
			else {
				if (this.record.VI_SaisieConsommationHeuresPleines__c !== undefined ||
					this.record.VI_PuissanceCompteurElecSaisieConso__c !== undefined) {
					this.estimationConsommationEnCours = true;
				}
				if (this.record.VI_SaisieConsommationHeuresPleines__c !== undefined &&
					this.record.VI_PuissanceCompteurElecSaisieConso__c !== undefined &&
					this.record.VI_SaisieConsommationHeuresPleines__c > 0 &&
					this.stepsForInfoComplementaires) {
					this.estimationConsommationTermine = true;
				}
			}

		}

		if (this.record.VI_ChoixEnergie__c === 'Gaz') {
			if (this.record.VI_ConsommationGazKwHSaisieConso__c !== undefined) {
				this.estimationConsommationEnCours = true;
			}

			if (this.record.VI_ConsommationGazKwHSaisieConso__c !== undefined &&
				this.record.VI_ConsommationGazKwHSaisieConso__c > 0 &&
				this.stepsForInfoComplementaires) {
				this.estimationConsommationTermine = true;
			}
		}

		if (this.record.VI_ChoixEnergie__c === 'Electricité + Gaz') {
			if (this.record.VI_SaisieConsommationElec_HP_HC__c === true) {
				if (this.record.VI_SaisieConsommationHeuresPleines__c !== undefined ||
					this.record.VI_SaisieConsommationHeuresCreuses__c !== undefined ||
					this.record.VI_PuissanceCompteurElecSaisieConso__c !== undefined ||
					this.record.VI_ConsommationGazKwHSaisieConso__c !== undefined) {
					this.estimationConsommationEnCours = true;
				}
				if (this.record.VI_SaisieConsommationHeuresPleines__c !== undefined &&
					this.record.VI_SaisieConsommationHeuresCreuses__c !== undefined &&
					this.record.VI_PuissanceCompteurElecSaisieConso__c !== undefined &&
					this.record.VI_ConsommationGazKwHSaisieConso__c !== undefined &&
					this.record.VI_SaisieConsommationHeuresPleines__c > 0 &&
					this.record.VI_SaisieConsommationHeuresCreuses__c > 0 &&
					this.record.VI_ConsommationGazKwHSaisieConso__c > 0 &&
					this.stepsForInfoComplementaires) {
					this.estimationConsommationTermine = true;
				}
			}
			else {
				if (this.record.VI_SaisieConsommationHeuresPleines__c !== undefined ||
					this.record.VI_PuissanceCompteurElecSaisieConso__c !== undefined ||
					this.record.VI_ConsommationGazKwHSaisieConso__c !== undefined) {
					this.estimationConsommationEnCours = true;
				}
				if (this.record.VI_SaisieConsommationHeuresPleines__c !== undefined &&
					this.record.VI_PuissanceCompteurElecSaisieConso__c !== undefined &&
					this.record.VI_ConsommationGazKwHSaisieConso__c !== undefined &&
					this.record.VI_SaisieConsommationHeuresPleines__c > 0 &&
					this.record.VI_ConsommationGazKwHSaisieConso__c > 0 &&
					this.stepsForInfoComplementaires) {
					this.estimationConsommationTermine = true;
				}
			}
		}
	}


	checkFieldsSaisiePaiement() {
		if (this.record.VI_ChoixMoyenPaiement__c != 'Prélèvement automatique' ||
			this.record.VI_Id_coordonnees_bancaires__c !== undefined) {
			this.checksaisie = true;
		}

	}


	checkFieldsSouhaiteEstimer() {
		if (this.record.VI_TypeResidenceSaisieConso__c !== undefined ||
			this.record.VI_TypeLogementSaisieConso__c !== undefined ||
			this.record.VI_SurfaceLogementSaisieConso__c !== undefined ||
			(this.record.VI_NombreOccupantLogementSaisieConso__c !== undefined && this.record.VI_NombreOccupantLogementSaisieConso__c !== "1") ||
			(this.record.VI_AnneeConstructionLogementSaisieConso__c !== undefined && this.record.VI_AnneeConstructionLogementSaisieConso__c !== "Je ne sais pas")
			|| (
				this.record.VI_ChoixEnergie__c === 'Gaz' &&
				(
					this.record.VI_EnergieCuissonSaisieConso__c === 'Gaz naturel' ||
					this.record.VI_DispositifChauffageSaisieConso__c === 'Individuel' ||
					this.record.VI_EnergieEauChaudeSaisieConso__c === 'Gaz naturel'
				)
			)
			|| (
				this.record.VI_ChoixEnergie__c === 'Electricité + Gaz' &&
				(
					this.record.VI_EnergieCuissonSaisieConso__c === 'Gaz naturel' ||
					this.record.VI_EnergieCuissonSaisieConso__c === 'Mixte' ||
					this.record.VI_DispositifChauffageSaisieConso__c === 'Individuel' ||
					this.record.VI_EnergieEauChaudeSaisieConso__c === 'Gaz naturel'
				)
			)
		) {
			this.estimationConsommationEnCours = true;
		}

		if (this.record.VI_TypeResidenceSaisieConso__c !== undefined &&
			this.record.VI_TypeLogementSaisieConso__c !== undefined &&
			this.record.VI_SurfaceLogementSaisieConso__c !== undefined &&
			this.record.VI_NombreOccupantLogementSaisieConso__c !== undefined &&
			this.record.VI_AnneeConstructionLogementSaisieConso__c !== undefined
			&& (
				(
					this.record.VI_ChoixEnergie__c === 'Gaz' &&
					(
						this.record.VI_EnergieCuissonSaisieConso__c === 'Gaz naturel' ||
						this.record.VI_DispositifChauffageSaisieConso__c === 'Individuel' ||
						this.record.VI_EnergieEauChaudeSaisieConso__c === 'Gaz naturel' ||
						this.record.VI_DispositifEauChaudeSaisieConso__c === 'Individuel'
					)
				)
				||
				(
					this.record.VI_ChoixEnergie__c === 'Electricité + Gaz' &&
					(
						this.record.VI_EnergieCuissonSaisieConso__c === 'Gaz naturel' ||
						this.record.VI_EnergieCuissonSaisieConso__c === 'Mixte' ||
						this.record.VI_DispositifChauffageSaisieConso__c === 'Individuel' ||
						this.record.VI_EnergieEauChaudeSaisieConso__c === 'Gaz naturel' ||
						this.record.VI_DispositifEauChaudeSaisieConso__c === 'Individuel'
					)
				)
				||
				this.record.VI_ChoixEnergie__c === 'Electricité'
			) &&
			this.stepsForInfoComplementaires) {
			if (this.record.VI_SurfaceLogementSaisieConso__c > 8 &&
				this.record.VI_SurfaceLogementSaisieConso__c < 1000) {
				if (this.record.VI_NombreOccupantLogementSaisieConso__c > 0 &&
					this.record.VI_NombreOccupantLogementSaisieConso__c < 21) {
					this.estimationConsommationTermine = true;
				}
			}
		}
	}

	/******Choix de l'énergie Methods******/
	//On BesoinChange make the current Step completed and move the next step
	handleBesoinChange(event) {
		this.emailChangedOnly = false;
		// Start DDPCM 1156
		this.gestionChangedOnly = false;
		// End DDPCM 1156
		let besoin = event.detail.detail.value;
		let oldbesoin = this.record.VI_ChoixEnergie__c;
		this.record = { ...this.record, VI_ChoixEnergie__c: besoin };
		if (besoin != null) {
			this._stepInfo[0].steps[1].status = "completed";
			//re-initialized l'etape constitution du panier
			if (this._stepInfo[4].status !== "disabled") {
				this._stepInfo[4].status = "available";
				this._stepInfo[4].steps[0].status = "nonInitialized";
				this._stepInfo[4].steps[1].status = "completed";
			}
			this.record.VI_ChoixOffreSurParcoursPanierClient__c = null;
			this.record.VI_AjustementMensualitesPanierClient__c = null;
			this.record.VI_MontantdelaMensualitePanierClient__c = null;
			this.record.VI_EleckWhHTPanierClient__c = null;
			this.record.VI_EleckWhTTCPanierClient__c = null;
			this.record.VI_GazkWhHTPanierClient__c = null;
			this.record.VI_AbonnementAnnuelGazHTPanierClient__c = null;
			this.record.VI_AbonnementAnnuelGazTTCPanierClient__c = null;
			this.record.VI_AbonnementAnnuelElecHTPanierClient__c = null;
			this.record.VI_AbonnementAnnuelElecTTCPanierClient__c = null;
			this.record.VI_CodePromotionnelPanierClient__c = null;
			this.record.VI_CodeOffrePanierClient__c = null;
			this.record.VI_OffreChoisieElecPanierClient__c = null;
			this.record.VI_OffreChoisieGazPanierClient__c = null;
			this.record.VI_Code_pack__c = null;
			this.record.VI_LibelleOffrePanierClient__c = null;
			this.record.VI_GazkWhTTCPanierClient__c = null;
			this.record.VI_LibelleOptionPanierClient__c = null
			this.record.VI_MontantOptionPanierClient__c = null;
			this.record.VI_CodeOptionPanierClient__c = null;
			this.record.VI_CodeOptionGazPanierClient__c = null;
			this.record.VI_ServiceOptionVerteElecPrixAbHT__c = null;
			this.record.VI_ServiceOptionVerteElecPrixAbTTC__c = null;
			this.record.VI_ServiceOptionVerteGazPrixAbHT__c = null;
			this.record.VI_LibelleOptionGazPanierClient__c = null;
			this.record.VI_ServiceOptionVerteGazPrixAbTTC__c = null;

			if (oldbesoin !== besoin) {
				if (oldbesoin !== "Electricité + Gaz" && besoin === "Electricité + Gaz") {
					if (this._stepInfo[3].status === "completed") {
						this._stepInfo[3].status = "available"
					}
					if (this._stepInfo[5].status !== "disabled" &&
						this._stepInfo[5].steps[1].status !== "nonInitialized") {
						this._stepInfo[5].steps[1].status = 'available';
						this._stepInfo[5].status = 'available';
						this._stepInfo[7].status = "disabled";
					}
				}
				if (besoin === "Electricité" && oldbesoin === "Gaz") {
					this.record.VI_ConsommationGazKwHSaisieConso__c = null;
					if ((this._stepInfo[3].status === "completed" || this._stepInfo[3].status === "available")
						&& this.record.VI_ChoixEstimation__c === 'Saisir la consommation d\'énergie') {
						this._stepInfo[3].status = "nonInitialized"
					}
				}
				if (oldbesoin === "Electricité + Gaz" && besoin === "Electricité") {
					if (this._stepInfo[3].status === "completed") {
						this._stepInfo[3].status = "available";
					}
				}
				if (oldbesoin === "Electricité" && besoin === "Gaz") {
					//Effacer les données de l etape 4
					if (this.record.VI_ChoixEstimation__c === 'Saisir la consommation d\'énergie') {
						this.record.VI_SaisieConsommationHeuresCreuses__c = null;
						this.record.VI_SaisieConsommationHeuresPleines__c = null;
						this.record.VI_SaisieConsommationHeuresPleines__c = null;
						this.record.VI_SaisieConsommationElec_HP_HC__c = false;
						this.record.VI_PuissanceCompteurElecSaisieConso__c = null;

					}

					if (this._stepInfo[3].status === "completed") {
						this._stepInfo[3].status = "available"
					}

					//Effacer les données de l'étape 6
					this.record.VI_InfosCompl_IndexElec__c = null;
					this.record.VI_InfosCompl_HP_HC__c = false;
					this.record.VI_InfosCompl_HeuresPleinesElec__c = null;
					this.record.VI_InfosCompl_HeuresCreusesElec__c = null;

					//Reinitialiser l'étape 6 partie 2
					if (this._stepInfo[5].status !== "disabled") {
						this._stepInfo[5].steps[1].status = "nonInitialized";
						if (this._stepInfo[5].steps[0].status === 'nonInitialized') {
							this._stepInfo[5].status = 'nonInitialized';
							this._stepInfo[7].status = "disabled";
						}
						else if (this._stepInfo[5].steps[0].status === 'available' ||
							this._stepInfo[5].steps[0].status === 'completed') {
							this._stepInfo[5].status = 'available';
							this._stepInfo[7].status = "disabled";
						}
					}
				}

				/* Start DDPCM - 1054 */
				if (oldbesoin !== besoin) {
					if (besoin === "Gaz") {
						this.record.VI_MensualiteElecTTC__c = 0;
					}
					else if (besoin === "Electricité") {
						this.record.VI_MensualiteGazTTC__c = 0;
					}
				}
				/* End DDPCM - 1054 */

				this._stepInfo[7].status = "disabled";

				this.updateCompleteParcours();
			}
		}
		if (this._stepInfo[0].steps[0].status === "completed") {
			this._stepInfo[0].status = "completed";
			if (this._stepInfo[1].status === "completed" && this._stepInfo[2].status === "completed" &&
				this._stepInfo[5].status === "disabled") {
				this._stepInfo[5].steps[0].status = "nonInitialized";
				this._stepInfo[5].steps[1].status = "nonInitialized";
				this._stepInfo[5].status = "nonInitialized";
				this._stepInfo[4].status = "available";
				this._stepInfo[4].steps[0].status = "nonInitialized";
				this._stepInfo[4].steps[1].status = "completed";
				this._stepInfo[6].status = "nonInitialized";
			}
		}
		else {
			this._stepInfo[0].status = "available";
		}
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
			this.stepsForInfoComplementaires = true;
		}
		if (this.record.VI_StatutParcours__c !== 'CPV Envoyées: PDL/PCE connu' && this.record.VI_StatutParcours__c !== 'CPV Envoyées: PDL/PCE non connu') {
			updateParcours
				(
					{
						idParcours: this.recordId,
						choixEnergie: besoin
					}
				)
		}
		this.currentStep = "client_energy";

		this.checkStatutRecap();
	}

	handleSuivantBesoin() {
		this.currentStep = "client_energy";
	}

	handlePrecedentBesoin() {
		this.currentStep = "situation";
	}

	/******Identification Client Methods******/
	// Identification Client - Move the status to completed ( Green) + move to the next step
	handleClientSelection(event) {
		this._stepInfo[1].status = "completed";

		this.currentStep = "identification_local";
		if (this._stepInfo[0].status === "completed" && this._stepInfo[2].status === "completed" &&
			this._stepInfo[5].status === "disabled") {
			this._stepInfo[5].steps[0].status = "nonInitialized";
			this._stepInfo[5].steps[1].status = "nonInitialized";
			this._stepInfo[5].status = "nonInitialized";
			this._stepInfo[4].status = "available";
			this._stepInfo[4].steps[0].status = "nonInitialized";
			this._stepInfo[4].steps[1].status = "completed";
			this._stepInfo[6].status = "nonInitialized";
		}
		let rechercheClient = this.template.querySelector('c-parcours-p-p-recherche-client');
		this.record = rechercheClient.record;
		this.record.VI_Id_coordonnees_bancaires__c = null;
		//check if we can access paiement
		if (this._stepInfo[5].status !== 'disabled' && this.record.VI_ChoixMoyenPaiement__c !== 'Autre') {
			this._stepInfo[6].status = 'nonInitialized';
		}
		if (rechercheClient.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
			this.updateCompleteParcours();
		}
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
			this.stepsForInfoComplementaires = true;
		}
		this.checkStatutRecap();
	}

	handleSuivantClient() {
		this.canChangePage = true;
		this.recordUpdated = false;
		//Etape Recherche Client
		let rechercheClient = this.template.querySelector('c-parcours-p-p-recherche-client');
		if (rechercheClient.emailchangedonly !== null) {
			this.emailChangedOnly = rechercheClient.emailchangedonly;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
		}
		if (rechercheClient.parcours !== null) {
			this.record = rechercheClient.parcours;
		}
		else {
			this.record = rechercheClient.record;
		}
		if (rechercheClient.recordupdated === true) {
			this.updateCompleteParcours();
		}
		this.currentStep = "identification_local";

	}

	handlePrecedentClient() {
		this.canChangePage = true;
		this.recordUpdated = false;
		//Etape Recherche Client
		let rechercheClient = this.template.querySelector('c-parcours-p-p-recherche-client');
		if (rechercheClient.emailchangedonly !== null) {
			this.emailChangedOnly = rechercheClient.emailchangedonly;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
		}
		if (rechercheClient.parcours !== null) {
			this.record = rechercheClient.parcours;
		}
		else {
			this.record = rechercheClient.record;
		}
		if (rechercheClient.recordupdated === true) {
			this.updateCompleteParcours();
		}

		this.currentStep = "energy";
	}

	// Identification Client - Move the status to completed ( Green) + move to the next step ( FROM CHILD)
	handleClientCreation(event) {
		this._stepInfo[1].status = "completed";
		if (this._stepInfo[0].status === "completed" && this._stepInfo[2].status === "completed" &&
			this._stepInfo[5].status === "disabled") {
			this._stepInfo[5].steps[0].status = "nonInitialized";
			this._stepInfo[5].steps[1].status = "nonInitialized";
			this._stepInfo[5].status = "nonInitialized";
			this._stepInfo[4].status = "available";
			this._stepInfo[4].steps[0].status = "nonInitialized";
			this._stepInfo[4].steps[1].status = "completed";
			this._stepInfo[6].status = "nonInitialized";
		}
		this.currentStep = "identification_local";
		let rechercheClient = this.template.querySelector('c-parcours-p-p-recherche-client');
		if (rechercheClient.parcours !== null) {
			this.record = rechercheClient.parcours;
		}
		else {
			this.record = rechercheClient.record;
		}
		if (rechercheClient.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
			this.updateCompleteParcours();
		}
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
			this.stepsForInfoComplementaires = true;
		}
		this.checkStatutRecap();
	}
	// Identification Client - Move the status to available ( Blue) after the same research is launched
	handleclientsearch(event) {
		if (this.record.VI_Contact__c === null || this.record.VI_Contact__c === undefined) {
			this._stepInfo[1].status = "available";
		}
	}

	/******Identification Local Methods******/
	//Upon Type de recherche local Change move the step status to available (Blue)
	handleTypeDeRechercheLocalChange(event) {
		if (this.record.VI_TypeRechercheLocal__c === null || this.record.VI_TypeRechercheLocal__c === undefined) {
			this._stepInfo[2].status = "available";
		}
	}

	// Start DDPCM - 279 
	//when 'Adresse de consommation identique' is unchecked the step status move to available (Blue)
	handleReinitializeclient(event) {
		if(this._stepInfo[2].status != "nonInitialized" && this._stepInfo[2].status != "disabled"){
			this._stepInfo[2].status = "available";
		}

		this._stepInfo[1].status = "nonInitialized";
		/* Start - 1094 */
		this._stepInfo[4].status = "disabled";
		this._stepInfo[4].steps[0].status =  "disabled";
		this._stepInfo[4].steps[1].status = "disabled";
		this._stepInfo[5].status = "disabled";
		this._stepInfo[5].steps[0].status =  "disabled";
		this._stepInfo[5].steps[1].status = "disabled";
		this._stepInfo[6].status = "disabled";
		/* End - 1094 */
		this._stepInfo[7].status = "disabled";

		this.updateCompleteParcours();
	}
	// END DDPCM - 279 

	handleReinitializeAddressLocal(event) {
		this._stepInfo[2].status = "available";
		/* Start - 1094 */
		this._stepInfo[4].status = "disabled";
		this._stepInfo[4].steps[0].status =  "disabled";
		this._stepInfo[4].steps[1].status = "disabled";
		this._stepInfo[5].status = "disabled";
		this._stepInfo[5].steps[0].status =  "disabled";
		this._stepInfo[5].steps[1].status = "disabled";
		this._stepInfo[6].status = "disabled";
		/* End - 1094 */
		this._stepInfo[7].status = "disabled";
	}

	handleSuivantLocal() {
		this.canChangePage = true;
		this.recordUpdated = false;
		console.log('this.currentStep ####' + this.currentStep);
		//Etape Identification Local
		let identificationLocal = this.template.querySelector('c-parcours-p-p-identification-local');
		this.record = identificationLocal.record;
		if (identificationLocal.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
			this.updateCompleteParcours();
		}
		this.currentStep = "EstimationConsommation";
	}

	handlePrecedentLocal() {
		this.canChangePage = true;
		this.recordUpdated = false;
		console.log('this.currentStep ####' + this.currentStep);
		//Etape Identification Local
		let identificationLocal = this.template.querySelector('c-parcours-p-p-identification-local');
		this.record = identificationLocal.record;
		if (identificationLocal.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
			this.updateCompleteParcours();
		}

		console.log("in handlePrecedentLocal");
		console.log("this.currentStep " + this.currentStep);
		this.currentStep = "client_energy";
		console.log("this.currentStep " + this.currentStep);
		console.log("after handlePrecedentLocal");
	}

	//Upon Local non identifié move the step status to completed ( Green) and stay in the same page
	handlelocalnonidentifie(event) {
		this._stepInfo[2].status = "completed";
		if (this._stepInfo[0].status === "completed" && this._stepInfo[1].status === "completed" &&
			this._stepInfo[5].status === "disabled") {
			this._stepInfo[5].steps[0].status = "nonInitialized";
			this._stepInfo[5].steps[1].status = "nonInitialized";
			this._stepInfo[5].status = "nonInitialized";
			this._stepInfo[4].status = "available";
			this._stepInfo[4].steps[0].status = "nonInitialized";
			this._stepInfo[4].steps[1].status = "completed";
			this._stepInfo[6].status = "nonInitialized";
		}
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
			this.stepsForInfoComplementaires = true;
		}
		/* Start DDPCM 1586 */
		this.recolorateFormerStatus();
		/* End DDPCM 1586 */
		this.checkStatutRecap();
	}
	//Upon choosing local move the step status to completed ( Green) and move to the next page
	handleSaveEtapeLocal(event) {
		if (this._stepInfo[0].status === "completed" && this._stepInfo[1].status === "completed" &&
			this._stepInfo[5].status === "disabled") {
			this._stepInfo[5].steps[0].status = "nonInitialized";
			this._stepInfo[5].steps[1].status = "nonInitialized";
			this._stepInfo[5].status = "nonInitialized";
			this._stepInfo[4].status = "available";
			this._stepInfo[4].steps[0].status = "nonInitialized";
			this._stepInfo[4].steps[1].status = "completed";
			this._stepInfo[6].status = "nonInitialized";
		}
		let identificationLocal = this.template.querySelector('c-parcours-p-p-identification-local');
		console.log("identificationLocal.record " + identificationLocal.record);
		this.record = identificationLocal.record;
		console.log("THISRECORD " + this.record);
		console.log(this.record);
		if ((this.record.VI_PDLRechercheLocal__c === null || this.record.VI_PDLRechercheLocal__c === "")
			&& ((this.record.VI_CodePostalRechercheLocal__c === "" || this.record.VI_CommuneRechercheLocal__c === "")
				|| this.record.VI_LocalNonIdentifieGenerationCase__c == false)) {

		} else {
			this._stepInfo[2].status = "completed";
		}
		if (identificationLocal.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
			console.log('update record');
			this.updateCompleteParcours();
		}
		this.currentStep = "EstimationConsommation";
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
			this.stepsForInfoComplementaires = true;
		}
		/* Start DDPCM 1586 */
		this.recolorateFormerStatus();
		/* End DDPCM 1586 */
		this.checkStatutRecap();
	}




	handleContinuer(event) {
		this._stepInfo[2].status = "completed";
		if (this._stepInfo[0].status === "completed" && this._stepInfo[1].status === "completed" &&
			this._stepInfo[5].status === "disabled") {
			this._stepInfo[5].steps[0].status = "nonInitialized";
			this._stepInfo[5].steps[1].status = "nonInitialized";
			this._stepInfo[5].status = "nonInitialized";
			this._stepInfo[4].status = "available";
			this._stepInfo[4].steps[0].status = "nonInitialized";
			this._stepInfo[4].steps[1].status = "completed";
			this._stepInfo[6].status = "nonInitialized";
		}
		let identificationLocal = this.template.querySelector('c-parcours-p-p-identification-local');
		console.log("identificationLocal.record " + identificationLocal.record);
		this.record = identificationLocal.record;
		console.log("THISRECORD " + this.record);
		console.log(this.record);
		if (identificationLocal.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = false;
			// End DDPCM 1156
			console.log('update record');
			this.updateCompleteParcours();
		}
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
			this.stepsForInfoComplementaires = true;
		}
		/* Start DDPCM 1586 */
		this.recolorateFormerStatus();
		/* End DDPCM 1586 */
		this.checkStatutRecap();
	}



	/******Informations Supplementaires Methods ******/
	//When contract date is filled in Informations Supplementaires
	handleDateContratRemplie(event) {
		this._stepInfo[5].steps[0].status = "completed";
		if (this._stepInfo[5].steps[1].status === "completed") {
			this._stepInfo[5].status = "completed";
			this.checkStatutRecap();
		}
		else {
			this._stepInfo[5].status = "available";
			this._stepInfo[7].status = "disabled";
		}
	}

	//When releves informations are being filled
	handleDetailsRelevesInities(event) {
		this._stepInfo[5].steps[1].status = "available";
		this._stepInfo[5].status = "available";
		this._stepInfo[7].status = "disabled";
	}

	//When releves informations are filled
	handleDetailsReleveRemplis(event) {
		this._stepInfo[5].steps[1].status = "completed";
		if (this._stepInfo[5].steps[0].status === "completed") {
			this._stepInfo[5].status = "completed";
			this.checkStatutRecap();
		}
		else {
			this._stepInfo[5].status = "available";
			this._stepInfo[7].status = "disabled";
		}
	}

	handleInfosComplPrecedent(event) {
		this.handleValiderEtapeInfosCompl();
		this.currentStep = "services";
	}

	handleValiderEtapeInfosCompl() {
		if (this.currentStep === "DateEffetContrat" || this.currentStep === "RelevesCompteur") {
			let infosCompl = this.template.querySelector('c-parcours-p-p-info-complementaires');
			this.record = infosCompl.record;
			if (infosCompl.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				this.updateCompleteParcours();
			}
		}
	}


	/******Saisie de paiement Methods ******/

	//Upon saisie de paiement set status to blue
	handlesaisiepaiementompleted() {
		let saisiePaiement = this.template.querySelector('c-parcours-p-p-saisie-paiements');
		if (saisiePaiement.record !== null) {
			this.record = saisiePaiement.record;
		}
		if (saisiePaiement.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = true;
			// End DDPCM 1156
			console.log('update record');
			console.log(this.record.VI_Id_coordonnees_bancaires__c);
			this.updateCompleteParcours();
		}
		this._stepInfo[6].status = "completed";
		this.checkStatutRecap();
	}

	handlesaisiepaiementnoninitialized() {
		this._stepInfo[6].status = "nonInitialized";
		this._stepInfo[7].status = "disabled";
		let saisiePaiement = this.template.querySelector('c-parcours-p-p-saisie-paiements');
		if (saisiePaiement.record !== null) {
			this.record = saisiePaiement.record;
		}
		if (saisiePaiement.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = true;
			// End DDPCM 1156
			console.log('update record');
			this.updateCompleteParcours();
		}
	}

	handlesaisiepaiementcheckbox() {
		let saisiePaiement = this.template.querySelector('c-parcours-p-p-saisie-paiements');
		if (saisiePaiement.record !== null) {
			this.record = saisiePaiement.record;
		}
		if (saisiePaiement.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = true;
			// End DDPCM 1156
			console.log('update record');
			this.updateCompleteParcours();
		}
	}

	handlesaisiepaiementavailable() {
		this._stepInfo[6].status = "available";
		this._stepInfo[7].status = "disabled";
		let saisiePaiement = this.template.querySelector('c-parcours-p-p-saisie-paiements');
		if (saisiePaiement.record !== null) {
			this.record = saisiePaiement.record;
		}
		if (saisiePaiement.recordupdated === true) {
			this.emailChangedOnly = false;
			// Start DDPCM 1156
			this.gestionChangedOnly = true;
			// End DDPCM 1156
			console.log('update record');
			this.updateCompleteParcours();
		}
	}

	handlesaisiepaiementavailableiban() {
		if (this._stepInfo[6].status !== "completed") {
		this._stepInfo[6].status = "available";
			this._stepInfo[7].status = "disabled";
	}
	}


	/* Start DDPCM - 1094 */
	// Service de Gestion

	handlestatusservicedegestion(){
		this._stepInfo[6].status = "available";
		this._stepInfo[7].status = "disabled";
	}
	/* End DDPCM - 1094 */

	//gestion du passage de l'etape 7 à l'etape 8
	handlePasserEtapeSaisiePaiement(event) {
		//this.handleChange(event);
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed" &&
			this._stepInfo[3].status === "completed" &&
			this._stepInfo[4].status === "completed" &&
			this._stepInfo[5].status === "completed" &&
			this._stepInfo[6].status === "completed") {

			this.allIsCompleted = true;
			let paiementEtape = this.template.querySelector('c-parcours-p-p-saisie-paiements');
			this.record = paiementEtape.record;
			console.log('-----------> ' + paiementEtape.record);
			console.log(this.record);
			this.updateCompleteParcours();
			this.currentStep = "Recapitulatif";
			this._stepInfo[7].status = "nonInitialized";
			this.checkStatutRecap();
		} else {
			this.allIsCompleted = false;
		}
	}

	handleSaisiePaiementPrecedent(event) {
		this.handleValiderEtapeSaisiePaiement();
		this.currentStep = "DateEffetContrat";
	}

	handleValiderEtapeSaisiePaiement() {
		if (this.currentStep === "Saisie_moyen_de_paiement") {
			let saisiePaiement = this.template.querySelector('c-parcours-p-p-saisie-paiements');
			this.record = saisiePaiement.record;
			if (saisiePaiement.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = true;
				// End DDPCM 1156
				this.updateCompleteParcours();
			}
		}
	}


	/******Estimation de la consommation Methods ******/
	//Upon estimation de la consommation set status to blue
	handleEstimationDeLaConsommationAvailable(event) {
		this._stepInfo[3].status = "available";
		this._stepInfo[7].status = "disabled";
	}

	//Upon estimation de la consommation set status to green
	handleEstimationDeLaConsommationCompleted(event) {
		this._stepInfo[3].status = "completed";
		let consoEtape = this.template.querySelector('c-parcours-p-p-estimation-consommation');
		this.record = consoEtape.record;
		if (consoEtape.recordupdated === true) {
			this.emailChangedOnly = false;
			this.gestionChangedOnly = false;
			this.updateCompleteParcours();
		}
		this.checkStatutRecap();
	}

	handlePasserEtapeEstimationConso(event) {
		this._stepInfo[3].status = "completed";
		let consoEtape = this.template.querySelector('c-parcours-p-p-estimation-consommation');
		this.record = consoEtape.record;
		if (consoEtape.recordupdated === true) {
			this.emailChangedOnly = false;
			this.gestionChangedOnly = false;
			this.updateCompleteParcours();
		}
		this.currentStep = "ConstitutionPanier";
		this.checkStatutRecap();
	}

	handleEstimationConsoPrecedent(event) {
		this.handleValiderEtapeEstimationConso();
		this.currentStep = "identification_local";
	}

	handleValiderEtapeEstimationConso() {
		if (this.currentStep === "EstimationConsommation") {
			let estimationConso = this.template.querySelector('c-parcours-p-p-estimation-consommation');
			this.record = estimationConso.record;
			if (estimationConso.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				this.updateCompleteParcours();
			}
		}
	}

	estimationConsoCompleted() {
		if (this._record.VI_TypeResidenceSaisieConso__c !== null &&
			this._record.VI_TypeLogementSaisieConso__c !== null &&
			this._record.VI_SurfaceLogementSaisieConso__c !== null &&
			this._record.VI_NombreOccupantLogementSaisieConso__c !== null &&
			this._record.VI_AnneeConstructionLogementSaisieConso__c !== null &&
			this._record.VI_DispositifChauffageSaisieConso__c !== null &&
			this._record.VI_EnergieChauffageSaisieConso__c !== null &&
			this._record.VI_EnergieCuissonSaisieConso__c !== null &&
			this._record.VI_DispositifEauChaudeSaisieConso__c !== null &&
			this._record.VI_EnergieEauChaudeSaisieConso__c !== null &&
			this._record.VI_SaisieEstimationConsoElec_HP_HC__c !== null) {
			return true;
		}
		else {
			return false;
		}
	}


	/******Constitution Du Panier Methods ******/
	//Handle Precendent
	handleConstitutionDuPanierPrecedent(event) {
		this.recordUpdated = false;
		//Etape Identification Local
		if (this.currentStep === "ConstitutionPanier") {
			let constitutionPanier = this.template.querySelector('c-parcours-p-p-constitution-panier');
			this.record = constitutionPanier.record;
			if (constitutionPanier.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				this.updateCompleteParcours();
			}
		}
		//this.handleValiderEtape(event);
		this.currentStep = "EstimationConsommation";
	}

	handleValiderEtape(event) {
		this.recordUpdated = false;
		//Etape Identification Local
		if (this.currentStep === "ConstitutionPanier") {
			let constitutionPanier = this.template.querySelector('c-parcours-p-p-constitution-panier');
			this.record = constitutionPanier.record;
			if (constitutionPanier.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				this.updateCompleteParcours();
			}
		}
		this.currentStep = "services";
		this.checkStatutRecap();
	}

	//Upon estimation de la consommation set status to blue
	handleConstitionDuPanierAvailable(event) {
		this._stepInfo[4].status = "available";
	}

	//Upon estimation de la consommation set status to green
	handleConstitionDuPanierCompleted(event) {
		this._stepInfo[4].steps[0].status = "completed";
		if (this._stepInfo[4].steps[1].status === "completed") {
			this._stepInfo[4].status = "completed";
		}
		else {
			this._stepInfo[4].status = "available";
		}
		/* Start DDPCM 786 */
		if (this.record.VI_ChoixMensualisation__c === 'Oui') {
			this._stepInfo[6].status = "available";
			this._stepInfo[7].status = "disabled";
			this.reopenPopUpMensualisation = true;
		}
		/* End DDPCM 786 */
		this.record = event.detail.record;
		this.checkStatutRecap();
	}

	//status to blue
	handleConstitionDuPanierEnCours(event) {
		this._stepInfo[4].status = "available";

		this.record = event.detail.record;
		this.checkStatutRecap();
	}

	//status to Grey
	handlePasDOffreChoisie(event) {
		if (this._stepInfo[4].status !== "disabled") {
			this._stepInfo[4].status = "nonInitialized";
			this._stepInfo[7].status = "disabled";
		}

		this.record = event.detail.record;
		this.checkStatutRecap();
	}

	//Etape services et options
	//Upon estimation de la consommation set status to green
	handleServicesEtOptionsCompleted(event) {
		this._stepInfo[4].steps[1].status = "completed";
		if (this._stepInfo[4].steps[0].status === "completed") {
			this._stepInfo[4].status = "completed";
		}
		else {
			this._stepInfo[4].status = "available";
		}
		this.record = event.detail.record;
		this.checkStatutRecap();
	}

	//status to blue
	handleServicesEtOptionsEnCours(event) {
		this._stepInfo[4].steps[1].status = "available";
		this._stepInfo[4].status = "available";
		this._stepInfo[7].status = "disabled";
		this.record = event.detail.record;
		this.checkStatutRecap();
	}

	handleServicesEtOptionsSuivant(event) {
		this.recordUpdated = false;
		//Etape Identification Local
		if (this.currentStep === "services") {
			let services = this.template.querySelector('c-parcours-p-p-options-et-services');
			this.record = services.record;
			if (services.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				this.updateCompleteParcours();
			}
		}
		this.currentStep = "DateEffetContrat";
		let infosComplementaires = this.template.querySelector('c-parcours-p-p-info-complementaires');
		//infosComplementaires.handleRecentrer();
		if (this._stepInfo[5].steps[0].status === "completed") {
			//infosComplementaires.handleRecentrer();
		}
		else {
			var scrollOptions = {
				left: 0,
				top: 0
				//behavior: 'smooth'
			}
			window.scrollTo(scrollOptions);
		}
		this.checkStatutRecap();
	}

	handleServicesEtOptionsPrecedent(event) {
		this.recordUpdated = false;
		//Etape Identification Local
		if (this.currentStep === "services") {
			let services = this.template.querySelector('c-parcours-p-p-options-et-services');
			this.record = services.record;
			if (services.recordupdated === true) {
				this.emailChangedOnly = false;
				this.gestionChangedOnly = false;
				this.updateCompleteParcours();
			}
		}
		this.currentStep = "ConstitutionPanier";
		this.checkStatutRecap();
	}

	/* Start DDPCM 786 */
	handleclosepopupajustementmensualite() {
		this.reopenPopUpMensualisation = false;
	}
	/* Start DDPCM 786 */

	/******Buttons Methods******/
	//saves the comments on the record based on the current step
	handleSaveComment(event) {
		if (event.detail.step === "situation" || event.detail.step === "energy") {
			this.record = { ...this.record, VI_CommentaireGeneral_idbesoin__c: event.detail.comment };
		}
		else if (event.detail.step === "client_energy") {
			this.record = { ...this.record, VI_CommentaireGeneral_idclient__c: event.detail.comment };
		}
		else if (event.detail.step === "identification_local") {
			this.record = { ...this.record, VI_CommentaireGeneral_idlocal__c: event.detail.comment };
		}
		else if (event.detail.step === "EstimationConsommation") {
			this.record = { ...this.record, VI_CommentaireGeneral_EstimationConso__c: event.detail.comment };
		}
		else if (event.detail.step === "ConstitutionPanier") {
			this.record = { ...this.record, VI_CommentaireGeneral_Constitutionpanier__c: event.detail.comment };
		}
		else if (event.detail.step === "Saisie_moyen_de_paiement") {
			this.record = { ...this.record, VI_CommentaireGeneral_MoyensPaiement__c: event.detail.comment };
		}
		else if (event.detail.step === "Recapitulatif") {
			this.record = { ...this.record, VI_CommentairesParcours__c: event.detail.comment };
		}
		else if (event.detail.step === "DateEffetContrat" || event.detail.step === "RelevesCompteur") {
			this.record = { ...this.record, VI_CommentaireGeneral_InfosCompl__c: event.detail.comment };
		}
	}



	handleNextPage(event) {
		if (this.currentStep === "situation") {
			this.currentStep = "energy";
			updateParcours
				(
					{
						idParcours: this.recordId,
						DescriptionTache: "situation"
					}
				)
		}
		else if (this.currentStep === "energy") {
			this.currentStep = "situation";
			updateParcours
				(
					{
						idParcours: this.recordId,
						DescriptionTache: "energy"
					}
				)
		}
	}

	renderedCallback() {
		if (this.isFirstRender) {
			Promise.all([
				loadScript(this, EngieCommunityResource + '/EngieAssets/bootstrap.bundle.min.js'),
				loadStyle(this, EngieCommunityResource + '/EngieAssets/bootstrap.min.css'),
				loadStyle(this, EngieCommunityResource + '/EngieAssets/EngieGlobalStyle.css')
			]);
			this.isFirstRender = false;
		}
		this.emailChangedOnly = true;
		// Start DDPCM 1156
		this.gestionChangedOnly = true;
		// End DDPCM 1156
	}

	/******TRANSVERSE******/
	// handles a click on the fil d'arianne in the middle of a step
	handleChange(event) {
		console.log("this._record : " + this.record);
		console.log(this.record);
		this.canChangePage = true;
		this.recordUpdated = false;
		//Etape Identification Local
		if (this.currentStep === "identification_local") {
			let identificationLocal = this.template.querySelector('c-parcours-p-p-identification-local');
			this.record = identificationLocal.record;
			if (identificationLocal.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				console.log('update record');
				this.updateCompleteParcours();
			}
		}
		//Etape Recherche Client
		else if (this.currentStep === "client_energy") {
			let rechercheClient = this.template.querySelector('c-parcours-p-p-recherche-client');
			if (rechercheClient.emailchangedonly !== null) {
				this.emailChangedOnly = rechercheClient.emailchangedonly;
				console.log('emailchangedonly' + this.emailchangedonly);
			}
			if (rechercheClient.parcours !== null) {
				this.record = rechercheClient.parcours;
			}
			else {
				this.record = rechercheClient.record;
			}
			if (rechercheClient.recordupdated === true) {
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				console.log('update record');
				this.updateCompleteParcours();
			}
		}
		//Etape Constitution du panier
		else if (this.currentStep === "ConstitutionPanier") {
			let constitutionPanier = this.template.querySelector('c-parcours-p-p-constitution-panier');

			this.record = constitutionPanier.record;
			//this.updateCompleteParcours();
			if (constitutionPanier.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				console.log('update record');
				this.updateCompleteParcours();
			}
		}
		//Etape Choix des options
		else if (this.currentStep === "services") {
			let optionsetservices = this.template.querySelector('c-parcours-p-p-options-et-services');

			this.record = optionsetservices.record;
			//this.updateCompleteParcours();
			if (optionsetservices.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				console.log('update record');
				this.updateCompleteParcours();
			}
		}
		//Etape Estimation Consommation
		else if (this.currentStep === "EstimationConsommation") {
			let estimationConso = this.template.querySelector('c-parcours-p-p-estimation-consommation');

			if (estimationConso.record !== null) {
				this.record = estimationConso.record;
			}
			else {
				this.record = estimationConso.record;
			}
			if (estimationConso.recordupdated === true) {
				console.log('update record');
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				this.updateCompleteParcours();
			}
		}
		//etape saisie paiement
		else if (this.currentStep === "Saisie_moyen_de_paiement") {
			let saisiePaiement = this.template.querySelector('c-parcours-p-p-saisie-paiements');
			if (saisiePaiement.record !== null) {
				this.record = saisiePaiement.record;
			}
			if (saisiePaiement.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = true;
				// End DDPCM 1156
				console.log('update record');
				this.updateCompleteParcours();
			}
		}

		//Etape Information Complementaires
		else if (this.currentStep === "DateEffetContrat" || this.currentStep === "RelevesCompteur") {
			let infosComplementaires = this.template.querySelector('c-parcours-p-p-info-complementaires');
			//infosComplementaires.handleRecentrer();
			if (this.currentStep === "RelevesCompteur") {
				infosComplementaires.handleRecentrer();
			}
			if (this.currentStep === "DateEffetContrat") {
				infosComplementaires.handleInfoComp();

			}
			if (infosComplementaires.record !== null) {
				this.record = infosComplementaires.record;
			}
			if (infosComplementaires.recordupdated === true) {
				this.emailChangedOnly = false;
				console.log('update record');
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				this.updateCompleteParcours();
			}
		}

		if (this.currentStep === "Recapitulatif") {
			let recapSouscription = this.template.querySelector('c-parcours-p-p-recap-souscription');
			this.record = recapSouscription.record;
			if (recapSouscription.recordupdated === true) {
				this.emailChangedOnly = false;
				// Start DDPCM 1156
				this.gestionChangedOnly = false;
				// End DDPCM 1156
				console.log('update record');
				this.updateCompleteParcours();
			}
		}

		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed") {
			this.stepsForInfoComplementaires = true;
			if (this.record.VI_InfosCompl_ChoixReleveCompteur__c === "Passer cette étape") {
				this._stepInfo[5].steps[1].status = "completed";
			}
			else {
				this.checkInfosComplementairesReleve();
			}
			this.checkInfosComplementairesDate();
		}

		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed" &&
			this._stepInfo[3].status === "completed" &&
			this._stepInfo[4].status === "completed" &&
			this._stepInfo[5].status === "completed") {
			this.stepsForRecap = false;
		}


		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed" &&
			this._stepInfo[3].status === "completed" &&
			this._stepInfo[4].status === "completed") {
			this.stepsForSubscription = false;
		}
		if ((event.target.getAttribute('data-section') === "DateEffetContrat" ||
			event.target.getAttribute('data-section') === "RelevesCompteur" ||
			event.target.getAttribute('data-section') === "ConstitutionPanier" ||
			event.target.getAttribute('data-section') === "services") &&
			(this._stepInfo[0].status !== "completed" ||
				this._stepInfo[1].status !== "completed" ||
				this._stepInfo[2].status !== "completed")) {
			this.canChangePage = false;
		}

		if ((event.target.getAttribute('data-section') === "Recapitulatif") &&
			(this._stepInfo[0].status !== "completed" ||
				this._stepInfo[1].status !== "completed" ||
				this._stepInfo[2].status !== "completed" ||
				this._stepInfo[3].status !== "completed" ||
				this._stepInfo[4].status !== "completed" ||
				this._stepInfo[5].status !== "completed" ||
				this._stepInfo[6].status !== "completed")) {
			this.canChangePage = false;
		}

		if ((event.target.getAttribute('data-section') === "Recapitulatif") &&
			(this._stepInfo[0].status !== "completed" ||
				this._stepInfo[1].status !== "completed" ||
				this._stepInfo[2].status !== "completed" ||
				this._stepInfo[3].status !== "completed" ||
				this._stepInfo[4].status !== "completed" ||
				this._stepInfo[5].status !== "completed" ||
				this._stepInfo[6].status !== "completed")) {
			this.canChangePage = false;
		}

		if ((event.target.getAttribute('data-section') === "Saisie_moyen_de_paiement") &&
			(this._stepInfo[5].status === "disabled")) {
				this._stepInfo[7].status = "disabled";
			this.canChangePage = false;
		}

		//
		if (this.canChangePage === true) {
			this.currentStep = event.target.getAttribute('data-section');
		}


		this.checkStatutRecap();
	}

	handleInfoComplDetailsReleveRemplis() {
		if (this._stepInfo[5].steps[1].status !== "disabled") {
			this._stepInfo[5].steps[1].status = "completed";
		}
	}

	handleInfoComplDetailsReleveInities() {
		if (this._stepInfo[5].steps[1].status !== "disabled") {
			this._stepInfo[5].steps[1].status = "available";
			this._stepInfo[7].status = "disabled";
		}
	}

	handleInfoComplDetailsReleveVides() {
		if (this._stepInfo[5].steps[1].status !== "disabled") {
			this._stepInfo[5].steps[1].status = "nonInitialized";
			this._stepInfo[7].status = "disabled";
		}
	}

	updateCompleteParcours() {
		console.log('inside updateCompleteParcours');
		updateParcoursSF({
			parcours: this.record,
			emailChangedOnly: this.emailChangedOnly,
			gestionChangedOnly: this.gestionChangedOnly
		}
		).then(result => {
			console.log('result' + result);
			if (result !== 'Success') {
				this._title = 'Erreur';
				this.message = result;
				this.variant = 'error';
				if (this.message !== 'Error') {
					this.showNotification();
				}
			}

		})
			.catch(error => {
				this._title = 'Erreur';
				this.message = error;
				this.variant = 'error';
				if (this.message !== 'Error') {
					this.showNotification();
				}
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

	get isSituation() {
		return (this.currentStep === "situation" && this.isDataLoaded);
	}
	get isEnergy() {
		return (this.currentStep === "energy" && this.isDataLoaded);
	}
	get isRechercheClient() {
		return (this.currentStep === "client_energy" && this.isDataLoaded);
	}
	get isConstitutionPanier() {
		return (this.currentStep === "ConstitutionPanier" && this.isDataLoaded);
	}
	get isOptionEtServices() {
		return (this.currentStep === "services" && this.isDataLoaded);
	}
	get isIdentificationLocal() {
		return (this.currentStep === "identification_local" && this.isDataLoaded);
	}
	get isSaisieMoyenDePaiement() {
		return (this.currentStep === "Saisie_moyen_de_paiement" && this.isDataLoaded);
	}
	get isEstimationConsommation() {
		return (this.currentStep === "EstimationConsommation" && this.isDataLoaded);
	}
	get isInfosComplementaires() {
		return ((this.currentStep === "DateEffetContrat" || this.currentStep === "RelevesCompteur") && this.isDataLoaded);
	}
	get isRecap() {
		return (this.currentStep === "Recapitulatif" && this.isDataLoaded);
	}
	get isPaiements() {
		return (this.currentStep === "Saisie_moyen_de_paiement" && this.isDataLoaded);
	}


	get currentStep() {
		let currentStep = "";
		this._stepInfo.forEach(step => {
			if (currentStep === "") {
				if (typeof step.steps !== "undefined" && step.steps.length > 0) {
					currentStep = step.steps.find(elt => {
						return elt.isCurrent === true;
					});
					currentStep = typeof currentStep !== "undefined" ? currentStep.name : "";
				} else {
					currentStep = step.isCurrent === true ? step.name : "";
				}
			}
		})
		this.currentStepValue = currentStep;
		if (currentStep !== null) {
			this.currentStepValue = currentStep;
		}
		return currentStep;
	}
	set currentStep(value) {
		this._stepInfo = this._stepInfo.map(step => {

			step.isCurrent = step.name === value;
			step.steps = step.steps.map(substep => {
				substep.isCurrent = substep.name === value;
				return substep;
			})
			return step;
		})

	}

	get alliscompleted() {
		let allIsOk = false;
		if (this._stepInfo[0].status === "completed" &&
			this._stepInfo[1].status === "completed" &&
			this._stepInfo[2].status === "completed" &&
			this._stepInfo[3].status === "completed" &&
			this._stepInfo[4].status === "completed" &&
			this._stepInfo[5].status === "completed") {
			allIsOk = true;
		}
		return allIsOk;
	}

	//Action à effectuer pour la fin du parcours
	handlefindeparcours(event) {
		let recapSouscription = this.template.querySelector('c-parcours-p-p-recap-souscription');
		this.record = recapSouscription.record;
		this._stepInfo[7].status = "completed";
	}

	handlefindeparcourserreur(event) {
		let recapSouscription = this.template.querySelector('c-parcours-p-p-recap-souscription');
		this.record = recapSouscription.record;
	}

	handleSituation(event) {
		this.modifSituation = event.detail;
		if (this.modifSituation === 'situation') {
			this.currentStep = "situation";
		}
	}

	handleEnergy(event) {
		this.modifEnergy = event.detail;
		if (this.modifEnergy === 'energy') {
			this.currentStep = "energy";
		}
	}

	handleClient(event) {
		this.modifClient = event.detail;
		if (this.modifClient === 'client_energy') {
			this.currentStep = "client_energy";
		}
	}

	handleLocal(event) {
		this.modifLocal = event.detail;
		if (this.modifLocal === 'identification_local') {
			this.currentStep = "identification_local";
		}
	}

	handlePanier(event) {
		this.modifPanier = event.detail;
		if (this.modifPanier === 'ConstitutionPanier') {
			this.currentStep = "ConstitutionPanier";
		}
	}

	handleContrat(event) {
		this.modifContrat = event.detail;
		if (this.modifContrat === 'DateEffetContrat') {
			this.currentStep = "DateEffetContrat";
		}
	}

	handlePaiement(event) {
		this.modifPaiement = event.detail;
		if (this.modifPaiement === 'Saisie_moyen_de_paiement') {
			this.currentStep = "Saisie_moyen_de_paiement";
		}
	}
	//Start DDPCM - 304
	handleBesoinCom(event) {
		this.modifSituation = event.detail;
		if (this.modifSituation === 'situation') {
			this.currentStep = "situation";
			this.template.querySelector("c-parcours-pp-round-button").currentstepvalue = this.currentStep;
		}
		this.template.querySelector("c-parcours-pp-round-button").openModal2();
	}

	handleClientCom(event) {
		this.modifClient = event.detail;
		if (this.modifClient === 'client_energy') {
			this.currentStep = "client_energy";
			this.template.querySelector("c-parcours-pp-round-button").currentstepvalue = this.currentStep;
		}
		this.template.querySelector("c-parcours-pp-round-button").openModal2();
	}

	handleLocalCom(event) {
		this.modifLocal = event.detail;
		if (this.modifLocal === 'identification_local') {
			this.currentStep = "identification_local";
			this.template.querySelector("c-parcours-pp-round-button").currentstepvalue = this.currentStep;
		}
		this.template.querySelector("c-parcours-pp-round-button").openModal2();
	}

	handleEstimation(event) {
		this.modifEstimation = event.detail;
		if (this.modifEstimation === 'EstimationConsommation') {
			this.currentStep = "EstimationConsommation";
			this.template.querySelector("c-parcours-pp-round-button").currentstepvalue = this.currentStep;
		}
		this.template.querySelector("c-parcours-pp-round-button").openModal2();
	}

	handlePanierCom(event) {
		this.modifPanier = event.detail;
		if (this.modifPanier === 'ConstitutionPanier') {
			this.currentStep = "ConstitutionPanier";
			this.template.querySelector("c-parcours-pp-round-button").currentstepvalue = this.currentStep;
		}
		this.template.querySelector("c-parcours-pp-round-button").openModal2();
	}

	handleContratCom(event) {
		this.modifContrat = event.detail;
		if (this.modifContrat === 'DateEffetContrat') {
			this.currentStep = "DateEffetContrat";
			this.template.querySelector("c-parcours-pp-round-button").currentstepvalue = this.currentStep;
		}
		this.template.querySelector("c-parcours-pp-round-button").openModal2();
	}

	handlePaiementCom(event) {
		this.modifPaiement = event.detail;
		if (this.modifPaiement === 'Saisie_moyen_de_paiement') {
			this.currentStep = "Saisie_moyen_de_paiement";
			this.template.querySelector("c-parcours-pp-round-button").currentstepvalue = this.currentStep;
		}
		this.template.querySelector("c-parcours-pp-round-button").openModal2();

	}

	handleRecapCom(event) {
		this.template.querySelector("c-parcours-pp-round-button").openModal2();
	}
	//End DDPCM - 304


}

const stepInfo = [
	{
		name: "situation",
		label: "Identification besoin", //get this from custom label
		status: "nonInitialized", //this can be one of 4, available - completed - disabled - hidden
		isCurrent: false,
		steps: [
			{
				name: "situation",
				label: "Choix de la situation", //get from custom label
				status: "nonInitialized",
				isCurrent: false // to see if it is rendered
			},
			{
				name: "energy",
				label: "Choix de l'énergie", //get from custom label
				status: "nonInitialized",
				isCurrent: false // to see if it is rendered
			}
		]
	}, {
		name: "client_energy",
		label: "Identification client", //get from custom label
		status: "nonInitialized",
		isCurrent: false, // to see if it is rendered
		steps: []
	},
	{
		name: "identification_local",
		label: "Identification local", //get from custom label
		status: "nonInitialized",
		isCurrent: false, // to see if it is rendered
		steps: []

	}, {
		name: "EstimationConsommation",
		label: "Estimation de la consommation", //get this from custom label
		status: "nonInitialized", //this can be one of 4, available - completed - disabled - hidden
		isCurrent: false,
		steps: []
	}, {
		name: "ConstitutionPanier",
		label: "Constitution du panier client", //get this from custom label
		status: "disabled", //this can be one of 4, available - completed - disabled - hidden
		isCurrent: false,
		steps: [
			{
				name: "ConstitutionPanier",
				label: "Choix de l'offre​", //get from custom label
				status: "disabled",
				isCurrent: false // to see if it is rendered
			},
			{
				name: "services",
				label: "Choix des options / services​", //get from custom label
				status: "disabled",
				isCurrent: false // to see if it is rendered
			}
		]
	}, {
		name: "DateEffetContrat",
		label: "Date et relevé", //get this from custom label
		status: "disabled", //this can be one of 4, available - completed - disabled - hidden
		isCurrent: false,
		steps: [
			{
				name: "DateEffetContrat",
				label: "Date de contrat effectif", //get from custom label
				status: "disabled",
				isCurrent: false // to see if it is rendered
			},
			{
				name: "RelevesCompteur",
				label: "Relevés de compteur", //get from custom label
				status: "disabled",
				isCurrent: false // to see if it is rendered
			}
		]
	},
	{
		name: "Saisie_moyen_de_paiement",
		label: "Saisie des moyens de paiement", //get this from custom label
		status: "nonInitialized", //this can be one of 4, available - completed - disabled - hidden
		isCurrent: false,
		steps: []
	},
	{
		name: "Recapitulatif",
		label: "Récapitulatif de la souscription", //get this from custom label
		status: "nonInitialized", //this can be one of 4, available - completed - disabled - hidden
		isCurrent: false,
		steps: []
	}
];