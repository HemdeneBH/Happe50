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
import getAutoReleveData from '@salesforce/apex/HP_EC_LoadCustomerData.getAutoReleveData';

import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';

export default class hp_ec_myConsumptionSummary extends NavigationMixin(LightningElement) {

    @wire(MessageContext) messageContext;

    @api titreFirstTab;
    @api textPasDeConsommations;
    @api lienSpecifique;
    @api libelleDuLien;

    @track onConsumptionTab = true;
    @track onReleveTab = false;
    @track consumptionTabClass = 'consumption-tab active';
    @track releveTabClass = 'consumption-tab';

    @track idPortefeuilleContrat;
    @track contractInfo;
    @track idClient;
    @track contractElec;
    @track contractGaz;
    @track currentPdl;
    @track currentPce;
    @track isCommunicantGaz;
    @track isCommunicantElec;

    @track showTextPasDeConsommations_Gaz = false;
    @track showTextPasDeConsommations_Elec = false;
    @track gasConsumptions = [];
    @track elecConsumptions = [];
    // Set to false to see estimated values
    @track communicatingMeter = true;
    @track showValue = true;
    @track showPrice = false;
    @track showDetails = false;
    @track displayDetails = false;
    @track showGas = true;
    @track showElec = false;
    @track isDual = false;

    // ReleveTab Properties //
    @api titreSecondTab;
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

    @api textBlocRose;
    @api showIconLampBlocRose;
    @api showIconConfirmBlocRose;

    @api textBlocBleue;
    @api showIconLampBlocBleue;
    @api showIconConfirmBlocBleue;

    @track dateProchainePeriodeGaz;
    @track dateProchainePeriodeElec;
    @track datePeriodeEnCoursGaz;
    @track datePeriodeEnCoursElec;
    @track datePeriodeEnCoursResiliation;

    @track confirmation_date;
    //////////////////////////

    @track isProcessFinished = false;

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

    get showSwitchEnergy () {
        return this.isDual;
    }

    get showTextPasDeConsommations() {
        if((this.showGas && this.showTextPasDeConsommations_Gaz && this.isProcessFinished) || (this.showElec && this.showTextPasDeConsommations_Elec && this.isProcessFinished))
            return true;
        return false;
    }

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
        // if(this.isProcessFinished && (!this.isCommunicantGaz || !this.isCommunicantElec))
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
        if (message.messageType == 'SelectedPortfolio') {
            self.idPortefeuilleContrat = message.messageData.message;
            self.getCurrentData();
        }
    }

    initializeComponantProperties() {
        // this.onConsumptionTab = true;
        // this.onReleveTab = false;

        this.consoGazResult = null;
        this.consoElecResult = null;

        this.contractGaz = null;
        this.contractElec = null;
        this.currentPce = null;
        this.currentPdl = null;

        this.isProcessFinished = false;
        this.isCommunicantGaz = null;
        this.isCommunicantElec = null;
        this.typeComptage = null;

        // ----------Initialize Releve Tab Properties-------- //
        this.datePeriodeEnCoursGaz = null;
        this.datePeriodeEnCoursElec = null;
        this.datePeriodeEnCoursResiliation = null;
        this.dateProchainePeriodeGaz = null;
        this.dateProchainePeriodeElec = null;

        this.isPeriodeAR_Elec = false;
        this.isPeriodeAR_Gaz = false;
        this.showConfirmationIndex = false;

        this.latest_index_elec = null;
        this.latest_indexhp_elec = null;
        this.latest_index_gaz = null;
        
        this.retourStatusAutoReleve_gaz = false;
        this.retourStatusAutoReleve_elec = false;

        // ------Initialize Consumption Tab Properties------ //
        this.gasConsumptions = [];
        this.elecConsumptions = [];

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

        this.showGas = true;
        this.showElec = false;
        this.showTextPasDeConsommations_Gaz = false;
        this.showTextPasDeConsommations_Elec = false;
    }

    async getCurrentData() {
        this.initializeComponantProperties();
        if (!this.contractInfo) {
            const contractJson = await this.getContractdata();
            this.contractInfo = JSON.parse(contractJson);
        }
        // console.log('HP_EC_hp_ec_myConsumptionSummary || this.contractInfo :' + this.contractInfo);

        if(this.contractInfo) {
            let contractCount = 0;
            this.contractInfo._data.forEach(c => {
                if (c.idPortefeuilleContrat == this.idPortefeuilleContrat && (c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' ||
                    c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007')) {
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

        if(this.contractGaz) {
            console.log('Contract Gaz : '+this.contractGaz.id);

            const INFO_CONTRACT_RESULT = await this.getInfoContractData(this.contractGaz.id.toString());
            const PARSED_INFO_CONTRACT_RESULT = JSON.parse(INFO_CONTRACT_RESULT);
            this.currentPce = PARSED_INFO_CONTRACT_RESULT.output.pdl;

            if (this.currentPce) {
                const CONSO_GAZ_RESULT = await this.getConsoGaz(this.idClient, this.currentPce);
                const PARSED_CONSO_GAZ_RESULT = JSON.parse(CONSO_GAZ_RESULT);
                if (PARSED_CONSO_GAZ_RESULT.status === 'SUCCESS') {
                    this.consoGazResult = PARSED_CONSO_GAZ_RESULT.output;
                    let latest_date_fin = new Date(1970, 1, 1);
                    let latest_index_fin = 0;
                    PARSED_CONSO_GAZ_RESULT.output.forEach(elem => {
                        const myArray = elem.date_releve.split("/");
                        const newFormat = myArray[2] + '-' + myArray[1] + '-' + myArray[0];
                        const date_releve = new Date(newFormat);
                        if ((elem.id_facture != null) && (date_releve > latest_date_fin)) {
                            latest_date_fin = date_releve;
                            latest_index_fin = elem.index_fin;
                        }
                    });
                    this.latest_index_gaz = latest_index_fin;
                }
                const IS_COMPTEUR_COMMUNICANT_GAZ = await this.isCompteurCommunicantGaz(this.currentPce, this.latest_index_gaz);
                console.log('IS_COMPTEUR_COMMUNICANT_GAZ : '+JSON.stringify(IS_COMPTEUR_COMMUNICANT_GAZ));
                if(IS_COMPTEUR_COMMUNICANT_GAZ.status == 200) {
                    this.isCommunicantGaz = IS_COMPTEUR_COMMUNICANT_GAZ.data;
                }
                console.log('isCommunicantGaz new : '+this.isCommunicantGaz);
                
            }
        }

        if (this.contractElec) {
            console.log('Contract Elec : '+this.contractElec.id);

            const INFO_CONTRACT_RESULT = await this.getInfoContractData(this.contractElec.id.toString());
            const PARSED_INFO_CONTRACT_RESULT = JSON.parse(INFO_CONTRACT_RESULT);
            this.currentPdl = PARSED_INFO_CONTRACT_RESULT.output.pdl;

            if (this.currentPdl) {
                const CONSO_ELEC_RESULT = await this.getConsoElec(this.idClient, this.currentPdl);
                const PARSED_CONSO_ELEC_RESULT = JSON.parse(CONSO_ELEC_RESULT);
                if (PARSED_CONSO_ELEC_RESULT.status === 'SUCCESS') {
                    this.consoElecResult = PARSED_CONSO_ELEC_RESULT.output;
                    let latest_date_fin = new Date(1970, 1, 1);
                    let latest_date_fin_indexhp = new Date(1970, 1, 1);
                    let latest_index_fin = 0;
                    let latest_indexhp_fin = 0;
                    PARSED_CONSO_ELEC_RESULT.output.forEach(elem => {
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
                }

                const IS_COMPTEUR_COMMUNICANT_ELEC = await this.isCompteurCommunicantElec(this.currentPdl, this.latest_index_elec);
                console.log('IS_COMPTEUR_COMMUNICANT_ELEC : '+JSON.stringify(IS_COMPTEUR_COMMUNICANT_ELEC));

                if(IS_COMPTEUR_COMMUNICANT_ELEC.status == 200) {
                    this.isCommunicantElec = IS_COMPTEUR_COMMUNICANT_ELEC.data;
                }
                console.log('isCommunicantElec new : '+this.isCommunicantElec);
                
            }
        }
        
        await this.releveTabProcess();
        await this.consumptionTabProcess();
        
        this.isProcessFinished = true;
        console.log('Show Releve Tab : '+this.showReleveComponent);
    }

    async releveTabProcess() {
        // if(this.onReleveTab ==  false)
        //     return;

        if(this.contractGaz) {
            // Get Période AR infos
            const gazAutoReleveDataResult = await this.getAutoReleveData(this.contractGaz.id);
            const gazAutoReleveDataResult_parsed = JSON.parse(gazAutoReleveDataResult);

            if (gazAutoReleveDataResult_parsed.status == 'SUCCESS') {
                this.retourStatusAutoReleve_gaz = true;
                if (gazAutoReleveDataResult_parsed.output.statut_ar) {
                    console.log('Gaz, Période AR ouverte !');
                    const DATE_FIN_PERIODE = formatDateToString(new Date(gazAutoReleveDataResult_parsed.output.date_fin_periode));
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
                        // console.log('this.typeComptage : ' + this.typeComptage);
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

    async consumptionTabProcess() {
        // if(this.onConsumptionTab ==  false)
        // return;

        if(this.contractGaz) {
            // Step 1 : Get typeComptage, prix htt, prix ttc
            const dateDebutValiditeUs = new Date(this.contractGaz.dateDebutValidite);
            const dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
            const grilleTarifaireResult = await this.getGrilleTarifaire(this.contractGaz.id.toString(), dateDebutValiditeFr);
            const grilleTarifaireResult_parsed = JSON.parse(grilleTarifaireResult);
            // console.log('HP_EC_hp_ec_myConsumptionSummary || grilleTarifaireResult Gaz: '+grilleTarifaireResult_parsed.status);
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

            // Step 2 : Generate Gaz Consumptions Data Per Conso
            this.gasConsumptions = this.generateGazConsumptionsPerConso();
            this.gasConsumptions?.splice(12,this.gasConsumptions.length - 12);
            console.log('HP_EC_hp_ec_myConsumptionSummary || this.gasConsumptions : '+JSON.stringify(this.gasConsumptions));

            // Final step: Après organization Data, afficher le gaz et masquer l'elec
            this.handleType({detail: 'gas'});
        }

        if(this.contractElec) {
            // Step 1 : Get typeComptage, prix htt, prix ttc
            const dateDebutValiditeUs = new Date(this.contractElec.dateDebutValidite);
            const dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
            const grilleTarifaireResult = await this.getGrilleTarifaire(this.contractElec.id.toString(), dateDebutValiditeFr);
            const grilleTarifaireResult_parsed = JSON.parse(grilleTarifaireResult);
            // console.log('HP_EC_hp_ec_myConsumptionSummary || grilleTarifaireResult elec: '+grilleTarifaireResult);
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

            // Step 2 : Generate Elec Consumptions Data Per Conso
            this.elecConsumptions = this.generateElecConsumptionsPerConso();
            console.log('HP_EC_hp_ec_myConsumptionSummary || this.elecConsumptions :' + JSON.stringify(this.elecConsumptions));

            // Final step: Après organization Data, afficher l'elec
            if(!this.contractGaz) {
                this.handleType({detail: 'elec'});
            }
                
        }

        this.gasConsumptions?.length == 0 ? this.showTextPasDeConsommations_Gaz = true: this.showTextPasDeConsommations_Gaz = false;
        this.elecConsumptions?.length == 0 ? this.showTextPasDeConsommations_Elec = true: this.showTextPasDeConsommations_Elec = false;
    }

    switchToConsumptionTab() {
        this.consumptionTabClass = 'consumption-tab active';
        this.releveTabClass = 'consumption-tab';
        this.onConsumptionTab = true;
        this.onReleveTab = false;

        // this.getCurrentData();
    }

    switchToReleveTab() {
        this.releveTabClass = 'consumption-tab active';
        this.consumptionTabClass = 'consumption-tab';
        this.onConsumptionTab = false;
        this.onReleveTab = true;

        // this.getCurrentData();
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

    generateGazConsumptionsPerConso() {
        if(!this.consoGazResult)
            return [];

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
            return [];

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
                    response = JSON.parse(response);
                    response.status = 200;
                    return response;
                }).catch(error => {
                    console.log('***Error isCompteurCommunicantElec : ' + JSON.stringify(error));
                    return error;
                    // return {"key":"isCompteurCommunicantElec","data":null,"status":"FAILED"};
                });
            resolve(result);
        })
    }

    async isCompteurCommunicantGaz(pce, index) {
        return new Promise(async (resolve, reject) => {
            var result = await isCompteurCommunicantGaz({ pce: pce, index: index})
                .then(response => {
                    response = JSON.parse(response);
                    response.status = 200;
                    return response;
                }).catch(error => {
                    console.log('***Error isCompteurCommunicantGaz : ' + JSON.stringify(error));
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