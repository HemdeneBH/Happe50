/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-13-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track, wire } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_valid from '@salesforce/resourceUrl/HP_EC_icon_valid';

import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getGrilleTarifaire from '@salesforce/apex/HP_EC_LoadCustomerData.getGrilleTarifaire';
import getContratInfo from '@salesforce/apex/HP_EC_LoadCustomerData.getContratInfo';
import loadEnergieVerOption from '@salesforce/apex/HP_EC_LoadCustomerData.loadEnergieVerOption';
import getPorteFeuilleContratXdata from '@salesforce/apex/HP_EC_LoadCustomerData.getPorteFeuilleContratXdata';
import getContractTranquility from '@salesforce/apex/HP_EC_LoadCustomerData.getContractTranquility';
import getContractsAddresses from '@salesforce/apex/HP_EC_LoadCustomerData.getContractsAddresses';
import {  NavigationMixin } from 'lightning/navigation';

import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

export default class Hp_ec_optionsServices extends NavigationMixin(LightningElement) {

    @api titleText;
    @api optionVertElecLabel;
    @api dateReglementPersonnaliseLabel;
    @api modePaiementLabel;
    @api factureEnLigneLabel;
    @api depanExpressLabel;
    @api depanExpressURL;
    @api voirOptionsURL;
    @api voirOptionsLabel;
    @api labelBouttonPopinOptionVerteActif;
    @api labelBouttonPopinOptionVerteInactif;
    @api textExplicatifPopinOptionVerte;
    @api texteIntroductifPopinOptionVerte;
    @api texteAlertePopinOptionVerte;
    @api titrePopinOptionVerte;

    @track factureEnLigneStatus;
    @track dateReglementStatus;
    @track optionVertElecStatus;
    @track showCheckFactureEnLigne;

    @track etatOption;
    @track labelBouttonPopin;
    @track textExplicatifPopin;
    @track texteAlertePopin;
    @track titrePopin;
    @track texteIntroductif;

    @track contractInfo;
    @track contact;
    @track idClient;
    @track pftcInfo;
    @track currentEnergy;
    @track idPortefeuilleContrat;
    @track isElec = false;
    @track depanExpressStatus = 'Actif';
    @track hasDepanExpress = false;
    @track optionType;
    @track currentContractId;
    @track showGereFactureEnLigne = false;

    @wire(MessageContext) messageContext;

    @track showPopin = false;

    iconChecked = HP_EC_icon_valid;
    iconAlert = HP_EC_icon_alert;
    iconClose = HP_EC_close_icon_light;

    @track  oContractsAddresses;
    @track codePostale;

    @wire(getContractsAddresses) 
    wiredContractsAddresses({ error, data }) {
        if (data) {
            this.oContractsAddresses = JSON.parse(data);
        }
        else if (error) {
            console.log('Error get addresses : ' + JSON.stringify(error));
        }
    }

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
        let optionText = '';
        if(!this.contractInfo){
            const contractInfoData = await this.getContractdata();
            this.contractInfo = JSON.parse(contractInfoData);
        }
        if(!this.idPortefeuilleContrat && !this.currentEnergy){
            return;
        }
        if(this?.contractInfo){
            let today = new Date();
            for(let i = 0; i<this.contractInfo._data.length;i++){
                if(this.contractInfo._data[i].idPortefeuilleContrat == this.idPortefeuilleContrat && this.contractInfo._data[i].energie == this.currentEnergy){
                    let dateFinValidite = new Date(this.contractInfo._data[i].dateFinValidite);
                    let diffTime = Math.abs(today - dateFinValidite);
                    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                    let isOldContract = (diffDays > 365) && (today > dateFinValidite);
                    if(this.contractInfo._data[i].codeStatutCrm == 'H0105' || this.contractInfo._data[i].codeStatutCrm == 'H0101' ||
                    this.contractInfo._data[i].codeStatutCrm == 'H0102' || this.contractInfo._data[i].codeStatutCrm == 'E0004' || 
                    this.contractInfo._data[i].codeStatutCrm == 'E0007' || 
                    ((this.contractInfo._data[i].codeStatutCrm == 'E0009' && !isOldContract) || (this.contractInfo._data[i].codeStatutCrm == 'H0103' && !isOldContract))){
                        this.currentContractId = this.contractInfo._data[i].id;
                        let contractID = JSON.stringify(this.currentContractId);
                        getContratInfo({ idContrat : contractID})
                        .then(response => {
                            const MY_RESPONSE = JSON.parse(response);
                            this.factureEnLigneStatus = MY_RESPONSE.output.mode_envoi_facture == 'électronique' ? 'Actif' : 'Inactif';
                            this.showCheckFactureEnLigne = this.factureEnLigneStatus == 'Actif';
                            this.dateReglementStatus = MY_RESPONSE.output?.jour_drp ? 'Actif' : 'Inactif';
                        })
                        .catch(error => {
                            console.log('Error getContratInfo option est services : ' + JSON.stringify(error));
                        });
                        this.getCurrentPostalCode();
                        getContractTranquility({ idPersonne : JSON.stringify(this.idClient)})
                        .then(response => {
                            const MY_RESPONSE = JSON.parse(response);
                            if(MY_RESPONSE.contratList && MY_RESPONSE.contratList.length>0){
                                let contList =  MY_RESPONSE.contratList;
                                for(let tranquillityContrat of contList) {
                                    if (this.codePostale === (tranquillityContrat.localAssure.codePostal).toString()) {
                                        this.hasDepanExpress = true;
                                        break;
                                    }else{
                                        this.hasDepanExpress = false;
                                    }
                                }
                            }else {
                                this.hasDepanExpress = false;
                            }
                        })
                        .catch(error => {
                            this.hasDepanExpress = false;
                            console.log('Error getContractTranquility : ' + error);
                        });
                        if(this.contractInfo._data[i].energie === 'Electricité'){
                            this.isElec = true;
                            const optionVerteResponse = await this.hasOptionVerte(this.contractInfo._data[i].id);
                            if(optionVerteResponse.output && optionVerteResponse.output[0] && optionVerteResponse.output[0].option && optionVerteResponse.output[0].option.vert == true){
                                this.optionVertElecStatus = 'Actif';
                            }else{
                                this.optionVertElecStatus = 'Inactif';
                            }                       
                        }else{
                            this.isElec = false;  
                        }
                    }
                }
            }
        }
    }

    async loadPortefeuilleContrat(){
        const pfcInfo = await this.loadPortefeuilleContratAsync();
        this.pftcInfo = JSON.parse(pfcInfo);
        const rythmeFacturation = this.pftcInfo.libelleRythmeFacturation == 'Annuel' ? 'Mensuel' : this.pftcInfo.libelleRythmeFacturation == 'Bimensuel' ? 'Bimestriel' : this.pftcInfo.libelleRythmeFacturation;
        this.modePaiementLabel = this.pftcInfo.libelleModeEncaissement + ' ' + rythmeFacturation;
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

    getCurrentPostalCode(){
        for(let i=0;i<this.oContractsAddresses._data.length;i++){
            if(this.idPortefeuilleContrat == this.oContractsAddresses._data[i].idPortefeuilleContrat){
                this.codePostale = this.oContractsAddresses._data[i].locaux[0].codePostal;
            }
        }
    }

    openPopinOption(event){
        if(event.target.id =='factureEnLigne'){
            this.optionType = 'facturesEnLigne';
            this.etatOption = this.factureEnLigneStatus;
        }else{
            this.optionType = 'optionVertElec';
            this.etatOption = this.optionVertElecStatus;
            this.labelBouttonPopin = this.optionVertElecStatus =='Actif' ? this.labelBouttonPopinOptionVerteInactif : this.labelBouttonPopinOptionVerteActif;
            this.textExplicatifPopin = this.textExplicatifPopinOptionVerte;
            this.texteAlertePopin = this.texteAlertePopinOptionVerte;
            this.titrePopin = this.titrePopinOptionVerte;
            this.texteIntroductif = this.texteIntroductifPopinOptionVerte;
        }
        this.showPopin = true;
    }

    get showCheckOptionVertElec(){
        return this.optionVertElecStatus == 'Actif';
    }

    get showCheckDRP(){
        return this.dateReglementStatus == 'Actif';
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

    closePopinOption(event){
        if(event.detail === true){
            this.showPopin = true;
        }else if(event.detail === false){
            this.showPopin = false;
            this.populateContractInfo();
        }
    }

    handleClickDateReglement(event){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Mes_factures__c'
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
        this.currentEnergy = getCurrentMessageValue('SelectedEnergy');
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
            self.loadPortefeuilleContrat();
            self.populateContractInfo();
        }
        if(message.messageType == 'SelectedEnergy'){
            self.currentEnergy = message.messageData.message;
            self.populateContractInfo();
        }  
    }

    handlePublish(message) {
    }
    
    handleAdhesionDepan(event){
        // TO_DO not in P0
    }
}