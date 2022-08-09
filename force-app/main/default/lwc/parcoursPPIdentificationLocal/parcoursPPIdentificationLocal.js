import { LightningElement, track, api } from 'lwc';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import searchLocalbyPDLPCE from '@salesforce/apex/VI_parcoursPPLocal_Controller.searchLocalbyPDLPCE';
import searchLocalbyAdresse from '@salesforce/apex/VI_parcoursPPLocal_Controller.getPDLPCEFromAdresse';
// Start DDPCM - 279 
import getSelectedContactAddress from '@salesforce/apex/VI_parcoursPPLocal_Controller.getSelectedContactAddress';
// END DDPCM - 279 
import getAdresseList from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getAdresseList';
import getListVille from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getVilles';
import getVillesCodePostal from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getVillesCodePostal';
import updateParcoursSF from '@salesforce/apex/VI_parcoursPPLocal_Controller.updateParcoursLocal';
import updateParcoursLocalNonidentifieSF from '@salesforce/apex/VI_parcoursPPLocal_Controller.updateParcoursLocalNonIdentifie';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// Start Visualisation des Cases 
import { NavigationMixin } from 'lightning/navigation';
import annulerParcours from '@salesforce/apex/VI_ParcoursPpRoundButton_Controller.annulerParcours';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
// END Visualisation des Cases 
//Start DDPCM - 1120
import getInfosSuppPDLPCEfromAdresse from '@salesforce/apex/VI_parcoursPPLocal_Controller.getInfosSuppPDLPCEfromAdresse';
//END DDPCM - 1120


export default class ParcoursPPIdentificationLocal extends NavigationMixin(LightningElement) {

/* ________________________________________________________________________________________________________________________________________________________ */
/* _________________________________________________________ VARIABLE DECLARATION _________________________________________________________________________ */
/* ________________________________________________________________________________________________________________________________________________________ */

	GazImage = EngieCommunityResource + '/EngieAssets/pictures/pictures/1-besoins-client--energie-group-3.png';
	GazImageInBlue = EngieCommunityResource + '/EngieAssets/pictures/pictures/1-besoins-client--situation-group-3-blue.png';
	trucImage = EngieCommunityResource + '/EngieAssets/pictures/pictures/1-besoins-client--situation-group-3-FB2B6729-A9F7-4898-9E4D-BE443CF34643@2x.png';
	FlecheGauche = EngieCommunityResource + '/EngieAssets/pictures/fleche-gauche.png';
	FlecheDroite = EngieCommunityResource + '/EngieAssets/pictures/fleche-droite.png';
	MaisonBlanc = EngieCommunityResource + '/EngieAssets/pictures/MaisonBlanc.png';
	MaisonBleu = EngieCommunityResource + '/EngieAssets/pictures/MaisonBleu.png';
	LocationBlanc = EngieCommunityResource + '/EngieAssets/pictures/LocationBlanc.png';
	LocationBleu = EngieCommunityResource + '/EngieAssets/pictures/LocationBleu.png';
	Astuce = EngieCommunityResource + '/EngieAssets/pictures/picto-astuce.png';
	// Start DDPCM - 671 
	LogoLinky = EngieCommunityResource + '/EngieAssets/pictures/LOGO_LINKY.png';
	LogoGazPAR = EngieCommunityResource + '/EngieAssets/pictures/LOGO_GAZPAR.png';
	LogoLinkyGazPAR = EngieCommunityResource + '/EngieAssets/pictures/LOGO_LINKY_GAZPAR.png';
	// End DDPCM - 671 
	/* Start DDPCM - 371 */
	/* Start DDPCM-727 New Cannaux*/
	showVisualisationDesCases = false;
	/* End DDPCM-727 New Cannaux*/
	/* Start DDPCM - 852 New Canaux */
	remplissageAutomatiqueNewCanaux = false;
	isRemplissageAutomatiqueLocal = false;
	/* End DDPCM - 852 New Canaux */
	clientDejaSelectionne = false;

	closeImage = EngieCommunityResource + '/EngieAssets/pictures/close-icon.png';
	iconVisualisationCase = EngieCommunityResource + '/EngieAssets/pictures/icon-question.png';

	isModalOpenBackgroundVisualisationCase = false;
	isModalVisualisationCaseOpen = false;
	isOffreEnCoursReliee = false;
	isOffreEnCoursRelieeVariableDAffichage = false;
	/* Start DDPCM - 871 */
	isCHF = false;
	/* End DDPCM - 871 */
	/* End DDPCM - 371 */
	isHPHC = false;
	isGaz = false;
	isElectricite = false;
	isGazEtElectricite = true;
	releveCompteurCompleted = false;
	releveCompteurInitialized = false;

	// Start DDPCM - 1117 
	rechercheParAdresseLoaded = false;
	rechercheParPDLPCELoaded = false;
	// End DDPCM - 1117

	// Start DDPCM - 1120 
	donneesLocauxLoaded = true;
	// End DDPCM - 1120

	// Start DDPCM - 279 
	isIdentificationClientCompleted = false;

	@track communeClient = "";
	@track codePostalClient = "";
	@track adresseClient = "";
	@track rue = "";
	@track numeroRue = "";

	communeClientSave = "";
	codePostalClientSave = "";
	adresseClientSave = "";
	rueSave = "";
	numeroRueSave = "";

	// END DDPCM - 279

	@api
	get recordupdated() {
		return this._recordupdated;
	}
	set recordupdated(value) {
		this._recordupdated = value;
	}
	isPDLPCE;
	isRecherche;
	PDLnonidentifie = false;
	value;
	error;
	data = [];
	tempdata = [];
	@api sortedDirection = 'asc';
	@api sortedBy = 'Name';
	@api searchKey = '';
	result;
	page = 0;
	pageAdresse = 0;
	items = [];
	columns;
	startingRecord = 1;
	pageSize = 3;
	totalRecountCount = 0;
	resultatDeRecherche = '0 résultat de recherche';
	totalPage = 0;
	pages = [];
	selectedLocal = [];
	selectedRows = [];
	_title = 'Sample Title';
	message = 'Sample Message';
	variant = 'error';
	set_size = 6;
	listVilles = [];
	listAddresses = [];
	adresse = null;
	afficherResultat = false;
	maisonChoisi;
	appartChoisi;
	PDLValidation = false;
	PCEValidation = false;

	selectLocalForPopup = [];
	isClosing = false;

/* ________________________________________________________________________________________________________________________________________________________ */
/* _________________________________________________________ INIT FUNCTION _________________________________________________________________________ */
/* ________________________________________________________________________________________________________________________________________________________ */

	@api
	get record() {
		return this._record;
	}
	set record(value) {
		if (value) {
			//Recherche par PDL PCE
			this._record = { ...value };

            var tableForUndefinedValues = ['VI_PDLRechercheLocal__c','VI_PCERechercheLocal__c','VI_TypeRechercheLocal__c','VI_ChoixParcours__c','VI_ChoixEnergie__c',
											'VI_InfosCompl_IndexElec__c','VI_InfosCompl_IndexGaz__c','VI_InfosCompl_HP_HC__c','VI_InfosCompl_HeuresPleinesElec__c',
											'VI_InfosCompl_HeuresCreusesElec__c','VI_NumeroRueRechercheLocal__c','VI_RueRechercheLocal__c','VI_CodePostalRechercheLocal__c',
											'VI_CommuneRechercheLocal__c','VI_CodeCommuneIdentificationLocal__c','VI_RechercheLocal_AdresseComplete__c','VI_Contact__c',
											'VI_AdresseDeConsoIdentique__c','VI_AccordClientRechercheLocal__c','VI_LocalNonIdentifieGenerationCase__c','VI_NomPredecesseurRechercheLocal__c',
											'VI_TypeLogementRechercheLocal__c','VI_NumeroEtageRechercheLocal__c','VI_NumeroAppartementRechercheLocal__c','VI_IndexHPRechercheLocal__c',
											'VI_IndexHCRechercheLocal__c','VI_IndexBaseRechercheLocal__c','VI_NumeroMatriculeRechercheLocal__c','VI_DroiteGaucheRechercheLocal__c',
											'VI_NumeroMatriculeGAZRechercheLocal__c'];

            this.handleUndefinedValuesGlobal(tableForUndefinedValues);

			if (this._record.VI_TypeRechercheLocal__c === 'Recherche du local par adresse') {
				this.isRecherche = true;
				this.searchbyAdresse();
			}
			if (this._record.VI_TypeRechercheLocal__c === 'PDL/PCE connu par le client') {
				this.isPDLPCE = true;
				if ((this._record.VI_PDLRechercheLocal__c != null && this._record.VI_PDLRechercheLocal__c.length === 14)
					|| (this._record.VI_PCERechercheLocal__c != null && this._record.VI_PCERechercheLocal__c.length === 14)) {
					this.searchbyPDLPCE();
				}
			}

			if(this._record.VI_Contact__c == null || this._record.VI_Contact__c == ""){
				this.communeClient = this._record.VI_CommuneRechercheLocal__c
				this.codePostalClient = this._record.VI_CodePostalRechercheLocal__c
				this.adresseClient = this._record.VI_RechercheLocal_AdresseComplete__c
				this.rue = this._record.VI_RueRechercheLocal__c
				this.numeroRue = this._record.VI_NumeroRueRechercheLocal__c
			}else{
				this.getSelectedContactAddressFunc();
			}


			/* Start DDPCM - 871 */
			if (this._record.VI_ChoixParcours__c === 'CHF') {
				this.isCHF = true;
			}
			else {
				this.isCHF = false;
			}

			/* End DDPCM - 871 */
			if (this._record.VI_ChoixEnergie__c === 'Gaz') {
				this.isGaz = true;
				this.isElectricite = false;
				this.isGazEtElectricite = false;
			}
			else if (this._record.VI_ChoixEnergie__c === 'Electricité') {
				this.isElectricite = true;
				this.isGaz = false;
				this.isGazEtElectricite = false;
			}
			else if (this._record.VI_ChoixEnergie__c === 'Electricité + Gaz') {
				this.isGazEtElectricite = true;
				this.isElectricite = false;
				this.isGaz = false;
			}

			if (this._record.VI_InfosCompl_HP_HC__c === true) {
				this.isHPHC = true;
			}
			else {
				this.isHPHC = false;
			}

			//Recherche par adresse
			//Start DDPCM - 279 
			if (this._record.VI_Contact__c != null) {
				this.isIdentificationClientCompleted = true;
				/* Start DDPCM-852 New Cannaux */
				this.isRemplissageAutomatiqueLocal = true;
				/* End DDPCM-852 New Cannaux */
				/* Start DDPCM-1117 */
				this.clientDejaSelectionne = true;
				/* End DDPCM-1117 */
			}
			else {
				this.isIdentificationClientCompleted = false;
				/* Start DDPCM-852 New Cannaux */
				this.isRemplissageAutomatiqueLocal = false;
				/* End DDPCM-852 New Cannaux */
				/* Start DDPCM-1117 */
				this.clientDejaSelectionne = false;
				/* End DDPCM-1117 */
			}

			// END DDPCM - 279 

			if (this._record.VI_LocalNonIdentifieGenerationCase__c === null) {
				this._record.VI_LocalNonIdentifieGenerationCase__c = false;
			}
			else {
				this.PDLnonidentifie = this._record.VI_LocalNonIdentifieGenerationCase__c;
			}

			if (this._record.VI_TypeLogementRechercheLocal__c === 'Maison') {
				this.maisonChoisi = true;
			}
			else if (this._record.VI_TypeLogementRechercheLocal__c === 'Appartement') {
				this.appartChoisi = true;
			}

			/* Start DDPCM-727 New Cannaux */

			if (this._record.VI_TypeParcours__c === 'PURE PLAYERS') {
				this.showVisualisationDesCases = true;
			}
			else {
				/* Start DDPCM-852 New Cannaux */
				this.remplissageAutomatiqueNewCanaux = true;
				/* End DDPCM-852 New Cannaux */
			}
			/* End DDPCM-727 New Cannaux */
		}
		else {
			this._record = {};
		}
	}

	//rattacher le contact selectionné au parcours
	getSelectedContactAddressFunc() {
		getSelectedContactAddress
			(
				{
					parcours: this._record
				}
			).then(result => {
				var client = result;
				if (client.MailingCity !== null && client.MailingCity !== undefined) {
					this.communeClientSave = client.MailingCity.toUpperCase();
				}
				else {
					this.communeClientSave = null;
				}
				this.codePostalClientSave = client.MailingPostalCode;
				if (client.MailingStreet !== null && client.MailingStreet !== undefined) {
					this.rueSave = client.MailingStreet.toUpperCase();
				}
				else {
					this.rueSave = null;
				}
				this.numeroRueSave = client.No_Voie;
				this.adresseClientSave = this.numeroRueSave + ' ' + this.rueSave + ' ' + this.codePostalClientSave + ' ' + this.communeClientSave;

				/* Start DDPCM-852 New Cannaux */
				if (this._record.VI_TypeParcours__c != 'PURE PLAYERS' &&
				this._record.VI_RemplissageAutomatiqueAdresseLocal__c != true &&
				this._record.VI_Contact__c != null) {
					this.communeClient = this.communeClientSave;
					this.codePostalClient = this.codePostalClientSave;
					this.adresseClient = this.adresseClientSave;
					this.rue = this.rueSave;
					this.numeroRue = this.numeroRueSave;
					this.saveAdresseComplet();
				}else{
					this.communeClient = this._record.VI_CommuneRechercheLocal__c
					this.codePostalClient = this._record.VI_CodePostalRechercheLocal__c
					this.adresseClient = this._record.VI_RechercheLocal_AdresseComplete__c
					this.rue = this._record.VI_RueRechercheLocal__c
					this.numeroRue = this._record.VI_NumeroRueRechercheLocal__c
				}
				/* End DDPCM-852 New Cannaux */
			})
			.catch(error => {
				console.log('ERROR getSelectedContactAddress')
				console.log(error)
				this.error = error;
			});
	}

/* ________________________________________________________________________________________________________________________________________________________ */
/* _________________________________________________________ HANDLE BUTTON FUNCTION _________________________________________________________________________ */
/* ________________________________________________________________________________________________________________________________________________________ */

	handleButtonClick(event) {
		this.recordupdated = true;
		if (event.target.dataset.id === 'Recherche du local par adresse') {
			this._record.VI_TypeRechercheLocal__c = 'Recherche du local par adresse';
			this.totalRecountCount = 0;
			this.resultatDeRecherche = '0 résultat de recherche';
			this.afficherResultat = false;
			this.data = [];
			this.isPDLPCE = false;
			this.isRecherche = true;
			this.searchbyAdresse();
			/* Start DDPCM-852 New Cannaux */
			if (this._record.VI_TypeParcours__c != 'PURE PLAYERS' &&
				this._record.VI_RemplissageAutomatiqueAdresseLocal__c != true &&
				this._record.VI_Contact__c != null) {
					this.communeClient = this.communeClientSave;
					this.codePostalClient = this.codePostalClientSave;
					this.adresseClient = this.adresseClientSave;
					this.rue = this.rueSave;
					this.numeroRue = this.numeroRueSave;
					this.saveAdresseComplet();
			}
			/* End DDPCM-852 New Cannaux */

		}
		if (event.target.dataset.id === 'PDL/PCE connu par le client') {
			this._record.VI_TypeRechercheLocal__c = 'PDL/PCE connu par le client';
			this.totalRecountCount = 0;
			this.resultatDeRecherche = '0 résultat de recherche';
			this.data = [];
			this.afficherResultat = false;
			this.searchbyPDLPCE();
			this.isPDLPCE = true;
			this.isRecherche = false;
		}
		const dispatchEventSearch = new CustomEvent('typederecherchelocalchange');
		this.dispatchEvent(dispatchEventSearch);
	}

	removeNumberScroll(event) {
		event.target.blur();
	}

	handleHPHCClick(event) {
		this.recordupdated = true;
		this.showErrorMessage = false;
		if (event.target.dataset.id === 'HP/HC') {
			this._record.VI_InfosCompl_HP_HC__c = event.target.checked;
			this.isHPHC = event.target.checked;
		}
	}

	// Start DDPCM - 279 
	handleAdresseIdentique(event) {
		this._record.VI_AdresseDeConsoIdentique__c = event.target.checked;
		if (this._record.VI_AdresseDeConsoIdentique__c === true) {
			this.communeClient = this.communeClientSave;
			this.codePostalClient = this.codePostalClientSave;
			this.adresseClient = this.adresseClientSave;
			this.rue = this.rueSave;
			this.numeroRue = this.numeroRueSave;
			this.saveAdresseComplet();

			if (this._record.VI_AccordClientRechercheLocal__c === true) {
				this.searchbyAdresse();
			}
		}
		else {
			this.communeClient = '';
			this.codePostalClient = '';
			this.adresseClient = '';
			this.rue = '';
			this.numeroRue = '';
			this.saveAdresseComplet();
			this._record.VI_CodeCommuneIdentificationLocal__c = "";
			this._record.VI_PDLRechercheLocal__c = "";
			this._record.VI_PCERechercheLocal__c = "";
			this.resultatDeRecherche = '0 résultat de recherche';
			this.totalPage = 0;
			this.pages = [];
			this.selectedLocal = [];
			this.selectedRows = [];
			this.data = [];
			this.totalRecountCount = 0;
			this.afficherResultat = false;
			this._record.VI_LocalNonIdentifieGenerationCase__c = false;
			const dispatchEventAddressLocal = new CustomEvent('reinitializeaddresslocal');
			this.dispatchEvent(dispatchEventAddressLocal);
		}
	}
	// END DDPCM - 279 

	/* End DDPCM-852 New Cannaux */
	handleRemplissageAutomatiqueAdresseLocal(event) {
		this._record.VI_RemplissageAutomatiqueAdresseLocal__c = event.target.checked;
		if (this._record.VI_RemplissageAutomatiqueAdresseLocal__c === false) {
			this.communeClient = this.communeClientSave;
			this.codePostalClient = this.codePostalClientSave;
			this.adresseClient = this.adresseClientSave;
			this.rue = this.rueSave;
			this.numeroRue = this.numeroRueSave;
			this.saveAdresseComplet();
		}
		else {
			this.communeClient = '';
			this.codePostalClient = '';
			this.adresseClient = '';
			this.rue = '';
			this.numeroRue = '';
			this.saveAdresseComplet();
			this._record.VI_PDLRechercheLocal__c = "";
			this._record.VI_PCERechercheLocal__c = "";
			this.resultatDeRecherche = '0 résultat de recherche';
			this.totalPage = 0;
			this.pages = [];
			this.selectedLocal = [];
			this.selectedRows = [];
			this.data = [];
			this.totalRecountCount = 0;
			this.afficherResultat = false;
			this._record.VI_LocalNonIdentifieGenerationCase__c = false;
			const dispatchEventAddressLocal = new CustomEvent('reinitializeaddresslocal');
			this.dispatchEvent(dispatchEventAddressLocal);
		}
	}
	/* End DDPCM-852 New Cannaux */

	handleSearchPDLPCEChange(event) {
		this.recordupdated = true;
		let field = event.target.name;

		if (field === "PDL") {
			this._record.VI_PDLRechercheLocal__c = event.target.value;
			if (this._record.VI_PDLRechercheLocal__c !== null) {
				this._record.VI_PDLRechercheLocal__c = event.target.value.slice(0, 14);
				this.template.querySelector('[data-id="PDL"]').value = event.target.value.slice(0, 14);
				this.PDLValidation = false;
			}
			if (this._record.VI_PDLRechercheLocal__c !== null && this._record.VI_PDLRechercheLocal__c.length === 14) {
				this.PDLValidation = false;
				this.searchbyPDLPCE();
			}
			else {
				this.PDLValidation = true;
				this.data = [];
				this.totalRecountCount = 0;
				this.resultatDeRecherche = '0 résultat de recherche';
				if (this._record.VI_PCERechercheLocal__c.length === 14) {
					this.searchbyPDLPCE();
				}
			}
		}
		if (field === "PCE") {
			this._record.VI_PCERechercheLocal__c = event.target.value;
			if (this._record.VI_PCERechercheLocal__c !== null) {
				this.template.querySelector('[data-id="PCE"]').value = event.target.value.slice(0, 14);
				this._record.VI_PCERechercheLocal__c = event.target.value.slice(0, 14);
				this.PCEValidation = false;
			}
			if (this._record.VI_PCERechercheLocal__c !== null && this._record.VI_PCERechercheLocal__c.length === 14) {
				this.PCEValidation = false;
				this.searchbyPDLPCE();
			}
			else {
				this.data = [];
				this.totalRecountCount = 0;
				this.resultatDeRecherche = '0 résultat de recherche';
				this.PCEValidation = true;
				if (this._record.VI_PDLRechercheLocal__c.length === 14) {
					this.searchbyPDLPCE();
				}
			}
		}
		if (field === 'ConsentementClient') {
			this._record.VI_AccordClientRechercheLocal__c = event.target.checked;
			if (this._record.VI_AccordClientRechercheLocal__c === true) {
				this.searchbyPDLPCE();
			}
			else {

				this.data = [];
				this.totalRecountCount = 0;
				this.resultatDeRecherche = '0 résultat de recherche';
			}

		}
		if (field === 'ConsentementClientAdresse') {
			this._record.VI_AccordClientRechercheLocal__c = event.target.checked;
			if (this._record.VI_AccordClientRechercheLocal__c === true) {
				this.searchbyAdresse();
			}
			else {
				this.data = [];
				this.totalRecountCount = 0;
				this.resultatDeRecherche = '0 résultat de recherche';
			}
		}
	}

	handleRechercheAdresseChange(event) {
		this.recordupdated = true;
		let field = event.target.name;

		//Adresse
		if (field === 'Num') {
			this.numeroRue = event.target.value;
			this._record.VI_NumeroRueRechercheLocal__c = event.target.value;
			this.searchbyAdresse();
		}
		else if (field === 'Rue') {
			this.rue = event.target.value;
			this._record.VI_RueRechercheLocal__c = event.target.value;
			this.searchbyAdresse();
		}
		else if (field === 'CodePostal') {
			this.codePostalClient = event.target.value.slice(0, 5);
			this._record.VI_CodePostalRechercheLocal__c = event.target.value.slice(0, 5);
			this.searchbyAdresse();

			if (this._record.VI_CodePostalRechercheLocal__c === null || this._record.VI_CodePostalRechercheLocal__c === "") {
				this._record.VI_CommuneRechercheLocal__c = null;
			}


			this.listVilles = [];
			if (this._record.VI_CodePostalRechercheLocal__c.length >= 3) {
				this.updateAdresseWrapper();
			}
		}
		else if (field === 'Commune') {
			this.communeClient = event.target.value;
			this._record.VI_CommuneRechercheLocal__c = event.target.value;
			if (this._record.VI_CommuneRechercheLocal__c === null || this._record.VI_CommuneRechercheLocal__c === "") {
				this._record.VI_CodePostalRechercheLocal__c = null;
			}

			this.searchbyAdresse();
		}
		else if (field === 'Adresse') {
			this.adresseClient = event.target.value;
			// Start DDPCM - 279
			this._record.VI_RechercheLocal_AdresseComplete__c = event.target.value;
			// End DDPCM - 279
			this.template.querySelector('[data-id="listAdressesSuggested"]').classList.remove('slds-hide');
			this.getSuggestionsadresses();
		}
		else if (field === 'localNonIdentifié') {
			this._record.VI_LocalNonIdentifieGenerationCase__c = event.target.checked;
			if (this._record.VI_LocalNonIdentifieGenerationCase__c === true) {
				const dispatchEventSearch = new CustomEvent('localnonidentifie');
				this.dispatchEvent(dispatchEventSearch);
				this.PDLnonidentifie = true;
				if (this.template.querySelector('[data-id="PDLnonIdentifie"]') !== null) {
					this.template.querySelector('[data-id="PDLnonIdentifie"]').scrollIntoView(true);
				}
			}
		}
		else if (field === 'NomPrédécesseur') {
			this._record.VI_NomPredecesseurRechercheLocal__c = event.target.value;
		}
		else if (field === 'Etage') {
			this._record.VI_NumeroEtageRechercheLocal__c = event.target.value;
		}
		else if (field === 'TypeLogement') {
			this._record.VI_TypeLogementRechercheLocal__c = event.target.value;
			if (this._record.VI_TypeLogementRechercheLocal__c === 'Maison') {
				this.appartChoisi = false;
				this.maisonChoisi = true;
			}
			else if (this._record.VI_TypeLogementRechercheLocal__c === 'Appartement') {
				this.maisonChoisi = false;
				this.appartChoisi = true;
			}
		}
		else if (field === 'NumAppartement') {
			this._record.VI_NumeroAppartementRechercheLocal__c = event.target.value;
		}
		else if (field === 'IndexHP') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_IndexHPRechercheLocal__c = event.target.value.slice(0, 6);
				this.template.querySelector('[data-id="IndexHP"]').value = this._record.VI_IndexHPRechercheLocal__c;
			}
		}
		else if (field === 'IndexHC') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_IndexHCRechercheLocal__c = event.target.value.slice(0, 6);
				this.template.querySelector('[data-id="IndexHC"]').value = this._record.VI_IndexHCRechercheLocal__c;
			}
		}
		else if (field === 'IndexBase') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_IndexBaseRechercheLocal__c = event.target.value.slice(0, 6);
				this.template.querySelector('[data-id="IndexBase"]').value = this._record.VI_IndexBaseRechercheLocal__c;
			}
		}
		else if (field === 'NumMatricule') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_NumeroMatriculeRechercheLocal__c = event.target.value.slice(0, 5);
				this.template.querySelector('[data-id="NumMatricule"]').value = this._record.VI_NumeroMatriculeRechercheLocal__c;
			}


		}
		else if (field === 'DroiteGauche') {
			this._record.VI_DroiteGaucheRechercheLocal__c = event.target.value;
		}
	}

/* ________________________________________________________________________________________________________________________________________________________ */
/* _________________________________________________________ USEFULL FUNCTION _________________________________________________________________________ */
/* ________________________________________________________________________________________________________________________________________________________ */

	//sets the fields to null if they are empty
	handleUndefinedValuesGlobal(recordField) {
		for(var i = 0; i < recordField.length; i++){
			if (typeof this._record[recordField[i]] === "undefined") {
				this._record[recordField[i]] = null;
			}
		}
	}  	

	searchbyPDLPCE() {
		if (this._record.VI_AccordClientRechercheLocal__c === true) {
			this.afficherResultat = true;
			// Start DDPCM - 1117 
			this.rechercheParPDLPCELoaded = false;
			// End DDPCM - 1117 
			searchLocalbyPDLPCE(
				{
					PCE: this._record.VI_PCERechercheLocal__c,
					PDL: this._record.VI_PDLRechercheLocal__c
				}
			).then(result => {
				this.data = result;
				// Start DDPCM - 1117 
				this.rechercheParPDLPCELoaded = true;
				// End DDPCM - 1117 
				if (this.data.length > 0) {
					if (this.pageAdresse === 0) {
						this.page = 1;
					}
					else {
						this.page = this.pageAdresse;
					}
					this.selectedRows = [];

					if (this._record.VI_PDLRechercheLocal__c === null) {
						this._record.VI_PDLRechercheLocal__c = '';
					}
					if (this._record.VI_PCERechercheLocal__c === null) {
						this._record.VI_PCERechercheLocal__c = '';
					}
					for (let i = 0; i < this.data.length; i++) {
						if (this.data[i].PDL_PCE === this._record.VI_PDLRechercheLocal__c + '_' + this._record.VI_PCERechercheLocal__c) {
							this.selectedRows = [...this.selectedRows, this.data[i].PDL_PCE];
						}
					}
				}
				else {
					this.page = 0;
				}
				this.totalRecountCount = this.data.length;
				if (this.totalRecountCount === 0 || this.totalRecountCount === 1) {
					this.resultatDeRecherche = this.totalRecountCount + ' résultat de recherche';
				}
				else {
					this.resultatDeRecherche = this.totalRecountCount + ' résultats de recherche';
				}
				/* Start DDPCM-727 New Cannaux*/
				if (this.showVisualisationDesCases) {
					this.columns = columns;
				}
				else {
					this.columns = columnsAutreCannaux
				}
				/* End DDPCM-727 New Cannaux*/
				this.pages = [];
				this.setPages(this.data);
			})
				.catch(error => {
					this.error = error;
				});
		}
	}

	searchbyAdresse() {
		if (this._record.VI_AccordClientRechercheLocal__c === true &&
			this._record.VI_CodePostalRechercheLocal__c !== null &&
			this._record.VI_NumeroRueRechercheLocal__c !== null &&
			this._record.VI_RueRechercheLocal__c !== null &&
			this._record.VI_CommuneRechercheLocal__c !== null) {

			this.afficherResultat = true;
			// Start DDPCM - 1117 
			this.rechercheParAdresseLoaded = false;
			// End DDPCM - 1117 
			searchLocalbyAdresse(
				{
					ville: this._record.VI_CommuneRechercheLocal__c,
					codePostal: this._record.VI_CodePostalRechercheLocal__c,
					libelleVoie: this._record.VI_RueRechercheLocal__c,
					numeroVoie: this._record.VI_NumeroRueRechercheLocal__c,
					PDLChoisi: this._record.VI_PDLRechercheLocal__c,
					PCEChoisi: this._record.VI_PCERechercheLocal__c
				}
			).then(result => {
				this.data = result;
				// Start DDPCM - 1117 
				this.rechercheParAdresseLoaded = true;
				// End DDPCM - 1117 
				if (this.data.length > 0) {
					if (this.pageAdresse === 0) {
						this.page = 1;
					}
					else {
						this.page = this.pageAdresse;
					}
					this.selectedRows = [];

					if (this._record.VI_PDLRechercheLocal__c === null) {
						this._record.VI_PDLRechercheLocal__c = '';
					}
					if (this._record.VI_PCERechercheLocal__c === null) {
						this._record.VI_PCERechercheLocal__c = '';
					}
					for (let i = 0; i < this.data.length; i++) {
						if (this.data[i].PDL_PCE === this._record.VI_PDLRechercheLocal__c + '_' + this._record.VI_PCERechercheLocal__c) {
							this.selectedRows = [...this.selectedRows, this.data[i].PDL_PCE];
						}
					}
				}
				else {
					this.page = 0;
				}
				this.totalRecountCount = this.data.length;
				if (this.totalRecountCount === 0 || this.totalRecountCount === 1) {
					this.resultatDeRecherche = this.totalRecountCount + ' résultat de recherche';
				}
				else {
					this.resultatDeRecherche = this.totalRecountCount + ' résultats de recherche';
				}
				/* Start DDPCM-727 New Cannaux*/
				if (this.showVisualisationDesCases) {
					this.columns = columns;
				}
				else {
					this.columns = columnsAutreCannaux
				}
				/* End DDPCM-727 New Cannaux*/
				this.pages = [];
				this.setPages(this.data);
			})
			.catch(error => {
				this.error = error;
			});
		}
		else {
			this.data = [];
			this.selectedRows = [];
		}
	}

	saveAdresseComplet(){
		this._record.VI_NumeroRueRechercheLocal__c = this.numeroRue;
		this._record.VI_RueRechercheLocal__c = this.rue;
		this._record.VI_CodePostalRechercheLocal__c = this.codePostalClient;
		this._record.VI_CommuneRechercheLocal__c = this.communeClient;
		this._record.VI_RechercheLocal_AdresseComplete__c = this.adresseClient;
	}

	//get the number of pages to display in a page
	get pagesList() {
		let mid = Math.floor(this.set_size / 2) + 1;
		if (this.page > mid) {
			return this.pages.slice(this.page - mid, this.page + mid - 1);
		}
		return this.pages.slice(0, this.set_size);
	}

	//get the records to display in a specific page
	pageData = () => {
		let page = this.page;
		this.pageAdresse = page;
		let perpage = this.pageSize;
		let startIndex = (page * perpage) - perpage;
		let endIndex = (page * perpage);
		for (let i = 0; i < this.data.slice(startIndex, endIndex).length; i++) {
			if (!this.data.slice(startIndex, endIndex)[i].infoRecuperees) {
				this.donneesLocauxLoaded = false;
				break;
			}
		}
		if (!this.donneesLocauxLoaded) {
			getInfosSuppPDLPCEfromAdresse({
				locaux: JSON.stringify(this.data),
				startIndexApex: startIndex,
				endIndexApex: endIndex
			}).then(result => {
				this.donneesLocauxLoaded = true;
				this.data = result;

			});
		}
		return this.data.slice(startIndex, endIndex);
	}

	//get the number of pages based on the number of records fetched
	setPages = (data) => {
		let numberOfPages = Math.ceil(data.length / this.pageSize);
		if (numberOfPages !== 1) {
			for (let index = 1; index <= numberOfPages; index++) {
				this.pages.push(index);
			}
		}
	}

	//displays the arrow if the page has a previous
	get hasPrev() {
		return this.page > 1;
	}

	//displays the arrow if the page has a next
	get hasNext() {
		return this.page < this.pages.length
	}

	//move to the next page
	onNext = () => {
		this.template.querySelector('[data-id="' + this.page + '"]').classList.remove('rectangle-click');
		++this.page;
		++this.pageAdresse;
		this.template.querySelector('[data-id="' + this.page + '"]').classList.add('rectangle-click');
	}
	//move to the previous page
	onPrev = () => {
		this.template.querySelector('[data-id="' + this.page + '"]').classList.remove('rectangle-click');
		--this.page;
		--this.pageAdresse;
		this.template.querySelector('[data-id="' + this.page + '"]').classList.add('rectangle-click');
	}

	//move to the desired page
	onPageClick = (e) => {
		this.template.querySelector('[data-id="' + this.page + '"]').classList.remove('rectangle-click');
		this.page = parseInt(e.target.dataset.id, 10);
		this.template.querySelector('[data-id="' + this.page + '"]').classList.add('rectangle-click');

	}

	//get current page data
	get currentPageData() {
		return this.pageData();
	}

	handleRelevesChange(event) {
		this.recordupdated = true;
		let field = event.target.name;
		if (field === 'VotreIndex1') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_InfosCompl_IndexElec__c = event.target.value.slice(0, 5);
				if (this.isElectricite) {
					this.template.querySelector('[data-id="IndexElec1"]').value = this._record.VI_InfosCompl_IndexElec__c;
				}
				else if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="IndexElec2"]').value = this._record.VI_InfosCompl_IndexElec__c;
				}
			}
		}
		if (field === 'HeuresPleines') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_InfosCompl_HeuresPleinesElec__c = event.target.value.slice(0, 5);
				if (this.isElectricite) {
					this.template.querySelector('[data-id="HeuresPleines1"]').value = this._record.VI_InfosCompl_HeuresPleinesElec__c;
				}
				else if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="HeuresPleines2"]').value = this._record.VI_InfosCompl_HeuresPleinesElec__c;
				}
			}
		}
		if (field === 'HeuresCreuses') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_InfosCompl_HeuresCreusesElec__c = event.target.value.slice(0, 5);
				if (this.isElectricite) {
					this.template.querySelector('[data-id="HeuresCreuses1"]').value = this._record.VI_InfosCompl_HeuresCreusesElec__c;
				}
				else if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="HeuresCreuses2"]').value = this._record.VI_InfosCompl_HeuresCreusesElec__c;
				}
			}
		}
		if (field === 'VotreIndex2') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_InfosCompl_IndexGaz__c = event.target.value.slice(0, 5);
				if (this.isGaz) {
					this.template.querySelector('[data-id="IndexGaz1"]').value = this._record.VI_InfosCompl_IndexGaz__c;
				}
				else if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="IndexGaz2"]').value = this._record.VI_InfosCompl_IndexGaz__c;
				}
			}
		}
		if (field === 'MatriculeCompteurELEC') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_NumeroMatriculeRechercheLocal__c = event.target.value.slice(0, 10);
				if (this.isElectricite) {
					this.template.querySelector('[data-id="MatriculeCompteurELEC1"]').value = this._record.VI_NumeroMatriculeRechercheLocal__c;
				}
				else if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="MatriculeCompteurELEC2"]').value = this._record.VI_NumeroMatriculeRechercheLocal__c;
				}
			}
		}
		if (field === 'MatriculeCompteurGAZ') {
			if (event.target.value !== null) {
				event.target.value = event.target.value.replace(/[^0-9]*/g, '');
				this._record.VI_NumeroMatriculeGAZRechercheLocal__c = event.target.value.slice(0, 10);
				if (this.isGaz) {
					this.template.querySelector('[data-id="MatriculeCompteurGAZ1"]').value = this._record.VI_NumeroMatriculeGAZRechercheLocal__c;
				}
				else if (this.isGazEtElectricite) {
					this.template.querySelector('[data-id="MatriculeCompteurGAZ2"]').value = this._record.VI_NumeroMatriculeGAZRechercheLocal__c;
				}
			}
		}
		this.checkReleveValues();
	}

	checkReleveValues() {
		if (this.isGaz) {
			if (this._record.VI_InfosCompl_IndexGaz__c !== null) {
				let indexGazDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexGaz__c);
				if (this._record.VI_InfosCompl_IndexGaz__c.toString().length >= 1 &&
					indexGazDifferenZero) {
					this.releveCompteurCompleted = true;
				}
				else {
					this.releveCompteurInitialized = true;
				}
			}
		}
		else if (this.isElectricite) {
			let heuresPleinesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresPleinesElec__c);
			let heuresCreusesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresCreusesElec__c);

			if (this.isHPHC) {
				if ((this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && heuresPleinesDifferenZero) ||
					(this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && heuresCreusesDifferenZero)) {
					this.releveCompteurInitialized = true;
				}
				if (this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && heuresPleinesDifferenZero &&
					this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && heuresCreusesDifferenZero) {
					if (this._record.VI_InfosCompl_HeuresPleinesElec__c.toString().length >= 1 &&
						this._record.VI_InfosCompl_HeuresCreusesElec__c.toString().length >= 1) {
						this.releveCompteurCompleted = true;
					}
				}
			}
			else {
				if (this._record.VI_InfosCompl_IndexElec__c !== null) {
					let indexElecDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexElec__c);
					if (this._record.VI_InfosCompl_IndexElec__c.toString().length >= 1 &&
						indexElecDifferenZero) {
						this.releveCompteurCompleted = true;
					}

					else {

						this.releveCompteurInitialized = true;
					}
				}
			}
		}
		else if (this.isGazEtElectricite) {
			let indexGazDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexGaz__c);
			let indexElecDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexElec__c);
			let heuresPleinesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresPleinesElec__c);
			let heuresCreusesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresCreusesElec__c);

			if (this.isHPHC) {
				if ((this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && heuresPleinesDifferenZero) ||
					(this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && heuresCreusesDifferenZero) ||
					(this._record.VI_InfosCompl_IndexGaz__c !== null && indexGazDifferenZero)) {
					this.releveCompteurInitialized = true;
				}

				if (this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && heuresPleinesDifferenZero &&
					this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && heuresCreusesDifferenZero &&
					this._record.VI_InfosCompl_IndexGaz__c !== null && indexGazDifferenZero) {
					if (this._record.VI_InfosCompl_HeuresPleinesElec__c.toString().length >= 1 &&
						this._record.VI_InfosCompl_HeuresCreusesElec__c.toString().length >= 1 &&
						this._record.VI_InfosCompl_IndexGaz__c.toString().length >= 1) {
						this.releveCompteurCompleted = true;
					}
				}
			}
			else {
				if ((this._record.VI_InfosCompl_IndexElec__c !== null && indexElecDifferenZero) ||
					(this._record.VI_InfosCompl_IndexGaz__c !== null && indexGazDifferenZero)) {
					this.releveCompteurInitialized = true;
				}
				if (this._record.VI_InfosCompl_IndexElec__c !== null && indexElecDifferenZero &&
					this._record.VI_InfosCompl_IndexGaz__c !== null && indexGazDifferenZero) {
					if (this._record.VI_InfosCompl_IndexElec__c.toString().length >= 1 &&
						this._record.VI_InfosCompl_IndexGaz__c.toString().length >= 1) {
						this.releveCompteurCompleted = true;
					}
				}
			}
		}
		if (this.releveCompteurCompleted === true) {
			const dispatchEventSearch = new CustomEvent('detailsreleveremplis');
			this.dispatchEvent(dispatchEventSearch);
			this.releveCompteurCompleted = false;
		}
		else if (this.releveCompteurCompleted === false && this.releveCompteurInitialized === true) {
			const dispatchEventSearch = new CustomEvent('detailsrelevesinities');
			this.dispatchEvent(dispatchEventSearch);
			this.releveCompteurInitialized = false;
		}
		else {
			const dispatchEventSearch = new CustomEvent('detailsrelevesvides');
			this.dispatchEvent(dispatchEventSearch)
		}
	}

	checkDifferentThanZero(valueToCompare) {
		if (valueToCompare !== "0" && valueToCompare !== "00" &&
			valueToCompare !== "000" && valueToCompare !== "0000" &&
			valueToCompare !== "00000") {
			return true;
		}
		return false;
	}

	checkListAdresse() {
		this.template.querySelector('[data-id="listAdressesSuggested"]').classList.remove('slds-hide');
	}

	onblurAdresse() {
		this.template.querySelector('[data-id="listAdressesSuggested"]').classList.add('slds-hide');
	}

	getSuggestionsadresses() {
		if (this.adresseClient.length > 4) {
			getAdresseList
				(
					{
						adresse: this.adresseClient
					}
				).then(result => {
					this.listAddresses = result;

				})
				.catch(error => {
					this.error = error;
				});
		}
	}

	selectAdresse(event) {
		this.template.querySelector('[data-id="listAdressesSuggested"]').classList.add('slds-hide');
		var selectedadresse = event.currentTarget.dataset;
		this.adresseClient = selectedadresse.label;
		this.communeClient = selectedadresse.ville;
		this.codePostalClient = selectedadresse.codepostal;
		this.rue = selectedadresse.voie;
		this.numeroRue = selectedadresse.numero;

		this.saveAdresseComplet();
		this.searchbyAdresse();
	}

	checkListVille() {
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.remove('slds-hide');
	}
	removeListVille() {
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
	}

	updateVilles() {
		getListVille
			(
				{
					codePostal: this._record.VI_CodePostalRechercheLocal__c
				}
			).then(result => {
				this.listVilles = result;

			})
			.catch(error => {
				this.error = error;
			});
	}

	updateAdresseWrapper() {
		getVillesCodePostal
			(
				{
					codePostal: this._record.VI_CodePostalRechercheLocal__c
				}
			).then(result => {
				this.listVilles = result;

			})
			.catch(error => {
				this.error = error;
			});
	}

	selectVilleValue(event) {
		var selectedadresse = event.currentTarget.dataset;

		this._record.VI_CommuneRechercheLocal__c = selectedadresse.ville;
		this._record.VI_CodeCommuneIdentificationLocal__c = selectedadresse.codecommune;
		this.template.querySelector('[data-id="ville"]').value = selectedadresse.ville;
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
	}

	checkListAdresse() {
		this.template.querySelector('[data-id="listAdressesSuggested"]').classList.remove('slds-hide');
	}

	updateParcours(event) {
		const datatable = this.template.querySelector('lightning-datatable');
		if (datatable != null) {
			const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
			if (selectedRows.length > 0) {
				this.selectedLocal = selectedRows[0];
				this._record.VI_CodeCommuneIdentificationLocal__c = this.selectedLocal.codeCommune;
				this._record.VI_PDLRechercheLocal__c = this.selectedLocal.PDL;
				this._record.VI_PCERechercheLocal__c = this.selectedLocal.PCE;
				this._record.VI_NumeroRueRechercheLocal__c = this.selectedLocal.numeroVoie;
				this._record.VI_RueRechercheLocal__c = this.selectedLocal.libelleVoie;
				this._record.VI_CodePostalRechercheLocal__c = this.selectedLocal.codePostal;
				this._record.VI_CommuneRechercheLocal__c = this.selectedLocal.ville;
				this._record.VI_RechercheLocal_AdresseComplete__c = this.selectedLocal.numeroVoie + ' ' + this.selectedLocal.libelleVoie + ' ' + this.selectedLocal.codePostal + ' ' + this.selectedLocal.ville;
				/* Start DDPCM - 674 */
				this._record.VI_typeCompteurElec__c = this.selectedLocal.typeCompteurElec;
				this._record.VI_typeCompteurGaz__c = this.selectedLocal.typeCompteurGaz;
				/* End DDPCM - 674 */
				// Start DDPCM - 279 
				if (this._record.VI_AdresseDeConsoIdentique__c) {
					this._record.VI_AdresseDeConsoIdentique__c = false;
					this._record.VI_LocalNonIdentifieGenerationCase__c = false;
				}
				// END DDPCM - 279 
				//this.updateParcoursLocal();
				const dispatchEvent = new CustomEvent('handlesaveetapelocal');
				this.dispatchEvent(dispatchEvent);
			}
			else {
				this._title = 'Erreur';
				this.message = 'Merci de sélectionner un local';
				this.variant = 'error';
				this.showNotification();
			}
		}
		else {
			this._title = 'Erreur';
			this.message = 'Merci de sélectionner un local';
			this.variant = 'error';
			this.showNotification();
		}
	}

	updateParcoursAdresse() {
		const datatable = this.template.querySelector('lightning-datatable');
		if (datatable != null) {
			const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
			if (selectedRows.length > 0) {
				this.selectedLocal = selectedRows[0];
				this._record.VI_CodeCommuneIdentificationLocal__c = this.selectedLocal.codeCommune;
				this._record.VI_PDLRechercheLocal__c = this.selectedLocal.PDL;
				this._record.VI_PCERechercheLocal__c = this.selectedLocal.PCE;
				this._record.VI_NumeroRueRechercheLocal__c = this.selectedLocal.numeroVoie;
				this._record.VI_RueRechercheLocal__c = this.selectedLocal.libelleVoie;
				this._record.VI_CodePostalRechercheLocal__c = this.selectedLocal.codePostal;
				this._record.VI_CommuneRechercheLocal__c = this.selectedLocal.ville;
				this._record.VI_CodeCommuneIdentificationLocal__c = this.selectedLocal.codeCommune;
				/* Start DDPCM - 674 */
				this._record.VI_typeCompteurElec__c = this.selectedLocal.typeCompteurElec;
				this._record.VI_typeCompteurGaz__c = this.selectedLocal.typeCompteurGaz;
				/* End DDPCM - 674 */
				this.updateParcoursLocal();

				if (this.template.querySelector('[data-id="PDLnonIdentifie"]') !== null) {
					this.template.querySelector('[data-id="PDLnonIdentifie"]').scrollIntoView(true);
				}

				this._recordupdated = true;
				const dispatchEvent = new CustomEvent("handlecontinuer");
				this.dispatchEvent(dispatchEvent);
				this.page=1;
				this.pageAdresse=1;
				this.template.querySelector('[data-id="' + this.page + '"]').classList.add('rectangle-click');
			}
			else {
				this._title = 'Erreur';
				this.message = 'Merci de sélectionner un local';
				this.variant = 'error';
				this.showNotification();
			}
		}
		else {
			this._title = 'Erreur';
			this.message = 'Merci de sélectionner un local';
			this.variant = 'error';
			this.showNotification();
		}
	}
	updateParcoursNonidentifie(event) {
		const dispatchEvent = new CustomEvent('handlesaveetapelocal');
		this.dispatchEvent(dispatchEvent);
	}

	showNotification() {
		const evt = new ShowToastEvent({
			title: this._title,
			message: this.message,
			variant: this.variant,
		});
		this.dispatchEvent(evt);
	}

	updateParcoursLocal() {
		updateParcoursSF
			(
				{
					PDL: this.selectedLocal.PDL,
					PCE: this.selectedLocal.PCE,
					numeroVoie: this.selectedLocal.numeroVoie,
					libelleVoie: this.selectedLocal.libelleVoie,
					codePostal: this.selectedLocal.codePostal,
					codeCommune: this.selectedLocal.codeCommune,
					ville: this.selectedLocal.ville,
					accordClient: this._record.VI_AccordClientRechercheLocal__c,
					parcourId: this._record.Id,
					typeRechercheLocal: this._record.VI_TypeRechercheLocal__c
				}
			).then(result => {
				if (result == null) {}
			})
			.catch(error => {
				this._title = 'Erreur';
				this.message = error;
				this.variant = 'error';
				this.showNotification();
			});
	}

	updateParcoursLocalNonidentifie() {
		updateParcoursLocalNonidentifieSF
			(
				{
					PDL: this.selectedLocal.PDL,
					PCE: this.selectedLocal.PCE,
					numeroVoie: this.selectedLocal.numeroVoie,
					libelleVoie: this.selectedLocal.libelleVoie,
					codePostal: this.selectedLocal.codePostal,
					codeCommune: this.selectedLocal.codeCommune,
					ville: this.selectedLocal.ville,
					accordClient: this._record.VI_AccordClientRechercheLocal__c,
					parcourId: this._record.Id,
					typeRechercheLocal: this._record.VI_TypeRechercheLocal__c,
					localNonIdentifie: this._record.VI_LocalNonIdentifieGenerationCase__c,
					nomPredecesseur: this._record.VI_NomPredecesseurRechercheLocal__c,
					typeLogement: this._record.VI_TypeLogementRechercheLocal__c,
					etage: this._record.VI_NumeroEtageRechercheLocal__c,
					numeroAppart: this._record.VI_NumeroAppartementRechercheLocal__c,
					indexHP: this._record.VI_IndexHPRechercheLocal__c,
					indexHC: this._record.VI_IndexHCRechercheLocal__c,
					indexBase: this._record.VI_IndexBaseRechercheLocal__c,
					numeroMatricule: this._record.VI_NumeroMatriculeRechercheLocal__c,
					droiteGauche: this._record.VI_DroiteGaucheRechercheLocal__c,
					/* start DDPCM - 279*/
					adresseIdentique: this._record.VI_AdresseDeConsoIdentique__c,
					/* end DDPCM - 279*/
					/* Start DDPCM - 671 */
					typeCompteurElec: this._record.VI_typeCompteurElec__c,
					typeCompteurGaz: this._record.VI_typeCompteurGaz__c
					/* End DDPCM - 671 */
				}
			).then(result => {
				if (result == null) {
				}

			})
			.catch(error => {
				this._title = 'Erreur';
				this.message = error;
				this.variant = 'error';
				this.showNotification();
			});
	}
	onFormSubmit(event) {
		event.preventDefault();
		event.stopPropagation();
	}
	handleDecimal(event) {
		if (event.key === ',' || event.key === '.') {
			event.preventDefault();
		}
	}

	handlePrecedent(event) {
		const dispatchEventSearch = new CustomEvent('precedent');
		this.dispatchEvent(dispatchEventSearch);
	}

	handleSuivant(event) {
		const dispatchEventSearch = new CustomEvent('suivant');
		this.dispatchEvent(dispatchEventSearch);
	}

	/* Start DDPCM - 371 */

	handleRowAction(event) {
		if (event.detail.action.name === 'PDLPCE_Icon') {
			this.selectLocalForPopup = event.detail.row;

			if (this.selectLocalForPopup.cases !== null &&
				this.selectLocalForPopup.cases !== undefined &&
				this.selectLocalForPopup.cases.length > 0) {
				/* Start DDPCM - 900 */
				this.isModalOpenBackgroundVisualisationCase = true;
				this.isModalVisualisationCaseOpen = true;
				/* End DDPCM - 900 */
				this.isOffreEnCoursReliee = true;
			}
			else {
				this.isOffreEnCoursReliee = false;
			}

		}
	}

	// Open / close Modal
	openModalVisualisationCase() {
		const datatable = this.template.querySelector('lightning-datatable');
		if (datatable != null) {
			const selectedRowsForPopup = this.template.querySelector('lightning-datatable').getSelectedRows();
			if (selectedRowsForPopup.length > 0) {
				this.selectLocalForPopup = selectedRowsForPopup[0];
				if (this.selectLocalForPopup.cases !== null &&
					this.selectLocalForPopup.cases !== undefined &&
					this.selectLocalForPopup.cases.length > 0) {
					/* Start DDPCM - 900 */
					this.isModalOpenBackgroundVisualisationCase = true;
					this.isModalVisualisationCaseOpen = true;
					/* End DDPCM - 900 */
					this.isOffreEnCoursReliee = true;
				}
				else {
					this.isOffreEnCoursReliee = false;
				}
			}
		}
	}

	closeModalVisualisationCase() {
		this.isModalOpenBackgroundVisualisationCase = false;
		this.isModalVisualisationCaseOpen = false;
	}

	/* END DDPCM - 371 */
	// Start Visualisation des Cases

	navigateToHomePage() {
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: '/PartnerCommunityENGIE/s/'
			}
		});
	}

	cancelParcours() {
		annulerParcours({
			parcours: this._record,
			motif: "Offre ENGIE en cours de souscription",
			commentaire: ""
		});
		this.navigateToHomePage();

		this.isModalOpenBackgroundVisualisationCase = false;
		this.isModalVisualisationCaseOpen = false;
	}

	handlePaste(event) {
		event.preventDefault();
	}

	handleContext(event) {
		event.preventDefault();
	}
}

const columns = [
	{ label: ' ', fieldName: 'PDLPCE', initialWidth: 175, wrapText: true },
	{ type: 'button-icon', initialWidth: 75, typeAttributes: { iconName: 'utility:warning', class: { fieldName: 'showIcon' }, name: 'PDLPCE_Icon', size: 'large', variant: "bare" }, cellAttributes: { class: 'buttonIconDataTable' } },
	{ label: 'TYPE COMPTEUR', fieldName: 'combinaisonTypeCompteur', initialWidth: 175, wrapText: true, cellAttributes: { class: 'TypeCompteur' }, type: 'text' },
	{ label: 'MATRICULE', fieldName: 'Matricules', initialWidth: 175, typeAttributes: { hideDefaultActions: true }, wrapText: true },
	{ label: 'ADRESSE', fieldName: 'adressePDLPCE' }
];

/* Start DDPCM-727 New Cannaux*/
const columnsAutreCannaux = [
	{ label: ' ', fieldName: 'PDLPCE', initialWidth: 175, wrapText: true },
	{ label: 'TYPE COMPTEUR', fieldName: 'combinaisonTypeCompteur', initialWidth: 175, wrapText: true, cellAttributes: { class: 'TypeCompteur' }, type: 'text' },
	{ label: 'MATRICULE', fieldName: 'Matricules', initialWidth: 175, typeAttributes: { hideDefaultActions: true }, wrapText: true },
	{ label: 'ADRESSE', fieldName: 'adressePDLPCE' }
];
/* End DDPCM-727 New Cannaux*/

const columns2 = [
	{ label: 'canal', fieldName: 'Canal', wrapText: true },
	{ label: 'energie', fieldName: 'Energie' },
	{ label: 'dateDenvoi', fieldName: 'Date d\' Envoi' }
];