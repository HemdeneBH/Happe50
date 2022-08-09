import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';


import IDENTIFIANT_BUISNESS_PARTENER__c from '@salesforce/schema/Contact.Identifiant_Buisness_Partener__c';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import EMAIL_FIELD2 from '@salesforce/schema/Contact.Adresse_Mail_2__c';
import EMAIL_FIELD3 from '@salesforce/schema/Contact.Adresse_Mail_3__c';
import MAIN_EMAIL from '@salesforce/schema/Contact.Adresse_Mail_Principale__c';


import setEdocumentStatus from "@salesforce/apex/SM_CTRL001_FreeServices.setEdocumentStatus";
import demanderSouscriptionServiceRef from "@salesforce/apex/SM_AP89_GestionSouscriptionService.demanderSouscriptionServiceRef";
import desactiverServiceGestion from "@salesforce/apex/SM_AP89_GestionSouscriptionService.desactiverServiceGestion";
import getKnowledge from "@salesforce/apex/SM_CTRL001_FreeServices.getKnowledge";

const FIELDS = [IDENTIFIANT_BUISNESS_PARTENER__c, EMAIL_FIELD, EMAIL_FIELD2, EMAIL_FIELD3, MAIN_EMAIL];
export default class Sm_FreeServices extends LightningElement {
    @api eDocumentStatus = false;
    @api felStatus = false;
    @api customerAreaUnavailable = false;
    @api noEmail = false;


    @api eventTargetName = null;
    @api displayFelInstruction = false;
    @api displayEDocumentInstruction = false;
    @api felInstruction;
    @api eDocumentInstruction;


    @api accountContract;
    @api felSpinner = false;
    @api eDocumentSpinner = false;
    @api recordId = null;
    @api felError = false;
    @api felErrorMessage = null;
    @api eDocumentError = false;
    @api eDocumentErrorMessage = null;


    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) contact;
    // FEL Status Update
    handleSetFelStatus(event) {
        this.felStatus = event.target.checked;
        this.felSpinner = true;
        let mail;
        let mainMail = getFieldValue(this.contact.data, MAIN_EMAIL);


        if(mainMail == 'Adresse Mail 1'){
            mail = getFieldValue(this.contact.data, EMAIL_FIELD);
        } else if(mainMail == 'Adresse Mail 2'){
            mail = getFieldValue(this.contact.data, EMAIL_FIELD2);
        } else if(mainMail == 'Adresse Mail 3'){
            mail = getFieldValue(this.contact.data, EMAIL_FIELD3);
        }
        //if checked 
        if(this.felStatus===true){
            demanderSouscriptionServiceRef({inputMap: { 
                refClientIdBP: getFieldValue(this.contact.data, IDENTIFIANT_BUISNESS_PARTENER__c),
                account: this.accountContract,
                mail: mail}})
                .then(result => {
                    if(result.code == 'OCTOPUS_DemanderSouscriptionService_01'){
                        this.felError = false;
                        this.felErrorMessage = null;
                        this.felSpinner = false;
                    } else {
                        this.felError = true;
                        this.felErrorMessage = result.libelle;
                        this.felStatus = !this.felStatus;
                        this.felSpinner = false;
                        console.error("Erreur WebService demanderSouscriptionServiceRef, code : ", result.code);
                    }
                })
                .catch(error => {
                    this.felStatus = !this.felStatus;
                    this.felSpinner = false;
                    console.error("Erreur handleSetFelStatus ", error);
                });
        }else{
            desactiverServiceGestion({inputMap: { 
                account: this.accountContract}})
                .then(result => {
                    if(result.code == 'OCTOPUS_DesactiverServiceGestion_01'){
                        this.felError = false;
                        this.felErrorMessage = null;
                        this.felSpinner = false;
                    } else {
                        this.felError = true;
                        this.felErrorMessage = result.libelle;
                        this.felStatus = !this.felStatus;
                        this.felSpinner = false;
                        console.error("Erreur WebService desactiverServiceGestion, code : ", result.code);
                }
            })
            .catch(error => {
                this.felStatus = !this.felStatus;
                this.felSpinner = false;
                    console.error("Erreur handleSetFelStatus", error);
                });
        }
    }
    // eDocument Status Update
    handleSetEdocumentStatus(event) {
        this.eDocumentStatus = event.target.checked;
        this.eDocumentSpinner = true;


        setEdocumentStatus({inputMap: { 
            refClientIdBP: getFieldValue(this.contact.data, IDENTIFIANT_BUISNESS_PARTENER__c),
            eDocumentChoices: event.target.checked }})
            .then(result => {
                if(result.code == 'OCTOPUS_MAJPersonne_01'){
                    this.eDocumentError = false;
                    this.eDocumentErrorMessage = null;
                    this.eDocumentSpinner = false;
                } else {
                    this.eDocumentError = true;
                    this.eDocumentErrorMessage = result.libelle;
                    this.eDocumentStatus = !this.eDocumentStatus;
                    this.eDocumentSpinner = false;
                    console.error("Erreur WebService setEdocumentStatus, code : ", result.code);
                }
            })
            .catch(error => {
                this.eDocumentStatus = !this.eDocumentStatus;
                this.eDocumentSpinner = false;
                console.error("Erreur handleSetEdocumentStatus ", error);
            });
    }
    // Get Knowledge
    handleGetKnowledge(event) {
        this.eventTargetName = event.target.name;
        getKnowledge({inputMap: {
                felMigrationKey:'000001045',
                eDocumentMigrationKey:'000001405'}})
            .then(result => {
                this.felInstruction = result.felInstruction;
                this.eDocumentInstruction = result.eDocumentInstruction;
                if(this.eventTargetName == "felKnowledgeLink"){
                    this.displayFelInstruction = !this.displayFelInstruction;
                }
                if(this.eventTargetName == "eDocumentKnowledgeLink"){
                    this.displayEDocumentInstruction = !this.displayEDocumentInstruction;
                }
            })
            .catch(error => {
                console.error("Erreur handleGetKnowledge ", error);
            });
    }
    // Close Knowledge
    handleCloseKnowledge(event) {
        this.eventTargetName = event.target.name;
        if(this.eventTargetName == "felKnowledgeLink"){
            this.displayFelInstruction = !this.displayFelInstruction;
        }
        if(this.eventTargetName == "eDocumentKnowledgeLink"){
            this.displayEDocumentInstruction = !this.displayEDocumentInstruction;
        }
    }


    // Tab closing
    handleCloseFreeServicesTab(){
        const closeFreeServicesTab = new CustomEvent('closeFreeServicesTab');
        this.dispatchEvent(closeFreeServicesTab); 
    }
}