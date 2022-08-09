/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 08-09-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { api, track, wire, LightningElement } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_download from '@salesforce/resourceUrl/HP_EC_icon_download';
import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

import getContractDocumentsInfo from '@salesforce/apex/HP_EC_DocumentManager.getContractDocumentsInfo';
import getJustificatif from '@salesforce/apex/HP_EC_DocumentManager.getJustificatif';

import getJustificatifDeDomicileVariables from '@salesforce/apex/HP_EC_DocumentManager.getJustificatifDeDomicileVariables';
import generateJustificatifDomicilePDF from '@salesforce/apex/HP_EC_DocumentManager.generateJustificatifDomicilePDF';
import getCoTitulaires from '@salesforce/apex/HP_EC_LoadCustomerData.getCoTitulaires';

import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getContractsAddresses from '@salesforce/apex/HP_EC_LoadCustomerData.getContractsAddresses';



export default class Hp_ec_myDocuments extends LightningElement {

    iconDownload = HP_EC_icon_download;
    
    @api title;
    @api cgvUrl;
    @api filterEnergy
    @track mandatUrl;

    @track idPortefeuilleContrat;
    @track cpvUrlElec;
    @track cpvUrlGaz;
    @track contractIdElec;
    @track contractIdGaz;
    @track displayElec;
    @track displayGaz;
    @track currentContractId;


    @track contractInfo;
    @track contact;
    @track idClient;
    @track currentContract;
    @track contractElec;
    @track contractGaz;
    @track isDual;

    @track justificatifDeDomicileSettings;

    @track date_du_jour;
    @track ref_client;
    @track adresse_factu1;
    @track adresse_factu2;
    @track adresse_local;
    @track ref_contrat;
    @track civilite_titulaire;
    @track nom_titulaire;
    @track prenom_titulaire;
    @track civilite_cotitulaire;
    @track nom_cotitulaire;
    @track prenom_cotitulaire;

    @track bodyParagraph;

    @track capital_GDF_SUEZ;
    @track adr_gdfsuez_siege;
    @track numero_tva_gdf_suez;
    @track service_client_agilab;
    @track depannage_elec;
    @track depannage_gaz;

    @wire(MessageContext) messageContext;

    @wire(getContactData)
    wiredContact({ error, data }) {
        if (data) {
            this.contact = JSON.parse(data);
            this.idClient = this.contact.ID_Tiers__c;
        } else if (error) {
            console.log(JSON.stringify(error));
        }
    }

    @wire(getContractData)
    wiredContract({error, data}){
        if (data) {
            this.contractInfo = JSON.parse(data);
        } else if(error){
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

    connectedCallback() {
        this.handleSubscription();
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.currentEnergy = getCurrentMessageValue('SelectedEnergy');
        this.getDocumentsUrl();
    }

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    handleSubscription() {

        if (!this.subscription) {
            subscribeMC(this, this.messageContext, this.handleLightningMessage);
        }
    }

    handleLightningMessage(self, subscription, message) {
        if (message.messageType == 'SelectedPortfolio') {
            self.idPortefeuilleContrat = message.messageData.message;
            self.getDocumentsUrl();
        }
        else if (message.messageType == 'SelectedEnergy') {
            self.currentEnergy = message.messageData.message;
            self.getDocumentsUrl();
        }
    }

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    handleClickDownloadJustificatif() {
        this.downloadJustificatifDomicile();
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


        this.displayElec = false;
        this.displayGaz = false;

        this.currentContractId = null;
        this.contractIdElec = null;
        this.contractIdGaz = null;

        this.documentsData = null;
        this.mandatUrl = null;
        this.cpvUrlElec = null;
        this.cpvUrlGaz = null;
    }

    async getDocumentsUrl() {
        
        this.initializeComponantProperties();

        if (!this.justificatifDeDomicileSettings) {
            const JUSTIFICATIF_DOMICILE_MDT = await this.getJustificatifDomicileSettingsData();
            this.justificatifDeDomicileSettings = JUSTIFICATIF_DOMICILE_MDT;
        }

        if (!this.contractInfo) {
            const CONTRACT_DATA = await this.getContractdata();
            this.contractInfo = JSON.parse(CONTRACT_DATA);
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

        if(this.contractInfo) {
            let today = new Date();
            for (let i = 0; i < this.contractInfo._data.length; i++) {
                if (this.contractInfo._data[i].idPortefeuilleContrat == this.idPortefeuilleContrat) {
                    let dateFinValidite = new Date(this.contractInfo._data[i].dateFinValidite);
                    let diffTime = Math.abs(today - dateFinValidite);
                    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                    let isOldContract = (diffDays > 365) && (today > dateFinValidite);
                    if (this.contractInfo._data[i].codeStatutCrm == 'H0105' || this.contractInfo._data[i].codeStatutCrm == 'H0101' ||
                        this.contractInfo._data[i].codeStatutCrm == 'H0102' || this.contractInfo._data[i].codeStatutCrm == 'E0004' ||
                        this.contractInfo._data[i].codeStatutCrm == 'E0007' ||
                        ((this.contractInfo._data[i].codeStatutCrm == 'E0009' && !isOldContract) || (this.contractInfo._data[i].codeStatutCrm == 'H0103' && !isOldContract))) {
                            if (this.filterEnergy == true) {
                                if(this.contractInfo._data[i].energie == this.currentEnergy){
                                    this.currentContractId = this.contractInfo._data[i].id;
                                }
                                if (this.contractInfo._data[i].energie == 'Electricité') {
                                    this.contractIdElec = this.contractInfo._data[i].id;
                                }
                                else {
                                    this.contractIdGaz = this.contractInfo._data[i].id;
                                }
                            }else{
                                if (this.contractInfo._data[i].energie == 'Electricité') {
                                    this.contractIdElec = this.contractInfo._data[i].id;
                                    this.currentContractId = this.contractInfo._data[i].id;
                                    this.displayElec = true;
                                }
                                else {
                                    this.contractIdGaz = this.contractInfo._data[i].id;
                                    this.currentContractId = this.contractInfo._data[i].id;
                                    this.displayGaz = true;
                                }
                            }
                    }
                }
            }

            if (this.currentContractId != '') {
                const documentJson = await getContractDocumentsInfo({ idPortfolio: this.idPortefeuilleContrat });
                this.documentsData = documentJson;
                if (this.documentsData) {
                    for (let i = 0; i < this.documentsData.output.length; i++) {

                        if (this.documentsData.output[i].id_contrat_xdata == this.currentContractId) {
                            let documents = this.documentsData.output[i].documents;
                            for (let x = 0; x < documents.length; x++) {
                                if (documents[x].type_document == '4') {
                                    this.mandatUrl = documents[x].url_document;
                                }
                                else if (documents[x].type_document == '11') {
                                    if (this.documentsData.output[i].id_contrat_xdata == this.contractIdElec) {
                                        this.cpvUrlElec = documents[x].url_document;
                                    }
                                    else if (this.documentsData.output[i].id_contrat_xdata == this.contractIdGaz) {
                                        this.cpvUrlGaz = documents[x].url_document;
                                    }
                                }
                            }
                        }
                    }
                }
            }
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

                // const byteString = window.atob(response);
                // const arrayBuffer = new ArrayBuffer(byteString.length);
                // const int8Array = new Uint8Array(arrayBuffer);
                // for (let i = 0; i < byteString.length; i++) {
                //     int8Array[i] = byteString.charCodeAt(i);
                // }
                // const blob = new Blob([int8Array], { type: 'application/pdf'});

                // // data should be your response data in base64 format
                // // const blobb = this.dataURItoBlob(data);
                // const url = URL.createObjectURL(blob);
                // window.open(url, '_blank');
            });
    }

}
function formatDateToString(date) {
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    return ('0' + day).slice(-2) + '/' + ('0' + month).slice(-2) + '/' + year.toString().slice(-2);
}