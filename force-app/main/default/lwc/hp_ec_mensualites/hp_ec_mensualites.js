/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-11-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track, wire } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import getEcheanceContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getEcheanceContractData';
import getPorteFeuilleContratXdata from '@salesforce/apex/HP_EC_LoadCustomerData.getPorteFeuilleContratXdata';
import getContratInfo from '@salesforce/apex/HP_EC_LoadCustomerData.getContratInfo';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

export default class Hp_ec_mensualites extends LightningElement {
    @api titreMensualites;
    @api titreMontantMensuel;
    @api titreDatePaiement;
    @api alerteMensualites;
    @api modifierMensualitesBoutton;
    @api paramGlobale;
    @api messageErreur;

    @track showPopin = false;
    @track montantMensuel;
    @track montantElec;
    @track montantGaz;
    @track datePaiementText;
    @track idPortefeuilleContrat;
    @track contractInfo;
    @track showMe = true;
    @track isDual = false;
    @track errorMessage='';
    @track showError = false;
    @track jourPrelevement;
    @track contactId;
    @track contractCount = 0;

    @wire(MessageContext) messageContext;

    iconAlert = HP_EC_icon_alert;

    @wire(getContactData)
    wiredContact({ error, data }) {
        if (data) {
             this.contact = JSON.parse(data);
             this.contactId = this.contact.Id;
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
           console.log('*** Error Wire getContractData : '+JSON.stringify(error));
       }
    }

    async getContractdata(){
        return new Promise(async (resolve, reject) => {
            var result = await getContractData({}).then(response => {
                return response;
            }).catch(error => {
                console.log('*** Error get Contract Data : ' + JSON.stringify(error));
                return error;
            }); 
            resolve(result);
        })
    }

    async populateMensualites(){
        try {
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
                    if(this.contractInfo._data[i].codeStatutCrm == 'H0105' || this.contractInfo._data[i].codeStatutCrm == 'H0101' ||
                    this.contractInfo._data[i].codeStatutCrm == 'H0102' || this.contractInfo._data[i].codeStatutCrm == 'E0004' || this.contractInfo._data[i].codeStatutCrm == 'E0007' || 
                    ((this.contractInfo._data[i].codeStatutCrm == 'E0009' && !isOldContract) || (this.contractInfo._data[i].codeStatutCrm == 'H0103' && !isOldContract))){
                        this.contractCount++;
                        let contractID = JSON.stringify(this.contractInfo._data[i].id);
                        getContratInfo({ idContrat : contractID})
                        .then(response => {
                            const MY_RESPONSE = JSON.parse(response);
                            this.datePaiementText = MY_RESPONSE?.output?.jour_drp ? 'Le ' + MY_RESPONSE.output.jour_drp +' du mois' : undefined;
                            this.jourPrelevement = MY_RESPONSE?.output?.jour_drp ? MY_RESPONSE.output.jour_drp : '';
                        })
                        .catch(error => {
                            console.log('***Error Get Contrat Info: ' + JSON.stringify(error));
                        }); 
                        getEcheanceContractData({ id_contrat_xdata : contractID})
                        .then(response => {
                            const myResponse = JSON.parse(response);
                            if(myResponse?.output?.echeance_0){
                                this.showError = false;
                                let echeanceMontant = parseInt(myResponse.output.echeance_0.montant_ttc);
                                if(this.contractInfo._data[i].energie === 'Electricité'){
                                    this.montantElec = echeanceMontant;
                                }else{
                                    this.montantGaz = echeanceMontant;
                                }
                                if(this.contractCount > 1 && this.montantElec && this.montantGaz){
                                    const montantTotal = this.montantElec + this.montantGaz; 
                                    this.montantMensuel = montantTotal + ' €';
                                    this.isDual = true;
                                }else{
                                    this.montantMensuel = myResponse.output.echeance_0.montant_ttc + ' €';
                                    this.isDual = false;
                                }
                                var array = Object.keys(myResponse.output)
                                            .map(function(key) {
                                                return myResponse.output[key];
                                            });
                                let firstEcheance = this.findFirstEchInfuture(array);
                                if(!this.datePaiementText && firstEcheance != null){
                                    const dateEcheance = firstEcheance.date_decheance.split('-');
                                    this.datePaiementText = 'Le ' + dateEcheance[2] +' du mois';
                                    this.jourPrelevement = dateEcheance[2];
                                }
                                if(firstEcheance == null){
                                    this.showError = true; 
                                }
                            }else{
                                this.showError = true;
                            }
                        })
                        .catch(error => {
                            console.log('***Error Get Echeance Contract Data: ' + JSON.stringify(error));
                        }); 
                    }
                }
            }
            if(this.contractCount == 0){
                this.showError = true;
            }
        }            
        } catch (error) {
            console.log('Error in populateMensualites : '+ error.message);
        }
        
    }

    async loadPortefeuilleContrat(){
        const pfcInfo = await this.loadPortefeuilleContratAsync();
        this.pftcInfo = JSON.parse(pfcInfo);
        this.showMe = this.pftcInfo.libelleRythmeFacturation == this.paramGlobale.trim() ;
    }

    async loadPortefeuilleContratAsync(){
        return new Promise(async (resolve, reject) => {
            var result = await getPorteFeuilleContratXdata({contractPortfolioXdataId : this.idPortefeuilleContrat}).then(response => {
                return response;
            }).catch(error => {
                console.log('***Error loadPortefeuilleContratAsync : ' + JSON.stringify(error));
                return error;
            }); 
            resolve(result);
        })
    }


    findFirstEchInfuture(echList) {
        let keys = Object.keys(echList);
        if(keys.length == 0) {
            return null;
        }
        let minEch = null;
        let today = new Date();
        for(let key of keys) {
            let currentDate = new Date(echList[key].date_decheance);
            if(minEch == null && currentDate >= today) {
                minEch = echList[key];
                minEch.dt = currentDate;
                continue;
            }
            if(minEch != null && currentDate >= today && minEch.dt > currentDate) {
                minEch = echList[key];
                minEch.dt = currentDate;
            }
        } 
        return minEch;
    }

    handleChange(event){
        this.showPopin = true
    }

    closePopin(event){
        if(event.detail.hide === true){
            if(event.detail.newAmount){
                this.montantMensuel = event.detail.newAmount + ' €';
            }
            if(event.detail.newDate){
                this.datePaiementText = 'Le ' + event.detail.newDate + ' du mois';
            }
            this.showPopin = false;
        }else{
            this.showPopin = true;
        }
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
        this.populateMensualites();
        this.loadPortefeuilleContrat(); 
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this,this.messageContext, this.handleLightningMessage);
        }
    } 

    handleLightningMessage(self,subscription, message) {
        if(message.messageType == 'SelectedPortfolio'){
            self.idPortefeuilleContrat = message.messageData.message;
            self.populateMensualites();
            self.loadPortefeuilleContrat();
        }  
    }

    handlePublish(message) {
    }

}