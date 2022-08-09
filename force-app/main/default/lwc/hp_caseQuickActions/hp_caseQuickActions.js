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
import { getRecord, getFieldValue, updateRecord, createRecord } from 'lightning/uiRecordApi';
import CONTACT_ID from '@salesforce/schema/Case.ContactId';
import PHONE_CONTACT from '@salesforce/schema/Case.ContactMobile';
import RT_DEV_CASE from '@salesforce/schema/Case.RecordType.DeveloperName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import QUEUESUBLE_FIELD from '@salesforce/schema/Case.HP_QueueCible__c';
import OWNERID_FIELD from '@salesforce/schema/Case.OwnerId';
import ID_FIELD from '@salesforce/schema/Case.Id';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import UsrId from '@salesforce/user/Id';
import ROLE_DEV_NAME from '@salesforce/schema/User.UserRole.DeveloperName';
import strUserId from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';

import APPELS_SORTANTS_OBJECT from '@salesforce/schema/HP_AppelsSortants__c';
import CASERAPPEL_FIELD from '@salesforce/schema/HP_AppelsSortants__c.HP_CaseRappel__c';
import RESULTAT_FIELD from '@salesforce/schema/HP_AppelsSortants__c.HP_ResultatRappel__c';
import REPONSE_FIELD from '@salesforce/schema/HP_AppelsSortants__c.HP_ReponseRappel__c';
import COMMENTAIRE_FIELD from '@salesforce/schema/HP_AppelsSortants__c.HP_CommentaireRappel__c';

export default class Hp_caseQuickActions extends LightningElement {
    @api recordId;
    @track updateClientPopupModal = false;
    @track showReclamationCase = false;
    @track showSpinner = false;
    @track showPlanificationCase = false;
    @track showAppelsSortant = false;
    @track showSpinnerPl = false;
    selectedFields = [REPONSE_FIELD, RESULTAT_FIELD, COMMENTAIRE_FIELD];
    @wire(getRecord, {
        recordId: '$recordId',
        fields: [CONTACT_ID, PHONE_CONTACT,RT_DEV_CASE]
    }) caseObject;
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;
    dateRappel;
    isTicTac;
    plTime;
    ownerName;  
    ownerId;

    @wire(getRecord, {
        recordId: UsrId, 
        fields: [ROLE_DEV_NAME, NAME_FIELD]
    }) user;



    get userId() {
        return strUserId;
    }

    get userName() {
        return  getFieldValue(this.user.data, NAME_FIELD);
    }


    get isTelRTDevName() {
        if(this?.caseObject?.data) {
            return getFieldValue(this.caseObject.data, RT_DEV_CASE) == "HP_Telephone";
        }
        return false;
    }

    get contactId() {
        if(this?.caseObject?.data) {
            return getFieldValue(this.caseObject.data, CONTACT_ID);
        }
        return null;
    }
    get contactPhone() {
        if(this?.caseObject?.data) {
            return getFieldValue(this.caseObject.data, PHONE_CONTACT);
        }
        return null;
    }
    updateClientPopupModalPopupModal() {
        this.updateClientPopupModal = false;
    }
    openClientPopupModalPopupModal() {
        this.updateClientPopupModal = true;
    }
    openReclamationPopupModalPopupModal() {
        this.showReclamationCase = true;
    }
    closeReclamationPopupModalPopupModal() {
        this.showReclamationCase = false;
    }
    get reclamationRT() {
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Médiation / Réclamation');
    }
    
    get phoneRT() {
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Téléphone');
    }
    
    handleSubmit(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        fields.RecordTypeId = this.reclamationRT;
        fields.ContactId = getFieldValue(this.caseObject.data, CONTACT_ID);

        fields.Status = 'HP_PENDING';
        fields.ParentId = this.recordId;
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

        if(!this.isTicTac) {
            window.location.reload();
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




        const fields = {};
            fields[ID_FIELD.fieldApiName] = updatedRecord;
            fields[OWNERID_FIELD.fieldApiName] = this.ownerId != null ? this.ownerId: strUserId;
    
            const recordInput = { fields };
            updateRecord(recordInput)
                .then(() => {
                  
                })
                .catch(error => {
                   
                  
                });





    }
    

    handleCancelAppelsSortant() {
        this.showAppelsSortant = false;

    }
    
    handleSubmitAppelsSortant(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        fields[CASERAPPEL_FIELD.fieldApiName] = this.recordId;
        this.template.querySelector('lightning-record-form').submit(fields);
        
        let status = this.getstatusAppelsSortant(fields.HP_ResultatRappel__c);
        const caseFields = {};
        caseFields[STATUS_FIELD.fieldApiName] = status;
        caseFields[ID_FIELD.fieldApiName] = this.recordId;
        const recordInput = { fields: caseFields };

        console.log(recordInput);
        updateRecord(recordInput)
        .then(() => {
            
        })
        .catch(error => {
            this.showSpinner = false;
            console.log(error);
            this.dispatchEvent(new ShowToastEvent({
                title: '',
                message: "Erreur lors de la mise à jour du case.",
                variant: 'error'
            }));
        });
        
    }
    handleSuccessAppelsSortant() {
        this.showSpinner = false;
        this.showAppelsSortant = false;
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Appel sortant enregistré avec succès',
            variant: 'success'
        }));
        eval("$A.get('e.force:refreshView').fire();");
    }
    handleErrorAppelsSortant(error) {
        this.showSpinner = false;
        console.log(error);
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: "Erreur d'enregistrement de l'appel sortant, vous n'avez pas le droit de modifier cette requete.",
            variant: 'error'
        }));
    }

    getstatusAppelsSortant(resultat) {
        try{        
            if(resultat === 'HP_LeadTransforme' || resultat === 'HP_LeadNonTransforme' || resultat === 'HP_ClientInjoignable') {
                return 'CLOSED';
            } else if(resultat === 'HP_DemandeRappel' || resultat === 'HP_ARappeler') {
                return 'TO_DO';
            }
        } catch(e) {
            return null;
        }
    }

    openAppelsSortantPopupModal() {
        this.showAppelsSortant = true;
    }

    closeAppelsSortantPopupModal() {
        this.showAppelsSortant = false;
    }

    handleSubmitAppelsSortant(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        fields[CASERAPPEL_FIELD.fieldApiName] = this.recordId;
        this.template.querySelector('lightning-record-form').submit(fields);
        
        let status = this.getstatusAppelsSortant(fields.HP_ResultatRappel__c);
        const caseFields = {};
        caseFields[STATUS_FIELD.fieldApiName] = status;
        caseFields[ID_FIELD.fieldApiName] = this.recordId;
        const recordInput = { fields: caseFields };

        console.log(recordInput);
        updateRecord(recordInput)
        .then(() => {
            
        })
        .catch(error => {
            this.showSpinner = false;
            console.log(error);
            this.dispatchEvent(new ShowToastEvent({
                title: '',
                message: "Erreur lors de la mise à jour du case.",
                variant: 'error'
            }));
        });
        
    }
    handleSuccessAppelsSortant() {
        this.showSpinner = false;
        this.showAppelsSortant = false;
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Appel sortant enregistré avec succès',
            variant: 'success'
        }));
        eval("$A.get('e.force:refreshView').fire();");
    }
    handleErrorAppelsSortant(error) {
        this.showSpinner = false;
        console.log(error);
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: "Erreur d'enregistrement de l'appel sortant, vous n'avez pas le droit de modifier cette requete.",
            variant: 'error'
        }));
    }

    getstatusAppelsSortant(resultat) {
        try{        
            if(resultat === 'HP_LeadTransforme' || resultat === 'HP_LeadNonTransforme' || resultat === 'HP_ClientInjoignable') {
                return 'CLOSED';
            } else if(resultat === 'HP_DemandeRappel' || resultat === 'HP_ARappeler') {
                return 'TO_DO';
            }
        } catch(e) {
            return null;
        }
    }

    openAppelsSortantPopupModal() {
        this.showAppelsSortant = true;
    }

    closeAppelsSortantPopupModal() {
        this.showAppelsSortant = false;
    }

    openPlanifierRappelPopupModal() {
        this.showPlanificationCase = true;
    }

    closePlanifierRappelPopupModal() {
        this.showPlanificationCase = false;
    }

    handleErrorPL(event) {
        this.showPlanificationCase = false;
        console.log("handleError event");
        console.log(JSON.stringify(event.detail));
    }

    rappelDateHandler(event) {
        this.dateRappel = event.target.value;
    }



    onRecordSelection(event) {
        this.ownerName = event.detail.selectedValue;  
        this.ownerId = event.detail.selectedRecordId;  
    }


}