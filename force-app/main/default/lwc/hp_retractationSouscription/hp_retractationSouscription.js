import { LightningElement,api,track } from 'lwc';
import executeProcessRetractation from '@salesforce/apex/HP_SM035_Restractation.processRestractionProcess';
import confirmRetractation from '@salesforce/apex/HP_SM035_Restractation.confirmRetractation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Hp_retractationSouscription extends NavigationMixin(LightningElement)  {
    @api recordid;
    @track showSpinner = false;
    @track resultData;
    @track resultDataRetractation;
    @track popupYesNo = false;
    @track debugPopupModal = false;
    @track transactionId;
    @track permissionViewLog;
    @track retractionDone = false;
    get linkUS() {
        if(this.resultData != null) 
            return 'https://engie-dmpa-dsi-digital.atlassian.net/browse/HAPP-'+ this.resultData.US;
        return null;
    }
    connectedCallback() {
        console.log('@@ recordid : ' + this.recordid);
        this.showSpinner = true;
        executeProcessRetractation({ souscriptionId: this.recordid}).then(result => {
            this.popupYesNo = (result.processEndResult == 'AVEC_FRAIS' || result.processEndResult == 'SANS_FRAIS');
            this.showSpinner = false;
            this.resultData = JSON.parse(JSON.stringify(result).split("T00:00:00.000Z").join(""));
            this.transactionId =  this.resultData.transactionId; 
            console.log('@@ result : ' + JSON.stringify(this.resultData));
            this.permissionViewLog = result.permissionViewLog;
        });
    }

    closeRetractation() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    closeDebugPopupModal(){
        this.debugPopupModal = false;
        if(this.retractionDone) {
            this.dispatchEvent(new CustomEvent('close'));
        }
     }
     openDebug(){
        this.debugPopupModal = true;
     }
    validRetractation() {
        console.log('@@ validation');
        this.showSpinner = true;
        confirmRetractation({ souscriptionId: this.recordid, 
                            createCase : this.resultData.createCase, 
                            updatePCStatus : this.resultData.updatePCStatus, 

                            updateContractStatus : this.resultData.updateContractStatus,
                            updateSouscriptionStatus : this.resultData.updateSouscriptionStatus}).then(result => {
            eval("$A.get('e.force:refreshView').fire();");

                                this.showSpinner = false;
            this.resultDataRetractation = result;
            this.transactionId += ';' + result.transactionId; 
            console.log('@@ resultVal : ' + JSON.stringify(result));
            this.retractionDone = true;
            if(result.resultAPI) {
                const event = new ShowToastEvent({
                    title: 'La demande de rétractation a été enregistrée',
                    message: 'Pour envoyer un e-mail de confirmation, utiliser l\'option dans la requête',
                    variant: 'success'
                });
                this.dispatchEvent(event);
            } else {
                const event = new ShowToastEvent({
                    title: '',
                    message: 'La demande de rétractation n\'a pas été enregistrée, merci de réessayer ultérieurement',
                    variant: 'error'
                });
                this.dispatchEvent(event);
            }
            if(this.permissionViewLog) {
                this.debugPopupModal = true;
            } else {
                this.dispatchEvent(new CustomEvent('close'));
            }
        });
    }
    openCase1(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  this.resultDataRetractation.case1,
                actionName: 'view'
            }
        });
    }
    openCase2(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  this.resultDataRetractation.case2,
                actionName: 'view'
            }
        });
    }
}