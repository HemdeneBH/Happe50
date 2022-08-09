/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 07-18-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { LightningElement, api, wire, track } from 'lwc';
import { MessageContext } from 'lightning/messageService';

import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getConsoGaz from '@salesforce/apex/HP_EC_LoadCustomerData.getConsoGaz';
import getConsoElec from '@salesforce/apex/HP_EC_LoadCustomerData.getConsoElec';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';

import getInfoContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getInfoContractData';
import getGrilleTarifaire from '@salesforce/apex/HP_EC_LoadCustomerData.getGrilleTarifaire';
import isCompteurCommunicantElec from '@salesforce/apex/HP_EC_LoadCustomerData.isCompteurCommunicantElec';
import isCompteurCommunicantGaz from '@salesforce/apex/HP_EC_LoadCustomerData.isCompteurCommunicantGaz';

import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';

export default class Hp_ec_myConsumption extends LightningElement {

    @api textPasDeConsommations;

    @track idClient;
    @track contractElec;
    @track contractGaz;
    @track isCommunicantGaz;
    @track isCommunicantElec;

    // Set to false to see estimated values
    @track subscription = null;
    @track communicatingMeter = true;

    @track showValue = false;
    @track showPrice = true;
    @track showDetails = true
    @track showGas = true;
    @track showElec = false;

    @track showConsoDates = false;
    @track showYear = false;

    @track currentPdl;
    @track currentPce;
    @track idPortefeuilleContrat = null;
    contractInfo;

    @track gasConsumptions = [];
    @track elecConsumptions = [];

    @track showTextPasDeConsommations_Gaz = false;
    @track showTextPasDeConsommations_Elec = false;
    @track isProcessFinished = false;

    gasData;
    elecData;

    date = new Date();
    endDate = new Date();                                                       // Today
    startDate = new Date(new Date().setFullYear(new Date().getFullYear() - 1));   // Last year, same date

    get showTextPasDeConsommations() {
        if((this.showGas && this.showTextPasDeConsommations_Gaz && this.isProcessFinished) || (this.showElec && this.showTextPasDeConsommations_Elec && this.isProcessFinished))
            return true;
        return false;
    }

    get startDateLocaleString () {
        return this.startDate.toLocaleDateString();
    }

    get startDateISOString () {
        return this.startDate.toISOString().split("T")[0];
    }

    get endDateLocaleString () {
        return this.endDate.toLocaleDateString();
    }

    get endDateISOString () {
        return this.endDate.toISOString().split("T")[0];
    }

    get maxGasValue () {
        return Math.max(...this.gasConsumptions.map(cons => cons.value), 0) * 1.1;
    }

    get maxGasPrice() {
        return Math.max(...this.gasConsumptions.map(cons => cons.priceValue), 0) * 1.1;
    }

    get maxElecValue () {
        return Math.max(...this.elecConsumptions.map(cons => cons.value), 0) * 1.1;
    }

    get maxElecPrice() {
        return Math.max(...this.elecConsumptions.map(cons => cons.priceValue), 0) * 1.1;
    }

    get displayDetails () {
        return this.communicatingMeter && this.showPrice && this.showDetails;
    }

    get displayDetailSwitchButton() {
        return this.communicatingMeter && this.showPrice;
    }

    // OPTIONS ARRAYS
    showDetailsOptions = [
        {
            value: 'simple',
            label: "Simple",
            checked: !this.showDetails
        },
        {
            value: 'detailed',
            label: "Détaillée",
            checked: this.showDetails
        }
    ];

    showValuePriceOptions = [
        {
            value: 'price',
            label: "Euros<sup>TTC</sup>",
            checked: this.showPrice
        },
        {
            value: 'value',
            label: "kWH",
            checked: this.showValue
        }
    ];

    timeOptions = [
        {
            value: 'conso',
            label: "Conso",
            checked: true
        },
        {
            value: 'month',
            label: "Mois",
            checked: false
        },
        {
            value: 'year',
            label: "Année",
            checked: false
        }
    ];

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

    connectedCallback() {
        this.handleSubscription();
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.getCurrentData();
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this, this.messageContext, this.handleLightningMessage);
        }
    } 

    handleLightningMessage(self, subscription, message) {
        console.log('HP EC myConsumption || Message received:', message);
        if (message.messageType == 'SelectedPortfolio') {
            self.idPortefeuilleContrat = message.messageData.message;
            self.getCurrentData();
        }
        if (message.messageType == 'SelectedEnergy') {
            if (message.messageData && message.messageData.message == 'Electricité') {
                self.currentEnergy = message.messageData.message;
                self.showGas = false;
                self.showElec = true;
            }
            if (message.messageData && message.messageData.message == 'Gaz Naturel') {
                self.currentEnergy = message.messageData.message;
                self.showGas = true;
                self.showElec = false;
            }
        }
    }

    initializeComponantProperties() {
        this.showTextPasDeConsommations_Gaz = false;
        this.showTextPasDeConsommations_Elec = false;
        
        this.gasConsumptions = [];
        this.elecConsumptions = [];

        this.currentPce = null;
        this.currentPdl = null;
        this.contractElec = null;
        this.contractGaz = null;
        this.typeComptage = null;
        this.isCommunicantGaz = null;
        this.isCommunicantElec = null;

        this.GAZ_consoTtc = null;
        this.GAZ_consoHtt = null;
        this.ELEC_consoTtc = null;
        this.ELEC_consoHtt = null;
        this.ELEC_HC_consoTtc = null;
        this.ELEC_HC_consoHtt = null;
        this.ELEC_HP_consoTtc = null;
        this.ELEC_HP_consoHtt = null;

        this.GAZ_aboTtc = null;
        this.GAZ_aboHtt = null;
        this.ELEC_aboTtc = null;
        this.ELEC_aboHtt = null;
    }

    async getCurrentData() {
        this.initializeComponantProperties();
        if (!this.contractInfo) {
            const contractJson = await this.getContractdata();
            this.contractInfo = JSON.parse(contractJson);
        }
        // console.log('HP_EC_myConsumption || this.contractInfo :' + this.contractInfo);

        if(this.contractInfo) {
            this.contractInfo._data.forEach(c => {
                if (c.idPortefeuilleContrat == this.idPortefeuilleContrat && (c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' ||
                    c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007')) {
                        c.energie == 'Electricité' ? this.contractElec = c : this.contractGaz = c;
                }
            });
        }

        if(this.contractGaz) {
            // console.log('HP_EC_myConsumption || this.contractGaz.id : ' + this.contractGaz.id);
            // Step 1 : Get numéro PCE
            const INFO_CONTRACT_RESULT = await this.getInfoContractData(this.contractGaz.id.toString());
            const PARSED_INFO_CONTRACT_RESULT = JSON.parse(INFO_CONTRACT_RESULT);
            this.currentPce = PARSED_INFO_CONTRACT_RESULT.output.pdl;
            // console.log('HP_EC_myConsumption || this.currentPce :' + this.currentPce);

            // Step 2 : Get typeComptage, prix htt, prix ttc
            const dateDebutValiditeUs = new Date(this.contractGaz.dateDebutValidite);
            const dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
            const grilleTarifaireResult = await this.getGrilleTarifaire(this.contractGaz.id.toString(), dateDebutValiditeFr);
            const grilleTarifaireResult_parsed = JSON.parse(grilleTarifaireResult);
            // console.log('HP_EC_myConsumption || grilleTarifaireResult Gaz: '+grilleTarifaireResult);
            if (grilleTarifaireResult_parsed?.status == 'SUCCESS') {
                grilleTarifaireResult_parsed.consos.forEach(conso => {
                    if(conso.typeConso == 'index conso gaz') {
                        this.GAZ_consoTtc = conso.consoTtc;
                        this.GAZ_consoHtt = conso.consoHt;
                    }
                });
                this.GAZ_aboTtc = grilleTarifaireResult_parsed.aboTtc;
                this.GAZ_aboHtt = grilleTarifaireResult_parsed.aboHt;

                // console.log('GAZ_consoTtc : '+this.GAZ_consoTtc);
                // console.log('GAZ_consoHtt : '+this.GAZ_consoHtt);
                // console.log('GAZ_aboTtc : '+this.GAZ_aboTtc);
                // console.log('GAZ_aboHtt : '+this.GAZ_aboHtt);
            }

            // Step 3 : Get consommations gaz
            if (this.currentPce) {
                const CONSO_GAZ_RESULT = await this.getConsoGaz(this.idClient, this.currentPce);
                const PARSED_CONSO_GAZ_RESULT = JSON.parse(CONSO_GAZ_RESULT);
                // console.log('HP_EC_myConsumption || CONSO_GAZ :', JSON.stringify(PARSED_CONSO_GAZ_RESULT.output));
                if (PARSED_CONSO_GAZ_RESULT.status == "SUCCESS") {
                    // console.log('HP_EC_myConsumption || PARSED_CONSO_GAZ_RESULT status success');
                    this.consoGazResult = PARSED_CONSO_GAZ_RESULT.output;

                    // START OF: check if compteur gaz communicant //
                    let latest_date_fin = new Date(1970, 1, 1);
                    let latest_index_fin = 0;
                    PARSED_CONSO_GAZ_RESULT.output.forEach(elem => {
                        const DATE_RELEVE = getDate(elem.date_releve);
                        if ((elem.id_facture != null) && (DATE_RELEVE > latest_date_fin)) {
                            latest_date_fin = DATE_RELEVE;
                            latest_index_fin = elem.index_fin;
                        }
                    });
                    const LATEST_INDEX_GAZ = latest_index_fin;
                    // console.log('LATEST_INDEX_GAZ : ' + LATEST_INDEX_GAZ);

                    const IS_COMPTEUR_COMMUNICANT_GAZ = await this.isCompteurCommunicantGaz(this.currentPce, LATEST_INDEX_GAZ);
                    this.isCommunicantGaz = JSON.parse(IS_COMPTEUR_COMMUNICANT_GAZ)?.data;
                    // console.log('isCommunicantGaz : '+this.isCommunicantGaz);
                    // END OF: check if compteur gaz communicant  //

                    this.gasConsumptions = this.generateGazConsumptionsPerConso();
                    this.gasConsumptions?.splice(12,this.gasConsumptions.length - 12);
                }                
            }
            console.log('HP_EC_myConsumption || this.gasConsumptions : '+JSON.stringify(this.gasConsumptions));
            
            // Final step: Après organization Data, afficher le gaz et masquer l'elec
            // this.handleType({detail: 'gas'});
        }
        
        if(this.contractElec) {
            console.log('HP_EC_myConsumption || this.contractElec.id : ' + this.contractElec.id);
            // Step 1 : Get numéro PDL
            const INFO_CONTRACT_RESULT = await this.getInfoContractData(this.contractElec.id.toString());
            const PARSED_INFO_CONTRACT_RESULT = JSON.parse(INFO_CONTRACT_RESULT);
            this.currentPdl = PARSED_INFO_CONTRACT_RESULT.output.pdl;
            // console.log('HP_EC_myConsumption || this.currentPdl :' + this.currentPdl);

            // Step 2 : Get typeComptage, prix htt, prix ttc
            const dateDebutValiditeUs = new Date(this.contractElec.dateDebutValidite);
            const dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
            const grilleTarifaireResult = await this.getGrilleTarifaire(this.contractElec.id.toString(), dateDebutValiditeFr);
            const grilleTarifaireResult_parsed = JSON.parse(grilleTarifaireResult);
            // console.log('HP_EC_myConsumption || grilleTarifaireResult elec: '+grilleTarifaireResult);
            if (grilleTarifaireResult_parsed?.status == 'SUCCESS') {
                this.typeComptage = grilleTarifaireResult_parsed.elecTypeComptage;
                if(this.typeComptage == 'Comptage simple') {
                    this.ELEC_consoTtc = grilleTarifaireResult_parsed.consos[0].consoTtc;
                    this.ELEC_consoHtt = grilleTarifaireResult_parsed.consos[0].consoHt;
                } else if(this.typeComptage == 'Comptage HPHC') {
                    grilleTarifaireResult_parsed.consos.forEach(conso => {
                        if(conso.typeConso == 'HC') {
                            this.ELEC_HC_consoTtc = conso.consoTtc;
                            this.ELEC_HC_consoHtt = conso.consoHt;
                        }
                        if(conso.typeConso == 'HP') {
                            this.ELEC_HP_consoTtc = conso.consoTtc;
                            this.ELEC_HP_consoHtt = conso.consoHt;
                        }
                    });
                }
                this.ELEC_aboTtc = grilleTarifaireResult_parsed.aboTtc;
                this.ELEC_aboHtt = grilleTarifaireResult_parsed.aboHt;

                console.log('ELEC_consoTtc : '+this.ELEC_consoTtc);
                console.log('ELEC_consoHtt : '+this.ELEC_consoHtt);

                console.log('ELEC_aboTtc : '+this.ELEC_aboTtc);
                console.log('ELEC_aboHtt : '+this.ELEC_aboHtt);
            }

            // Step 3 : Get consommations elec
            if (this.currentPdl) {
                const CONSO_ELEC_RESULT = await this.getConsoElec(this.idClient, this.currentPdl);
                const PARSED_CONSO_ELEC_RESULT = JSON.parse(CONSO_ELEC_RESULT);
                console.log('HP_EC_myConsumption || elecData:', CONSO_ELEC_RESULT);
                if(PARSED_CONSO_ELEC_RESULT.status == "SUCCESS") {
                    this.consoElecResult = PARSED_CONSO_ELEC_RESULT.output;
                    this.elecConsumptions = this.generateElecConsumptionsPerConso();
                }
            }
            console.log('HP_EC_myConsumption || this.elecConsumptions :' + JSON.stringify(this.elecConsumptions));
        }

        this.gasConsumptions?.length == 0 ? this.showTextPasDeConsommations_Gaz = true: this.showTextPasDeConsommations_Gaz = false;
        this.elecConsumptions?.length == 0 ? this.showTextPasDeConsommations_Elec = true: this.showTextPasDeConsommations_Elec = false;

        this.isProcessFinished = true;
    }

    handleShowValuePrice (event) {
        if (event.detail == 'price') {
            this.showPrice = true;
            this.showValue = false;
        } else {
            this.showValue = true;
            this.showPrice = false;
        }

        this.showValuePriceOptions = updateOptionsArray(this.showValuePriceOptions, event.detail);
    }

    handleShowDetails (event) {
        if (event.detail == 'detailed') {
            this.showDetails = true;
        } else {
            this.showDetails = false;
        }

        this.showDetailsOptions = updateOptionsArray(this.showDetailsOptions, event.detail);
    }

    handleTime (event) {
        console.log(event.detail);

        switch (event.detail) {
            case 'conso':
                if(this.currentEnergy == 'Gaz Naturel') {
                    this.gasConsumptions = this.generateGazConsumptionsPerConso();
                    this.gasConsumptions?.splice(12,this.gasConsumptions.length - 12);
                }
                else if(this.currentEnergy == 'Electricité') {
                    this.elecConsumptions = this.generateElecConsumptionsPerConso();
                    this.elecConsumptions?.splice(12,this.elecConsumptions.length - 12);
                }
                break;
            case 'month':
                if(this.currentEnergy == 'Gaz Naturel') {
                    this.gasConsumptions = this.generateGazConsumptionsPerMonth();
                }
                else if(this.currentEnergy == 'Electricité') { 
                    console
                    this.elecConsumptions = this.generateElecConsumptionsPerMonth();
                }
                break;
            case 'year':
                if(this.currentEnergy == 'Gaz Naturel') {
                    this.gasConsumptions = this.generateGazConsumptionsPerYear();
                }
                else if(this.currentEnergy == 'Electricité') {
                    this.elecConsumptions = this.generateElecConsumptionsPerYear();
                }
                break;
        }
    }

    handleDateFocus (event) {
        if (event.target && event.target.showPicker) {
            event.target.showPicker();
        }
    }

    handleDateChange (event) {
        var date = new Date();
        if (event.target.value) {
            date = new Date(event.target.value);
        }

        if (event.target.dataset.type === 'start') {
            this.startDate = date;
            console.log('this.startDate : '+formatDateToString(this.startDate));
        } else if (event.target.dataset.type === 'end') {
            this.endDate = date;
            console.log('this.endDate : '+formatDateToString(this.endDate));
        }
    }

    async getContractdata(contractId) {
        return new Promise(async (resolve, reject) => {
            var result = await getContractData({})
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error getContractData : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
    }

    async getInfoContractData(contractId) {
        return new Promise(async (resolve, reject) => {
            var result = await getInfoContractData({ id_contrat_xdata : contractId})
            .then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getInfoContractData : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        })
    }

    async getGrilleTarifaire(contractId, dateContract) {
        return new Promise(async (resolve, reject) => {
            var result = await getGrilleTarifaire({ idContrat : contractId,  dateContrat :dateContract})
            .then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getGrilleTarifaire : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        })
    }

    async getConsoGaz(idClientXdata, pce) {
        return new Promise(async (resolve, reject) => {
            var result = await getConsoGaz({ idClientXdata: idClientXdata, pce: pce })
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error getConsoGaz : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
    }

    async getConsoElec(idClientXdata, pdl) {
        return new Promise(async (resolve, reject) => {
            var result = await getConsoElec({ idClientXdata: idClientXdata, pdl: pdl })
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error getConsoElec : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
    }

    async isCompteurCommunicantElec(pdl, index) {
        return new Promise(async (resolve, reject) => {
            var result = await isCompteurCommunicantElec({ pdl: pdl, index: index})
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error isCompteurCommunicantElec : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
    }

    async isCompteurCommunicantGaz(pce, index) {
        return new Promise(async (resolve, reject) => {
            var result = await isCompteurCommunicantGaz({ pce: pce, index: index})
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error isCompteurCommunicantGaz : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
    }

    /* Generate Gaz Consumptions Per Conso */
    generateGazConsumptionsPerConso() {
        if(!this.consoGazResult)
            return null;

        var gasConsumptionsArray = [];
        this.consoGazResult.forEach(item => {
            const DATE_RELEVE   = getDate(item.date_releve);                            // Convert date string to Date
            const START_DATE    = getDate(item.date_debut);
            const END_DATE      = getDate(item.date_fin);
            const METER         = (item.type_comptage !== 'Classique');                 // Convert type string to Boolean
            const CONSO_KWH     = item.conso_cadran;                                    // Convert gas volume to kwh(item.volume_brut_gaz * item.kpcs)
            const ACTIVE        = (DATE_RELEVE.getYear() === new Date().getYear());     // Active = true if current year

            const SUBSCRIPTION      = this.GAZ_aboTtc / 12;                  // abonnement
            const CONSOMMAITON_TTC  = CONSO_KWH * this.GAZ_consoTtc;                    // consommation
            const COMPTAGE_TAX      =  CONSO_KWH * (this.GAZ_consoTtc - this.GAZ_consoHtt);  //comptage et taxe

            const PRICE = (CONSO_KWH * this.GAZ_consoTtc) + (SUBSCRIPTION * getMonthDifference(START_DATE, END_DATE));
            const PRICE_UNITS = 'EUR';
            
            // console.log('(CONSO_KWH * this.GAZ_consoTtc) : '+(CONSO_KWH * this.GAZ_consoTtc));
            // console.log('COMPTAGE_TAX : '+COMPTAGE_TAX);
            // console.log('(this.GAZ_consoTtc - this.GAZ_consoHtt) : '+(this.GAZ_consoTtc - this.GAZ_consoHtt));
            // console.log('CONSO_KWH : '+CONSO_KWH);
            // console.log('CONSOMMAITON_TTC : '+CONSOMMAITON_TTC);
            // console.log('getMonthDifference(START_DATE, END_DATE) : '+ getMonthDifference(START_DATE, END_DATE));
    
            const cons = {
                startDate: START_DATE,
                endDate: END_DATE,
                date: DATE_RELEVE,
                value: CONSO_KWH,
                units : 'kWh',
                communicatingMeter: METER,
                active: ACTIVE,
                conso: CONSOMMAITON_TTC.toFixed(2),
                priceValue: PRICE.toFixed(2),
                priceUnits: PRICE_UNITS,
                subscription: SUBSCRIPTION.toFixed(2),
                tax: COMPTAGE_TAX.toFixed(2)
            };

            if (cons.startDate <= this.endDate && cons.endDate >= this.startDate && gasConsumptionsArray.length < 12) {
                gasConsumptionsArray.push(cons);
            }
            
            gasConsumptionsArray.sort((a, b) => a.date - b.date); /* Date Sorting */
        });

        return gasConsumptionsArray;
    }

    /* Generate Gaz Consumptions Per Month */
    generateGazConsumptionsPerMonth() {
        var gasConsumptionsPerMonths = [];
        var last12Months = [];
        for(let i=0;i<12;i++) {
            var date = new Date(), y = date.getFullYear(), m = date.getMonth()-i;
            last12Months.push(new Date(y, m, 1));
        }

        last12Months.forEach(m => {
            var conso_value_kwh = 0;
            this.consoGazResult.forEach(item => {
                const ITEM_DATE = new Date(getDate(item.date_releve).getFullYear(),getDate(item.date_releve).getMonth(), 1);
                if((ITEM_DATE.getFullYear() == m.getFullYear()) && (ITEM_DATE.getMonth() == m.getMonth())) {
                    conso_value_kwh = conso_value_kwh + item.conso_cadran;
                }
            });

            const ACTIVE = ((m.getFullYear() == new Date().getFullYear()) && (m.getMonth() == new Date().getMonth())); 
            const SUBSCRIPTION      = conso_value_kwh == 0 ? 0 : this.GAZ_aboTtc / 12;                                         // abonnement
            const CONSOMMAITON_TTC  = conso_value_kwh * this.GAZ_consoTtc;                          // consommation
            const COMPTAGE_TAX      =  conso_value_kwh * (this.GAZ_consoTtc - this.GAZ_consoHtt);   //comptage et taxe

            const PRICE = conso_value_kwh == 0 ? 0 : (conso_value_kwh * this.GAZ_consoTtc) + (SUBSCRIPTION * 1);
            const PRICE_UNITS = 'EUR';

            // console.log('month : '+formatDateToString(m));
            // console.log('conso_value_kwh : '+conso_value_kwh);
            // console.log('COMPTAGE_TAX : '+COMPTAGE_TAX);
            // console.log('SUBSCRIPTION : '+SUBSCRIPTION);

            const cons = {
                month: m,
                value: conso_value_kwh,
                units : 'kWh',
                active: ACTIVE,
                conso: CONSOMMAITON_TTC.toFixed(2),
                priceValue: PRICE.toFixed(2),
                priceUnits: PRICE_UNITS,
                subscription: SUBSCRIPTION.toFixed(2),
                tax: COMPTAGE_TAX.toFixed(2)
            };

            if (cons.month <= this.endDate && cons.month >= this.startDate) {
                gasConsumptionsPerMonths.push(cons);
            }
            // gasConsumptionsPerMonths.push(cons);
            gasConsumptionsPerMonths.sort((a, b) => a.month - b.month);  /* Date Sorting */
        });
        
        console.log('gasConsumptionsPerMonths : '+JSON.stringify(gasConsumptionsPerMonths));
        return gasConsumptionsPerMonths;
    }

    /* Generate Gaz Consumptions Per Year */
    generateGazConsumptionsPerYear() {
        if(!this.consoGazResult)
            return null;

        const YEAR = this.endDate.getFullYear();
        var gasConsumptionsPerYear = [];

        for (let i = YEAR-11; i <= YEAR; i++) {
            var conso_value_kwh = 0;
            var months = [];
            this.consoGazResult.forEach(item => {
                const ITEM_YEAR = getDate(item.date_releve).getFullYear();
                const START_DATE    = getDate(item.date_debut);
                const END_DATE      = getDate(item.date_fin);
                if (ITEM_YEAR == i) {
                    conso_value_kwh = conso_value_kwh + item.conso_cadran;
                    getMonthsIndex(START_DATE, END_DATE).forEach(m => {
                        if(months.indexOf(m) === -1) {
                            months.push(m);
                        }
                    });
                }
            });
            // console.log('months in year '+i+' : '+months);
            console.log('months in year '+i+' : '+months.length);

            const ACTIVE = (i == YEAR); 
            const SUBSCRIPTION      = (this.GAZ_aboTtc / 12) * months.length;        // abonnement
            const CONSOMMAITON_TTC  = conso_value_kwh * this.GAZ_consoTtc;           // consommation
            const COMPTAGE_TAX      =  conso_value_kwh * (this.GAZ_consoTtc - this.GAZ_consoHtt);  //comptage et taxe

            const PRICE = (conso_value_kwh * this.GAZ_consoTtc) + SUBSCRIPTION;
            const PRICE_UNITS = 'EUR';

            const cons = {
                year: i,
                value: conso_value_kwh,
                units : 'kWh',
                active: ACTIVE,
                conso: CONSOMMAITON_TTC.toFixed(2),
                priceValue: PRICE.toFixed(2),
                priceUnits: PRICE_UNITS,
                subscription: SUBSCRIPTION.toFixed(2),
                tax: COMPTAGE_TAX.toFixed(2)
            };
            if (cons.year <= this.endDate.getFullYear() && cons.year >= this.startDate.getFullYear()) { 
                gasConsumptionsPerYear.push(cons);
            }
        }
        
        console.log('gasConsumptionsPerYear : '+JSON.stringify(gasConsumptionsPerYear));
        return gasConsumptionsPerYear;
    }

    /* Generate Elec Consumptions Per Conso */
    generateElecConsumptionsPerConso() {
        if(!this.consoElecResult)
            return null;

        var elecConsumptionsArray = [];
        this.consoElecResult.forEach(item => {
            const DATE_RELEVE   = getDate(item.date_releve);
            const START_DATE    = getDate(item.date_debut);
            const END_DATE      = getDate(item.date_fin);
            const METER         = (item.type_comptage !== 'Classique');                 // Convert type string to Boolean
            const CONSO_KWH     = item.conso_cadran;                                    // Convert gas volume to kwh(item.volume_brut_gaz * item.kpcs)
            const ACTIVE        = (DATE_RELEVE.getYear() === new Date().getYear());     // Active = true if current year
            const PRICE_UNITS   = 'EUR';
            
            const SUBSCRIPTION  = this.ELEC_aboTtc / 12;                  // abonnement
            var CONSOMMAITON_TTC= 0;
            var COMPTAGE_TAX    = 0;
            var PRICE           = 0;

            // console.log('getMonthDifference('+formatDateToString(START_DATE)+', '+formatDateToString(END_DATE)+' : '+getMonthDifference(START_DATE, END_DATE));

            if(this.typeComptage == 'Comptage simple') {
                CONSOMMAITON_TTC = CONSO_KWH *  this.ELEC_consoTtc; 
                COMPTAGE_TAX = CONSO_KWH * (this.ELEC_consoTtc - this.ELEC_consoHtt);
                PRICE = (CONSO_KWH * this.ELEC_consoTtc) + (SUBSCRIPTION * getMonthDifference(START_DATE, END_DATE));
            } else if(this.typeComptage == 'Comptage HPHC') {
                if(item.rang_cadran == 1) {
                    CONSOMMAITON_TTC = CONSO_KWH *  this.ELEC_HC_consoTtc;
                    COMPTAGE_TAX = CONSO_KWH * (this.ELEC_HC_consoTtc - this.ELEC_HC_consoHtt);
                    PRICE = (CONSO_KWH * this.ELEC_HC_consoTtc) + (SUBSCRIPTION * getMonthDifference(START_DATE, END_DATE));
                } else if (item.rang_cadran == 2) {
                    CONSOMMAITON_TTC = CONSO_KWH *  this.ELEC_HP_consoTtc;
                    COMPTAGE_TAX = CONSO_KWH * (this.ELEC_HP_consoTtc - this.ELEC_HP_consoHtt);
                    PRICE = (CONSO_KWH * this.ELEC_HP_consoTtc) + (SUBSCRIPTION * getMonthDifference(START_DATE, END_DATE));
                }
            }

            const cons = {
                startDate: START_DATE,
                endDate: END_DATE,
                date: DATE_RELEVE,
                value: CONSO_KWH,
                units: 'kWh',
                communicatingMeter: METER,
                active: ACTIVE,
                conso: CONSOMMAITON_TTC.toFixed(2),
                priceValue: PRICE.toFixed(2),
                priceUnits: PRICE_UNITS,
                subscription: SUBSCRIPTION.toFixed(2),
                tax: COMPTAGE_TAX.toFixed(2)
            };

            if (cons.startDate <= this.endDate && cons.endDate >= this.startDate) {
                elecConsumptionsArray.push(cons);
            }
        });

        elecConsumptionsArray.sort((a, b) => a.date - b.date); /* Date Sorting */
        return elecConsumptionsArray;
    }

    /* Generate Elec Consumptions Per Month */
    generateElecConsumptionsPerMonth() {
        if(!this.consoElecResult)
            return null;

        var elecConsumptionsPerMonths = [];
        var last12Months = [];
        for(let i=0;i<12;i++) {
            var date = new Date(), y = date.getFullYear(), m = date.getMonth()-i;
            last12Months.push(new Date(y, m, 1));
        }

        last12Months.forEach(m => {
            const ACTIVE = ((m.getFullYear() == new Date().getFullYear()) && (m.getMonth() == new Date().getMonth()));
            const PRICE_UNITS   = 'EUR';
            
            const SUBSCRIPTION  = this.ELEC_aboTtc / 12;                  // abonnement
            var CONSO_KWH       = 0;
            var CONSOMMAITON_TTC= 0;
            var COMPTAGE_TAX    = 0;
            var PRICE           = 0;

            this.consoElecResult.forEach(item => {
                const ITEM_DATE = new Date(getDate(item.date_releve).getFullYear(),getDate(item.date_releve).getMonth(), 1);
                if((ITEM_DATE.getFullYear() == m.getFullYear()) && (ITEM_DATE.getMonth() == m.getMonth())) {
                    CONSO_KWH = CONSO_KWH + item.conso_cadran;

                    if(this.typeComptage == 'Comptage simple') {
                        CONSOMMAITON_TTC += item.conso_cadran *  this.ELEC_consoTtc; 
                        COMPTAGE_TAX += item.conso_cadran * (this.ELEC_consoTtc - this.ELEC_consoHtt);
                        PRICE += item.conso_cadran == 0 ? 0 :(item.conso_cadran * this.ELEC_consoTtc) + (SUBSCRIPTION * 1);
                    } else if(this.typeComptage == 'Comptage HPHC') {
                        if(item.rang_cadran == 1) {
                            CONSOMMAITON_TTC += item.conso_cadran *  this.ELEC_HC_consoTtc;
                            COMPTAGE_TAX += item.conso_cadran * (this.ELEC_HC_consoTtc - this.ELEC_HC_consoHtt);
                            PRICE += item.conso_cadran == 0 ? 0 :(item.conso_cadran * this.ELEC_HC_consoTtc) + (SUBSCRIPTION * 1);
                        } else if (item.rang_cadran == 2) {
                            CONSOMMAITON_TTC += item.conso_cadran *  this.ELEC_HP_consoTtc;
                            COMPTAGE_TAX += item.conso_cadran * (this.ELEC_HP_consoTtc - this.ELEC_HP_consoHtt);
                            PRICE += item.conso_cadran == 0 ? 0 :(item.conso_cadran * this.ELEC_HP_consoTtc) + (SUBSCRIPTION * 1);
                        }
                    }
                }
            });
        
            const cons = {
                month: m,
                value: CONSO_KWH,
                units : 'kWh',
                active: ACTIVE,
                conso: CONSOMMAITON_TTC,
                priceValue: PRICE.toFixed(2),
                priceUnits: PRICE_UNITS,
                subscription: SUBSCRIPTION.toFixed(2),
                tax: COMPTAGE_TAX.toFixed(2)
            };
            if (cons.month <= this.endDate && cons.month >= this.startDate) {
                elecConsumptionsPerMonths.push(cons);
            }
            elecConsumptionsPerMonths.sort((a, b) => a.month - b.month);  /* Date Sorting */
        });
        
        return elecConsumptionsPerMonths;
    }

    /* Generate Elec Consumptions Per Year */
    generateElecConsumptionsPerYear() {
        if(!this.consoElecResult)
            return null;

        const YEAR = this.endDate.getFullYear();
        var elecConsumptionsPerYear = [];
        for (let i = YEAR-11; i <= YEAR; i++) {

            var months = [];
            this.consoElecResult.forEach(item => {
                const ITEM_YEAR = getDate(item.date_releve).getFullYear();
                const START_DATE    = getDate(item.date_debut);
                const END_DATE      = getDate(item.date_fin);
                if (ITEM_YEAR == i) {
                    getMonthsIndex(START_DATE, END_DATE).forEach(m => {
                        if(months.indexOf(m) === -1) {
                            months.push(m);
                        }
                    });
                }
            });

            const ACTIVE = (i == YEAR); 
            const PRICE_UNITS   = 'EUR';
            const SUBSCRIPTION  = (this.ELEC_aboTtc / 12) * months.length;
            var CONSO_KWH       = 0;
            var CONSOMMAITON_TTC= 0;
            var COMPTAGE_TAX    = 0;
            var PRICE           = 0;

            this.consoElecResult.forEach(item => {
                const ITEM_YEAR = getDate(item.date_releve).getFullYear();
                if (ITEM_YEAR == i) {
                    CONSO_KWH = CONSO_KWH + item.conso_cadran;

                    if(this.typeComptage == 'Comptage simple') {
                        CONSOMMAITON_TTC += item.conso_cadran *  this.ELEC_consoTtc; 
                        COMPTAGE_TAX += item.conso_cadran * (this.ELEC_consoTtc - this.ELEC_consoHtt);
                        PRICE += item.conso_cadran == 0 ? 0 :(item.conso_cadran * this.ELEC_consoTtc) ;
                    } else if(this.typeComptage == 'Comptage HPHC') {
                        if(item.rang_cadran == 1) {
                            CONSOMMAITON_TTC += item.conso_cadran *  this.ELEC_HC_consoTtc;
                            COMPTAGE_TAX += item.conso_cadran * (this.ELEC_HC_consoTtc - this.ELEC_HC_consoHtt);
                            PRICE += item.conso_cadran == 0 ? 0 :(item.conso_cadran * this.ELEC_HC_consoTtc);
                        } else if (item.rang_cadran == 2) {
                            CONSOMMAITON_TTC += item.conso_cadran *  this.ELEC_HP_consoTtc;
                            COMPTAGE_TAX += item.conso_cadran * (this.ELEC_HP_consoTtc - this.ELEC_HP_consoHtt);
                            PRICE += item.conso_cadran == 0 ? 0 :(item.conso_cadran * this.ELEC_HP_consoTtc);
                        }
                    }
                }
            });

            PRICE = (PRICE == 0) ? 0 : PRICE + SUBSCRIPTION;

            const cons = {
                year: i,
                value: CONSO_KWH,
                units : 'kWh',
                active: ACTIVE,
                conso: CONSOMMAITON_TTC.toFixed(2),
                priceValue: PRICE.toFixed(2),
                priceUnits: PRICE_UNITS,
                subscription: SUBSCRIPTION.toFixed(2),
                tax: COMPTAGE_TAX.toFixed(2)
            };

            if (cons.year <= this.endDate.getFullYear() && cons.year >= this.startDate.getFullYear()) {
                elecConsumptionsPerYear.push(cons);  
            }
        }

        return elecConsumptionsPerYear;
    }
}

function updateOptionsArray(array, value) {
    return array.map(option => {
        if (option.value == value) {
            return {...option, checked: true};
        }
        return {...option, checked: false};
    });
}

function getDate(string) {
    const parts = string.split('/');        // Split date string to day, month, year
    const day = parseInt(parts[0]);         // Convert date string to int
    const month = parseInt(parts[1]) - 1;   // Convert month string to month index
    const year = parseInt(parts[2]);        // Convert 2-digit year string to full year int
    return new Date(year, month, day);
}

function getMonthDifference(startDate, endDate) {
    const diffMonths = (endDate.getMonth() - startDate.getMonth() + 12 * (endDate.getFullYear() - startDate.getFullYear()));
    
    // When statDate & endDate are in the same month
    if(diffMonths == 0)
        return 1;

    return diffMonths;
}

function getMonthsIndex(startDate, endDate) {
    var months = [];
    if(startDate < endDate) {
        var date = startDate;
        while (date < endDate) {
            months.push(date.getMonth()+1);
            date = new Date(date.setMonth(date.getMonth()+1));
        }
    }
    return months;
}

function formatDateToString(date) {
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    return ('0' + day).slice(-2) + '.' + ('0' + month).slice(-2) + '.' + year.toString().slice(-2);
}