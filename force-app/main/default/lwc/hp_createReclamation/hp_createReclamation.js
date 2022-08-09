/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-28-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, track, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import { getRecord, getFieldValue, updateRecord} from 'lightning/uiRecordApi';
import CONTACT_ID from '@salesforce/schema/HP_Souscription__c.HP_Contact__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


import QUEUESUBLE_FIELD from '@salesforce/schema/Case.HP_QueueCible__c';
import ID_FIELD from '@salesforce/schema/Case.Id';
import UsrId from '@salesforce/user/Id';
import ROLE_DEV_NAME from '@salesforce/schema/User.UserRole.DeveloperName';


export default class Hp_createReclamation extends LightningElement {
    @api recordid;
    @track updateClientPopupModal = false;
    @track showReclamationCase = false;
    @track showSpinner = false;
    @wire(getRecord, {
        recordId: '$recordid',
        fields: [CONTACT_ID]
    }) souscription;
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;

    isTicTac;
    @wire(getRecord, {
        recordId: UsrId, 
        fields: [ROLE_DEV_NAME]
    }) user;

    get reclamationRT() {
        if(this.objectInfo == null || this.objectInfo.data == null || this.objectInfo.data.recordTypeInfos == null) {
            return null;
        }
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Médiation / Réclamation');
    }

    handleSubmit(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        fields.RecordTypeId = this.reclamationRT;
        fields.ContactId = getFieldValue(this.souscription.data, CONTACT_ID);

        fields.Status = 'HP_PENDING';
        fields.HP_Souscription__c = this.recordid;
        fields.Reason = fields.HP_Motif__c;
        console.log(JSON.stringify(fields));
        this.isTicTac = fields.HP_Type__c == 'HP_TIC_TAC';
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
    handleSuccess(event) {
        this.showSpinner = false;
        const payload = event.detail;
        //console.log("@@ payload : " + JSON.stringify(event));
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        this.showReclamationCase = false;
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Requête créée avec succès',
            variant: 'success'
        }));
        this.dispatchEvent(new CustomEvent('close'));
        

        if(!this.isTicTac) {
            eval("$A.get('e.force:refreshView').fire();");
               return;
           }
            let role = getFieldValue(this.user.data, ROLE_DEV_NAME);
            let val = null;
            if(role == 'HP_Conseiller_Niveau_1') {
                val = 'Niveau 2';
            }
    
            if(role == 'HP_Conseiller_Niveau_2') {
                val = 'Niveau 3';
            }
    
            if(val == null) {
                eval("$A.get('e.force:refreshView').fire();");
                return;
            }
            const fields = {};
            fields[ID_FIELD.fieldApiName] = updatedRecord;
            fields[QUEUESUBLE_FIELD.fieldApiName] = val;
    
            const recordInput = { fields };
    
            updateRecord(recordInput)
                .then(() => {
                    eval("$A.get('e.force:refreshView').fire();");
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur',
                            message: "Erreur d'escalade",
                            variant: 'error'
                        })
                    );
                    eval("$A.get('e.force:refreshView').fire();");
                });

    }
    closeReclamationPopupModalPopupModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}