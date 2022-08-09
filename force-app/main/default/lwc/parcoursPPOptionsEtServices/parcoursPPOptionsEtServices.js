import { LightningElement, track, api } from 'lwc';
import getOptionsEtServicesParcours from '@salesforce/apex/VI_parcoursOptionsEtServices_Controller.getOptionsEtServices';
import getInfoSelectedContact from '@salesforce/apex/VI_parcoursOffre_Controller.getInfoSelectedContact';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ParcoursPPOptionsEtServices extends LightningElement {
    SmileyImage = EngieCommunityResource + '/EngieAssets/pictures/smileyVert.png';
    giftImage = EngieCommunityResource + '/EngieAssets/pictures/3-offre--mensualites-fill-1-D2CB8F43-C3F3-4F66-BF92-F14EA9046E63@2x.png';
    optionDropImage = EngieCommunityResource + '/EngieAssets/pictures/fleche-droite.png';
    greydeleteImage = EngieCommunityResource + '/EngieAssets/pictures/grey-delete-button.png';

    @api recorddonnee;

    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';

    optionsEtServicesObject;

    loaded = false;

    checkBoxOption = false;
    optionLabel = "";
    optionValue = 0;
    optionValueHT = 0;
    optionCode = "";
    isOptionElecNotNull = true;

    priceOffreSelected = 0;
    valueifOptionSelected = 0;
    valueifOptionGazSelected = 0;

    nomClient = '';
    prenomClient = '';
    madameChoisi = false;
    monsieurChoisi = false;
    coTitulaireChoisi = false;
    isArretNon = false;
    isArretOui = false;
    isInvaliditeNon = false;
    isInvaliditeOui = false;

    checkBoxOptionGaz = false;
    optionGazLabel = "";
    optionGazValue = 0;
    optionGazValueHT = 0;
    optionGazCode = "";
    isOptionGazNotNull = true;

    Description_Option_Gaz_Vert = "";
    Description_Option_Elec_v = "";
    Description_Option_Gaz_Vert_2 = "";
    Description_Option_Elec_Vert_2 = "";
    VI_DescriptionAssuranceFacture1 = "";
    VI_DescriptionAssuranceFacture2 = "";

    optionPriceNotZero = true;
    optionPriceGazNotZero = true;


    boxOptionGazColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
    boxOptionElecColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
    boxAFColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";

    assuranceFactureChecked = false;
    assuranceLabel = "Assurance Facture";
    valueifAssuranceFactureSelected = 0;
    redLabelArretTravail = false;
    redLabelRenteInvalidite = false;
    redLabelCSP = false;
    redLabelBirthDate = false;
    redLabelAFIncomplet = false;
    redLabelAFImpossible = false;
    redLabelAFBirthdayInaccepte = false;
    redLabelAFArretEtRenteInaccepte = false;

    /* Start DDPCM 1192 */

    isShowCodePromo = false;
    isCodePromoSelected = false;
    isCodePromo1Applied = false;
    isCodePromo2Applied = false;

    isOffreSelected = false;

    @track
    promoList;

    @track selectedPromoList = {
        NumPromotion: "",
        CodePromo: "",
        LibelleSurFacture: "",
        NomPromotion: "",
        DescriptifPromotion: "",
        DebutValidity: "",
        FinValidity: "",
        CanalDeVente: ""
    };

    divPromoStyle = "position: relative;margin-top: 200px;margin-left: -11%;";
    /* Ens DDPCM 1192 */

    @api
    get record() {
        return this._record;
    }
    set record(value) {
        if (value) {
            this._record = { ...value };
            var tableForUndefinedValues = ['VI_ChoixOffreSurParcoursPanierClient__c','VI_CodePromotionnelPanierClient__c','VI_LibelleOptionPanierClient__c','VI_MontantOptionPanierClient__c',
        'VI_MontantdelaMensualitePanierClient__c','VI_CodeOptionPanierClient__c','VI_CodeOptionGazPanierClient__c','VI_LibelleOffrePanierClient__c','VI_ServiceOptionVerteElecPrixAbHT__c',
        'VI_ServiceOptionVerteElecPrixAbTTC__c','VI_ServiceOptionVerteGazPrixAbHT__c','VI_LibelleOptionGazPanierClient__c','VI_ServiceOptionVerteGazPrixAbTTC__c','VI_FinValidity__c',
        'VI_DebutValidity__c','VI_CanalDeVente__c','VI_DescriptifPromotion__c','VI_NomPromotion__c','VI_LibelleSurFacture__c','VI_CodePromo__c','VI_NumPromotion__c',
        'VI_FinValidity2__c','VI_DebutValidity2__c','VI_CanalDeVente2__c','VI_DescriptifPromotion2__c','VI_NomPromotion2__c','VI_LibelleSurFacture2__c','VI_CodePromo2__c',
        'VI_NumPromotion2__c','VI_CodePromoApplied__c','VI_CodePromoApplied2__c','VI_ParcoursDeSouscriptionAF__c','VI_CiviliteAF__c','VI_NomAF__c','VI_PrenomAF__c',
        'VI_DateDeNaissanceAF__c','VI_CategorieSocioprofessionnelleAF__c','VI_ArretDeTravailPourRaisonDeSanteAF__c','VI_RenteInvaliditeAF__c','VI_ModeDePaiementAF__c',
        'VI_AssuranceFactureCocheeAF__c','VI_AF_Enregistre__c','VI_CodePostalNaissanceAF__c','VI_PaysNaissanceAF__c','VI_VilleNaissanceAF__c'];

            this.handleUndefinedValuesGlobal(tableForUndefinedValues);

            if (this._record.VI_AssuranceFactureCocheeAF__c === true) {
                this.assuranceFactureChecked = true;
            }
            if (this._record.VI_ParcoursDeSouscriptionAF__c === null || this._record.VI_ParcoursDeSouscriptionAF__c === "") {
                this._record.VI_ParcoursDeSouscriptionAF__c = 'Email';
            }
            if (this._record.VI_CiviliteAF__c === 'Madame') {
                this._record.VI_CiviliteAF__c = 'Madame';
                this.madameChoisi = true;
                this.monsieurChoisi = false;
                this.coTitulaireChoisi = false;
            }
            else if (this._record.VI_CiviliteAF__c === 'Monsieur') {
                this._record.VI_CiviliteAF__c = 'Monsieur';
                this.madameChoisi = false;
                this.monsieurChoisi = true;
                this.coTitulaireChoisi = false;
            }
            else if (this._record.VI_CiviliteAF__c === 'Co-titulaire') {
                this.madameChoisi = false;
                this.monsieurChoisi = false;
                this.coTitulaireChoisi = true;
            }
            if (this._record.VI_NomAF__c === null || this._record.VI_NomAF__c === undefined) {
                this._record.VI_NomAF__c = "";
            }
            if (this._record.VI_PrenomAF__c === null || this._record.VI_PrenomAF__c === undefined) {
                this._record.VI_PrenomAF__c = "";
            }
            if (this._record.VI_DateDeNaissanceAF__c === null || this._record.VI_DateDeNaissanceAF__c === undefined) {
                this._record.VI_DateDeNaissanceAF__c = "";
            }
            if (this._record.VI_CategorieSocioprofessionnelleAF__c === null
                || this._record.VI_CategorieSocioprofessionnelleAF__c === undefined) {
                this._record.VI_CategorieSocioprofessionnelleAF__c = "";
            }
            if (this._record.VI_ArretDeTravailPourRaisonDeSanteAF__c === "Non") {
                this.isArretOui = false;
                this.isArretNon = true;
            }
            if (this._record.VI_ArretDeTravailPourRaisonDeSanteAF__c === "Oui") {
                this.isArretOui = true;
                this.isArretNon = false;
            }
            if (this._record.VI_RenteInvaliditeAF__c === "Non") {
                this.isInvaliditeOui = false;
                this.isInvaliditeNon = true;
            }
            if (this._record.VI_RenteInvaliditeAF__c === "Oui") {
                this.isInvaliditeOui = true;
                this.isInvaliditeNon = false;
            }
            if (this._record.VI_ModeDePaiementAF__c === null) {
                this._record.VI_ModeDePaiementAF__c = true;
            }
            if (this._record.VI_AF_Enregistre__c === true) {
                this.boxAFColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: rgb(0,153,52);border-width: 2.5px;";
            }
            // End Assurance Facture

            if (this._record.VI_CodePromotionnelPanierClient__c === null
                || this._record.VI_CodePromotionnelPanierClient__c === undefined) {
                this._record.VI_CodePromotionnelPanierClient__c = "";
            }

            if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === 'Offre poussée' || this._record.VI_ChoixOffreSurParcoursPanierClient__c === 'Offre de repli') {
                this.isOffreSelected = true;
                this.nameOffreSelected = this._record.VI_LibelleOffrePanierClient__c;
                this.priceOffreSelected = Number(this._record.VI_MontantdelaMensualitePanierClient__c);
            }
            /* Start DDPCM 1192 */
            if (this.isOffreSelected === true) {
                console.log('showCodePromo ' + this.isShowCodePromo);
                this.isShowCodePromo = true;
                console.log('showCodePromo ' + this.isShowCodePromo);
            }

            /* End DDPCM 1192 */

            console.log("### _record : ");
            console.log(this._record);
        } else {
            this._record = {};
        }
    }

    //sets the fields to null if they are empty
    handleUndefinedValuesGlobal(recordField) {
        for(var i = 0; i < recordField.length; i++){
            if (typeof this._record[recordField[i]] === "undefined") {
                this._record[recordField[i]] = null;
            }
        }
    }   

    setLabels() {
        console.log("### recorddonnee")
        console.log(this.recorddonnee)
        for (var i = 0; i < this.recorddonnee.length; i++) {
            if (this.recorddonnee[i].Name === "Labels Parcours entier"
                && this.recorddonnee[i].RecordType.Name === "Labels") {
                this.Description_Option_Gaz_Vert = this.recorddonnee[i].Description_Option_Gaz_Vert__c;
                this.Description_Option_Elec_v = this.recorddonnee[i].VI_Description_Option_Elec_v__c;
                this.Description_Option_Gaz_Vert_2 = this.recorddonnee[i].Description_Option_Gaz_Vert_2__c;
                this.Description_Option_Elec_Vert_2 = this.recorddonnee[i].Description_Option_Elec_Vert_2__c;
                this.VI_DescriptionAssuranceFacture1 = this.recorddonnee[i].VI_DescriptionAssuranceFacture1__c;
                this.VI_DescriptionAssuranceFacture2 = this.recorddonnee[i].VI_DescriptionAssuranceFacture2__c;
            }
        }
    }

    @api
    get recordupdated() {
        return this._recordupdated;
    }
    set recordupdated(value) {
        this._recordupdated = value;
    }

    connectedCallback() {
        this.setLabels();
        getInfoSelectedContact
            (
                {
                    parcours: this._record
                }
            ).then(result => {
                this.client = result;
                this._record.VI_NomAF__c = this.client.LastName;
                this.nomClient = this._record.VI_NomAF__c;
                this._record.VI_PrenomAF__c = this.client.FirstName;
                this.prenomClient = this._record.VI_PrenomAF__c;
                if (this.client.Salutation === 'MME' || this.client.Salutation === 'MLLE' || this.client.Salutation === 'MLLES' || this.client.Salutation === 'MMES' || this.client.Salutation === 'Madame') {
                    this._record.VI_CiviliteAF__c = 'Madame';
                    this.madameChoisi = true;
                    this.monsieurChoisi = false;
                    this.coTitulaireChoisi = false;
                }
                else if (this.client.Salutation === 'MR' || this.client.Salutation === 'MRS' || this.client.Salutation === 'Monsieur') {
                    this._record.VI_CiviliteAF__c = 'Monsieur';
                    this.madameChoisi = false;
                    this.monsieurChoisi = true;
                    this.coTitulaireChoisi = false;
                }
                this.recupererOptionsEtServices();
            })
            .catch(error => {
                console.log(error);
                this.error = error;
            });

        // END Assurance Facture
    }


    recupererOptionsEtServices() {
        getOptionsEtServicesParcours
            ({
                parcours: this._record
            }).then(result => {
                console.log('getOptionsEtServicesParcours success');
                console.log(result);
                this.optionsEtServicesObject = result;
                console.log("result : ");
                console.log(this.optionsEtServicesObject);
                this.setOptionsValue();
                this.checkIfOptionsAlreadySelected();
                if (this.isOffreSelected === true &&
                    this.optionsEtServicesObject.promotions &&
                    this.optionsEtServicesObject.promotions.length > 0) {
                    this.isShowCodePromo = true;
                    this.promotions_Offre_Choisi = this.optionsEtServicesObject.promotions;
                }
                if (this._record.VI_CodePromoApplied__c) {
                    this.isCodePromo1Applied = true;
                }
                if (this._record.VI_CodePromoApplied2__c) {
                    this.isCodePromo2Applied = true;
                }
                this.calculFinalRecap();
                this.loaded = true;
            })
            .catch(error => {
                console.log("error" + error);
                console.log(error.body);
                this._title = 'Erreur';
                this.message = error.body.message;
                this.variant = 'error';
                this.showNotification()
                console.log(error.body.message);
            });
    }

    setOptionsValue() {
        if (this.optionsEtServicesObject.optionCodeElec !== undefined) {
            this.optionLabel = this.optionsEtServicesObject.optionLabelElec;
            this.optionCode = this.optionsEtServicesObject.optionCodeElec;
            if (this.optionsEtServicesObject.optionValueElec === 0) {
                this.optionPriceNotZero = false;
            } else {
                this.optionValue = this.optionsEtServicesObject.optionValueElec;
            }
            if (this.optionsEtServicesObject.optionValueElec === undefined) {
                this.optionPriceNotZero = false;
            } else {
                this.optionValue = this.optionsEtServicesObject.optionValueElec;
            }
        } else {
            if (this.optionsEtServicesObject.optionCodeGaz === undefined) {
                this.isOptionNotNull = false;
            }
            this.isOptionElecNotNull = false;
            this.divPromoStyle = "position: relative;margin-top: 170px;margin-left: -11%;";
        }

        if (this.optionsEtServicesObject.optionCodeGaz !== undefined) {
            this.optionGazLabel = this.optionsEtServicesObject.optionLabelGaz;
            this.optionGazCode = this.optionsEtServicesObject.optionCodeGaz;
            if (this.optionsEtServicesObject.optionValueGaz === 0) {
                this.optionPriceGazNotZero = false;
            } else {
                this.optionGazValue = this.optionsEtServicesObject.optionValueGaz;
            }
            if (this.optionsEtServicesObject.optionValueGaz === undefined) {
                this.optionPriceGazNotZero = false;
            } else {
                this.optionGazValue = this.optionsEtServicesObject.optionValueGaz;
            }
        } else {
            if (this.optionsEtServicesObject.optionCodeElec === undefined) {
                this.isOptionNotNull = false;
            }
            this.isOptionGazNotNull = false;
            this.divPromoStyle = "position: relative;margin-top: 170px;margin-left: -11%;";
        }
    }

    handleOptionCheck() {
        console.log("this.checkBoxOption " + this.checkBoxOption);
        this.checkBoxOption = this.template.querySelector('[data-id="checkboxOptionId"]').checked;
        console.log("this.checkBoxOption2 " + this.checkBoxOption);
        if (this.checkBoxOption) {
            this.valueifOptionSelected = this.optionValue;
            this.isOptionSelected = true;
            this._record.VI_LibelleOptionPanierClient__c = this.optionLabel;
            this._record.VI_CodeOptionPanierClient__c = this.optionCode;
            this._record.VI_ServiceOptionVerteElecPrixAbHT__c = this.optionsEtServicesObject.optionValueElecHT.toString().replace(".", ",");
            this._record.VI_ServiceOptionVerteElecPrixAbTTC__c = this.optionValue.toString().replace(".", ",");
            this.boxOptionElecColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: rgb(0,153,52);border-width: 2.5px;";

        } else {
            this.valueifOptionSelected = 0;
            this.isOptionSelected = false;

            this._record.VI_LibelleOptionPanierClient__c = null;
            this._record.VI_CodeOptionPanierClient__c = null;
            this._record.VI_ServiceOptionVerteElecPrixAbHT__c = 0;
            this._record.VI_ServiceOptionVerteElecPrixAbTTC__c = 0;
            this.boxOptionElecColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
        }
        this.calculFinalRecap();
        this._recordupdated = true;
    }

    handleOptionGazCheck() {
        this.checkBoxOptionGaz = this.template.querySelector('[data-id="checkboxOptionGazId"]').checked;

        if (this.checkBoxOptionGaz) {
            this.valueifOptionGazSelected = this.optionGazValue;
            this.isOptionGazSelected = true;

            this._record.VI_LibelleOptionGazPanierClient__c = this.optionGazLabel;
            this._record.VI_CodeOptionGazPanierClient__c = this.optionGazCode;
            this._record.VI_ServiceOptionVerteGazPrixAbHT__c = this.optionsEtServicesObject.optionValueGazHT.toString().replace(".", ",");
            this._record.VI_ServiceOptionVerteGazPrixAbTTC__c = this.optionGazValue.toString().replace(".", ",");
            this.boxOptionGazColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: rgb(0,153,52);border-width: 2.5px;";
        } else {
            this.valueifOptionGazSelected = 0;
            this.isOptionGazSelected = false;

            this._record.VI_LibelleOptionGazPanierClient__c = null;
            this._record.VI_CodeOptionGazPanierClient__c = null;
            this._record.VI_ServiceOptionVerteGazPrixAbHT__c = 0;
            this._record.VI_ServiceOptionVerteGazPrixAbTTC__c = 0;
            this.boxOptionGazColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
        }
        this.calculFinalRecap();
        this._recordupdated = true;
    }

    handlecheckBoxOptionAF() {
        this.assuranceFactureChecked = this.template.querySelector('[data-id="checkboxOptionAFId"]').checked;
        if (this.assuranceFactureChecked === true) {
            this._record.VI_AssuranceFactureCocheeAF__c = true;
            this._record.VI_PrixAssuranceFacture__c = this.optionsEtServicesObject.AssuranceFacturePrixTTC;
            this.valueifAssuranceFactureSelected = this.optionsEtServicesObject.AssuranceFacturePrixTTC;
            const dispatchEventSearch = new CustomEvent('serviceoptionsafencours', {
                detail: {
                    record: this._record
                }
            });
            this.dispatchEvent(dispatchEventSearch);
        }
        else {
            this._record.VI_AssuranceFactureCocheeAF__c = false;
            this._record.VI_AF_Enregistre__c = false;
            this._record.VI_PrixAssuranceFacture__c = null;
            this.valueifAssuranceFactureSelected = 0;
            this.boxAFColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
            const dispatchEventSearch = new CustomEvent('serviceoptionsafterminee', {
                detail: {
                    record: this._record
                }
            });
            this.dispatchEvent(dispatchEventSearch);
        }
        this.checkBoxOptionAF = this.template.querySelector('[data-id="checkboxOptionAFId"]').checked;
        this.calculFinalRecap();
    }

    handleAF(event) {
        this._recordupdated = true;
        this._record.VI_AF_Enregistre__c = false;
        let field = event.target.name;
        if (field === 'parcoursDeSouscription') {
            this._record.VI_ParcoursDeSouscriptionAF__c = event.target.value;
        }
        if (field === 'DateNaissance') {
            this._record.VI_DateDeNaissanceAF__c = event.target.value;
        }
        if (field === 'CatégorieSocioprofessionnelle') {
            this._record.VI_CategorieSocioprofessionnelleAF__c = event.target.value;
        }
        if (field === 'arretTravail') {
            if (event.target.value === 'Oui') {
                this._record.VI_ArretDeTravailPourRaisonDeSanteAF__c = event.target.value;
                this.isArretOui = true;
                this.isArretNon = false;
            }
            else if (event.target.value === 'Non') {
                this._record.VI_ArretDeTravailPourRaisonDeSanteAF__c = event.target.value;
                this.isArretOui = false;
                this.isArretNon = true;
            }
        }
        if (field === 'invalidité') {
            if (event.target.value === 'Oui') {
                this._record.VI_RenteInvaliditeAF__c = event.target.value;
                this.isInvaliditeOui = true;
                this.isInvaliditeNon = false;
            }
            else if (event.target.value === 'Non') {
                this._record.VI_RenteInvaliditeAF__c = event.target.value;
                this.isInvaliditeOui = false;
                this.isInvaliditeNon = true;
            }
        }

        if (field === 'VilleID') {
            this._record.VI_VilleNaissanceAF__c = event.target.value;
        }

        if (field === 'PaysID') {
            if(event.target.value.toLowerCase() != "france"){
                this.template.querySelector('input[data-id=CodePostalID]').value = 0;
                this._record.VI_CodePostalNaissanceAF__c = '0';
            }
            this._record.VI_PaysNaissanceAF__c = event.target.value;
        }

        if (field === 'CodePostalID') {
            this._record.VI_CodePostalNaissanceAF__c = event.target.value;
        }

        const dispatchEventSearch = new CustomEvent('onserviceoptionsafencours', {
            detail: {
                record: this._record
            }
        });
        this.dispatchEvent(dispatchEventSearch);
    }
    handleBirthDadeValidation() {
        if (this._record.VI_DateDeNaissanceAF__c && this._record.VI_DateDeNaissanceAF__c != null &&
            this._record.VI_DateDeNaissanceAF__c != undefined && this._record.VI_DateDeNaissanceAF__c != "") {
            var today = new Date();
            var todayMinus18Years = today.getYear() - 18;
            var todayMinus85Years = today.getYear() - 85;
            var birthdayYear = this._record.VI_DateDeNaissanceAF__c.toString();
            birthdayYear = birthdayYear.slice(0, 4);
            var birthdayYearNumber = Number(birthdayYear) - 1900;
            if (todayMinus85Years <= birthdayYearNumber &&
                todayMinus18Years >= birthdayYearNumber) {
                this.redLabelBirthDate = false;
                this.redLabelAFBirthdayInaccepte = false;
            }
        }
        else {
            this.redLabelBirthDate = true;
            this.redLabelAFBirthdayInaccepte = false;
        }

    }

    handleEnregistrer() {
        this.redLabelCSP = true;
        this.redLabelBirthDate = true;
        this.redLabelArretTravail = true;
        this.redLabelRenteInvalidite = true;
        this.redLabelAFIncomplet = true;
        this.redLabelAFBirthdayInaccepte = true;
        this.redLabelAFArretEtRenteInaccepte = true;
        this.handleBirthDadeValidation();

        if (this._record.VI_CategorieSocioprofessionnelleAF__c != null &&
            this._record.VI_CategorieSocioprofessionnelleAF__c != undefined &&
            this._record.VI_CategorieSocioprofessionnelleAF__c != '') {
            this.redLabelCSP = false;
        }
        if (this._record.VI_ArretDeTravailPourRaisonDeSanteAF__c === "Non") {
            this.redLabelArretTravail = false;
        }
        if (this._record.VI_RenteInvaliditeAF__c === "Non") {
            this.redLabelRenteInvalidite = false;
        }
        if ((this.redLabelArretTravail === false &&
            this.redLabelRenteInvalidite === false) ||
            (this.isArretOui != true && this.isArretNon != true) || (this.isInvaliditeOui != true && this.isInvaliditeNon != true)) {
            this.redLabelAFArretEtRenteInaccepte = false;
        }
        if ((this.isArretOui === true || this.isArretNon === true) && (this.isInvaliditeOui === true || this.isInvaliditeNon === true) &&
            (this._record.VI_DateDeNaissanceAF__c && this._record.VI_DateDeNaissanceAF__c != null &&
                this._record.VI_DateDeNaissanceAF__c != undefined && this._record.VI_DateDeNaissanceAF__c != "") && this.redLabelCSP === false) {
            this.redLabelAFIncomplet = false;
        }
        if (this.redLabelAFIncomplet === true && (this.isArretOui != true && this.isArretNon != true) && (this.isInvaliditeOui != true && this.isInvaliditeNon != true)) {
            this.redLabelAFArretEtRenteInaccepte = false;
        }
        if (this.redLabelAFArretEtRenteInaccepte === true || this.redLabelAFBirthdayInaccepte === true) {
            this.redLabelAFImpossible = true;
        }
        else {
            this.redLabelAFImpossible = false;
        }
        if (this._record.VI_AssuranceFactureCocheeAF__c === true && this.redLabelAFIncomplet === false
            && this.redLabelAFArretEtRenteInaccepte === false && this.redLabelAFBirthdayInaccepte === false) {
            this._record.VI_AF_Enregistre__c = true;
            this.calculFinalRecap();
            this._recordupdated = true;
            const dispatchEventSearch = new CustomEvent('serviceoptionsafterminee', {
                detail: {
                    record: this._record
                }
            });
            this.dispatchEvent(dispatchEventSearch);
            this.boxAFColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: rgb(0,153,52);border-width: 2.5px;";
        }
    }

    checkIfOptionsAlreadySelected() {
        if (this.optionsEtServicesObject.promotions &&
            this.optionsEtServicesObject.promotions.length > 0) {
            this.promotions_Offre_Choisi = this.optionsEtServicesObject.promotions;
        }
        this.isShowCodePromo = true;


        if (this._record.VI_CodeOptionPanierClient__c === null
            || this._record.VI_CodeOptionPanierClient__c === undefined
            || this._record.VI_CodeOptionPanierClient__c === "") {
            this.checkBoxOption = false;
            this.valueifOptionSelected = 0;
            this.isOptionSelected = false;
            this.boxOptionElecColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
        } else {
            this.checkBoxOption = true;
            this.valueifOptionSelected = this.optionValue;
            this.isOptionSelected = true;
            this.boxOptionElecColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: rgb(0,153,52);border-width: 2.5px;";

        }

        // Start Assurance Facture
        if (this._record.VI_PrixAssuranceFacture__c === null
            || this._record.VI_PrixAssuranceFacture__c === undefined
            || this._record.VI_PrixAssuranceFacture__c === ""
            || this._record.VI_PrixAssuranceFacture__c === 0) {
            this.valueifAssuranceFactureSelected = 0;
        } else {
            this.valueifAssuranceFactureSelected = this.optionsEtServicesObject.AssuranceFacturePrixTTC;
        }
        // Start Assurance Facture

        if (this._record.VI_CodeOptionGazPanierClient__c === null
            || this._record.VI_CodeOptionGazPanierClient__c === undefined
            || this._record.VI_CodeOptionGazPanierClient__c === "") {
            this.checkBoxOptionGaz = false;
            this.valueifOptionGazSelected = 0;
            this.isOptionGazSelected = false;
            this.boxOptionGazColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
        } else {
            this.checkBoxOptionGaz = true;
            this.valueifOptionGazSelected = this.optionGazValue;
            this.isOptionGazSelected = true;
            this.boxOptionGazColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: rgb(0,153,52);border-width: 2.5px;";
        }
    }

    /* Start DDPCM 1192 */

    handleChoixPromo(event) {
        this.isCodePromoSelected = true;
        var selectedPromo = event.currentTarget.dataset;
        this.selectedPromoList.CanalDeVente = selectedPromo.canaldevente;
        this.selectedPromoList.CodePromo = selectedPromo.codepromo;
        this.selectedPromoList.DebutValidity = selectedPromo.debutvalidity;
        this.selectedPromoList.DescriptifPromotion = selectedPromo.descriptifpromotion;
        this.selectedPromoList.FinValidity = selectedPromo.finvalidity;
        this.selectedPromoList.LibelleSurFacture = selectedPromo.libellesurfacture;
        this.selectedPromoList.NomPromotion = selectedPromo.nompromotion;
        this.selectedPromoList.NumPromotion = selectedPromo.numpromotion;
    }

    handleAppliquerPromo() {
        if (this.isCodePromoSelected) {

            if (this._record.VI_CodePromoApplied__c === false) {
                this._recordupdated = true;
                this._record.VI_FinValidity__c = this.selectedPromoList.FinValidity;
                this._record.VI_DebutValidity__c = this.selectedPromoList.DebutValidity;
                this._record.VI_CanalDeVente__c = this.selectedPromoList.CanalDeVente;
                this._record.VI_DescriptifPromotion__c = this.selectedPromoList.DescriptifPromotion;
                this._record.VI_NomPromotion__c = this.selectedPromoList.NomPromotion;
                this._record.VI_LibelleSurFacture__c = this.selectedPromoList.LibelleSurFacture;
                this._record.VI_CodePromo__c = this.selectedPromoList.CodePromo;
                this._record.VI_NumPromotion__c = this.selectedPromoList.NumPromotion;
                this._record.VI_CodePromoApplied__c = true;
                this.isCodePromo1Applied = true;
            }
            else if (this._record.VI_CodePromoApplied2__c === false) {
                this._recordupdated = true;
                this._record.VI_FinValidity2__c = this.selectedPromoList.FinValidity;
                this._record.VI_DebutValidity2__c = this.selectedPromoList.DebutValidity;
                this._record.VI_CanalDeVente2__c = this.selectedPromoList.CanalDeVente;
                this._record.VI_DescriptifPromotion2__c = this.selectedPromoList.DescriptifPromotion;
                this._record.VI_NomPromotion2__c = this.selectedPromoList.NomPromotion;
                this._record.VI_LibelleSurFacture2__c = this.selectedPromoList.LibelleSurFacture;
                this._record.VI_CodePromo2__c = this.selectedPromoList.CodePromo;
                this._record.VI_NumPromotion2__c = this.selectedPromoList.NumPromotion;
                this._record.VI_CodePromoApplied2__c = true;
                this.isCodePromo2Applied = true;
            }
            else {
                this._title = 'Erreur';
                this.message = "Vous ne pouvez pas sélectionner plus de 2 codes promos.";
                this.variant = 'error';
                this.showNotification();
            }
            this.isCodePromoSelected = false;
            this.selectedPromoList.CanalDeVente = '';
            this.selectedPromoList.CodePromo = '';
            this.selectedPromoList.DebutValidity = '';
            this.selectedPromoList.DescriptifPromotion = '';
            this.selectedPromoList.FinValidity = '';
            this.selectedPromoList.LibelleSurFacture = '';
            this.selectedPromoList.NomPromotion = '';
            this.selectedPromoList.NumPromotion = '';
        }
    }

    handleDeletePromo1() {
        this._recordupdated = true;
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
    }

    handleDeletePromo2() {
        this._recordupdated = true;
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

    calculFinalRecap() {
        this.finalCalculValue = parseFloat(this.valueifOptionSelected) +
            parseFloat(this.priceOffreSelected) +
            parseFloat(this.valueifOptionGazSelected) +
            parseFloat(this.valueifAssuranceFactureSelected);
    }


    handleSuivant() {
        const dispatchEventSearch = new CustomEvent('suivant');
        this.dispatchEvent(dispatchEventSearch);
    }

    handlePrecedent() {
        console.log('in precedent');
        const dispatchEventSearch = new CustomEvent('precedent');
        this.dispatchEvent(dispatchEventSearch);
        console.log('after precedent')
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