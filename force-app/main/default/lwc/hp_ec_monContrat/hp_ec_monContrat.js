/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-11-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track, wire } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import loadEnergieVerOption from '@salesforce/apex/HP_EC_LoadCustomerData.loadEnergieVerOption';
import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';
import {  NavigationMixin } from 'lightning/navigation';

export default class Hp_ec_monContrat extends NavigationMixin(LightningElement) {

    @api titleText;
    @api voirContractButtonLabel;
    @api justificatifButtonLabel;
    @wire(MessageContext) messageContext;
    @track titleContrat;
    @track contractInfo;
    @track contact;
    @track idClient;
    @track idPortefeuilleContrat;
    @track contractList = [];

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
            console.log('conractInfoData : '+conractInfoData);
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
                    if(this.contractInfo._data[i].codeStatutCrm == 'H0105' || this.contractInfo._data[i].codeStatutCrm == 'H0101' ||
                    this.contractInfo._data[i].codeStatutCrm == 'H0102' || this.contractInfo._data[i].codeStatutCrm == 'E0004' || 
                    this.contractInfo._data[i].codeStatutCrm == 'E0007'  || 
                    ((this.contractInfo._data[i].codeStatutCrm == 'E0009' && !isOldContract) || (this.contractInfo._data[i].codeStatutCrm == 'H0103' && !isOldContract))){
                        if(this.contractInfo._data[i].energie == 'Electricité' && contractCountElec <1){
                            contractCountElec ++;
                            this.contractList.push({
                                id:1,
                                idXdata : this.contractInfo._data[i].id
                            });
                            const optionVerteResponse = await this.hasOptionVerte(this.contractInfo._data[i].id);
                            if(optionVerteResponse.output && optionVerteResponse.output[0] && optionVerteResponse.output[0].option && optionVerteResponse.output[0].option.vert == true){
                                this.titleContrat = 'Contrat électricité - Option Vertélec+ happ-e';
                                optionText = ' - Option Vertélec+ happ-e';
                            }else{
                                this.titleContrat = 'Contrat électricité';
                            }
                        }else if(this.contractInfo._data[i].energie == 'Gaz Naturel' && contractCountGaz <1){
                            contractCountGaz ++;
                            this.contractList.push({
                                id:1,
                                idXdata : this.contractInfo._data[i].id
                            });
                            this.titleContrat = 'Contrat gaz';
                        }else{
                            continue;
                        }
                        contractCount ++;
                    }
                }
            }
        }
        if(contractCount == 2){
            this.titleContrat = 'Contrat électricité et gaz' + optionText;
        }
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

    async getContractdata(){
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

    handleVoirContract(event){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Mon_contrat__c'
            },
        });
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

    connectedCallback() {
        this.handleSubscription();
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.populateContractInfo();
    }

    handleSubscription() {

        if (!this.subscription) {
            console.log('je me souscris depuis Offre');
            subscribeMC(this,this.messageContext, this.handleLightningMessage);
        }
    } 

    handleLightningMessage(self,subscription, message) {
        if(message.messageType == 'SelectedPortfolio'){
            self.idPortefeuilleContrat = message.messageData.message;
            self.contractList = [];
            self.populateContractInfo();
        }  
    }

    handlePublish(message) {
    }

    handleJustificatif(event){
        // TO_DO
        // en atttente de agilab pour la gestion des documents
    }

}