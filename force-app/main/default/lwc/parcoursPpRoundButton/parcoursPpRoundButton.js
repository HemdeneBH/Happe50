import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import writeComment from '@salesforce/apex/VI_ParcoursPpRoundButton_Controller.writeComment';
import createTask from '@salesforce/apex/VI_ParcoursPpRoundButton_Controller.createTask';
import annulerParcours from '@salesforce/apex/VI_ParcoursPpRoundButton_Controller.annulerParcours';
import transfererParcours from '@salesforce/apex/VI_ParcoursPpRoundButton_Controller.transfererParcours';
import reprendrePlutardSansTache from '@salesforce/apex/VI_ParcoursPpRoundButton_Controller.reprendrePlutardSansTache';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PARCOURS_OBJECT from '@salesforce/schema/VI_Parcours__c';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import HomePageRedirectLink from '@salesforce/label/c.VI_HomePageRedirectLink';


export default class ParcoursPpRoundButton extends NavigationMixin(LightningElement) {

    @track error;
    @track currentUserName;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.currentUserName = data.fields.Name.value;
        }
    }

    @api
	get parcours() {
		return this._parcours;
	}
	set parcours(value) {
        if (value) {
            this._parcours = { ...value };
        }
    }

    @api
	get recordupdated() {
		return this._recordupdated;
	}
	set recordupdated(value) {
		this._recordupdated = value;
	}

    commentaireImage = EngieCommunityResource + '/EngieAssets/pictures/crayon-commentaire.png';
    phonecallImage = EngieCommunityResource + '/EngieAssets/pictures/transfert-appel.png';
    triangleImage = EngieCommunityResource + '/EngieAssets/pictures/triangle-popup.png';
    closeImage = EngieCommunityResource + '/EngieAssets/pictures/close-icon.png';
    chronoImage = EngieCommunityResource + '/EngieAssets/pictures/chrono-reprendre-ult.png';
    supprImage = EngieCommunityResource + '/EngieAssets/pictures/corbeille-suppr-comm.png';
    checkedImage = EngieCommunityResource + '/EngieAssets/pictures/checked.png';
    aideImage = EngieCommunityResource + '/EngieAssets/pictures/5-panier-client2.png';

    commentTransfert = '';
    comment = '';
    commentTask = '';
    commentAnnulation = '';
    date;
    time = '';
    motifJS = '';
    description = '';
    scriptDescrition = '';
    isModalOpen = false;
    isModal1Open = false;
    isModal2Open = false;
    isModal3Open = false;
    isModal4Open = false;
    isModal5Open = false;
    showDropdown = false;
    planATask = true;
    justClicked = false;
    canContinue = true;
    isUncomplete = false;
    motifRequired = false;
    // Start - DDPCM 105
    commentRequired = false;
    // End - DDPCM 105
    dateValidation = false;
    timeValidation = false;
    planTaskaskValidation = false;
    timeAnterieur = false;
    dateAnterieur = false;
    // Start - DDPCM 106
    notWorkingHour = false;
    // End - DDPCM 106
    timeWrongFormat = false;
    titreScript = "";

    firstString = "";
    secondString = "";

    @wire(getObjectInfo, { objectApiName: PARCOURS_OBJECT }) parcoursObjectInfo;

    @wire(getPicklistValues, { recordTypeId: '$parcoursObjectInfo.data.defaultRecordTypeId', fieldApiName: 'VI_Parcours__c.VI_MotifAnnulationParcours__c' }) MotifPicklistValues;

    @api firstload; // A supprimer, risque de conflit ac HTML LWC 'Content' ?
    @api currentstepvalue;
    @api recorddonnee;

    firstLoadJS = true;

    closeAllModal() {
        this.isModalOpen = false;
        this.isModal1Open = false;
        this.isModal2Open = false;
        this.isModal3Open = false;
        this.isModal4Open = false;
        this.isModal5Open = false;
    }




    // Open / close Modal1
    openModal1() {
        this.isModalOpen = true;
        this.isModal1Open = true;
    }

    closeModal1() {
        this.isModalOpen = false;
        this.isModal1Open = false;
    }

    // Open / close Modal1
    @api openModal2() {
        this.isModalOpen = true;
        this.isModal2Open = true;
        if ((this.currentstepvalue === "situation" || this.currentstepvalue === "energy") && this.parcours.VI_CommentaireGeneral_idbesoin__c) {
            this.comment = this.parcours.VI_CommentaireGeneral_idbesoin__c;
        } else if (this.currentstepvalue === "client_energy" && this.parcours.VI_CommentaireGeneral_idclient__c) {
            this.comment = this.parcours.VI_CommentaireGeneral_idclient__c;
        } else if (this.currentstepvalue === "identification_local" && this.parcours.VI_CommentaireGeneral_idlocal__c) {
            this.comment = this.parcours.VI_CommentaireGeneral_idlocal__c;
        } else if (this.currentstepvalue === "EstimationConsommation" && this.parcours.VI_CommentaireGeneral_EstimationConso__c) {
            this.comment = this.parcours.VI_CommentaireGeneral_EstimationConso__c;
        } else if (this.currentstepvalue === "ConstitutionPanier" && this.parcours.VI_CommentaireGeneral_Constitutionpanier__c) {
            this.comment = this.parcours.VI_CommentaireGeneral_Constitutionpanier__c;
        }
        else if ((this.currentstepvalue === "DateEffetContrat" || this.currentstepvalue === "RelevesCompteur") && this.parcours.VI_CommentaireGeneral_InfosCompl__c) {
            this.comment = this.parcours.VI_CommentaireGeneral_InfosCompl__c;
        }
        else if (this.currentstepvalue === "Saisie_moyen_de_paiement" && this.parcours.VI_CommentaireGeneral_MoyensPaiement__c) {
            this.comment = this.parcours.VI_CommentaireGeneral_MoyensPaiement__c;
        }
        else if (this.currentstepvalue === "Recapitulatif" && this.parcours.VI_CommentairesParcours__c) {
            this.comment = this.parcours.VI_CommentairesParcours__c;
        } else {
            this.comment = "";
        }
    }

    closeModal2() {
        this.isModalOpen = false;
        this.isModal2Open = false;
    }

    // Open / close Modal1
    openModal3() {
        this.isModalOpen = true;
        this.isModal3Open = true;
    }

    closeModal3() {
        this.date = '';
        this.time = '';
        this.commentTask = '';
        this.planATask = true;
        this.isModalOpen = false;
        this.isModal3Open = false;
    }

    // Open / close Modal1
    openModal4() {
        this.isModalOpen = true;
        this.isModal4Open = true;
    }

    closeModal4() {
        this.motifJS = null;
        this.commentAnnulation = null;
        this.isModalOpen = false;
        this.isModal4Open = false;
    }


    // Open / close Modal1
    openModal5() {
        this.isModalOpen = true;
        this.isModal5Open = true;
        this.setVariableForScript();
    }

    closeModal5() {
        this.isModalOpen = false;
        this.isModal5Open = false;
    }

    // Méthodes utilitaires
    changeCommentaire(event) {
        this.comment = event.target.value;
    }
    changeCommentaireTransfert(event) {
        this.commentTransfert = event.target.value;
    }
    changeCommentaireAnnulation(event) {
        this.commentAnnulation = event.target.value;
    }


    changeDate(event) {
        this.date = new Date(event.target.value);;
        this.dateValidation = false;
        this.dateAnterieur = false;
    }

    openList() {
        this.showDropdown = !(this.showDropdown);
        this.timeValidation = false;
        this.timeAnterieur = false;
        if (this.showDropdown) {
            this.justClicked = true;
        }
    }

    hideDropdownList() {
        if (this.justClicked) {
            this.justClicked = false;
        } else {
            this.showDropdown = false;
        }
    }

    selectValue(event) {
        this.time = event.target.title;

        this.timeValidation = false;
        this.timeAnterieur = false;

        this.notWorkingHour = false

        this.showDropdown = !(this.showDropdown);
    }

    selectMotif(event) {
        this.motifJS = event.target.title;
        this.motifRequired = false;
        // Start - DDPCM 105
        this.commentRequired = false;
        // END - DDPCM 105
        this.showDropdown = false;
    }

    check() {
        this.planATask = !this.planATask;
        this.planTaskaskValidation = false;
    }

    changeTime(event) {
        this.time = event.target.value;
        this.timeValidation = false;
        this.timeAnterieur = false;
    }

    changeDescription(event) {
        this.description = event.target.value;
    }

    changeCommentaireTask(event) {
        this.commentTask = event.target.value;
    }

    changeMotif(event) {
        this.motifJS = event.target.value;
    }

    transferer() {
        transfererParcours({
            parcours: this.parcours,
            comments: this.commentTransfert
        });
        this.isModalOpen = false;
        this.isModal1Open = false;
    }

    writeComments(event) {
        const dispatchEventBis = new CustomEvent("saverecord");
        this.dispatchEvent(dispatchEventBis);
        event.preventDefault();
		event.stopPropagation();

        const dispatchEvent = new CustomEvent("handlesavecomment", {
            detail: {
                comment: this.comment,
                step: this.currentstepvalue
            }
        });
        this.dispatchEvent(dispatchEvent);


        writeComment({
            parcours: this.parcours,
            comments: this.comment,
            step: this.currentstepvalue
        });
        this.isModalOpen = false;
        this.isModal2Open = false;
        this.firstLoadJS = false;
    }

    reprendrePlutard() {
        this.parcours.VI_StatutParcours__c = 'Vente à compléter';
        reprendrePlutardSansTache({
            parcours: this.parcours,
            comments: this.commentTask
        })
        this.navigateToHomePage();
        this.closeAllModal();
    }

    planTask() {
        this.isUncomplete = false;
        this.dateAnterieur = false;
        this.timeAnterieur = false;
        this.timeWrongFormat = false;
        /* Start - DDPCM 106*/
        this.notWorkingHour = false;
        /* End - DDPCM 106*/
        let handleTaskChecked = this.handleTaskCreation();
        if (handleTaskChecked === true) {
            createTask({
                parcours: this.parcours,

                dateEcheance: this.date,
                heureEcheance: this.time,
                description: this.description,

                comments: this.commentTask,
                planTask: this.planATask
            });
            this.navigateToHomePage();
            this.isModalOpen = false;
            this.isModal3Open = false;
        }
        /*else{
                this.isUncompletdateAnterieur = false;
                        this.e = true;
        }*/
    }

    handleTaskCreation() {
        let taskValidationchecked = true;
        var today = new Date();
        var selectedDate = new Date();
        var sameDay = false;
        var timeHours = parseInt(this.time.slice(0, 2), 10);
        var timeMinutes = parseInt(this.time.slice(3, 5), 10);
        if (this.planATask === false) {
            this.planTaskaskValidation = true;
            taskValidationchecked = false;
        }
        else {
            if (this.date !== undefined) {
                if (this.date.getFullYear() === today.getFullYear() && this.date.getMonth() === today.getMonth() && this.date.getDate() === today.getDate()) {
                    sameDay = true;
                }
            }
            if (this.date === undefined || isNaN(this.date)) {
                this.isUncomplete = true;
                return false;
            }
            else {
                selectedDate.setFullYear(this.date.getFullYear());
                selectedDate.setMonth(this.date.getMonth());
                selectedDate.setDate(this.date.getDate());
            }
            if (selectedDate < today) {
                this.dateAnterieur = true;
                taskValidationchecked = false;
            }
            if (this.time == '') {
                this.isUncomplete = true;
                taskValidationchecked = false;
            }
            else if (!(/^[0-9]{2}:[0-9]{2}$/.test(this.time))) {
                this.timeWrongFormat = true;
                taskValidationchecked = false;
            }
            else if (Number(this.time.slice(0, 2)) > 23 || Number(this.time.slice(3, 5)) > 59) {
                this.timeWrongFormat = true;
                taskValidationchecked = false;
            }
            /* Start - DDPCM 106*/
            else if (Number(this.time.slice(0, 2)) < 8 || Number(this.time.slice(0, 2)) > 19) {
                if (!(Number(this.time.slice(0, 2)) === 20 && Number(this.time.slice(3, 5)) < 1)) {
                    this.notWorkingHour = true;
                    taskValidationchecked = false;
                }
            }
            /* End - DDPCM 106*/
            else if (sameDay === true && timeHours < today.getHours()) {
                this.timeAnterieur = true;
                taskValidationchecked = false;
            } else if (sameDay === true && timeHours === today.getHours() && timeMinutes < today.getMinutes()) {
                this.timeAnterieur = true;
                taskValidationchecked = false;
            }
        }
        return taskValidationchecked;
    }

    cancelParcours() {
        if (this.motifJS === "") {
            this.motifRequired = true;
        }
        // Start - DDPCM 105
        else if (this.motifJS === "Autre" && (this.commentAnnulation === "" || this.commentAnnulation === null)) {
            this.commentRequired = true;
        }
        // END - DDPCM 105
        else {
            annulerParcours({
                parcours: this.parcours,
                motif: this.motifJS,
                commentaire: this.commentAnnulation
            });
            this.navigateToHomePage();
            this.isModalOpen = false;
            this.isModal4Open = false;
        }

    }

    setVariableForScript() {
        if (this.currentstepvalue === "ConstitutionPanier") {
            this.titreScript = "Constitution du panier client";
            if (this.parcours.VI_TechOffreReferenceChoisie__c === true &&
                this.parcours.VI_AssuranceFactureCocheeAF__c === false) {
                for (var i = 0; i < this.recorddonnee.length; i++) {
                    if (this.recorddonnee[i].Name === "6 Ter: Constitution du panier - Offre de référence"
                        && this.recorddonnee[i].RecordType.Name === "Scripts") {
                        this.doReplaceMetadata(this.recorddonnee[i]);
                    }
                }
            }
            else if (this.parcours.VI_AssuranceFactureCocheeAF__c === true) {
                for (var i = 0; i < this.recorddonnee.length; i++) {
                    if (this.recorddonnee[i].Name === "6 Bis: Panier - Assurance Facture"
                        && this.recorddonnee[i].RecordType.Name === "Scripts") {
                        this.doReplaceMetadata(this.recorddonnee[i]);
                    }
                }
            }
            else {
                for (var i = 0; i < this.recorddonnee.length; i++) {
                    if (this.recorddonnee[i].Name === "6: Constitution du panier"
                        && this.recorddonnee[i].RecordType.Name === "Scripts") {
                        this.doReplaceMetadata(this.recorddonnee[i]);
                    }
                }
            }
        }

        if (this.currentstepvalue === "situation") {
            this.titreScript = "Identifions vos besoins";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "1: Choix de la situation"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }

        if (this.currentstepvalue === "energy") {
            this.titreScript = "Identifions vos besoins";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "2: Choix de l'énergie"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }

        if (this.currentstepvalue === "client_energy") {
            this.titreScript = "Recherche Client";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "3: Identification Client"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }

        if (this.currentstepvalue === "identification_local") {
            this.titreScript = "Identification local";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "4: Identification local"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }

        if (this.currentstepvalue === "EstimationConsommation") {
            this.titreScript = "Estimation tarifaire";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "5: Estimation de la consommation"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }

        if (this.currentstepvalue === "DateEffetContrat") {
            this.titreScript = "Informations complémentaires";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "7: Date de contrat effectif"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }

        if (this.currentstepvalue === "RelevesCompteur") {
            this.titreScript = "Informations complémentaires";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "8: Relevés de compteur"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }

        if (this.currentstepvalue === "Saisie_moyen_de_paiement") {
            this.titreScript = "Choix du moyen de paiement";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "9: Saisie des moyens de paiement"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }

        if (this.currentstepvalue === "Recapitulatif") {
            this.titreScript = "Recapitulatif";
            for (var i = 0; i < this.recorddonnee.length; i++) {
                if (this.recorddonnee[i].Name === "10: Récapitulatif de l'offre"
                    && this.recorddonnee[i].RecordType.Name === "Scripts") {
                    this.doReplaceMetadata(this.recorddonnee[i]);
                }
            }
        }
    }

    doReplaceMetadata(recorddonnee) {
        if (this.parcours.VI_ChoixParcours__c === "EM") {
            if (!recorddonnee.VI_PrisenCompte_Choix_energie__c) {
                var interString = '';

                interString = recorddonnee.VI_EMScript1__c;

                interString = this.helpReplaceData(interString);

                this.firstString = interString;

                var interString = recorddonnee.VI_EMScript2__c;

                interString = this.helpReplaceData(interString);

                this.secondString = interString;
            }
            else {
                if (this.parcours.VI_ChoixEnergie__c === "Electricité") {
                    var interString = '';

                    interString = recorddonnee.VI_EM_ELEC_Script_1__c;

                    interString = this.helpReplaceData(interString);

                    this.firstString = interString;

                    var interString = recorddonnee.VI_EM_ELEC_Script_2__c;

                    interString = this.helpReplaceData(interString);

                    this.secondString = interString;
                }
                else if (this.parcours.VI_ChoixEnergie__c === "Gaz") {
                    var interString = '';

                    interString = recorddonnee.VI_EM_Gaz_Script_1__c;

                    interString = this.helpReplaceData(interString);

                    this.firstString = interString;

                    var interString = recorddonnee.VI_EM_Gaz_Script_2__c;

                    interString = this.helpReplaceData(interString);

                    this.secondString = interString;
                }

                else if (this.parcours.VI_ChoixEnergie__c === "Electricité + Gaz") {
                    var interString = '';

                    interString = recorddonnee.VI_EM_DUAL_Script_1__c;

                    interString = this.helpReplaceData(interString);

                    this.firstString = interString;

                    var interString = recorddonnee.VI_EM_DUAL_Script_2__c;

                    interString = this.helpReplaceData(interString);

                    this.secondString = interString;
                }
            }
        }
        else if (this.parcours.VI_ChoixParcours__c === "CHF") {
            if (!recorddonnee.VI_PrisenCompte_Choix_energie__c) {
                var interString = '';

                interString = recorddonnee.VI_CHFScript1__c;

                interString = this.helpReplaceData(interString);

                this.firstString = interString;

                var interString = recorddonnee.VI_CHFScript2__c;

                interString = this.helpReplaceData(interString);

                this.secondString = interString;
            }
            else {
                if (this.parcours.VI_ChoixEnergie__c === "Electricité") {
                    var interString = '';

                    interString = recorddonnee.VI_CHF_ELEC_Script_1__c;

                    interString = this.helpReplaceData(interString);

                    this.firstString = interString;

                    var interString = recorddonnee.VI_CHF_ELEC_Script_1__c;

                    interString = this.helpReplaceData(interString);

                    this.secondString = interString;
                }
                else if (this.parcours.VI_ChoixEnergie__c === "Gaz") {
                    var interString = '';

                    interString = recorddonnee.VI_CHF_GAZ_Script_1__c;

                    interString = this.helpReplaceData(interString);

                    this.firstString = interString;

                    var interString = recorddonnee.VI_CHF_GAZ_Script_2__c;

                    interString = this.helpReplaceData(interString);

                    this.secondString = interString;
                }
                else if (this.parcours.VI_ChoixEnergie__c === "Electricité + Gaz") {
                    var interString = '';

                    interString = recorddonnee.VI_CHF_DUAL_Script_1__c;

                    interString = this.helpReplaceData(interString);

                    this.firstString = interString;

                    var interString = recorddonnee.VI_CHF_DUAL_Script_2__c;

                    interString = this.helpReplaceData(interString);

                    this.secondString = interString;
                }
            }
        }
    }

    helpReplaceData(pInterString) {
        pInterString = pInterString.replace(/<img src=/g, '<lightning-formatted-url target="_blank" value=');
        pInterString = pInterString.replaceAll("</img>", "</lightning-formatted-url>");

        pInterString = pInterString.replaceAll("{prix-offre-choisie}", this.parcours.VI_MontantdelaMensualitePanierClient__c);
        pInterString = pInterString.replaceAll("{nom-offre-choisie}", this.parcours.VI_LibelleOffrePanierClient__c);
        pInterString = pInterString.replaceAll("{prix-offre-choisie-gaz-kwh-ttc}", this.parcours.VI_GazkWhTTCPanierClient__c);
        pInterString = pInterString.replaceAll("{prix-offre-choisie-elec-kwh-ttc}", this.parcours.VI_EleckWhTTCPanierClient__c);
        pInterString = pInterString.replaceAll("{prix-offre-choisie-gaz-abo-ttc}", this.parcours.VI_AbonnementAnnuelGazTTCPanierClient__c);
        pInterString = pInterString.replaceAll("{prix-offre-choisie-elec-abo-ttc}", this.parcours.VI_AbonnementAnnuelElecTTCPanierClient__c);
        pInterString = pInterString.replaceAll("{choix-energie-parcours}", this.parcours.VI_ChoixEnergie__c);
        pInterString = pInterString.replaceAll("{nom-prenom-user}", this.currentUserName);
        pInterString = pInterString.replaceAll("{prix-abo-elec-acheminement-ttc}", this.parcours.VI_MONTANT_ABO_ELEC_ACH_TTC__c);
        pInterString = pInterString.replaceAll("{prix-abo-elec-fourniture -ttc}", this.parcours.VI_MONTANT_ABO_ELEC_FOUR_TTC__c,);
        pInterString = pInterString.replaceAll("{prix-conso-elec-acheminement-ttc}", this.parcours.VI_PRIX_KWH_ELEC_ACH_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-elec-fourniture -ttc}", this.parcours.VI_PRIX_KWH_ELEC_FOUR_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-elec-obligations-ttc}", this.parcours.VI_PRIX_KWH_ELEC_OBLI__c);
        pInterString = pInterString.replaceAll("{prix-abo-gaz-acheminement-ttc}", this.parcours.VI_MONTANT_ABO_GAZ_ACH_TTC__c);
        pInterString = pInterString.replaceAll("{prix-abo-gaz-fourniture -ttc}", this.parcours.VI_MONTANT_ABO_GAZ_FOUR_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-gaz-acheminement-ttc}", this.parcours.VI_PRIX_KWH_GAZ_ACH_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-gaz-fourniture -ttc}", this.parcours.VI_PRIX_KWH_GAZ_FOUR_TTC__c);
        pInterString = pInterString.replaceAll("{total-prix-abonnement-gaz-ttc}", this.parcours.VI_TOTAL_MONTANT_ABO_GAZ_TTC__c);
        pInterString = pInterString.replaceAll("{total-prix-abonnement-elec-ttc}", this.parcours.VI_TOTAL_MONTANT_ABO_ELEC_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-elec-acheminement-HP-ttc}", this.parcours.VI_PRIX_KWH_ELEC_ACH_HP_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-elec-acheminement-HC-ttc}", this.parcours.VI_PRIX_KWH_ELEC_ACH_HC_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-elec-fourniture-HP-ttc}", this.parcours.VI_PRIX_KWH_ELEC_FOUR_HP_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-elec-fourniture-HC-ttc}", this.parcours.VI_PRIX_KWH_ELEC_FOUR_HC_TTC__c);
        pInterString = pInterString.replaceAll("{prix-conso-gaz-obligations-ttc}", this.parcours.VI_PRIX_KWH_GAZ_OBLI__c);
        pInterString = pInterString.replaceAll("{nom-complet-client}", this.parcours.VI_NomCompletClientCPV__c);
        if (this.parcours.VI_Email_CPV__c && this.parcours.VI_Email_CPV__c != '') {
            pInterString = pInterString.replaceAll("{email-cpv}", this.parcours.VI_Email_CPV__c);
        }
        else {
            if (this.parcours.VI_EmailPrincipalCreationClient__c === 'Email 1') {
                pInterString = pInterString.replaceAll("{email-cpv}", this.parcours.VI_Email1Client__c);
            }
            else {
                pInterString = pInterString.replaceAll("{email-cpv}", this.parcours.VI_Email2Client__c);
            }
        }
        if (this.parcours.VI_InfosCompl_HP_HC__c === true ||
            this.parcours.VI_SaisieConsommationElec_HP_HC__c === true ||
            this.parcours.VI_SaisieEstimationConsoElec_HP_HC__c === 'Oui') {
            var casNonHPHCBegin;
            var casNonHPHCEndEnd;
            var textToDelete = '';

            casNonHPHCBegin = pInterString.search('{cas_NON_HP_HC_BEGIN}');
            casNonHPHCEndEnd = pInterString.search('{cas_NON_HP_HC_END}');
            if (casNonHPHCBegin > 0 && casNonHPHCEndEnd > 0) {
                textToDelete = pInterString.substring(casNonHPHCBegin, casNonHPHCEndEnd);

                pInterString = pInterString.replaceAll(textToDelete, '');
                pInterString = pInterString.replaceAll('{cas_NON_HP_HC_END}', '');

                pInterString = pInterString.replaceAll('{cas_HP_HC_BEGIN}', '');
                pInterString = pInterString.replaceAll('{cas_HP_HC_END}', '');
            }
        }
        else {
            var casHPHCBegin;
            var casHPHCEndEnd;
            var textToDelete = '';

            casHPHCBegin = pInterString.search('{cas_HP_HC_BEGIN}');
            casHPHCEndEnd = pInterString.search('{cas_HP_HC_END}');
            if (casHPHCBegin > 0 && casHPHCEndEnd > 0) {
                textToDelete = pInterString.substring(casHPHCBegin, casHPHCEndEnd);

                pInterString = pInterString.replaceAll('{cas_HP_HC_END}', '');
                pInterString = pInterString.replaceAll(textToDelete, '');

                pInterString = pInterString.replaceAll('{cas_NON_HP_HC_BEGIN}', '');
                pInterString = pInterString.replaceAll('{cas_NON_HP_HC_END}', '');
            }
        }
        if (this.parcours.VI_AF_Enregistre__c === true) {
            pInterString = pInterString.replaceAll('{cas_AF_BEGIN}', '');
            pInterString = pInterString.replaceAll('{cas_AF_END}', '');
        }
        else {
            var AFBegin;
            var AFEnd;
            var textToDelete = '';

            AFBegin = pInterString.search('{cas_AF_BEGIN}');
            AFEnd = pInterString.search('{cas_AF_END}');
            if (AFEnd > 0 && AFBegin > 0) {
                textToDelete = pInterString.substring(AFBegin, AFEnd);

                pInterString = pInterString.replaceAll('{cas_AF_END}', '');
                pInterString = pInterString.replaceAll(textToDelete, '');
            }
        }
        return pInterString;
    }

    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: HomePageRedirectLink
            }
        });
    }
}