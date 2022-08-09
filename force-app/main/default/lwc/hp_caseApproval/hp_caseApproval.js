import { LightningElement, track, api, wire } from 'lwc';
import UsrId from '@salesforce/user/Id';
import {getRecord, getFieldValue,updateRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ROLE_DEV_NAME from '@salesforce/schema/User.UserRole.DeveloperName';
import USER_FIRST_NAME from '@salesforce/schema/User.FirstName';
import USER_LAST_NAME from '@salesforce/schema/User.LastName';
import DEMANDE from '@salesforce/schema/Case.HP_ContDemApprobation__c';
import REPONSE from '@salesforce/schema/Case.HP_reponseApprobation__c';
import EMAILTOBEAPR from '@salesforce/schema/Case.HP_emailApproved__c';
import STATUS from '@salesforce/schema/Case.Status';

export default class Hp_caseApproval extends LightningElement {
    @api recordid;
    @track currentQueue;
    @track showSpinner = false;
    @track falseValue = false;
    @track currentCase;

    @wire(getRecord, {
        recordId: UsrId, 
        fields: [ROLE_DEV_NAME, USER_FIRST_NAME, USER_LAST_NAME]
    }) user;
    

    @wire(getRecord, { 
        recordId: '$recordid', 
        fields: [DEMANDE, REPONSE, EMAILTOBEAPR, STATUS] 
    }) currentCase;

    handleSubmit(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields; 
        if(getFieldValue(this.currentCase.data, STATUS)==null) {
            console.log('if1');
            fields.EMAILTOBEAPR = false;
            this.showSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: '',
                message: "Erreur d'approbation. Requête fermée ou annulée, vous n'avez pas le droit de modifier cette requete.",
                variant: 'error'
            }));
            
        } else {

            if( getFieldValue(this.currentCase.data, STATUS) =='CLOSED' || getFieldValue(this.currentCase.data, STATUS) =='CANCELED') {
            console.log('elseif2')

                fields.EMAILTOBEAPR = false;
                this.showSpinner = false;
                this.dispatchEvent(new ShowToastEvent({
                    title: '',
                    message: "Erreur d'approbation. Requête fermée ou annulée, vous n'avez pas le droit de modifier cette requete.",
                    variant: 'error'
                }));
            } else {
                console.log('else3');
                fields.HP_emailApproved__c = true;
                //fields.Status = 'APPROVAL';
                this.template.querySelector('lightning-record-edit-form').submit(fields);
            }

            
        }
        console.log(JSON.stringify(fields));
    }

    handleSuccess(event) {
        this.showSpinner = false;
        const payload = event.detail;
        //console.log("@@ payload : " + JSON.stringify(event));
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: "Demande d'approbation envoyé avec succès",
            variant: 'success'
        }));
        eval("$A.get('e.force:refreshView').fire();");

    }
    handleError(err) {
        console.log(JSON.stringify(err));
        this.showSpinner = false;
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: "Erreur d'approbation, vous n'avez pas le droit de modifier cette requete.",
            variant: 'error'
        }));
    }

    getstatus() {
        try{        
            return getFieldValue(this.currentCase.data, STATUS);
        } catch(e) {
            return null;
        }
    }
}