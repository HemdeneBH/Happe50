import { api, LightningElement, track } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ID_FIELD from '@salesforce/schema/Case.Id';
import DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import CPPF_FIELD from '@salesforce/schema/Case.HP_Contact_pb_paiement_factures__c';

export default class Hp_caseTraitementPreliminaire extends LightningElement {

    @api recordId;
    @track showSpinner = false;
    @track proceedTraitementPreliminaire = false;

    value = 'Non';

    get options() {
        return [
            { label: 'Oui', value: 'Oui' },
            { label: 'Non', value: 'Non' },
        ];
    }

    handleRadioChange(event) {
        const selectedOption = event.detail.value;
        if (selectedOption == 'Oui'){
            this.proceedTraitementPreliminaire = true;
        } else {
            this.proceedTraitementPreliminaire = false;
        }
    }

    validateTraitement() {
        this.showSpinner = true;
        if (this.proceedTraitementPreliminaire) {
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[STATUS_FIELD.fieldApiName] = 'CANCELED';
            fields[CPPF_FIELD.fieldApiName] = true;
            fields[DESCRIPTION_FIELD.fieldApiName] = '{'+new Date().toLocaleDateString("fr-FR")+'} - Annulé car client ayant contacté le service client pour problème de paiement de factures';
            const recordInput = { fields };

            updateRecord(recordInput)
                .then(() => {
                    console.log('Case updated successfully');
                    this.showSpinner = false;
                    this.dispatchEvent(new ShowToastEvent({
                        title: '',
                        message: 'Veuillez traiter la requête concernant le problème de paiement des factures du client ',
                        variant: 'success'
                    }));
                    this.closeTraitement();
                })
                .catch(error => {
                    console.log('Case update throw an error: '+JSON.stringify(erreur));
                    this.showSpinner = false;
                    this.dispatchEvent(new ShowToastEvent({
                        title: '',
                        message: 'Error occured: '+error,
                        variant: 'error'
                    }));
                });
        } 
        else {
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[STATUS_FIELD.fieldApiName] = 'HP_PENDING';
            fields[DESCRIPTION_FIELD.fieldApiName] = '{'+new Date().toLocaleDateString("fr-FR")+'} - Attente batch automatique';
            const recordInput = { fields };

            updateRecord(recordInput)
                .then(() => {
                    console.log('Case updated successfully');
                    this.showSpinner = false;
                    this.closeTraitement();
                })
                .catch(error => {
                    console.log('Case update throw an error: '+JSON.stringify(erreur));
                    this.showSpinner = false;
                    this.dispatchEvent(new ShowToastEvent({
                        title: '',
                        message: 'Error occured: '+error,
                        variant: 'error'
                    }));
                });
        }
    }

    closeTraitement() {
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null});
        this.dispatchEvent(event);
    }

}