/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-06-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track, wire } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getGrilleTarifaire from '@salesforce/apex/HP_EC_LoadCustomerData.getGrilleTarifaire';
import getContratInfo from '@salesforce/apex/HP_EC_LoadCustomerData.getContratInfo';
import getContractDocumentsInfo from '@salesforce/apex/HP_EC_DocumentManager.getContractDocumentsInfo';
import getJustificatif from '@salesforce/apex/HP_EC_DocumentManager.getJustificatif';
import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

export default class Hp_ec_contract extends LightningElement {
    @api titleText;
    @api voirContractButtonLabel;
    @api justificatifButtonLabel;

    @track contractText ;
    @track idContract ;
    @track refClientText = 'Référence client';
    @track idClient ;
    @track pdlPceText;
    @track idPdlPce ;
    @track puissanceText = 'Puissance';
    @track puissance ;
    @track typeComptageText = 'Type de comptage';
    @track typeComptage;
    @track plageConsoText = 'Plage de consommation';
    @track plageConso;
    @track isElec = false;
    @track isGaz = false;

    @track showResilPopin = false;
    @track contact;
    @track contractInfo;
    @track contractInfoAgilab;
    @track grilleTarifaire;
    @track idPortefeuilleContrat;
    @track currentEnergy;
    @track documentsData;
    @track cpvUrl;
    @wire(MessageContext) messageContext;

    @track contratItemTitleClass;

    @wire(getContactData)
    wiredContact({ error, data }) {
        if (data) {
             this.contact = JSON.parse(data);
             this.idClient = this.contact.ID_Tiers__c;
        }else if(error){
            console.log(JSON.stringify(error));
        }
    }

    @wire(getContractData)
    wiredContract({error, data}){
        if (data) {
            this.contractInfo = JSON.parse(data);
       }else if(error){
           console.log(JSON.stringify(error));
       }
    }

    async populateContractInfo(){
        this.cpvUrl = undefined;
        if(!this.contractInfo){
            const conractInfoData = await this.getContractdata();
            this.contractInfo = JSON.parse(conractInfoData);
        }
        if(!this.idPortefeuilleContrat && !this.currentEnergy){
            return;
        }
        try {
            
        
        if(this?.contractInfo){
            let today = new Date();
            for(let i = 0; i<this.contractInfo._data.length;i++){
                let dateFinValidite = new Date(this.contractInfo._data[i].dateFinValidite);
                let diffTime = Math.abs(today - dateFinValidite);
                let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                let isOldContract = (diffDays > 365) && (today > dateFinValidite);
                if(this.contractInfo._data[i].idPortefeuilleContrat == this.idPortefeuilleContrat && this.contractInfo._data[i].energie == this.currentEnergy && (
                    this.contractInfo._data[i].codeStatutCrm == 'H0105' || this.contractInfo._data[i].codeStatutCrm == 'H0101' ||
                    this.contractInfo._data[i].codeStatutCrm == 'H0102' || this.contractInfo._data[i].codeStatutCrm == 'E0004' || this.contractInfo._data[i].codeStatutCrm == 'E0007' || 
                    ((this.contractInfo._data[i].codeStatutCrm == 'E0009' && !isOldContract) || (this.contractInfo._data[i].codeStatutCrm == 'H0103' && !isOldContract)))){
                    let dateDebutValiditeUs = new Date(this.contractInfo._data[i].dateDebutValidite);
                    let dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
                    this.idContract = this.contractInfo._data[i].id;
                    let contractID = JSON.stringify(this.idContract);
                    getGrilleTarifaire({ idContrat : contractID,  dateContrat :dateDebutValiditeFr})
                    .then(response => {
                        const MY_RESPONSE = JSON.parse(response);
                        this.grilleTarifaire = MY_RESPONSE;
                        this.plageConso = MY_RESPONSE.gazPlageConso;
                        this.typeComptage = MY_RESPONSE.elecTypeComptage;
                    })
                    .catch(error => {
                        console.log('Error getGrilleTarifaire: ' + JSON.stringify(error));
                    });
                    getContratInfo({ idContrat : contractID})
                    .then(response => {
                        const MY_RESPONSE = JSON.parse(response);
                        this.contractInfoAgilab = MY_RESPONSE;
                        this.idPdlPce = MY_RESPONSE.output.pdl;
                        this.puissance = MY_RESPONSE.output?.electricite.puissance;
                    })
                    .catch(error => {
                        console.log('Error getContratInfo: ' + JSON.stringify(error));
                    });
                    getContractDocumentsInfo({idPortfolio : this.idPortefeuilleContrat}).then(response => {
                        this.documentsData = response;
                        if (this.documentsData) {
                            for (let i = 0; i<this.documentsData.output.length;i++) {
                                if (this.documentsData.output[i].id_contrat_xdata == this.idContract) {
                                    let documents = this.documentsData.output[i].documents;
                                    for (let j=0; j < documents.length; j++) {
                                         if (documents[j].type_document == '11') {
                                            this.cpvUrl = documents[j].url_document;
                                        }
                                    }
                                }
                            }
                        }
                    }).catch(error => {
                        console.log('Erreur get document : '+ JSON.stringify(error));
                    });
                }
            }
            
            if(this.currentEnergy === 'Gaz Naturel'){
                this.contractText = 'Contrat gaz';
                this.pdlPceText = 'N° PCE';
                this.contratItemTitleClass = 'hp-contrat-item-title blue';
                this.isElec = false;
                this.isGaz = true;
            }else{
                this.contractText = 'Contrat électricité';
                this.pdlPceText = 'N° PDL';
                this.contratItemTitleClass = 'hp-contrat-item-title purple';
                this.isElec = true;
                this.isGaz = false;
            }        
        }
        } catch (error) {
            console.log('Erreure : '+error.message);
        }
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

    openResilPopin(evt){
        this.showResilPopin = true;
    }

    openPopinDonneesCollectees(evt){
        if(evt.detail === true){
            this.showResilPopin = true;
        }else if(evt.detail === false){
            this.showResilPopin = false;
        }
    }

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    connectedCallback() {
        this.handleSubscription();
        this.currentEnergy = getCurrentMessageValue('SelectedEnergy');
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.populateContractInfo();
    }

    handleSubscription() {
        if (!this.subscription) {
           subscribeMC(this,this.messageContext, this.handleLightningMessage);
        }
    } 

    handleLightningMessage(self,subscription, message){
        if(message.messageType == 'SelectedPortfolio'){
            self.idPortefeuilleContrat = message.messageData.message;
            self.populateContractInfo();
        }
        if(message.messageType == 'SelectedEnergy'){
            self.currentEnergy = message.messageData.message;
            self.populateContractInfo();
        }
    }

    handlePublish(message) {
        publishMC(this.messageContext, message, '');
    }

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    handleVoirContract(){
        if(this.cpvUrl){
            window.open(this.cpvUrl, '_blank');
        }
    }

    handleJustificatif(){
         /* TO DO */
    }
}