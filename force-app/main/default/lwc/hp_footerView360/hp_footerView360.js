import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_footerView360  extends NavigationMixin(LightningElement) {
    _masterdata;
    _selectedpfcid;
    contrats = {};
    currentPfc;
    _pfcdata;
    _secondarydata;

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
        this.findCurrentContracts();
        this.findCurrentPftc();
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
        this.findCurrentContracts();   
        this.findCurrentPftc();
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

    openAgilabSpace() {
		if (this._masterdata.data[0].HP_AgilabExternalId__c != null) {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this._masterdata.globalParam.data.urlAgilab + "personnes/show/" + this._masterdata.data[0].HP_AgilabExternalId__c.toString()
                }
            });
        } else {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this._masterdata.globalParam.data.urlAgilab
                }
            });
        }
    }

    handleAction() {
        if(this.contrats == null) {
            return;
        }
        if(this.currentPfc == null || this.currentPfc.locaux == null || this.currentPfc.locaux.length == null || this.currentPfc.locaux.length == 0) {
            const event = new ShowToastEvent({
                title: 'Résiliation',
                variant: 'info',
                message: 'On ne peut pas résilier les contrats associés à ce local (données manquantes sur le porte feuille contrat)',
            });
            this.dispatchEvent(event);
            return;
        }
        let contList = [];
        if(this.verifyStatusCRM(this.contrats.elec) == true) {
            contList.push(this.contrats.elec);
        }
        if(this.verifyStatusCRM(this.contrats.gaz) == true) {
            contList.push(this.contrats.gaz);
        }
        if(contList.length == 0) {
            const event = new ShowToastEvent({
                title: 'Résiliation',
                variant: 'info',
                message: 'On ne peut pas résilier les contrats associés à ce local',
            });
            this.dispatchEvent(event);
            return;
        }

        this.dispatchEvent(new CustomEvent('activateresiliation', { detail: true}));
    }

    verifyStatusCRM(cont) {
        if(cont == null) {
            return false;
        }
        if(cont.codeStatutCrm == 'E0004' || cont.codeStatutCrm == 'H0101' || 
        cont.codeStatutCrm == 'H0105' || cont.codeStatutCrm == 'E0007') {
            return true;
        }
        return false;
    }
    findCurrentContracts() {
        this.contrats = {};
        if(this._selectedpfcid == null || this._masterdata == null || this._masterdata.contratInfoList == null ||this._masterdata.contratInfoList.data == null 
            || this._masterdata.contratInfoList.data._data == null) {
                return;
        }
        let contratsList =  this._masterdata.contratInfoList.data._data;

        for(let cont of contratsList) {
            if(cont.idPortefeuilleContrat == this._selectedpfcid) {
                if(cont.codeOffre == 'GITR2_H') {
                    this.contrats.gaz = cont;
                } else {
                    this.contrats.elec = cont;
                }
                
            }
        }
    }

    findCurrentPftc() {
        if(this._masterdata != null && this._masterdata.contratInfoList != null
            && this._masterdata.contratInfoList.pfcInfoList != null  && this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList != null
            && this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data != null) {
            let locauxContrat = this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data._data;
            if(locauxContrat == null || !Array.isArray(locauxContrat)) {
                return;
            }
            for(let i = 0; i < locauxContrat.length; i ++) {
                if(this._selectedpfcid == locauxContrat[i].idPortefeuilleContrat) {
                    this.currentPfc = locauxContrat[i];
                    break;
                }
            }
		}
		
	}
}