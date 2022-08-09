import { LightningElement, api } from 'lwc';
import getCaseOrders from "@salesforce/apex/SM_CTRL010_InfosCPV.getCaseOrders";

export default class SmCPVCard extends LightningElement {
    @api recordId;
    orderItems;

    showCPVForm=false;spinner=false;

    connectedCallback() {
        getCaseOrders({caseId: this.recordId}).then(result => {
            console.log('result caseOrders 3: ',JSON.stringify(result));
            this.orderItems = result;
        }).catch(error => {
            console.log('error caseOrders: ',error);
        })
    }
    /* openModal() {
        this.showCPVForm = true;
    }
    closeModal() {
        this.showCPVForm = false;
    } */
    submit(){
        this.spinner = true;
        setTimeout(() => {
            this.showCPVForm = false;
            this.spinner = false;
        }, 1200);
    }
}