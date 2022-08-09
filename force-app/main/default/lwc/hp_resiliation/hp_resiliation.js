import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { LightningElement, api, track , wire} from 'lwc';
import HP_Source from '@salesforce/schema/Case.HP_Source__c';
import CASE_OBJECT from '@salesforce/schema/Case';
import getCancelationCase from '@salesforce/apex/HP_ContractCancelationClass.getCancelationCase';
import createPrestation from '@salesforce/apex/HP_ContractCancelationClass.createPrestation';
import scheduleCancelationCase from '@salesforce/apex/HP_ContractCancelationClass.scheduleCancelationCase';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_resiliation extends NavigationMixin(LightningElement) {
    _masterdata;
    _selectedpfcid;
    @track contrats = {};
    @track currentPfc;
    @track selectedContrat = null;
    @track isGaz;
    @track scheCase = false;
    @track firstStep = true;
    @track recap;
    @track dataForm = {};
    @track type;
    @track showSpinner = false;
    @track energie;
    _pfcdata;
    _secondarydata;
    pdl;
    pce;

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: HP_Source})
    sourceHappePicklistValues;

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
        this.findCurrentPftAndContrat();
    }
    get masterdata() {
        return null;
    }

    @api
    set selectedpfcid(value) {
        this.initForm();
        if(value == null) {
            return;
        }
        this._selectedpfcid = value; 
        this.findCurrentContracts();  
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

    get optionEnergy() {
        let result = [];

        if( this.contrats!= null && this.contrats.gaz != null) {
            result.push({ label: 'Gaz : ' + this.contrats.gaz.offre + ' - N° Contrat : '
            + this.contrats.gaz.id + ' - ' + this.contrats.gaz.libelleStatutCrm + ' - PCE : ' + this.pce, value: 'gas' });
        }
        if(this.contrats!= null && this.contrats.elec != null) {
            result.push({ label: 'Electricité : ' + this.contrats.elec.offre + ' - N° Contrat : '
            + this.contrats.elec.id + ' - ' + this.contrats.elec.libelleStatutCrm + ' - PDL : ' + this.pdl, value: 'elec' });
        }
        return result;
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
                    for(let j = 0; j < locauxContrat[i].locaux[0].pointsDeLivraison.length; j ++) {
                        let cont = locauxContrat[i].locaux[0].pointsDeLivraison[j];
                        if(cont.typeCompteur != null) {
                            this.pce = cont.numeroPointDeLivraison;
                        }
                        if(cont.systemeInfoContractuel != null) {
                            this.pdl = cont.numeroPointDeLivraison;
                        }
                    }
                    break;
                }
               
            }
        }

    }
    closeResiliation() {
        if(this.firstStep == true) {
            if(confirm('Voulez vous annuler les modification sur la résiliation en cours ?')) {
                this.initForm();
                this.dispatchEvent(new CustomEvent('activateresiliation', { detail: false}));
            }
            
        } else {
            this.initForm();
            this.dispatchEvent(new CustomEvent('activateresiliation', { detail: false}));
        }
        
    }
    savegarderResiliation() {
        
        if(this.dataForm.orign == null) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Erreur', message: 'Vueillez choisir l\'origine de la resiliation', variant: 'error'
            }));
            return;
        }
        if(this.type == null) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Erreur', message: 'Vueillez choisir le contrat', variant: 'error'
            }));
            return;
        }
        let indexGeneric;
        if (this.isGaz) {
            indexGeneric = this.dataForm.gazindex;
        } else {
            indexGeneric = (this.dataForm.hcindex != null && this.dataForm.hcindex !== '') ? this.dataForm.hpindex : this.dataForm.elecindex;
        }
        this.showSpinner = true;
        if(this.scheCase) {
            
            scheduleCancelationCase({
                contactId:this._masterdata.data[0].ID_Tiers__c,
                caseId: this.dataForm.caseId,
                threatmentDate: this.dataForm.processdate,
                indexHP: this.dataForm.hpindex,
                indexHC: this.dataForm.hcindex,
                indexGas: indexGeneric,
                caseSourceStr: this.dataForm.orign,
                energy: this.isGaz ? 'gaz' : 'elec',
                indexEnergy: indexGeneric,
                idContract: this.selectedContrat.id,
                assetId: '',
                resilDate:this.dataForm.effectivedate
            }).then(result => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'success', message: 'La requête a été replanifiée avec succès', variant: 'success'
                }));
                this.initForm();
                this.dispatchEvent(new CustomEvent('activateresiliation', { detail: false}));
                this.showSpinner = false;
                eval("$A.get('e.force:refreshView').fire();");
                
            }).catch(error => {
                console.log('@@@@@@@@+++>',JSON.stringify(error));
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Erreur', message: 'Erreur au niveau de planification de case', variant: 'error'
                }));
                this.showSpinner = false;
               
            });
        } else {
            createPrestation(
                {
                    prestationDate: this.dataForm.prestadate,
                    businessNumber: this.dataForm.businessnum,
                    caseId: this.dataForm.caseId,
                    caseSourceStr: this.dataForm.orign,
                    pdlPce: this.isGaz ? this.pce : this.pdl,
                    idContract: this.selectedContrat.id,
                    contactId: this._masterdata.data[0].ID_Tiers__c,
                    energy: this.isGaz ? 'gaz' : 'elec',
                    indexEnergy:this.dataForm.hcindex,
                    indexHP:indexGeneric,
                    indexGas: indexGeneric,
                    codeStatutContratCRM: this.selectedContrat.codeStatutCrm,
                    statutContrat: this.selectedContrat.libelleStatutCrm
                }
            ).then(result => {
                if (result === 2) {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Erreur', message: 'Une prestation existe déjà sur ce contract', variant: 'error'
                    }));
                }
                else if (result === 3) {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Erreur', message: 'Ce contrat est déjà en cours de resiliation', variant: 'error'
                    }));
                }
                else {
                    this.firstStep = false;
                    if(this.isGaz) {
                        this.recap =  'Gaz : ' + this.contrats.gaz.offre + ' - N° Contrat : '
                        + this.contrats.gaz.id + ' - ' + this.contrats.gaz.libelleStatutCrm + ' - PCE : ' + this.pce;
                    } else {
                        this.recap = 'Electricité : ' + this.contrats.elec.offre + ' - N° Contrat : '
                        + this.contrats.elec.id + ' - ' + this.contrats.elec.libelleStatutCrm + ' - PDL : ' + this.pdl;
                    }
                    
                }
                this.showSpinner = false;
                 eval("$A.get('e.force:refreshView').fire();");
            })
            .catch(error => {
                this.showSpinner = false;
                console.log('error: ',error);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Erreur', message: error, variant: 'error'
                }));
            });
        }
       
       
    }

    selectContract(event) {
        this.type = event.target.value;
        if(event.target.value == 'gas') {
            this.selectedContrat = this.contrats.gaz;
            this.isGaz = true;
            this.energie = 'GAZ';
        } else {
            this.energie = 'ELECTRICITE';
            this.selectedContrat = this.contrats.elec;
            this.isGaz = null;
        }

        this.showSpinner = true;
        getCancelationCase({
			idContract:this.selectedContrat.id
		}).then(result => {
			if (result) {
				this.dataForm.orign = result.HP_Source__c;
				this.dataForm.gazindex = result.HP_index_gaz__c;
				this.dataForm.effectivedate = result.HP_EffectiveDate__c;
				this.dataForm.caseId = result.Id;
				this.dataForm.contactId = result.ContactId;
				this.dataForm.orign = result.HP_Source__c;
				this.dataForm.elecindex = result.HP_index_elec_base__c;
				this.dataForm.hpindex = result.HP_index_elec_hp__c;
				this.dataForm.hcindex = result.HP_index_elec_hc__c;
                this.dataForm.assetId = result.AssetId;
                this.dataForm.processdate = result.HP_TreatmentDate__c;
			}
			else {
				console.log("Cancellation Case doesn't exist "+result);
            }
            this.showSpinner = false;
		}).catch(error => {
            this.showSpinner = false;
			console.log("Exception =" + error.body.message);
		});
    }
    scheduleCase(event) {
        this.scheCase = event.target.checked;

        if(event.target.checked===true){
			this.template.querySelector('.numAffaire').value='';
			this.template.querySelector('.datePrestation').value='';
			this.template.querySelector('.numAffaire').readOnly=true;
			this.template.querySelector('.datePrestation').readOnly=true;
		}else{
			this.template.querySelector('.numAffaire').readOnly=false;
			this.template.querySelector('.datePrestation').readOnly=false;
		}
    }

    preventcaracters(){
		this.template.querySelector('.index').addEventListener("keypress", function (evt) {
			if (evt.which !== 8 && evt.which !== 0 && (evt.which < 48 || evt.which > 57))
			{
				evt.preventDefault();
			}
		});
	}
    
    handleChange(event){
        if( event.target.name === 'orign' ){
            this.dataForm.orign = event.target.value;
        } else if( event.target.name === 'businessnum' ){
            this.dataForm.businessnum = event.target.value;
        } else if( event.target.name === 'prestadate' ){
            this.dataForm.prestadate = event.target.value;
        } else if( event.target.name === 'processdate' ){
            this.dataForm.processdate = event.target.value;
        } else if( event.target.name === 'effectivedate' ){
            this.dataForm.effectivedate = event.target.value;
        } else if( event.target.name === 'gazindex' ){
            this.preventcaracters();
            this.dataForm.gazindex = event.target.value == '' ? null : event.target.value;;
        } else if( event.target.name === 'elecindex' ){
            this.preventcaracters();
            this.dataForm.elecindex = event.target.value == '' ? null : event.target.value;;
        } else if( event.target.name === 'hpindex' ){
            this.preventcaracters();
            this.dataForm.hpindex = event.target.value == '' ? null : event.target.value;
        } else if( event.target.name === 'hcindex' ){
            this.preventcaracters();
            this.dataForm.hcindex = event.target.value == '' ? null : event.target.value;;
        }
    }

    initForm() {
       // this.contrats = {};
        this.currentPfc;
        this.selectedContrat = null;
        this.isGaz;
        this.scheCase = false;
        this.firstStep = true;
        this.recap = '';
        this.dataForm = {};
        this.type = null;
    }
}