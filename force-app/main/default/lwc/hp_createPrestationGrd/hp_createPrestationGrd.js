/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 

 * @last modified on  : 10-11-2021

 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, wire, track, api } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PRESTATION_OBJECT from '@salesforce/schema/Prestation_distributeur__c';

import { getRecord, getFieldValue, updateRecord} from 'lightning/uiRecordApi';

import NUM_COMPTEUR from '@salesforce/schema/Case.HP_Contrat__r.HP_Id_Compteur__c';
import TYPE_COMPTEUR from '@salesforce/schema/Case.HP_Contrat__r.HP_Type_de_Compteur__c';
import TYPE_SOUSCRIPTION from '@salesforce/schema/Case.HP_Souscription__r.HP_type_Souscription__c';
import TYPE_HAPPE from '@salesforce/schema/Case.HP_Type__c';
import UsrId from '@salesforce/user/Id';
import OWNERID_FIELD from '@salesforce/schema/Case.OwnerId';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import ID_FIELD from '@salesforce/schema/Case.Id';
import SOUSCRIPTION_FIELD from '@salesforce/schema/Case.HP_Souscription__c';
import ID_HPS_FIELD from '@salesforce/schema/HP_Souscription__c.Id';
import DATE_HPS_FIELD from '@salesforce/schema/HP_Souscription__c.HP_Date_de_Contractualisation__c';
import CONTRAT_ID from '@salesforce/schema/Case.HP_Contrat__c';
import SOUS_TYPE_HAPPE_FIELD from '@salesforce/schema/Case.HP_Sous_type__c';
import STATUS_CODE_CRM from '@salesforce/schema/Case.HP_Contrat__r.HP_CodeStatutContrat__c';
import STATUS_CRM from '@salesforce/schema/Case.HP_Contrat__r.HP_StatutContrat__c';
import ID_XDATA_CONTRAT from '@salesforce/schema/Case.HP_Contrat__r.HP_Contrat_XdataId__c';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_createPrestationGrd extends LightningElement {

    @track showSpinner = false;
    @track showPrestationForm = undefined;
    @track showSwitchDialog = undefined;
    @track caseUpdate = false;
    @track newDate;
    @track prestaUrgente = false;

    @api recordId;
    
    @wire(getObjectInfo, { objectApiName: PRESTATION_OBJECT })
    prestationObject;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [ID_XDATA_CONTRAT,STATUS_CRM,STATUS_CODE_CRM,CONTRAT_ID,NUM_COMPTEUR,TYPE_COMPTEUR,TYPE_SOUSCRIPTION,TYPE_HAPPE,OWNERID_FIELD,STATUS_FIELD,ID_FIELD,SOUSCRIPTION_FIELD]
    }) case;

    get isPrestationAuto(){
        if(this.showSwitchDialog != undefined){
            return this.showSwitchDialog;
        }else 
        if(this?.case?.data){
            return getFieldValue(this.case.data, TYPE_HAPPE) === 'HP_AUTOMATED_PROCESS' ;
        }
    }

    get isPrestationManual(){
        if(this.showSwitchDialog != undefined){
            return !this.showSwitchDialog;
        }else 
        if(this?.case?.data){
            return getFieldValue(this.case.data, TYPE_HAPPE) != 'HP_AUTOMATED_PROCESS';
            }
        }

    get prestationRT() {
        if(this?.prestationObject?.data){
            const rtis = this.prestationObject.data.recordTypeInfos;
            return Object.keys(rtis).find(rti => rtis[rti].name === 'HP_PrestationDistributeur');
        }
    }

    handleSubmit(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;
        fields.RecordTypeId = this.prestationRT;
        fields.Numero_PDL_PCE__c = getFieldValue(this.case.data, NUM_COMPTEUR);
        fields.Statut__c = 'En cours';
        fields.Case__c = this.recordId;
        fields.Secteur_activite__c = getFieldValue(this.case.data, TYPE_COMPTEUR) == 'GAS' ? 'Gaz' : 'Elec';
        console.log(JSON.stringify(fields));
        fields.Situation_de_vente__c = getFieldValue(this.case.data, TYPE_SOUSCRIPTION) == 'MOVING_IN' ? 'Emménagement' :  'Changement de fournisseur';
        fields.Type_OPS__c = 'Recollement';
        fields.Name = fields.Numero_affaire_distributeur__c;
        if(this.prestaUrgente){
            this.updateCasePrestationUrgente();
        }
        this.updateSouscription();
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        
    }

    handleCheckboxChange(event){
        this.prestaUrgente = event.target.checked;
    }

    handleSuccess(event) {
        this.showSpinner = false;
        const payload = event.detail; 
        const updatedRecord = payload.id;
        console.log('onsuccess: ', updatedRecord);
        var objJSON = JSON.parse(JSON.stringify(payload));  
        const numDistribituer = objJSON["fields"]["Numero_affaire_distributeur__c"]["value"];   
        eval("$A.get('e.force:refreshView').fire();");
        const evt = new ShowToastEvent({
            "variant": "success",
            "message": "Prestation distributeur {0} créée avec succès",
            "messageData": [
                {
                    url: '/'+updatedRecord,
                    label: numDistribituer
                }
            ]
        });
        this.dispatchEvent(evt);
        this.dispatchEvent(new CustomEvent('closeupdate', { detail: null}));
    }

    handleError(err) {
        console.log(JSON.stringify(err));
        this.showSpinner = false;
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: "Erreur de création de prestation",
            variant: 'error'
        }));
    }

    closePrestation(){
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null});
        this.dispatchEvent(event);
    }

    handleChoice(event){
        if(event.target.value === 'oui'){
                this.showSwitchDialog = false;
                this.updateCase();
        }else{
            this.dispatchEvent(new CustomEvent('closeupdate', { detail: null}));
        }
            
    }

    handleDateChange(event){
        this.newDate = event.target.value;
    }

    updateCase(){
        const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[TYPE_HAPPE.fieldApiName] = 'HP_MANUAL_PROCESS';
            fields[OWNERID_FIELD.fieldApiName] = UsrId;
            fields[STATUS_FIELD.fieldApiName] = 'TO_DO';
            const recordInput = { fields };
            updateRecord(recordInput)
            .then(() => { })
            .catch(error => {
            });
    }

    updateCasePrestationUrgente(){
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[SOUS_TYPE_HAPPE_FIELD.fieldApiName] = 'Presta GRD urgente';
        fields[OWNERID_FIELD.fieldApiName] = UsrId;
        const recordInput = { fields };
        updateRecord(recordInput).then(() => { })
            .catch(error => {});
    }
    updateSouscription(){
        if(this?.case?.data){
            let souscription = getFieldValue(this.case.data, SOUSCRIPTION_FIELD);
            if(souscription!= null){
                const fields = {};
                fields[ID_HPS_FIELD.fieldApiName] = souscription;
                fields[DATE_HPS_FIELD.fieldApiName] = this.newDate;
                const recordInput = { fields };
                updateRecord(recordInput)
                .then(() => { 
                })
                .catch(error => {
                });
            }
        }
    }
}