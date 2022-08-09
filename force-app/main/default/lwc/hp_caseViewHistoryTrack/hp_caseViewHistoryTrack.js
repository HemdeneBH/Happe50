import { LightningElement, api, wire } from 'lwc';
import insertCaseHistoryView from '@salesforce/apex/HP_SM049_CaseViewHistory.insertCaseHistoryView';

export default class Hp_caseViewHistoryTrack extends LightningElement {
    @api recordId;
    connectedCallback() {
        insertCaseHistoryView({caseId : this.recordId}).then(resultat => {

        });
    }
}