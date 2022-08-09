import { LightningElement, wire, api, track } from 'lwc';

import updateParcoursClient from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.updateParcoursClient';
import getContactListNew from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getContactListNew';
import getListVille from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getVilles';
import getMapVille from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.getMapVilles';
import majEmailPersonne from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.majEmailPersonne';
import majConsentements from '@salesforce/apex/VI_parcoursPPRechercheClient_Controller.updateConsentementParcours';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ParcoursPPRechercheClient extends LightningElement {
	FlecheGauche = EngieCommunityResource + '/EngieAssets/pictures/fleche-gauche.png';
	FlecheDroite = EngieCommunityResource + '/EngieAssets/pictures/fleche-droite.png';

	@api recorddonnee;
	@api
	get record() {
		return this._record;
	}
	set record(value) {
		if (value) {
			this._record = { ...value };
			this.handleUndefinedValues('VI_Email1Client__c');
			this.handleUndefinedValues('VI_Mobile1Client__c');
			this.handleUndefinedValues('VI_TelephoneFixe1Client__c');
			this.handleUndefinedValues('VI_NomClient__c');
			this.handleUndefinedValues('VI_PrenomClient__c');
			this.handleUndefinedValues('VI_CommuneClient__c');
			this.handleUndefinedValues('VI_CodePostalClient__c');
			this.handleUndefinedValues('VI_Email_CPV_IsFavori__c');
			this.handleUndefinedValues('VI_Email_CPV__c');
			if (this._record.VI_CodePostalClient__c !== null) {
				if (this._record.VI_CodePostalClient__c.length >= 3) {
					this.updateVilles();
				}
			}
			this.handleUndefinedValues('VI_BoutonCreerNouveauClientClique__c');
			if (this._record.VI_BoutonCreerNouveauClientClique__c === true) {
				this.showCreationClientComponent = true;
				//this.template.querySelector('[data-id="buttons"]').scrollIntoView(false);
			}
			this.handleUndefinedValues('VI_IDReferenceClient__c');
			this.handleUndefinedValues('Tech_IdentificationClientInitiee__c');
			this.handleUndefinedValues('VI_Contact__c');
			if (this._record.Tech_IdentificationClientInitiee__c === true) {
				this.searchSimilarContacts();
				this.afficherEmailPrefere = true;
				/* START DDPCM - 949 */
				this.isShowCLientSContract = true;
				/* END DDPCM - 949 */
			}
			if (this._record.VI_TelephoneFixe1Client__c) {
				this.customerPhoneNumber = this._record.VI_TelephoneFixe1Client__c;
			}
			if (this._record.VI_Mobile1Client__c) {
				this.customerPhoneNumber = this._record.VI_Mobile1Client__c;
			}
			this.errorMessageFormatEmail = false;
			this.inputEmailRed = "form-control";
		}
		else {
			this._record = {};
		}
	}

	@api
	get recordupdated() {
		let creationclient = this.template.querySelector('c-parcours-p-p-creation-client');
		if (creationclient !== null) {
			if (creationclient.recordupdated === true) {
				return creationclient.recordupdated;
			}
		}
		return this._recordupdated;
	}

	set recordupdated(value) {
		this._recordupdated = value;
	}

	@api
	get emailchangedonly() {
		return this._emailchangedonly;
	}
	set emailchangedonly(value) {
		this._emailchangedonly = value;
	}


	@api
	get parcours() {
		let creationclient = this.template.querySelector('c-parcours-p-p-creation-client');
		if (creationclient === null) {
			return null;
		}
		else {
			return creationclient.parcours;
		}

	}

	value;
	error;
	data;
	@api sortedDirection = 'asc';
	@api sortedBy = 'Name';
	@api searchKey = '';
	result;
	page = 0;

	items = [];
	data = [];
	columns;
	startingRecord = 1;
	pageSize = 5;
	totalRecountCount = 0;
	resultatDeRecherche = '0 résultat de recherche';
	totalPage = 0;
	pages = [];
	selectedContact = [];
	selectedRows = [];
	customerPhoneNumber = '';
	_title = 'Sample Title';
	message = 'Sample Message';
	variant = 'error';
	set_size = 6;
	listVilles = [];
	afficherResultat = false;
	buttonReinitializeDisabled = true;
	buttonDisabled = true;
	checkBoxEmailPrefere = false;
	afficherEmailPrefere = false;
	errorMessageFormatEmail = false;
	redLabelTéléphone = false;
	inputEmailRed = "form-control";
	contactEmailModified = false;
	phoneNumberToSearch = '';

	/* START DDPCM - 949 */
	isCLientHasContract = false;
	isShowCLientSContract = false;
	/* END DDPCM - 949 */

	mapVilles = new Map();
	mesVilles = [];

	rgpd1 = false;
	rgpd2 = false;

	// Start DDPCM - 1052 
	rechercheContactSimilaire = false;
	// End DDPCM - 1052 

	//sets the fields to null if they are empty
	handleUndefinedValues(recordField) {
		if (typeof this._record[recordField] === "undefined") {
			this._record[recordField] = null;
		}
	}

	//make the client creation component visible
	showCreationClientComponent = false;

	renderedCallback() {
		if (this._record.VI_BoutonCreerNouveauClientClique__c === true) {
			this.showCreationClientComponent = true;
			//this.template.querySelector('[data-id="buttons"]').scrollIntoView(true);
			this.template.querySelector('c-parcours-p-p-creation-client').scrollIntoView(true);
		}
	}
	showCreationClient() {
		if (!this.buttonDisabled) {
			//this._record.VI_Contact__c = null;

			this._record.VI_BoutonCreerNouveauClientClique__c = true;
			this.buttonReinitializeDisabled = true;
			this.showCreationClientComponent = true;
			this._recordupdated = true;
			this.template.querySelector('c-parcours-p-p-creation-client').scrollIntoView(true);
		}
	}

	reinitialiser() {
		if (this.buttonReinitializeDisabled === false) {
			this.buttonReinitializeDisabled = true;
			this.data = [];
			this.listVilles = [];
			this.resultatDeRecherche = '0 résultat de recherche';
			this.afficherResultat = false;
			this.afficherEmailPrefere = false;
			/* START DDPCM - 949 */
			this.isShowCLientSContract = false;
			/* END DDPCM - 949 */
			this.template.querySelector('form').reset();
			this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
			this._record.VI_Email1Client__c = '';
			this._record.VI_NomClient__c = '';
			this._record.VI_CommuneClient__c = '';
			this._record.VI_Mobile1Client__c = '';
			this._record.VI_TelephoneFixe1Client__c = '';
			this._record.VI_PrenomClient__c = '';
			this._record.VI_CodePostalClient__c = '';
			this._record.VI_IDReferenceClient__c = '';
			this._record.VI_Email_CPV__c = null;
			this._record.VI_Contact__c = null;
			this._record.VI_Email_CPV_IsFavori__c = false;
			this._record.Tech_IdentificationClientInitiee__c = false;
			this._recordupdated = true;
			this.customerPhoneNumber = '';
			this.redLabelTéléphone = false;
			const dispatchEvent = new CustomEvent('reinitializeclient');
			this.dispatchEvent(dispatchEvent);
		}

	}

	removeNumberScroll(event) {
		event.target.blur();
	}

	/*renderedCallback() {
			if(this.showCreationClientComponent === true){
	this.template.querySelector('c-parcours-p-p-creation-client').scrollIntoView(true);
			}
}*/

	//Called to search for contacts in the database
	handleSearchClientChange(event) {
		this._emailchangedonly = false;
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
		let field = event.target.name;
		this._recordupdated = true;
		console.log('event.target.value.length ' + event.target.value.length);
		if (event.target.value.length > 0) {
			const dispatchEventSearch = new CustomEvent('clientsearch');
			this.dispatchEvent(dispatchEventSearch);
		}
		if (field === 'Email') {
			this._record.VI_Email1Client__c = event.target.value;
			if (this.afficherResultat === false) {
				if (/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/.test(this._record.VI_Email1Client__c)) {
					this.searchSimilarContacts();
				}
			}
			else if (this.afficherResultat === true) {
				this.searchSimilarContacts();
			}
		} else if (field === 'Nom') {
			this._record.VI_NomClient__c = event.target.value;
			if (this.afficherResultat === false) {
				if (this._record.VI_NomClient__c.length > 2
					&& this._record.VI_CodePostalClient__c.length === 5
					&& this._record.VI_CommuneClient__c.length > 2) {
					this.searchSimilarContacts();
				}
			}
			else if (this.afficherResultat === true) {
				this.searchSimilarContacts();
			}
		}
		else if (field === 'Téléphone') {
			this.customerPhoneNumber = event.target.value;
			if (event.target.value !== null) {
				this.customerPhoneNumber = event.target.value.slice(0, 10);
				if (this.afficherResultat === false) {
					if (this.customerPhoneNumber.length === 10) {
						if (this.customerPhoneNumber.startsWith('06') || this.customerPhoneNumber.startsWith('07')) {
							this._record.VI_Mobile1Client__c = this.customerPhoneNumber;
							this._record.VI_TelephoneFixe1Client__c = '';
							this.redLabelTéléphone = false;
							this.searchSimilarContacts();
						}
						else if ((this.customerPhoneNumber.startsWith('0'))
							&& !(this.customerPhoneNumber.startsWith('06') || this.customerPhoneNumber.startsWith('07') ||
								this.customerPhoneNumber.startsWith('08') || this.customerPhoneNumber.startsWith('00'))) {
							this._record.VI_TelephoneFixe1Client__c = this.customerPhoneNumber;
							this._record.VI_Mobile1Client__c = '';
							this.redLabelTéléphone = false;
							this.searchSimilarContacts();
						}
						else {
							this.redLabelTéléphone = true;
						}
					}
					else {
						this.redLabelTéléphone = false;
					}
				}
				else if (this.afficherResultat === true) {
					if (this.customerPhoneNumber.length < 2) {
						this._record.VI_Mobile1Client__c = '';
						this._record.VI_TelephoneFixe1Client__c = '';
					}
					if (this.customerPhoneNumber.length === 10) {
						if (!(this.customerPhoneNumber.startsWith('01') || this.customerPhoneNumber.startsWith('02') ||
							this.customerPhoneNumber.startsWith('03') || this.customerPhoneNumber.startsWith('04') ||
							this.customerPhoneNumber.startsWith('05') || this.customerPhoneNumber.startsWith('06') ||
							this.customerPhoneNumber.startsWith('07') || this.customerPhoneNumber.startsWith('09'))) {
							this.redLabelTéléphone = true;
							this.totalRecountCount = 0;
							this.resultatDeRecherche = '0 résultat de recherche';
							this.data = [];
						}
						else {
							if (this.customerPhoneNumber.startsWith('06') || this.customerPhoneNumber.startsWith('07')) {
								this._record.VI_Mobile1Client__c = this.customerPhoneNumber;
								this._record.VI_TelephoneFixe1Client__c = '';
							}
							else if ((this.customerPhoneNumber.startsWith('0')) && (this.customerPhoneNumber.length > 1)
								&& !(this.customerPhoneNumber.startsWith('06') || this.customerPhoneNumber.startsWith('07') ||
									this.customerPhoneNumber.startsWith('08') || this.customerPhoneNumber.startsWith('00'))) {
								this._record.VI_TelephoneFixe1Client__c = this.customerPhoneNumber;
								this._record.VI_Mobile1Client__c = '';
							}
							this.redLabelTéléphone = false;
							this.searchSimilarContacts();
						}
					}
					else {
						this.totalRecountCount = 0;
						this.resultatDeRecherche = '0 résultat de recherche';
						this.data = [];
					}
				}
			}
		}
		else if (field === 'Prénom') {
			this._record.VI_PrenomClient__c = event.target.value;
			if (this.afficherResultat === false) {

			} else {
				this.searchSimilarContacts();
			}
		}
		else if (field === 'Commune') {
			this._record.VI_CommuneClient__c = event.target.value;
			if (this.afficherResultat === false) {
				if (this._record.VI_NomClient__c.length > 2
					&& this._record.VI_CodePostalClient__c.length === 5
					&& this._record.VI_CommuneClient__c.length > 2) {
					this.searchSimilarContacts();
				}
			} else {
				this.searchSimilarContacts();
			}
			if (event.target.value === null || event.target.value === "") {
				this._record.VI_CodePostalClient__c = null;
			}
		}
		else if (field === 'CodePostal') {
			this.listVilles = [];
			this._record.VI_CodePostalClient__c = event.target.value;
			if (event.target.value !== null) {
				this._record.VI_CodePostalClient__c = event.target.value.slice(0, 5);
				if (this._record.VI_CodePostalClient__c.length >= 3) {
					this.checkListVille();
					this.updateVilles();
				}
				if (this._record.VI_NomClient__c.length > 2
					&& this._record.VI_CodePostalClient__c.length === 5
					&& this._record.VI_CommuneClient__c.length > 2) {

					this.searchSimilarContacts();
				}
				if (event.target.value === "") {
					this._record.VI_CommuneClient__c = null;
				}
			} else {
				this._record.VI_CommuneClient__c = null;
			}

		}
		else if (field === 'RefClient') {
			if (event.target.value !== null) {
				this._record.VI_IDReferenceClient__c = event.target.value.slice(0, 9);
				if (this._record.VI_IDReferenceClient__c.length > 8 && this.afficherResultat === false) {
					this.searchSimilarContacts();
				}
				else if (this.afficherResultat === true) {
					this.searchSimilarContacts();
				}
			}
		}

		if ((this._record.VI_Email1Client__c !== '' && this._record.VI_Email1Client__c !== null) ||
			(this._record.VI_NomClient__c !== '' && this._record.VI_NomClient__c !== null) ||
			(this._record.VI_CommuneClient__c !== '' && this._record.VI_CommuneClient__c !== null) ||
			(this._record.VI_Mobile1Client__c !== '' && this._record.VI_Mobile1Client__c !== null) ||
			(this._record.VI_TelephoneFixe1Client__c !== '' && this._record.VI_TelephoneFixe1Client__c !== null) ||
			(this._record.VI_PrenomClient__c !== '' && this._record.VI_PrenomClient__c !== null) ||
			(this._record.VI_CodePostalClient__c !== '' && this._record.VI_CodePostalClient__c !== null) ||
			(this._record.VI_IDReferenceClient__c !== '' && this._record.VI_IDReferenceClient__c !== null) ||
			(this.customerPhoneNumber !== '' && this.customerPhoneNumber !== null)
		) {
			this.buttonReinitializeDisabled = false;
		}

		if ((this._record.VI_Email1Client__c === '' || this._record.VI_Email1Client__c === null) &&
			(this._record.VI_NomClient__c === '' || this._record.VI_NomClient__c === null) &&
			(this._record.VI_CommuneClient__c === '' || this._record.VI_CommuneClient__c === null) &&
			(this._record.VI_Mobile1Client__c === '' || this._record.VI_Mobile1Client__c === null) &&
			(this._record.VI_TelephoneFixe1Client__c === '' || this._record.VI_TelephoneFixe1Client__c === null) &&
			(this._record.VI_PrenomClient__c === '' || this._record.VI_PrenomClient__c === null) &&
			(this._record.VI_CodePostalClient__c === '' || this._record.VI_CodePostalClient__c === null) &&
			(this._record.VI_IDReferenceClient__c === '' || this._record.VI_IDReferenceClient__c === null) &&
			(this.customerPhoneNumber === '' || this.customerPhoneNumber === null)
		) {
			this.buttonReinitializeDisabled = true;
		}
	}

	//search for similar contacts
	searchSimilarContacts() {
		this.totalRecountCount = 0;
		this.resultatDeRecherche = '0 résultat de recherche';
		this.data = [];
		this._record.Tech_IdentificationClientInitiee__c = true;
		this.afficherResultat = true;
		this.buttonDisabled = false;
		this.buttonReinitializeDisabled = false;
		const dispatchEventSearch = new CustomEvent('clientsearch');
		this.dispatchEvent(dispatchEventSearch);
		this.rechercheContactSimilaire = false;

		getContactListNew
			(
				{
					lastName: this._record.VI_NomClient__c,
					phoneNumber: this.customerPhoneNumber,
					email: this._record.VI_Email1Client__c,
					commune: this._record.VI_CommuneClient__c,
					codePostal: this._record.VI_CodePostalClient__c,
					referenceClient: this._record.VI_IDReferenceClient__c,
					prenom: this._record.VI_PrenomClient__c
				}
			).then(result => {
				this.data = result;
				this.rechercheContactSimilaire = true;
				if (this.data.length > 0) {
					this.page = 1;
					this.selectedRows = [];
					for (let i = 0; i < this.data.length; i++) {
						if (this.data[i].Id === this._record.VI_Contact__c) {
							this.selectedRows = [...this.selectedRows, this.data[i].Id];
						}
					}
				}
				else {
					this.data = [];
					this.page = 0;
				}
				this.totalRecountCount = this.data.length;
				if (this.totalRecountCount === 0 || this.totalRecountCount === 1) {
					this.resultatDeRecherche = this.totalRecountCount + ' résultat de recherche';
				}
				else {
					this.resultatDeRecherche = this.totalRecountCount + ' résultats de recherche';
				}
				this.columns = columns;
				this.pages = [];
				this.setPages(this.data);
			})
			.catch(error => {
				this.error = error;
			});
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
		if (this.data !== null) {
			let page = this.page;
			let perpage = this.pageSize;
			let startIndex = (page * perpage) - perpage;
			let endIndex = (page * perpage);
			return this.data.slice(startIndex, endIndex);
		}
		else {
			return this.data;
		}
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
		++this.page;
	}
	//move to the previous page
	onPrev = () => {
		--this.page;
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

	async secondMethodCall() {
		return new Promise(async (resolve, reject) => {
			var result = await majConsentements(
				{
					parcours: this._record
				}
			).then(result => {
				console.log('succes')
				console.log(result);
				this.rgpd1 = result.VI_ConsentProspectionEngieNonAnalogue__c;
				this.rgpd2 = result.VI_ConsentProspectionPartenaire__c;
			})
				.catch(error => {
					console.log('erreur')
					this.error = error;
				});;
			resolve(result);
		});
	}

	async updateParcours(event) {
		const datatable = this.template.querySelector('lightning-datatable');
		const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
		var continuParcour = true;
		if (selectedRows.length > 0) {
			this.selectedContact = selectedRows[0];
			// Start DDPCM - 279 
			if (this._record.VI_AdresseDeConsoIdentique__c) {
				this._record.VI_NumeroRueRechercheLocal__c = "";
				this._record.VI_RueRechercheLocal__c = "";
				this._record.VI_CodePostalRechercheLocal__c = "";
				this._record.VI_CommuneRechercheLocal__c = "";
				this._record.VI_RechercheLocal_AdresseComplete__c = "";
				this._record.VI_CodeCommuneIdentificationLocal__c = "";
				this._record.VI_PDLRechercheLocal__c = "";
				this._record.VI_PCERechercheLocal__c = "";
				this._record.VI_AdresseDeConsoIdentique__c = false;
				this._record.VI_LocalNonIdentifieGenerationCase__c = false;
				const dispatchEventAddressLocal = new CustomEvent('reinitializeclient');
				this.dispatchEvent(dispatchEventAddressLocal);
			}
			// END DDPCM - 279 
			this._record.VI_Contact__c = this.selectedContact.Id;
			this._record.VI_IDReferenceClient__c = this.selectedContact.reference_client_f__c;
			this._record.VI_BoutonCreerNouveauClientClique__c = false;
			this._recordupdated = true;
			if (this._record.VI_Email_CPV__c && this._record.VI_Email_CPV__c != "") {
				if (/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/.test(this._record.VI_Email_CPV__c)) {
					continuParcour = true;
					if (this._record.VI_Email_CPV_IsFavori__c) {
						majEmailPersonne
							(
								{
									parcours: this._record
								}
							).then(result => {

							})
							.catch(error => {
								this.error = error;
							});
					}
				} else {
					this._title = 'Erreur';
					this.message = 'Merci de renseigner un format d\'email valide';
					this.variant = 'error';
					this.showNotification();
					continuParcour = false;
					this.inputEmailRed = "form-control inputRed";
				}
			}

			await this.secondMethodCall();
			this._record.VI_ConsentProspectionEngieNonAnalogue__c = this.rgpd1;
			this._record.VI_ConsentProspectionPartenaire__c = this.rgpd2;

			if (continuParcour) {
				console.log('continu')
				const dispatchEvent = new CustomEvent('clientselection');
				this.dispatchEvent(dispatchEvent);
			}
		}
		else {
			this._title = 'Erreur';
			this.message = 'Merci de sélectionner un client';
			this.variant = 'error';
			this.showNotification();
		}
	}

	updateContactId() {
		updateParcoursClient
			(
				{
					parcours: this._record,
					contactId: this.selectedContact.Id,
					referenceClient: this.selectedContact.Identifiant_Buisness_Partener__c
				}
			).then(result => {
				console.log('updateParcours success');
			})
			.catch(error => {
				this.error = error;
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

	checkListVille() {
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.remove('slds-hide');
	}

	handleCheckEmailPrefere() {
		this._recordupdated = true;
		this._record.VI_Email_CPV_IsFavori__c = this.template.querySelector('[data-id="checkBoxEmailPrefereId"]').checked;
		this._record.VI_Email_CPV__c = this.template.querySelector('[data-id="inputEmailPrefereId"]').value;
	}

	afficherEmailPrefereAction(event) {
		this._recordupdated = true;
		this.afficherEmailPrefere = true;
		/* START DDPCM - 949 */
		this.isShowCLientSContract = true;
		/* END DDPCM - 949 */
	}

	updateEmailCPV(event) {
		console.log("in updateEmailCPV ");
		this._recordupdated = true;
		this._record.VI_Email_CPV__c = event.target.value;
	}

	updateEmailPrefere() {
		console.log("in updateEmailPrefere");
		if (/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/.test(this._record.VI_Email_CPV__c)) {
			if (this._record.VI_Email_CPV_IsFavori__c) {
				majEmailPersonne
					(
						{
							parcours: this._record
						}
					).then(result => {

					})
					.catch(error => {
						this.error = error;
					});
			}
		}
	}

	updateVilles() {
		getMapVille(
			{
				codePostal: this._record.VI_CodePostalClient__c
			}
		).then(result => {
			this.mesVilles = [];

			for (var key in result) {
				this.mesVilles.push(key);
				this.mapVilles.set(key, result[key]);
			}
			if (this.mesVilles.length === 1) {
				this._record.VI_CommuneClient__c = this.mesVilles[0];

				this._record.VI_CodePostalClient__c = this.mapVilles.get(this.mesVilles[0]);
				this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
			}
		})


	}
	selectVilleValue(event) {
		this._record.VI_CommuneClient__c = event.currentTarget.dataset.value;
		this._record.VI_CodePostalClient__c = this.mapVilles.get(this._record.VI_CommuneClient__c);
		this.template.querySelector('[data-id="ville"]').value = event.currentTarget.dataset.value;
		this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
		this.searchSimilarContacts();
	}

	onFormSubmit(event) {
		console.log('####submit');
		event.preventDefault();
		event.stopPropagation();
	}

	handlePrecedent(event) {
		const dispatchEventSearch = new CustomEvent('precedent');
		this.dispatchEvent(dispatchEventSearch);
	}

	handleSuivant(event) {
		const dispatchEventSearch = new CustomEvent('suivant');
		this.dispatchEvent(dispatchEventSearch);
	}

}

const columns = [
	{
		label: 'NOM', fieldName: 'LastName', cellAttributes:
			{ style: 'box-shadow:none' }
	},
	{ label: 'PRÉNOM', fieldName: 'FirstName', wrapText: true },
	{ label: 'ADRESSE EMAIL', fieldName: 'VI_Contact_Emails__c', wrapText: true },
	{ label: 'TÉLÉPHONE', fieldName: 'VI_Contact_Tel_Fixes__c', wrapText: true },
	{ label: 'MOBILE', fieldName: 'VI_Contact_Mobile__c', wrapText: true },
	{ label: 'CODE POSTAL', fieldName: 'MailingPostalCode' },
	{ label: 'COMMUNE', fieldName: 'MailingCity' },
	{ label: 'RÉFÉRENCE CLIENT', fieldName: 'reference_client_f__c' }

];