/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-28-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, wire, api, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import { getRecord, getFieldValue, updateRecord, createRecord } from 'lightning/uiRecordApi';
import strUserId from '@salesforce/user/Id';
import CONTACT_ID from '@salesforce/schema/Case.ContactId';
import PHONE_CONTACT from '@salesforce/schema/Case.ContactMobile';
import RT_DEV_CASE from '@salesforce/schema/Case.RecordType.DeveloperName';
import UsrId from '@salesforce/user/Id';
import ROLE_DEV_NAME from '@salesforce/schema/User.UserRole.DeveloperName';
import NAME_FIELD from '@salesforce/schema/User.Name';
import OWNERID_FIELD from '@salesforce/schema/Case.OwnerId';
import ID_FIELD from '@salesforce/schema/Case.Id';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_casePlanifierRappel extends LightningElement {

    @api recordId;
    @track showSpinnerPl = false;

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;
    plTime;
    ownerName;  
    ownerId;
    
    @wire(getRecord, {
        recordId: '$recordId',
        fields: [CONTACT_ID,PHONE_CONTACT,RT_DEV_CASE]
    }) contact;

    @wire(getRecord, {
        recordId: UsrId, 
        fields: [ROLE_DEV_NAME, NAME_FIELD]
    }) user;

    get phoneRT() {
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Téléphone');
    }

    get userId() {
        return strUserId;
    }

    get userName() {
        return  getFieldValue(this.user.data, NAME_FIELD);
    }

    get contactId() {
        if(this?.contact?.data) {
            return getFieldValue(this.contact.data, CONTACT_ID);
        }
        return null;
    }
    
    get contactPhone() {
        if(this?.contact?.data) {
            return getFieldValue(this.contact.data, PHONE_CONTACT);
        }
        return null;
    }
    
    handlePLTimeChange(event) {
        this.plTime = event.target.value;
    }

    handleSubmitPL(event) {
        
        event.preventDefault();
        let valid = true;
        this.template.querySelectorAll('.date-rappel').forEach(element => {
            valid = element.reportValidity();
        });
        if(!valid) {
            return;
        }
        this.showSpinnerPl = true;
        let fields = event.detail.fields;
        fields.RecordTypeId = this.phoneRT;

        fields.HP_TreatmentTime__c = this.plTime;

        fields.OwnerId = this.ownerId != null ? this.ownerId: strUserId;
        fields.Status = 'DELAYED_PROCESS';
        fields.Origin = 'HP_CRM';

        fields.ParentId = this.recordId;
        fields.HP_Type__c = 'HP_Rappel_planifie';
        fields.HP_Sous_type__c = 'Aucun';
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccessPL(event) {
        this.showSpinnerPl = false;
       // console.log("@@ payload : " + JSON.stringify(event));
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        this.showPlanificationCase = false;
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Requête créée avec succès',
            variant: 'success'
        }));
        this.dispatchEvent(new CustomEvent('closeupdate', { detail: null}));
        const fields = {};
            fields[ID_FIELD.fieldApiName] = updatedRecord;
            fields[OWNERID_FIELD.fieldApiName] = this.ownerId != null ? this.ownerId: strUserId;
            const recordInput = { fields };
            updateRecord(recordInput)
                .then(() => { })
                .catch(error => {
                });
    }
    closePlanifier(){
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null});
        this.dispatchEvent(event);
    }

    onRecordSelection(event) {
        this.ownerName = event.detail.selectedValue;  
        this.ownerId = event.detail.selectedRecordId;  
    }
}