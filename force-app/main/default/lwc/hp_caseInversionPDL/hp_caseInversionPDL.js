import { api, LightningElement, track, wire } from 'lwc';
import { getRecord, createRecord, updateRecord } from 'lightning/uiRecordApi';

import CASE_OBJECT from '@salesforce/schema/Case';
import ID_FIELD from '@salesforce/schema/Case.Id';

import RECORDTYPEID_FIELD from '@salesforce/schema/Case.RecordTypeId';
import HPTYPE_FIELD from '@salesforce/schema/Case.HP_Type__c';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import OWNERID_FIELD from '@salesforce/schema/Case.OwnerId';
import PRIORITY_FIELD from '@salesforce/schema/Case.Priority';
import PARENTID_FIELD from '@salesforce/schema/Case.ParentId';

import ORIGIN_FIELD from '@salesforce/schema/Case.Origin';
import CONTACTID_FIELD from '@salesforce/schema/Case.ContactId';
import PORTEFEUILLE_HAPPE_FIELD from '@salesforce/schema/Case.Portefeuille_Contrat_Happe__c';
import CONTRAT_FIELD from '@salesforce/schema/Case.HP_Contrat__c';
import PDLPCE_FIELD from '@salesforce/schema/Case.HP_PDL_PCE__c';
import ENERGY_FIELD from '@salesforce/schema/Case.HP_Energy__c';
import HPCLIENTAIDE_FIELD from '@salesforce/schema/Case.HP_Client_Aide__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';
import HPSOUSTYPE_FIELD from '@salesforce/schema/Case.HP_Sous_type__c';


export default class Hp_caseInversionPDL extends LightningElement {

    @api recordId;
    @track showSpinner = false;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [OWNERID_FIELD,ORIGIN_FIELD,CONTACTID_FIELD,PORTEFEUILLE_HAPPE_FIELD,CONTRAT_FIELD,PDLPCE_FIELD,ENERGY_FIELD,HPCLIENTAIDE_FIELD,DESCRIPTION_FIELD,STATUS_FIELD]
    }) case;

    validateInversionPDL() {
        this.showSpinner = true;
        const fields = {};
        fields[RECORDTYPEID_FIELD.fieldApiName] = this.case.data.recordTypeInfo.recordTypeId;
        fields[HPTYPE_FIELD.fieldApiName] = 'HP_Inversion_PDL';
        fields[HPSOUSTYPE_FIELD.fieldApiName] = 'Suspicion Inversion de PDL';
        fields[STATUS_FIELD.fieldApiName] = 'TO_DO';
        fields[OWNERID_FIELD.fieldApiName] = this.case.data.fields.OwnerId.value;
        fields[PRIORITY_FIELD.fieldApiName] = 'High';
        fields[PARENTID_FIELD.fieldApiName] = this.recordId;
        // Données de la requête : Reprise des données du case de coupure
        fields[ORIGIN_FIELD.fieldApiName] = this.case.data.fields.Origin.value;
        fields[CONTACTID_FIELD.fieldApiName] = this.case.data.fields.ContactId.value;
        fields[PORTEFEUILLE_HAPPE_FIELD.fieldApiName] = this.case.data.fields.Portefeuille_Contrat_Happe__c.value;
        fields[CONTRAT_FIELD.fieldApiName] = this.case.data.fields.HP_Contrat__c.value;
        fields[PDLPCE_FIELD.fieldApiName] = this.case.data.fields.HP_PDL_PCE__c.value;
        fields[ENERGY_FIELD.fieldApiName] = this.case.data.fields.HP_Energy__c.value;
        fields[HPCLIENTAIDE_FIELD.fieldApiName] = this.case.data.fields.HP_Client_Aide__c.value;

        const recordInput = { apiName: CASE_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then(caseCreated => {
                console.log('Case created successfully');     
                this.updateOriginCase(caseCreated.id);
            })
            .catch(erreur => {
                console.log('Case creation throw an error: '+JSON.parse(erreur));
                this.showSpinner = false;
            });
    }

    updateOriginCase(caseCreatedId) {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[STATUS_FIELD.fieldApiName] = 'CANCELED';
        fields[HPSOUSTYPE_FIELD.fieldApiName] = 'Suspicion Inversion de PDL';
        fields[DESCRIPTION_FIELD.fieldApiName] = '{'+new Date().toLocaleDateString("fr-FR")+'} : Inversion de PDL';
        const RecordInput = { fields };

        updateRecord(RecordInput)
            .then(() => {
                console.log('Case updated successfully');

                eval("$A.get('e.force:closeQuickAction').fire();");
                var navEvt = eval("$A.get('e.force:navigateToSObject');");
                navEvt.setParams({
                    "recordId": caseCreatedId
                });
                navEvt.fire();

                this.showSpinner = false;
                this.closeInversionPDL();
            })
            .catch(erreur => {
                console.log('Case update throw an error: '+ JSON.stringify(erreur));
            });
    }

    closeInversionPDL() {
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null});
        this.dispatchEvent(event);
    }
}