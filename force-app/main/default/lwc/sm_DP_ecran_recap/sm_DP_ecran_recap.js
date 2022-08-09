import { LightningElement,api  } from 'lwc';
import recapImg from '@salesforce/resourceUrl/recapDP';
import { updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Case.Id';
import 	Status_FIELD from '@salesforce/schema/Case.Status';
import 	SousStaut_FIELD from '@salesforce/schema/Case.Sous_statut__c';

import recapfilarianne from '@salesforce/resourceUrl/sm_filariannedprecap'; 

export default class Sm_DP_ecran_recap extends LightningElement {
    @api montanttotal;
    @api montantpremiereecheance;
    @api datepremiereecheance;
    @api nombreecheance;
    @api caseid;
    @api articlekbrecap;
    imageUrl = recapImg;

    imagefilariane = recapfilarianne;

    /* closeDPTab(){
        var close = true;
        const closeclickedevt = new CustomEvent('closeDPTabEvent', {
            detail: close 
        });
        // Fire the custom event
        this.dispatchEvent(closeclickedevt);
    }
    updateCaseStatus(){
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.caseid;
        fields[Status_FIELD.fieldApiName] = 'Pré-clôturé';
        fields[SousStaut_FIELD.fieldApiName] = 'Conforme';
        const recordInput = { fields };
        updateRecord(recordInput)
                .then(() => {
                    console.log('case mis à jour '+this.caseid);
                })
                .catch(error => {
                    console.log('erreur lors de la maj du case '+JSON.stringify(error));
                });
    }
    navigateToInteraction(){
        const eventName = 'openInteraction';
        let inputMap;
        //Params pour interaction
        inputMap = {
            isActivateTracerInteractionOS: true,
            isCasNominal:true,
            isPauseInteraction: false,
            DRId_Case:this.caseid,
            StepNameOS:'Délai de paiement',
            refClientIdBP:this.idBusinessPartner,
            isLWC:true
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    traceInteractionRedirection(){
        this.updateCaseStatus();
        this.navigateToInteraction();
        this.closeDPTab();
    }*/
}