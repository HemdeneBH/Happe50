import { LightningElement, api, track } from 'lwc';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import getOffersOctopusParcours from '@salesforce/apex/VI_parcoursOffre_Controller.getOffersOctopusParcours';
import getInfoSelectedContact from '@salesforce/apex/VI_parcoursOffre_Controller.getInfoSelectedContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ParcoursPPConstitutionPanier extends LightningElement {


    // Start Assurance Facture 
    assuranceFactureChecked = false;

    @track nomClient = '';
    @track prenomClient = '';
    @track madameChoisi = false;
    @track monsieurChoisi = false;
    @track coTitulaireChoisi = false;
    isArretNon = false;
    isArretOui = false;
    isInvaliditeNon = false;
    isInvaliditeOui = false;
    @track boxAFColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
    // END Assurance Facture 

    /* Start DDPCM 1192 */

    isShowCodePromo = false;
    isCodePromoSelected = false;
    isCodePromo1Applied = false;
    isCodePromo2Applied = false;

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
    /* Ens DDPCM 1192 */

    //DDPCM-443 START
    @track boxOptionGazColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
    @track boxOptionElecColor = "height: 113%;border-radius: 16px;border-style: solid;border-color: var(--cerulean);border-width: 2.5px;";
    //DDPCM-443 END

    /* Start DDPCM - 1126 Autres Canaux */
    isAutresCanaux = false;
    /* End DDPCM - 1126 Autres Canaux */

    @api
    get record() {
        return this._record;
    }
    set record(value) {
        if (value) {
            this._record = { ...value };
            this.handleUndefinedValues('VI_ChoixOffreSurParcoursPanierClient__c');
            this.handleUndefinedValues('VI_AjustementMensualitesPanierClient__c');
            this.handleUndefinedValues('VI_MontantdelaMensualitePanierClient__c');
            this.handleUndefinedValues('VI_EleckWhHTPanierClient__c');
            this.handleUndefinedValues('VI_EleckWhTTCPanierClient__c');
            this.handleUndefinedValues('VI_EleckWhHTHCPanierClient__c');
            this.handleUndefinedValues('VI_EleckWhTTCHCPanierClient__c');
            this.handleUndefinedValues('VI_GazkWhHTPanierClient__c');
            this.handleUndefinedValues('VI_GazkWhTTCPanierClient__c');
            this.handleUndefinedValues('VI_AbonnementAnnuelGazHTPanierClient__c');
            this.handleUndefinedValues('VI_AbonnementAnnuelGazTTCPanierClient__c');
            this.handleUndefinedValues('VI_AbonnementAnnuelElecHTPanierClient__c');
            this.handleUndefinedValues('VI_AbonnementAnnuelElecTTCPanierClient__c');
            this.handleUndefinedValues('VI_CodePromotionnelPanierClient__c');
            this.handleUndefinedValues('VI_LibelleOptionPanierClient__c');
            this.handleUndefinedValues('VI_MontantOptionPanierClient__c');
            this.handleUndefinedValues('VI_CodeOptionPanierClient__c');
            this.handleUndefinedValues('VI_CodeOptionGazPanierClient__c');
            this.handleUndefinedValues('VI_OffreChoisieElecPanierClient__c');
            this.handleUndefinedValues('VI_OffreChoisieGazPanierClient__c');
            this.handleUndefinedValues('VI_LibelleOffrePanierClient__c');
            this.handleUndefinedValues('VI_ServiceOptionVerteElecPrixAbHT__c');
            this.handleUndefinedValues('VI_ServiceOptionVerteElecPrixAbTTC__c');
            this.handleUndefinedValues('VI_ServiceOptionVerteGazPrixAbHT__c');
            this.handleUndefinedValues('VI_LibelleOptionGazPanierClient__c');
            this.handleUndefinedValues('VI_ServiceOptionVerteGazPrixAbTTC__c');
            /* Start DDPCM - 1192 */
            this.handleUndefinedValues('VI_FinValidity__c');
            this.handleUndefinedValues('VI_DebutValidity__c');
            this.handleUndefinedValues('VI_CanalDeVente__c');
            this.handleUndefinedValues('VI_DescriptifPromotion__c');
            this.handleUndefinedValues('VI_NomPromotion__c');
            this.handleUndefinedValues('VI_LibelleSurFacture__c');
            this.handleUndefinedValues('VI_CodePromo__c');
            this.handleUndefinedValues('VI_NumPromotion__c');
            this.handleUndefinedValues('VI_FinValidity2__c');
            this.handleUndefinedValues('VI_DebutValidity2__c');
            this.handleUndefinedValues('VI_CanalDeVente2__c');
            this.handleUndefinedValues('VI_DescriptifPromotion2__c');
            this.handleUndefinedValues('VI_NomPromotion2__c');
            this.handleUndefinedValues('VI_LibelleSurFacture2__c');
            this.handleUndefinedValues('VI_CodePromo2__c');
            this.handleUndefinedValues('VI_NumPromotion2__c');
            this.handleUndefinedValues('VI_CodePromoApplied__c');
            this.handleUndefinedValues('VI_CodePromoApplied2__c');
            /* End DDPCM - 1192 */
            /* Start DDPCM - 1126 Autres Canaux */
            if (this._record.VI_TypeParcours__c != 'PURE PLAYERS') {
                this.isAutresCanaux = true;
            }
            else {
                this.isAutresCanaux = false;
            }
            /* End DDPCM - 1126 Autres Canaux */
            // Start Assurance Facture
            this.handleUndefinedValues('VI_ParcoursDeSouscriptionAF__c');
            this.handleUndefinedValues('VI_CiviliteAF__c');
            this.handleUndefinedValues('VI_NomAF__c');
            this.handleUndefinedValues('VI_PrenomAF__c');
            this.handleUndefinedValues('VI_DateDeNaissanceAF__c');
            this.handleUndefinedValues('VI_CategorieSocioprofessionnelleAF__c');
            this.handleUndefinedValues('VI_ArretDeTravailPourRaisonDeSanteAF__c');
            this.handleUndefinedValues('VI_RenteInvaliditeAF__c');
            this.handleUndefinedValues('VI_ModeDePaiementAF__c');
            this.handleUndefinedValues('VI_AF_Enregistre__c');

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
            if (this._record.VI_SaisieEstimationConsoElec_HP_HC__c === "Oui" || this._record.VI_SaisieConsommationElec_HP_HC__c === true) {
                this.isHPHC = true;
            }

            console.log("### _record : ");
            console.log(this._record);
        } else {
            this._record = {};
        }
    }

    @api
    get recordupdated() {
        return this._recordupdated;
    }
    set recordupdated(value) {
        this._recordupdated = value;
    }

    loaded = false;
    offreObject;
    isLoaderOn = false;
    isModalOpen = false;
    isModalMensualiteOpen = false;
    isModalMensualiteRepliOpen = false;
    isRepliOpen = true;
    isOptionOpen = true;
    isPousseMensuNot0 = false;
    isRepliMensuNot0 = false;
    showButtonPlusPousse = false;
    showButtonMoinsPousse = false;
    showButtonPlusRepli = false;
    showButtonMoinsRepli = false;
    isElecPousseNotNull = true;
    isGazPousseNotNull = true;
    isDualPousse = false;
    isElecRepliNotNull = true;
    isGazRepliNotNull = true;
    isDualRepli = false;
    isOffreDeRepliNotNull = true;
    isOptionNotNull = true;
    totalPriceNotEgalZeroPousse = true;
    totalPriceNotEgalZeroRepli = true;
    optionPriceNotZero = true;
    optionPriceGazNotZero = true;
    isOffreSelected = false;
    isOffreRepliSelected = false;
    isOptionSelected = false;
    isOptionGazSelected = false;
    isHPHC = false;
    // Start DDPCM-169
    isOrange = false;
    isBlue = true;
    isGreen = false;
    myAjustement = 0;
    // End DDPCM-169



    buttonLabelPousse = "Choisir cette offre";
    buttonLabelRepli = "Choisir cette offre";

    ajustMensPousseNum = 0;
    ajustMensRepliNum = 0;
    copieAjustMensPousseNum = 0;
    copieAjustMensRepliNum = 0;
    priceOffreSelected = 0;
    nameOffreSelected = '';
    finalCalculValue = 0;
    valueifOptionSelected = 0;
    valueifOptionGazSelected = 0;

    variableValueForMensualitePousse = 0;
    variableValueForMensualiteRepli = 0;

    isEuroSup = 0;
    isEuroInf = 0;
    copieOffrePousseTotalPriceVarRounded = 0;
    copieOffrePousseTotalPriceVar = 0;

    offrePousseTotalPrice = 0;
    offreObjectoffrePousseelibelle = "";
    offrePousseTotalPriceVar = 0;
    offrePousseTotalPriceVarRounded = 0;
    offrePousseTotalPriceInitValue = 0;
    offreObjectoffrePousseprixElecAboTTC = 0;
    offreObjectoffrePousseprixElecAboTTC2 = 0;
    offreObjectoffrePousseprixElecAboHT = 0;
    offreObjectoffrePousseprixElecAboHT2 = 0;
    offreObjectoffrePousseprixElecCoTTC = 0;
    offreObjectoffrePousseprixElecCoTTC2 = 0;
    offreObjectoffrePousseprixElecCoHT = 0;
    offreObjectoffrePousseprixElecCoHT2 = 0;
    offreObjectoffrePousseprixElecCoTTCHC = 0;
    offreObjectoffrePousseprixElecCoHTHC = 0;
    offreObjectoffrePousseprixGazAboTTC = 0;
    offreObjectoffrePousseprixGazAboHT = 0;
    offreObjectoffrePousseprixGazCoTTC = 0;
    offreObjectoffrePousseprixGazCoHT = 0;
    offreObjectoffrePousseeprixElecAboACHHT = 0;
    offreObjectoffrePousseeprixElecAboACHTTC = 0;
    offreObjectoffrePousseeprixElecTOTABHT = 0;
    offreObjectoffrePousseeprixElecTOTAB = 0;

    offreObjectoffrePousseeprixElecCoACHHT = 0;
    offreObjectoffrePousseeprixElecCoACHHCHT = 0;
    offreObjectoffrePousseeprixElecCoACHHCBHT = 0;
    offreObjectoffrePousseeprixElecCoACHHPBHT = 0;
    offreObjectoffrePousseeprixElecCoACHHCHHT = 0;
    offreObjectoffrePousseeprixElecCoACHHPHHT = 0;
    offreObjectoffrePousseeprixElecObHT = 0;
    offreObjectoffrePousseeprixElecTOTCOHT = 0;

    offreObjectoffrePousseeprixElecCoACHTTC = 0;
    offreObjectoffrePousseeprixElecCoACHHCTTC = 0;
    offreObjectoffrePousseeprixElecCoACHHCBTTC = 0;
    offreObjectoffrePousseeprixElecCoACHHPBTTC = 0;
    offreObjectoffrePousseeprixElecCoACHHCHTTC = 0;
    offreObjectoffrePousseeprixElecCoACHHPHTTC = 0;
    offreObjectoffrePousseeprixElecObTTC = 0;
    offreObjectoffrePousseeprixElecTOTCO = 0;

    offreObjectoffrePousseprixGazAboACHTTC = 0;
    offreObjectoffrePousseprixGazAboHT2 = 0;
    offreObjectoffrePousseprixGazTOTABHT = 0;
    offreObjectoffrePousseprixGazAboACHHT = 0;
    offreObjectoffrePousseprixGazAboTTC2 = 0;
    offreObjectoffrePousseprixGazTOTAB = 0;

    offreObjectoffrePousseprixGazCoACHHT = 0;
    offreObjectoffrePousseprixGazObHT = 0;
    offreObjectoffrePousseprixGazTOTCOHT = 0;
    offreObjectoffrePousseprixGazCoACHTTC = 0;
    offreObjectoffrePousseprixGazObTTC = 0;
    offreObjectoffrePousseprixGazTOTCO = 0;


    offreRepliTotalPrice = 0;
    offreRepliTotalPriceVar = 0;
    offreRepliTotalPriceVarRounded = 0;
    offreRepliTotalPriceInitValue = 0;
    offreObjectoffreDeReplislibelle = "";
    offreObjectoffreDeReplisprixElecAboTTC = 0;
    offreObjectoffreDeReplisprixElecAboHT = 0;
    offreObjectoffreDeReplisprixElecCoTTC = 0;
    offreObjectoffreDeReplisprixElecCoHT = 0;
    offreObjectoffreDeReplisprixElecCoTTCHC = 0;
    offreObjectoffreDeReplisprixElecCoHTHC = 0;
    offreObjectoffreDeReplisprixGazAboTTC = 0;
    offreObjectoffreDeReplisprixGazAboHT = 0;
    offreObjectoffreDeReplisprixGazCoTTC = 0;
    offreObjectoffreDeReplisprixGazCoHT = 0;

    offreObjectoffreDeReplisprixElecAboHT2 = 0;
    offreObjectoffreDeReplisprixElecAboTTC2 = 0;
    offreObjectoffreDeReplisprixElecAboACHHT = 0;
    offreObjectoffreDeReplisprixElecTOTABHT = 0;
    offreObjectoffreDeReplisprixElecAboACHTTC = 0;
    offreObjectoffreDeReplisprixElecTOTAB = 0;

    offreObjectoffreDeReplisprixElecCoACHHT = 0;
    offreObjectoffreDeReplisprixElecCoACHHCHT = 0;
    offreObjectoffreDeReplisprixElecCoACHHCBHT = 0;
    offreObjectoffreDeReplisprixElecCoACHHPBHT = 0;
    offreObjectoffreDeReplisprixElecCoACHHCHHT = 0;
    offreObjectoffreDeReplisprixElecCoACHHPHHT = 0;
    offreObjectoffreDeReplisprixElecObHT = 0;
    offreObjectoffreDeReplisprixElecTOTCOHT = 0;

    offreObjectoffreDeReplisprixElecCoACHTTC = 0;
    offreObjectoffreDeReplisprixElecCoACHHCTTC = 0;
    offreObjectoffreDeReplisprixElecCoACHHCBTTC = 0;
    offreObjectoffreDeReplisprixElecCoACHHPBTTC = 0;
    offreObjectoffreDeReplisprixElecCoACHHCHTTC = 0;
    offreObjectoffreDeReplisprixElecCoACHHPHTTC = 0;
    offreObjectoffreDeReplisprixElecObTTC = 0;
    offreObjectoffreDeReplisprixElecTOTCO = 0;

    offreObjectoffreDeReplisprixGazAboHT2 = 0;
    offreObjectoffreDeReplisprixGazAboACHHT = 0;
    offreObjectoffreDeReplisprixGazTOTABHT = 0;
    offreObjectoffreDeReplisprixGazAboTTC2 = 0;
    offreObjectoffreDeReplisprixGazAboACHTTC = 0;
    offreObjectoffreDeReplisprixGazTOTAB = 0;

    offreObjectoffreDeReplisprixGazCoACHHT = 0;
    offreObjectoffreDeReplisprixGazObHT = 0;
    offreObjectoffreDeReplisprixGazTOTCOHT = 0;
    offreObjectoffreDeReplisprixGazCoACHTTC = 0;
    offreObjectoffreDeReplisprixGazObTTC = 0;
    offreObjectoffreDeReplisprixGazTOTCO = 0;

    optionDropImage = EngieCommunityResource + '/EngieAssets/pictures/fleche-droite.png';
    SmileyImage = EngieCommunityResource + '/EngieAssets/pictures/smileyVert.png';
    giftImage = EngieCommunityResource + '/EngieAssets/pictures/3-offre--mensualites-fill-1-D2CB8F43-C3F3-4F66-BF92-F14EA9046E63@2x.png';
    closeImage = EngieCommunityResource + '/EngieAssets/pictures/close-icon.png';
    pictoAstuce = EngieCommunityResource + '/EngieAssets/pictures/picto-astuce.png';
    elecImage = EngieCommunityResource + '/EngieAssets/pictures/elec_bleu.svg';
    gazImage = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--situation-group-3-blue.png';
    gazImageVert = EngieCommunityResource + '/EngieAssets/pictures/gaz_vert.svg';
    elecImageVert = EngieCommunityResource + '/EngieAssets/pictures/elec_vert.svg';


    isAcheminementBasePoussee = false;
    isAcheminementHPHCPoussee = false;
    isAcheminement4QuadrantPoussee = false;

    isAcheminementBase = false;
    isAcheminementHPHC = false;
    isAcheminement4Quadrant = false;



    @track divPromoStyle = "position: relative;margin-top: 200px;margin-left: -11%;";

    @track divStyle = 'gazHeader backgroundColorBlueClass';
    @track totalPriceDiv = 'font-size50px fontColorBlueClass';
    @track TotalPriceDevice = 'font-size30px fontColorBlueClass';
    // Start DDPCM-169
    @track colorBorder = 'vi-modal-container-mensualite-astuce blueBorder;';
    // End DDPCM-169
    @track imageClass = 'height130P font-size30px fontColorBlueClass';
    @track ajusterButtonClass = 'fontColorBlueClass underlineText font-size20px';
    @track choisirButtonClass = 'buttonChoisir borderColorBlueClass backgroundColorBlueClass';
    @track tableHeaderClass = 'fontColorBlueClass font-size20px';
    @track traitClass = "backgroundColorBlueClass";
    @track traitGazClass = "OffrePousseGazTraitClass backgroundColorBlueClass";
    @track offerRepliClass = "container gazDiv";
    @track offerStyle = "border-color: var(--cerulean)";
    @track gazPrixGazDivClass = "gazPrixElecDiv";
    @track ElecDivClass = "gazPrixElecDiv";
    @track imageRepliStyle = "";
    @track hideOptionStyle = "";
    @track totalPriceNullClass = 'text-center';
    @track ajusterNullTotalPriceClass = 'text-center';
    @track textIfPriceNullClass = "margin-top25px";

    @track divStylePousse = 'gazHeader backgroundColorBlueClass';
    @track totalPricePousseDiv = 'font-size50px fontColorBlueClass';
    @track TotalPriceDevicePousse = 'font-size30px fontColorBlueClass';
    @track imagePousseClass = 'height130P font-size30px fontColorBlueClass';
    @track ajusterButtonPousseClass = 'fontColorBlueClass underlineText font-size20px';
    @track choisirButtonPousseClass = 'buttonChoisir borderColorBlueClass backgroundColorBlueClass';
    @track tableHeaderPousseClass = 'fontColorBlueClass font-size20px';
    @track traitPousseClass = "backgroundColorBlueClass";
    @track traitGazPousseClass = "OffrePousseGazTraitClass backgroundColorBlueClass";
    @track offerPousseClass = "container gazDiv";
    @track offerPousseStyle = "border-color: var(--cerulean)";
    @track gazPrixGazDivPousseClass = "gazPrixElecDiv";
    @track ElecDivPousseClass = "gazPrixElecDiv";
    @track ajusterNullTotalPriceRepliClass = 'text-center';
    @track textIfPriceNullRepliClass = "margin-top25px";
    @track gazTop = "";
    @track gazTopRepli = "top:6%";

    @track positionOffreRepli = 'row positionOffreRepli';
    @track positionOptions = 'row positionOptions'


    @track imageOffreRepliGaz = this.gazImage;
    @track imageOffreRepliElec = this.elecImage;
    @track imageOffrePousseGaz = this.gazImage;
    @track imageOffrePousseElec = this.elecImage;


    @track viModalButtonMinusMensualitePousse = "vi-modal-button-minus-mensualite borderColorBlueClass fontColorBlueClass";
    @track viModalButtonPlusMensualitePousse = "vi-modal-button-plus-mensualite borderColorBlueClass fontColorBlueClass";
    @track viModalButtonMinusMensualiteRepli = "vi-modal-button-minus-mensualite borderColorBlueClass fontColorBlueClass";
    @track viModalButtonPlusMensualiteRepli = "vi-modal-button-plus-mensualite borderColorBlueClass fontColorBlueClass";

    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';

    connectedCallback() {

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
                this.OfferOctopus();
            })
            .catch(error => {
                console.log(error);
                this.error = error;
            });
    }

    // Open / close Modal1
    openModalMensualite() {
        this.isModalOpen = true;
        this.isModalMensualiteOpen = true;
    }

    openModalMensualiteRepli() {
        this.isModalOpen = true;
        this.isModalMensualiteRepliOpen = true;
    }

    closeModalMensualiteRepli() {
        this.isModalOpen = false;
        this.isModalMensualiteRepliOpen = false;
    }

    closeModalMensualite() {
        this.isModalOpen = false;
        this.isModalMensualiteOpen = false;
    }

    closeAllModalMensualite() {
        this.isModalOpen = false;
        this.isModalMensualiteRepliOpen = false;
        this.isModalMensualiteOpen = false;
    }

    hideRepli() {
        if (this.isRepliOpen === false) {
            this.isRepliOpen = true;
            this.imageRepliStyle = "transform: rotate(-90deg)";
            if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === "Offre de repli") {
                this.turnOffreRepliIntoGreen();
            } else if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === "Offre poussée") {
                this.turnOffrePrincIntoGreen();
            }

        } else {
            this.isRepliOpen = false;
            this.imageRepliStyle = "transform: rotate(90deg)";
        }
    }

    // Start DDPCM-169
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
    // End DDPCM-169

    buttonPlusAction() {

        this.offrePousseTotalPriceVarRounded = Math.ceil(this.offrePousseTotalPriceVar);
        this.isEuroSup = + Math.floor(this.offrePousseTotalPriceVarRounded) + 1;
        this.viModalButtonMinusMensualitePousse = "vi-modal-button-minus-mensualite borderColorBlueClass fontColorBlueClass";
        this.showButtonMoinsPousse = false;
        while (this.ajustMensPousseNum < 10 && this.offrePousseTotalPriceVarRounded < this.isEuroSup) {
            if (this.ajustMensPousseNum < 10) {
                this.offrePousseTotalPriceVar = (parseFloat(this.offrePousseTotalPriceVar) + parseFloat(this.variableValueForMensualitePousse)).toFixed(2);
                this.offrePousseTotalPriceVarRounded = Math.ceil(this.offrePousseTotalPriceVar);
                this.ajustMensPousseNum = this.ajustMensPousseNum + 1;
                if (this.ajustMensPousseNum === 10) {
                    this.showButtonPlusPousse = true;
                    this.viModalButtonPlusMensualitePousse = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
                }
            }
        }
        if (this.offrePousseTotalPriceVarRounded === this.offrePousseTotalPriceInitValue) {
            this.ajustMensPousseNum = 0;
            this.offrePousseTotalPriceVar = this.offrePousseTotalPriceInitValue;
        }
        if (this.ajustMensPousseNum < 10) {
            this.copieAjustMensPousseNum = this.ajustMensPousseNum;
            this.copieOffrePousseTotalPriceVar = this.offrePousseTotalPriceVar;
            this.copieOffrePousseTotalPriceVarRounded = this.offrePousseTotalPriceVarRounded;
            this.isEuroSup = this.isEuroSup + 1;
            while (this.copieAjustMensPousseNum < 10 && this.copieOffrePousseTotalPriceVarRounded < this.isEuroSup) {
                this.copieOffrePousseTotalPriceVar = (parseFloat(this.copieOffrePousseTotalPriceVar) + parseFloat(this.variableValueForMensualitePousse)).toFixed(2);
                this.copieOffrePousseTotalPriceVarRounded = Math.ceil(this.copieOffrePousseTotalPriceVar);
                this.copieAjustMensPousseNum = this.copieAjustMensPousseNum + 1;
            }
            if (this.copieAjustMensPousseNum === 10 && this.copieOffrePousseTotalPriceVarRounded === this.offrePousseTotalPriceVarRounded) {
                this.showButtonPlusPousse = true;
                this.viModalButtonPlusMensualitePousse = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
            }
        }
        else {
            this.showButtonPlusPousse = true;
            this.viModalButtonPlusMensualitePousse = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
        }
        // Start DDPCM-169
        this.myAjustement = this.ajustMensPousseNum;
        this.colorAjustement();
        // End DDPCM-169

    }

    buttonMoinsAction() {
        this.offrePousseTotalPriceVarRounded = Math.ceil(this.offrePousseTotalPriceVar);
        this.isEuroInf = + Math.floor(this.offrePousseTotalPriceVarRounded) - 1;
        this.showButtonPlusPousse = false;
        this.viModalButtonPlusMensualitePousse = "vi-modal-button-plus-mensualite borderColorBlueClass fontColorBlueClass";
        while (this.ajustMensPousseNum > -10 && this.offrePousseTotalPriceVarRounded > this.isEuroInf) {
            if (this.ajustMensPousseNum > -10) {
                this.offrePousseTotalPriceVar = (parseFloat(this.offrePousseTotalPriceVar) - parseFloat(this.variableValueForMensualitePousse)).toFixed(2);
                this.offrePousseTotalPriceVarRounded = Math.ceil(this.offrePousseTotalPriceVar);
                this.ajustMensPousseNum = this.ajustMensPousseNum - 1;
                if (this.ajustMensPousseNum === -10) {
                    this.showButtonMoinsPousse = true;
                    this.viModalButtonMinusMensualitePousse = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
                }
            }
        }
        if (this.offrePousseTotalPriceVarRounded === this.offrePousseTotalPriceInitValue) {
            this.ajustMensPousseNum = 0;
            this.offrePousseTotalPriceVar = this.offrePousseTotalPriceInitValue;
        }
        if (this.ajustMensPousseNum > -10) {
            this.copieAjustMensPousseNum = this.ajustMensPousseNum;
            this.copieOffrePousseTotalPriceVar = this.offrePousseTotalPriceVar;
            this.copieOffrePousseTotalPriceVarRounded = this.offrePousseTotalPriceVarRounded;
            this.isEuroInf = this.isEuroInf - 1;
            while (this.copieAjustMensPousseNum > -10 && this.copieOffrePousseTotalPriceVarRounded > this.isEuroInf) {
                this.copieOffrePousseTotalPriceVar = (parseFloat(this.copieOffrePousseTotalPriceVar) - parseFloat(this.variableValueForMensualitePousse)).toFixed(2);
                this.copieOffrePousseTotalPriceVarRounded = Math.ceil(this.copieOffrePousseTotalPriceVar);
                this.copieAjustMensPousseNum = this.copieAjustMensPousseNum - 1;
            }
            if (this.copieAjustMensPousseNum === -10 && this.copieOffrePousseTotalPriceVarRounded === this.offrePousseTotalPriceVarRounded) {
                this.showButtonMoinsPousse = true;
                this.viModalButtonMinusMensualitePousse = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
            }
        }
        else {
            this.showButtonMoinsPousse = true;
            this.viModalButtonMinusMensualitePousse = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
        }
        // Start DDPCM-169
        this.myAjustement = this.ajustMensPousseNum;
        this.colorAjustement();
        // End DDPCM-169
    }

    buttonPlusActionRepli() {
        this.offreRepliTotalPriceVarRounded = Math.ceil(this.offreRepliTotalPriceVar);
        this.isEuroSup = + Math.floor(this.offreRepliTotalPriceVarRounded) + 1;
        this.viModalButtonMinusMensualiteRepli = "vi-modal-button-minus-mensualite borderColorBlueClass fontColorBlueClass";
        this.showButtonMoinsRepli = false;
        while (this.ajustMensRepliNum < 10 && this.offreRepliTotalPriceVarRounded < this.isEuroSup) {
            if (this.ajustMensRepliNum < 10) {
                this.offreRepliTotalPriceVar = (parseFloat(this.offreRepliTotalPriceVar) + parseFloat(this.variableValueForMensualitePousse)).toFixed(2);
                this.offreRepliTotalPriceVarRounded = Math.ceil(this.offreRepliTotalPriceVar);
                this.ajustMensRepliNum = this.ajustMensRepliNum + 1;
                if (this.ajustMensRepliNum === 10) {
                    this.showButtonPlusRepli = true;
                    this.viModalButtonPlusMensualiteRepli = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
                }
            }
        }
        if (this.offreRepliTotalPriceVarRounded === this.offreRepliTotalPriceInitValue) {
            this.ajustMensRepliNum = 0;
            this.offreRepliTotalPriceVar = this.offreRepliTotalPriceInitValue;
        }
        if (this.ajustMensRepliNum < 10) {
            this.copieAjustMensPousseNum = this.ajustMensRepliNum;
            this.copieOffrePousseTotalPriceVar = this.offreRepliTotalPriceVar;
            this.copieOffrePousseTotalPriceVarRounded = this.offreRepliTotalPriceVarRounded;
            this.isEuroSup = this.isEuroSup + 1;
            while (this.copieAjustMensPousseNum < 10 && this.copieOffrePousseTotalPriceVarRounded < this.isEuroSup) {
                this.copieOffrePousseTotalPriceVar = (parseFloat(this.copieOffrePousseTotalPriceVar) + parseFloat(this.variableValueForMensualitePousse)).toFixed(2);
                this.copieOffrePousseTotalPriceVarRounded = Math.ceil(this.copieOffrePousseTotalPriceVar);
                this.copieAjustMensPousseNum = this.copieAjustMensPousseNum + 1;
            }
            if (this.copieAjustMensPousseNum === 10 && this.copieOffrePousseTotalPriceVarRounded === this.offrePousseTotalPriceVarRounded) {
                this.showButtonPlusRepli = true;
                this.viModalButtonPlusMensualiteRepli = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
            }
        }
        else {
            this.showButtonPlusRepli = true;
            this.viModalButtonPlusMensualiteRepli = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
        }
        // Start DDPCM-169
        this.myAjustement = this.ajustMensRepliNum;
        this.colorAjustement();
        // End DDPCM-169
    }

    buttonMoinsActionRepli() {
        this.offreRepliTotalPriceVarRounded = Math.ceil(this.offreRepliTotalPriceVar);
        this.isEuroInf = + Math.floor(this.offreRepliTotalPriceVarRounded) - 1;
        this.showButtonPlusRepli = false;
        this.viModalButtonPlusMensualiteRepli = "vi-modal-button-plus-mensualite borderColorBlueClass fontColorBlueClass";
        while (this.ajustMensRepliNum > -10 && this.offreRepliTotalPriceVarRounded > this.isEuroInf) {
            if (this.ajustMensRepliNum > -10) {
                this.offreRepliTotalPriceVar = (parseFloat(this.offreRepliTotalPriceVar) - parseFloat(this.variableValueForMensualitePousse)).toFixed(2);
                this.offreRepliTotalPriceVarRounded = Math.ceil(this.offreRepliTotalPriceVar);
                this.ajustMensRepliNum = this.ajustMensRepliNum - 1;
                if (this.ajustMensRepliNum === -10) {
                    this.showButtonMoinsRepli = true;
                    this.viModalButtonMinusMensualiteRepli = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
                }
            }
        }
        if (this.offreRepliTotalPriceVarRounded === this.offreRepliTotalPriceInitValue) {
            this.ajustMensRepliNum = 0;
            this.offreRepliTotalPriceVar = this.offreRepliTotalPriceInitValue;
        }
        if (this.ajustMensRepliNum > -10) {
            this.copieAjustMensPousseNum = this.ajustMensRepliNum;
            this.copieOffrePousseTotalPriceVar = this.offreRepliTotalPriceVar;
            this.copieOffrePousseTotalPriceVarRounded = this.offreRepliTotalPriceVarRounded;
            this.isEuroInf = this.isEuroInf - 1;
            while (this.copieAjustMensPousseNum > -10 && this.copieOffrePousseTotalPriceVarRounded > this.isEuroInf) {
                this.copieOffrePousseTotalPriceVar = (parseFloat(this.copieOffrePousseTotalPriceVar) - parseFloat(this.variableValueForMensualitePousse)).toFixed(2);
                this.copieOffrePousseTotalPriceVarRounded = Math.ceil(this.copieOffrePousseTotalPriceVar);
                this.copieAjustMensPousseNum = this.copieAjustMensPousseNum - 1;
            }
            if (this.copieAjustMensPousseNum === -10 && this.copieOffrePousseTotalPriceVarRounded === this.offreRepliTotalPriceVarRounded) {
                this.showButtonMoinsRepli = true;
                this.viModalButtonMinusMensualiteRepli = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
            }
        }
        else {
            this.showButtonMoinsRepli = true;
            this.viModalButtonMinusMensualiteRepli = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
        }
        // Start DDPCM-169
        this.myAjustement = this.ajustMensRepliNum;
        this.colorAjustement();
        // End DDPCM-169
    }

    validerMensuPousse() {
        this.isModalOpen = false;
        this.isModalMensualiteOpen = false;
        this.offrePousseTotalPrice = this.offrePousseTotalPriceVarRounded;

        if (this.ajustMensPousseNum === 0) {
            this.isPousseMensuNot0 = false;
        } else {
            this.isPousseMensuNot0 = true;
        }

        if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === "Offre poussée") {
            this._record.VI_MontantOffrePanierClient__c = this.offrePousseTotalPriceInitValue.toString().replace(".", ",");
            this._record.VI_AjustementMensualitesPanierClient__c = this.ajustMensPousseNum.toString();
            this._record.VI_MontantdelaMensualitePanierClient__c = this.offrePousseTotalPrice.toString().replace(".", ",");
            this._record.VI_EleckWhHTPanierClient__c = this.offreObjectoffrePousseprixElecCoHT.toString().replace(".", ",");
            this._record.VI_EleckWhTTCPanierClient__c = this.offreObjectoffrePousseprixElecCoTTC.toString().replace(".", ",");
            if (this.isHPHC) {
                this._record.VI_EleckWhTTCHCPanierClient__c = this.offreObjectoffrePousseprixElecCoTTCHC.toString().replace(".", ",");
                this._record.VI_EleckWhHTHCPanierClient__c = this.offreObjectoffrePousseprixElecCoHTHC.toString().replace(".", ",");
            }
            this._record.VI_GazkWhHTPanierClient__c = this.offreObjectoffrePousseprixGazCoHT.toString().replace(".", ",");
            this._record.VI_GazkWhTTCPanierClient__c = this.offreObjectoffrePousseprixGazCoTTC.toString().replace(".", ",");
            this._record.VI_AbonnementAnnuelGazHTPanierClient__c = this.offreObjectoffrePousseprixGazAboHT.toString().replace(".", ",");
            this._record.VI_AbonnementAnnuelGazTTCPanierClient__c = this.offreObjectoffrePousseprixGazAboTTC.toString().replace(".", ",");
            this._record.VI_AbonnementAnnuelElecHTPanierClient__c = this.offreObjectoffrePousseprixElecAboHT.toString().replace(".", ",");
            this._record.VI_AbonnementAnnuelElecTTCPanierClient__c = this.offreObjectoffrePousseprixElecAboTTC.toString().replace(".", ",");
            this._record.VI_OffreChoisieElecPanierClient__c = this.offreObject.offrePoussee.codeElec;
            this._record.VI_OffreChoisieGazPanierClient__c = this.offreObject.offrePoussee.codeGaz;
            this._record.VI_LibelleOffrePanierClient__c = this.offreObjectoffrePousseelibelle;
            this._record.VI_Code_pack__c = this.offreObject.offrePoussee.idPack;
        }

        if (this.isOffreSelected) {
            this.priceOffreSelected = this.offrePousseTotalPrice;
            this.sendRecordParent();
        }
    }

    validerMensuRepli() {
        this.isModalOpen = false;
        this.isModalMensualiteRepliOpen = false;
        this.offreRepliTotalPrice = this.offreRepliTotalPriceVarRounded;

        if (this.ajustMensRepliNum === 0) {
            this.isRepliMensuNot0 = false;
        } else {
            this.isRepliMensuNot0 = true;
        }

        if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === "Offre de repli") {
            this._record.VI_MontantOffrePanierClient__c = this.offreRepliTotalPriceInitValue.toString().replace(".", ",");
            this._record.VI_AjustementMensualitesPanierClient__c = this.ajustMensRepliNum.toString();
            this._record.VI_MontantdelaMensualitePanierClient__c = this.offreRepliTotalPrice.toString().replace(".", ",");
            this._record.VI_EleckWhHTPanierClient__c = this.offreObjectoffreDeReplisprixElecCoHT.toString().replace(".", ",");
            this._record.VI_EleckWhTTCPanierClient__c = this.offreObjectoffreDeReplisprixElecCoTTC.toString().replace(".", ",");
            if (this.isHPHC) {
                this._record.VI_EleckWhHTHCPanierClient__c = this.offreObjectoffreDeReplisprixElecCoHTHC.toString().replace(".", ",");
                this._record.VI_EleckWhTTCHCPanierClient__c = this.offreObjectoffreDeReplisprixElecCoTTCHC.toString().replace(".", ",");
            }
            this._record.VI_GazkWhHTPanierClient__c = this.offreObjectoffreDeReplisprixGazCoHT.toString().replace(".", ",");
            this._record.VI_GazkWhTTCPanierClient__c = this.offreObjectoffreDeReplisprixGazCoTTC.toString().replace(".", ",");
            this._record.VI_AbonnementAnnuelGazHTPanierClient__c = this.offreObjectoffreDeReplisprixGazAboHT.toString().replace(".", ",");
            this._record.VI_AbonnementAnnuelGazTTCPanierClient__c = this.offreObjectoffreDeReplisprixGazAboTTC.toString().replace(".", ",");
            this._record.VI_AbonnementAnnuelElecHTPanierClient__c = this.offreObjectoffreDeReplisprixElecAboHT.toString().replace(".", ",");
            this._record.VI_AbonnementAnnuelElecTTCPanierClient__c = this.offreObjectoffreDeReplisprixElecAboTTC.toString().replace(".", ",");
            this._record.VI_OffreChoisieElecPanierClient__c = this.offreObject.offreDeReplis.codeElec;
            this._record.VI_OffreChoisieGazPanierClient__c = this.offreObject.offreDeReplis.codeGaz;
            this._record.VI_LibelleOffrePanierClient__c = this.offreObjectoffreDeReplislibelle;
            this._record.VI_Code_pack__c = this.offreObject.offreDeReplis.idPack;
        }

        if (this.isOffreRepliSelected) {
            this.priceOffreSelected = this.offreRepliTotalPrice;
            this.sendRecordParent();
        }
    }



    choixOffrePrincipale() {
        this.isOffreSelected = true;
        /* Start DDPCM 1192 */
        this.promotions_Offre_Choisi = null;
        this.emptyCodePromo();
        /* End DDPCM 1192 */
        this.isOffreRepliSelected = false;
        this.nameOffreSelected = this.offreObject.offrePoussee.libelle;
        this.priceOffreSelected = this.offrePousseTotalPrice;
        this.turnOffrePrincIntoGreen();
        this.registerDataOffrePrincipale();
        this.sendRecordParent();

    }

    registerDataOffrePrincipale() {
        this._record.VI_ChoixOffreSurParcoursPanierClient__c = "Offre poussée";
        this._record.VI_MontantOffrePanierClient__c = this.offrePousseTotalPriceInitValue.toString().replace(".", ",");
        this._record.VI_AjustementMensualitesPanierClient__c = this.ajustMensPousseNum.toString();
        this._record.VI_MontantdelaMensualitePanierClient__c = this.offrePousseTotalPrice.toString().replace(".", ",");
        this._record.VI_EleckWhHTPanierClient__c = this.offreObjectoffrePousseprixElecCoHT.toString().replace(".", ",");
        this._record.VI_EleckWhTTCPanierClient__c = this.offreObjectoffrePousseprixElecCoTTC.toString().replace(".", ",");
        if (this.isHPHC) {
            if (this.offreObjectoffrePousseprixElecCoTTCHC !== null &&
                this.offreObjectoffrePousseprixElecCoTTCHC !== undefined) {
                this._record.VI_EleckWhTTCHCPanierClient__c = this.offreObjectoffrePousseprixElecCoTTCHC.toString().replace(".", ",");
            }
            if (this.offreObjectoffrePousseprixElecCoHTHC !== null &&
                this.offreObjectoffrePousseprixElecCoHTHC !== undefined) {
                this._record.VI_EleckWhHTHCPanierClient__c = this.offreObjectoffrePousseprixElecCoHTHC.toString().replace(".", ",");

            }
        }
        this._record.VI_GazkWhHTPanierClient__c = this.offreObjectoffrePousseprixGazCoHT.toString().replace(".", ",");
        this._record.VI_GazkWhTTCPanierClient__c = this.offreObjectoffrePousseprixGazCoTTC.toString().replace(".", ",");
        this._record.VI_AbonnementAnnuelGazHTPanierClient__c = this.offreObjectoffrePousseprixGazAboHT.toString().replace(".", ",");
        this._record.VI_AbonnementAnnuelGazTTCPanierClient__c = this.offreObjectoffrePousseprixGazAboTTC.toString().replace(".", ",");
        this._record.VI_AbonnementAnnuelElecHTPanierClient__c = this.offreObjectoffrePousseprixElecAboHT.toString().replace(".", ",");
        this._record.VI_AbonnementAnnuelElecTTCPanierClient__c = this.offreObjectoffrePousseprixElecAboTTC.toString().replace(".", ",");
        this._record.VI_OffreChoisieElecPanierClient__c = this.offreObject.offrePoussee.codeElec;
        this._record.VI_OffreChoisieGazPanierClient__c = this.offreObject.offrePoussee.codeGaz;
        this._record.VI_LibelleOffrePanierClient__c = this.offreObjectoffrePousseelibelle;
        this._record.VI_Code_pack__c = this.offreObject.offrePoussee.idPack;

        if (this.offreObject.offrePoussee.prixElec !== null &&
            this.offreObject.offrePoussee.prixElec !== undefined) {
            this._record.VI_MensualiteElecTTC__c = this.offreObject.offrePoussee.prixElec.prixMensuel;
        }
        if (this.offreObject.offrePoussee.prixGaz !== null &&
            this.offreObject.offrePoussee.prixGaz !== undefined) {
            this._record.VI_MensualiteGazTTC__c = this.offreObject.offrePoussee.prixGaz.prixMensuel;
        }

        if (this.offreObject.isTradeOffPoussee) {
            this._record.VI_TechOffreReferenceChoisie__c = true;
            this._record.VI_Code_FTA_Offre__c = this.offreObject.offrePoussee.ftaOutput;


            if (this.isElecPousseNotNull) {
                this._record.VI_MONTANT_ABO_ELEC_FOUR_TTC__c = this.offreObject.offrePoussee.prixElec.AboTTC;
                this._record.VI_MONTANT_ABO_ELEC_FOUR_HT__c = this.offreObject.offrePoussee.prixElec.AboHT;

                this._record.VI_MONTANT_ABO_ELEC_ACH_TTC__c = this.offreObject.offrePoussee.prixElec.AboACHTTC;
                this._record.VI_MONTANT_ABO_ELEC_ACH_HT__c = this.offreObject.offrePoussee.prixElec.AboACHHT;
                this._record.VI_TOTAL_MONTANT_ABO_ELEC_TTC__c = this.offreObject.offrePoussee.prixElec.TOTAB;
                this._record.VI_TOTAL_MONTANT_ABO_ELEC_HT__c = this.offreObject.offrePoussee.prixElec.TOTABHT;
                this._record.VI_TOTAL_MONTANT_CONSO_ELEC_TTC__c = this.offreObject.offrePoussee.prixElec.TOTCO;
                this._record.VI_TOTAL_MONTANT_CONSO_ELEC_HT__c = this.offreObject.offrePoussee.prixElec.TOTCOHT;
                this._record.VI_PRIX_KWH_ELEC_ACH_TTC__c = this.offreObject.offrePoussee.prixElec.CoACHTTC;
                this._record.VI_PRIX_KWH_ELEC_ACH_HT__c = this.offreObject.offrePoussee.prixElec.CoACHHT;
                if (!this.isHPHC) {
                    this._record.VI_PRIX_KWH_ELEC_FOUR_TTC__c = this.offreObject.offrePoussee.prixElec.CoTTC;
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HT__c = this.offreObject.offrePoussee.prixElec.CoHT;
                    this._record.VI_PRIX_KWH_ELEC_OBLI__c = this.offreObject.offrePoussee.prixElec.ObTTC;
                    this._record.VI_PRIX_KWH_ELEC_OBLI_HT__c = this.offreObject.offrePoussee.prixElec.ObHT;
                }
                else {
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c = this.offreObject.offrePoussee.prixElec.CoTTC;
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HP_HT__c = this.offreObject.offrePoussee.prixElec.CoHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HP_TTC__c = this.offreObject.offrePoussee.prixElec.CoACHTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HP_HT__c = this.offreObject.offrePoussee.prixElec.CoACHHT;
                    this._record.VI_PRIX_KWH_ELEC_OBLI__c = this.offreObject.offrePoussee.prixElec.ObTTC;
                    this._record.VI_PRIX_KWH_ELEC_OBLI_HT__c = this.offreObject.offrePoussee.prixElec.ObHT;
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c = this.offreObject.offrePoussee.prixElec.CoTTCHC;
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HC_HT__c = this.offreObject.offrePoussee.prixElec.CoHTHC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HC_TTC__c = this.offreObject.offrePoussee.prixElec.CoACHHCTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HC_HT__c = this.offreObject.offrePoussee.prixElec.CoACHHCHT;
                }
                if (this.offreObject.offrePoussee.prixElec.CoACHHCBHT !== undefined &&
                    this.offreObject.offrePoussee.prixElec.CoACHHCBHT !== null) {
                    this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c = this.offreObject.offrePoussee.prixElec.CoACHHCBHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_TTC__c = this.offreObject.offrePoussee.prixElec.CoACHHCBTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c = this.offreObject.offrePoussee.prixElec.CoACHHPBHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPbasse_TTC__c = this.offreObject.offrePoussee.prixElec.CoACHHPBTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HChaute_HTT__c = this.offreObject.offrePoussee.prixElec.CoACHHCHHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HChaute_TTC__c = this.offreObject.offrePoussee.prixElec.CoACHHCHTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPhaute_HTT__c = this.offreObject.offrePoussee.prixElec.CoACHHPHHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPhaute_TTC__c = this.offreObject.offrePoussee.prixElec.CoACHHPHTTC;
                }
                else {
                    this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_TTC__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPbasse_TTC__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HChaute_HTT__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HChaute_TTC__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPhaute_HTT__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPhaute_TTC__c = null;
                }
            }
            if (this.isGazPousseNotNull) {
                this._record.VI_MONTANT_ABO_GAZ_FOUR_TTC__c = this.offreObject.offrePoussee.prixGaz.AboTTC;
                this._record.VI_MONTANT_ABO_GAZ_FOUR_HT__c = this.offreObject.offrePoussee.prixGaz.AboHT;
                this._record.VI_MONTANT_ABO_GAZ_ACH_TTC__c = this.offreObject.offrePoussee.prixGaz.AboACHTTC;
                this._record.VI_MONTANT_ABO_GAZ_ACH_HT__c = this.offreObject.offrePoussee.prixGaz.AboACHHT;
                this._record.VI_PRIX_KWH_GAZ_FOUR_TTC__c = this.offreObject.offrePoussee.prixGaz.CoTTC;
                this._record.VI_PRIX_KWH_GAZ_FOUR_HT__c = this.offreObject.offrePoussee.prixGaz.CoHT;
                this._record.VI_PRIX_KWH_GAZ_ACH_TTC__c = this.offreObject.offrePoussee.prixGaz.CoACHTTC;
                this._record.VI_PRIX_KWH_GAZ_ACH_HT__c = this.offreObject.offrePoussee.prixGaz.CoACHHT;
                this._record.VI_PRIX_KWH_GAZ_OBLI__c = this.offreObject.offrePoussee.prixGaz.ObTTC;
                this._record.VI_PRIX_KWH_GAZ_OBLI_HT__c = this.offreObject.offrePoussee.prixGaz.ObHT;
                this._record.VI_TOTAL_MONTANT_ABO_GAZ_TTC__c = this.offreObject.offrePoussee.prixGaz.TOTAB;
                this._record.VI_TOTAL_MONTANT_ABO_GAZ_HT__c = this.offreObject.offrePoussee.prixGaz.TOTABHT;
                this._record.VI_TOTAL_MONTANT_CONSO_GAZ_TTC__c = this.offreObject.offrePoussee.prixGaz.TOTCO;
                this._record.VI_TOTAL_MONTANT_CONSO_GAZ_HT__c = this.offreObject.offrePoussee.prixGaz.TOTCOHT;
            }

        }
        else {
            this._record.VI_TechOffreReferenceChoisie__c = false;
        }

        this._recordupdated = true;
    }

    choixOffreReppli() {
        this.nameOffreSelected = this.offreObject.offreDeReplis.libelle;
        this.isOffreSelected = false;
        this.isOffreRepliSelected = true;
        /* Start DDPCM 1192 */
        this.promotions_Offre_Choisi = null;
        this.emptyCodePromo();
        /* End DDPCM 1192 */
        this.priceOffreSelected = this.offreRepliTotalPrice;
        this.turnOffreRepliIntoGreen();
        this.registerDataOffreRepli();
        this.sendRecordParent();

    }

    emptyCodePromo() {
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

    registerDataOffreRepli() {
        this._record.VI_ChoixOffreSurParcoursPanierClient__c = "Offre de repli";
        this._record.VI_MontantOffrePanierClient__c = this.offreRepliTotalPriceInitValue.toString().replace(".", ",");
        this._record.VI_AjustementMensualitesPanierClient__c = this.ajustMensRepliNum.toString();
        this._record.VI_MontantdelaMensualitePanierClient__c = this.offreRepliTotalPrice.toString().replace(".", ",");
        this._record.VI_EleckWhHTPanierClient__c = this.offreObjectoffreDeReplisprixElecCoHT.toString().replace(".", ",");
        this._record.VI_EleckWhTTCPanierClient__c = this.offreObjectoffreDeReplisprixElecCoTTC.toString().replace(".", ",");
        if (this.isHPHC) {
            if (this.offreObjectoffreDeReplisprixElecCoTTCHC !== null &&
                this.offreObjectoffreDeReplisprixElecCoTTCHC !== undefined) {
                this._record.VI_EleckWhTTCHCPanierClient__c = this.offreObjectoffreDeReplisprixElecCoTTCHC.toString().replace(".", ",");
            }
            if (this.offreObjectoffreDeReplisprixElecCoHTHC !== null &&
                this.offreObjectoffreDeReplisprixElecCoHTHC !== undefined) {
                this._record.VI_EleckWhHTHCPanierClient__c = this.offreObjectoffreDeReplisprixElecCoHTHC.toString().replace(".", ",");
            }
        }
        this._record.VI_GazkWhHTPanierClient__c = this.offreObjectoffreDeReplisprixGazCoHT.toString().replace(".", ",");
        this._record.VI_GazkWhTTCPanierClient__c = this.offreObjectoffreDeReplisprixGazCoTTC.toString().replace(".", ",");
        this._record.VI_AbonnementAnnuelGazHTPanierClient__c = this.offreObjectoffreDeReplisprixGazAboHT.toString().replace(".", ",");
        this._record.VI_AbonnementAnnuelGazTTCPanierClient__c = this.offreObjectoffreDeReplisprixGazAboTTC.toString().replace(".", ",");
        this._record.VI_AbonnementAnnuelElecHTPanierClient__c = this.offreObjectoffreDeReplisprixElecAboHT.toString().replace(".", ",");
        this._record.VI_AbonnementAnnuelElecTTCPanierClient__c = this.offreObjectoffreDeReplisprixElecAboTTC.toString().replace(".", ",");
        this._record.VI_OffreChoisieElecPanierClient__c = this.offreObject.offreDeReplis.codeElec;
        this._record.VI_OffreChoisieGazPanierClient__c = this.offreObject.offreDeReplis.codeGaz;
        this._record.VI_LibelleOffrePanierClient__c = this.offreObjectoffreDeReplislibelle;
        this._record.VI_Code_pack__c = this.offreObject.offreDeReplis.idPack;

        if (this.offreObject.offreDeReplis.prixElec !== null &&
            this.offreObject.offreDeReplis.prixElec !== undefined) {
            this._record.VI_MensualiteElecTTC__c = this.offreObject.offreDeReplis.prixElec.prixMensuel;
        }
        if (this.offreObject.offreDeReplis.prixGaz !== null &&
            this.offreObject.offreDeReplis.prixGaz !== undefined) {
            this._record.VI_MensualiteGazTTC__c = this.offreObject.offreDeReplis.prixGaz.prixMensuel;
        }

        if (this.offreObject.isTradeOffRepli) {
            this._record.VI_TechOffreReferenceChoisie__c = true;
            this._record.VI_Code_FTA_Offre__c = this.offreObject.offreDeReplis.ftaOutput;


            if (this.isElecRepliNotNull) {
                this._record.VI_MONTANT_ABO_ELEC_FOUR_TTC__c = this.offreObject.offreDeReplis.prixElec.AboTTC;
                this._record.VI_MONTANT_ABO_ELEC_FOUR_HT__c = this.offreObject.offreDeReplis.prixElec.AboHT;
                this._record.VI_MONTANT_ABO_ELEC_ACH_TTC__c = this.offreObject.offreDeReplis.prixElec.AboACHTTC;
                this._record.VI_MONTANT_ABO_ELEC_ACH_HT__c = this.offreObject.offreDeReplis.prixElec.AboACHHT;
                this._record.VI_TOTAL_MONTANT_ABO_ELEC_TTC__c = this.offreObject.offreDeReplis.prixElec.TOTAB;
                this._record.VI_TOTAL_MONTANT_ABO_ELEC_HT__c = this.offreObject.offreDeReplis.prixElec.TOTABHT;
                this._record.VI_TOTAL_MONTANT_CONSO_ELEC_TTC__c = this.offreObject.offreDeReplis.prixElec.TOTCO;
                this._record.VI_TOTAL_MONTANT_CONSO_ELEC_HT__c = this.offreObject.offreDeReplis.prixElec.TOTCOHT;
                this._record.VI_PRIX_KWH_ELEC_ACH_TTC__c = this.offreObject.offreDeReplis.prixElec.CoACHTTC;
                this._record.VI_PRIX_KWH_ELEC_ACH_HT__c = this.offreObject.offreDeReplis.prixElec.CoACHHT;
                if (!this.isHPHC) {
                    this._record.VI_PRIX_KWH_ELEC_FOUR_TTC__c = this.offreObject.offreDeReplis.prixElec.CoTTC;
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HT__c = this.offreObject.offreDeReplis.prixElec.CoHT;
                    this._record.VI_PRIX_KWH_ELEC_OBLI__c = this.offreObject.offreDeReplis.prixElec.ObTTC;
                    this._record.VI_PRIX_KWH_ELEC_OBLI_HT__c = this.offreObject.offreDeReplis.prixElec.ObHT;
                }
                else {
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c = this.offreObject.offreDeReplis.prixElec.CoTTC;
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HP_HT__c = this.offreObject.offreDeReplis.prixElec.CoHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HP_TTC__c = this.offreObject.offreDeReplis.prixElec.CoACHTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HP_HT__c = this.offreObject.offreDeReplis.prixElec.CoACHHT;
                    this._record.VI_PRIX_KWH_ELEC_OBLI__c = this.offreObject.offreDeReplis.prixElec.ObTTC;
                    this._record.VI_PRIX_KWH_ELEC_OBLI_HT__c = this.offreObject.offreDeReplis.prixElec.ObHT;
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c = this.offreObject.offreDeReplis.prixElec.CoTTCHC;
                    this._record.VI_PRIX_KWH_ELEC_FOUR_HC_HT__c = this.offreObject.offreDeReplis.prixElec.CoHTHC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HC_TTC__c = this.offreObject.offreDeReplis.prixElec.CoACHHCTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HC_HT__c = this.offreObject.offreDeReplis.prixElec.CoACHHCHT;
                }

                if (this.offreObject.offreDeReplis.prixElec.CoACHHCBHT !== undefined &&
                    this.offreObject.offrePoussee.prixElec.CoACHHCBHT !== null) {
                    this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c = this.offreObject.offreDeReplis.prixElec.CoACHHCBHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_TTC__c = this.offreObject.offreDeReplis.prixElec.CoACHHCBTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c = this.offreObject.offreDeReplis.prixElec.CoACHHPBHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPbasse_TTC__c = this.offreObject.offreDeReplis.prixElec.CoACHHPBTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HChaute_HTT__c = this.offreObject.offreDeReplis.prixElec.CoACHHCHHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HChaute_TTC__c = this.offreObject.offreDeReplis.prixElec.CoACHHCHTTC;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPhaute_HTT__c = this.offreObject.offreDeReplis.prixElec.CoACHHPHHT;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPhaute_TTC__c = this.offreObject.offreDeReplis.prixElec.CoACHHPHTTC;
                }
                else {
                    this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_HTT__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HCbasse_TTC__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPbasse_HTT__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPbasse_TTC__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HChaute_HTT__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HChaute_TTC__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPhaute_HTT__c = null;
                    this._record.VI_PRIX_KWH_ELEC_ACH_HPhaute_TTC__c = null;
                }
            }
            if (this.isGazRepliNotNull) {
                this._record.VI_MONTANT_ABO_GAZ_FOUR_TTC__c = this.offreObject.offreDeReplis.prixGaz.AboTTC;
                this._record.VI_MONTANT_ABO_GAZ_FOUR_HT__c = this.offreObject.offreDeReplis.prixGaz.AboHT;
                this._record.VI_MONTANT_ABO_GAZ_ACH_TTC__c = this.offreObject.offreDeReplis.prixGaz.AboACHTTC;
                this._record.VI_MONTANT_ABO_GAZ_ACH_HT__c = this.offreObject.offreDeReplis.prixGaz.AboACHHT;
                this._record.VI_PRIX_KWH_GAZ_FOUR_TTC__c = this.offreObject.offreDeReplis.prixGaz.CoTTC;
                this._record.VI_PRIX_KWH_GAZ_FOUR_HT__c = this.offreObject.offreDeReplis.prixGaz.CoHT;
                this._record.VI_PRIX_KWH_GAZ_ACH_TTC__c = this.offreObject.offreDeReplis.prixGaz.CoACHTTC;
                this._record.VI_PRIX_KWH_GAZ_ACH_HT__c = this.offreObject.offreDeReplis.prixGaz.CoACHHT;
                this._record.VI_PRIX_KWH_GAZ_OBLI__c = this.offreObject.offreDeReplis.prixGaz.ObTTC;
                this._record.VI_PRIX_KWH_GAZ_OBLI_HT__c = this.offreObject.offreDeReplis.prixGaz.ObHT;
                this._record.VI_TOTAL_MONTANT_ABO_GAZ_TTC__c = this.offreObject.offreDeReplis.prixGaz.TOTAB;
                this._record.VI_TOTAL_MONTANT_ABO_GAZ_HT__c = this.offreObject.offreDeReplis.prixGaz.TOTABHT;
                this._record.VI_TOTAL_MONTANT_CONSO_GAZ_TTC__c = this.offreObject.offreDeReplis.prixGaz.TOTCO;
                this._record.VI_TOTAL_MONTANT_CONSO_GAZ_HT__c = this.offreObject.offreDeReplis.prixGaz.TOTCOHT;
            }

        }
        else {
            this._record.VI_TechOffreReferenceChoisie__c = false;
        }


        this._recordupdated = true;
    }

    sendRecordParent() {
        const dispatchEventSearch = new CustomEvent('offrechoisie', {
            detail: {
                record: this._record
            }
        });
        this.dispatchEvent(dispatchEventSearch);
    }

    handleFinalValiderParcour() {
        const dispatchEventSearch = new CustomEvent('valideretape');
        this.dispatchEvent(dispatchEventSearch);
    }

    handlePrecedent() {
        const dispatchEventSearch = new CustomEvent('precedent');
        this.dispatchEvent(dispatchEventSearch);
    }

    handleInputChange(event) {
        let field = event.target.name;
        this._recordupdated = true;
        if (field === 'codePromoName') {
            this._record.VI_CodePromotionnelPanierClient__c = event.target.value;
        }
    }

    OfferOctopus() {
        getOffersOctopusParcours
            ({
                parcours: this._record
            }).then(result => {
                console.log('getOfferOctopus success');
                console.log(result);
                this.offreObject = result;

                console.log("result : ");
                console.log(this.offreObject);

                if ((this._record.VI_CodePostalRechercheLocal__c === "" || this._record.VI_CommuneRechercheLocal__c === "")
                    & this._record.VI_LocalNonIdentifieGenerationCase__c == true) {
                    this._title = 'Erreur';
                    this.message = "Si le local n'a pas été identifié, merci de renseigner à minima les champs de recherche 'Code postal' et 'Commune' à l'étape Identification local (par adresse)";
                    this.variant = 'error';
                    this.showNotification()
                    console.log(error.body.message);
                } else {
                    if (this.offreObject.offrePoussee !== undefined) {
                        this._record = result.parcours;
                        this.setOffrePousseValue();
                        this.setOffreRepliValue();
                        this.checkIfOffreAlreadySelected();
                        this.loaded = true;
                    } else {
                        if (this.offreObject.message === null) {
                            this._title = 'Erreur';
                            this.message = "Une erreur inconnu c'est produite, veuillez contacter votre administrateur";
                            this.variant = 'error';
                            this.showNotification();
                            console.log(this.message);
                        } else {
                            this._title = 'Erreur';
                            this.message = result.message;
                            this.variant = 'error';
                            this.showNotification();
                            console.log(this.message);
                        }
                    }
                }
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


    checkIfOffreAlreadySelected() {
        if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === "Offre poussée") {
            this.ajustMensPousseNum = Number(this._record.VI_AjustementMensualitesPanierClient__c);
            this.myAjustement = this.ajustMensPousseNum;
            this.colorAjustement();


            this.offrePousseTotalPrice = Number(this._record.VI_MontantdelaMensualitePanierClient__c).toFixed(0);

            this.offrePousseTotalPriceVar = Number(this._record.VI_MontantdelaMensualitePanierClient__c).toFixed(2);
            this.offrePousseTotalPriceVarRounded = Math.ceil(this.offrePousseTotalPriceVar);
            this.priceOffreSelected = Number(this._record.VI_MontantdelaMensualitePanierClient__c).toFixed(2);

            this.offreObjectoffrePousseprixElecCoHT = this._record.VI_EleckWhHTPanierClient__c;
            this.offreObjectoffrePousseprixElecCoTTC = this._record.VI_EleckWhTTCPanierClient__c;
            if (this.isHPHC) {
                this.offreObjectoffrePousseprixElecCoTTCHC = this._record.VI_EleckWhTTCHCPanierClient__c;
                this.offreObjectoffrePousseprixElecCoHTHC = this._record.VI_EleckWhHTHCPanierClient__c;
            }
            this.offreObjectoffrePousseprixGazCoHT = this._record.VI_GazkWhHTPanierClient__c;
            this.offreObjectoffrePousseprixGazCoTTC = this._record.VI_GazkWhTTCPanierClient__c;
            this.offreObjectoffrePousseprixGazAboHT = this._record.VI_AbonnementAnnuelGazHTPanierClient__c;
            this.offreObjectoffrePousseprixGazAboTTC = this._record.VI_AbonnementAnnuelGazTTCPanierClient__c;
            this.offreObjectoffrePousseprixElecAboHT = this._record.VI_AbonnementAnnuelElecHTPanierClient__c;
            this.offreObjectoffrePousseprixElecAboTTC = this._record.VI_AbonnementAnnuelElecTTCPanierClient__c;

            this.priceOffreSelected = this._record.VI_MontantdelaMensualitePanierClient__c;

            this.turnOffrePrincIntoGreen();

            if (this.ajustMensPousseNum === 0) {
                this.isPousseMensuNot0 = false;
            } else {
                this.isPousseMensuNot0 = true;
            }

            if (this.ajustMensPousseNum === 10) {
                this.showButtonPlusPousse = true;
                this.viModalButtonPlusMensualitePousse = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
            }
            if (this.ajustMensPousseNum === -10) {
                this.showButtonMoinsPousse = true;
                this.viModalButtonMinusMensualitePousse = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
            }
            this.nameOffreSelected = this.offreObject.offrePoussee.libelle;
            this.isOffreSelected = true;
        }

        if (this._record.VI_ChoixOffreSurParcoursPanierClient__c === "Offre de repli") {
            this.ajustMensRepliNum = Number(this._record.VI_AjustementMensualitesPanierClient__c);
            this.myAjustement = this.ajustMensRepliNum;
            this.colorAjustement();

            this.offreRepliTotalPrice = Number(this._record.VI_MontantdelaMensualitePanierClient__c).toFixed(0);
            this.offreRepliTotalPriceVar = Number(this._record.VI_MontantdelaMensualitePanierClient__c).toFixed(2);
            this.priceOffreSelected = Number(this._record.VI_MontantdelaMensualitePanierClient__c).toFixed(2);
            this.offreRepliTotalPriceVarRounded = Math.ceil(this.offreRepliTotalPriceVar);

            this.offreObjectoffreDeReplisprixElecCoHT = this._record.VI_EleckWhHTPanierClient__c;
            this.offreObjectoffreDeReplisprixElecCoTTC = this._record.VI_EleckWhTTCPanierClient__c;
            if (this.isHPHC) {
                this.offreObjectoffreDeReplisprixElecCoTTCHC = this._record.VI_EleckWhHTHCPanierClient__c;
                this.offreObjectoffreDeReplisprixElecCoHTHC = this._record.VI_EleckWhTTCHCPanierClient__c;
            }
            this.offreObjectoffreDeReplisprixGazCoHT = this._record.VI_GazkWhHTPanierClient__c;
            this.offreObjectoffreDeReplisprixGazCoTTC = this._record.VI_GazkWhTTCPanierClient__c;
            this.offreObjectoffreDeReplisprixGazAboHT = this._record.VI_AbonnementAnnuelGazHTPanierClient__c;
            this.offreObjectoffreDeReplisprixGazAboTTC = this._record.VI_AbonnementAnnuelGazTTCPanierClient__c;
            this.offreObjectoffreDeReplisprixElecAboHT = this._record.VI_AbonnementAnnuelElecHTPanierClient__c;
            this.offreObjectoffreDeReplisprixElecAboTTC = this._record.VI_AbonnementAnnuelElecTTCPanierClient__c;

            this.turnOffreRepliIntoGreen();

            if (this.ajustMensRepliNum === 0) {
                this.isRepliMensuNot0 = false;
            } else {
                this.isRepliMensuNot0 = true;
            }

            if (this.ajustMensRepliNum === 10) {
                this.showButtonPlusRepli = true;
                this.viModalButtonPlusMensualiteRepli = "vi-modal-button-plus-mensualite borderColorGreyClass fontColorGreyClass";
            }
            if (this.ajustMensRepliNum === -10) {
                this.showButtonMoinsRepli = true;
                this.viModalButtonMinusMensualiteRepli = "vi-modal-button-minus-mensualite borderColorGreyClass fontColorGreyClass";
            }

            this.nameOffreSelected = this.offreObject.offreDeReplis.libelle;
            this.isOffreSelected = true;
        }
    }

    //sets the fields to null if they are empty
    handleUndefinedValues(recordField) {
        if (typeof this._record[recordField] === "undefined") {
            this._record[recordField] = null;
        }
    }

    setOffrePousseValue() {
        if (this.offreObject.offrePoussee.totalPrice !== undefined) {
            if (this.offreObject.offrePoussee.totalPrice === 0) {
                this.offerPousseClass = "container gazDivNoTotalPrice";
                this.ajusterNullTotalPriceClass = "text-center height7P";
                this.textIfPriceNullClass = "margin-top20P";
                this.totalPriceNotEgalZeroPousse = false;
            }
            this.offrePousseTotalPrice = this.offreObject.offrePoussee.totalPrice;
            this.variableValueForMensualitePousse = this.offrePousseTotalPrice / 100;
            this.offrePousseTotalPriceInitValue = this.offreObject.offrePoussee.totalPrice;
            this.offrePousseTotalPriceVar = this.offreObject.offrePoussee.totalPrice;
            this.offrePousseTotalPriceVarRounded = this.offreObject.offrePoussee.totalPrice;
        } else {
            if (this.offreObject.offrePoussee.totalPrice === 0) {
                this.offerPousseClass = "container gazDivNoTotalPrice";
                this.ajusterNullTotalPriceClass = "text-center height7P";
                this.textIfPriceNullClass = "margin-top20P";
                this.totalPriceNotEgalZeroPousse = false;
            }
        }

        if (this.offreObject.offrePoussee.libelle !== undefined) {
            this.offreObjectoffrePousseelibelle = this.offreObject.offrePoussee.libelle;

            this.Description_Offre_Principale1 = this.offreObject.offrePoussee.descriptif1;
            this.Description_Offre_principale_2 = this.offreObject.offrePoussee.descriptif2;

        }

        if (this.offreObject.offrePoussee.prixElec !== undefined) {

            if (this.offreObject.offrePoussee.prixElec.CoACHHCBHT !== undefined) {
                this.isAcheminement4QuadrantPoussee = true;
                this.offerPousseClass = "container gazDiv4QuadrantsSansGaz";
                this.positionOffreRepli = "row positionOffreRepli4QuadrantsSansGaz";
                this.gazTop = "top:25%;";
            }
            else if (this.offreObject.offrePoussee.prixElec.CoACHHCHT !== undefined) {
                this.isAcheminementHPHCPoussee = true;
                this.offerPousseClass = "container gazDiv2QuadrantsSansGaz";
                this.gazTop = "top:15%;";
            }
            else {
                this.isAcheminementBasePoussee = true;
                this.positionOffreRepli = "row positionOffreRepliBaseSansGaz";
            }


            if (this.offreObject.offrePoussee.prixElec.AboTTC !== undefined) {
                this.offreObjectoffrePousseprixElecAboTTC = this.offreObject.offrePoussee.prixElec.AboTTC.toFixed(3);
                this.offreObjectoffrePousseprixElecAboTTC2 = this.offreObject.offrePoussee.prixElec.AboTTC.toFixed(2);
            } else {
                this.isElecPousseNotNull = false;
                this.gazPrixGazDivPousseClass = "gazPrixElecDiv margin-top18";
            }
            if (this.offreObject.offrePoussee.prixElec.AboHT !== undefined) {
                this.offreObjectoffrePousseprixElecAboHT = this.offreObject.offrePoussee.prixElec.AboHT.toFixed(3);
                this.offreObjectoffrePousseprixElecAboHT2 = this.offreObject.offrePoussee.prixElec.AboHT.toFixed(2);
            } else {
                this.isElecPousseNotNull = false;
                this.gazPrixGazDivPousseClass = "gazPrixElecDiv margin-top18";
            }
            if (this.offreObject.offrePoussee.prixElec.CoTTC !== undefined) {
                this.offreObjectoffrePousseprixElecCoTTC = this.offreObject.offrePoussee.prixElec.CoTTC.toFixed(3);
                this.offreObjectoffrePousseprixElecCoTTC2 = this.offreObject.offrePoussee.prixElec.CoTTC.toFixed(2);

            } else {
                this.isElecPousseNotNull = false;
                this.gazPrixGazDivPousseClass = "gazPrixElecDiv margin-top18";
            }
            if (this.offreObject.offrePoussee.prixElec.CoHT !== undefined) {
                this.offreObjectoffrePousseprixElecCoHT = this.offreObject.offrePoussee.prixElec.CoHT.toFixed(3);
                this.offreObjectoffrePousseprixElecCoHT2 = this.offreObject.offrePoussee.prixElec.CoHT.toFixed(2);
            } else {
                this.isElecPousseNotNull = false;
                this.gazPrixGazDivPousseClass = "gazPrixElecDiv margin-top18";
            }
            if (this.offreObject.offrePoussee.prixElec.AboACHHT !== undefined) {
                this.offreObjectoffrePousseeprixElecAboACHHT = this.offreObject.offrePoussee.prixElec.AboACHHT.toFixed(2);
            }
            if (this.offreObject.offrePoussee.prixElec.AboACHTTC !== undefined) {
                this.offreObjectoffrePousseeprixElecAboACHTTC = this.offreObject.offrePoussee.prixElec.AboACHTTC.toFixed(2);
            }
            if (this.offreObject.offrePoussee.prixElec.TOTABHT !== undefined) {
                this.offreObjectoffrePousseeprixElecTOTABHT = this.offreObject.offrePoussee.prixElec.TOTABHT.toFixed(2);
            }
            if (this.offreObject.offrePoussee.prixElec.TOTAB !== undefined) {
                this.offreObjectoffrePousseeprixElecTOTAB = this.offreObject.offrePoussee.prixElec.TOTAB.toFixed(2);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHT !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHT = this.offreObject.offrePoussee.prixElec.CoACHHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHCHT !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHCHT = this.offreObject.offrePoussee.prixElec.CoACHHCHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHCBHT !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHCBHT = this.offreObject.offrePoussee.prixElec.CoACHHCBHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHPBHT !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHPBHT = this.offreObject.offrePoussee.prixElec.CoACHHPBHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHCHHT !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHCHHT = this.offreObject.offrePoussee.prixElec.CoACHHCHHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHPHHT !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHPHHT = this.offreObject.offrePoussee.prixElec.CoACHHPHHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.ObHT !== undefined) {
                this.offreObjectoffrePousseeprixElecObHT = this.offreObject.offrePoussee.prixElec.ObHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.TOTCOHT !== undefined) {
                this.offreObjectoffrePousseeprixElecTOTCOHT = this.offreObject.offrePoussee.prixElec.TOTCOHT.toFixed(3);
            }

            if (this.offreObject.offrePoussee.prixElec.CoACHTTC !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHTTC = this.offreObject.offrePoussee.prixElec.CoACHTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHCTTC !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHCTTC = this.offreObject.offrePoussee.prixElec.CoACHHCTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHCBTTC !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHCBTTC = this.offreObject.offrePoussee.prixElec.CoACHHCBTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHPBTTC !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHPBTTC = this.offreObject.offrePoussee.prixElec.CoACHHPBTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHCHTTC !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHCHTTC = this.offreObject.offrePoussee.prixElec.CoACHHCHTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.CoACHHPHTTC !== undefined) {
                this.offreObjectoffrePousseeprixElecCoACHHPHTTC = this.offreObject.offrePoussee.prixElec.CoACHHPHTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.ObTTC !== undefined) {
                this.offreObjectoffrePousseeprixElecObTTC = this.offreObject.offrePoussee.prixElec.ObTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixElec.TOTCO !== undefined) {
                this.offreObjectoffrePousseeprixElecTOTCO = this.offreObject.offrePoussee.prixElec.TOTCO.toFixed(3);
            }



            if (this.isHPHC) {
                if (this.offreObject.offrePoussee.prixElec.CoTTCHC !== undefined) {
                    this.offreObjectoffrePousseprixElecCoTTCHC = this.offreObject.offrePoussee.prixElec.CoTTCHC.toFixed(3);
                } else {
                    this.isElecPousseNotNull = false;
                    this.gazPrixGazDivPousseClass = "gazPrixElecDiv margin-top18";
                }
                if (this.offreObject.offrePoussee.prixElec.CoHTHC !== undefined) {
                    this.offreObjectoffrePousseprixElecCoHTHC = this.offreObject.offrePoussee.prixElec.CoHTHC.toFixed(3);
                } else {
                    this.isElecPousseNotNull = false;
                    this.gazPrixGazDivPousseClass = "gazPrixElecDiv margin-top18";
                }
            }
        } else {
            this.isElecPousseNotNull = false;
            this.gazPrixGazDivPousseClass = "gazPrixElecDiv margin-top18";
        }

        if (this.offreObject.offrePoussee.prixGaz !== undefined) {
            if (this.offreObject.offrePoussee.prixGaz.AboTTC !== undefined) {
                this.offreObjectoffrePousseprixGazAboTTC = this.offreObject.offrePoussee.prixGaz.AboTTC.toFixed(3);
                this.offreObjectoffrePousseprixGazAboTTC2 = this.offreObject.offrePoussee.prixGaz.AboTTC.toFixed(2);
            } else {
                this.isGazPousseNotNull = false;
                this.ElecDivPousseClass = "gazPrixElecDiv margin-top19";
            }
            if (this.offreObject.offrePoussee.prixGaz.AboHT !== undefined) {
                this.offreObjectoffrePousseprixGazAboHT = this.offreObject.offrePoussee.prixGaz.AboHT.toFixed(3);
                this.offreObjectoffrePousseprixGazAboHT2 = this.offreObject.offrePoussee.prixGaz.AboHT.toFixed(2);
            } else {
                this.isGazPousseNotNull = false;
                this.ElecDivPousseClass = "gazPrixElecDiv margin-top19";
            }
            if (this.offreObject.offrePoussee.prixGaz.CoTTC !== undefined) {
                this.offreObjectoffrePousseprixGazCoTTC = this.offreObject.offrePoussee.prixGaz.CoTTC.toFixed(3);
            } else {
                this.isGazPousseNotNull = false;
                this.ElecDivPousseClass = "gazPrixElecDiv margin-top19";
            }
            if (this.offreObject.offrePoussee.prixGaz.AboACHHT !== undefined) {
                this.offreObjectoffrePousseprixGazAboACHHT = this.offreObject.offrePoussee.prixGaz.AboACHHT.toFixed(2);
            }
            if (this.offreObject.offrePoussee.prixGaz.TOTABHT !== undefined) {
                this.offreObjectoffrePousseprixGazTOTABHT = this.offreObject.offrePoussee.prixGaz.TOTABHT.toFixed(2);
            }
            if (this.offreObject.offrePoussee.prixGaz.AboACHTTC !== undefined) {
                this.offreObjectoffrePousseprixGazAboACHTTC = this.offreObject.offrePoussee.prixGaz.AboACHTTC.toFixed(2);
            }
            if (this.offreObject.offrePoussee.prixGaz.TOTAB !== undefined) {
                this.offreObjectoffrePousseprixGazTOTAB = this.offreObject.offrePoussee.prixGaz.TOTAB.toFixed(2);
            }

            if (this.offreObject.offrePoussee.prixGaz.CoACHHT !== undefined) {
                this.offreObjectoffrePousseprixGazCoACHHT = this.offreObject.offrePoussee.prixGaz.CoACHHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixGaz.ObHT !== undefined) {
                this.offreObjectoffrePousseprixGazObHT = this.offreObject.offrePoussee.prixGaz.ObHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixGaz.TOTCOHT !== undefined) {
                this.offreObjectoffrePousseprixGazTOTCOHT = this.offreObject.offrePoussee.prixGaz.TOTCOHT.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixGaz.CoACHTTC !== undefined) {
                this.offreObjectoffrePousseprixGazCoACHTTC = this.offreObject.offrePoussee.prixGaz.CoACHTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixGaz.ObTTC !== undefined) {
                this.offreObjectoffrePousseprixGazObTTC = this.offreObject.offrePoussee.prixGaz.ObTTC.toFixed(3);
            }
            if (this.offreObject.offrePoussee.prixGaz.TOTCO !== undefined) {
                this.offreObjectoffrePousseprixGazTOTCO = this.offreObject.offrePoussee.prixGaz.TOTCO.toFixed(3);
            }

            if (this.offreObject.offrePoussee.prixGaz.CoHT !== undefined) {
                this.offreObjectoffrePousseprixGazCoHT = this.offreObject.offrePoussee.prixGaz.CoHT.toFixed(3);
            } else {
                this.isGazPousseNotNull = false;
                this.ElecDivPousseClass = "gazPrixElecDiv margin-top19";
            }

            if (this.offerPousseClass === "container gazDiv4QuadrantsSansGaz") {
                this.offerPousseClass = "container gazDiv4QuadrantsAvecGaz";
                this.positionOffreRepli = "row positionOffreRepli4QuadrantsAvecGaz";
            }
            if (this.offerPousseClass === "container gazDiv2QuadrantsSansGaz") {
                this.offerPousseClass = "container gazDiv2QuadrantsAvecGaz";
                this.positionOffreRepli = "row positionOffreRepli2QuadrantsAvecGaz";
            }
            if (this.isAcheminementBasePoussee === true) {
                this.offerPousseClass = "container gazDiv2QuadrantsAvecGaz";
                this.positionOffreRepli = "row positionOffreRepli2QuadrantsAvecGaz";
                this.gazTop = "top:15%;";
            }


        } else {
            this.isGazPousseNotNull = false;
            this.ElecDivPousseClass = "gazPrixElecDiv margin-top19";
        }
        if (this.isElecPousseNotNull == true && this.isGazPousseNotNull == true && this.totalPriceNotEgalZeroPousse == true) {
            this.isDualPousse = true;
        }
    }

    setOffreRepliValue() {
        if (this.offreObject.offreDeReplis !== undefined) {

            if (this.offreObject.offreDeReplis.totalPrice !== undefined) {
                if (this.offreObject.offreDeReplis.totalPrice === 0) {
                    this.offerRepliClass = "container gazDivNoTotalPrice";
                    this.ajusterNullTotalPriceRepliClass = "text-center height7P";
                    this.textIfPriceNullRepliClass = "margin-top20P";
                    this.totalPriceNotEgalZeroRepli = false;
                }
                this.offreRepliTotalPrice = this.offreObject.offreDeReplis.totalPrice;
                this.variableValueForMensualiteRepli = this.offreRepliTotalPrice / 100;

                this.offreRepliTotalPriceInitValue = this.offreObject.offreDeReplis.totalPrice;
                this.offreRepliTotalPriceVar = this.offreObject.offreDeReplis.totalPrice;
                this.offreRepliTotalPriceVarRounded = Math.ceil(this.offreRepliTotalPriceVar);
            } else {
                if (this.offreObject.offreDeReplis.totalPrice === 0) {
                    this.offerRepliClass = "container gazDivNoTotalPrice";
                    this.ajusterNullTotalPriceRepliClass = "text-center height7P";
                    this.textIfPriceNullRepliClass = "margin-top20P";
                    this.totalPriceNotEgalZeroRepli = false;
                }
            }

            if (this.offreObject.offreDeReplis.libelle !== undefined) {
                this.offreObjectoffreDeReplislibelle = this.offreObject.offreDeReplis.libelle;

                this.Description_Offre_Repli_1 = this.offreObject.offreDeReplis.descriptif1;
                this.Description_Offre_Repli_2 = this.offreObject.offreDeReplis.descriptif2;

            }

            if (this.offreObject.offreDeReplis.prixElec !== undefined) {
                if (this.offreObject.offreDeReplis.prixElec.CoACHHCBHT !== undefined) {
                    this.isAcheminement4Quadrant = true;
                    this.offerRepliClass = "container gazDiv4QuadrantsSansGaz";
                    this.positionOptions = 'row positionOptionsSansGaz'
                    this.gazTopRepli = "top:27%";
                }
                else if (this.offreObject.offreDeReplis.prixElec.CoACHHCHT !== undefined) {
                    this.isAcheminementHPHC = true;
                    this.offerRepliClass = "container gazDiv2QuadrantsSansGaz";
                }
                else {
                    this.isAcheminementBase = true;
                    this.offerRepliClass = "container gazDivBaseSansGaz";
                    this.gazTopRepli = "top:12%";
                }


                if (this.offreObject.offreDeReplis.prixElec.AboTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecAboTTC = this.offreObject.offreDeReplis.prixElec.AboTTC.toFixed(3);
                    this.offreObjectoffreDeReplisprixElecAboTTC2 = this.offreObject.offreDeReplis.prixElec.AboTTC.toFixed(2);
                } else {
                    this.isElecRepliNotNull = false;
                    this.gazPrixGazDivClass = "gazPrixElecDiv margin-top18";
                }
                if (this.offreObject.offreDeReplis.prixElec.AboHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecAboHT = this.offreObject.offreDeReplis.prixElec.AboHT.toFixed(3);
                    this.offreObjectoffreDeReplisprixElecAboHT2 = this.offreObject.offreDeReplis.prixElec.AboHT.toFixed(2);
                } else {
                    this.isElecRepliNotNull = false;
                    this.gazPrixGazDivClass = "gazPrixElecDiv margin-top18";
                }
                if (this.offreObject.offreDeReplis.prixElec.CoTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoTTC = this.offreObject.offreDeReplis.prixElec.CoTTC.toFixed(3);
                } else {
                    this.isElecRepliNotNull = false;
                    this.gazPrixGazDivClass = "gazPrixElecDiv margin-top18";
                }
                if (this.offreObject.offreDeReplis.prixElec.CoHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoHT = this.offreObject.offreDeReplis.prixElec.CoHT.toFixed(3);
                } else {
                    this.isElecRepliNotNull = false;
                    this.gazPrixGazDivClass = "gazPrixElecDiv margin-top18";
                }

                if (this.offreObject.offreDeReplis.prixElec.AboACHHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecAboACHHT = this.offreObject.offreDeReplis.prixElec.AboACHHT.toFixed(2);
                }
                if (this.offreObject.offreDeReplis.prixElec.TOTABHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecTOTABHT = this.offreObject.offreDeReplis.prixElec.TOTABHT.toFixed(2);
                }
                if (this.offreObject.offreDeReplis.prixElec.AboACHTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecAboACHTTC = this.offreObject.offreDeReplis.prixElec.AboACHTTC.toFixed(2);
                }
                if (this.offreObject.offreDeReplis.prixElec.TOTAB !== undefined) {
                    this.offreObjectoffreDeReplisprixElecTOTAB = this.offreObject.offreDeReplis.prixElec.TOTAB.toFixed(2);
                }


                if (this.offreObject.offreDeReplis.prixElec.CoACHHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHT = this.offreObject.offreDeReplis.prixElec.CoACHHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHCHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHCHT = this.offreObject.offreDeReplis.prixElec.CoACHHCHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHCBHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHCBHT = this.offreObject.offreDeReplis.prixElec.CoACHHCBHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHPBHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHPBHT = this.offreObject.offreDeReplis.prixElec.CoACHHPBHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHCHHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHCHHT = this.offreObject.offreDeReplis.prixElec.CoACHHCHHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHPHHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHPHHT = this.offreObject.offreDeReplis.prixElec.CoACHHPHHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.ObHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecObHT = this.offreObject.offreDeReplis.prixElec.ObHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.TOTCOHT !== undefined) {
                    this.offreObjectoffreDeReplisprixElecTOTCOHT = this.offreObject.offreDeReplis.prixElec.TOTCOHT.toFixed(3);
                }

                if (this.offreObject.offreDeReplis.prixElec.CoACHTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHTTC = this.offreObject.offreDeReplis.prixElec.CoACHTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHCTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHCTTC = this.offreObject.offreDeReplis.prixElec.CoACHHCTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHCBTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHCBTTC = this.offreObject.offreDeReplis.prixElec.CoACHHCBTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHPBTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHPBTTC = this.offreObject.offreDeReplis.prixElec.CoACHHPBTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHCHTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHCHTTC = this.offreObject.offreDeReplis.prixElec.CoACHHCHTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.CoACHHPHTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecCoACHHPHTTC = this.offreObject.offreDeReplis.prixElec.CoACHHPHTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.ObTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixElecObTTC = this.offreObject.offreDeReplis.prixElec.ObTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixElec.TOTCO !== undefined) {
                    this.offreObjectoffreDeReplisprixElecTOTCO = this.offreObject.offreDeReplis.prixElec.TOTCO.toFixed(3);
                }




                if (this.isHPHC) {
                    if (this.offreObject.offreDeReplis.prixElec.CoTTCHC !== undefined) {
                        this.offreObjectoffreDeReplisprixElecCoTTCHC = this.offreObject.offreDeReplis.prixElec.CoTTCHC.toFixed(3);
                    } else {
                        this.isElecRepliNotNull = false;
                        this.gazPrixGazDivClass = "gazPrixElecDiv margin-top18";
                    }
                    if (this.offreObject.offreDeReplis.prixElec.CoHTHC !== undefined) {
                        this.offreObjectoffreDeReplisprixElecCoHTHC = this.offreObject.offreDeReplis.prixElec.CoHTHC.toFixed(3);
                    } else {
                        this.isElecRepliNotNull = false;
                        this.gazPrixGazDivClass = "gazPrixElecDiv margin-top18";
                    }
                }
            } else {
                this.isElecRepliNotNull = false;
                this.gazPrixGazDivClass = "gazPrixElecDiv margin-top18";
            }

            if (this.offreObject.offreDeReplis.prixGaz !== undefined) {
                if (this.offreObject.offreDeReplis.prixGaz.AboTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixGazAboTTC = this.offreObject.offreDeReplis.prixGaz.AboTTC.toFixed(3);
                    this.offreObjectoffreDeReplisprixGazAboTTC2 = this.offreObject.offreDeReplis.prixGaz.AboTTC.toFixed(2);
                } else {
                    this.isGazRepliNotNull = false;
                    this.ElecDivClass = "gazPrixElecDiv margin-top19";
                }
                if (this.offreObject.offreDeReplis.prixGaz.AboHT !== undefined) {
                    this.offreObjectoffreDeReplisprixGazAboHT = this.offreObject.offreDeReplis.prixGaz.AboHT.toFixed(3);
                    this.offreObjectoffreDeReplisprixGazAboHT2 = this.offreObject.offreDeReplis.prixGaz.AboHT.toFixed(2);
                } else {
                    this.isGazRepliNotNull = false;
                    this.ElecDivClass = "gazPrixElecDiv margin-top19";
                }
                if (this.offreObject.offreDeReplis.prixGaz.CoTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixGazCoTTC = this.offreObject.offreDeReplis.prixGaz.CoTTC.toFixed(3);
                } else {
                    this.isGazRepliNotNull = false;
                    this.ElecDivClass = "gazPrixElecDiv margin-top19";
                }
                if (this.offreObject.offreDeReplis.prixGaz.CoHT !== undefined) {
                    this.offreObjectoffreDeReplisprixGazCoHT = this.offreObject.offreDeReplis.prixGaz.CoHT.toFixed(3);
                } else {
                    this.isGazRepliNotNull = false;
                    this.ElecDivClass = "gazPrixElecDiv margin-top19";
                }
                if (this.offerRepliClass === "container gazDiv4QuadrantsSansGaz") {
                    this.offerRepliClass = "container gazDiv4QuadrantsAvecGaz";
                    this.positionOptions = 'row positionOptionsAvecGaz'
                }
                if (this.offerRepliClass === "container gazDiv2QuadrantsSansGaz") {
                    this.offerRepliClass = "container gazDiv2QuadrantsAvecGaz";
                }

                if (this.offerRepliClass === "container gazDivBaseSansGaz") {
                    this.offerRepliClass = "container gazDivBaseAvecGaz";
                    this.positionOptions = "row positionOffreRepliBaseAvecGaz";
                }
                if (this.offreObject.offreDeReplis.prixGaz.AboACHHT !== undefined) {
                    this.offreObjectoffreDeReplisprixGazAboACHHT = this.offreObject.offreDeReplis.prixGaz.AboACHHT.toFixed(2);
                }
                if (this.offreObject.offreDeReplis.prixGaz.TOTABHT !== undefined) {
                    this.offreObjectoffreDeReplisprixGazTOTABHT = this.offreObject.offreDeReplis.prixGaz.TOTABHT.toFixed(2);
                }
                if (this.offreObject.offreDeReplis.prixGaz.AboACHTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixGazAboACHTTC = this.offreObject.offreDeReplis.prixGaz.AboACHTTC.toFixed(2);
                }
                if (this.offreObject.offreDeReplis.prixGaz.TOTAB !== undefined) {
                    this.offreObjectoffreDeReplisprixGazTOTAB = this.offreObject.offreDeReplis.prixGaz.TOTAB.toFixed(2);
                }


                if (this.offreObject.offreDeReplis.prixGaz.CoACHHT !== undefined) {
                    this.offreObjectoffreDeReplisprixGazCoACHHT = this.offreObject.offreDeReplis.prixGaz.CoACHHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixGaz.ObHT !== undefined) {
                    this.offreObjectoffreDeReplisprixGazObHT = this.offreObject.offreDeReplis.prixGaz.ObHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixGaz.TOTCOHT !== undefined) {
                    this.offreObjectoffreDeReplisprixGazTOTCOHT = this.offreObject.offreDeReplis.prixGaz.TOTCOHT.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixGaz.CoACHTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixGazCoACHTTC = this.offreObject.offreDeReplis.prixGaz.CoACHTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixGaz.ObTTC !== undefined) {
                    this.offreObjectoffreDeReplisprixGazObTTC = this.offreObject.offreDeReplis.prixGaz.ObTTC.toFixed(3);
                }
                if (this.offreObject.offreDeReplis.prixGaz.TOTCO !== undefined) {
                    this.offreObjectoffreDeReplisprixGazTOTCO = this.offreObject.offreDeReplis.prixGaz.TOTCO.toFixed(3);
                }


            } else {
                this.isGazRepliNotNull = false;
                this.ElecDivClass = "gazPrixElecDiv margin-top19";
            }
        }
        else {
            this.isOffreDeRepliNotNull = false;
        }
        if (this.isElecRepliNotNull == true && this.isGazRepliNotNull == true && this.totalPriceNotEgalZeroRepli == true) {
            this.isDualRepli = true;
        }

    }

    turnOffrePrincIntoGreen() {
        this.imageOffrePousseGaz = this.gazImageVert;
        this.imageOffrePousseElec = this.elecImageVert;
        this.imageOffreRepliGaz = this.gazImage;
        this.imageOffreRepliElec = this.elecImage;

        this.buttonLabelRepli = "Choisir cette offre";
        this.buttonLabelPousse = "Offre choisie";

        this.divStyle = 'gazHeader backgroundColorBlueClass';
        this.totalPriceDiv = 'font-size50px fontColorBlueClass';
        this.TotalPriceDevice = 'font-size30px fontColorBlueClass';
        this.imageClass = 'height130P font-size30px fontColorBlueClass';
        this.ajusterButtonClass = 'fontColorBlueClass underlineText font-size20px';
        this.choisirButtonClass = 'buttonChoisir borderColorBlueClass backgroundColorBlueClass';
        this.tableHeaderClass = 'fontColorBlueClass font-size20px';
        this.traitClass = "backgroundColorBlueClass";
        this.traitGazClass = "OffrePousseGazTraitClass backgroundColorBlueClass";

        this.divStylePousse = 'gazHeader backgroundColorGreenClass';
        this.totalPricePousseDiv = 'font-size50px fontColorGreenClass';
        this.TotalPriceDevicePousse = 'font-size30px fontColorGreenClass';
        this.imagePousseClass = 'height130P font-size30px fontColorGreenClass';
        this.ajusterButtonPousseClass = 'fontColorGreenClass underlineText font-size20px';
        this.choisirButtonPousseClass = 'buttonChoisir borderColorGreenClass backgroundColorGreenClass';
        this.tableHeaderPousseClass = 'fontColorGreenClass font-size20px';
        this.traitPousseClass = "backgroundColorGreenClass";
        this.traitGazPousseClass = "OffrePousseGazTraitClass backgroundColorGreenClass";
        this.offerPousseStyle = "border-color: rgba(0, 153, 52, 1)";
        if (this.offreObject.offreDeReplis !== undefined) {
            this.offerStyle = "border-color: var(--cerulean);";
        }
    }

    turnOffreRepliIntoGreen() {
        this.imageOffrePousseGaz = this.gazImage;
        this.imageOffrePousseElec = this.elecImage;
        this.imageOffreRepliGaz = this.gazImageVert;
        this.imageOffreRepliElec = this.elecImageVert;

        this.buttonLabelPousse = "Choisir cette offre";
        this.buttonLabelRepli = "Offre Choisie";

        this.divStyle = 'gazHeader backgroundColorGreenClass';
        this.totalPriceDiv = 'font-size50px fontColorGreenClass';
        this.TotalPriceDevice = 'font-size30px fontColorGreenClass';
        this.imageClass = 'height130P font-size30px fontColorGreenClass';
        this.ajusterButtonClass = 'fontColorGreenClass underlineText font-size20px';
        this.choisirButtonClass = 'buttonChoisir borderColorGreenClass backgroundColorGreenClass';
        this.tableHeaderClass = 'fontColorGreenClass font-size20px';
        this.traitClass = "backgroundColorGreenClass";
        this.traitGazClass = "OffrePousseGazTraitClass backgroundColorGreenClass";

        this.divStylePousse = 'gazHeader backgroundColorBlueClass';
        this.totalPricePousseDiv = 'font-size50px fontColorBlueClass';
        this.TotalPriceDevicePousse = 'font-size30px fontColorBlueClass';
        this.imagePousseClass = 'height130P font-size30px fontColorBlueClass';
        this.ajusterButtonPousseClass = 'fontColorBlueClass underlineText font-size20px';
        this.choisirButtonPousseClass = 'buttonChoisir borderColorBlueClass backgroundColorBlueClass';
        this.tableHeaderPousseClass = 'fontColorBlueClass font-size20px';
        this.traitPousseClass = "backgroundColorBlueClass";
        this.traitGazPousseClass = "OffrePousseGazTraitClass backgroundColorBlueClass";
        this.offerStyle = "border-color: rgba(0, 153, 52, 1);";
        this.offerPousseStyle = "border-color: var(--cerulean)";
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