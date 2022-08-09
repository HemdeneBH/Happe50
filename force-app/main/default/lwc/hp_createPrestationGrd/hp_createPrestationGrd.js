/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 

 * @last modified on  : 03-17-2022

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
import { LightningElement, wire, track, api } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import PRESTATION_OBJECT from '@salesforce/schema/Prestation_distributeur__c';
import CASE_OBJECT from '@salesforce/schema/Case';




import { getRecord, getFieldValue, updateRecord, createRecord} from 'lightning/uiRecordApi';

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
import CASE_RECORDTYPE_FIELD from '@salesforce/schema/Case.RecordTypeId';
import CONTACT_ID from '@salesforce/schema/Case.ContactId';
import ORIGIN from '@salesforce/schema/Case.Origin';
import PDLPCE from '@salesforce/schema/Case.HP_PDL_PCE__c';
import ENERGIE from '@salesforce/schema/Case.HP_Energy__c';
import PRIORITY from '@salesforce/schema/Case.Priority';
import TREATEMENTDAY from '@salesforce/schema/Case.HP_TreatmentDate__c';


import getQueueIdByName from '@salesforce/apex/HP_UTIL_QueueManager.getQueueIdByName';
import getPeriodeHivernaleEndDate from '@salesforce/apex/HP_EM054_CoupureReduction.getPeriodeHivernaleEndDate';

const queueN1 = 'HP_Niveau_1';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_createPrestationGrd extends LightningElement {

    @track showSpinner = false;
    @track showPrestationForm = undefined;
    @track showSwitchDialog = undefined;
    @track caseUpdate = false;
    @track newDate;
    @track typePresta = 'Souscription';
    @track prestaUrgente = false;
    @track caseRTID;
    @track caseRT;
    @track typeprestaRequired;

    @api recordId;
    
    @wire(getObjectInfo, { objectApiName: PRESTATION_OBJECT })
    prestationObject;

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    caseObject;


    @wire(getRecord, {
        recordId: '$recordId',
        fields: [CONTACT_ID,ORIGIN,PRIORITY,ID_XDATA_CONTRAT,STATUS_CRM,PDLPCE,STATUS_CODE_CRM,CONTRAT_ID,NUM_COMPTEUR,TYPE_COMPTEUR,TYPE_SOUSCRIPTION,TYPE_HAPPE,OWNERID_FIELD,STATUS_FIELD,ID_FIELD,SOUSCRIPTION_FIELD,CASE_RECORDTYPE_FIELD,ENERGIE]
    }) case;

    @wire(getQueueIdByName, {queueName : queueN1})
    queueId;

    @wire(getPeriodeHivernaleEndDate, {})
    periodeHivernaleEndDate;

    get isPrestationAuto(){

        if(this.showSwitchDialog != undefined){
            console.log('isPrestationAuto + showSwitchDialog :', showSwitchDialog);
            return this.showSwitchDialog;

        }else 
        if(this?.case?.data){
            console.log('isPrestationAuto + data :', getFieldValue(this.case.data, TYPE_HAPPE));
            return getFieldValue(this.case.data, TYPE_HAPPE) === 'HP_AUTOMATED_PROCESS' ;

        }
    }

    get isPrestationManual(){
        if(this.showSwitchDialog != undefined){
            console.log('isPrestationManual + showSwitchDialog :', showSwitchDialog);
            return !this.showSwitchDialog;
        }else 
        if(this?.case?.data){
            console.log('isPrestationManual + data :', getFieldValue(this.case.data, TYPE_HAPPE));
            return getFieldValue(this.case.data, TYPE_HAPPE) != 'HP_AUTOMATED_PROCESS';
            }
        }

    get prestationRT() {

        if(this?.prestationObject?.data){
            const rtis = this.prestationObject.data.recordTypeInfos;
            console.log('prestationRT: ', Object.keys(rtis).find(rti => rtis[rti].name));
            return Object.keys(rtis).find(rti => rtis[rti].name === 'HP_PrestationDistributeur');
        }
    }

    rtMethode() {
        const caseRTIDS = getFieldValue(this.case.data, CASE_RECORDTYPE_FIELD);
        console.log('caseRTIDS: ', caseRTIDS);
        const rtis = this.caseObject.data.recordTypeInfos;
        console.log('rtis: ', rtis);
        const rtPrestaId= Object.keys(rtis).find(rti => rtis[rti].name === 'Prestation distributeur');
        const rtFacturationId= Object.keys(rtis).find(rti => rtis[rti].name === 'Facturation');

        if(caseRTIDS === rtPrestaId){
            this.caseRT= 'HP_PrestationDistributeur';
        } else if(caseRTIDS === rtFacturationId){
            this.caseRT= 'HP_Facturation';    
        }else{
            this.caseRT= null;
        }
    }

    get types(){
        this.rtMethode();
        if(this.caseRT === 'HP_PrestationDistributeur'){
            this.typeprestaRequired = true;
            return [
                { label: 'Souscription', value: 'Souscription'},
            ];
        }else if(this.caseRT === 'HP_Facturation'){
            this.typeprestaRequired = false;
            return [
                { label: 'Réduction de puissance', value: 'ReductionDePuissance' },
                { label: 'Coupure', value: 'Coupure' },
                { label: 'Rétablissement', value: 'Retablissement' },
            ];
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
        if(getFieldValue(this.case.data, SOUSCRIPTION_FIELD) != null){
            if (getFieldValue(this.case.data, TYPE_SOUSCRIPTION) == 'MOVING_IN'){
                fields.Situation_de_vente__c = 'Emménagement';
            }else if(getFieldValue(this.case.data, TYPE_SOUSCRIPTION) == 'SWITCH_SUPLIER'){
                fields.Situation_de_vente__c = 'Changement de fournisseur';
            }
        }
        fields.Type_OPS__c = 'Recollement';
        fields.Name = fields.Numero_affaire_distributeur__c;
        fields.HP_Type_de_prestation__c = this.typePresta;
        fields.HP_Prestation_GRD_Urgente__c = this.prestaUrgente;
        fields.Contact__c = getFieldValue(this.case.data, CONTACT_ID);

        if(this.prestaUrgente && this.typePresta=='Souscription'){
            this.updateCasePrestationUrgente();
        }
        if(this.caseRT === 'HP_Facturation'){
            this.updateCaseFacturation();
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

    handleTypePresta(event){
        this.typePresta = event.target.value;
    }

    updateCase(){
        const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[TYPE_HAPPE.fieldApiName] = 'HP_MANUAL_PROCESS';
            fields[OWNERID_FIELD.fieldApiName] = UsrId;
            fields[STATUS_FIELD.fieldApiName] = 'TO_DO';
            if(this.prestaUrgente && this.typePresta=='Souscription'){
                fields[SOUS_TYPE_HAPPE_FIELD.fieldApiName] = 'Presta GRD urgente';
            }
            const recordInput = { fields };
            updateRecord(recordInput)
            .then(() => { })
            .catch(error => {
            });
    }

    updateCaseFacturation(){
        console.log('update case prestation grd methode');

        this.rtMethode();
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        if(this.caseRT === 'HP_Facturation'){
            if(this.typePresta==='Coupure'){
                console.log('HP_Coupure_');
                fields[TYPE_HAPPE.fieldApiName] = 'HP_Coupure_ReductionPuissance';
                fields[SOUS_TYPE_HAPPE_FIELD.fieldApiName] = 'Coupure';
            }else if(this.typePresta==='ReductionDePuissance'){
                console.log('HP_ReductionPuissance');
                fields[TYPE_HAPPE.fieldApiName] = 'HP_Coupure_ReductionPuissance';
                fields[SOUS_TYPE_HAPPE_FIELD.fieldApiName] = 'Réduction de puissance';
                this.createCaseCoupure();
            } else if(this.typePresta==='Retablissement'){
                console.log('RETABLISSEMENT');
                fields[TYPE_HAPPE.fieldApiName] = 'HP_Retablissement';
            }
            fields[OWNERID_FIELD.fieldApiName] = UsrId;
            fields[STATUS_FIELD.fieldApiName] = 'CLOSED';
        }
            const recordInput = { fields };
            updateRecord(recordInput)
            .then(() => { })
            .catch(error => {
            });
    }

    addDays(date, days) {
        var result = new Date(date);
        result.setDate(result.getDate() + days);
        return result;
      }

    createCaseCoupure(){
        console.log('CREATE CASE COUPURE METHODE ');
        const fields = {};
        const rtis = this.caseObject.data.recordTypeInfos;
        const rtFacturationId= Object.keys(rtis).find(rti => rtis[rti].name === 'Facturation');
        fields[CASE_RECORDTYPE_FIELD.fieldApiName] = rtFacturationId;
        fields[STATUS_FIELD.fieldApiName] = 'DELAYED_PROCESS';
        fields[CONTACT_ID.fieldApiName] =getFieldValue(this.case.data, CONTACT_ID);
        fields[ORIGIN.fieldApiName] = 'HP_CRM';
        fields[CONTRAT_ID.fieldApiName] =getFieldValue(this.case.data, CONTRAT_ID);
        fields[PDLPCE.fieldApiName] = getFieldValue(this.case.data, PDLPCE);
        fields[ENERGIE.fieldApiName] = getFieldValue(this.case.data, ENERGIE);
        console.log('fields.get(ENERGIE.fieldApiName)', getFieldValue(this.case.data, ENERGIE));
        fields[TYPE_HAPPE.fieldApiName] = 'HP_Coupure_ReductionPuissance';
        fields[SOUS_TYPE_HAPPE_FIELD.fieldApiName] = 'Coupure';
        fields[PRIORITY.fieldApiName] = 'Medium';
        console.log('this.periodeHivernaleEndDate.data',this.periodeHivernaleEndDate.data);
        fields[TREATEMENTDAY.fieldApiName] = this.addDays(this.periodeHivernaleEndDate.data,1);
        fields[OWNERID_FIELD.fieldApiName] = this.queueId.data;
        const recordInput = { 'apiName': CASE_OBJECT.objectApiName,fields };
        createRecord(recordInput).then(() => { })
            .catch(error => {
                console.log('error case coupure',error);

                this.showSpinner = false;
                this.dispatchEvent(new ShowToastEvent({
                    title: '',
                    message: "Erreur de création du case coupure",
                    variant: 'error'
                }));
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