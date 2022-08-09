/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-15-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { api, LightningElement, track } from 'lwc';
import processRetablissement from '@salesforce/apex/HP_SM075_CoupureReduction.processRetablissement'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_caseRetablissement extends LightningElement {
    @api recordId;
    @track showSpinner = false;

    originOptions = [
        { value: 'HP_Client', label: 'Client' },
        { value: 'HP_happe', label: 'happ-e' }
    ];
    @track originDemande = 'HP_Client';
    @track prestaUrgente = false;

    handleComboboxChange(event) {
        this.originDemande = event.detail.value;
    }

    handleCheckboxChange(event) {
        this.prestaUrgente = event.detail.checked;
    }

    validateRetablissement() {
        this.showSpinner = true;
        console.log('this.comboboxValue: '+this.originDemande);
        console.log('this.isChecked: '+this.prestaUrgente);
        processRetablissement({caseId : this.recordId, prestaUrgente : this.prestaUrgente, origineDemande : this.originDemande}).then( result => { 
            console.log('result : '+result);
            if(result === 'Prestation Crée avec Succès'){
                this.displayToast('Succès',  'Prestation Crée avec Succès', 'success');
            }else{
                this.displayToast('Erreur',  result, 'warning');
            }
            this.showSpinner = false;
            this.closeRetablissement();
        }).catch(error => {
            this.showSpinner = false;
            console.log("got error loadContact", error);
            this.displayToast('Erreur',  error.body.message, 'warning');
            this.closeRetablissement();
        });
        
    }

    closeRetablissement() {
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null });
        this.dispatchEvent(event);
    }

    displayToast(title, message, variant) {
		const evt = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(evt);
    }
}