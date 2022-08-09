/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 08-09-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { api, track, wire, LightningElement } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_download from '@salesforce/resourceUrl/HP_EC_icon_download';
import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

import getContractDocumentsInfo from '@salesforce/apex/HP_EC_DocumentManager.getContractDocumentsInfo';
import getJustificatif from '@salesforce/apex/HP_EC_DocumentManager.getJustificatif';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';


export default class Hp_ec_myDocuments extends LightningElement {
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


    @wire(MessageContext) messageContext;

    iconDownload = HP_EC_icon_download;

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

    async getDocumentsUrl() {

        if (this.filterEnergy == true) {
            if (this.currentEnergy == 'Electricité') {
                this.displayElec = true;
                this.displayGaz = false;
            }
            else {
                this.displayGaz = true;
                this.displayElec = false;
            }
        }
        const contractsJson = await getContractData();
        this.contractInfo = JSON.parse(contractsJson);
        let today = new Date();
        for (let i = 0; i < this.contractInfo._data.length; i++) {
            if (this.contractInfo._data[i].idPortefeuilleContrat == this.idPortefeuilleContrat) {
                let dateFinValidite = new Date(this.contractInfo._data[i].dateFinValidite);
                let diffTime = Math.abs(today - dateFinValidite);
                let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                let isOldContract = (diffDays > 365) && (today > dateFinValidite);
                console.log('Code Statut Contrat : '+ this.contractInfo._data[i].codeStatutCrm);
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
        console.log('show elec : '+ this.displayElec);
        console.log('show gaz : '+ this.displayGaz);

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
        });
    }

    async downloadJustificatifDomicile() {
        await getJustificatif({ idPortfolio: this.idPortefeuilleContrat })
            .then(response => {
                console.log('Response :');
                console.log(response);
                /*var file = new Blob([response], {type: 'application/pdf'});
                 var fileUrl = URL.createObjectURL(file);
                 window.open(fileUrl);*/
                let downloadLink = document.createElement('a');
                downloadLink.href = "data:application/pdf;base64," + response;
                downloadLink.download = "Happ-e Attestation de titulaire de contrat.pdf";
                downloadLink.click();
            });
    }

}