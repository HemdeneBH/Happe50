/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 07-05-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { api, LightningElement, track, wire } from 'lwc';

import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getAutoReleveData from '@salesforce/apex/HP_EC_LoadCustomerData.getAutoReleveData';

import getInfoContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getInfoContractData';
import getGrilleTarifaire from '@salesforce/apex/HP_EC_LoadCustomerData.getGrilleTarifaire';
import getConsoGaz from '@salesforce/apex/HP_EC_LoadCustomerData.getConsoGaz';
import getConsoElec from '@salesforce/apex/HP_EC_LoadCustomerData.getConsoElec';
import isCompteurCommunicantElec from '@salesforce/apex/HP_EC_LoadCustomerData.isCompteurCommunicantElec';
import isCompteurCommunicantGaz from '@salesforce/apex/HP_EC_LoadCustomerData.isCompteurCommunicantGaz';

import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

export default class Hp_ec_releve extends LightningElement {

    @wire(MessageContext) messageContext;

    @api title;

    @api textProchainePeriodeGaz;
    @api textProchainePeriodeElec;
    @api textPeriodeEnCoursGaz;
    @api textPeriodeEnCoursElec;
    @api textPeriodeEnCoursResiliation;

    @api titlePopinReleve;
    @api messageIndexError;
    @api messageIndexNoValidError;
    @api customUrlPopinReleve;
    @api customUrlLabelPopinReleve;

    @track dateProchainePeriodeGaz;
    @track dateProchainePeriodeElec;
    @track datePeriodeEnCoursGaz;
    @track datePeriodeEnCoursElec;
    @track datePeriodeEnCoursResiliation;

    @track contractData;
    @track contractGaz;
    @track contractElec;
    @track contact;
    @track idClient;
    @track isPeriodeAR_Gaz;
    @track isPeriodeAR_Elec;
    @track typeComptage;
    @track pdl;
    @track pce;
    @track latest_index_elec;
    @track latest_indexhp_elec;
    @track latest_index_gaz;

    @track showConfirmationIndex;
    @track isProcessFinished;
    @track isCommunicantGaz;
    @track isCommunicantElec;
    @track retourStatusAutoReleve_gaz;
    @track retourStatusAutoReleve_elec;

    @track confirmation_date;

    get isPeriodeAR() {
        if ((this.isPeriodeAR_Gaz || this.isPeriodeAR_Elec) && !this.showConfirmationIndex)
            return true;
        return false;
    }

    get showPeriodeEnCoursElec() {
        if(this.datePeriodeEnCoursElec && !this.datePeriodeEnCoursResiliation)
            return true;
        return false;
    }

    get showPeriodeEnCoursGaz() {
        if(this.datePeriodeEnCoursGaz && !this.datePeriodeEnCoursResiliation)
            return true;
        return false;
    }

    get showReleveComponent() {
        if(this.isProcessFinished && this.retourStatutAutoReleve && (!this.isCommunicantGaz || !this.isCommunicantElec))
            return true;
        return false;
    }
    
    get retourStatutAutoReleve() {
        if(this.retourStatusAutoReleve_gaz || this.retourStatusAutoReleve_elec)
            return true;
        return false;
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
    wiredContract({ error, data }) {
        if (data) {
            this.contractData = JSON.parse(data);
        } else if (error) {
            console.log(JSON.stringify(error));
        }
    }

    async populateContractInfo() {
        console.log('Releve LWC -- idPortefeuilleContrat : ' + this.idPortefeuilleContrat);
        this.initializeComponantProperties();

        if (!this.contractData) {
            const contractDataResult = await this.getContractdata();
            this.contractData = JSON.parse(contractDataResult);
        }
        if (!this.idPortefeuilleContrat) {
            return;
        }
        if (this.contractData) {
            // console.log('this.contractData : '+JSON.stringify(this.contractData));
            this.contractData._data.forEach(c => {
                if (c.idPortefeuilleContrat == this.idPortefeuilleContrat && (c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' ||
                c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007')) {
                            c.energie == 'Electricité' ? this.contractElec = c : this.contractGaz = c;
                        }
                    });

            if(this.contractGaz) {
                console.log('this.contractGaz.id : ' + this.contractGaz.id);

                // check if compteur gaz communicant  //
                        // Part 1: Get numéro PCE
                        const infoContractResult = await this.getInfoContractData(this.contractGaz.id.toString());
                        const parsedInfoContractResult = JSON.parse(infoContractResult);
                        this.pce = parsedInfoContractResult.output.pdl;
                        console.log('PCE : ' + this.pce);

                        // Part 2: Get Index dernière relève
                        if (this.pce) {
                            // const consoGazResult = await this.getConsoGaz(this.pce);
                            const consoGazResult = await this.getConsoGaz(this.idClient, this.pce);
                    // console.log('consoGazResult : '+consoGazResult);
                            const parsedConsoGazResult = JSON.parse(consoGazResult);
                            if (parsedConsoGazResult.status === 'SUCCESS') {
                                let latest_date_fin = new Date(1970, 1, 1);
                                let latest_index_fin = 0;
                                parsedConsoGazResult.output.forEach(elem => {
                                    const myArray = elem.date_releve.split("/");
                                    const newFormat = myArray[2] + '-' + myArray[1] + '-' + myArray[0];
                                    const date_releve = new Date(newFormat);
                                    if ((elem.id_facture != null) && (date_releve > latest_date_fin)) {
                                        latest_date_fin = date_releve;
                                        latest_index_fin = elem.index_fin;
                                    }
                                });
                                this.latest_index_gaz = latest_index_fin;
                                console.log('latest_index_gaz : ' + this.latest_index_gaz);
                            }
                        }
                const IS_COMPTEUR_COMMUNICANT_GAZ = await this.isCompteurCommunicantGaz(this.pce, this.latest_index_gaz);
                this.isCommunicantGaz = JSON.parse(IS_COMPTEUR_COMMUNICANT_GAZ)?.data;
                console.log('isCommunicantGaz : '+this.isCommunicantGaz);
                // END OF: check if compteur gaz communicant //

                // Get Période AR infos
                const gazAutoReleveDataResult = await this.getAutoReleveData(this.contractGaz.id);
                const gazAutoReleveDataResult_parsed = JSON.parse(gazAutoReleveDataResult);

                if (gazAutoReleveDataResult_parsed.status == 'SUCCESS') {
                    this.retourStatusAutoReleve_gaz = true;
                    if (gazAutoReleveDataResult_parsed.output.statut_ar) {
                        console.log('Gaz, Période AR ouverte !');
                        const DATE_FIN_PERIODE = formatDateToString(new Date(gazAutoReleveDataResult_parsed.output.date_fin_periode))
                        // console.log('this.contractGaz.codeStatutCrm : ' + this.contractGaz.codeStatutCrm);
                        // console.log('DATE_FIN_PERIODE : ' + DATE_FIN_PERIODE);

                        if(this.contractGaz.codeStatutCrm == 'E0007' || this.contractGaz.codeStatutCrm == 'E0009') {
                            this.datePeriodeEnCoursResiliation = DATE_FIN_PERIODE; // date 5
                        } else {
                            this.datePeriodeEnCoursGaz = DATE_FIN_PERIODE; // date 3
                        }

                        this.isPeriodeAR_Gaz = true;
                    } else {
                        console.log('Gaz, Période AR non ouverte !');
                        const DATE_DEBUT_PROCHAINE_RELEVE = formatDateToString(new Date(gazAutoReleveDataResult_parsed.output.date_debut_prochaine_releve));
                        const DATE_FIN_PROCHAINE_RELEVE = formatDateToString(new Date(gazAutoReleveDataResult_parsed.output.date_fin_prochaine_releve));
                        // date 1
                        this.dateProchainePeriodeGaz = DATE_DEBUT_PROCHAINE_RELEVE + ' au ' + DATE_FIN_PROCHAINE_RELEVE;
                    }
                }
                if(gazAutoReleveDataResult_parsed.status == 'FAILED') {
                    console.log("Prestation d'auto-relève non activée sur ce contrat gaz. "+this.contractGaz.id);
                }
            } else {
                this.isCommunicantGaz = true;
            }

            if (this.contractElec) {
                console.log('this.contractElec.id : ' + this.contractElec.id);
                
                // Part 2: Get numéro PDL
                const infoContractResult = await this.getInfoContractData(this.contractElec.id.toString());
                const parsedInfoContractResult = JSON.parse(infoContractResult);
                this.pdl = parsedInfoContractResult.output.pdl;
                console.log('PDL : ' + this.pdl);

                // Part 3: Get Index dernière relève
                if (this.pdl) {
                    const consoElecResult = await this.getConsoElec(this.idClient,this.pdl);
                    const parsedConsoElecResult = JSON.parse(consoElecResult);
                    if (parsedConsoElecResult.status === 'SUCCESS') {
                        let latest_date_fin = new Date(1970, 1, 1);
                        let latest_date_fin_indexhp = new Date(1970, 1, 1);
                        let latest_index_fin = 0;
                        let latest_indexhp_fin = 0;
                        parsedConsoElecResult.output.forEach(elem => {
                            const myArray = elem.date_releve.split("/");
                            const newFormat = myArray[2] + '-' + myArray[1] + '-' + myArray[0];
                            const date_releve = new Date(newFormat);
                            if ((elem.id_facture != null) && (date_releve > latest_date_fin) && (elem.rang_cadran == 1)) {
                                latest_date_fin = date_releve;
                                latest_index_fin = elem.index_fin;
                            }
                            if ((elem.id_facture != null) && (date_releve > latest_date_fin_indexhp) && (elem.rang_cadran == 2)) {
                                latest_date_fin_indexhp = date_releve;
                                latest_indexhp_fin = elem.index_fin;
                            }
                        });
                        this.latest_index_elec = latest_index_fin;
                        console.log('latest_index_elec : ' + this.latest_index_elec);
                    }
                }
                const IS_COMPTEUR_COMMUNICANT_ELEC = await this.isCompteurCommunicantElec(this.pdl, this.latest_index_elec);
                this.isCommunicantElec = JSON.parse(IS_COMPTEUR_COMMUNICANT_ELEC)?.data;
                console.log('isCommunicantElec : '+this.isCommunicantElec);
                
                // Main Part : Get Période AR infos
                const elecAutoReleveDataResult = await this.getAutoReleveData(this.contractElec.id);
                const elecAutoReleveDataResult_parsed = JSON.parse(elecAutoReleveDataResult);

                if (elecAutoReleveDataResult_parsed.status == 'SUCCESS') { 
                    this.retourStatusAutoReleve_elec = true;
                    if (elecAutoReleveDataResult_parsed.output.statut_ar) {
                        console.log('Elec, Période AR ouverte !');
                        const DATE_FIN_PERIODE = formatDateToString(new Date(elecAutoReleveDataResult_parsed.output.date_fin_periode))
                        
                        if(this.contractElec.codeStatutCrm == 'E0007' || this.contractElec.codeStatutCrm == 'E0009') {
                            if(this.datePeriodeEnCoursResiliation < DATE_FIN_PERIODE) 
                                this.datePeriodeEnCoursResiliation = DATE_FIN_PERIODE; // date 5
                        } else {
                            this.datePeriodeEnCoursElec = DATE_FIN_PERIODE; // date 4
                        }

                        // Get type comptage
                        const dateDebutValiditeUs = new Date(this.contractElec.dateDebutValidite);
                        const dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
                        const grilleTarifaireResult = await this.getGrilleTarifaire(this.contractElec.id.toString(), dateDebutValiditeFr);
                        const grilleTarifaireResult_parsed = JSON.parse(grilleTarifaireResult);
                        // console.log('grilleTarifaireResult : '+grilleTarifaireResult);
                        if (grilleTarifaireResult_parsed?.status == 'SUCCESS') {
                            this.typeComptage = grilleTarifaireResult_parsed.elecTypeComptage;
                            console.log('this.typeComptage : ' + this.typeComptage);
                        }
                        this.isPeriodeAR_Elec = true;

                    } else {
                        console.log('Elec, Période AR non ouverte !');
                        const DATE_DEBUT_PROCHAINE_RELEVE = formatDateToString(new Date(elecAutoReleveDataResult_parsed.output.date_debut_prochaine_releve));
                        const DATE_FIN_PROCHAINE_RELEVE = formatDateToString(new Date(elecAutoReleveDataResult_parsed.output.date_fin_prochaine_releve));
                        // date 2
                        this.dateProchainePeriodeElec = DATE_DEBUT_PROCHAINE_RELEVE + ' au ' + DATE_FIN_PROCHAINE_RELEVE;
                    }
                }
                if (elecAutoReleveDataResult_parsed.status == 'FAILED') {
                    console.log("Prestation d'auto-relève non activée sur ce contrat elec. " + this.contractElec.id);
                }
            } else {
                this.isCommunicantElec = true;
            }
            
        }
        this.isProcessFinished = true;
        console.log('showReleveComponent : '+ this.showReleveComponent);
    }

    initializeComponantProperties() {
        this.contractGaz = null;
        this.contractElec = null;

        this.datePeriodeEnCoursGaz = null;
        this.datePeriodeEnCoursElec = null;
        this.datePeriodeEnCoursResiliation = null;
        this.dateProchainePeriodeGaz = null;
        this.dateProchainePeriodeElec = null;

        this.isPeriodeAR_Elec = false;
        this.isPeriodeAR_Gaz = false;
        this.showConfirmationIndex = false;

        this.typeComptage = null;
        this.pdl = null;
        this.pce = null;
        this.latest_index_elec = null;
        this.latest_indexhp_elec = null;
        this.latest_index_gaz = null;
        
        this.isProcessFinished = false;
        this.isCommunicantGaz = true;
        this.isCommunicantElec = true;

        this.retourStatusAutoReleve_gaz = false;
        this.retourStatusAutoReleve_elec = false;
    }

    hanldeEnvoieIndexEvent(event) {
        console.log('event.detail in hp_ec_releve  .. : '+ JSON.stringify(event.detail));

        this.confirmation_date = formatDateToString(new Date(Date.now()));
        console.log('this.confirmation_date : '+this.confirmation_date);

      if(event.detail.isGaz && event.detail.status == 'SUCCESS') {
        this.datePeriodeEnCoursGaz = null;
        this.dateProchainePeriodeGaz = event.detail.prochaine_releve_debut;
        this.showConfirmationIndex = true;
      }

      if(event.detail.isElec && event.detail.status == 'SUCCESS') {
        this.datePeriodeEnCoursElec = null;
        this.dateProchainePeriodeElec = event.detail.prochaine_releve_debut;
        this.showConfirmationIndex = true;
      }
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

    async getAutoReleveData(contractId) {
        return new Promise(async (resolve, reject) => {
            var result = await getAutoReleveData({ id_contrat_xdata: contractId })
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error getAutoReleveData : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
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

    connectedCallback() {
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.handleSubscription();
        this.populateContractInfo();
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this, this.messageContext, this.handleLightningMessage);
        }
    }

    handleLightningMessage(self, subscription, message) {
        if (message.messageType == 'SelectedPortfolio') {
            self.idPortefeuilleContrat = message.messageData.message;
            self.populateContractInfo();
        }
    }

}

function formatDateToString(date) {
    const year = date.getFullYear();
    const month = date.getMonth()+1;
    const day = date.getDate();

    return ('0'+day).slice(-2)+'.'+('0'+month).slice(-2)+'.'+year.toString().slice(-2);
}