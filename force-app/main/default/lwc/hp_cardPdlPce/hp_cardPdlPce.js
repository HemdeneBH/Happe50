import { NavigationMixin } from 'lightning/navigation';
import { LightningElement,api,track } from 'lwc';

import getFlyoutPDL from '@salesforce/apex/HP_FlyoutPDL.getFlyoutPDL';
import getFlyoutPCE from '@salesforce/apex/HP_FlyoutPCE.getFlyoutPCE';
export default class Hp_cardPdlPce extends NavigationMixin(LightningElement) {
    @api type;
    @track _masterdata;
    @track currentContrat;
    @track iconCompteur;
    @track flayoutData;
    @track showHideFlyout = false;
    @track error;
    @track isGazFlyout;
    @track isElecFlyout;
    @track isGazFlyout;
    @track isElecFlyout;
    @track showSpinner = false;
    @track numCopied = false;
    apiContratInfo;
    currentPfc;
    isActiveContrat;
    currentOpen = false;
    @track _selectedpfcid;
    @api
    set masterdata(value) {
        if(value == null ) {
            return;
        }
        this._masterdata = value;
        if(this._selectedpfcid == null) {
            return;
        }
        this.findCurrentPftAndContrat();
        this.loadIconCompteur();
    }
    get masterdata() {
        return null;
    }

    @api
    set popupstate(value) {
        if( this.currentOpen) {
            this.currentOpen = false;
            return;
        }
        this.showHideFlyout = false;
    }
    get popupstate() {
        return null;
    }

    @api
    set selectedpfcid(value) {
        this.currentContrat = null;
        if(value == null) {
            return;
        }
        this._selectedpfcid = value;
        if(this._masterdata == null) {
            return;
        } 
        this.findCurrentPftAndContrat();
        this.loadIconCompteur();
    }
    get selectedpfcid() {
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
                this.currentPfc = locauxContrat[i];
                if(locauxContrat[i].locaux.length > 0) {
                    for(let j = 0; j < locauxContrat[i].locaux[0].pointsDeLivraison.length; j ++) {
                        let cont = locauxContrat[i].locaux[0].pointsDeLivraison[j];
                        if( cont.secteurActivite == 'gaz' &&   this.type == 'gaz') {
                            this.currentContrat = cont;
                            break;
                        }
                        if( cont.secteurActivite == 'elec' &&  this.type == 'elec') {
                            this.currentContrat = cont;
                            break;
                        }
                    }
                }
                break;
            }
        }

        let contratInfo = this._masterdata.contratInfoList.data._data;
        this.apiContratInfo = null;
        for(let i = 0; i < contratInfo.length; i ++) {
            if(this._selectedpfcid == contratInfo[i].idPortefeuilleContrat && 
                ((this.type == 'gaz' && contratInfo[i].codeOffre == 'GITR2_H') || (this.type == 'elec' && contratInfo[i].codeOffre != 'GITR2_H'))) {
                this.apiContratInfo = contratInfo[i];
                break;
            }
        }
        if(this.apiContratInfo == null) {
            return;
        }
        
        if((this.apiContratInfo.codeStatutCrm == 'H0105' || this.apiContratInfo.codeStatutCrm == 'H0101' ||
         this.apiContratInfo.codeStatutCrm == 'H0102' || 
        this.apiContratInfo.codeStatutCrm == 'E0004' || this.apiContratInfo.codeStatutCrm == 'E0007')) {
            this.isActiveContrat = true;
        } else {
            this.isActiveContrat = false;
        }
    }   
    loadIconCompteur() {
        if(this.currentContrat == null) {
            this.iconCompteur = null;
            return;
        }
        if(this.type == 'gaz' && this.currentContrat.typeCompteur == 'Gazpar') {
            this.iconCompteur = '/resource/EngieCustomResources/images/Compteur_GAZ_gazpar.svg';
        } else if(this.type == 'gaz') {
            this.iconCompteur = '/resource/EngieCustomResources/images/Compteur_GAZ_ordinaire.svg';
        } else {
            if (this.currentContrat.codeNiveauService === '0' || (this.currentContrat.systemeInfoContractuel === 'DISCO' && this.currentContrat.codeNiveauService === '1')){
                this.iconCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_ordinaire.svg';
            }else if (this.currentContrat.systemeInfoContractuel === 'GINKO') {
                if (this.currentContrat.codeNiveauService === '2') {
                    this.iconCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_linky_communiquant.svg';
                } else if (this.currentContrat.codeNiveauService === '1') {
                    this.iconCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_linky_non_communiquant.svg';
                }
            } else {
                this.iconCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_ordinaire.svg';
            }
        }
    }
    loadFlayoutData() {
        if(this.showHideFlyout) {
            this.showHideFlyout = false;
            this.isElecFlyout = false;
            this.isGazFlyout = false;
            return;
        }
        this.currentOpen = true;
        const event = new CustomEvent('popupevent', { open: true});
        this.dispatchEvent(event);
        this.showSpinner = true;
        this.showHideFlyout = true;
        if (this.type === "gaz") {
            let inputMap = {
                PCEIdentifier: this.currentContrat.numeroPointDeLivraison,
                PerimetrePCE: this.isActiveContrat
            }
            getFlyoutPCE(inputMap).then(result => {
                    if (result) {
                        if(result.error == true) {
                            this.error = true;
                            this.showSpinner = false;
                            const event = new CustomEvent('newidtransaction', { detail: result.transactionId});
                            this.dispatchEvent(event);
                           
                        } else {
                            this.flayoutData = result;
                            this.isGazFlyout = this.type === 'gaz';
                            const event = new CustomEvent('newidtransaction', { detail: result.transactionId});
                            this.dispatchEvent(event);
                        }
                       
                    }
                    this.showSpinner = false;
                })
                .catch(error => {
                    this.error = true;
                    this.showSpinner = false;
                });
        } else {
            let inputMap = {
                pdlElectricity: this.currentContrat.numeroPointDeLivraison
            }
            getFlyoutPDL(inputMap).then(result => {
                    if (result) {
                        if(result.error == true) {
                            this.error = true;
                            this.showSpinner = false;
                            const event = new CustomEvent('newidtransaction', { detail: result.transactionId});
                            this.dispatchEvent(event);
                        } else {
                            this.flayoutData = result;
                            this.isElecFlyout = this.type === 'elec';
                            const event = new CustomEvent('newidtransaction', { detail: result.transactionId});
                            this.dispatchEvent(event);
                        }
                       
                    }
                    this.showSpinner = false;
                })
                .catch(error => {
                    this.error = true;
                    this.showSpinner = false;
                });
        }
    }
    copyPCEPDL(e) {
        e.stopPropagation();
        let textToCopy = e.currentTarget.innerText;
        let input = document.createElement('input');
        e.currentTarget.appendChild(input);
        input.value = textToCopy;
        input.focus();
        input.select();
        let isSuccessful = document.execCommand('copy');
        e.currentTarget.removeChild(input);
        if (!isSuccessful) {
            console.error('Failed to copy text.');
        } else {
            this.numCopied = true;
            setTimeout(() => {
                this.numCopied = false;
            }, 2000);
        }
    }
}