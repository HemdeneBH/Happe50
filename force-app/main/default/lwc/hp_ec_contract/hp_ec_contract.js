/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-29-2022
 * @last modified by  : Badr Eddine Belkarchi
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

import getJustificatifDeDomicileVariables from '@salesforce/apex/HP_EC_DocumentManager.getJustificatifDeDomicileVariables';
import generateJustificatifDomicilePDF from '@salesforce/apex/HP_EC_DocumentManager.generateJustificatifDomicilePDF';
import getCoTitulaires from '@salesforce/apex/HP_EC_LoadCustomerData.getCoTitulaires';
import getContractsAddresses from '@salesforce/apex/HP_EC_LoadCustomerData.getContractsAddresses';

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

    @wire(getContractsAddresses)
    wiredContractsAddresses({ error, data }) {
        if (data) {
            this.ContractsAddresses = data;
        }
        else if (error) {
            console.log('Error get addresses' + JSON.stringify(error));
        }
    }

    @wire(getJustificatifDeDomicileVariables)
    wiredJustificatifDeDomicileVariables({ error, data }) {
        if (data) {
            this.justificatifDeDomicileSettings = data;
            // console.log('getJustificatifDeDomicileVariables : ',this.justificatifDeDomicileSettings);
        } else if (error) {
            console.log('getJustificatifDeDomicileVariables',JSON.stringify(error));
        }
    }

    initializeComponantProperties() {
        this.contractInfo = null;
        this.contractElec = null;
        this.contractGaz = null;
        this.isDual = null;

        this.adressPFContratPart1 = '';
        this.adressPFContratPart2 = '';
        
        this.date_du_jour = '';      
        this.ref_client = '';
        this.adresse_factu1 = '';
        this.adresse_factu2 = '';
        this.adresse_local = '';
        this.ref_contrat = '';

        this.civilite_titulaire = '';
        this.nom_titulaire = '';
        this.prenom_titulaire = '';

        this.coTitulaires == '';  
        this.civilite_cotitulaire = '';
        this.nom_cotitulaire = '';  
        this.prenom_cotitulaire = '';

        this.bodyParagraph = '';
        this.depannage_elec = '';
        this.depannage_gaz = '';
    }

    async populateContractInfo(){
        this.initializeComponantProperties();
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


        if (!this.justificatifDeDomicileSettings) {
            const JUSTIFICATIF_DOMICILE_MDT = await this.getJustificatifDomicileSettingsData();
            this.justificatifDeDomicileSettings = JUSTIFICATIF_DOMICILE_MDT;
        }

        if(this.contractInfo && this.justificatifDeDomicileSettings) {
            let contractCount = 0;
            const TODAY = new Date();
            this.contractInfo._data.forEach(c => {

                const DATE_FIN_VALIDITE = new Date(c.dateFinValidite);
                const DIFF_TIME = Math.abs(TODAY - DATE_FIN_VALIDITE);
                const DIFF_DAYS = Math.ceil(DIFF_TIME / (1000 * 60 * 60 * 24)); 
                const IS_OLD_CONTRACT = (DIFF_DAYS > 365) && (TODAY > DATE_FIN_VALIDITE);

                if (c.idPortefeuilleContrat == this.idPortefeuilleContrat && (c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' || c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007' || ((c.codeStatutCrm == 'E0009' && !IS_OLD_CONTRACT) || (c.codeStatutCrm == 'H0103' && !IS_OLD_CONTRACT)))) {
                        if(c.energie == 'Electricité') {
                            this.contractElec = c;
                            contractCount++;
                        } else if(c.energie == 'Gaz Naturel') {
                            this.contractGaz = c;
                            contractCount++;
                        }
                }
            });
            contractCount == 2 ? this.isDual = true : this.isDual = false;   
        }

        if (!this.ContractsAddresses) {
            this.ContractsAddresses = await this.getAdressContract();
        }
        if (this.ContractsAddresses) {
            const CONTRACTS_ADDRESSES = JSON.parse(this.ContractsAddresses)._data;
            CONTRACTS_ADDRESSES.forEach(keyPortfolio => {
                if(keyPortfolio.idPortefeuilleContrat == this.idPortefeuilleContrat){
                    keyPortfolio.locaux.forEach(keyLocal=>{
                            this.adressPFContratPart1 = keyLocal.numeroVoie + ' ' + keyLocal.libelleVoie
                            this.adressPFContratPart2 = keyLocal.codePostal + ' ' + keyLocal.ville
                        })
                }
            });
        }
        const CO_TITULAIRES = await this.getCoTitulaires(this.idClient);
        this.coTitulaires = JSON.parse(CO_TITULAIRES);
        
        this.date_du_jour = formatDateToString(new Date());        
        this.ref_client = this.idClient;
        this.adresse_factu1 = this.contact.No_Voie__c + ' ' + this.contact.MailingStreet;
        this.adresse_factu2 = this.contact.MailingPostalCode + ' ' + this.contact.MailingCity;
        this.adresse_local = this.adressPFContratPart1 + ' ' + this.adressPFContratPart2;

        if(this.isDual){
            const REF_CONTRACT = 'Electricité : ' + this.contractElec.id + ' - Gaz : ' + this.contractGaz.id;
            this.ref_contrat = REF_CONTRACT;
        } else if (this.contractElec) {
            this.ref_contrat = this.contractElec.id;
        } else if (this.contractGaz) {
            this.ref_contrat = this.contractGaz.id;
        }        

        this.contact.Salutation = 'MR' ? this.civilite_titulaire = 'M.':this.civilite_titulaire = 'Mme';
        this.nom_titulaire = this.contact.LastName;
        this.prenom_titulaire = this.contact.FirstName;

        if(this.coTitulaires.output?.co_titulaires[0]) {
            this.coTitulaires.output.co_titulaires[0].civilite = 'Monsieur' ? this.civilite_cotitulaire = 'M.':this.civilite_cotitulaire = 'Mme';    
            this.nom_cotitulaire = this.coTitulaires.output.co_titulaires[0]?.nom    
            this.prenom_cotitulaire = this.coTitulaires.output.co_titulaires[0]?.prenom;
        }
        if(this.nom_cotitulaire == '') {
            this.bodyParagraph = "Par la présente, ENGIE atteste qu’en date du "+this.date_du_jour+", "+this.civilite_titulaire+" "+this.nom_titulaire.toUpperCase()+" "+this.prenom_titulaire.toUpperCase()+" est actuellement titulaire d’un contrat d’énergie happ-e by ENGIE auprès d’ENGIE pour le logement situé au "+this.adresse_local+".";
        } else {
            this.bodyParagraph = "Par la présente, ENGIE atteste qu’en date du "+this.date_du_jour+", "+this.civilite_titulaire+" "+this.nom_titulaire.toUpperCase()+" "+this.prenom_titulaire.toUpperCase()+" et "+this.civilite_cotitulaire+" "+this.nom_cotitulaire.toUpperCase()+" "+this.prenom_cotitulaire.toUpperCase()+" sont actuellement titulaires d’un contrat d’énergie happ-e by ENGIE auprès d’ENGIE pour le logement situé au "+this.adresse_local+".";
        }

        this.capital_GDF_SUEZ = this.justificatifDeDomicileSettings.capital_GDF_SUEZ__c + '€';
        this.adr_gdfsuez_siege = this.justificatifDeDomicileSettings.adr_gdfsuez_siege__c;
        this.numero_tva_gdf_suez = this.justificatifDeDomicileSettings.numero_tva_gdf_suez__c
        this.service_client_agilab = this.justificatifDeDomicileSettings.service_client_agilab__c;

        if (this.contractElec) {
            let depannage_elec = this.justificatifDeDomicileSettings.depannage_electricite__c;
            const NUM_DEPARTEMENT_LOGEMENT = this.adressPFContratPart2.slice(0,2);
            this.depannage_elec = depannage_elec.replace('{XX}', NUM_DEPARTEMENT_LOGEMENT);
        }
        if (this.contractGaz) {
            this.depannage_gaz = this.justificatifDeDomicileSettings.depannage_gaz__c;
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

    async downloadJustificatifDomicile() {

        let informationJustificatifToPdf={
            date_du_jour: this.date_du_jour,
            ref_client: this.ref_client,
            adresse_factu1: this.adresse_factu1,
            adresse_factu2: this.adresse_factu2,
            adresse_local: this.adresse_local,
            ref_contrat: this.ref_contrat,
            civilite_titulaire: this.civilite_titulaire,
            nom_titulaire: this.nom_titulaire,
            prenom_titulaire: this.prenom_titulaire,
            civilite_cotitulaire: this.civilite_cotitulaire,
            nom_cotitulaire: this.nom_cotitulaire,
            prenom_cotitulaire: this.prenom_cotitulaire,

            bodyParagraph: this.bodyParagraph,

            capital_GDF_SUEZ: this.capital_GDF_SUEZ,
            adr_gdfsuez_siege: this.adr_gdfsuez_siege,
            numero_tva_gdf_suez: this.numero_tva_gdf_suez,
            service_client_agilab: this.service_client_agilab,
            depannage_elec: this.depannage_elec,
            depannage_gaz: this.depannage_gaz
        };

        await generateJustificatifDomicilePDF({ informationJustificatifToPdf: JSON.stringify(informationJustificatifToPdf) })
            .then(response => {

                let downloadLink = document.createElement('a');
                downloadLink.href = "data:application/pdf;base64," + response;
                downloadLink.download = this.prenom_titulaire + " "+ this.nom_titulaire +"_justificatif_de_domicile.pdf";
                downloadLink.click();
            });
    }

    async getJustificatifDomicileSettingsData(){
        return new Promise(async (resolve, reject) => {
            var result = await getJustificatifDeDomicileVariables({}).then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getJustificatifDomicileSettingsData : ' + JSON.stringify(error));
                return error;
            }); 
            resolve(result);
        });
    }

    async getAdressContract() {
        return new Promise(async (resolve, reject) => {
            var result = await getContractsAddresses().then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getContractsAddresses : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        });
    }

    async getCoTitulaires(id_client_xdata) {
        return new Promise(async (resolve, reject) => {
            var result = await getCoTitulaires({ id_client_xdata: id_client_xdata})
            .then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getCoTitulaires : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        });
    }
}

function formatDateToString(date) {
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    return ('0' + day).slice(-2) + '/' + ('0' + month).slice(-2) + '/' + year.toString().slice(-2);
}