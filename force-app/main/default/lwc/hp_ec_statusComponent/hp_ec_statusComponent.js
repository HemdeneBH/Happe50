/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-20-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { api, LightningElement, track, wire } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';

import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';

import getInfoContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getInfoContractData';
import getSoldeEffectifData from '@salesforce/apex/HP_EC_LoadCustomerData.getSoldeEffectifData';
import getFactureAgilabData from '@salesforce/apex/HP_EC_LoadCustomerData.getFactureAgilabData';
import getEcheanceContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getEcheanceContractData';

export default class Hp_ec_statusComponent extends LightningElement {

    @wire(MessageContext) messageContext;

    @api title;

    @track contactData;
    @track contractData;
    @track soldeEffectifData;
    @track factureAgilabData;

    @track currentEnergy;
    @track contractElec;
    @track contractGaz;

    @track actifContract;
    @track dateDebutValidite;
    @track dateReconduction;
    @track dateProchaineFacture;
    @track jourPrelevement;

    @track solde;

    @track isStatusPaiementEnRetard;
    @track isStatusAJourPaiement;

    @track todayDate = new Date();

    @track infoClass = 'rose info_date';
    @track statusClass = 'status_contract_rose';

    @wire(getContactData)
    wiredContactData({ data, error }) {
        if (data) {
            this.contactData = JSON.parse(data);
            console.log('Statut LWC -- this.contactData.ID_Tiers__c: ' + this.contactData.ID_Tiers__c);
        } else if (error) {
            console.log('Statut LWC -- error wiredContactData: ' + JSON.stringify(error));
        }
    }

    @wire(getContractData)
    wiredContractData({ data, error }) {
        if (data) {
            this.contractData = JSON.parse(data);
            // console.log('this.contractData wired : '+JSON.stringify(this.contractData));
        } else if (error) {
            console.log('Statut LWC -- error wiredContractData: ' + JSON.stringify(error));
        }
    }

    @wire(getSoldeEffectifData)
    wiredSoldeEffectifData({ error, data }) {
        if (data) {
            this.soldeData = data;
        } else if (error) {
            console.log('Statut LWC -- error wiredSoldeEffectifData: ' + JSON.stringify(error));
        }
    }

    initializeComponantProperties() {
        this.actifContract = null;
        this.dateDebutValidite = null;
        this.dateReconduction = null;
        this.dateProchaineFacture = null;
        this.jourPrelevement = null;

        this.contractElec = null;
        this.contractGaz = null;

        this.isStatusAJourPaiement = false;
        this.isStatusPaiementEnRetard = false;

        this.todayDate = new Date();
    }

    async populateContractInfo() {
        this.initializeComponantProperties();
        
        if (!this.contractData) {
            const contractDataResult = await this.getContractdata();
            this.contractData = JSON.parse(contractDataResult);
        }
        if (!this.idPortefeuilleContrat  || !this.currentEnergy) {
            return;
        }
        if (this.contractData ) {
            let today = new Date();
            this.contractData._data.forEach(c => {
                let dateFinValidite = new Date(c.dateFinValidite);
                let diffTime = Math.abs(today - dateFinValidite);
                let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                let isOldContract = (diffDays > 365) && (today > dateFinValidite) ;
                if (this.currentEnergy == 'Electricité' && (c.energie == 'Electricité' && c.idPortefeuilleContrat == this.idPortefeuilleContrat && (c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' ||
                c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007' || ((c.codeStatutCrm == 'E0009' && isOldContract) || (c.codeStatutCrm == 'H0103' && isOldContract))))) {
                    this.actifContract = c;
                    this.infoClass = 'purple info_date';
                }
                if (this.currentEnergy == 'Gaz Naturel' && (c.energie == 'Gaz Naturel' && c.idPortefeuilleContrat == this.idPortefeuilleContrat && (c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' ||
                c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007' || ((c.codeStatutCrm == 'E0009' && isOldContract) || (c.codeStatutCrm == 'H0103' && isOldContract))))) {
                    this.actifContract = c;
                    this.infoClass = 'blue info_date';
                }
            });

            if (this.actifContract) {
                if (!this.soldeData) {
                    this.soldeData = await this.getSoldeEffectifData();
                }
                if (this?.soldeData) {
                    this.soldeEffectifData = JSON.parse(this.soldeData);
                    if (this.soldeEffectifData.output?.soldes) {
                        let keys = Object.keys(this.soldeEffectifData.output.soldes);

                        for (let key of keys) {
                            let key2 = Object.keys(this.soldeEffectifData.output.soldes[key]);
                            if (key2 == this.idPortefeuilleContrat) {
                                this.montant = this.soldeEffectifData.output.soldes[key][key2];
                                this.montantToDisplay = Math.abs(this.montant);
                            }
                        }
                    }
                }

                let conditionCas2 = false;

                const FACTURES_DATA = await this.getFactureData(this.idPortefeuilleContrat);
                const FACTURES = JSON.parse(FACTURES_DATA);
                // console.log('FACTURES_DATA : '+FACTURES_DATA);
                if(FACTURES.status == 'SUCCESS') {
                    FACTURES.output.factures.forEach(f => {
                        if((f.statut == '1' || f.statut == '2') && (new Date(f.date_limite_de_paiement) < new Date()) && (this.montant < 0)) {
                            console.log('condition cas 2 True F : '+f.ref_facture);
                            conditionCas2 = true;
                        }
                    });
                }
                console.log('conditionCas2 factures test : '+conditionCas2);

                const ECHEANCE_DATA = await this.getEcheanceData(this.actifContract.id.toString());
                const ECHEANCES = JSON.parse(ECHEANCE_DATA);
                // console.log('ECHEANCE_DATA : ' + ECHEANCE_DATA);
                if(ECHEANCES.status == 'SUCCESS') { 
                    let keys = Object.keys(ECHEANCES.output);
                    for (let key of keys) {
                        if ((new Date(ECHEANCES.output[key].date_decheance) < new Date()) && !this.isEcheanceSolde(ECHEANCES.output[key].soldee_le) && (this.montant < 0)) {
                            console.log('condition cas 2 True E : ' + ECHEANCES.output[key].reference);
                            conditionCas2 = true;
                        }
                    }
                }
                console.log('conditionCas2 echeances test : '+conditionCas2);

                if (conditionCas2) {
                    // console.log('paiement en retard');
                    this.statusClass = 'status_contract_rose';
                    this.isStatusPaiementEnRetard = true;
                    
                } else {
                    // console.log('A jour de paiement');
                    this.currentEnergy == 'Electricité' ? this.statusClass = 'status_contract_purple':this.statusClass='status_contract_blue';
                    this.isStatusAJourPaiement = true;
                }
                
                //------------------------------ Part 1 --------------------------------------//
                const DateDebutValidite = this.actifContract.dateDebutValidite;
                this.dateDebutValidite = formatDateToString(new Date(DateDebutValidite));
                console.log('this.dateDebutValidite: ' + this.dateDebutValidite);
                //---------------------------- Part 2 --------------------------------------//
                // const DAY_DEBUT = new Date(DateDebutValidite).getDate();
                // const MONTH_DEBUT = new Date(DateDebutValidite).getMonth() + 1;
                // const AFTER_2_YEARS_DEBUT = Number(new Date(DateDebutValidite).getFullYear()) + Number(2);

                // this.dateReconduction = ('0' + DAY_DEBUT).slice(-2) + '.' + ('0' + MONTH_DEBUT).slice(-2) + '.' + AFTER_2_YEARS_DEBUT.toString().slice(-2);
                // console.log('this.dateReconduction: ' + this.dateReconduction);

                //------------------------------ Part 2 ------------------------------------//
                const INFO_CONTRACT_RESULT = await this.getInfoContractData(this.actifContract.id.toString());
                const PARSED_INFO_CONTRACT_RESULT = JSON.parse(INFO_CONTRACT_RESULT);
                if (PARSED_INFO_CONTRACT_RESULT?.output) {
                    this.dateReconduction = formatDateToString(new Date(PARSED_INFO_CONTRACT_RESULT.output.date_reconduction));
                    this.dateProchaineFacture = formatDateToString(new Date(PARSED_INFO_CONTRACT_RESULT.output.date_prochaine_facturation));
                } else {
                    this.template.querySelector('[data-id="date2"]').className='rose';
                    this.template.querySelector('[data-id="date3"]').className='rose';
                }

                //------------------------------ Part 3 ----------------------------------------//

                if (ECHEANCES.output) {
                    // console.log('Statut LWC -- echeancesData : ' + JSON.stringify(ECHEANCES));
                    let keys = Object.keys(ECHEANCES.output);
                    let minEch = null;
                    let today = new Date();
                    for (let key of keys) {
                        let currentDate = new Date(ECHEANCES.output[key].date_decheance);
                        if (minEch == null && currentDate >= today) {
                            minEch = currentDate;
                            this.jourPrelevement = ('0' + minEch.getDate()).slice(-2) + ' du mois';
                            continue;
                        }
                        if (minEch != null && currentDate >= today && minEch > currentDate) {
                            minEch = currentDate;
                            this.jourPrelevement = ('0' + minEch.getDate()).slice(-2) + ' du mois';
                        }
                    }
                    // console.log('this.jourPrelevement: ' + this.jourPrelevement);
                } else {
                    this.template.querySelector('[data-id="date4"]').className='rose';
                }
            }
        }
    }

    async getContractdata() {
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

    async getSoldeEffectifData(contractId) {
        return new Promise(async (resolve, reject) => {
            var result = await getSoldeEffectifData({}).then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getSoldeEffectifData : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        })
    }

    async getInfoContractData(contractId) {
        return new Promise(async (resolve, reject) => {
            var result = await getInfoContractData({ id_contrat_xdata: contractId })
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error getInfoContractData : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
    }

    async getFactureData(portefeuilleId) {
        return new Promise(async (resolve, reject) => {
            var result = await getFactureAgilabData({ id_portefeuille_contrat_xdata: portefeuilleId })
            .then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getFactureAgilabData : ' + JSON.stringify(error));
            });
            resolve(result);
        })
    }


    async getEcheanceData(contractId) {
        return new Promise(async (resolve, reject) => {
            var result = await getEcheanceContractData({ id_contrat_xdata: contractId })
            .then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getEcheanceContractData : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        })
    }

    getConditionFacture(factures) {
        let isFacturesHasConditionForCas1 = false
        let facturesHasCodition1 = [];
        factures.forEach(fct => {
            if ((fct.statut == 1 || fct.statut == 2) && new Date(fct.date_limite_de_paiement) > this.todayDate) {
                facturesHasCodition1.push(fct);
            }
        });
        if ((facturesHasCodition1.length == factures.length) && (factures.length != 0)) {
            isFacturesHasConditionForCas1 = true;
        }
        return isFacturesHasConditionForCas1;
    }

    isEcheanceSolde(soldee) {
        if(soldee?.includes('Total') || soldee?.includes('Partiel'))
            return true;
        return false;
    }

    connectedCallback() {
        this.handleSubscription();
        this.currentEnergy = getCurrentMessageValue('SelectedEnergy');
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.populateContractInfo();
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this, this.messageContext, this.handleLightningMessage);
        }
    }

    handleLightningMessage(self, subscription, message) {
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
        publishMC(this.messageContext, message, 'SelectedEnergy');
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
}

function formatDateToString(date) {
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();

    return ('0' + day).slice(-2) + '.' + ('0' + month).slice(-2) + '.' + year.toString().slice(-2);
}