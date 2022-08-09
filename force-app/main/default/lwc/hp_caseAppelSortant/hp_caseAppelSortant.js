/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-27-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CASERAPPEL_FIELD from '@salesforce/schema/HP_AppelsSortants__c.HP_CaseRappel__c';
import RESULTAT_FIELD from '@salesforce/schema/HP_AppelsSortants__c.HP_ResultatRappel__c';
import REPONSE_FIELD from '@salesforce/schema/HP_AppelsSortants__c.HP_ReponseRappel__c';
import COMMENTAIRE_FIELD from '@salesforce/schema/HP_AppelsSortants__c.HP_CommentaireRappel__c';
import ID_FIELD from '@salesforce/schema/Case.Id';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import { getRecord, getFieldValue, updateRecord, createRecord } from 'lightning/uiRecordApi';

export default class Hp_caseAppelSortant extends LightningElement {
    @api recordId;
    @track showSpinner = false;
    selectedFields = [REPONSE_FIELD, RESULTAT_FIELD, COMMENTAIRE_FIELD];

    handleSubmitAppelsSortant(event) {
        this.showSpinner = true;
        event.preventDefault();
        console.log(this.recordId);
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
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Appel sortant enregistré avec succès',
            variant: 'success'
        }));
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new CustomEvent('closeupdate', { detail: null}));
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

    handleCancelAppelsSortant(){
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null});
        this.dispatchEvent(event);
    }
}