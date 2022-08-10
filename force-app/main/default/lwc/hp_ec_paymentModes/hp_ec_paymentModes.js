/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 08-10-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { api, LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import generateSogenactifParams from '@salesforce/apex/HP_EC_UTIL_CryptoUtils.generateSogenactifParams';
import generateAmazonPayParams from '@salesforce/apex/HP_EC_UTIL_CryptoUtils.generateAmazonPayParams';

import HP_EC_icon_CB from '@salesforce/resourceUrl/HP_EC_icon_CB';
import HP_EC_icon_paylib from '@salesforce/resourceUrl/HP_EC_icon_paylib';
import HP_EC_icon_paypal from '@salesforce/resourceUrl/HP_EC_icon_paypal';
import HP_EC_icon_valid from '@salesforce/resourceUrl/HP_EC_icon_valid';
import HP_EC_icon_confirm from '@salesforce/resourceUrl/HP_EC_icon_confirm';
import HP_EC_icon_amazonPay from '@salesforce/resourceUrl/HP_EC_icon_amazonPay';

export default class Hp_ec_paymentModes extends NavigationMixin(LightningElement) {
    @api echeanceid;
    @api amount;
    @api contact;
    @api titleText;
    @api isEtatInactif;

    @track paiementAplusieursPopin = false;
    @track sogenactifRedirectionURL;
    @track redirectionVersion;
    @track redirectionData;

    styleIconCB = "-webkit-mask-image: url(" + HP_EC_icon_CB + ");";
    styleIconPaylib = "-webkit-mask-image: url(" + HP_EC_icon_paylib + ");";
    styleIconPaypal = "-webkit-mask-image: url(" + HP_EC_icon_paypal + ");";
    styleIconAmazonPay = "-webkit-mask-image: url(" + HP_EC_icon_amazonPay + ");";

    iconChecked = HP_EC_icon_valid;
    iconConfirm = HP_EC_icon_confirm;



    // Champs contribuables : START //
    
    // @api titreV2;

    // @api labelMoyenPaiement1;
    // @api labelMoyenPaiement2;
    // @api labelMoyenPaiement3;
    // @api labelMoyenPaiement4;
    // @api labelMoyenPaiement5;

    // @api lienEnSavoirPlusPaiement1;
    // @api lienEnSavoirPlusPaiement2;
    // @api lienEnSavoirPlusPaiement3;
    // @api lienEnSavoirPlusPaiement4;
    // @api lienEnSavoirPlusPaiement5;

    // @api showLienEnSavoirPlusPaiement1;
    // @api showLienEnSavoirPlusPaiement2;
    // @api showLienEnSavoirPlusPaiement3;
    // @api showLienEnSavoirPlusPaiement4;
    // @api showLienEnSavoirPlusPaiement5;

    // @api textModePaiement;
    // @api textDatePrelevementPart1;
    // @api textDatePrelevementPart2;

    // @api listPaymentsTitle;
    // @api textRappel;
    // @api messageListPayement;
    // @api boutonListPaymentLabel;
    // // Champs contribuables : END //

    // @api idPortefeuilleContrat;
	
    // @track hasRenderedOnce;
    // @track version1;
    // @track version2;
    // @track contractInfo;
    // @track soldeEffectifData;
    // @track actifPRTF;
    // @track datePrelevement;
    // @track contractElec;
    // @track contractGaz;

    // @track conditionCas1;
    // @track conditionCas2;
    // @track isProcessFinished;

	
    // @track contact;
	// @track inpaidInvoice;
    // @track inpaidEcheance;
    // @track echeancesData;
    // @track listFctEch = [];
    // @track showListPayement = false;
    // @track montantToDisplay;
    // @track payementAmountToDisplay;

 
    // renderedCallback() {
    //     console.log('etatIsInactif in mode payement '+this.isEtatInactif)
    //     console.log('echeance id in payement mode '+this.echeanceid)
    //     console.log('amount in mode payement '+this.amount)
    // }

   

    // get isEtatInactif() {
    //     if(!(this.isProcessFinished && (this.solde < 0) && (this.conditionCas1 || this.conditionCas2)))
    //         return true;
    //     return false;
    // }

    // openPaiementAplusieursPopin () {
    //     this.paiementAplusieursPopin = true;
    // }

    closePaiementAplusieursPopin (event) {
        event.preventDefault();
        event.stopPropagation();
        event.stopImmediatePropagation();
        this.paiementAplusieursPopin = false;
    }

    // // renderedCallback() {
    // //     if (this.hasRenderedOnce) {
    // //         return;
    // //     }
    // //     loadUserTheme.call(this);
    // //     this.hasRenderedOnce = true;

    // //     this.populateContractInfo();
    // // }

    // // @wire(getContractData)
    // // wiredContract({ error, data }) {
    // //     if (data) {
    // //         this.contractInfo = JSON.parse(data);
    // //     } else if (error) {
    // //         console.log(JSON.stringify(error));
    // //     }
    // // }

	// // @wire(getContactData)
    // // wiredContact({error, data}){
    // //     if(data){
    // //         this.contact = JSON.parse(data);
    // //     }
    // //     else if (error) {
    // //         console.log(JSON.stringify(error));
    // //     }
    // // }

    // // @wire(getSoldeEffectifData)
    // // wiredSoldeEffectifData({ error, data }) {
    // //     if (data) {
    // //         this.soldeEffectifData = JSON.parse(data);
    // //     } else if (error) {
    // //         console.log(JSON.stringify(error));
    // //     }
    // // }

    // // connectedCallback() {
    // //     this.handleSubscription();
    // //     this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
    // //     this.populateContractInfo();
    // // }

    // // handleSubscription() {
    // //     if (!this.subscription) {
    // //         subscribeMC(this, this.messageContext, this.handleLightningMessage);
    // //     }
    // // }

    // // handleLightningMessage(self, subscription, message) {
    // //     if (message.messageType == 'SelectedPortfolio') {
    // //         self.idPortefeuilleContrat = message.messageData.message;
    // //         self.populateContractInfo();
    // //     }
    // // }

    // async populateContractInfo() {
    //     this.initializeComponantProperties();
    //     try {
    //     if (!this.contractInfo) {
    //         const CONTRACT_DATA_RESULT = await this.getContractdata();
    //         this.contractInfo = JSON.parse(CONTRACT_DATA_RESULT);
    //     }
    //     if (!this.idPortefeuilleContrat) {
    //         return;
    //     }
    //     if (this.contractInfo) {
    //             const ACTIF_PORTEFEUILLE = await this.getPorteFeuilledata(this.idPortefeuilleContrat);
    //             this.actifPRTF = JSON.parse(ACTIF_PORTEFEUILLE);
    //             this.actifPRTF.codeModeEncaissement == '5' ? this.version2 = true : this.version1 = true;
    //             let today = new Date();
    //             this.contractInfo._data.forEach(c => {
    //                 let dateFinValidite = new Date(c.dateFinValidite);
    //                 let diffTime = Math.abs(today - dateFinValidite);
    //                 let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
    //                 let isOldContract = (diffDays > 365) && (today > dateFinValidite) ;
    //                 console.log('is old contract ? : ' + isOldContract);
    //                 console.log('difference between dates : '+diffDays);
    //                 if (c.idPortefeuilleContrat == this.idPortefeuilleContrat && (c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' ||
    //                 c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007' || ((c.codeStatutCrm == 'E0009' && isOldContract)
    //                 || (c.codeStatutCrm == 'H0103' && isOldContract)) )) {
    //                 c.energie == 'Electricité' ? this.contractElec = c : this.contractGaz = c;
    //             }
    //         });
    //     }

    //     if (this.version1) {
    //         console.log('in version 1')
    //         if (!this.soldeEffectifData) {
    //             this.soldeEffectifData = await this.getSoldeEffectifData();
    //         }
    //         // 1st verification
    //         if (this.soldeEffectifData) {
    //             if (this.soldeEffectifData.output?.soldes) {
    //                 this.soldeEffectifData.output.soldes.forEach(s => {
    //                     let keys = Object.keys(s);
    //                     for (let key of keys) {
    //                         if (key == this.idPortefeuilleContrat) {
    //                             this.solde = s[key];
    //                             let absMontant = Math.abs(this.solde);
    //                             this.montantToDisplay = (Math.round(absMontant * 100) / 100).toFixed(2);
    //                         }
    //                     }
    //                 });
    //             }
    //         }

    //         if (this.solde < 0) {
    //             console.log('in if solde verification')
    //             // 2nd verification : factures
    //             let count = 0;
    //             const FACTURES_DATA = await this.getFactureData(this.idPortefeuilleContrat);
    //             const FACTURES = JSON.parse(FACTURES_DATA);
    //                 this.inpaidInvoice = this.findFirstInpaidInvoice(FACTURES.output.factures);
    //                 if(FACTURES.status == 'SUCCESS') {
    //                     console.log('list des fct '+JSON.stringify(FACTURES))
    //                     this.listFctEch = [...this.listFctEchToShow(FACTURES, '')];
    //                     console.log('this.listFctEch '+JSON.stringify(this.listFctEch))
    //                     FACTURES.output.factures.forEach(f => {
    //                         if((f.statut == '1' || f.statut == '2') && (new Date(f.date_limite_de_paiement) < new Date())) {
    //                         this.conditionCas2 = true;
    //                     }
    //                     if((f.statut == '1' || f.statut == '2') && (new Date(f.date_limite_de_paiement) > new Date())) {
    //                         count++;
    //                     }
    //                 });

    //                 if(count == FACTURES.output.factures.length) 
    //                     this.conditionCas1 = true;
    //             }

    //             // 3rd verification : écheances
    //             if(this.contractGaz) {
    //                 let count = 0;
    //                 const ECHEANCE_DATA = await this.getEcheanceData(this.contractGaz.id.toString());
    //                 const ECHEANCES = JSON.parse(ECHEANCE_DATA);
    //                  if(ECHEANCES.status == 'SUCCESS') { 
    //                     this.listFctEch = [...this.listFctEch, this.listFctEchToShow(ECHEANCES, 'Gaz')] ;
    //                         let keys = Object.keys(ECHEANCES.output);
    //                         for (let key of keys) {
    //                             this.echeancesData.push(JSON.parse(ECHEANCES).output[key]);
    //                             const ECHEANCE = ECHEANCES.output[key];
    //                             if (new Date(ECHEANCE.date_decheance) < new Date() && !this.isEcheanceSolde(ECHEANCE.soldee_le)) {
    //                             this.conditionCas2 = true;
    //                         }
    //                         if (new Date(ECHEANCE.date_decheance) < new Date() && this.isEcheanceSolde(ECHEANCE.soldee_le)) {
    //                             count++;
    //                         }
    //                     }

    //                     if(count == ECHEANCES.output.length) 
    //                         this.conditionCas1 = true;
    //                 }
    //             }

    //             if(this.contractElec) {
    //                 let count = 0;
    //                 const ECHEANCE_DATA = await this.getEcheanceData(this.contractElec.id.toString());
    //                 const ECHEANCES = JSON.parse(ECHEANCE_DATA);
    //                     if(ECHEANCES.status == 'SUCCESS') { 
    //                         this.listFctEch = [...this.listFctEch, this.listFctEchToShow(ECHEANCES, 'Elec')] ;
    //                         let keys = Object.keys(ECHEANCES.output);
    //                         for (let key of keys) {
    //                             this.echeancesData.push(JSON.parse(ECHEANCES).output[key]);
    //                             const ECHEANCE = ECHEANCES.output[key];
    //                             if (new Date(ECHEANCE.date_decheance) < new Date() && !this.isEcheanceSolde(ECHEANCE.soldee_le)) {
    //                             this.conditionCas2 = true;
    //                         }
    //                         if (new Date(ECHEANCE.date_decheance) < new Date() && this.isEcheanceSolde(ECHEANCE.soldee_le)) {
    //                             count++;
    //                         }
    //                     }

    //                     if(count == ECHEANCES.output.length) 
    //                         this.conditionCas1 = true;
    //                 }
    //                 }
    //                 if(this?.echeancesData && this?.echeancesData.length > 0){
    //                     this.inpaidEcheance = this.findFirstInpaidEcheance(this.echeancesData);
    //                 }
    //             }
    //             if(!(this.amount || this.echeanceid)){
    //                 this.amount = this.getAmount();
    //                 this.echeanceid = this.getEcheanceId();
    //         }
    //         console.log('this.listFctEch lenght '+this.listFctEch.length)
    //         if(this.listFctEch.length > 1){
    //             this.listFctEch = this.listFctEch.sort(function(a, b) {
    //                 return new Date(a.dateExigible) - new Date(b.dateExigible);
    //             })
    //             this.showListPayement = true;
    //             this.payementAmountToDisplay = (this.montantToDisplay - parseFloat(this.listFctEch[0].montant)).toFixed(2);
    //         }
    //     }

    //     // if (this.version2) {
    //     //     console.log('in version 2')
    //     //     if (this.contractElec) {
    //     //             const INFO_CONTRACT_ELEC_RESULT = await this.getInfoContractdata(this.contractElec.id.toString());
    //     //             const INFO_CONTRACT_ELEC_PARSED = JSON.parse(INFO_CONTRACT_ELEC_RESULT);
    //     //         if (INFO_CONTRACT_ELEC_PARSED?.output?.jour_drp) {
    //     //             this.datePrelevement = ('0' + INFO_CONTRACT_ELEC_PARSED.output.jour_drp).slice(-2);
    //     //         }
    //     //     }
    //     //     if (this.contractGaz) {
    //     //             const INFO_CONTRACT_GAZ_RESULT = await this.getInfoContractdata(this.contractGaz.id.toString());
    //     //             const INFO_CONTRACT_GAZ_PARSED = JSON.parse(INFO_CONTRACT_GAZ_RESULT);
    //     //         if (INFO_CONTRACT_GAZ_PARSED?.output?.jour_drp) {
    //     //             this.datePrelevement = ('0' + INFO_CONTRACT_GAZ_PARSED.output.jour_drp).slice(-2);
    //     //         }
    //     //     }
    //     // }
    //     } catch (error) {
    //         console.log('Error in populateContractInfo : '+error.message);
    //     }
    //     this.isProcessFinished = true;
    // }

    // initializeComponantProperties() {
    //     this.actifPRTF = null;
    //     this.contractGaz = null;
    //     this.contractElec = null;
    //     this.version1 = false;
    //     this.version2 = false;
    //     this.datePrelevement = null;

    //     this.solde == null;

    //     this.conditionCas1 = false;
    //     this.conditionCas2 = false;
    //     this.isProcessFinished = false;
    //     this.listFctEch = [];
    //     this.showListPayement = false;
    //     this.montantToDisplay = null;
    //     this.payementAmountToDisplay = 0;
    // }

    // handleNavigateEnSavoirPlusPaiement1() {
    //     const config = {
    //         type: 'standard__webPage',
    //         attributes: {
    //             url: this.lienEnSavoirPlusPaiement1
    //         }
    //     };
    //     this[NavigationMixin.Navigate](config);
    // }

    // handleNavigateEnSavoirPlusPaiement2() {
    //     const config = {
    //         type: 'standard__webPage',
    //         attributes: {
    //             url: this.lienEnSavoirPlusPaiement2
    //         }
    //     };
    //     this[NavigationMixin.Navigate](config);
    // }

    // handleNavigateEnSavoirPlusPaiement3() {
    //     const config = {
    //         type: 'standard__webPage',
    //         attributes: {
    //             url: this.lienEnSavoirPlusPaiement3
    //         }
    //     };
    //     this[NavigationMixin.Navigate](config);
    // }

    // handleNavigateEnSavoirPlusPaiement4() {
    //     const config = {
    //         type: 'standard__webPage',
    //         attributes: {
    //             url: this.lienEnSavoirPlusPaiement4
    //         }
    //     };
    //     this[NavigationMixin.Navigate](config);
    // }

    // handleNavigateEnSavoirPlusPaiement5() {
    //     const config = {
    //         type: 'standard__webPage',
    //         attributes: {
    //             url: this.lienEnSavoirPlusPaiement5
    //         }
    //     };
    //     this[NavigationMixin.Navigate](config);
    // }

    // isEcheanceSolde(soldee) {
    //     if(soldee.includes('Total') || soldee.includes('Partiel'))
    //         return true;
    //     return false;
    // }

    // async getContractdata() {
    //     return new Promise(async (resolve, reject) => {
    //         var result = await getContractData({})
    //             .then(response => {
    //                 return response;
    //             }).catch(error => {
    //                 console.log('***Error getContractData : ' + JSON.stringify(error));
    //                 return error;
    //             });
    //         resolve(result);
    //     })
    // }

    // async getSoldeEffectifData() {
    //     return new Promise(async (resolve, reject) => {
    //         var result = await getSoldeEffectifData({})
    //             .then(response => {
    //                 return response;
    //             }).catch(error => {
    //                 console.log('***Error getSoldeEffectifData : ' + JSON.stringify(error));
    //                 return error;
    //             });
    //         resolve(result);
    //     })
    // }

    // async getPorteFeuilledata(portefeuilleId) {
    //     return new Promise(async (resolve, reject) => {
    //         var result = await getPorteFeuilleContrat({ contractPortfolioXdataId: portefeuilleId })
    //             .then(response => {
    //                 return response;
    //             }).catch(error => {
    //                 console.log('***Error getPorteFeuilleData : ' + JSON.stringify(error));
    //                 return error;
    //             });
    //         resolve(result);
    //     })
    // }

    // async getEcheanceData(contractId) {
    //     return new Promise(async (resolve, reject) => {
    //         var result = await getEcheanceContractData({ id_contrat_xdata: contractId })
    //             .then(response => {
    //                 return response;
    //             }).catch(error => {
    //                 console.log('***Error getEcheanceContractData : ' + JSON.stringify(error));
    //                 return error;
    //             });
    //         resolve(result);
    //     })
    // }

    // async getFactureData(portefeuilleId) {
    //     return new Promise(async (resolve, reject) => {
    //         var result = await getFactureAgilabData({ id_portefeuille_contrat_xdata: portefeuilleId })
    //             .then(response => {
    //                 return response;
    //             }).catch(error => {
    //                 console.log('***Error getFactureAgilabData : ' + JSON.stringify(error));
    //                 return error;
    //             });
    //         resolve(result);
    //     })
    // }

    // async getInfoContractdata(contractId) {
    //     return new Promise(async (resolve, reject) => {
    //         var result = await getInfoContractData({ id_contrat_xdata: contractId }).then(response => {
    //             return response;
    //         }).catch(error => {
    //             console.log('***Error getPorteFeuilleData : ' + JSON.stringify(error));
    //             return error;
    //         });
    //         resolve(result);
    //     })
    // }
	
	handleClickCB(){
        generateSogenactifParams({amount : this.amount, contactId : this.contact.Id, echeanceId : this.echeanceid, paymentMethod : 'CB'}).then(response => {
            if(response.redirectionStatusCode == '00'){
                this.sogenactifRedirectionURL = response.redirectionUrl;
                this.redirectionVersion = response.redirectionVersion;
                this.redirectionData = response.redirectionData;
                if(this.sogenactifRedirectionURL && this.redirectionVersion && this.redirectionData){
                    const myForm = this.template.querySelector('form');
                    myForm.action = this.sogenactifRedirectionURL;
                    this.template.querySelector('[data-id="redirectionVersion"]').value = this.redirectionVersion;
                    this.template.querySelector('[data-id="redirectionData"]').value = this.redirectionData;
                    console.log(myForm.action);
                    myForm.submit();
                }
            }else{
                console.log(JSON.stringify(response));
            }
        }).catch(error => {
            console.log('erreure sogenactif : '+JSON.stringify(error));
        });
    }
    handleClickPaylib(){
        generateSogenactifParams({amount : this.amount, contactId : this.contact.Id, echeanceId : this.echeanceid, paymentMethod : 'PAYLIB'}).then(response => {
            if(response.redirectionStatusCode == '00'){
                this.sogenactifRedirectionURL = response.redirectionUrl;
                this.redirectionVersion = response.redirectionVersion;
                this.redirectionData = response.redirectionData;
                if(this.sogenactifRedirectionURL && this.redirectionVersion && this.redirectionData){
                    const myForm = this.template.querySelector('form');
                    myForm.action = this.sogenactifRedirectionURL;
                    this.template.querySelector('[data-id="redirectionVersion"]').value = this.redirectionVersion;
                    this.template.querySelector('[data-id="redirectionData"]').value = this.redirectionData;
                    console.log(myForm.action);
                    myForm.submit();
                }
            }else{
                console.log(JSON.stringify(response));
            }
        }).catch(error => {
            console.log('erreure sogenactif : '+JSON.stringify(error));
        });
    }

    // findFirstInpaidInvoice(factList) {
    //     let minFact = null;
    //     let today = new Date();
    //     for(let fact of factList) {
    //         let currentDate = new Date(fact.date_limite_de_paiement);
    //         if(minFact == null && currentDate <= today && (fact.statut == 1 || fact.statut == 2)) {
    //             minFact = fact;
    //             minFact.date_limite_de_paiement = currentDate;
    //             continue;
    //         }
    //         if(minFact != null && currentDate <= today && minFact.date_limite_de_paiement < currentDate && (fact.statut == 1 || fact.statut == 2)) {
    //             minFact = fact;
    //             minFact.date_limite_de_paiement = currentDate;
    //         }
    //     } 
    //     return minFact;
    // }

    // findFirstInpaidEcheance(echList) {
    //     let minEch = null;
    //     let today = new Date();
    //     for(let ech of echList) {
    //         let currentDate = new Date(ech.date_decheance);
    //         if(minEch == null && currentDate <= today && ech.soldee_le == null && ech.annulee_le == null) {
    //             minEch = ech;
    //             minEch.dt = currentDate;
    //             continue;
    //         }
    //         if(minEch != null && currentDate <= today && minEch.dt < currentDate && ech.soldee_le == null && ech.annulee_le == null) {
    //             minEch = ech;
    //             minEch.dt = currentDate;
    //         }
    //     } 
    //     return minEch;
    // }

    // getAmount(){
    //     try {
    //         if(this?.inpaidInvoice && this?.inpaidEcheance){
    //             return this.inpaidInvoice.date_limite_de_paiement < this.inpaidEcheance.date_decheance ? this.inpaidEcheance.montant_restant_du : this.inpaidInvoice.montant_restant_du ;
    //         }else if(this?.inpaidInvoice){
    //             return this.inpaidInvoice.montant_restant_du ;
    //         }else if(this?.inpaidEcheance){
    //             return this.inpaidEcheance.montant_restant_du;
    //         }
    //     } catch (error) {
    //         console.log('Erreur dans getAmount : '+error.message);
    //     }
    // }

    // getEcheanceId(){
    //     try {
    //         if(this?.inpaidInvoice && this?.inpaidEcheance){
    //             return this.inpaidInvoice.date_limite_de_paiement < this.inpaidEcheance.date_decheance ? this.inpaidEcheance.reference : this.inpaidInvoice.ref_echeance_facture ;
    //         }else if(this?.inpaidInvoice){
    //             return this.inpaidInvoice.ref_echeance_facture ;
    //         }else if(this?.inpaidEcheance){
    //             return this.inpaidEcheance.reference;
    //         }
    //     } catch (error) {
    //         console.log('Erreur dans getEcheanceId : '+error.message);
    //     }
    // }

    handleClickAmazonPay(){
        //generateAmazonPayParams({echeanceId : this.echeanceid, amount : this.amount}).then(response =>{
        generateAmazonPayParams({echeanceId : 'ECH1679601', amount : '628.03'}).then(response =>{    
            console.log('Signature Amazon Pay : ' + response.signature);
            const myForm = this.template.querySelector('[data-id="amazonePayForm"]');
            myForm.action = 'https://payments.amazon.fr/checkout/initiate';
            this.template.querySelector('[data-id="payloadJSON"]').value = response.payloadJSON;
            this.template.querySelector('[data-id="signature"]').value = response.signature;
            this.template.querySelector('[data-id="publicKeyId"]').value = response.publicKeyId;
            this.template.querySelector('[data-id="algorithm"]').value = response.algorithm;
            this.template.querySelector('[data-id="ledgerCurrency"]').value = response.ledgerCurrency;
            this.template.querySelector('[data-id="checkoutLanguage"]').value = response.checkoutLanguage;
            this.template.querySelector('[data-id="merchantId"]').value = response.merchantId;
            this.template.querySelector('[data-id="productType"]').value = response.productType;
            this.template.querySelector('[data-id="environment"]').value = response.environment;
            this.template.querySelector('[data-id="merchantDomain"]').value = response.merchantDomain;
            this.template.querySelector('[data-id="origin_url"]').value = response.origin_url;
            console.log(myForm.action);
            myForm.submit();
        }).catch(error => {
            console.log('Erreure amazon pay : '+JSON.stringify(error));
        })
    }

    
}