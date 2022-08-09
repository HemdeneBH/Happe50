/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-30-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, wire, track, api } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import { getRecord, getFieldValue, updateRecord, createRecord } from 'lightning/uiRecordApi';
import CONTACT_ID from '@salesforce/schema/Case.ContactId';
import ID_FIELD from '@salesforce/schema/Case.Id';
import QUEUESUBLE_FIELD from '@salesforce/schema/Case.HP_QueueCible__c';
import RT_DEV_CASE from '@salesforce/schema/Case.RecordType.DeveloperName';
import ROLE_DEV_NAME from '@salesforce/schema/User.UserRole.DeveloperName';
import UsrId from '@salesforce/user/Id';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_createReclamationCase extends LightningElement {

    @track showSpinner = false;
    @api recordId;
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;
    isTicTac;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [CONTACT_ID,RT_DEV_CASE]
    }) contact;

    @wire(getRecord, {
        recordId: UsrId, 
        fields: [ROLE_DEV_NAME]
    }) user;


    get reclamationRT() {
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Médiation / Réclamation');
    }

    get contactId() {
        if(this?.contact?.data) {
            return getFieldValue(this.contact.data, CONTACT_ID);
        }
        return null;
    }

    handleSubmit(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        fields.RecordTypeId = this.reclamationRT;
        fields.ContactId = this.contactId;

        fields.Status = 'HP_PENDING';
        fields.ParentId = this.recordId;
        fields.Reason = fields.HP_Motif__c;
        this.isTicTac = fields.HP_Type__c == 'HP_TIC_TAC';
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event) {
        this.showSpinner = false;
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        this.showReclamationCase = false;        
        if(!this.isTicTac) {
            eval("$A.get('e.force:refreshView').fire();");
            this.dispatchEvent(new ShowToastEvent({
                title: '',
                message: 'Requête créée avec succès',
                variant: 'success'
            }));
            this.dispatchEvent(new CustomEvent('closeupdate', { detail: null}));
               return;
           }
           let role;
           let val = null;
            role = getFieldValue(this.user.data, ROLE_DEV_NAME);
            if(role == 'HP_Conseiller_Niveau_1') {
                val = 'Niveau 2';
            }
    
            if(role == 'HP_Conseiller_Niveau_2') {
                val = 'Niveau 3';
            }
    
            if(val == null) {
              
                return;
            }
            const fields = {};
            fields[ID_FIELD.fieldApiName] = updatedRecord;
            fields[QUEUESUBLE_FIELD.fieldApiName] = val;
    
            const recordInput = { fields };
    
            updateRecord(recordInput)
                .then(() => {
                  
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: "Erreur d'escalade",
                            variant: 'error'
                        })
                    );
                  
                });
            eval("$A.get('e.force:refreshView').fire();");
            this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Requête créée avec succès',
            variant: 'success'
        }));
                this.dispatchEvent(new CustomEvent('closeupdate', { detail: null}));
    }
    closeReclamation(){
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null});
        this.dispatchEvent(event);
    }
}