import { LightningElement, api, track , wire} from 'lwc';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import getSelectedContact from '@salesforce/apex/VI_ParcoursPPRecap_Controller.getSelectedContact';
import envoieCpv from '@salesforce/apex/VI_ParcoursPPRecap_Controller.envoiCPV';
import coupleCodeValeurInit from '@salesforce/apex/VI_SM025_CreerCPVSansPC.createCoupleCodeValeurINIT';
import getQuestions from '@salesforce/apex/VI_ParcoursPPRecap_Controller.getQuestions';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import HomePageRedirectLink from '@salesforce/label/c.VI_HomePageRedirectLink';


export default class ParcoursPPRecapSouscription extends NavigationMixin(LightningElement) {

	situation;
	energie;
	releve_compteur;
	indexs;
	dateFormat;
	panier;
	@track
	portable2;

	@track loaded = true;

	commentaireImage = EngieCommunityResource + '/EngieAssets/pictures/crayon_modif.png';
	optionDropImage = EngieCommunityResource + '/EngieAssets/pictures/fleche-droite.png';
	iconInformation = EngieCommunityResource + '/EngieAssets/pictures/icon-information.png';
	prochainesEtapes = EngieCommunityResource + '/EngieAssets/pictures/FilProchainesEtapes.png';
	closeImage = EngieCommunityResource + '/EngieAssets/pictures/close-icon.png';
	checked = EngieCommunityResource + '/EngieAssets/pictures/checked.png';
	unchecked = EngieCommunityResource + '/EngieAssets/pictures/unchecked.png';

	isOption = false;

	isOffre;
	isAjuste = false;
	isIndexElec = false;
	isIndexGaz = false;
	isAppartement = false;
	isEM = false;
	isCHF = false;
	isBoutonEM = false;
	isBoutonCHF = false;
	isBoutonARenvoyer = false;
	isMessage = true;
	isOpen = true;
	etape;
	isOptionGaz = false;
	isShowPopUp = false;
	openEtape = true;
	isAuto = true;
	// Start Assurance Facture
	isOptionAF = false;
	// End Assurance Facture

	//Start Offre reference recap
	isElec = false;
	isGaz = false;
	isHPHC = false;
	//End Offre reference recap

	//DDPCM 993 START
	achHPNotNull = false;
	achHCNotNull = false;
	fouHPNotNull = false;
	fouHCNotNull = false;
	consoAcheminement4Quadrant = false;
	consoAcheminement2Quadrant = false;
	consoAcheminementBase = false;
	//DDPCM 993 END

	isPrincipalEmail1 = true;
	isPrincipalFixe1 = true;
	isPrincipalPortable1 = true;


	hasCodePromo = false;

	//DDPCM 1195 START
	isCodePromo1 = false;
	isCodePromo2 = false;
	//DDPCM 1195 END

	// Start DDPCM 1110
	isFactureEnLigne = false;
	isEDoc = false;
	// End DDPCM 1110

	/* Start Autres Canaux */
	isAutresCanaux = false;
	isMensualistionAutresCanaux = false;
	/* End Autres Canaux */
	//DDPCM-1324 Consentement RGPD
	questionsLoaded = false;
	DonneesGDPR = "";

	/* Start DDPCM 1299*/
	isConsentementRGPD1Oui = false;
	isConsentementRGPD1Non = false;
	isConsentementRGPD2Oui = false;
	isConsentementRGPD2Non = false;
	/* End DDPCM 1299*/

	@track
	isTel;
	@track
	isFixe;
	@track
	isMail;
	@track
	isEmailCPV = false;
	@track
	isNewEmail = false;

	_title = 'Erreur';
	message = 'Erreur';
	variant = 'error';
	@track coupleCodeValeurs;
	@track buttonStyle = 'height: 44px;width: 260px;color: #666!important;background-color: #ccc;border-color: #999;border-radius:0';
	@track disableEnvoyerButton = true;
	@track client;
	@track error;
	@track nomClient;
	@track prenomClient;
	@track referenceClient;
	@track tel1Client;
	@track tel2Client;
	@track email1Client;
	@track email2Client;
	@track fixe1Client;
	@track fixe2Client;
	@track communeClient;
	@track codePostalClient;
	@track adresseClient;
	@track civilite;
	@track rue;
	@track numeroRue;
	@track commentairesParcours = "";

	@track numeroCase;
	statutCase;

	@api alliscompleted;
	@track imageRepliStyle = "";

/* ________________________________________________________________________________________________________________________________________________________ */
/* _________________________________________________________ INIT FUNCTION _________________________________________________________________________ */
/* ________________________________________________________________________________________________________________________________________________________ */


	@api
	get record() {
		return this._record;
	}
	set record(value) {
		if (value) {
			this._record = { ...value };
			this.commentairesParcours = this._record.VI_CommentairesParcours__c;
			this.getOfferOption();
			this.getCodePromo();

			/* Start Autres Canaux */
			if (this._record.VI_TypeParcours__c !='PURE PLAYERS') {
				this.isAutresCanaux = true;
				if (this._record.VI_ChoixMensualisation__c === 'Oui') {
					this.isMensualistionAutresCanaux = true;
				}
			}
			/* End Autres Canaux */

			if (this._record.VI_ChoixMoyenPaiement__c === "Autre" && this._record.VI_TypeParcours__c ==='PURE PLAYERS') {
				this.isAuto = false;
			}

			//Start Offre reference recap
			if (this._record.VI_ChoixEnergie__c === "Electricité") {
				this.isElec = true;
				this.isGaz = false;
			}
			if (this._record.VI_ChoixEnergie__c === "Gaz") {
				this.isElec = false;
				this.isGaz = true;
			}
			if (this._record.VI_ChoixEnergie__c === "Electricité + Gaz") {
				this.isElec = true;
				this.isGaz = true;
			}

			if ((this._record.VI_ChoixEstimation__c === 'Saisir la consommation d\'énergie' &&
				this._record.VI_SaisieConsommationElec_HP_HC__c === true) ||
				(this._record.VI_ChoixEstimation__c === 'Estimer la consommation d\'énergie' &&
					this._record.VI_SaisieEstimationConsoElec_HP_HC__c === 'Oui')) {
				this.isHPHC = true;
			}
			else {
				this.isHPHC = false;
			}

			if (this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c != null &&
				this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c !== undefined) {
				this.consoAcheminement4Quadrant = true;
			}
			else if (this._record.VI_PRIX_KWH_ELEC_ACH_HC_HT__c != null &&
				this._record.VI_PRIX_KWH_ELEC_ACH_HC_HT__c !== undefined) {
				this.consoAcheminement2Quadrant = true;
			}
			else if(this._record.VI_PRIX_KWH_ELEC_ACH_HT__c != null &&
				this._record.VI_PRIX_KWH_ELEC_ACH_HT__c !== undefined){
				this.consoAcheminementBase=true;
			}
				
			if (this.isHPHC) {
				if (this._record.VI_PRIX_KWH_ELEC_ACH_HP_TTC__c != null &&
					this._record.VI_PRIX_KWH_ELEC_ACH_HP_TTC__c != undefined) {
					this.achHPNotNull = true;
				}
				if (this._record.VI_PRIX_KWH_ELEC_ACH_HC_TTC__c != null &&
					this._record.VI_PRIX_KWH_ELEC_ACH_HC_TTC__c != undefined) {
					this.achHCNotNull = true;
				}
				if (this._record.VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c != null &&
					this._record.VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c != undefined) {
					this.fouHPNotNull = true;
				}
				if (this._record.VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c != null &&
					this._record.VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c != undefined) {
					this.fouHCNotNull = true;
				}
				// Start DDPCM 1110
				if (this._record.VI_FactureEnLigne__c === 'Oui') {
					this.isFactureEnLigne = true;
				}
				else {
					this.isFactureEnLigne = false;
				}
				if (this._record.VI_EdocsMoyensPaiement__c === 'Oui') {
					this.isEDoc = true;
				}
				else {
					this.isEDoc = false;
				}
				// Start DDPCM 1110
			}

			//End Offre reference recap
			// Start DDPCM 1110
			if (this._record.VI_FactureEnLigne__c === 'Oui') {
				this.isFactureEnLigne = true;
			}
			else {
				this.isFactureEnLigne = false;
			}
			if (this._record.VI_EdocsMoyensPaiement__c === 'Oui') {
				this.isEDoc = true;
			}
			else {
				this.isEDoc = false;
			}
			// End DDPCM 1110

			/* Start DDPCM 1299*/
			if (this._record.VI_ConsentProspectionEngieNonAnalogue__c === 'Oui') {
				this.isConsentementRGPD1Oui = true;
				this.isConsentementRGPD1Non = false;
			}
			else if (this._record.VI_ConsentProspectionEngieNonAnalogue__c === 'Non') {
				this.isConsentementRGPD1Oui = false;
				this.isConsentementRGPD1Non = true;
			}
			if (this._record.VI_ConsentProspectionPartenaire__c === 'Oui') {
				this.isConsentementRGPD2Oui = true;
				this.isConsentementRGPD2Non = false;
			}
			else if (this._record.VI_ConsentProspectionPartenaire__c === 'Non') {
				this.isConsentementRGPD2Oui = false;
				this.isConsentementRGPD2Non = true;
			}
			/* End DDPCM 1299*/
		} else {
			this._record = {};
		}
		this._record.VI_NomClient__c = this.nomClient;
		this._record.VI_PrenomClient__c = this.prenomClient;
		this._record.VI_IDReferenceClient__c = this.referenceClient;
		this.email1Client = this._record.VI_Email1Client__c;
		this._record.VI_Email1Client__c = this.email1Client;
		this._record.VI_Email2Client__c = this.email2Client;
		this._record.VI_Mobile1Client__c = this.tel1Client;
		this._record.VI_Mobile2Client__c = this.tel2Client;
		this._record.VI_TelephoneFixe1Client__c = this.fixe1Client;
		this._record.VI_TelephoneFixe2Client__c = this.fixe2Client;
		this._record.VI_CommuneClient__c = this.communeClient;
		this._record.VI_CodePostalClient__c = this.codePostalClient;
		this._record.VI_Numero_de_la_rue__c = this.numeroRue;
		this._record.VI_CiviliteClient__c = this.civilite;
	}

	@api
	get recordupdated() {
		return this._recordupdated;
	}
	set recordupdated(value) {
		this._recordupdated = value;
	}

	@api
	get recorddonnee() {
		return this._recorddonnee;
	}
	set recorddonnee(value) {
		this._recorddonnee = value;
		this.setLabels();
	}

	@api
	get situations() {
		if (this._record.VI_ChoixParcours__c == 'EM') {
			this.situation = 'Emménagement';
			this.isEM = true;
			if (this._record.VI_StatutParcours__c == 'CPV Envoyées: PDL/PCE connu' ||
				this._record.VI_StatutParcours__c == 'CPV Envoyées: PDL/PCE non connu') {
				this.isBoutonARenvoyer = true;
			}
			else {
				this.isBoutonEM = true;
			}
		}
		else if (this._record.VI_ChoixParcours__c == 'CHF') {
			this.situation = 'Changement de fournisseur';
			this.isCHF = true;
			if (this._record.VI_StatutParcours__c == 'CPV Envoyées: PDL/PCE connu' ||
				this._record.VI_StatutParcours__c == 'CPV Envoyées: PDL/PCE non connu') {
				this.isBoutonARenvoyer = true;
			}
			else {
				this.isBoutonCHF = true;
			}
		}
		else {
			this.situation = 'Aucune situation sélectionnée'
		}
		return this.situation;
	}

	//DDPCM-1324 Consentement RGPD
	@wire(getQuestions, {})
	questions({ error, data }) {
		if (data) {
			this.questionslist = data;
			this.consentementEngie = data[0];
			this.consentementPartner = data[1];
			this.questionsLoaded = true;
		}
		else if (error) {
			this.error = error;
		}
	}

	//rattacher le contact selectionné au parcours
	connectedCallback() {
		getSelectedContact
			(
				{
					parcours: this._record
				}
			).then(result => {
				this.client = result;
				this.numeroCase = this.client.recapCase.CaseNumber;
				this.statutCase = this.client.recapCase.statutEnveloppe;
				this._record.VI_IDReferenceClient__c = this.client.recapContact.reference_client_f;
				this._record.VI_NomClient__c = this.client.recapContact.FirstName;
				this._record.VI_PrenomClient__c = this.client.recapContact.LasttName;
				this._record.VI_Email1Client__c = this.client.recapContact.Email;
				this._record.VI_Email2Client__c = this.client.recapContact.VI_Email1Client;
				this.nomClient = this.client.recapContact.FirstName;
				this.prenomClient = this.client.recapContact.LastName;
				this.referenceClient = this.client.recapContact.reference_client_f;
				this.tel1Client = this.client.recapContact.MobilePhone;
				this.tel2Client = this.client.recapContact.Mobile_2;
				this.email1Client = this.client.recapContact.Email;
				this.email2Client = this.client.recapContact.Adresse_Mail_2;
				this.fixe1Client = this.client.recapContact.Phone;
				this.fixe2Client = this.client.recapContact.Tel_Fixe_2;
				if (this.client.recapContact.MailingCity !== null && this.client.recapContact.MailingCity !== undefined) {
					this.communeClient = this.client.recapContact.MailingCity.toUpperCase();
				}
				else {
					this.communeClient = null;
				}
				this.codePostalClient = this.client.recapContact.MailingPostalCode;
				this.adresseClient = this.client.recapContact.MailingAddress;
				this.civilite = this.client.recapContact.Salutation;
				if (this.client.recapContact.MailingCity !== null && this.client.recapContact.MailingCity !== undefined) {
					this.rue = this.client.recapContact.MailingStreet.toUpperCase();
				}
				else {
					this.rue = null;
				}
				this.numeroRue = this.client.recapContact.No_Voie;
				if ((this.tel1Client != undefined && this.tel1Client.length == 12) || (this.tel2Client != undefined && this.tel2Client.length == 12)) {
					this.isTel = true;
				}


				if ((this.fixe1Client != undefined && this.fixe1Client.length == 12) || (this.fixe2Client != undefined && this.fixe2Client.length == 12)) {
					this.isFixe = true;
				}
				if ((this.email1Client != undefined && this.email1Client.length > 0) || (this.email2Client != undefined && this.email2Client.length > 0)) {
					this.isMail = true;
				}
				if (this._record.VI_Email_CPV__c && this._record.VI_Email_CPV__c != "") {
					this.isEmailCPV = true;
					if (this._record.VI_Email_CPV_IsFavori__c === true) {
						this.isNewEmail = true;
					}
				}


				if (this.client.recapContact.Adresse_Mail_Principale === 'Adresse Mail 2') {
					this.isPrincipalEmail1 = false;
				}
				if (this.client.recapContact.Adresse_Mail_Principale === 'Adresse Mail 1') {
					this.isPrincipalEmail1 = true;
				}
				if (this.client.recapContact.Tel_Fixe_Principal === 'Tel Fixe 2') {
					this.isPrincipalFixe1 = false;
				}
				if (this.client.recapContact.Tel_Fixe_Principal === 'Tel Fixe 1') {
					this.isPrincipalFixe1 = true;
				}
				if (this.client.recapContact.Mobile_Principal === 'Mobile 2') {
					this.isPrincipalPortable1 = false;
				}
				if (this.client.recapContact.Mobile_Principal === 'Mobile 1') {
					this.isPrincipalPortable1 = true;
				}
			})
			.catch(error => {
				this.error = error;
			});

		//Get coupleCodeValeurs
		coupleCodeValeurInit
			(
				{
					parcours: this._record
				}
			).then(result => {
				this.coupleCodeValeurs = result;
				this.disableEnvoyerButton = false;
				this.buttonStyle = 'height: 44px;width: 260px;color: #fff;background-color: rgba(0, 153, 52, 1);border-color: rgba(0, 153, 52, 1);border-radius:0';

			})
			.catch(error => {
				this.error = error;
			});
	}

	//Affichage téléphone portable1
	@api
	get telephone_portable1() {
		let portable;
		let tel1;
		if (this.tel1Client != undefined) {
			tel1 = this.tel1Client.replace(/[+]\d{2}/g, '0');
			portable = tel1.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5");
		}
		else {
			portable = '';
		}

		return portable;
	}

	//Affichage téléphone portable2
	@api
	get telephone_portable2() {
		let portable;
		let tel2;
		if (this.tel2Client != undefined) {
			tel2 = this.tel2Client.replace(/[+]\d{2}/g, '0');
			portable = ', ' + tel2.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5");
		}
		else {
			portable = '';
		}

		return portable;
	}


	//verify the principal contact
	getPrincipalContact() {
		if (this._record.VI_EmailPrincipalCreationClient__c === 'Email1') {
			this.isPrincipalEmail1 = true;
		}
		if (this._record.VI_TelephonePrincipalCreationClient__c === 'Téléphone 1') {
			this.isPrincipalFixe1 = true;
		}
		if (this._record.VI_MobilePrincipalCreationClient__c === 'Mobile 1') {
			this.isPrincipalPortable1 = true;
		}
	}

	//verify offre et option selected
	getOfferOption() {
		if (this._record.VI_MontantOffrePanierClient__c && this._record.VI_MontantOffrePanierClient__c != this._record.VI_MontantdelaMensualitePanierClient__c) {

			this.isAjuste = true;
		}
		if (parseFloat(this._record.VI_MontantdelaMensualitePanierClient__c) > 0) {
			this.isOffre = true;
		}
		if (parseFloat(this._record.VI_ServiceOptionVerteElecPrixAbTTC__c) > 0) {
			this.isOption = true;
		}
		if (parseFloat(this._record.VI_ServiceOptionVerteGazPrixAbTTC__c) > 0) {
			this.isOptionGaz = true;
		}
		// START Assurance Facture
		if (parseFloat(this._record.VI_PrixAssuranceFacture__c) > 0) {
			this.isOptionAF = true;
		}
		// END Assurance Facture
		// Start DDPCM 1195
		if (this._record.VI_CodePromoApplied__c) {
			this.isCodePromo1 = true;
		}
		if (this._record.VI_CodePromoApplied2__c) {
			this.isCodePromo2 = true;
		}
		// End DDPCM 1195
	}

	//sets the fields to zero if they are empty
	handleSetToZero(recordField) {
		if (typeof this._record[recordField] === "undefined") {
			this._record[recordField] = 0;
		}
		if (this._record[recordField] === null) {
			this._record[recordField] = 0;
		}
	}

	//Affichage panier
	@api
	get total_panier() {
		let montantPanier = 0;
		if (this._record.VI_MontantdelaMensualitePanierClient__c != null) {
			montantPanier = montantPanier + parseFloat(this._record.VI_MontantdelaMensualitePanierClient__c.toString().replace(",", "."));
		}
		if (this._record.VI_ServiceOptionVerteElecPrixAbTTC__c != null) {
			montantPanier = montantPanier + parseFloat(this._record.VI_ServiceOptionVerteElecPrixAbTTC__c.toString().replace(".", ","));
		}
		if (this._record.VI_ServiceOptionVerteGazPrixAbTTC__c != null) {
			montantPanier = montantPanier + parseFloat(this._record.VI_ServiceOptionVerteGazPrixAbTTC__c.toString().replace(",", "."));
		}
		if (this._record.VI_PrixAssuranceFacture__c != null) {
			montantPanier = montantPanier + parseFloat(this._record.VI_PrixAssuranceFacture__c.toString().replace(".", ","));
		}
		this.panier = montantPanier.toString() + ' €/mois comprenant :';

		return this.panier;
	}

	//Affichage téléphone fixe
	@api
	get telephone_fixe() {
		let fixe;
		let fixe1;
		let fixe2;
		if (this.fixe1Client != undefined && this.fixe2Client != undefined) {
			fixe1 = this.fixe1Client.replace(/[+]\d{2}/g, '0');
			fixe2 = this.fixe2Client.replace(/[+]\d{2}/g, '0');

			fixe = 'Téléphone fixe : ' + fixe1.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5") + ' , ' + fixe2.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5");
		}
		else if (this.fixe1Client != undefined && this.fixe2Client === undefined) {
			fixe1 = this.fixe1Client.replace(/[+]\d{2}/g, '0');
			fixe = 'Téléphone fixe : ' + fixe1.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5");
		}
		else if (this.fixe1Client === undefined && this.fixe2Client != undefined) {
			fixe2 = this.fixe1Client.replace(/[+]\d{2}/g, '0');
			fixe = 'Téléphone fixe : ' + fixe2.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5");
		}
		else {
			fixe = 'Téléphone fixe : Non renseigné';
		}
		return fixe;
	}

	//Affichage téléphone fixe1
	@api
	get telephone_fixe1() {
		let fixe;
		let fixe1;
		if (this.fixe1Client != undefined) {
			fixe1 = this.fixe1Client.replace(/[+]\d{2}/g, '0');
			fixe = fixe1.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5");
		}
		else {
			fixe = '';
		}

		return fixe;
	}

	//Affichage téléphone fixe2
	@api
	get telephone_fixe2() {
		let fixe;
		let fixe2;
		if (this.fixe2Client != undefined) {
			fixe2 = this.fixe2Client.replace(/[+]\d{2}/g, '0');
			fixe = ', ' + fixe2.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1 $2 $3 $4 $5");
		}
		else {
			fixe = '';
		}

		return fixe;
	}

	//affichage email1
	@api
	get email1() {
		let mail;
		if (this.email1Client !== undefined) {
			mail = this.email1Client;
		}
		return mail;
	}

	//affichage email2
	@api
	get email2() {
		let mail;
		if (this.email2Client !== undefined) {
			mail = ', ' + this.email2Client;
		}
		return mail;
	}

	// affichage de la date - formatage xx-xx-xxxx au format xx/xx/xxxx
	@api
	get dateFormat() {
		let date;
		date = this._record.VI_InfosCompl_DateContratEffectif__c.replace(/(\d{4})-(\d{1,2})-(\d{1,2})/, "$3/$2/$1");
		return date.substring(0, 10);
	}

	//verification du relevé de compteur pour checkbox information contrat
	@api
	get releves_compteurs() {
		if (this._record.VI_InfosCompl_ChoixReleveCompteur__c == 'Saisir mes relevés') {
			this.releve_compteur = true;
		}
		else {
			this.releve_compteur = false;
		}
		return this.releve_compteur;
	}

	//Récupération de l'index en fonction de la valeur relevée
	@api
	get indexElec() {
		if (this._record.VI_InfosCompl_IndexElec__c != undefined) {
			this.indexs = 'Index électricité : ' + (this._record.VI_InfosCompl_IndexElec__c).toString() + ' KWh';
			this.isIndexElec = true;
		}

		return this.indexs;
	}

	get isApp() {
		if (this._record.VI_TypeLogementRechercheLocal__c == 'Appartement') {

			this.isAppartement = true;
		}

		return this.isAppartement;
	}

	//Récupération de l'index en fonction de la valeur relevée
	@api
	get indexGaz() {
		var index_gaz;
		if (this._record.VI_InfosCompl_IndexGaz__c != undefined) {
			this.index_gaz = 'Index gaz : ' + (this._record.VI_InfosCompl_IndexGaz__c).toString();
			this.isIndexGaz = true;

		}

		return this.index_gaz;
	}

	//Affichage prédécesseur
	@api
	get predecesseur() {
		var pred;
		if (this._record.VI_NomPredecesseurRechercheLocal__c != undefined) {
			this.pred = 'Prédécesseur : ' + this._record.VI_NomPredecesseurRechercheLocal__c;
		}
		else {
			this.pred = 'Prédécesseur non renseigné';
		}

		return this.pred;
	}

	//Affichage appartement
	@api
	get appartement() {
		var appart;
		if (this._record.VI_NumeroAppartementRechercheLocal__c != undefined) {
			this.appart = ', appartement ' + this._record.VI_NumeroAppartementRechercheLocal__c;
		}
		else {
			this.appart = ' , appartement non renseigné';
		}

		return this.appart;
	}

	//Affichage porte gauche droite
	@api
	get porte() {
		var port;
		if (this._record.VI_DroiteGaucheRechercheLocal__c != undefined) {
			this.port = ', ' + this._record.VI_DroiteGaucheRechercheLocal__c;
		}
		else {
			this.port = ', porte non renseignée';
		}

		return this.port;
	}



	//Affichage matricule
	@api
	get matricule() {
		//DDPCM 345 Start
		var mat;
		this.mat = 'N° matricule : ';
		if (this._record.VI_ChoixEnergie__c === 'Electricité + Gaz') {
			this.mat += 'Elec ';
			if (this._record.VI_NumeroMatriculeRechercheLocal__c != undefined &&
				this._record.VI_NumeroMatriculeRechercheLocal__c !== '') {
				this.mat += this._record.VI_NumeroMatriculeRechercheLocal__c;
			}
			else {
				this.mat += 'non renseigné'
			}
			this.mat += ' / Gaz ';
			if (this._record.VI_NumeroMatriculeGAZRechercheLocal__c != undefined &&
				this._record.VI_NumeroMatriculeGAZRechercheLocal__c !== '') {
				this.mat += this._record.VI_NumeroMatriculeGAZRechercheLocal__c;
			}
			else {
				this.mat += 'non renseigné'
			}
		}
		else if (this._record.VI_ChoixEnergie__c === 'Electricité') {
			this.mat += 'Elec ';
			if (this._record.VI_NumeroMatriculeRechercheLocal__c != undefined &&
				this._record.VI_NumeroMatriculeRechercheLocal__c !== '') {
				this.mat += this._record.VI_NumeroMatriculeRechercheLocal__c;
			}
			else {
				this.mat += 'non renseigné'
			}
		}
		else if (this._record.VI_ChoixEnergie__c === 'Gaz') {
			this.mat += 'Gaz ';
			if (this._record.VI_NumeroMatriculeGAZRechercheLocal__c != undefined &&
				this._record.VI_NumeroMatriculeGAZRechercheLocal__c !== '') {
				this.mat += this._record.VI_NumeroMatriculeGAZRechercheLocal__c;
			}
			else {
				this.mat += 'non renseigné'
			}
		}
		return this.mat;
		//DDPCM 345 End
	}

	//Affichage etage
	@api
	get etage() {
		var etag;
		if (this._record.VI_NumeroEtageRechercheLocal__c != undefined) {
			this.etag = 'étage ' + (this._record.VI_NumeroEtageRechercheLocal__c).toString();
		}
		else {
			this.etag = 'étage non renseigné';
		}

		return this.etag;
	}

	@api
	get energies() {
		if (this._record.VI_ChoixEnergie__c == 'Gaz') {
			this.energie = 'Gaz';
		}
		else if (this._record.VI_ChoixEnergie__c == 'Electricité') {
			this.energie = 'Electricité';
		}
		else if (this._record.VI_ChoixEnergie__c == 'Electricité + Gaz') {
			this.energie = 'Electricité et Gaz naturel';
		}
		else {
			this.energie = 'Aucune energie sélectionnée'
		}
		return this.energie;
	}


/* ________________________________________________________________________________________________________________________________________________________ */
/* _________________________________________________________ HANDLE BUTTON FUNCTION _________________________________________________________________________ */
/* ________________________________________________________________________________________________________________________________________________________ */
		
	handleChangeToSave(event){
		if(event.target.name == undefined){
			var field = event.target.id;
		}else{
			var field = event.target.name;
		}
		this._recordupdated = true;
			/* Start DDPCM 1299*/
		if (field.includes('consentementEngieOui')) {
			this.isConsentementRGPD1Oui = true;
			this.isConsentementRGPD1Non = false;
			this._record.VI_ConsentProspectionEngieNonAnalogue__c = event.target.value;
		}
		else if (field.includes('consentementEngieNon')) {
			this.isConsentementRGPD1Non = true;
			this.isConsentementRGPD1Oui = false;
			this._record.VI_ConsentProspectionEngieNonAnalogue__c = event.target.value;
		}
		else if (field.includes('consentementPartnerOui')) {
			this.isConsentementRGPD2Oui = true;
			this.isConsentementRGPD2Non = false;
			this._record.VI_ConsentProspectionPartenaire__c = event.target.value;
		}
		else if (field.includes('consentementPartnerNon')) {
			this.isConsentementRGPD2Non = true;
			this.isConsentementRGPD2Oui = false;
			this._record.VI_ConsentProspectionPartenaire__c = event.target.value;
		}/* End DDPCM 1299*/
	}


	//sets the fields to null if they are empty
	handleUndefinedValues(recordField) {
		if (typeof this._record[recordField] === "undefined") {
			this._record[recordField] = null;
		}
	}

	//Naviguer vers les étapes à modifier
	handleNavigate() {
		this[NavigationMixin.Navigate]({
			type: "standard__component",
			attributes: {
				componentName: "c-parcours-pp-ident-besoin"
			},
			state: {
				c__propertyValue: '500'
			}
		});
	}

	handleFinParcours() {
		if (this.isCHF && this.statutCase == 'Signed') {
			this._title = 'Erreur';
			this.message = "Merci de ne pas modifier ce parcours";
			this.variant = 'error';
			this.showNotification();
		}
		else {
			this.loaded = false;
			console.log('############ tete : ')
			console.log(this._record.VI_ConsentProspectionPartenaire__c)
			console.log(this._record.VI_ConsentProspectionEngieNonAnalogue__c)
			envoieCpv
				(
					{
						parcours: this._record,
						numeroCase: this.numeroCase,
						coupleCodeValeurs: this.coupleCodeValeurs
					}
				).then(result => {
					this.loaded = true;
					if (result.message != null && result.message != undefined) {
						this._title = 'Erreur';
						this.message = result.message;
						this.variant = 'error';
						this.showNotification();
					}
					else {
						console.log('tesult parcours');
						console.log(result.parcours);
						this._record = result.parcours;
						//this._recordupdated=true;
						this.isShowPopUp = true;
						this.dispatchEvent(new CustomEvent('findeparcours', { detail: 'true' }));
						//ovrir le pop up de fin de parcours
						this.isBoutonARenvoyer = true;
						this.isBoutonCHF = false;
						this.isBoutonEM = false;

					}
				})
				.catch(error => {
					this.loaded = false;
					this._title = 'Erreur';
					this.message = error.body.message;
					this.variant = 'error';
					this.showNotification();
				});
		}
	}

	handleClose() {
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: HomePageRedirectLink
			}
		});
	}

	get showButton() {
		var sb;
		if (this._record.VI_ChoixParcours__c != 'EM' && this._record.VI_ChoixParcours__c != 'CHF') {
			this.sb = false;
		}
		return this.sb;
	}

	modifierSituation() {
		this.dispatchEvent(new CustomEvent('modifiersituation', { detail: 'situation' }));
	}

	modifierEnergie() {
		this.dispatchEvent(new CustomEvent('modifierenergie', { detail: 'energy' }));
	}
	modifierClient() {
		this.dispatchEvent(new CustomEvent('modifierclient', { detail: 'client_energy' }));
	}

	modifierLocal() {
		this.dispatchEvent(new CustomEvent('modifierlocal', { detail: 'identification_local' }));
	}

	modifierPanier() {
		this.dispatchEvent(new CustomEvent('modifierpanier', { detail: 'ConstitutionPanier' }));
	}

	modifierContrat() {
		this.dispatchEvent(new CustomEvent('modifiercontrat', { detail: 'DateEffetContrat' }));
	}

	modifierPaiement() {
		this.dispatchEvent(new CustomEvent('modifierpaiement', { detail: 'Saisie_moyen_de_paiement' }));
	}

	modifierBesoinCommentaire() {
		this.dispatchEvent(new CustomEvent('modifierbesoincommentaire', { detail: 'situation' }));
	}

	modifierClientCommentaire() {
		this.dispatchEvent(new CustomEvent('modifierclientcommentaire', { detail: 'client_energy' }));
	}

	modifierLocalCommentaire() {
		this.dispatchEvent(new CustomEvent('modifierlocalcommentaire', { detail: 'identification_local' }));
	}

	modifierEstimationCommentaire() {
		this.dispatchEvent(new CustomEvent('modifierestimationcommentaire', { detail: 'EstimationConsommation' }));
	}

	modifierPanierCommentaire() {
		this.dispatchEvent(new CustomEvent('modifierpaniercommentaire', { detail: 'ConstitutionPanier' }));
	}

	modifierContratCommentaire() {
		this.dispatchEvent(new CustomEvent('modifiercontratcommentaire', { detail: 'DateEffetContrat' }));
	}

	modifierPaiementCommentaire() {
		this.dispatchEvent(new CustomEvent('modifierpaiementcommentaire', { detail: 'Saisie_moyen_de_paiement' }));
	}

	modifierRecapCommentaire() {
		this.dispatchEvent(new CustomEvent('modifierrecapcommentaire', { detail: 'Recapitulatif' }));
	}

/* ________________________________________________________________________________________________________________________________________________________ */
/* _________________________________________________________ USEFULL FUNCTION _________________________________________________________________________ */
/* ________________________________________________________________________________________________________________________________________________________ */

	setLabels() {
		if (this.recorddonnee === undefined || this.recorddonnee === null) {
			console.log("in if");
		} else {
			for (let i = 0; i < this.recorddonnee.length; i++) {
				if (this.recorddonnee[i].Name === "Labels Parcours entier"
					&& this.recorddonnee[i].RecordType.Name === "Labels") {
					this.DonneesGDPR = this.recorddonnee[i].VI_DonneesGDPR__c;
				}
			}
		}
	}


	getCodePromo() {
		if (this._record.VI_CodePromotionnelPanierClient__c != null && this._record.VI_CodePromotionnelPanierClient__c != '') {
			this.hasCodePromo = true;
		}
	}

	showMessage() {

		if (this.isMessage === false) {
			this.isMessage = true;
			this.isOpen = true;
			this.imageRepliStyle = "transform: rotate(-90deg)";
			if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === "Offre de repli") {
				this.turnOffreRepliIntoGreen();
			} else if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === "Offre poussée") {
				this.turnOffrePrincIntoGreen();
			}

		} else {
			this.isMessage = false;
			this.isOpen = false;
			this.imageRepliStyle = "transform: rotate(90deg)";
		}
	}

	openEtapes() {
		if (this.openEtape === false) {
			this.openEtape = true;
		}
		else {
			this.openEtape = false;
		}
	}

	closeModal() {
		this.openEtape = false;
	}

	closePopUp() {
		this.isShowPopUp = false;
	}

	showNotification() {
		const evt = new ShowToastEvent({
			title: this._title,
			message: this.message,
			variant: this.variant,
		});
		this.dispatchEvent(evt);
	}
}