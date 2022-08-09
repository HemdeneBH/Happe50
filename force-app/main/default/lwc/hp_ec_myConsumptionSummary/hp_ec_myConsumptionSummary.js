import { LightningElement, api, wire, track } from 'lwc';
import { MessageContext } from 'lightning/messageService';
import { NavigationMixin } from "lightning/navigation";

import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getConsoGaz from '@salesforce/apex/HP_EC_LoadCustomerData.getConsoGaz';
import getConsoElec from '@salesforce/apex/HP_EC_LoadCustomerData.getConsoElec';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';

import getInfoContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getInfoContractData';
import getGrilleTarifaire from '@salesforce/apex/HP_EC_LoadCustomerData.getGrilleTarifaire';
import isCompteurCommunicantElec from '@salesforce/apex/HP_EC_LoadCustomerData.isCompteurCommunicantElec';
import isCompteurCommunicantGaz from '@salesforce/apex/HP_EC_LoadCustomerData.isCompteurCommunicantGaz';

import { publishMC, subscribeMC, unsubscribeMC } from 'c/hp_ec_utl_lightningMessageManager';

export default class Hp_ec_myConsumption extends NavigationMixin(LightningElement) {

    @wire(MessageContext) messageContext;

    @api titreFirstTab;

    @api textPasDeConsommations;
    @api lienSpecifique;
    @api libelleDuLien;
    @track showTextPasDeConsommations = false;

    @track idPortefeuilleContrat;
    @track contractInfo;

    @track idClient;
    @track contractElec;
    @track contractGaz;

    @track currentPdl;
    @track currentPce;
    
    @track isCommunicantGaz;
    @track isCommunicantElec;

    @track gasConsumptions = [];
    @track elecConsumptions = [];

    // Set to false to see estimated values
    communicatingMeter = true;

    showValue = true;
    showPrice = false;
    showDetails = false;
    displayDetails = false;

    showGas = true;
    showElec = false;

    @track consumptionTabClass = 'consumption-tab active';
    @track releveTabClass = 'consumption-tab';

    date = new Date();
    endDate = new Date();                                                           // Today
    startDate = new Date(new Date().setFullYear(new Date().getFullYear() - 1));     // Last year, same date

    alertTreshold = 370;

    typeOptions = [
        {
            value: 'gas',
            label: "Gaz",
            checked: this.showGas
        },
        {
            value: 'elec',
            label: "Élec",
            checked: this.showElec
        }
    ];
    
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
    }

    initializeComponantProperties() {
        this.showTextPasDeConsommations = false;
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
            // return;
            console.log('HP_EC_myConsumption || this.contractGaz.id : ' + this.contractGaz.id);
            // Step 1 : Get numéro PCE
            const INFO_CONTRACT_RESULT = await this.getInfoContractData(this.contractGaz.id.toString());
            const PARSED_INFO_CONTRACT_RESULT = JSON.parse(INFO_CONTRACT_RESULT);
            this.currentPce = PARSED_INFO_CONTRACT_RESULT.output.pdl;
            console.log('HP_EC_myConsumption || this.currentPce :' + this.currentPce);

            // Step 2 : Get typeComptage, prix htt, prix ttc
            const dateDebutValiditeUs = new Date(this.contractGaz.dateDebutValidite);
            const dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
            const grilleTarifaireResult = await this.getGrilleTarifaire(this.contractGaz.id.toString(), dateDebutValiditeFr);
            const grilleTarifaireResult_parsed = JSON.parse(grilleTarifaireResult);
            console.log('HP_EC_myConsumption || grilleTarifaireResult Gaz: '+grilleTarifaireResult);
            if (grilleTarifaireResult_parsed?.status == 'SUCCESS') {
                grilleTarifaireResult_parsed.consos.forEach(conso => {
                    if(conso.typeConso == 'index conso gaz') {
                        this.GAZ_consoTtc = conso.consoTtc;
                        this.GAZ_consoHtt = conso.consoHt;
                    }
                });
                this.GAZ_aboTtc = grilleTarifaireResult_parsed.aboTtc;
                this.GAZ_aboHtt = grilleTarifaireResult_parsed.aboHt;
            }

            // Step 3 : Get consommations gaz
            if (this.currentPce) {
                console.log('this.idClient : '+this.idClient);
                console.log('this.currentPce : '+this.currentPce);
                const CONSO_GAZ_RESULT = await this.getConsoGaz(this.idClient, this.currentPce);
                const PARSED_CONSO_GAZ_RESULT = JSON.parse(CONSO_GAZ_RESULT);
                console.log('HP_EC_myConsumption || CONSO_GAZ :', JSON.stringify(PARSED_CONSO_GAZ_RESULT));
                if (PARSED_CONSO_GAZ_RESULT.status == "SUCCESS") {
                    console.log('HP_EC_myConsumption || PARSED_CONSO_GAZ_RESULT status success');
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
                    console.log('LATEST_INDEX_GAZ : ' + LATEST_INDEX_GAZ);

                    const IS_COMPTEUR_COMMUNICANT_GAZ = await this.isCompteurCommunicantGaz(this.currentPce, LATEST_INDEX_GAZ);
                    this.isCommunicantGaz = JSON.parse(IS_COMPTEUR_COMMUNICANT_GAZ)?.data;
                    console.log('isCommunicantGaz : '+this.isCommunicantGaz);
                    // END OF: check if compteur gaz communicant  //

                    this.gasConsumptions = this.generateGazConsumptionsPerConso();
                    this.gasConsumptions.splice(12,this.gasConsumptions.length - 12);
                    console.log('HP_EC_myConsumption || this.gasConsumptions : '+JSON.stringify(this.gasConsumptions));
                }                
            }
            // Final step: Après organization Data, afficher le gaz et masquer l'elec
            this.showGas = true;
            this.showElec = false;
        }

        if(this.contractElec) {
            console.log('HP_EC_myConsumption || this.contractElec.id : ' + this.contractElec.id);
            // Step 1 : Get numéro PDL
            const INFO_CONTRACT_RESULT = await this.getInfoContractData(this.contractElec.id.toString());
            const PARSED_INFO_CONTRACT_RESULT = JSON.parse(INFO_CONTRACT_RESULT);
            this.currentPdl = PARSED_INFO_CONTRACT_RESULT.output.pdl;
            console.log('HP_EC_myConsumption || this.currentPdl :' + this.currentPdl);

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
            }

            // Step 3 : Get consommations elec
            if (this.currentPdl) {
                console.log('this.idClient : '+this.idClient)
                console.log('this.currentPdl : '+this.currentPdl)
                const CONSO_ELEC_RESULT = await this.getConsoElec(this.idClient, this.currentPdl);
                const PARSED_CONSO_ELEC_RESULT = JSON.parse(CONSO_ELEC_RESULT);
                console.log('HP_EC_myConsumption || elecData:', CONSO_ELEC_RESULT);
                if(PARSED_CONSO_ELEC_RESULT.status == "SUCCESS") {
                    this.consoElecResult = PARSED_CONSO_ELEC_RESULT.output;
                    this.elecConsumptions = this.generateElecConsumptionsPerConso();
                    console.log('HP_EC_myConsumption || this.elecConsumptions :' + JSON.stringify(this.elecConsumptions));
                }
    
                console.log('HP_EC_myConsumption || this.elecConsumptions :' + JSON.stringify(this.elecConsumptions));
                // Final step: Après organization Data, afficher le gaz et masquer l'elec 
                if(this.gasConsumptions?.length == 0) { 
                    this.handleType({detail: 'elec'});
                }
            }

        }

        (this.gasConsumptions?.length == 0 && this.elecConsumptions?.length == 0) ? this.showTextPasDeConsommations = true: this.showTextPasDeConsommations = false;
    }

    switchToConsumptionTab() {
        this.consumptionTabClass = 'consumption-tab active';
        this.releveTabClass = 'consumption-tab';
        
    }

    switchToReleveTab() {
        this.releveTabClass = 'consumption-tab active';
        this.consumptionTabClass = 'consumption-tab';
    }

    handleType(event) {
        this.typeOptions = updateOptionsArray(this.typeOptions, event.detail);
        if (event.detail == 'elec') {
            this.showGas = false;
            this.showElec = true;
        }
        if (event.detail == 'gas') {
            this.showGas = true;
            this.showElec = false;
        }
    }

    handleNavigationToLienSpecifique() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: this.lienSpecifique
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    generateGazConsumptionsPerConso() {
        if(!this.consoGazResult)
            return null;

        var gasConsumptionsArray = [];
        this.consoGazResult.forEach(item => {
            const date = getDate(item.date_releve);                      // Convert date string to Date
            const meter = (item.type_comptage !== 'Classique');          // Convert type string to Boolean
            const conso_value_kwh = item.conso_cadran;                   // Convert gas volume to kwh(item.volume_brut_gaz * item.kpcs)
            const active = (date.getYear() === new Date().getYear());    // Active = true if current year
            
            const cons = {
                startDate: getDate(item.date_debut),
                endDate: getDate(item.date_fin),
                date: date,
                value: conso_value_kwh,
                units : 'kWh',
                communicatingMeter: meter,
                active: active
            };

            if (cons.startDate <= this.endDate && cons.endDate >= this.startDate && gasConsumptionsArray.length < 12) {
                gasConsumptionsArray.push(cons);
            }    
        });

        gasConsumptionsArray.sort((a, b) => a.date - b.date); /* Date Sorting */
        return gasConsumptionsArray;
    }

    generateElecConsumptionsPerConso() {
        if(!this.consoElecResult)
            return null;

        var elecConsumptionsArray = [];
        this.consoElecResult.forEach(item => {
            const date = getDate(item.date_releve);                      // Convert date string to Date
            const meter = (item.type_compteur !== 'Classique');          // Convert type string to Boolean
            const conso_value_kwh = item.conso_cadran;                   // Get value
            const active = (date.getYear() === new Date().getYear());    // Active = true if current year

            const cons = {
                startDate: getDate(item.date_debut),
                endDate: getDate(item.date_fin),
                date: date,
                value: conso_value_kwh,
                units: 'kWh',
                communicatingMeter: meter,
                active: active
            };

            if (cons.startDate <= this.endDate && cons.endDate >= this.startDate) {
                elecConsumptionsArray.push(cons);
            }
        });

        elecConsumptionsArray.sort((a, b) => a.date - b.date); /* Date Sorting */
        return elecConsumptionsArray;
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
    const year = parseInt(parts[2]); // Convert 2-digit year string to full year int
    return new Date(year, month, day);
}

function formatDateToString(date) {
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    return ('0' + day).slice(-2) + '.' + ('0' + month).slice(-2) + '.' + year.toString().slice(-2);
}