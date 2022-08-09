/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 08-02-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
import { LightningElement, api, track, wire } from 'lwc';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getSoldeData from '@salesforce/apex/HP_EC_LoadCustomerData.getSoldeEffectifData';
import getFacture from '@salesforce/apex/HP_EC_LoadCustomerData.getFactureAgilabData';
import getEcheance from '@salesforce/apex/HP_EC_LoadCustomerData.getEcheanceContractData';
import getPorteFeuilleContrat from '@salesforce/apex/HP_EC_LoadCustomerData.getPorteFeuilleContratXdata';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getPlansApurement from '@salesforce/apex/HP_EC_LoadCustomerData.getPlansApurement';
import { NavigationMixin } from 'lightning/navigation';

import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';



export default class Hp_ec_solde extends NavigationMixin(LightningElement) {

    //ID TIERES = 83368331
    @api titleText;
    @api messageRemerciement;
    @api debiteur;
    @api debiteurRetard;
    @api crediteur;
    @api confirmationSoldeRegle;
    @api prochaineFacture;
    @api firstButton;
    @api secondButton;
    @api lien;
    @api usePathInFirstButton;

    //popin paiement echeance contribution
    @api listPaymentsTitle;
    @api textRappel;
    @api messageListPayement;
    @api boutonListPaymentLabel;


    @track idPortefeuilleContrat;
    @track soldeEffectifData;
    @track solde;
    @track showPayButton;
    @track actifPRTF;
    @track message;
    @track montant = 0.0
    @track montantToDisplay = 0.0
    @track soldetData
    @track echeancesCondition = []
    @track facturesCondition = []
    @track todayDate = new Date()
    @track conditionsOfCas1 = false
    @track conditionsOfCas2 = false
    @track conditionsOfCas3 = false
    @track conditionsOfCas4 = false
    @track conditionsOfCas5 = false
    @track dateToDisplay
    @track facturesData;
    @track echeancesData;
	@track contractData;
    @track contractElec;
    @track contractGaz;
    @track inpaidInvoice;
    @track inpaidEcheance;
    @track amount;
    @track echeanceId;
    @track listFctEch = [];
    @track conditionCas1;
    @track conditionCas2;
    @track isProcessFinished;
    @track payementAmountToDisplay;
    @track montantToPaye;
    @track showListPayementComponent = false;
    @track showListPayement;
    @track echeancIdToPaye;
    @track contact;

    // Champs contribuables pour hp_ec_popinPayments : START //
    @api titreV1;
    @api titreV2;

    @api labelMoyenPaiement1;
    @api labelMoyenPaiement2;
    @api labelMoyenPaiement3;
    @api labelMoyenPaiement4;
    @api labelMoyenPaiement5;

    @api lienEnSavoirPlusPaiement1;
    @api lienEnSavoirPlusPaiement2;
    @api lienEnSavoirPlusPaiement3;
    @api lienEnSavoirPlusPaiement4;
    @api lienEnSavoirPlusPaiement5;

    @api showLienEnSavoirPlusPaiement1;
    @api showLienEnSavoirPlusPaiement2;
    @api showLienEnSavoirPlusPaiement3;
    @api showLienEnSavoirPlusPaiement4;
    @api showLienEnSavoirPlusPaiement5;

    @api textModePaiement;
    @api textDatePrelevementPart1;
    @api textDatePrelevementPart2;
    // Champs contribuables : END //

    paymentPopin = false;
    prelevement = false;
    pageReloaded = false;

    openPopin () {
        
        this.paymentPopin = true;
    }

    closePopin (event) {
        event.preventDefault();
        event.stopPropagation();
        event.stopImmediatePropagation();
        this.paymentPopin = false;
    }


    @wire(getSoldeData)
    wiredGetSoldeData({ data, error }) {
        if (data) {
            this.soldetData = data;
            //console.log('this.soldetData in wire : ' + JSON.stringify(this.soldetData));

        }
        if (error) {
            console.log('Error : ' + JSON.stringify(error));
            //Cas 5
            this.conditionsOfCas5 = true
            this.conditionsOfCas2 = false
            this.conditionsOfCas3 = false
            this.conditionsOfCas4 = false
            this.conditionsOfCas1 = false
        }
    }

    @wire(getContractData)
     wiredContract({ error, data }) {
         if (data) {
             this.contractData = JSON.parse(data);
            } else if (error) {
                console.log(JSON.stringify(error));
            }
        }

        @wire(getContactData)
        wiredContact({error, data}){
            if(data){
                this.contact = JSON.parse(data);
            }
            else if (error) {
                console.log(JSON.stringify(error));
            }
        }

    @wire(MessageContext) messageContext;
    
    connectedCallback() {
        if (performance.navigation.type == performance.navigation.TYPE_RELOAD) {
            console.info( "This page is reloaded" );
            this.pageReloaded = true;
          }
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.handleSubscription();
        this.populateContractInfo();
    }

    handleSubscription() {
        subscribeMC(this, this.messageContext, this.handleLightningMessage);
    }

    handleLightningMessage(self, subscription, message) {
        if (message.messageType == 'SelectedPortfolio' && !self.pageReloaded) {
            self.idPortefeuilleContrat = message.messageData.message;
            self.populateContractInfo();
        }
        self.pageReloaded = false;
    }

    handlePublish(message) {
        // publishMC(this.messageContext, message, 'SelectedEnergy');
    }

    get isEtatInactif() {
        if(!(this.isProcessFinished && (this.montant <= 0) && (this.conditionCas1 || this.conditionCas2)))
            return true;
        return false;
    }


    async populateContractInfo() {
        this.initialiseGlobalVar();
        if (this.contractData.length == 0) {
            this.spinnerLoad = true;
            const contractDataResult = await this.getContractData();
            this.contractData = JSON.parse(contractDataResult);
        }
        if(!this.idPortefeuilleContrat){
            return;
        }
        
        const factures = await this.getFacture();
        const FACTURES = JSON.parse(factures);
        this.facturesData = JSON.parse(factures).output.factures;
        this.inpaidInvoice = this.findFirstInpaidInvoice(this.facturesData);
        this.facturesCondition =  await this.getConditionFacture(this.facturesData);
        if(FACTURES.status == 'SUCCESS') {
            let count = 0;
            this.listFctEch = [];
            this.listFctEch = this.listFctEchToShow(FACTURES, '');
            FACTURES.output.factures.forEach(f => {
                if((f.statut == '1' || f.statut == '2') && (new Date(f.date_limite_de_paiement) < new Date())) {
                this.conditionCas2 = true;
            }
            if((f.statut == '1' || f.statut == '2') && (new Date(f.date_limite_de_paiement) > new Date())) {
                count++;
            }
            });

            if(count == FACTURES.output.factures.length) 
                this.conditionCas1 = true;
        }

        const plansApurementList = await this.getPlansApurement();
        
        if (plansApurementList) {
            const plansTab = JSON.parse(plansApurementList).output.plans_apurement; 
            const filtredPlansTab = plansTab.filter(pla => pla?.statut == 3);
            let echsPla = [];
            if(filtredPlansTab.length != 0){
                filtredPlansTab.forEach(c => {
                    echsPla = echsPla.concat(c.echeances.filter(ech => ech?.statut == 1 || ech?.statut == 10));
                });
                const echsPlansApurement = await this.listEchPlaToShow(echsPla);
                this.listFctEch = this.listFctEch.concat(echsPlansApurement);
            }
        }
        
        if(this?.contractData.length !=0){
            const ACTIF_PORTEFEUILLE = await this.getPorteFeuilledata(this.idPortefeuilleContrat);
            this.actifPRTF = JSON.parse(ACTIF_PORTEFEUILLE);
            this.actifPRTF.codeModeEncaissement == '5' ? this.prelevement = true : this.prelevement = false;
            let today = new Date();
            this.contractData._data.forEach(c => {
                let dateFinValidite = new Date(c.dateFinValidite);
                let diffTime = Math.abs(today - dateFinValidite);
                let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                let isOldContract = (diffDays > 365) && (today > dateFinValidite) ;
                if ((c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' ||
                c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007' || 
                ((c.codeStatutCrm == 'E0009' && isOldContract) || (c.codeStatutCrm == 'H0103' && isOldContract))) && 
                c.idPortefeuilleContrat == this.idPortefeuilleContrat) {
                    c.energie == 'Electricité' ? this.contractElec = c : this.contractGaz = c;
                    
                }
            });

           
            if(this.contractElec){
                let count = 0;
                const echeanceData = await this.getEcheanceData(this.contractElec);
                const ECHEANCES = JSON.parse(echeanceData);
                if(!(JSON.parse(echeanceData).status == "FAILED")){
                    const tbEchElec = await this.listEcheanceToShow(ECHEANCES, 'Elec')
                    this.listFctEch = this.listFctEch.concat(tbEchElec);
                    let keys = Object.keys(JSON.parse(echeanceData).output);
                    for (let key of keys) {
                        this.echeancesData.push(JSON.parse(echeanceData).output[key]);
                        const ECHEANCE = ECHEANCES.output[key];
                        if (new Date(ECHEANCE.date_decheance) < new Date() && !this.isEcheanceSolde(ECHEANCE.soldee_le)) {
                            this.conditionCas2 = true;
                        }
                        if (new Date(ECHEANCE.date_decheance) < new Date() && this.isEcheanceSolde(ECHEANCE.soldee_le)) {
                            count++;
                        }
                    }
                    if(count == ECHEANCES.output.length){
                        this.conditionCas1 = true;
                    }
                            
                }
                
            }
            
            if(this.contractGaz){
                let count = 0;
                const echeanceData = await this.getEcheanceData(this.contractGaz);
                const ECHEANCES = JSON.parse(echeanceData);
                if(!(JSON.parse(echeanceData).status == "FAILED")){
                    const tbEchGaz = await this.listEcheanceToShow(ECHEANCES, 'Gaz');
                    this.listFctEch = this.listFctEch.concat(tbEchGaz);
                    let keys = Object.keys(JSON.parse(echeanceData).output);
                    for (let key of keys) {
                        this.echeancesData.push(JSON.parse(echeanceData).output[key]);
                        const ECHEANCE = ECHEANCES.output[key];
                        if (new Date(ECHEANCE.date_decheance) < new Date() && !this.isEcheanceSolde(ECHEANCE.soldee_le)) {
                            this.conditionCas2 = true;
                        }
                        if (new Date(ECHEANCE.date_decheance) < new Date() && this.isEcheanceSolde(ECHEANCE.soldee_le)) {
                            count++;
                        }
                    }
                    if(count == ECHEANCES.output.length){
                        this.conditionCas1 = true;
                    }
                }
                
            }
            
            if (this?.echeancesData && this.echeancesData.length > 0) {
                this.inpaidEcheance = this.findFirstInpaidEcheance(this.echeancesData);
                this.echeancesCondition = await this.getEcheanceCondition(this.echeancesData);
            }

        }
        if (!this.soldetData) {
            this.spinnerLoad = true;
            this.soldetData = await this.getSoldeData();
        }
        if (this?.soldetData) {
            this.spinnerLoad = false;
            this.soldeEffectifData = JSON.parse(this.soldetData);
            if (this.soldeEffectifData.output?.soldes) {
                let keys = Object.keys(this.soldeEffectifData.output.soldes);
                for (let key of keys) {
                    let key2 = Object.keys(this.soldeEffectifData.output.soldes[key]);
                    if (key2 == this.idPortefeuilleContrat) {
                        this.montant = this.soldeEffectifData.output.soldes[key][key2];
                        let absMontant = Math.abs(this.montant);
                        this.montantToDisplay = (Math.round(absMontant * 100) / 100).toFixed(2);
                    }
                }
                if(this.listFctEch.length != 0 && this.montant < 0){
                    this.showListPayement = await this.sortListFctEch(this.listFctEch);
                }
            }
            if (this.facturesCondition.length == 0 || this.echeancesCondition.length == 0) {
                let contract = await this.getContractData();
                let factures = await this.getFacture();
                this.amount = this.getAmount();
                this.echeanceId = this.getEcheanceId();
            }
            let lowerDate;
            if (this.facturesCondition.length > 0 || this.echeancesCondition.length > 0) {
                //Cas 1
                if (this.montant < 0 && (this.facturesCondition[0] || this.echeancesCondition[0])) {
                    this.conditionsOfCas1 = true;
                    this.conditionsOfCas2 = false;
                    this.conditionsOfCas3 = false;
                    this.conditionsOfCas4 = false;
                    this.conditionsOfCas5 = false;
                    if(this.facturesCondition.length > 0 && this.echeancesCondition.length > 0){
                        if(this.facturesCondition[2] != null && this.echeancesCondition[2] == null){
                            lowerDate = this.facturesCondition[2];
                        }
                        else if(this.facturesCondition[2] == null && this.echeancesCondition[2] != null){
                            lowerDate = this.echeancesCondition[2];
                        }
                        else if(this.facturesCondition[2] < this.echeancesCondition[2]){
                            lowerDate =  this.facturesCondition[2];
                        }
                        else{
                            lowerDate =  this.echeancesCondition[2];
                        }
                    }
                    else if(this.facturesCondition.length > 0 && this.echeancesCondition.length == 0){
                        lowerDate =  this.facturesCondition[2];
                    }
                    else if(this.facturesCondition.length == 0 && this.echeancesCondition.length > 0){
                        lowerDate =  this.echeancesCondition[2];
                    }
                    let day = ("0" + lowerDate.getDate()).slice(-2);
                    let monthIndex =("0" + (lowerDate.getMonth() + 1)).slice(-2);
                    let year = lowerDate.getFullYear();
                    this.dateToDisplay = day +'/'+monthIndex+'/'+year;
                }
                //Cas 2
                if (this.montant < 0 && (this.facturesCondition[1] || this.echeancesCondition[1])) {
                    this.conditionsOfCas2 = true;
                    this.conditionsOfCas1 = false;
                    this.conditionsOfCas3 = false;
                    this.conditionsOfCas4 = false;
                    this.conditionsOfCas5 = false;
                    if(this.facturesCondition.length > 0 && this.echeancesCondition.length > 0){
                        if(this.facturesCondition[2] != null && this.echeancesCondition[2] == null){
                            lowerDate = this.facturesCondition[2];
                        }
                        if(this.facturesCondition[2] == null && this.echeancesCondition[2] != null){
                            lowerDate = this.echeancesCondition[2];
                        }
                        if(this.facturesCondition[2] < this.echeancesCondition[2]){
                            lowerDate =  this.facturesCondition[2];
                        }
                        else{
                            lowerDate =  this.echeancesCondition[2];
                        }
                    }
                    else if(this.facturesCondition.length > 0 && this.echeancesCondition.length == 0){
                        lowerDate =  this.facturesCondition[2];
                    }
                    else if(this.facturesCondition.length == 0 && this.echeancesCondition.length > 0){
                        lowerDate =  this.echeancesCondition[2];
                    }
                    let day = ("0" + lowerDate.getDate()).slice(-2);
                    let monthIndex =("0" + (lowerDate.getMonth() + 1)).slice(-2);
                    let year = lowerDate.getFullYear();
                    this.dateToDisplay = day +'/'+monthIndex+'/'+year;
                }
            }
            //Cas 3
            if (this.montant > 0) {
                this.conditionsOfCas3 = true;
                this.conditionsOfCas2 = false;
                this.conditionsOfCas1 = false;
                this.conditionsOfCas4 = false;
                this.conditionsOfCas5 = false;
            }
            //Cas 4
            if (this.montant == 0 && (this.facturesData.length != 0 || this.echeancesData != 0)) {
                this.conditionsOfCas4 = true;
                this.conditionsOfCas2 = false;
                this.conditionsOfCas3 = false;
                this.conditionsOfCas1 = false;
                this.conditionsOfCas5 = false;
                if(this.soldeEffectifData.output?.portefeuille_contrats?.length > 0){
                    let day;
                    let monthIndex;
                    let year;
                    for(let i = 0; i < this.soldeEffectifData.output.portefeuille_contrats.length; i++){
                        let key3 = Object.keys(this.soldeEffectifData.output.portefeuille_contrats[i]);
                        if(key3 == this.idPortefeuilleContrat){
                            let myObj = this.soldeEffectifData.output.portefeuille_contrats[i][key3];
                            for(let key of Object.keys(myObj[0])){ 
                                lowerDate = new Date(myObj[0][key].date_prochaine_facture);
                                break; 
                            }
                            day = ("0" + lowerDate.getDate()).slice(-2);
                            monthIndex =("0" + (lowerDate.getMonth() + 1)).slice(-2);
                            year = lowerDate.getFullYear();
                            this.dateToDisplay = day +'/'+monthIndex+'/'+year;
                        }
                    }
                }
            }
            //Suite de Cas 5
            if (this.montant == 0 && (this.facturesData.length == 0 && this.echeancesData == 0)) {
                this.conditionsOfCas5 = true;
                this.conditionsOfCas2 = false;
                this.conditionsOfCas3 = false;
                this.conditionsOfCas4 = false;
                this.conditionsOfCas1 = false;
                if(this.soldeEffectifData.output?.portefeuille_contrats?.length > 0){
                    let day;
                    let monthIndex;
                    let year;
                    for(let i = 0; i < this.soldeEffectifData.output.portefeuille_contrats.length; i++){
                        let key3 = Object.keys(this.soldeEffectifData.output.portefeuille_contrats[i]);
                        if(key3 == this.idPortefeuilleContrat){
                            let myObj = this.soldeEffectifData.output.portefeuille_contrats[i][key3];
                            for(let key of Object.keys(myObj[0])){ 
                                lowerDate = new Date(myObj[0][key].date_prochaine_facture);
                                break; 
                            }
                            day = ("0" + lowerDate.getDate()).slice(-2);
                            monthIndex =("0" + (lowerDate.getMonth() + 1)).slice(-2);
                            year = lowerDate.getFullYear();
                            this.dateToDisplay = day +'/'+monthIndex+'/'+year;
                        }
                    }
                }
            }
        }
        this.isProcessFinished = true;
    }
    initialiseGlobalVar(){
    this.soldeEffectifData = null;
    this.solde = null;
    this.showPayButton = null;
    this.actifPRTF = null;
    this.message = null;
    this.montant = 0.0
    this.montantToDisplay = 0.0
    this.soldetData = null;
    this.echeancesCondition = [];
    this.facturesCondition = [];
    this.todayDate = new Date();
    this.conditionsOfCas1 = false;
    this.conditionsOfCas2 = false;
    this.conditionsOfCas3 = false;
    this.conditionsOfCas4 = false;
    this.conditionsOfCas5 = false;
    this.dateToDisplay = null;
    this.facturesData = [];
    this.echeancesData = [];
    this.contractData = [];
    this.spinnerLoad = false;
    this.prelevement = false;
    this.listFctEch = [];
    this.conditionCas1 = false;
    this.conditionCas2 = false;
    this.isProcessFinished = false;
    this.payementAmountToDisplay = 0;
    this.montantToPaye = null;
    this.showListPayementComponent = false;
    this.showListPayement = null;
    this.echeancIdToPaye = null;

    }

    async getSoldeData() {
        return new Promise(async (resolve, reject) => {
            var result = await getSoldeData({}).then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getSoldeData : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        })
    }

    async getPorteFeuilledata(portefeuilleId) {
        return new Promise(async (resolve, reject) => {
            var result = await getPorteFeuilleContrat({ contractPortfolioXdataId: portefeuilleId })
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error getPorteFeuilleData : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
    }

    async getFacture() {
        return new Promise(async (resolve, reject) => {
            var result = await getFacture({ id_portefeuille_contrat_xdata: this.idPortefeuilleContrat.toString() })
                .then(data => {
                    return data;
                })
                .catch(error => {
                    console.log('error facture: ' + JSON.stringify(error));
                });
            resolve(result);
        })
    }

    async getContractData() {
        return new Promise(async (resolve, reject) => { 
            var result = await getContractData()
                .then(data => {
                    return data;
                })
                .catch(error => {
                    console.log('error contract data: ' + JSON.stringify(error));
                });
            resolve(result);
        })
    }

    async getEcheanceData(c) {
        return new Promise(async (resolve, reject) => {
            var result = await getEcheance({ id_contrat_xdata: c.id.toString() })
                .then(data => {
                    return data;
                })
                .catch(error => {
                    console.log('error Eéchéence: ' + JSON.stringify(error));
                });
            resolve(result);
        })
    }

    async getPlansApurement() {
        return new Promise(async (resolve, reject) => {
            var result = await getPlansApurement({ idPorteFueilleContrat: this.idPortefeuilleContrat })
                .then(data => {
                    return data;
                })
                .catch(error => {
                    console.log('error getPlansApurement: ' + JSON.stringify(error));
                });
            resolve(result);
        })
      }

    async getConditionFacture(factures) {
        return new Promise(async (resolve, reject) => {
        let facturesHasCodition1 = [];
        let facturesHasCodition2 = [];
        let isFacturesHasConditionForCas1 = false;
        let isFacturesHasConditionForCas2 = false;
        let tabConditionFactures = [];
        let tabFacturesDates = [];
        let facturesTab = [];
        let dateFacture; 
        factures.forEach(fct => {
            if( fct.montant_restant_du != 0.0){
                facturesTab.push(fct);
            
            if ((fct.statut == 1 || fct.statut == 2) && new Date(fct.date_limite_de_paiement) > this.todayDate) {

                facturesHasCodition1.push(fct);
                tabFacturesDates.push(new Date(fct.date_limite_de_paiement));
            }
            if ((fct.statut == 1 || fct.statut == 2) && new Date(fct.date_limite_de_paiement) < this.todayDate) {
                facturesHasCodition2.push(fct);
                tabFacturesDates.push(new Date(fct.date_limite_de_paiement));
            }
        }
        })
        dateFacture = tabFacturesDates.sort(function(a, b) {
                                                    return a - b;
                                                }).shift()
        if (facturesHasCodition1.length == facturesTab.length) {
            isFacturesHasConditionForCas1 = true;
        }
        if (facturesHasCodition2.length > 0) {
            isFacturesHasConditionForCas2 = true;
        }
        tabConditionFactures.push(isFacturesHasConditionForCas1);
        tabConditionFactures.push(isFacturesHasConditionForCas2);
        tabConditionFactures.push(dateFacture);
        resolve(tabConditionFactures);
        })
    }

    async getEcheanceCondition(echeances) {
        return new Promise(async (resolve, reject) => {
        let echeancesHasCodition1 = [];
        let echeancesHasCodition2 = [];
        let isEcheancesHasConditionForCas1 = false;
        let isEcheancesHasConditionForCas2 = false;
        let tabConditionEcheances = [];
        let tabDatesEcheances = [];
        let dateEchance;
        echeances.forEach(ech => {
            let soldeEcheance = this.isEcheanceSolde(ech.soldee_le);
            if (new Date(ech.date_decheance) < this.todayDate && (soldeEcheance && ech.annulee_le == null)) {
                echeancesHasCodition1.push(ech);
                tabDatesEcheances.push(new Date(ech.date_decheance));
            }
            if (new Date(ech.date_decheance) < this.todayDate && (!soldeEcheance && ech.annulee_le == null)) {
                echeancesHasCodition2.push(ech);
                tabDatesEcheances.push(new Date(ech.date_decheance));
            }
        })
        dateEchance = tabDatesEcheances.sort(function(a, b) {
                                                return a - b;
                                            }).shift()
        if (echeancesHasCodition1.length == echeances.length) {
            isEcheancesHasConditionForCas1 = true;
        }
        if (echeancesHasCodition2.length > 0) {
            isEcheancesHasConditionForCas2 = true;
        }
        tabConditionEcheances.push(isEcheancesHasConditionForCas1);
        tabConditionEcheances.push(isEcheancesHasConditionForCas2);
        tabConditionEcheances.push(dateEchance);
        resolve (tabConditionEcheances);

        })
        
    }

     async isEcheanceSolde(solde) {
        let soldee = false
        if(solde.includes('Total') || solde.includes('Partiel')){
            soldee = true;
        }
           
        return soldee;
        //     let isSoldee = false;
        // if(solde != null && solde !== ''){
        //     let arraySolde = solde.split(" ");
        //     arraySolde.forEach(sld => {
        //         if (sld == "Total" || sld == "Partiel") {
        //             isSoldee = true;
        //         }
        //     })
        // }
        // return isSoldee;
        
    }

    convertDate(inputFormat) {
        function pad(s) { return (s < 10) ? '0' + s : s; }
        var d = inputFormat;
        return [pad(d.getDate()), pad(d.getMonth()+1), d.getFullYear()].join('.');
    }

     actionFirstButton() {
        const config = {
             type: 'standard__webPage',
             attributes: {
                 url:  this.lien
                }
            };
            this[NavigationMixin.Navigate](config);
      }

    findFirstInpaidInvoice(factList) {
        let minFact = null;
        let today = new Date();
        for(let fact of factList) {
            let currentDate = new Date(fact.date_limite_de_paiement);
            if(minFact == null && currentDate <= today && (fact.statut == 1 || fact.statut == 2)) {
                minFact = fact;
                minFact.date_limite_de_paiement = currentDate;
                continue;
            }
            if(minFact != null && currentDate <= today && minFact.date_limite_de_paiement < currentDate && (fact.statut == 1 || fact.statut == 2)) {
                minFact = fact;
                minFact.date_limite_de_paiement = currentDate;
            }
        } 
        return minFact;
    }

    findFirstInpaidEcheance(echList) {
        let minEch = null;
        let today = new Date();
        for(let ech of echList) {
            let currentDate = new Date(ech.date_decheance);
            if(minEch == null && currentDate <= today && ech.soldee_le == null && ech.annulee_le == null) {
                minEch = ech;
                minEch.dt = currentDate;
                continue;
            }
            if(minEch != null && currentDate <= today && minEch.dt < currentDate && ech.soldee_le == null && ech.annulee_le == null) {
                minEch = ech;
                minEch.dt = currentDate;
            }
        } 
        return minEch;
    }

    getAmount(){
        if(this?.inpaidInvoice && this?.inpaidEcheance){
            return this.inpaidInvoice.date_limite_de_paiement < this.inpaidEcheance.date_decheance ? this.inpaidEcheance.montant_restant_du : this.inpaidInvoice.montant_restant_du ;
        }else if(this?.inpaidInvoice){
            return this.inpaidInvoice.montant_restant_du ;
        }else if(this?.inpaidEcheance){
            return this.inpaidEcheance.montant_restant_du;
        }
    }

    getEcheanceId(){
        if(this?.inpaidInvoice && this?.inpaidEcheance){
            return this.inpaidInvoice.date_limite_de_paiement < this.inpaidEcheance.date_decheance ? this.inpaidEcheance.reference : this.inpaidInvoice.ref_facture ;
        }else if(this?.inpaidInvoice){
            return this.inpaidInvoice.ref_facture ;
        }else if(this?.inpaidEcheance){
            return this.inpaidEcheance.reference;
        }
    }

    listFctEchToShow(data, enrg){
        if(data){
            let listResult = [];
            if(data.key == 'FactureAgilab'){
                data.output.factures.forEach((elem,index) => {
                    if(elem.statut == "1" || elem.statut == "2"){
                        var dateObj = new Date(elem.date_limite_de_paiement);
                        var month = dateObj.getUTCMonth() + 1; //months from 1-12
                        var day = dateObj.getUTCDate();
                        var year = dateObj.getUTCFullYear();
                        var newdate = year + "-" + month + "-" + day;
                        listResult.push({
                            typeDoc : 'Facture',
                            type : 'Facture',
                            energie : elem.energie,
                            ref : elem.ref_facture,
                            montant : elem.montant_restant_du,
                            dateExigible : newdate
                        })
                    }
                    
                });
             }
            return listResult;
            
        }
    }

    async listEcheanceToShow(data, enrg){
        if(data){
            let listResult;
                    let keys = Object.keys(data.output);
                    let echeances = []
                    for (let key of keys) {
                        echeances.push(data.output[key]);
                    }
                    const echeancesSoldee = echeances.filter(ech => ech.soldee_le?.includes('Total') || ech.soldee_le?.includes('Partiel'));
                     if(echeancesSoldee){
                        listResult = [];
                        echeancesSoldee.forEach((elem,index) => {
                                var dateObj = new Date(elem.date_decheance);
                                var month = dateObj.getUTCMonth() + 1; //months from 1-12
                                var day = dateObj.getUTCDate();
                                var year = dateObj.getUTCFullYear();
                                var newdate = year + "-" + month + "-" + day;
                                listResult.push({
                                    typeDoc : 'Echéance',
                                    type : 'Echéance',
                                    energie : enrg,
                                    ref : elem.reference,
                                    montant : elem.montant_restant_du,
                                    dateExigible : newdate
                                })
                                
                        });
                    }
                    return listResult;
        }
            
            
    }

    async listEchPlaToShow(data){
        if(data){
            let listResult = [];
            data.forEach((elem,index) => {
                let newdate = '';
                if(elem.date_decheance != null){
                    var dateObj = new Date(elem.date_decheance);
                    var month = dateObj.getUTCMonth() + 1; //months from 1-12
                    var day = dateObj.getUTCDate();
                    var year = dateObj.getUTCFullYear();
                    newdate = year + "-" + month + "-" + day;
                }
                    
                listResult.push({
                    typeDoc : 'Echéance Plan d’apurement',
                    type : 'Echéance',
                    energie : '',
                    ref : elem.ref_echeances,
                    montant : elem.montant_restant_du,
                    dateExigible : newdate
                })
                    
            });
            return listResult;
        }
            
    }
    

    async sortListFctEch(listFctEch) {
        return new Promise(async (resolve, reject) => {
            var isShow;
            if(listFctEch.length > 1){
                this.listFctEch = listFctEch.sort(function(a, b) {
                    return new Date(a.dateExigible) - new Date(b.dateExigible);
                })
                isShow = true;
                this.showListPayementComponent = true;
                this.payementAmountToDisplay = (this.montantToDisplay - parseFloat(this.listFctEch[0].montant)).toFixed(2);
                this.montantToPaye = parseFloat(this.listFctEch[0].montant);
                this.echeancIdToPaye = this.listFctEch[0].ref;
            }
            else{
                isShow = false;
                this.showListPayementComponent = true;
                this.montantToPaye = parseFloat(this.listFctEch[0].montant);
                this.echeancIdToPaye = this.listFctEch[0].ref;
            }
            resolve(isShow);
        })
    }

}