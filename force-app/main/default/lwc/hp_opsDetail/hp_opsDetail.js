import { LightningElement,api , track } from 'lwc';
import lireOPS from '@salesforce/apex/HP_SM052_PlanificationOPS.lireOPS';
import modifierOPS from '@salesforce/apex/HP_SM052_PlanificationOPS.modifierOPS';
import cancelOPSGaz from '@salesforce/apex/HP_SM052_PlanificationOPS.cancelOPSGaz';
import isHoliday from '@salesforce/apex/HP_EM047_Holiday.isHoliday';
import sendNotification from '@salesforce/apex/HP_SM052_PlanificationOPS.sendNotification';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_opsDetail extends LightningElement {
    intl = new Intl.DateTimeFormat("en-GB",  
                {
                  day:"2-digit",
                  month:"2-digit",
                  year:"numeric"
                });
    _secondarydata;
    _masterdata;
    _pfcdata;
    _selectedpfcid;
    _ops;
    currentPfc = {};
    @track
    opsOctopus={};
    @track
    numLabel;
    @track
    enegrie;

    @track 
    showSpinner = true;
    @track
    personneContacter;
    @track
    disabledModify = false;

    @track
    messageModify;

    @track 
    showModify = false;

    @track 
    showModifyButton = true;

    @track 
    showCreneau = false;

    @track 
    showSuccess = false;

    @track
    showError = false;
    @track
    nom;

    @track
    prenom;

    @track
    civilite;

    @track
    tel;

    @track
    commentaire;
    @track
    date;
    @track
    creneau;

    @track
    type;

    @track
    urlPortail;
    @track
    showDateError = false;
    @track
    showDateErrorMessage;
    @track 
    distName;
    @track
    disponibilites;
    @track
    dateFormat;
    @track
    errorMessageOPS;

    indexDispo;
    creneauLabel;
    errorDate = false;
    sms;
    email;
    get creneauOptions() {
        return [
            { label: 'Journée', value: 'jou' },
            { value: 'dma', label: 'Début matinée' },
            { value: 'fma', label: 'Fin matinée' },
            { value: 'mat', label: 'Matin' },
            { value: 'dap', label: 'Début après-midi' },
            { value: 'fap', label: 'Fin après-midi' },
            { value: 'apm', label: 'Après-midi' },
            { value: 'fjo', label: 'Fin journée' },
            { value: 'dso', label: 'Début soirée' },
            { value: 'mjo', label: 'Milieu de journée' },
            { value: 'soi', label: 'Soirée' },
            { value: 'fso', label: 'Fin de soirée' }
        ];
    }

    get civiliteOptions() {
        return [
            { label: 'MR', value: 'MR' },
            { label: 'MME', value: 'MME' }
        ];
    }
    @api
    set secondarydata(value) {
        this._secondarydata = value;
    }
    get secondarydata() {
        return null;
    }

    @api
    set masterdata(value) {
        this.contrats = null;
        if(value == null ) {
            return;
        }
        this._masterdata = value;
        this.findCurrentPftAndContrat();
    }
    get masterdata() {
        return null;
    }

    @api
    set selectedpfcid(value) {
        if(value == null) {
            return;
        }
        this._selectedpfcid = value; 

        this.findCurrentPftAndContrat();
    }

    get selectedpfcid() {
        return null;
    }

    @api
    set pfcdata(value) {

        this._pfcdata =  JSON.parse(JSON.stringify(value));
    }
    get pfcdata() {
        return null;
    }


    @api
    set ops(value) {
        this._ops = value;
        this.numLabel = (value.type == 'gaz' ? 'PCE' : 'PDL');
        this.enegrie = (value.type == 'gaz' ? 'Gaz' : 'Electricité');
        let compteurType = (value.type == 'gaz' ? 'Gazpar' : 'Linky');
        this.distName =  (value.type == 'gaz' ? 'GRDF' : 'ENEDIS');

        this.urlPortail =  (value.type == 'gaz' ? 'https://portailfournisseur.grdf.fr/login' : 'https://sge.gdfsuez.net/sgePortail/');
        this.type = value.type;
        //this.messageModify = 'L’intervention sera réalisée à distance car il s’agit d’un compteur télé-opérable (' + compteurType + '). Aucune action ou présence du client requise lors de l’intervention.'
        this.showSpinner = true;
        this.personneContacter = '';
        this.opsOctopus = {};
        lireOPS({
            
            idAffaire: value.Numero_affaire_distributeur__c,
            type:value.type
        }).then(result => {
            this.showSpinner = false;
            this.opsOctopus = result;
            this.disabledModify = this.opsOctopus.disabledModify;
            this.messageModify = result.errorMessage;
            if(this.opsOctopus.personneContacterPrenom != null && this.opsOctopus.personneContacterNom != null && this.opsOctopus.personneContacterCivilite != null) {
                this.nom = this.opsOctopus.personneContacterNom;
                this.prenom = this.opsOctopus.personneContacterPrenom;
                this.civilite = this.opsOctopus.personneContacterCivilite;
                this.personneContacter = this.opsOctopus.personneContacterCivilite + ' ' + this.opsOctopus.personneContacterPrenom + ' ' + this.opsOctopus.personneContacterNom;
            } else if(this._ops.Civilite_interlocuteur_intervention__c != null &&
                this._ops.Prenom_contact_d_intervention__c != null &&
                this._ops.Nom_contact_d_intervention__c != null){

                this.personneContacter = this._ops.Civilite_interlocuteur_intervention__c + ' ' + this._ops.Prenom_contact_d_intervention__c
                + ' ' + this._ops.Nom_contact_d_intervention__c;
                this.nom = this._ops.Nom_contact_d_intervention__c;
                this.prenom = this._ops.Prenom_contact_d_intervention__c;
                this.civilite = this._ops.Civilite_interlocuteur_intervention__c;
            }
            if(this._ops.Telephone_intervention__c) {
                this.tel = this._ops.Telephone_intervention__c;
            }
            console.log('@@@ opsOctopus : ' + JSON.stringify( this.opsOctopus));
        }).catch(error => {
            this.showSpinner = false;
            console.log('@@@ error : ' + JSON.stringify( error));
            this.disabledModify = true;
        });
    }
    get ops() {
        return null;
    }


    findCurrentPftAndContrat() {
        try {
            if(this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data._data == null) {
                return;
            }
        } catch(e){return;}
        let locauxContrat = this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data._data;
        for(let i = 0; i < locauxContrat.length; i ++) {
            if(this._selectedpfcid == locauxContrat[i].idPortefeuilleContrat) {
                if(locauxContrat[i].locaux.length > 0) {
                    this.currentPfc = locauxContrat[i].locaux[0];
                    
                    break;
                }
               
            }
        }

    }

    closeOps() {
        const event = new CustomEvent('closeops', { detail: true});
        this.dispatchEvent(event);
    }

    closeOpsCancel() {
        if(this.type == 'gaz') {
            this.showSpinner = true;
            cancelOPSGaz({
                idAffaire: this._ops.Numero_affaire_distributeur__c,
                type:this.type,
                civilite:this.civilite,
                nom : this.nom,
                prenom : this.prenom,
                tel : this.tel,
                dateSou : this.date,
                creneau : this.creneau,
                commentaire : this.commentaire
            }).then(result => {
                this.showSpinner = false;
                this.closeOps();
            }).catch(function(error) {
                this.showSpinner = false;
                this.closeOps();
            });
        } else {
            this.closeOps();
        }
       
    }

    modify() {
        this.showModify = true;
        this.showModifyButton = false;
    }

    handleData(event) {
        if(event.target.name === 'nom'){
			this.nom = event.target.value;
		}else if(event.target.name === 'prenom'){
            this.prenom = event.target.value;
        }else if(event.target.name === 'date'){
            this.showDateError = false;
            this.errorDate = false;
            this.date = event.target.value;
            let dt = new Date(this.date);
            let today = new Date();
            let tom = new Date(new Date().setDate(today.getDate() + 1));
            
            this.dateFormat = this.intl.format(dt);
            isHoliday({daterdv : this.date}).then(result => {
                if(result == true) {
                    this.errorDate = true;
                    this.showDateError = true;
                    this.showDateErrorMessage = "Les weekends et jours fériés ne sont pas autorisés !";
                }
                
            });
            if(dt.getDay() == 0 || dt.getDay() == 6){
                this.errorDate = true;
                this.showDateError = true;
                this.showDateErrorMessage = "Les weekends et jours fériés ne sont pas autorisés !";
            }else if(dt < today) {
                this.showDateError = true;
                this.showDateErrorMessage = "Date n'est pas autorisée !";
                this.errorDate = true;
            } else if(dt < tom) {
                this.showDateError = true;
                this.showDateErrorMessage = "La date choisie est dans un délai de moins de 24h, des frais d’urgence vont s’appliquer";
            }
        }else if(event.target.name === 'tel'){
            this.tel = event.target.value;
        }else if(event.target.name === 'creneau'){
            this.creneau = event.target.value;
            this.creneauLabel = event.target.options.find(cr => cr.value === event.detail.value).label;
        }else if(event.target.name === 'commentaire'){
            this.commentaire = event.target.value;
        }else if(event.target.name === 'civilite'){
            this.civilite = event.target.value;
        }
        else if(event.target.name === 'sms'){
            this.sms = event.target.checked;
        }else if(event.target.name === 'email'){
            this.email = event.target.checked;
        }
    }
    displayToast(title, message, variant) {
		const evt = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(evt);
    }
    validCreneau1Step() {
        let valid = true;
        this.template.querySelectorAll('.validation').forEach(element => {
            valid = element.reportValidity() & valid;
        });
        if(!valid) {
            this.displayToast('Erreur', "Merci de remplir tout les champs obligatoires", 'error');
            return;
        }

        if(this.errorDate ) {
            this.displayToast('Erreur', "Date n'est pas autorisée !", 'error');
            return;
        }
        this.validCreneau('REPLANIFIER_OPS');
    }

    validCreneau2Step() {
        this.validCreneau('PROPOSER');
    }
    validCreneau(action) {
        this.showSpinner = true;
        modifierOPS({
            idAffaire: this._ops.Numero_affaire_distributeur__c,
            type:this.type,
            civilite:this.civilite,
            nom : this.nom,
            prenom : this.prenom,
            tel : this.tel,
            dateSou : this.date,
            creneau : this.creneau,
            commentaire : this.commentaire,
            action : action
        }).then(result => {
            console.log('@@@ result mod ' +JSON.stringify(result));
            this.showSpinner = false;
            if(result.code == '210') {
                this.showModify = false;
                this.showCreneau = true;
                this.showSuccess = false;
                this.showError = false;
                this.disponibilites = JSON.parse(JSON.stringify(result.disponibilites));
                for(let i = 0; i < this.disponibilites.length; i ++) {
                    this.disponibilites[i].index = i; 
                    this.disponibilites[i].class = 'dispo-style'; 
                    this.disponibilites[i].dateFormat = this.intl.format(new Date(this.disponibilites[i].date)); 
                }
            } else if(result.code == '200') {
                this.showSuccess = true;
                this.showModify = false;
                this.showCreneau = false;
                this.showError = false;
            } else {
                this.showSuccess = false;
                this.showModify = false;
                this.showCreneau = false;
                this.showError = true;
                this.errorMessageOPS = result.error;
            }
            
        });
    }

    selectDispo(event) {
        this.indexDispo = parseInt(event.currentTarget.dataset.id);
        for(let i = 0; i < this.disponibilites.length; i ++) {
            this.disponibilites[i].class = 'dispo-style'; 
        }
        this.disponibilites[this.indexDispo].class= 'color-selected';      
        this.date = this.disponibilites[this.indexDispo].date;
        this.dateFormat = this.disponibilites[this.indexDispo].dateFormat;
        this.creneau = this.disponibilites[this.indexDispo].creneauCode;
        this.creneauLabel =  this.disponibilites[this.indexDispo].creneauLibelle;
    }

    sendNotification() {
        if(this.sms != true && this.email != true) {
            this.closeOps();
        }
        this.showSpinner = true;
        let add = this.currentPfc.numeroVoie + ' '+ this.currentPfc.libelleVoie + ' '+ this.currentPfc.codePostal + ' '+ this.currentPfc.ville;
        sendNotification({contactId : this._masterdata.data[0].Id, distName : (this.type == 'gaz' ? 'GRDF' : 'ENEDIS'),
        dateRDV : this.dateFormat, creneau :this.creneauLabel, address : add, sms : this.sms, email : this.email}).then(() => {
            this.closeOps();
            this.showSpinner = false;
            this.displayToast('Succès', "Notification envoyée vers le client avec succès", 'success');
        });
    }
}