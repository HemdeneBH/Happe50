import { LightningElement, api, track,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import 	Type_FIELD from '@salesforce/schema/Case.Type';
import 	SousType_FIELD from '@salesforce/schema/Case.Sous_type__c';
import 	Origin_FIELD from '@salesforce/schema/Case.Origin';
import 	Status_FIELD from '@salesforce/schema/Case.Status';
import 	AccountId_FIELD from '@salesforce/schema/Case.AccountId';
import 	RecordType_FIELD from '@salesforce/schema/Case.RecordTypeId';
import 	ContactId_FIELD from '@salesforce/schema/Case.ContactId';
import 	MotifIneligibilite_FIELD from '@salesforce/schema/Case.SM_MotifIneligibiliteDelaiPaiement__c';
import 	SousStaut_FIELD from '@salesforce/schema/Case.Sous_statut__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class SmNoteDebitCredit extends LightningElement {
    @api listnotedebitcredit;
    @track listnotdebcred;
    @api IdBusinessPartner;
    @api AccountId;
    @api recordId;
    @api EnqSat;
    checkedPause;
    checkedInteraction;
    DRId_Case;
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT }) objectInfo;

    connectedCallback() {
        console.log('note deb cred ',this.listnotedebitcredit);
        this.listnotedebitcredit = JSON.parse(this.listnotedebitcredit);
        console.log(this.listnotedebitcredit);
        if(this.listnotedebitcredit != null && this.listnotedebitcredit.x_data != null && this.listnotedebitcredit.x_data.length > 0){
            this.listnotdebcred = this.listnotedebitcredit.x_data;
        }
        console.log('listnotdebcred ',this.listnotdebcred);
    }


    closeTab() {
        let close = true;
        const closeclickedevt = new CustomEvent('closeclicked', {
            detail: close 
        });
        // Fire the custom event
        this.dispatchEvent(closeclickedevt);
    }

    handlePause(event){
        this.checkedPause = event.target.checked;
    }
    handleInteraction(event){
        console.log("change");
        this.checkedInteraction = event.target.checked;
    }
    caseNavigate(){
        this.nextDisable = true;
        this.noDataCase = false;
        if(this.checkedInteraction){
             this.createCase(true);             
        }
        else if(this.checkedPause){
            this.createCase(true);
        }   
    }
    @api
    get nextDisabled(){
        if(this.nextDisable){
            return true;
        }
        if(((this.checkedPause && this.checkedInteraction) || (!this.checkedPause && !this.checkedInteraction)) && !this.messageInegibilite){
            return true;
        }
        return false
    }
    navigateToInteraction(){
        const eventName = 'openInteraction';
        let inputMap;
        //Params pour interaction
        console.log(' navigateToInteraction idbp '+this.IdBusinessPartner);
        if(this.checkedInteraction ){
            inputMap = {
                isActivateTracerInteractionOS: true,
                isCasNominal:true,
                isPauseInteraction: false,
                DRId_Case:this.DRId_Case,
                StepNameOS:'Note débit crédit',
                refClientIdBP:this.IdBusinessPartner,
                isLWC:true,
                EnqSat:this.EnqSat
            }
        }
      //Params pour mise en pause
        else if(this.checkedPause){
            inputMap = {
            isActivateTracerInteractionOS: true,
            isCasNominal:false,
            isPauseInteraction: true,
            DRId_Case:this.DRId_Case,
            StepNameOS:'Note débit crédit',
            refClientIdBP:this.IdBusinessPartner,
            isLWC:true,
            EnqSat:this.EnqSat
            }
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    createCase(callback) {
        const fields = {};    
          let caseStatus
          if(this.checkedInteraction){
               caseStatus = 'Pré-clôturé';
               fields[SousStaut_FIELD.fieldApiName] = 'Conforme';
          }else{
              caseStatus = 'Pré-clôturé';
              fields[SousStaut_FIELD.fieldApiName] = 'Conforme';
          }
          fields[Type_FIELD.fieldApiName] = 'Paiement';
          fields[SousType_FIELD.fieldApiName] = "Suivi paiement ou remboursement";
          fields[Origin_FIELD.fieldApiName] = 'Phone';
          fields[Status_FIELD.fieldApiName] = caseStatus;
          //fields[AccountId_FIELD.fieldApiName] = this.AccountId;
          fields[ContactId_FIELD.fieldApiName] =this.recordId;
          //console.log('this.AccountId '+this.AccountId);
          console.log('this.recordId '+this.recordId);
          const rtis = this.objectInfo.data.recordTypeInfos;
          //find and set recordType==Service 
          fields[RecordType_FIELD.fieldApiName]= Object.keys(rtis).find(rti => rtis[rti].name === 'Service');
          const recordInput = {
              apiName: CASE_OBJECT.objectApiName,
              fields
          };
          createRecord(recordInput).then(acase => {
              this.DRId_Case = acase.id;
              console.log('case créé DRId_Case '+this.DRId_Case);
              if(callback){
                  this.navigateToInteraction();
                  this.closeTab();
              }
          })
          .catch(error => {
                  console.log('erreur lors de la création du case' +JSON.stringify(error));
                  this.dispatchEvent(
                      new ShowToastEvent({
                          title: 'Erreur dans la création Case',
                              message: JSON.stringify(error),
                          variant: 'error',
                      }),
                  );
              });
      }

    /*get listnotedebcred() {
        console.log('note deb cred ',this.listnotedebitcredit);
        let listdata;
        if(listnotedebitcredit){
            listdata = JSON.parse(this.listnotedebitcredit);
        }
        console.log('note deb cred parse ',listdata);
        return listdata;
    }*/
}