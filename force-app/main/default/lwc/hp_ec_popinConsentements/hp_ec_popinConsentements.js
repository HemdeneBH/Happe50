/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-27-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, wire, track } from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import { refreshApex } from '@salesforce/apex';


import getQuestionsConsent from '@salesforce/apex/HP_EC_LoadCustomerData.getQuestionsConsentement';
import getConsentResponses from '@salesforce/apex/HP_EC_LoadCustomerData.getReponsesConsentement';
import saveClient from '@salesforce/apex/HP_EC_UpdateCustomerData.updateConsentementXdata';
import updateConsentementInfos from '@salesforce/apex/HP_EC_UpdateCustomerData.updateConsentementInfos';
import updateOptinMarketing from '@salesforce/apex/HP_EC_UpdateCustomerData.updateOptinMarketing';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import optinMarketingPhrase from '@salesforce/label/c.HP_optinMarketingPhrase';
import CONTACT_OPTIN_MARKETING from '@salesforce/schema/Contact.HP_OptinMarketing__c';

import { getRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

export default class Hp_ec_popinConsentements extends LightningElement {
    @api popinconsentementstitle;
    @api idclient;
    @api boutonsubmitpopinconsentement;
    @track yesNo = [
        { label: '', value: 'oui' },
        { label: '', value: 'non' }
    ];
    @track questions;
    @track consentementList=[];
    wiredConsentementList;
    @track responses;
    @track recordId;
    @track indicatif = '+33';
    @track contactInfo;
    @track optinMarketing;
    @track optinMarketingResponse;

    

    iconAlert = HP_EC_icon_alert;
    iconClose = HP_EC_close_icon_light;

    @wire(getContactData)
    wiredContact({ error, data }) {
        if (data) {
             this.contactInfo = JSON.parse(data);
             this.recordId = this.contactInfo.Id;
             
        }else if(error){
            console.log('*** Error getContactData : '+JSON.stringify(error));
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: [CONTACT_OPTIN_MARKETING] })
    wiredContactData({ error, data }) {
        if (data) {
            this.optinMarketing = data.fields.HP_OptinMarketing__c.value;
            this.optinMarketingResponse = this.optinMarketing == true ? 'oui' : 'non';
        } else if (error) {
            console.log(error);
        }
    }

    marketingLabels = {
        optinMarketingPhrase
    };

    closePopinConsentements(event){
        this.dispatchEvent(new CustomEvent('openpopinconsentements', { detail: false}));
    }

    @wire (getQuestionsConsent)
    wiredQuestionsConsent({ error, data }) {
        if(data){
            this.questions = data;
            for (let index = 0; index < this.questions.length; index++) {
                this.consentementList.push({
                    idPersonne: 0,
                    libelleQuestion: this.questions[index].libelleQuestion,
                    idQuestion: parseInt(this.questions[index].idQuestion),
                    idQuestionnaire: parseInt(this.questions[index].idQuestionnaire),
                    consent: false,
                    canal: 'Telephone',
                    application: 'HAPPE',
                    name: 'consent'+index ,
                    response : 'non'
                });
            } 
        }if(error){
            console.log('Error : '+JSON.stringify(error));
        }
        
    }

    @wire(getConsentResponses, {idPersonne:'$idclient'})
        wiredConsentResponses(value){
            this.wiredConsentementList = value;
            const {error, data} = value;
            if(data){
                this.responses = data;
                let responseMap = {};
                for (let i = 0; i < this.responses.length ; i++) {
                    responseMap[this.responses[i].idQuestionnaire + '-' + this.responses[i].idQuestion] = {};
                    responseMap[this.responses[i].idQuestionnaire + '-' + this.responses[i].idQuestion].consent = this.responses[i].consent; 
                    responseMap[this.responses[i].idQuestionnaire + '-' + this.responses[i].idQuestion].id = this.responses[i].id; 
                }
                for(let i = 0; i < this.consentementList.length; i ++) {
                    let resp = responseMap[this.consentementList[i].idQuestionnaire + '-' + this.consentementList[i].idQuestion];
                    if(resp == null) {
                        continue;
                    }
                    this.consentementList[i].id = resp.id;
                    this.consentementList[i].response = (resp.consent ? 'oui' : 'non');
                    this.consentementList[i].consent = resp.consent;
                }
            }else if(error){
                console.log('Error : '+JSON.stringify(error));
            }
        }

    handleSubmit() {
        for(let i = 0; i < this.consentementList.length; i ++) {
            this.consentementList[i].consent = (this.consentementList[i].response == 'oui');
        }
        saveClient({idClient:this.idclient, concentementList:this.consentementList}).then(result => {
        }).catch(error => {
            console.log('Erreure saveClient : '+JSON.stringify(error));
        });

        updateConsentementInfos({idClient:this.idclient, concentementList:this.consentementList}).then(result => {
        }).catch(error =>{
            console.log('Erreure updateConsentementInfos : '+JSON.stringify(error));
        });

        updateOptinMarketing({idClient:this.idclient, optinMarketing: this.optinMarketing}).then(result => {
        }).catch(error =>{
            console.log('Erreure updateOptinMarketing : '+JSON.stringify(error));
        });

        this.dispatchEvent(new CustomEvent('openpopinconsentements', { detail: false}));
    }

    consentementChanged(event){
        for(let i = 0; i < this.consentementList.length; i ++) {
            if(this.consentementList[i].name == event.currentTarget.dataset.id) {
                this.consentementList[i].consent = event.target.checked;
                this.consentementList[i].response = this.consentementList[i].consent ? 'oui' : 'non';
                return;
            }
        }
    }

    renderedCallback() {
        if (this.hasRenderedOnce) {
            refreshApex(this.wiredConsentementList);
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
        
    }

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    optinMarketingChange(event){
        this.optinMarketing = event.target.checked;
        this.optinMarketingResponse = this.optinMarketing == true ? 'oui' : 'non';
    }

}