/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-05-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track, wire } from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import loadEnergieVerOption from '@salesforce/apex/HP_EC_LoadCustomerData.loadEnergieVerOption';
import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue} from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

export default class Hp_ec_offre extends LightningElement {

    @api titleText;
    @api detailOffreText;
    @api detailOffreURLGaz;
    @api detailOffreURLElec;
    @api detailOffreURLDual;
    @track contact;
    @track idClient;
    @track contractInfo;
    @track optionVerte;
    @track offreText;
    @track idPortefeuilleContrat;
    @track optionVerteTexte;
    @track isDual = false;
    @track currentEnergy;
    @wire(MessageContext) messageContext;
    @track componentStyle = 'hp-offre slds-col';



    @track areDetailsVisible = false;

    @wire(getContactData)
    wiredContact({ error, data }) {
        if (data) {
             this.contact = JSON.parse(data);
             this.idClient = this.contact.ID_Tiers__c;
        }else if(error){
            console.log('*** Error getContactData : '+JSON.stringify(error));
        }
    }

    @wire(getContractData)
    wiredContract({error, data}){
        if (data) {
            this.contractInfo = JSON.parse(data);
       }else if(error){
           console.log('*** Error getContractData : '+JSON.stringify(error));
       }
    }

    async populateContractInfo(){
        let contractCount = 0;
        let contractCountElec = 0;
        let contractCountGaz = 0;
        let optionText = '';
        if(!this.contractInfo){
            const conractInfoData = await this.getContractdata();
            this.contractInfo = JSON.parse(conractInfoData);
        }
        if(this?.contractInfo){
            let today = new Date();
            for(let i = 0; i<this.contractInfo._data.length;i++){
                if(this.contractInfo._data[i].idPortefeuilleContrat == this.idPortefeuilleContrat){
                    let dateFinValidite = new Date(this.contractInfo._data[i].dateFinValidite);
                    let diffTime = Math.abs(today - dateFinValidite);
                    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                    let isOldContract = (diffDays > 365) && (today > dateFinValidite);
                    try {
                        if(this.contractInfo._data[i].codeStatutCrm == 'H0105' || this.contractInfo._data[i].codeStatutCrm == 'H0101' ||
                        this.contractInfo._data[i].codeStatutCrm == 'H0102' || this.contractInfo._data[i].codeStatutCrm == 'E0004' || 
                        this.contractInfo._data[i].codeStatutCrm == 'E0007' || 
                        ((this.contractInfo._data[i].codeStatutCrm == 'E0009' && !isOldContract) || (this.contractInfo._data[i].codeStatutCrm == 'H0103' && !isOldContract))){
                            
                            if(this.contractInfo._data[i].energie == 'Electricité' && contractCountElec <1){
                                contractCountElec ++;
                                this.componentStyle = 'hp-offre purple slds-col';
                                const optionVerteResponse = await this.hasOptionVerte(this.contractInfo._data[i].id);
                                this.currentEnergy = this.contractInfo._data[i].energie;
                                if(optionVerteResponse.output != null && optionVerteResponse.output[0] && optionVerteResponse.output[0]?.option && optionVerteResponse.output[0].option.vert == true){
                                    this.offreText = 'Electricité - Option électricité verte';
                                    optionText = ' - Option électricité verte';
                                }else{
                                    this.offreText = 'Electricité';
                                }                       
                            }else if(this.contractInfo._data[i].energie == 'Gaz Naturel' && contractCountGaz <1){
                                contractCountGaz ++;
                                this.componentStyle = 'hp-offre blue slds-col';
                                this.currentEnergy = this.contractInfo._data[i].energie;
                                this.offreText = 'Gaz';
                            }else{
                                continue;
                            }
                            contractCount ++;
                        }
                    } catch (error) {
                        console.log('Error Catched : ' + error.message);
                    }
                    
                }
            }
        }    
        if(contractCount == 2){
            this.componentStyle = 'hp-offre purple slds-col';
            this.isDual = true;
            this.offreText = 'Dual- électricité et Gaz' + optionText;
            this.currentEnergy = 'Electricité';
        }else{
            this.isDual = false; 
        }
        console.log(window.location.href);
        this.handlePublish(this.currentEnergy);
    }

    async hasOptionVerte(contractId){
        return new Promise(async (resolve, reject) => {
            var result = await loadEnergieVerOption({contractId : JSON.stringify(contractId)}).then(response => {
                return response;
            }).catch(error => {
                console.log('***Error LoadEnergieVerte : ' + JSON.stringify(error));
                return error;
            }); 
            resolve(result);
        })
    }

    async getContractdata(contractId){
        return new Promise(async (resolve, reject) => {
            var result = await getContractData({}).then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getContractData : ' + JSON.stringify(error));
                return error;
            }); 
            resolve(result);
        })
    }

    handleChange(event) {
        this.areDetailsVisible = event.target.checked;
    }

    get offreURL(){
        return this.isDual ? this.detailOffreURLDual : this.currentEnergy == 'Electricité' ? this.detailOffreURLElec : this.detailOffreURLGaz;
    }

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    handleType (event) {
        if(event.detail == 'Electricité'){
            this.componentStyle = 'hp-offre purple slds-col';
        }else{
            this.componentStyle = 'hp-offre blue slds-col'; 
        }
        this.updateOptionsArray(this.typeOptions, event.detail);
        this.handlePublish(event.detail);
    }

    typeOptions = [
        {
            value: 'Electricité',
            label: "Élec",
            checked: true
        },
        {
            value: 'Gaz Naturel',
            label: "Gaz",
            checked: false
        }
    ];

    connectedCallback() {
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.handleSubscription(); 
        this.populateContractInfo();
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this,this.messageContext, this.handleLightningMessage);
        }
    } 

    handleLightningMessage(self,subscription, message) {
        if(message.messageType == 'SelectedPortfolio'){
            self.idPortefeuilleContrat = message.messageData.message;
            self.populateContractInfo();
        }  
    }

    handlePublish(message) {
        publishMC(this.messageContext, message, 'SelectedEnergy');
    }


    updateOptionsArray(array, value) {
        return array.map(option => {
            if (option.value == value) {
                return {...option, checked: true};
            }
            return {...option, checked: false};
        });
    }

}