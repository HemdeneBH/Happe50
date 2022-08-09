import { LightningElement, api, track } from 'lwc';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import createCoobClient from '@salesforce/apex/VI_ParcoursPPMPaiement_Controller.createCoobClient';
import getCoobClient from '@salesforce/apex/VI_ParcoursPPMPaiement_Controller.getCoobClient';
import createAccount from '@salesforce/apex/VI_ParcoursPPMPaiement_Controller.createAccount';
import createCoobClientLWC from '@salesforce/apex/VI_ParcoursPPMPaiement_Controller.createCoobClientLWC';
import createCoobClientIBANExistant from '@salesforce/apex/VI_ParcoursPPMPaiement_Controller.chooseIBANexistant';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ParcoursPPSaisiePaiements extends LightningElement {

	barreGrise = EngieCommunityResource + '/EngieAssets/pictures/barregrise.png';
	cadenas = EngieCommunityResource + '/EngieAssets/pictures/cadenas.png';
	commentaireImage = EngieCommunityResource + '/EngieAssets/pictures/crayon_modif.png';
	commentaireImage1 = EngieCommunityResource + '/EngieAssets/pictures/crayon_modif1.png';
	optionDropImage = EngieCommunityResource + '/EngieAssets/pictures/fleche-droite.png';
	//DDPCM 302 Start
	checkboxIban = EngieCommunityResource + '/EngieAssets/pictures/checkbox_iban.png';
	//DDPCM 302 End
	//DDPCM 786 Start
	closeImage = EngieCommunityResource + '/EngieAssets/pictures/close-icon.png';
	//DDPCM 786 End


	prel = 'Prélèvement automatique';

	isAuto = true;
	isEdoc = false;
	isEnLigne = false;
	isDeuxMois = false;
	isFR = true;
	// Start DDPCM - 276
	isConfirmerPossible = true;
	// End DDPCM - 276
	// START IBAN En SELFCARE
	isShowIBAN = true;
	// END IBAN En SELFCARE
	// Start DDPCM - 840 New Canaux
	isNewCanaux = false;
	// End DDPCM - 840 New Canaux
	// Start DDPCM - 1109 New Canaux
	informationMensualisation = false;
	informationEspaceClient = false;
	informationEFacture = false;
	informationEDoc = false;
	// End DDPCM - 1109 New Canaux
	/* Start DDPCM - 1110 */
	isMensualisationNon = false;
	isMensualisationOui = false;
	isFactureNon = false;
	isFactureOui = false;
	isEdocNon = false;
	isEdocOui = false;
	isErrorMensualité = false;
	isErrorEDoc = false;
	/* End DDPCM - 1110 */
	// Start DDPCM - 854 New Canaux
	isModalOpenWarningMensualite = false;
	isModalOpenBackgroundWarningMensualite = false;
	// End DDPCM - 854 New Canaux
	// Start DDPCM - 786 New Canaux
	isMensualisationAccessible = false;
	isModalOpenAjustementMensualite = false;
	isBackgroundModalOpenAjustementMensualite = false;
    showButtonPlus = false;
    showButtonMoins = false;
	isOrange = false;
    isBlue = true;
    isGreen = false;
    myAjustement = 0;
	isAjustementMensuNot0 = 0;
	isEuroSup = 0;
    isEuroInf = 0;
	offreTotalPriceInitValue = 0;
	offreTotalPriceVarRounded = 0;
	offreTotalPriceVar = 0;
    copieOffreTotalPriceVarRounded = 0;
    copieOffreTotalPriceVar = 0;
	pourcentageOffreTotalPrice = 0;

	@api
	get reopenpopupmensualisation() {
		return this._reopenPopUpMensualisation;
	}
	set reopenpopupmensualisation(value) {
		this._reopenPopUpMensualisation = value;
	}

	// End DDPCM - 786 New Canaux

	loaded = false;
	coobId = null;
	iban;

	@track
	cooblist;

	@track
	isExistant;

	@track boxColor;

	coobListReplace;
	showErrorOnSuivant = false;
	@track selectedCoobList = {
		IbanNumber: "",
		IbanNumberX: "",
		Nombanque: "",
		TitulaireCompte: "",
		bic: "",
		idCompteClientCoordB: "",
		idCoordonneeBancaire: "",
		libelle: ""
	};

	_title = 'Sample Title';
	message = 'Sample Message';
	variant = 'error';


	@track
	myMap;

	@track
	boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 157, 233, 1);"

	/* Start DDPCM 786 */
    @track viModalButtonMinusMensualite = "vi-modal-button-minus-mensualite borderColorBlueClass fontColorBlueClass";
    @track viModalButtonPlusMensualite = "vi-modal-button-plus-mensualite borderColorBlueClass fontColorBlueClass";
	/* End DDPCM 786 */

	@api
	isIban = false;

	@api
	isValideTitulaire;
	@api
	isValaideIban;
	@api
	ibanOk;
	@api
	isTest;
	@api
	titulaireOK;
	@api
	numIban;
	@api
	nomTitulaire = '';

	showMessageTitul = false;
	showMessageIban = false;

	ibanSpace = '';

	@api
	messageCreationIban = '';

	@api
	messageCreationCompte = '';
	@api
	parcours1;

	recup;
	/*recupIban = {
	titulaire,
	iban,
	nomBanque,
	bic
};*/



	handleChange(event) {
		this.value = event.detail.value;
	}


	@api
	get recordupdated() {
		return this._recordupdated;
	}
	set recordupdated(value) {
		this._recordupdated = value;
	}

	/*@api
	get alliscompleted(){
			return this._alliscompleted;
	}
	set alliscompleted(value) {
			this.alliscompleted = value;
	}

	@api
	get alliscompleted() {
			return this._alliscompleted;
	}
	set alliscompleted(value) {
			this._alliscompleted = value;
	} */


	@api alliscompleted;

	@api
	get record() {
		return this._record;
	}
	set record(value) {
		if (value) {
			this._record = { ...value };
			this.handleUndefinedValues('VI_IBANMoyendePaiement__c');
			this.handleUndefinedValues('VI_NomTitulaireMoyendePaiement__c');
			this.handleUndefinedValues('VI_ChoixParcours__c');
			this.handleUndefinedValues('VI_ChoixEnergie__c');
			this.handleUndefinedValues('VI_Contact__c');
			this.handleUndefinedValues('VI_PDLRechercheLocal__c');
			this.handleUndefinedValues('VI_PCERechercheLocal__c');
			this.handleUndefinedValues('VI_LocalNonIdentifieGenerationCase__c');
			this.handleUndefinedValues('VI_ChoixOffreSurParcoursPanierClient__c');
			this.handleUndefinedValues('VI_Id_coordonnees_bancaires__c');
			// START IBAN En SELFCARE
			this.handleUndefinedValues('VI_IBANEnSelfCare__c');
			// END IBAN En SELFCARE
			/* Start DDPCM 1110 */
			this.handleUndefinedValues('VI_ChoixMensualisation__c');
			this.handleUndefinedValues('VI_FactureEnLigne__c');
			this.handleUndefinedValues('VI_EdocsMoyensPaiement__c');
			/* End DDPCM 1110 */
			/* Start DDPCM 786 */
			this.handleUndefinedValues('VI_AjustementMensualitesPanierClient__c');
            this.handleUndefinedValues('VI_MontantdelaMensualitePanierClient__c');
			this.handleUndefinedValues('VI_MontantOptionPanierClient__c');
			/* End DDPCM 786 */
			console.log('*');
			console.log('id coob ----> ' + this._record.VI_Id_coordonnees_bancaires__c);
			console.log('this._record.VI_Id_coordonnees_bancaires__c : '+ this._record.VI_Id_coordonnees_bancaires__c);
			if (this._record.VI_Id_coordonnees_bancaires__c != null && this._record.VI_Id_coordonnees_bancaires__c !== undefined) {
				//this.handleStatusCompleted();
				this.coobId = this._record.VI_Id_coordonnees_bancaires__c;
				this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 153, 52, 1);"
			}

			if (typeof this._record.VI_FrequencePrelevementMoyendePaiement__c === "undefined") {
				this._record.VI_FrequencePrelevementMoyendePaiement__c = 'Mensuel';
				this.isDeuxMois = false;
			}
			if (this._record.VI_FrequencePrelevementMoyendePaiement__c === 'Tous les deux mois') {
				this.isDeuxMois = true;

			}
			if (typeof this._record.VI_ChoixMoyenPaiement__c === "undefined") {
				this._record.VI_ChoixMoyenPaiement__c = 'Prélèvement automatique';
			}
			if (this._record.VI_ChoixMoyenPaiement__c === "Autre") {
				this.isAuto = false;
				//this.handleStatusCompleted();
			}
			this.isIban = true;

			//	this.recupCoob();
			if (this._record.VI_Id_coordonnees_bancaires__c === undefined) {
				this.isExistant = true;
			}
			// START IBAN En SELFCARE
			if (this._record.VI_IBANEnSelfCare__c === true) {
				this.isShowIBAN = false;
			}
			else {
				this.isShowIBAN = true;
			}
			// END IBAN En SELFCARE
			// Start DDPCM - 840 New Canaux
			if (this._record.VI_TypeParcours__c != 'PURE PLAYERS') {
				//this.handleStatusCompleted();
				this.isNewCanaux = true;
				/* Start DDPCM 1110 */
				/* Start DDPCM 786 */
				if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === 'Offre poussée' || this._record.VI_ChoixOffreSurParcoursPanierClient__c === 'Offre de repli') {
					this.isMensualisationAccessible = true;
					this.offreTotalPriceInitValue = parseFloat(this._record.VI_MontantOffrePanierClient__c);
					this.pourcentageOffreTotalPrice = this.offreTotalPriceInitValue / 100;
					this.myAjustement = parseFloat(this._record.VI_AjustementMensualitesPanierClient__c);
					this.offreTotalPriceVar = parseFloat(this._record.VI_MontantdelaMensualitePanierClient__c);
					this.offreTotalPriceVarRounded = Math.ceil(parseFloat(this.offreTotalPriceVar));
				}
				else {

				}
				/* End DDPCM 786 */
				if (this._record.VI_ChoixMensualisation__c === 'Non') {
					this.isMensualisationNon = true;
					this.isMensualisationOui = false;
				}
				else if (this._record.VI_ChoixMensualisation__c === 'Oui') {
					this.isMensualisationOui = true;
					this.isMensualisationNon = false;
				}
				else {
					this.isMensualisationOui = false;
					this.isMensualisationNon = false;
				}

				if (this._record.VI_FactureEnLigne__c === 'Non') {
					this.isFactureNon = true;
					this.isFactureOui = false;
				}
				else if (this._record.VI_FactureEnLigne__c === 'Oui') {
					this.isFactureOui = true;
					this.isFactureNon = false;
				}
				else {
					this.isFactureNon = false;
					this.isFactureOui = false;
				}

				if (this._record.VI_EdocsMoyensPaiement__c === 'Non') {
					this.isEdocNon = true;
					this.isEdocOui = false;
				}
				else if (this._record.VI_EdocsMoyensPaiement__c === 'Oui') {
					this.isEdocOui = true;
					this.isEdocNon = false;
				}
				else {
					this.isEdocOui = false;
					this.isEdocNon = false;
				}
			}
			else {
				if (this._record.VI_FactureEnLigne__c === 'Oui') {
					this.isFactureOui = true;
				}
				else {
					this.isFactureOui = false;
				}
				if (this._record.VI_EdocsMoyensPaiement__c != 'Oui' && this._record.VI_EdocsMoyensPaiement__c != 'Non') {
					this._record.VI_EdocsMoyensPaiement__c = 'Oui';
					this.isEdocOui = true;
				}
				if (this._record.VI_EdocsMoyensPaiement__c === 'Oui') {
					this.isEdocOui = true;
				}
				else if (this._record.VI_EdocsMoyensPaiement__c === 'Non') {
					this.isEdocOui = false;
				}
			}

			/* End DDPCM 1110 */
			// End DDPCM - 840 New Canaux
		} else {
			this._record = {};
		}
	}

	get isTousLesDeuxmois() {
		let freq;
		if (this._record.VI_FrequencePrelevementMoyendePaiement__c === 'Tous les deux mois') {
			freq = true;
		}
		else {
			freq = false;
		}
		return freq;
	}

	@api
	get isPrelevementAutomatique() {
		let freq;
		if (this._record.VI_ChoixMoyenPaiement__c === 'Prélèvement automatique') {
			freq = true;
			this.isAuto = true;
		}
		else {
			freq = false;
			this.isAuto = false;
		}
		return freq;
	}





	@api
	handleServiceGestion() {
		this._recordupdated = true;
		console.log('compl avant ' + this.alliscompleted);
		// Start DDPCM - 840 New Canaux
		if (this._record.VI_TypeParcours__c != 'PURE PLAYERS') {
			// Start DDPCM - 1110
			if (this.isMensualisationNon === true || this.isMensualisationOui === true) {
				this.isErrorMensualité = false;
			}
			else {
				this.isErrorMensualité = true;
			}
			if (this.isEdocNon === true || this.isEdocOui === true) {
				this.isErrorEDoc = false;
			}
			else {
				this.isErrorEDoc = true;
			}
			if (this.isErrorMensualité === false && this.isErrorEDoc === false) {
				this._record.VI_ChoixMoyenPaiement__c = 'Autre';
				this.isAuto = false;
				this._record.VI_Id_coordonnees_bancaires__c = null;
				this._record.VI_FrequencePrelevementMoyendePaiement__c = null;
				this.handleStatusCompleted();
			}
			// End DDPCM - 1110		
		}
		else {
			// End DDPCM - 840 New Canaux
			this._record.VI_Id_coordonnees_bancaires__c = this.coobId;
			// Start DDPCM - 840 New Canaux
		}
		// End DDPCM - 840 New Canaux
		const dispatchEventSearch = new CustomEvent('continuer');
		this.dispatchEvent(dispatchEventSearch);
		console.log('comp apres ' + this.alliscompleted);
		if (this.alliscompleted === false || (this._record.VI_Id_coordonnees_bancaires__c === null && this._record.VI_ChoixMoyenPaiement__c === "Prélèvement automatique")) {
			this.showErrorOnSuivant = true;
		}
		//this.updatParcours();
	}

	//sets the fields to null if they are empty
	handleUndefinedValues(recordField) {
		if (typeof this._record[recordField] === "undefined") {
			this._record[recordField] = null;
		}
	}

	//sets the checkbox to false if they are empty
	handleFalseValues(recordField) {
		if (typeof this._record[recordField] === "undefined") {
			this._record[recordField] = false;
		}
	}
	connectedCallback() {
		if (this._record.VI_TypeParcours__c != 'PURE PLAYERS') {
			this.loaded = true;
			if (this._reopenPopUpMensualisation === true) {
				this.openModalAjustementMensualite();
			}
		}
		else {
			this.recupCoob();
		}
	}


	handlePrelevementAutoClick(event) {
		this._recordupdated = true;

		if (event.target.checked) {
			this._record.VI_ChoixMoyenPaiement__c = this.prel;
			this.isAuto = true;
			this._record.VI_Id_coordonnees_bancaires__c = this.coobId;
			this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 157, 233, 1);";
			this._record.VI_FrequencePrelevementMoyendePaiement__c = 'Mensuel';
			this.isDeuxMois = false;
			//Coob not chosen
			// Start-840 New Cannaux
			if (this._record.VI_TypeParcours__c === 'PURE PLAYERS') {
				this._record.VI_FactureEnLigne__c = 'Oui';
				// Start DDPCM 1506
				if (this._record.VI_IBANEnSelfCare__c === true) {
					const dispatchEventSearch = new CustomEvent('saisiepaiementcompleted');
					this.dispatchEvent(dispatchEventSearch);
				}
				else {
					// Start DDPCM - 840 New Cannaux
				this.handleStatusNotInitialized();
					// End DDPCM - 840 New Cannaux
				}
				// End DDPCM 1506
			}
			else {
				this.handleStatusCompleted();
			}
			// End DDPCM-840 New Cannaux
		}
		else {
			this._record.VI_ChoixMoyenPaiement__c = 'Autre';
			this.isAuto = false;
			this._record.VI_Id_coordonnees_bancaires__c = null;
			this._record.VI_FrequencePrelevementMoyendePaiement__c = null;
			/* Start DDPCM - 1029 */
			if (this._record.VI_MontantOffrePanierClient__c && this._record.VI_MontantOffrePanierClient__c != this._record.VI_MontantdelaMensualitePanierClient__c) {
				this._record.VI_MontantdelaMensualitePanierClient__c = this._record.VI_MontantOffrePanierClient__c;
				this._record.VI_AjustementMensualitesPanierClient__c = '0';
			}
			/* End DDPCM - 1029 */
			// End Start-840 New Cannaux
			if (this._record.VI_TypeParcours__c === 'PURE PLAYERS') {
				this._record.VI_FactureEnLigne__c = 'Non';
			}
			// End DDPCM-840 New Cannaux
			this.handleStatusCompleted();
		}
		//this.updatParcours();
	}

	// START IBAN EN SELFCARE

	handleIBANSELFCARE(event){
		if (event.target.checked) {
			this.isShowIBAN = false;
			this._record.VI_IBANEnSelfCare__c = true;
			this._record.VI_NomTitulaireMoyendePaiement__c = '';
			//this._record.VI_Id_coordonnees_bancaires__c = null;
			//this._record.VI_FrequencePrelevementMoyendePaiement__c = null;
			//this.handleStatusCompleted();
			const dispatchEventSearch = new CustomEvent('saisiepaiementcompleted');
			this.dispatchEvent(dispatchEventSearch);
		}
		else {
			this.isShowIBAN = true;
			this._record.VI_IBANEnSelfCare__c = false;
			if (this.isConfirmerPossible) {
				this.handleStatusNotInitialized();
			}
			else {
				const dispatchEventSearch = new CustomEvent('saisiepaiementcompleted');
				this.dispatchEvent(dispatchEventSearch);
			}
		}
		console.log("VI_IBANEnSelfCare__c = ", + this._record.VI_IBANEnSelfCare__c);
		this._recordupdated = true;
	}

	// END IBAN En SELFCARE

	handleTest() {
		this._recordupdated = true;

		if (this.isTest === true) {
			this.isTest = false;
			this._record.VI_Id_coordonnees_bancaires__c = null;
			console.log('nouveau client');
			this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 157, 233, 1);"


		}
		else {
			this.isTest = true;
			console.log('Client existant');
			this._record.VI_NomTitulaireMoyendePaiement__c = '';
			//if(this._record.VI_Id_coordonnees_bancaires__c != null && this._record.VI_Id_coordonnees_bancaires__c !== undefined){
			if (this.isConfirmerPossible) {
				this.handleStatusNotInitialized();
				this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 157, 233, 1);"
			}
			else {
				if (this.coobId != null) {
					this._record.VI_Id_coordonnees_bancaires__c = this.coobId;
					//this.handleStatusCompleted();
					console.log('VI_coordonnees filled');
				}
				this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 153, 52, 1);"
				const dispatchEventSearch = new CustomEvent('saisiepaiementcompleted');
				this.dispatchEvent(dispatchEventSearch);
			}
		}
		//this.updatParcours();
	}


	handleFrequencePrelevement(event) {
		this._recordupdated = true;
		if (event.target.checked) {
			this._record.VI_FrequencePrelevementMoyendePaiement__c = 'Tous les deux mois';
			this.isDeuxMois = true;
			if (this._record.VI_MontantOffrePanierClient__c && this._record.VI_MontantOffrePanierClient__c != this._record.VI_MontantdelaMensualitePanierClient__c) {
				this._record.VI_MontantdelaMensualitePanierClient__c = this._record.VI_MontantOffrePanierClient__c;
				this._record.VI_AjustementMensualitesPanierClient__c = '0';
			}
		}
		else {
			this._record.VI_FrequencePrelevementMoyendePaiement__c = 'Mensuel';
			this.isDeuxMois = false;
		}
		//this.handleStatusAvaible();
		//this.updatParcours();
	}

	ibanIsOk(event) {
		this._recordupdated = true;
		console.log('inside isIbanOK');
		let field = event.target.name;
		console.log('field' + field);
		let ibanSansEspace;
		let verifIban;
		this.isFR = false;

		if (field === 'iban') {

			//supprime toutes les lettres saisies par l'utilisateur dans le champs iban et récupère les valeurs saisies par bloque
			const x = event.target.value.replace(/[^A-Za-z0-9]+/g, '').match(/(\w{0,2})(\w{0,4})(\w{0,4})(\w{0,4})(\w{0,4})(\w{0,4})(\w{0,3})/);

			//determine comment les bloques sont retounés à l'input et rajoute les espaces entre les bloques
			event.target.value = !x[1] ? `` : `${x[1]}` + (x[2] ? `  ${x[2]}` : ``) + (x[3] ? `  ${x[3]}` : ``) + (x[4] ? `  ${x[4]}` : ``) + (x[5] ? `  ${x[5]}` : ``) + (x[6] ? `  ${x[6]}` : ``) + (x[7] ? `  ${x[7]}` : ``);

			//suppression des espaces
			ibanSansEspace = event.target.value.replace(/[^A-Z0-9]+/gi, '');
				
				
			verifIban =  ibanSansEspace.match(/^([A-Z0-9]{25})$/);
 

			if ((verifIban) && (ibanSansEspace.length == 25)) {
				this.ibanOk = true;
				this.isValideIban = true;
				this.iban = 'FR' + ibanSansEspace;
				//this._record.VI_IBANMoyendePaiement__c = 
				console.log("checkPoint 1");
			}
			else {
				this.ibanOk = false;
				this.isValideIban = false;
			}
		}

		if (field === 'titulaire') {

			if (event.target.value !== undefined) {
				this._record.VI_NomTitulaireMoyendePaiement__c = event.target.value;
				//this.template.querySelector('[data-id="titul"]').value = null;
				this.titulaireOK = true;
				console.log("checkPoint 2");
				console.log(event.target.value.length);
				this.isValideTitulaire = true;
			}
			else {

				this.titulaireOK = false;
			}

			if (event.target.value.length == 0) {
				this.isValideTitulaire = false;
			}
		}

		if (this.titulaireOK && this.ibanOk) {
			this.isIban = false;
			console.log("checkPoint 3");

		}

		if (!this.titulaireOK || !this.ibanOk) {
			this.isIban = true;
			console.log("checkPoint 4");
		}

		this.handleStatusAvaibleIbanTitulaire();
	}

	validationIban() {
		let ibanSansEspace;
		let verifIban;
		//supprime toutes les lettres saisies par l'utilisateur dans le champs iban et récupère les valeurs saisies par bloque
		let iban = this.template.querySelector('[data-id="iban"]').value;
			
			
		const x =  iban.replace(/[^A-Za-z0-9]+/g, '').match(/(\w{0,2})(\w{0,4})(\w{0,4})(\w{0,4})(\w{0,4})(\w{0,4})(\w{0,3})/) ;

		//determine comment les bloques sont retounés à l'input et rajoute les espaces entre les bloques
		iban = !x[1] ? `` : `${x[1]}` + (x[2] ? `  ${x[2]}` : ``) + (x[3] ? `  ${x[3]}` : ``) + (x[4] ? `  ${x[4]}` : ``) + (x[5] ? `  ${x[5]}` : ``) + (x[6] ? `  ${x[6]}` : ``) + (x[7] ? `  ${x[7]}` : ``);

		//suppression des espaces
		ibanSansEspace = iban.replace(/[^A-Z0-9]+/gi, '');
		verifIban = ibanSansEspace.match(/^([A-Z0-9]{25})$/);


		if ((verifIban) && (ibanSansEspace.length == 25)) {
			this.ibanOk = true;
			this.isValideIban = true;
			this.iban = 'FR' + ibanSansEspace;
			//this._record.VI_IBANMoyendePaiement__c = 'FR'+ibanSansEspace;
			console.log("checkPoint 1");
		}
		else {
			this.ibanOk = false;
			this.isValideIban = false;
		}
	}

	validationTitulaire() {
		let titulaire = this.template.querySelector('[data-id="titul"]').value;
		if (titulaire !== undefined) {
			this._record.VI_NomTitulaireMoyendePaiement__c = titulaire;
			//this.template.querySelector('[data-id="titul"]').value = null;
			this.titulaireOK = true;
			console.log("checkPoint 2");
			console.log(titulaire);
			this.isValideTitulaire = true;
		}
		else {

			this.titulaireOK = false;
		}

		if (titulaire === 0) {
			this.isValideTitulaire = false;
		}
	}

	//Validation de la saisie de l'iban
	handleSaisieIban() {
		if (this._record.VI_StatutParcours__c !== 'CPV Envoyées: PDL/PCE connu' &&
			this._record.VI_StatutParcours__c !== 'CPV Envoyées: PDL/PCE non connu') {

			this.validationIban();
			this.validationTitulaire();
			if (this.titulaireOK && this.ibanOk) {
				this.isIban = false;
				console.log("checkPoint 3");

			}

			if (!this.titulaireOK || !this.ibanOk) {
				this.isIban = true;
				console.log("checkPoint 4");
			}
			console.log('handleSaisieIban');
			console.log('this.isValideIban' + this.isValideIban);
			console.log('this.isValideTitulaire' + this.isValideTitulaire);
			if (this.isValideIban && this.isValideTitulaire) {
				console.log('inside if statement');
				console.log('titulaire sauvegardé : ' + this._record.VI_NomTitulaireMoyendePaiement__c);
				console.log('iban sauvegardé : ' + this._record.VI_IBANMoyendePaiement__c);
				this.loaded = false;
				let checkCoobExistResponse = this.checkCoobExist()
				if (checkCoobExistResponse === null) {
					this.creerCompte();
					this._recordupdated = true;
					this.isTest = true;

				}
				else {
					this.loaded = true;
					this._title = 'Succès';
					this.message = 'Les coordonnées bancaires saisies existent dans la liste des coordonnées bancaires existantes.';
					this.variant = 'success';
					console.log('checkCoobExistResponse');
					console.log(checkCoobExistResponse);
					this.selectedCoobList.IbanNumber = checkCoobExistResponse.IbanNumber;
					this.selectedCoobList.IbanNumberX = checkCoobExistResponse.IbanNumberX;
					this.selectedCoobList.bic = checkCoobExistResponse.bic;
					this.selectedCoobList.Nombanque = checkCoobExistResponse.Nombanque;
					this.selectedCoobList.idCoordonneeBancaire = checkCoobExistResponse.idCoordonneeBancaire;
					this.selectedCoobList.TitulaireCompte = checkCoobExistResponse.TitulaireCompte;
					this.selectedCoobList.idCompteClientCoordB = checkCoobExistResponse.idCompteClientCoordB;
					this.selectedCoobList.libelle = checkCoobExistResponse.libelle;
					this.selectedCoobList = checkCoobExistResponse;
					this.isTest = true;
					console.log('this.selectedCoobList');
					console.log(this.selectedCoobList);
					this.coobId = checkCoobExistResponse.idCoordonneeBancaire;
					this.showNotification();

					this.handleConfirmerIban();

				}

				//this.recupCoob();
				//this._record.VI_NomTitulaireMoyendePaiement__c = '';
				//this._record.VI_IBANMoyendePaiement__c = '';
				//this.handleStatusAvaible();
				//this.template.querySelector('[data-id="serviceGestion"]').scrollIntoView(true);


			}
			console.log('Check fields');
			console.log('this._record.VI_NomTitulaireMoyendePaiement__c' + this._record.VI_NomTitulaireMoyendePaiement__c);
			if (this.template.querySelector('[data-id="titul"]').value.length === 0 || this._record.VI_NomTitulaireMoyendePaiement__c === null) {
				console.log('if titulaire');
				this.showMessageTitul = true;
				this.handleStatusAvaible();

			}
			else {
				console.log('else titulaire');
				this.showMessageTitul = false;
			}
			console.log('IBAN' + this.template.querySelector('[data-id="iban"]').value.length);
			console.log('IBAN' + this.template.querySelector('[data-id="iban"]').value);
			console.log('this._record.VI_IBANMoyendePaiement__c' + this._record.VI_IBANMoyendePaiement__c);
			if (this.template.querySelector('[data-id="iban"]').value.length < 37 || this._record.VI_IBANMoyendePaiement__c === null) {
				console.log('if iban');
				this.showMessageIban = true;
				this.handleStatusAvaible();

			}
			else {
				console.log('else iban');
				this.showMessageIban = false;
			}
			this._recordupdated = true;
			//this.updatParcours();
			console.log('this.showMessageTitul' + this.showMessageTitul);
			console.log('this.showMessageIban' + this.showMessageIban);
		}
	}

	//check if coob already in list
	checkCoobExist() {
		console.log('inside checkCoobExist');
		for (let i = 0; i < this.coobList.length; i++) {
			if (this.coobList[i].IbanNumber === this._record.VI_IBANMoyendePaiement__c) {
				console.log(this.coobList[i]);
				return this.coobList[i];
			}
		}
		return null;
	}

	//récupération de coordonnées bancaires
	recupCoob() {
		this.loaded = false;
		getCoobClient(
			{
				parcours: this._record
			}
		).then(result => {
			console.log('result');
			console.log(result);
			if (result != null && (result.message === null || result.message === undefined || result.message === '')) {
				this.coobList = result.coordonnees;
				console.log('coob Id on record' + this._record.VI_Id_coordonnees_bancaires__c);
				if (this.coobList !== null && this.coobList.length > 0) {

					this.isExistant = true;

					if (this._record.VI_Id_coordonnees_bancaires__c !== null) {
						for (let i = 0; i < this.coobList.length; i++) {
							console.log('i' + this.coobList[i]);
							console.log(this.coobList[i]);
							if (this.coobList[i].idCoordonneeBancaire === this._record.VI_Id_coordonnees_bancaires__c) {
								console.log('selectedCoobList' + i);
								console.log("this.coobList[i]");
								console.log(this.coobList[i]);

								this.isConfirmerPossible = false;

								//this.selectedCoobList = this.coobList[i];
								this.selectedCoobList.IbanNumber = this.coobList[i].IbanNumber;
								this.selectedCoobList.IbanNumberX = this.coobList[i].IbanNumberX;
								this.selectedCoobList.bic = this.coobList[i].bic;
								this.selectedCoobList.Nombanque = this.coobList[i].Nombanque;
								this.selectedCoobList.idCoordonneeBancaire = this.coobList[i].idCoordonneeBancaire;
								this.selectedCoobList.TitulaireCompte = this.coobList[i].TitulaireCompte;
								this.selectedCoobList.idCompteClientCoordB = this.coobList[i].idCompteClientCoordB;
								this.selectedCoobList.libelle = this.coobList[i].libelle;
								this.selectedCoobList.isSigned = this.coobList[i].isSigned;
								this.coobId = this.coobList[i].idCoordonneeBancaire;
								console.log("paul statut iban " + this.coobList[i].statutMandat);

							}
						}
					}
					else {
						//this.selectedCoobList = this.coobList[0];
						console.log('test' + this.coobList[0]);
						console.log(this.coobList[0]);
						this.selectedCoobList.IbanNumber = this.coobList[0].IbanNumber;
						this.selectedCoobList.IbanNumberX = this.coobList[0].IbanNumberX;
						this.selectedCoobList.bic = this.coobList[0].bic;
						this.selectedCoobList.Nombanque = this.coobList[0].Nombanque;
						this.selectedCoobList.idCoordonneeBancaire = this.coobList[0].idCoordonneeBancaire;
						this.selectedCoobList.TitulaireCompte = this.coobList[0].TitulaireCompte;
						this.selectedCoobList.idCompteClientCoordB = this.coobList[0].idCompteClientCoordB;
						this.selectedCoobList.libelle = this.coobList[0].libelle;
						this.selectedCoobList.isSigned = this.coobList[0].isSigned;
						this.coobId = this.coobList[0].idCoordonneeBancaire;
						console.log("paul statut iban2 " + this.coobList[0].statutMandat);
					}
				}
			}
			else if (result != null && result.message != null) {
				this._title = 'Erreur';
				this.message = result.meesage;
				this.variant = 'error';
				this.showNotification();
				this.isTest = false;

			}
			console.log('iban du client récupéré : ' + this.coobList);
			if (this.coobList && this.coobList.length != 0) {
				this.isTest = true;
			}
			this.loaded = true;
			this._recordupdated = true;
			//this.updatParcours();

		})
	}

	// création de compte client
	creerCompte() {
		console.log('creerCompte');
		this._record.VI_IBANMoyendePaiement__c = this.iban;
		createCoobClientLWC(
			{
				parcours: this._record
			}
		).then(result => {
			console.log('//////////////////////////////////////  result pour createCoobClientLWC');
			console.log(result);
			console.log('result ibanClientWrapper : ' + result.ibanClientWrapper);
			let ibanClient;
			this.messageCreationCompte = result.message;
			this._record = result.parcours;
			this._recordupdated = true;
			console.log('this._record');
			console.log(this._record);
			this._record.VI_IBANMoyendePaiement__c = null;
			if (this.messageCreationCompte != undefined && this.messageCreationCompte != null) {
				this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 157, 233, 1);"
				this._title = 'Erreur';

				this.message = this.messageCreationCompte;

				this.variant = 'error';
				this.showNotification();
				this.loaded = true;
				this.isTest = false;

			} else {
				this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 153, 52, 1);"
				console.log("ibanClientWrapper in else  creerCompte : " + result.ibanClientWrapper);
				ibanClient = result.ibanClientWrapper;
				console.log('ibanClient.coordonnees');
				console.log(ibanClient.coordonnees);
				console.log(this._record.VI_Id_coordonnees_bancaires__c);

				if (ibanClient !== undefined && ibanClient !== null) {
					if (ibanClient.coordonnees !== null && ibanClient.coordonnees !== undefined) {
						this.coobList = ibanClient.coordonnees;
						for (let i = 0; i < this.coobList.length; i++) {
							console.log('i' + this.coobList[i]);
							console.log(this.coobList[i]);
							if (this.coobList[i].idCoordonneeBancaire === this._record.VI_Id_coordonnees_bancaires__c) {
								console.log(this.coobList[i].idCoordonneeBancaire);
								console.log('selectedCoobList' + i);
								//this.selectedCoobList = this.coobList[i];
								this.selectedCoobList.IbanNumber = this.coobList[i].IbanNumber;
								this.selectedCoobList.IbanNumberX = this.coobList[i].IbanNumberX;
								this.selectedCoobList.bic = this.coobList[i].bic;
								this.selectedCoobList.Nombanque = this.coobList[i].Nombanque;
								this.selectedCoobList.idCoordonneeBancaire = this.coobList[i].idCoordonneeBancaire;
								this.selectedCoobList.TitulaireCompte = this.coobList[i].TitulaireCompte;
								this.selectedCoobList.idCompteClientCoordB = this.coobList[i].idCompteClientCoordB;
								this.selectedCoobList.libelle = this.coobList[i].libelle;
								this.selectedCoobList.isSigned = false;
								this.coobId = this.coobList[i].idCoordonneeBancaire;
							}
						}
					}
				}
				this.coobId = this._record.VI_Id_coordonnees_bancaires__c;
				this.loaded = true;
				this.isTest = true;
				this._title = 'Succès';
				this.message = 'Les coordonnées bancaires saisies sont correctes.';
				this.variant = 'success';
				this._recordupdated = true;
				this.showNotification();

				this.handleConfirmerIban();

				//this.updatParcours();

			}
			//this.handleStatusCompleted();
			console.log('création de compte : ' + this.messageCreationCompte);
		})
	}

	handleGestion(event) {
		let checkbox = event.target.name;
		if (checkbox === 'factureEnLigne') {
			if (event.target.checked) {
				this._record.VI_FactureEnLigne__c = 'Oui';
				this.isFactureOui = true;
				this._recordupdated = true;
				//this.updatParcours();
			}
			else {
				this._record.VI_FactureEnLigne__c = 'Non';
				this.isFactureOui = false;
				this._recordupdated = true;				
				//this.updatParcours();
			}
		}

		if (checkbox === 'eDoc') {
			if (event.target.checked) {
				this._record.VI_EdocsMoyensPaiement__c = 'Oui';
				this.isEdocOui = true;
				this._recordupdated = true;
			}
			else {
				this._record.VI_EdocsMoyensPaiement__c = 'Non';
				this.isEdocOui = false;
				this._recordupdated = true;
			}
		}

		// Start DDPCM 854 New Canaux
		if (checkbox === 'Mensualisation') {
			
			if (event.target.checked) {
				this._record.VI_ChoixMensualisation__c = 'Oui';
				this._recordupdated = true;
			}
			else {
				this._record.VI_ChoixMensualisation__c = 'Non';
				this._recordupdated = true;
				this.OpenModalWarningMensualite();
			}

		}

		/* Start DDPCM - 1110 */
		if (checkbox === 'MensualisationOui') {
			
			if (event.target.checked) {
				this.isMensualisationNon = false;
				this.isMensualisationOui = true;
				this._record.VI_ChoixMensualisation__c = 'Oui';
				/* Start DDPCM - 786 */
				if ((this._record.VI_ChoixOffreSurParcoursPanierClient__c === 'Offre poussée' || this._record.VI_ChoixOffreSurParcoursPanierClient__c === 'Offre de repli')
					&& (this._record.VI_MontantdelaMensualitePanierClient__c && Number(this._record.VI_MontantdelaMensualitePanierClient__c) > 0)) {
						this.openModalAjustementMensualite();
					}
				/* End DDPCM - 786 */
				this.handleMensualisationServicedeGestion();
				/* Start DDPCM 1094 */
				if (this._record.VI_EdocsMoyensPaiement__c === 'Oui' || this._record.VI_EdocsMoyensPaiement__c === 'Non') {
					this.handleStatusServiceDeGestionCompleted();
				}
				else {
					this.handleStatusServiceDeGestion();
				}
				/* End DDPCM 1094 */
			}
		}

		if (checkbox === 'MensualisationNon') {
			if (event.target.checked) {
				this.isMensualisationNon = true;
				this.isMensualisationOui = false;
				this._record.VI_ChoixMensualisation__c = 'Non';
				/* Start DDPCM - 786 */
				this.myAjustement = 0;
				this._record.VI_AjustementMensualitesPanierClient__c = '0';
				this.colorAjustement();
				this.isAjustementMensuNot0 = false;
				this.offreTotalPriceVar = this.offreTotalPriceInitValue;
				this.offreTotalPriceVarRounded = this.offreTotalPriceInitValue;
				this._record.VI_MontantdelaMensualitePanierClient__c = this._record.VI_MontantOffrePanierClient__c;
				this.offreTotalPriceVar = parseFloat(this._record.VI_MontantdelaMensualitePanierClient__c);
				/* End DDPCM - 786 */
				this.OpenModalWarningMensualite();
				this.handleMensualisationServicedeGestion();
				/* Start DDPCM 1094 */
				if (this._record.VI_EdocsMoyensPaiement__c === 'Oui' || this._record.VI_EdocsMoyensPaiement__c === 'Non') {
					this.handleStatusServiceDeGestionCompleted();
				}
				else {
					this.handleStatusServiceDeGestion();
				}
				/* End DDPCM 1094 */
			}
		}

		if (checkbox === 'FactureOui') {
			if (event.target.checked) {
				this.isFactureNon = false;
				this.isFactureOui = true;
				this._record.VI_FactureEnLigne__c = 'Oui';
				/* Start DDPCM 1094 */
				if ((this._record.VI_ChoixMensualisation__c === 'Non' || this._record.VI_ChoixMensualisation__c === 'Non') &&
					(this._record.VI_EdocsMoyensPaiement__c === 'Oui' || this._record.VI_EdocsMoyensPaiement__c === 'Non')) {
					this.handleStatusServiceDeGestionCompleted();
				}
				else {
					this.handleStatusServiceDeGestion();
				}
				/* End DDPCM 1094 */
			}
		}

		if (checkbox === 'FactureNon') {
			if (event.target.checked) {
				this.isFactureNon = true;
				this.isFactureOui = false;
				this._record.VI_FactureEnLigne__c = 'Non';
				/* Start DDPCM 1094 */
				if ((this._record.VI_ChoixMensualisation__c === 'Non' || this._record.VI_ChoixMensualisation__c === 'Non') &&
					(this._record.VI_EdocsMoyensPaiement__c === 'Oui' || this._record.VI_EdocsMoyensPaiement__c === 'Non')) {
					this.handleStatusServiceDeGestionCompleted();
				}
				else {
					this.handleStatusServiceDeGestion();
				}
				/* End DDPCM 1094 */
			}
		}

		if (checkbox === 'EdocOui') {
			if (event.target.checked) {
				this.isEdocNon = false;
				this.isEdocOui = true;
				this._record.VI_EdocsMoyensPaiement__c = 'Oui';
				/* Start DDPCM 1094 */
				if (this._record.VI_ChoixMensualisation__c === 'Non' || this._record.VI_ChoixMensualisation__c === 'Non') {
					this.handleStatusServiceDeGestionCompleted();
				}
				else {
					this.handleStatusServiceDeGestion();
				}
				/* End DDPCM 1094 */
			}
		}

		if (checkbox === 'EdocNon') {
			if (event.target.checked) {
				this.isEdocNon = true;
				this.isEdocOui = false;
				this._record.VI_EdocsMoyensPaiement__c = 'Non';
				/* Start DDPCM 1094 */
				if (this._record.VI_ChoixMensualisation__c === 'Non' || this._record.VI_ChoixMensualisation__c === 'Non') {
					this.handleStatusServiceDeGestionCompleted();
				}
				else {
					this.handleStatusServiceDeGestion();
				}
				/* End DDPCM 1094 */
			}
		}
		/* End DDPCM - 1110 */

		// End DDPCM 854 New Canaux

		this.handleStatusCheckbox();
		this._recordupdated = true;
		//this.updatParcours();
	}

	handlePrecedent() {
		console.log("### précédent : ");
		const dispatchEventSearch = new CustomEvent('precedent');
		this.dispatchEvent(dispatchEventSearch);
		console.log("### précédent FIN : ");
		this._recordupdated = true;
		//this.updatParcours();
	}

	handleStatusCheckbox() {
		const dispatchEventSearch = new CustomEvent('saisiepaiementcheckbox');
		this.dispatchEvent(dispatchEventSearch);
		this._recordupdated = true;
	}

	handleStatusAvaible() {
		const dispatchEventSearch = new CustomEvent('saisiepaiementavailable');
		this.dispatchEvent(dispatchEventSearch);
		this._recordupdated = true;
		//this.updatParcours();
	}

	handleStatusAvaibleIbanTitulaire() {
		const dispatchEventSearch = new CustomEvent('saisiepaiementavailableiban');
		this.dispatchEvent(dispatchEventSearch);
	}

	handleStatusCompleted() {
		this._recordupdated = true;
		this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 153, 52, 1);"
		const dispatchEventSearch = new CustomEvent('saisiepaiementcompleted');
		this.dispatchEvent(dispatchEventSearch);
		//this.updatParcours();
	}

	handleStatusNotInitialized() {
		const dispatchEventSearch = new CustomEvent('saisiepaiementnoninitialized');
		this.dispatchEvent(dispatchEventSearch);
		//this.updatParcours();
	}

	/* Start DDPCM 1094 */
	handleStatusServiceDeGestion() {
		this._recordupdated = true;
		const dispatchEventSearch = new CustomEvent('statusservicedegestion');
		this.dispatchEvent(dispatchEventSearch);
	}

	handleStatusServiceDeGestionCompleted() {
		this._recordupdated = true;
		const dispatchEventSearch = new CustomEvent('saisiepaiementcompleted');
		this.dispatchEvent(dispatchEventSearch);
	}
	/* Start DDPCM 1094 */
	

	showNotification() {
		const evt = new ShowToastEvent({
			title: this._title,
			message: this.message,
			variant: this.variant,
		});
		this.dispatchEvent(evt);
	}

	replaceByX() {
		this.coobList.forEach(element => element.IbanNumber.tel1.replace(/(\[a-zA-Z0-9_]{23})(\d{4})/, "XXXXXXXXXXXXXXXXXXXXXXX$2"));
	}

	handleConfirmeIban(event) {
		let selectedIbanID = event.currentTarget.dataset.id;
		console.log('ibanSelected:::', selectedIbanID);
		this._record.VI_Id_coordonnees_bancaires__c = selectedIbanID;
		this._recordupdated = true;
		if (this._record.VI_Id_coordonnees_bancaires__c != null || this._record.VI_Id_coordonnees_bancaires__c !== undefined) {
			this.handleStatusAvaible();
			this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 153, 52, 1);"
		}

		//this.updatParcours();

	}

	updatParcours() {
		const dispatchEventSearch = new CustomEvent('updateparcours');
		this.dispatchEvent(dispatchEventSearch);
	}

		/* Start DDPCM 1269 */
	

	handleChoixCoob(event) {
		
		
		/* End DDPCM 1269 */
		console.log('this.coobList');
		console.log(this.coobList);
		console.log('this.selectedCoobList');
		console.log(this.selectedCoobList);
		var selectedCoob = event.currentTarget.dataset;
		console.log('selectedCoob');
		console.log(selectedCoob);
		this.selectedCoobList.IbanNumber = selectedCoob.ibannumber;
		this.selectedCoobList.IbanNumberX = selectedCoob.ibannumberx;
		this.selectedCoobList.bic = selectedCoob.bic;
		this.selectedCoobList.Nombanque = selectedCoob.nombanque;
		this.selectedCoobList.idCoordonneeBancaire = selectedCoob.coobid;
		this.selectedCoobList.TitulaireCompte = selectedCoob.titulairecompte;
		this.selectedCoobList.idCompteClientCoordB = selectedCoob.idcompteclient;
		this.selectedCoobList.libelle = selectedCoob.libelle;
		if (selectedCoob.issigned === "true") {
			this.selectedCoobList.isSigned = true;
		}
		else {
			this.selectedCoobList.isSigned = false;
		}
		this.coobId = selectedCoob.coobid;
		// Start DDPCM - 276
		if (this._record.VI_Id_coordonnees_bancaires__c != this.coobId) {
			this.isConfirmerPossible = true;
		}
		else {
			this.isConfirmerPossible = false;
		}
		// End DDPCM - 276
		console.log('this.selectedCoobList');
		console.log(this.selectedCoobList);
		console.log('this.coobList');
		console.log(this.coobList);
	}
	handleConfirmerIbanHTML() {
		// Start DDPCM - 276
		console.log("*handleConfirmerIban*");
		if (this._record.VI_Id_coordonnees_bancaires__c != this.coobId) {
			this.isConfirmerPossible = true;
		}
		else {
			this.isConfirmerPossible = false;
		}
		console.log("isConfirmerPossible : " + this.isConfirmerPossible);
		// End DDPCM - 276
		this._record.VI_Id_coordonnees_bancaires__c = this.coobId;
		console.log("VI_Id_coordonnees_bancaires__c : " + this._record.VI_Id_coordonnees_bancaires__c);

		createCoobClientIBANExistant(
			{
				parcours: this._record
			}
		).then(result => {
			let ibanClient;
			this.messageCreationCompte = result.message;
			this._record = result.parcours;
			console.log('this._record');
			console.log(this._record);
			this._recordupdated = true;
			this.handleConfirmerIban();
			this._title = 'Succès';
			this.message = 'Les coordonnées bancaires sont sélectionnées.';
			this.variant = 'success';
			this._recordupdated = true;
			this.showNotification();
		}
		)

	}

	handleConfirmerIban() {
		console.log('*handleConfirmerIban*');
		console.log('ma coob liste ' + this.coobList.length);
		console.log('this.coobId in handleConfirmerIban' + this.coobId);
		this._recordupdated = true;

		this.template.querySelector('[data-id="complete"]').scrollIntoView(false); //

		if (this.coobId !== null && this.coobId !== undefined) {
			this._record.VI_Id_coordonnees_bancaires__c = this.coobId;
		}

		if (this._record.VI_Id_coordonnees_bancaires__c != null || this._record.VI_Id_coordonnees_bancaires__c !== undefined) {
			this.handleStatusCompleted();
			this.boxColor = "border: 2px solid;border-radius: 16px;border-color: rgba(0, 153, 52, 1);"
			// Start DDPCM - 276
			this.isConfirmerPossible = false;
			// End DDPCM - 276
		}
		this._recordupdated = true;
		//this.updatParcours();
	}

	// Start DDPCM - 786

	colorAjustement() {
        if (this.myAjustement > 5) {
            this.isOrange = false;
            this.isBlue = false;
            this.isGreen = true;
            this.colorBorder = 'vi-modal-container-mensualite-astuce greenBorder;';
        }
        else if (this.myAjustement < -5) {
            this.isOrange = true;
            this.isBlue = false;
            this.isGreen = false;
            this.colorBorder = 'vi-modal-container-mensualite-astuce orangeBorder';
        }
        else {
            this.isOrange = false;
            this.isBlue = true;
            this.isGreen = false;
            this.colorBorder = 'vi-modal-container-mensualite-astuce blueBorder;';
        }
    }
	
	buttonPlusAction() {
		this.offreTotalPriceVarRounded = Math.ceil(this.offreTotalPriceVar);
        this.isEuroSup = + Math.floor(this.offreTotalPriceVarRounded) + 1;
        this.viModalButtonMinusMensualite = "vi-modal-button-minus-mensualite borderColorBlueClass fontColorBlueClass";
        this.showButtonMoins = false;
        while (this.myAjustement < 10 && this.offreTotalPriceVarRounded < this.isEuroSup) {
            if (this.myAjustement < 10) {
                this.offreTotalPriceVar = (parseFloat(this.offreTotalPriceVar) + parseFloat(this.pourcentageOffreTotalPrice)).toFixed(2);
                this.offreTotalPriceVarRounded = Math.ceil(this.offreTotalPriceVar);
				this.myAjustement = this.myAjustement + 1;
                if (this.myAjustement === 10) {
                    this.showButtonPlus = true;
                    this.viModalButtonPlusMensualite = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
                }
				console.log('myAjustement : ' + this.myAjustement);
            }
        }
        if (parseFloat(this.offreTotalPriceVarRounded) === parseFloat(this.offreTotalPriceInitValue)) {
            this.myAjustement = 0;
            this.offreTotalPriceVar = parseFloat(this.offreTotalPriceInitValue);
        }
        if (this.myAjustement < 10) {
            this.copieAjustMensNum = parseFloat(this.myAjustement);
            this.copieOffreTotalPriceVar = parseFloat(this.offreTotalPriceVar);
            this.copieOffreTotalPriceVarRounded = parseFloat(this.offreTotalPriceVarRounded);
            this.isEuroSup = parseFloat(this.isEuroSup) + 1;
            while (this.copieAjustMensNum < 10 && this.copieOffreTotalPriceVarRounded < this.isEuroSup) {
                this.copieOffreTotalPriceVar = (parseFloat(this.copieOffreTotalPriceVar) + parseFloat(this.pourcentageOffreTotalPrice)).toFixed(2);
                this.copieOffreTotalPriceVarRounded = Math.ceil(this.copieOffreTotalPriceVar);
                this.copieAjustMensNum = this.copieAjustMensNum + 1;
            }
            if (this.copieAjustMensNum === 10 && this.copieOffreTotalPriceVarRounded === this.offreTotalPriceVarRounded) {
                this.showButtonPlus = true;
                this.viModalButtonPlusMensualite = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
            }
        }
        else {
            this.showButtonPlus = true;
            this.viModalButtonPlusMensualite = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
        }
        this.colorAjustement();
	}

    buttonMoinsAction() {
        this.offreTotalPriceVarRounded = Math.ceil(this.offreTotalPriceVar);
		this.isEuroInf = + Math.floor(this.offreTotalPriceVarRounded) - 1;
		this.showButtonPlus = false;
		this.viModalButtonPlusMensualite = "vi-modal-button-plus-mensualite borderColorBlueClass fontColorBlueClass";
		while (this.myAjustement > -10 && this.offreTotalPriceVarRounded > this.isEuroInf) {
			if (this.myAjustement > -10) {
				this.offreTotalPriceVar = (parseFloat(this.offreTotalPriceVar) - parseFloat(this.pourcentageOffreTotalPrice)).toFixed(2);
				this.offreTotalPriceVarRounded = Math.ceil(this.offreTotalPriceVar);
				this.myAjustement = this.myAjustement - 1;
				if (this.myAjustement === -10) {
					this.showButtonMoins = true;
					this.viModalButtonMinusMensualite = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
				}
				console.log('myAjustement : ' + this.myAjustement);
			}
		}
		if (this.offreTotalPriceVarRounded === this.offreTotalPriceInitValue) {
			this.myAjustement = 0;
			this.offreTotalPriceVar = this.offreTotalPriceInitValue;
		}
		if (this.myAjustement > -10) {
			this.copieAjustMensNum = this.myAjustement;
			this.copieOffreTotalPriceVar = this.offreTotalPriceVar;
			this.copieOffreTotalPriceVarRounded = this.offreTotalPriceVarRounded;
			this.isEuroInf = this.isEuroInf - 1;
			while (this.copieAjustMensNum > -10 && this.copieOffreTotalPriceVarRounded > this.isEuroInf) {
				this.copieOffreTotalPriceVar = (parseFloat(this.copieOffreTotalPriceVar) - parseFloat(this.pourcentageOffreTotalPrice)).toFixed(2);
				this.copieOffreTotalPriceVarRounded = Math.ceil(this.copieOffreTotalPriceVar);
				this.copieAjustMensNum = this.copieAjustMensNum - 1;
			}
			if (this.copieAjustMensNum === -10 && this.copieOffreTotalPriceVarRounded === this.offreTotalPriceVarRounded) {
				this.showButtonMoins = true;
				this.viModalButtonMinusMensualite = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
			}
		}
		else {
			this.showButtonMoins = true;
			this.viModalButtonMinusMensualite = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
		}
		this.colorAjustement();
    }

	validerMensualite() {

		//this.offreTotalPriceVar = this.offreTotalPriceVarRounded;

		if (this.myAjustement === 0) {
			this.isAjustementMensuNot0 = false;
			this.offreTotalPriceVar = this.offreTotalPriceInitValue;
		} else {
			this.isAjustementMensuNot0 = true;
		}
		console.log("offreTotalPriceVarRounded : " + this.offreTotalPriceVarRounded);
		console.log("offreTotalPriceVar : " + this.offreTotalPriceVar);
		this._record.VI_MontantOffrePanierClient__c = this.offreTotalPriceInitValue.toString().replace(".", ",");
		this._record.VI_AjustementMensualitesPanierClient__c = this.myAjustement.toString();
		this._record.VI_MontantdelaMensualitePanierClient__c = this.offreTotalPriceVarRounded.toString().replace(".", ",");
		console.log('offreTotalPriceInitValue : ' + this.offreTotalPriceInitValue);
		console.log('VI_MontantOffrePanierClient__c : ' + this._record.VI_MontantOffrePanierClient__c);
		console.log('VI_MontantdelaMensualitePanierClient__c : ' + this._record.VI_MontantdelaMensualitePanierClient__c);
		this.closeModalAjustementMensualite();
	}
	
	// End DDPCM - 786

	// Start DDPCM - 1109 New Canaux
	showInformationMensualisation() {
		this.informationMensualisation = !this.informationMensualisation;
	}

	showinformationEspaceClient() {
		this.informationEspaceClient = !this.informationEspaceClient;
	}

	showinformationEFacture() {
		this.informationEFacture = !this.informationEFacture;
	}

	showinformationEDoc () {
		this.informationEDoc = !this.informationEDoc;
	}
	// End DDPCM - 1109 New Canaux

	/* Start DDPCM - 1110 */
	handleMensualisationServicedeGestion() {
		const dispatchEventSearch = new CustomEvent('mensualisationservicedegestion');
		this.dispatchEvent(dispatchEventSearch);
		this._recordupdated = true;		
	}
	/* Start DDPCM - 1110 */

	// Start DDPCM 854 New Canaux
	// Open / close Modal
	OpenModalWarningMensualite() {
		this.isModalOpenBackgroundWarningMensualite = true;
		this.isModalOpenWarningMensualite = true;
	}

	closeModalWarningMensualite() {
		this.isModalOpenWarningMensualite = false;
		this.isModalOpenBackgroundWarningMensualite = false;
	}
	// End DDPCM 854 New Canaux

	// End DDPCM 786 New Canaux

	openModalAjustementMensualite() {
		this.isModalOpenAjustementMensualite = true;
		this.isBackgroundModalOpenAjustementMensualite = true;
		this.colorAjustement();
	}

	closeModalAjustementMensualite() {
		this.isModalOpenAjustementMensualite = false;
		this.isBackgroundModalOpenAjustementMensualite = false;
		
		this.myAjustement = parseFloat(this._record.VI_AjustementMensualitesPanierClient__c);

		const dispatchEventSearch = new CustomEvent('closepopupajustementmensualite');
		this.dispatchEvent(dispatchEventSearch);
		this._recordupdated = true;
	}
	// End DDPCM 786 New Canaux

}