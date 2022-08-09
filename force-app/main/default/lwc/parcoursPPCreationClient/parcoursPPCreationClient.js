import { LightningElement, wire, api, track } from 'lwc';
import createContact from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.createContactFromLWC';
import getListVille from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getVilles';
import getMapVille from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getMapVilles';
import getAdresseList from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getAdresseList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ParcoursPPCreationClient extends LightningElement {
	emailAccepte = true;
	email1choisi;
	email2choisi;
	disabledEmail1Choisi = true;
	disabledEmail2Choisi = true;
	fixe1choisi;
	fixe2choisi;
	disabledFixe1Choisi = true;
	disabledFixe2Choisi = true;
	mobile1choisi;
	mobile2choisi;
	disabledMobile1Choisi = true;
	disabledMobile2Choisi = true;
	telephoneAccepte = true;
	monsieurChoisi = false;
	madameChoisi = false;
	coTitulaireChoisi = false;
	telephoneFixeAccepte = true;
	questionslist;
	error;
	listVilles = [];
	listAddresses = [];
	adresse;
	_title = 'Sample Title';
	message = 'Sample Message';
	variant = 'error';
	loaded = true;
	consentementEngie;
	consentementPartner;

	mapVilles = new Map();
	mesVilles=[];

	@api recorddonnee;
	@api
	get parcours() {
		return this._parcours;
	}
	set parcours(value) {
		if (value) {
			this._parcours = { ...value };
			//section Identité
			this.handleUndefinedValues('VI_CiviliteClient__c');
			if (this._parcours.VI_CiviliteClient__c === 'Monsieur') {
				this.monsieurChoisi = true;
			}
			if (this._parcours.VI_CiviliteClient__c === 'Madame') {
				this.madameChoisi = true;
			}
			if (this._parcours.VI_CiviliteClient__c === 'Co-Titulaire') {
				this.coTitulaireChoisi = true;
			}
			this.handleUndefinedValues('VI_NomClient__c');
			this.handleUndefinedValues('VI_PrenomClient__c');
			//section Emails
			this.handleUndefinedValues('VI_RefusEmailCreationClient__c');
			this.handleUndefinedValues('VI_Email1Client__c');
			this.handleUndefinedValues('VI_Email2Client__c');
			this.handleUndefinedValues('VI_EmailPrincipalCreationClient__c');
			this.emailAccepte = !this._parcours.VI_RefusEmailCreationClient__c;
			console.log("this._parcours.VI_EmailPrincipalCreationClient__c " + this._parcours.VI_EmailPrincipalCreationClient__c);
			if (this._parcours.VI_EmailPrincipalCreationClient__c === 'Email 2') {

				this.email2choisi = true;
				this.email1choisi = false;
			}
			else {
				this.email1choisi = true;
				this.email2choisi = false;
			}
			if (this._parcours.VI_Email1Client__c && this._parcours.VI_Email1Client__c != "") {
				this.disabledEmail1Choisi = false;
			}
			if (this._parcours.VI_Email2Client__c && this._parcours.VI_Email2Client__c != "") {
				this.disabledEmail2Choisi = false;
			}
			//section Télephones
			//fixe
			this.handleUndefinedValues('VI_RefusTelephoneCreationClient__c');
			this.handleUndefinedValues('VI_TelephoneFixe1Client__c');
			this.handleUndefinedValues('VI_TelephoneFixe2Client__c');
			this.handleUndefinedValues('VI_TelephonePrincipalCreationClient__c');
			this.handleUndefinedValues('VI_IDReferenceClient__c');
			this.telephoneFixeAccepte = !this._parcours.VI_RefusTelephoneCreationClient__c;
			if (this._parcours.VI_TelephonePrincipalCreationClient__c === 'Téléphone 2') {
				this.fixe2choisi = true;
				this.fixe1choisi = false;
			}
			else {
				this.fixe2choisi = false;
				this.fixe1choisi = true;
			}
			if (this._parcours.VI_TelephoneFixe1Client__c && this._parcours.VI_TelephoneFixe1Client__c != "") {
				this.disabledFixe1Choisi = false;
			}
			if (this._parcours.VI_TelephoneFixe2Client__c && this._parcours.VI_TelephoneFixe2Client__c != "") {
				this.disabledFixe2Choisi = false;
			}
			//portable
			this.handleUndefinedValues('VI_RefusMobile__c');
			this.handleUndefinedValues('VI_Mobile1Client__c');
			this.handleUndefinedValues('VI_Mobile2Client__c');
			this.handleUndefinedValues('VI_MobilePrincipalCreationClient__c');
			this.telephoneAccepte = !this._parcours.VI_RefusMobile__c;
			if (this._parcours.VI_MobilePrincipalCreationClient__c === 'Mobile 2') {
				this.mobile2choisi = true;
				this.mobile1choisi = false;
			}
			else {
				this.mobile2choisi = false;
				this.mobile1choisi = true;
			}
			if (this._parcours.VI_Mobile1Client__c && this._parcours.VI_Mobile1Client__c != "") {
				this.disabledMobile1Choisi = false;
			}
			if (this._parcours.VI_Mobile2Client__c && this._parcours.VI_Mobile2Client__c != "") {
				this.disabledMobile2Choisi = false;
			}
			//Adresse
			this.handleUndefinedValues('VI_Numero_de_la_rue__c');
			this.handleUndefinedValues('VI_RueCreationClient__c');
			this.handleUndefinedValues('VI_CodePostalClient__c');
			this.handleUndefinedValues('VI_CommuneClient__c');

		}
		else {
			this._parcours = {};
		}
	}

	@api
	get recordupdated() {
		return this._recordupdated;
	}

	set recordupdated(value) {
		this._recordupdated = value;
	}

	@track informationVisible = true;
	hideInformation() {
		this.informationVisible = false;
	}
	showInformation() {
		this.informationVisible = true;
	}

	//sets the fields to null if they are empty
	handleUndefinedValues(recordField) {
		if (typeof this._parcours[recordField] === "undefined") {
			this._parcours[recordField] = null;
		}
	}

	//Called to search for contacts in the database
	handleCreateClientChange(event) {
		let field = event.target.name;
		this._recordupdated = true;
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
		//section Identité
		if (field === 'Civilité') {
			this._parcours.VI_CiviliteClient__c = event.target.value;
			if (this._parcours.VI_CiviliteClient__c === 'Monsieur') {
				this.monsieurChoisi = true;
				this.madameChoisi = false;
				this.coTitulaireChoisi = false;
			}
			if (this._parcours.VI_CiviliteClient__c === 'Madame') {
				this.madameChoisi = true;
				this.monsieurChoisi = false;
				this.coTitulaireChoisi = false;
			}
			if (this._parcours.VI_CiviliteClient__c === 'Co-Titulaire') {
				this.coTitulaireChoisi = true;
				this.monsieurChoisi = false;
				this.madameChoisi = false;
			}
		}
		else if (field === 'Nom') {
			this._parcours.VI_NomClient__c = event.target.value;
		}
		else if (field === 'Prénom') {
			this._parcours.VI_PrenomClient__c = event.target.value;
		}
		//section Emails
		else if (field === 'RefusEmail') {
			this._parcours.VI_RefusEmailCreationClient__c = event.target.checked;
			this.emailAccepte = !event.target.checked;
		}
		else if (field === 'Email1') {
			this._parcours.VI_Email1Client__c = event.target.value;
			if (this._parcours.VI_Email1Client__c && this._parcours.VI_Email1Client__c != "") {
				this.template.querySelector('[data-id="Email1Radio"]').disabled = false;
			}
			else {
				this.template.querySelector('[data-id="Email1Radio"]').disabled = true;
			}
		}
		else if (field === 'Email2') {
			this._parcours.VI_Email2Client__c = event.target.value;
			if (this._parcours.VI_Email2Client__c && this._parcours.VI_Email2Client__c != "") {
				this.template.querySelector('[data-id="Email2Radio"]').disabled = false;
			}
			else {
				this.template.querySelector('[data-id="Email2Radio"]').disabled = true;
			}
		}
		else if (field === 'Email') {
			this._parcours.VI_EmailPrincipalCreationClient__c = event.target.value;
			if (this._parcours.VI_EmailPrincipalCreationClient__c === 'Email 2') {
				this.email2choisi = true;
				this.email1choisi = false;
			}
			else {
				this.email1choisi = true;
				this.email2choisi = false;
			}
		}
		//section Télephones
		//fixe
		else if (field === 'RefusTelephonesFixe') {
			this._parcours.VI_RefusTelephoneCreationClient__c = event.target.checked;
			this.telephoneFixeAccepte = !event.target.checked;
		}
		else if (field === 'Telephone1') {
			if (event.target.value !== null) {
				this._parcours.VI_TelephoneFixe1Client__c = event.target.value.slice(0, 10);
				this.template.querySelector('[data-id="Telephone1"]').value = this._parcours.VI_TelephoneFixe1Client__c;
				if (this._parcours.VI_TelephoneFixe1Client__c && this._parcours.VI_TelephoneFixe1Client__c != "") {
					this.template.querySelector('[data-id="TéléphoneFixe1Radio"]').disabled = false;
				}
				else {
					this.template.querySelector('[data-id="TéléphoneFixe1Radio"]').disabled = true;
				}
			}
		}
		else if (field === 'Telephone2') {
			if (event.target.value !== null) {
				this._parcours.VI_TelephoneFixe2Client__c = event.target.value.slice(0, 10);
				this.template.querySelector('[data-id="Telephone2"]').value = this._parcours.VI_TelephoneFixe2Client__c;
				if (this._parcours.VI_TelephoneFixe2Client__c && this._parcours.VI_TelephoneFixe2Client__c != "") {
					this.template.querySelector('[data-id="TéléphoneFixe2Radio"]').disabled = false;
				}
				else {
					this.template.querySelector('[data-id="TéléphoneFixe2Radio"]').disabled = true;
				}
			}
		}
		else if (field === 'TéléphoneFixe') {
			this._parcours.VI_TelephonePrincipalCreationClient__c = event.target.value;
			if (this._parcours.VI_TelephonePrincipalCreationClient__c === 'Téléphone 2') {
				this.fixe2choisi = true;
				this.fixe1choisi = false;
			}
			else {
				this.fixe2choisi = false;
				this.fixe1choisi = true;
			}
		}
		//portable
		else if (field === 'RefusTelephones') {
			this._parcours.VI_RefusMobile__c = event.target.checked;
			this.telephoneAccepte = !event.target.checked;
		}
		else if (field === 'Mobile1') {
			this._parcours.VI_Mobile1Client__c = event.target.value;
			if (event.target.value !== null) {
				this._parcours.VI_Mobile1Client__c = event.target.value.slice(0, 10);
				this.template.querySelector('[data-id="Mobile1"]').value = this._parcours.VI_Mobile1Client__c;
			}
			if (this._parcours.VI_Mobile1Client__c && this._parcours.VI_Mobile1Client__c != "") {
				this.template.querySelector('[data-id="Téléphone1Radio"]').disabled = false;
			}
			else {
				this.template.querySelector('[data-id="Téléphone1Radio"]').disabled = true;
			}
		}
		else if (field === 'Mobile2') {
			if (event.target.value !== null) {
				this._parcours.VI_Mobile2Client__c = event.target.value.slice(0, 10);
				this.template.querySelector('[data-id="Mobile2"]').value = this._parcours.VI_Mobile2Client__c;
			}
			if (this._parcours.VI_Mobile2Client__c && this._parcours.VI_Mobile2Client__c != "") {
				this.template.querySelector('[data-id="Téléphone2Radio"]').disabled = false;
			}
			else {
				this.template.querySelector('[data-id="Téléphone2Radio"]').disabled = true;
			}
		}
		else if (field === 'MobilePrincipale') {
			this._parcours.VI_MobilePrincipalCreationClient__c = event.target.value;
			if (this._parcours.VI_MobilePrincipalCreationClient__c === 'Mobile 2') {
				this.mobile2choisi = true;
				this.mobile1choisi = false;
			}
			else {
				this.mobile2choisi = false;
				this.mobile1choisi = true;
			}
		}
		//Adresse
		else if (field === 'Num') {
			this._parcours.VI_Numero_de_la_rue__c = event.target.value;
			this.template.querySelector('[data-id="adresse"]').value = null;
		}
		else if (field === 'Rue') {
			this._parcours.VI_RueCreationClient__c = event.target.value;
			this.template.querySelector('[data-id="adresse"]').value = null;
		}
		else if (field === 'CodePostal') {
			console.log('codepostal');
			if (event.target.value === null || event.target.value === "") {
				this._parcours.VI_CommuneClient__c = null;
				this._parcours.VI_CodePostalClient__c = event.target.value;
			}
			this.listVilles = [];
			console.log('event.target.value '+event.target.value);
			if (event.target.value !== null) {
				console.log('event.target.value.slice(0, 5) '+event.target.value.slice(0, 5));
				this._parcours.VI_CodePostalClient__c = event.target.value.slice(0, 5);
				console.log('before adress '+this.template.querySelector('[data-id="adresse"]'));
				this.template.querySelector('[data-id="adresse"]').value = null;
				console.log('after adress '+this.template.querySelector('[data-id="adresse"]'));
				
				console.log('this._parcours.VI_CodePostalClient__c '+this._parcours.VI_CodePostalClient__c);
				console.log('this._parcours.VI_CodePostalClient__c.length '+this._parcours.VI_CodePostalClient__c.length);

				if (this._parcours.VI_CodePostalClient__c.length >= 3) {
					this.checkListVille();
					this.updateVilles();
				}
			}
		}
		else if (field === 'Commune') {
			if (event.target.value === null || event.target.value === "") {
				this._parcours.VI_CodePostalClient__c = null;
				this.template.querySelector('[data-id="codePostal"]').value = null;
			}
			this._parcours.VI_CommuneClient__c = event.target.value;
			this.template.querySelector('[data-id="adresse"]').value = null;
		}
		else if (field === 'Adresse') {
			this.adresse = event.target.value;
			this.template.querySelector('[data-id="listAdressesSuggested"]').classList.remove('slds-hide');
			this.getSuggestionsadresses();
		}
	}

	removeNumberScroll(event) {
		event.target.blur();
	}

	creerClient() {
		if (this._parcours.VI_StatutParcours__c !== 'CPV Envoyées: PDL/PCE connu' &&
			this._parcours.VI_StatutParcours__c !== 'CPV Envoyées: PDL/PCE non connu') {

			var checkValidationRules = false;
			this.handleAllUndefinedValues();
			this.resetErrorMessage();
			checkValidationRules = this.regleValidationFunction();
			if (checkValidationRules === false) {
				this.loaded = false;
				console.log("passed validation rules");
				// Start DDPCM - 279 
				if (this._parcours.VI_AdresseDeConsoIdentique__c) {
					this._parcours.VI_NumeroRueRechercheLocal__c = "";
					this._parcours.VI_RueRechercheLocal__c = "";
					this._parcours.VI_CodePostalRechercheLocal__c = "";
					this._parcours.VI_CommuneRechercheLocal__c = "";
					this._parcours.VI_RechercheLocal_AdresseComplete__c = "";
					this._parcours.VI_CodeCommuneIdentificationLocal__c = "";
					this._parcours.VI_PDLRechercheLocal__c = "";
					this._parcours.VI_PCERechercheLocal__c = "";
					this._parcours.VI_AdresseDeConsoIdentique__c = false;
					this._parcours.VI_LocalNonIdentifieGenerationCase__c = false;
					this.dispatchEvent(
						new CustomEvent('reinitializeaddresslocal', { bubbles: true, composed: true }));
				}
				// END DDPCM - 279 
				createContact(
					{
						parcours: this.parcours,
						firstName: this._parcours.VI_PrenomClient__c,
						lastName: this._parcours.VI_NomClient__c,
						civilite: this._parcours.VI_CiviliteClient__c,
						refusEmail: !this.emailAccepte,
						email1: this._parcours.VI_Email1Client__c,
						email2: this._parcours.VI_Email2Client__c,
						emailPrefere: this._parcours.VI_EmailPrincipalCreationClient__c,
						refusFixe: !this.telephoneFixeAccepte,
						fixe1: this._parcours.VI_TelephoneFixe1Client__c,
						fixe2: this._parcours.VI_TelephoneFixe2Client__c,
						fixePrefere: this._parcours.VI_TelephonePrincipalCreationClient__c,
						refusMobile: this._parcours.VI_RefusMobile__c,
						mobile1: this._parcours.VI_Mobile1Client__c,
						mobile2: this._parcours.VI_Mobile2Client__c,
						mobilePrefere: this._parcours.VI_MobilePrincipalCreationClient__c,
						numeroRue: this._parcours.VI_Numero_de_la_rue__c,
						rue: this._parcours.VI_RueCreationClient__c,
						commune: this._parcours.VI_CommuneClient__c,
						codePostal: this._parcours.VI_CodePostalClient__c,
						consentementEngie: this._parcours.VI_ConsentProspectionEngieNonAnalogue__c,
						consentementPartenaire: this._parcours.VI_ConsentProspectionPartenaire__c
					}
				).then(result => {
					console.log("result.message " + result.message);
					if (result.message === "Success" || result.message === "champs vide") {
						this.loaded = true;
						console.log("in if");
						this._parcours = result.parcours;
						console.log("contact id " + this._parcours.VI_Contact__c);
						this._recordupdated = true;
						this.dispatchEvent(
							new CustomEvent('createclient', { bubbles: true, composed: true }));
					}
					else {
						this._parcours = result.parcours;
						this._recordupdated = true;
						this.loaded = true;
						this._title = 'Erreur';
						this.message = result.message;
						console.log('this.message' + this.message);
						this.variant = 'error';
						this.showNotification();
					}
				})
					.catch(error => {
						console.log("test1");
						this.loaded = true;
						console.log('error' + error);
						console.log('error' + error.body.message);
						this._recordupdated = true;
						this._title = 'Erreur';
						this.message = error.body.message;
						this.variant = 'error';
						this.showNotification();
					});
			}
			else {
				console.log("didn't pass validation rules");
			}
		}
		else{
			console.log("CPV déjà envoyés");
		}
	}

	showNotification() {
		console.log('this.message' + this.message);
		console.log('this._title' + this._title);
		console.log('this.variant' + this.variant);
		const evt = new ShowToastEvent({
			title: this._title,
			message: this.message,
			variant: this.variant
		});
		this.dispatchEvent(evt);
	}


	checkListVille() {
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.remove('slds-hide');
	}

	updateVilles() {
		/*getListVille(
			{
				codePostal: this._parcours.VI_CodePostalClient__c
			}
		).then(result => {
			this.listVilles = result;

		})
			.catch(error => {
				this.error = error;
			});*/
		getMapVille(
			{
				codePostal: this._parcours.VI_CodePostalClient__c
			}
		).then(result => {
			console.log('resultMap' + result);
			console.log(result);
			this.mesVilles = [];

			for (var key in result) {
				console.log("key " + key);
				this.mesVilles.push(key);
				this.mapVilles.set(key, result[key]);
			}
			if (this.mesVilles.length === 1) {
				console.log('rresult[0]' + this.mesVilles[0]);
				this._parcours.VI_CommuneClient__c = this.mesVilles[0];

				this._parcours.VI_CodePostalClient__c = this.mapVilles.get(this.mesVilles[0]);
				this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
			}
			console.log("this.mesVilles");
			console.log(this.mesVilles);
			console.log("this.mapVilles");
			console.log(this.mapVilles);
			//this.mesVilles=Array.from(result.keys());
			//this.mapVilles=result;

			//console.log(this.mesVilles);
		})
	}

	selectVilleValue(event) {
		console.log('event.currentTarget.dataset.value;' + event.currentTarget.dataset.value);
		console.log('get '+this.mapVilles.get(event.currentTarget.dataset.value));
		this._parcours.VI_CommuneClient__c = event.currentTarget.dataset.value;
		console.log('get '+this.mapVilles.get(this._parcours.VI_CommuneClient__c));
		this._parcours.VI_CodePostalClient__c=this.mapVilles.get(this._parcours.VI_CommuneClient__c);
		this.template.querySelector('[data-id="ville"]').value = event.currentTarget.dataset.value;
		this.template.querySelector('[data-id="codePostal"]').value = this.mapVilles.get(this._parcours.VI_CommuneClient__c);
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
	}

	checkListAdresse() {
		this.template.querySelector('[data-id="listAdressesSuggested"]').classList.remove('slds-hide');

	}

	getSuggestionsadresses() {
			console.log('in getSuggestionsadresses');
		if (this.adresse.length > 4) {
			getAdresseList(
				{
					adresse: this.adresse
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
		let selectedadresse = event.currentTarget.dataset;
		this.template.querySelector('[data-id="adresse"]').value = selectedadresse.label;
		this.template.querySelector('[data-id="ville"]').value = selectedadresse.ville;
		this._parcours.VI_CommuneClient__c = selectedadresse.ville;
		this.template.querySelector('[data-id="codePostal"]').value = selectedadresse.codepostal;
		this._parcours.VI_CodePostalClient__c = selectedadresse.codepostal;
		this.template.querySelector('[data-id="rue"]').value = selectedadresse.voie;
		this._parcours.VI_RueCreationClient__c = selectedadresse.voie;
		this.template.querySelector('[data-id="num"]').value = selectedadresse.numero;
		this._parcours.VI_Numero_de_la_rue__c = selectedadresse.numero;

	}

	regleValidationFunction() {
		var BolToReturn = false;
		console.log("#####3")

		if (this._parcours.VI_Email1Client__c === null) {
			var Email1Client__c = "";
		} else {
			console.log("this._parcours.VI_Email1Client__c " + this._parcours.VI_Email1Client__c)
			var Email1Client__c = this._parcours.VI_Email1Client__c;
			console.log("Email1Client__c " + Email1Client__c)
		}

		if (this._parcours.VI_Email2Client__c === null) {
			var Email2Client__c = "";
		} else {
			var Email2Client__c = this._parcours.VI_Email2Client__c;
		}

		if (this._parcours.VI_PrenomClient__c === null) {
			var PrenomClient__c = "";
		} else {
			var PrenomClient__c = this._parcours.VI_PrenomClient__c;
		}

		if (this._parcours.VI_NomClient__c === null) {
			var NomClient__c = "";
		} else {
			var NomClient__c = this._parcours.VI_NomClient__c;
		}

		if (this._parcours.VI_TelephoneFixe1Client__c === null) {
			var TelephoneFixe1Client__c = "";
		} else {
			var TelephoneFixe1Client__c = this._parcours.VI_TelephoneFixe1Client__c;
		}

		if (this._parcours.VI_TelephoneFixe2Client__c === null) {
			var TelephoneFixe2Client__c = "";
		} else {
			var TelephoneFixe2Client__c = this._parcours.VI_TelephoneFixe2Client__c;
		}

		if (this._parcours.VI_Mobile1Client__c === null) {
			var Mobile1Client__c = "";
		} else {
			var Mobile1Client__c = this._parcours.VI_Mobile1Client__c;
		}

		if (this._parcours.VI_Mobile2Client__c === null) {
			var Mobile2Client__c = "";
		} else {
			var Mobile2Client__c = this._parcours.VI_Mobile2Client__c;
		}

		if (this._parcours.VI_Numero_de_la_rue__c === null) {
			var Numero_de_la_rue__c = "";
		} else {
			var Numero_de_la_rue__c = this._parcours.VI_Numero_de_la_rue__c;
		}

		if (this._parcours.VI_RueCreationClient__c === null) {
			var RueCreationClient__c = "";
		} else {
			var RueCreationClient__c = this._parcours.VI_RueCreationClient__c;
		}

		if (this._parcours.VI_CodePostalClient__c === null || this._parcours.VI_CodePostalClient__c === "") {
			var CodePostalClient__c = "";
		} else {
			var CodePostalClient__c = this._parcours.VI_CodePostalClient__c;
		}

		if (this._parcours.VI_CommuneClient__c === null) {
			var CommuneClient__c = "";
		} else {
			var CommuneClient__c = this._parcours.VI_CommuneClient__c;
		}

		console.log("#####1")
		console.log("this.emailAccepte " + this.emailAccepte);
		console.log("Email1Client__c " + Email1Client__c);
		console.log("Email2Client__c " + Email2Client__c);
		if (!this.emailAccepte === true
			|| (!this.emailAccepte === false
				& Email1Client__c.replace(/\s/g, '').length === 0
				& Email2Client__c.replace(/\s/g, '').length === 0)
		) {
			console.log("$$$$ in if");
			BolToReturn = true;
			console.log("$$$$ in if1");
			this.template.querySelector('.refusEmailErrorMessageId').innerHTML = "Il faut renseigner au moins un email pour créer la fiche du client";
			console.log("$$$$ in if2");
		}
		console.log("#####21")
		if (!this.emailAccepte === false) {
			if (Email1Client__c.replace(/\s/g, '').length === 0) {
			} else {
				if (Email1Client__c.includes("@") & Email1Client__c.includes(".")) {

				} else {
					BolToReturn = true;
					this.template.querySelector('.wrongEmailErrorMessage').innerHTML = "l'email n'est pas renseigné au bon format";
				}
			}
			console.log("#####2")
			if (Email2Client__c.replace(/\s/g, '').length === 0) {
			} else {
				if (Email2Client__c.includes("@") & Email2Client__c.includes(".")) {

				} else {
					BolToReturn = true;
					this.template.querySelector('.wrongEmailErrorMessage').innerHTML = "l'email n'est pas renseigné au bon format";
				}
			}
		}
		console.log("#####10")
		if (PrenomClient__c.replace(/\s/g, '').length === 0 || PrenomClient__c === null
			|| NomClient__c.replace(/\s/g, '').length === 0 || NomClient__c === null
			|| this._parcours.VI_CiviliteClient__c === null) {
			BolToReturn = true;
			this.template.querySelector('.NomCivErrorMessage').innerHTML = "Il faut renseigner tous les champs de la section Identité (Nom, Prénom et Civilité)";
		}

		if ((!this.telephoneFixeAccepte === true & this._parcours.VI_RefusMobile__c === true)
			|| (TelephoneFixe1Client__c.replace(/\s/g, '').length === 0
				& TelephoneFixe2Client__c.replace(/\s/g, '').length === 0
				& Mobile1Client__c.replace(/\s/g, '').length === 0
				& Mobile2Client__c.replace(/\s/g, '').length === 0)
		) {
			BolToReturn = true;
			this.template.querySelector('.phoneErrorMessage').innerHTML = "Il faut renseigner au moins un numéro de téléphone pour créer la fiche du client";
		}
		if (this._parcours.VI_RefusMobile__c === false && this._parcours.VI_Mobile1Client__c !== null && this._parcours.VI_Mobile1Client__c !== '') {
			if (!((this._parcours.VI_Mobile1Client__c.startsWith('06') || this._parcours.VI_Mobile1Client__c.startsWith('07'))
				& this._parcours.VI_Mobile1Client__c.length === 10
				& !(isNaN(this._parcours.VI_Mobile1Client__c)))
			) {
				console.log("%%%4");
				BolToReturn = true;
				this.template.querySelector('.mobileErrorMessage').innerHTML = "Veuillez saisir un numéro commençant par 06 ou 07 suivi de 8 chiffres";
			}
		}

		if (this._parcours.VI_RefusMobile__c === false && this._parcours.VI_Mobile2Client__c !== null && this._parcours.VI_Mobile2Client__c !== '') {
			if (!((this._parcours.VI_Mobile2Client__c.startsWith('06') || this._parcours.VI_Mobile2Client__c.startsWith('07'))
				& this._parcours.VI_Mobile2Client__c.length === 10
				& !(isNaN(this._parcours.VI_Mobile2Client__c)))
			) {
				console.log("%%%5");
				BolToReturn = true;
				this.template.querySelector('.mobileErrorMessage').innerHTML = "Veuillez saisir un numéro commençant par 06 ou 07 suivi de 8 chiffres";
			}
		}

		if (this.telephoneFixeAccepte === true && this._parcours.VI_TelephoneFixe2Client__c !== null && this._parcours.VI_TelephoneFixe2Client__c !== '') {
			if (!((this._parcours.VI_TelephoneFixe2Client__c.startsWith('0'))
				& this._parcours.VI_TelephoneFixe2Client__c.length === 10
				& !(isNaN(this._parcours.VI_TelephoneFixe2Client__c)))
			) {
				console.log("%%%6");
				BolToReturn = true;
				this.template.querySelector('.fixeErrorMessage').innerHTML = "Veuillez saisir un numéro commençant par 01 à 05 ou 09 suivi de 8 chiffres";
			}
		}

		if (this.telephoneFixeAccepte === true && this._parcours.VI_TelephoneFixe1Client__c !== null && this._parcours.VI_TelephoneFixe1Client__c !== '') {
			if (!((this._parcours.VI_TelephoneFixe1Client__c.startsWith('0'))
				& this._parcours.VI_TelephoneFixe1Client__c.length === 10
				& !(isNaN(this._parcours.VI_TelephoneFixe1Client__c)))
			) {
				console.log("%%%7");
				BolToReturn = true;
				this.template.querySelector('.fixeErrorMessage').innerHTML = "Veuillez saisir un numéro commençant par 01 à 05 ou 09 suivi de 8 chiffres";
			}
		}

		if (Numero_de_la_rue__c.replace(/\s/g, '').length === 0
			|| RueCreationClient__c.replace(/\s/g, '').length === 0
			|| CodePostalClient__c.replace(/\s/g, '').length === 0
			|| CommuneClient__c.replace(/\s/g, '').length === 0
		) {
			console.log("%%%8");
			BolToReturn = true;
			this.template.querySelector('.AdresseErrorMessage').innerHTML = "Il faut renseigner une adresse de facturation complète (Numéro de rue, Rue, Code postal et Commune)";
		}
		console.log("#####4")
		return BolToReturn;
	}

	resetErrorMessage() {
		this.template.querySelector('.wrongEmailErrorMessage').innerHTML = "";
		this.template.querySelector('.refusEmailErrorMessageId').innerHTML = "";
		this.template.querySelector('.NomCivErrorMessage').innerHTML = "";
		this.template.querySelector('.AdresseErrorMessage').innerHTML = "";
		this.template.querySelector('.fixeErrorMessage').innerHTML = "";
		this.template.querySelector('.phoneErrorMessage').innerHTML = "";
		this.template.querySelector('.mobileErrorMessage').innerHTML = "";
	}

	onFormSubmit(event) {
		console.log('####submit');
		event.preventDefault();
		event.stopPropagation();
	}

	handleAllUndefinedValues() {
		//section Identité
		this.handleUndefinedValues('VI_CiviliteClient__c');
		if (this._parcours.VI_CiviliteClient__c === 'Monsieur') {
			this.monsieurChoisi = true;
		}
		if (this._parcours.VI_CiviliteClient__c === 'Madame') {
			this.madameChoisi = true;
		}
		if (this._parcours.VI_CiviliteClient__c === 'Co-titulaire') {
			this.coTitulaireChoisi = true;
		}
		this.handleUndefinedValues('VI_NomClient__c');
		this.handleUndefinedValues('VI_PrenomClient__c');
		//section Emails
		this.handleUndefinedValues('VI_RefusEmailCreationClient__c');
		this.handleUndefinedValues('VI_Email1Client__c');
		this.handleUndefinedValues('VI_Email2Client__c');
		this.handleUndefinedValues('VI_EmailPrincipalCreationClient__c');
		this.emailAccepte = !this._parcours.VI_RefusEmailCreationClient__c;
		console.log("this._parcours.VI_EmailPrincipalCreationClient__c " + this._parcours.VI_EmailPrincipalCreationClient__c);
		if (this._parcours.VI_EmailPrincipalCreationClient__c === 'Email 2') {

			this.email2choisi = true;
			this.email1choisi = false;
		}
		else {
			this.email1choisi = true;
			this.email2choisi = false;
		}
		//section Télephones
		//fixe
		this.handleUndefinedValues('VI_RefusTelephoneCreationClient__c');
		this.handleUndefinedValues('VI_TelephoneFixe1Client__c');
		this.handleUndefinedValues('VI_TelephoneFixe2Client__c');
		this.handleUndefinedValues('VI_TelephonePrincipalCreationClient__c');
		this.handleUndefinedValues('VI_IDReferenceClient__c');
		this.telephoneFixeAccepte = !this._parcours.VI_RefusTelephoneCreationClient__c;
		if (this._parcours.VI_TelephonePrincipalCreationClient__c === 'Téléphone 2') {
			this.fixe2choisi = true;
			this.fixe1choisi = false;
		}
		else {
			this.fixe2choisi = false;
			this.fixe1choisi = true;
		}
		//portable
		this.handleUndefinedValues('VI_RefusMobile__c');
		this.handleUndefinedValues('VI_Mobile1Client__c');
		this.handleUndefinedValues('VI_Mobile2Client__c');
		this.handleUndefinedValues('VI_MobilePrincipalCreationClient__c');
		this.telephoneAccepte = !this._parcours.VI_RefusMobile__c;
		if (this._parcours.VI_MobilePrincipalCreationClient__c === 'Mobile 2') {
			this.mobile2choisi = true;
			this.mobile1choisi = false;
		}
		else {
			this.mobile2choisi = false;
			this.mobile1choisi = true;
		}
		//Adresse
		this.handleUndefinedValues('VI_Numero_de_la_rue__c');
		this.handleUndefinedValues('VI_RueCreationClient__c');
		this.handleUndefinedValues('VI_CodePostalClient__c');
		this.handleUndefinedValues('VI_CommuneClient__c');
		//GDPR
		console.log('Engie' + this._parcours.VI_ConsentProspectionEngieNonAnalogue__c);
		console.log('Partners' + this._parcours.VI_ConsentProspectionPartenaire__c);
		this.handleUndefinedValues('VI_ConsentProspectionEngieNonAnalogue__c');
			this.handleUndefinedValues('VI_ConsentProspectionPartenaire__c');
	}

}