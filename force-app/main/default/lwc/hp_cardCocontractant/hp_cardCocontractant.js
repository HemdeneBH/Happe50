import {LightningElement, track, api } from "lwc";
import {NavigationMixin} from "lightning/navigation";
import loadCocontractantInfo from '@salesforce/apex/HP_SM012_Souscription.loadDataCocontractant';
export default class Hp_cardCocontractant extends NavigationMixin(LightningElement) {
    @api recordId;
    @track cocontractantList;

    @track isCocontractant = false;
    connectedCallback() {
        loadCocontractantInfo({ contactId : this.recordId}).then(data => {
            this.cocontractantList = data;
            this.isCocontractant = (this.cocontractantList.length > 0)




        });
    }
    clickCocontractant(event){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  event.target.dataset.id,
                actionName: 'view',
            },
        })
    }
}