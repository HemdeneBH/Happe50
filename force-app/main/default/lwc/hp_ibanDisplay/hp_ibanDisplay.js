import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import insertCaseHistoryView from '@salesforce/apex/HP_SM051_IBANViewHistory.insertCaseHistoryView';

import loadCustomMetadata from '@salesforce/apex/HP_SM003_MetadataManager.getConfigurationGenerique';

const FIELDS = ['HP_Souscription__c.HP_IBAN__c'];

export default class Hp_ibanDisplay extends LightningElement {
    @api
    recordId;

    @track
    ibanDisplay = '*****************';

    delay;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    souscription;
    connectedCallback() {
        loadCustomMetadata({cleConfiguration : 'HP_DELAY_IBAN'}).then(result => {
            this.delay = parseInt(result);
        });
    }
    showIBAN() {
        this.ibanDisplay = this.souscription.data.fields.HP_IBAN__c.value;
        setTimeout(() => {
            this.ibanDisplay = '*****************';
        }, this.delay);

        insertCaseHistoryView({iban : this.ibanDisplay, souscriptionId : this.recordId, contactId : null}).then(result => {

        });
    }
}