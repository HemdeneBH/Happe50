/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-30-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, track, api, wire } from 'lwc';
import UsrId from '@salesforce/user/Id';
import {getRecord, getFieldValue, updateRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ROLE_DEV_NAME from '@salesforce/schema/User.UserRole.DeveloperName';
import USER_FIRST_NAME from '@salesforce/schema/User.FirstName';
import USER_LAST_NAME from '@salesforce/schema/User.LastName';
import ESCALADE_REASON from '@salesforce/schema/Case.HP_RaisonDetailleeEscalade__c';
import ID_FIELD from '@salesforce/schema/Case.Id';
export default class Hp_caseEscalade extends LightningElement {
    @api recordId;
    @track currentQueue;
    @track showSpinner = false;
    @track falseValue = false;
    @track currentCase;

    @wire(getRecord, {
        recordId: UsrId, 
        fields: [ROLE_DEV_NAME, USER_FIRST_NAME, USER_LAST_NAME]
    }) user;
    

    @wire(getRecord, { 
        recordId: '$recordId', 
        fields: [ESCALADE_REASON] 
    }) currentCase;

    get selectedQueue() {
        if(this.user == null || this.user.data == null) {
            return;
        }
        this.currentQueue = getFieldValue(this.user.data, ROLE_DEV_NAME);
        if(this.currentQueue == 'HP_Conseiller_Niveau_1') {
            return 'Niveau 2';
        }

        if(this.currentQueue == 'HP_Conseiller_Niveau_2') {
            return 'Niveau 3';
        }

        if(this.currentQueue == 'HP_Conseiller_Niveau_3') {
            return 'Niveau 2';
        }

        return null;
    }

    addPrefixedValue(newValue) {
        let existingReason = getFieldValue(this.currentCase.data, ESCALADE_REASON);
        const userFirstName = getFieldValue(this.user.data, USER_FIRST_NAME);
        const userLastNAme = getFieldValue(this.user.data, USER_LAST_NAME);
        if(existingReason) {
            existingReason = existingReason + "\n_________________________\n";
        }
        else {
            existingReason = "";
        }        

        let today = new Date();
        var dateStr = ("00" + today.getDate()).slice(-2) + "/" + ("00" + (today.getMonth() + 1)).slice(-2) + "/" 
                + today.getFullYear() + " " + ("00" + today.getHours()).slice(-2) + ":" + ("00" + today.getMinutes()).slice(-2);
        existingReason = existingReason + dateStr;
        existingReason = existingReason + " - " + userFirstName + " " + userLastNAme + " :\n" + newValue;
        
        return existingReason;
    }

    handleSubmit(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        fields.HP_RaisonDetailleeEscalade__c = this.addPrefixedValue(fields.HP_RaisonDetailleeEscalade__c); 
        let status = this.getstatus(fields.HP_QueueCible__c);
        if(status != null) {
            fields.Status = status;
            if(status == 'Escaladé (happe)') {
                fields.IsEscalated = true;
            } else {
                fields.IsEscalated = false;
            }
        } else {
            fields.IsEscalated = false;
        }
        console.log('fields : '+JSON.stringify(fields));
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
    handleSuccess(event) {
        this.showSpinner = false;
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Escalade fait avec succès',
            variant: 'success'
        }));
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new CustomEvent('closeupdate', { detail: null}));

    }
    handleError(err) {
        console.log(JSON.stringify(err));
        this.showSpinner = false;
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: "Erreur d'escalade, vous n'avez pas le droit de modifier cette requete.",
            variant: 'error'
        }));
    }
    getNiveau(role, prefix) {
        if(role == null) {
            return null;
        }
        try{
            return parseInt(role.replace(prefix, ''));
        }catch(ex) {
            return null;
        }
    }

    getstatus(queue) {
        try{        
            let currentLevel = this.getNiveau(this.currentQueue, 'HP_Conseiller_Niveau_');
            let escaladeLevel = this.getNiveau(queue, 'Niveau ');
            
            if(currentLevel > escaladeLevel) {
                return 'TO_DO';
            } else if(currentLevel < escaladeLevel) {
                return 'Escaladé (happe)';
            }
            return null;
        } catch(e) {
            return null;
        }
    }

    closeEscalade(){
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null});
        this.dispatchEvent(event);
    }
}