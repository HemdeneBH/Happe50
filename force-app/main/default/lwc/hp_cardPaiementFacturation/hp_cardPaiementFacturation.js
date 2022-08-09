/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 

 * @last modified on  : 12-15-2021

 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                 Modification
 * 1.0   06-14-2021   Hemdene Ben Hammouda   Initial Version
**/
import { LightningElement,api,track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import UsrId from '@salesforce/user/Id';
import ROLE_DEV_NAME from '@salesforce/schema/User.UserRole.DeveloperName';
import PROFILE_DEV_NAME from '@salesforce/schema/User.Profile.Name';
import {getRecord, getFieldValue, updateRecord} from 'lightning/uiRecordApi';
import QUEUESUBLE_FIELD from '@salesforce/schema/Case.HP_QueueCible__c';
import ID_FIELD from '@salesforce/schema/Case.Id';
import insertCaseHistoryView from '@salesforce/apex/HP_SM051_IBANViewHistory.insertCaseHistoryView';
import loadCustomMetadata from '@salesforce/apex/HP_SM003_MetadataManager.getConfigurationGenerique';
import RecurrenceMonthOfYear from '@salesforce/schema/Task.RecurrenceMonthOfYear';

const STATUT_CREER = 'H0105';
const STATUT_ATT_DISTRIB = 'H0101';
const STATUT_KO_DISTRIB = 'H0102';
export default class Hp_cardPaiementFacturation extends NavigationMixin(LightningElement) {
    _selectedpfcid;
    @track _masterdata;
    @track currentPfc;
    _secondarydata;
    @track currentInfoBank;
    @track xdataPersonne;
    @track pfcInfoAPI;
    @track isPrelevement;
    @track mandat;
    codeRythmeFacturation;
    @track contrats;
    @track contratsAgilab;
    @track factureInfo;
    @track echeances;
    @track isStatutMondatError = true;
    @track isMensEnCours;
    @track montantEcheance;
    @track maxDateFacture;
    @track isFacture = false;
    @track conditionPaiement;
    @track dateEcheance;
    @track showReclamationCase = false;
    @track personneData;
    @track showSpinner = false;
    @track reclamationCaseList = null;
    @track currentPDL;
    @track currentPCE;
    @track showLink = false;
    @track idContratGaz;
    @track idContratElec;
    @track statusContratElec = undefined;
    @track statusContratGaz = undefined;
    @track contratLocaux;
    @track pfcdata_factures;

    @track ibanDisplay = '********';

    isTicTac;
    delay;
    @wire(getRecord, {
        recordId: UsrId, 
        fields: [ROLE_DEV_NAME,PROFILE_DEV_NAME]
    }) user;

    intl = new Intl.DateTimeFormat("en-GB",  
    {
      hour12: false,
      hour: "2-digit",
      minute: "2-digit",
      second:"2-digit",
      day:"2-digit",
      month:"2-digit",
      year:"numeric"
    });
    _pfcdata;
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;
    @api
    set masterdata(value) {
        if(value == null ) {
            return;
        }
        this._masterdata = JSON.parse(JSON.stringify(value));
        this.personneData = this._masterdata.data[0];
        if(this._selectedpfcid == null) {
            return;
        }
    }
    get masterdata() {
        return null;
    }
    @api
    set pfcdata(value) {
        this. ibanDisplay = '********';
        if(value == null ) {
            return;
        }
        if(value.factureInfo != null) {
            this.factureInfo = JSON.parse(JSON.stringify(value.factureInfo.data));
            this.processFacture();
        }
        this._pfcdata =  JSON.parse(JSON.stringify(value));
        this.pfcdata_factures = value;
        this.processData();
    }
    get pfcdata() {
        return null;
    }
    @api
    set secondarydata(value) {
        if(value == null) {
            return;
        }
        this._secondarydata =JSON.parse(JSON.stringify(value)) ;
        this.processData();
        if(this._secondarydata.reclamationCase != null) {
            this.reclamationCaseList = this._secondarydata.reclamationCase.data;
        } else {
            this.reclamationCaseList = null;
        }
        if(this.reclamationCaseList != null) {
            for(let i = 0; i < this.reclamationCaseList.length; i ++) {
                this.reclamationCaseList[i].CreatedDate = this.intl.format(new Date(this.reclamationCaseList[i].CreatedDate));
            }
        }


        if(value.xdataPersonne != null) {
            this.xdataPersonne = value.xdataPersonne.data;
            if (value != null) {
                if (this.xdataPersonne.dateDebutValiditeChequeEnergie != null) {
                    const dateDebut = this.xdataPersonne.dateDebutValiditeChequeEnergie;
                    this.dateDebutValiditeChequeEnergieCustom = dateDebut.split('-')[0] + '/' + dateDebut.split('-')[1] + '/' + dateDebut.split('-')[2];
                }
                if (this.xdataPersonne.dateFinValiditeChequeEnergie != null) {
                    const dateFin = this.xdataPersonne.dateFinValiditeChequeEnergie;
                    this.dateFinValiditeChequeEnergieCustom = dateFin.split('-')[0] + '/' + dateFin.split('-')[1] + '/' + dateFin.split('-')[2];
                }
            }
        }
    }
    get secondarydata() {
        return null;
    }
    @api
    set selectedpfcid(value) {
        if(value == null) {
            return;
        }
        this._selectedpfcid = value;
        this.processData();
    }
    get selectedpfcid() {
        return null;
    }
    connectedCallback() {
        loadCustomMetadata({cleConfiguration : 'HP_DELAY_IBAN'}).then(result => {
            this.delay = parseInt(result);
        });
    }

    get showFactureLink(){
        return this?.factureInfo?.output?.factures?.length > 0;
    }

    get showAide(){
        let userProfile = getFieldValue(this.user.data, PROFILE_DEV_NAME);
        let statusElecOK = (this.statusContratElec != STATUT_CREER && this.statusContratElec != undefined && this.statusContratElec != STATUT_ATT_DISTRIB && this.statusContratElec != STATUT_KO_DISTRIB);
        let statusGazOK = (this.statusContratGaz != STATUT_CREER && this.statusContratGaz != undefined && this.statusContratGaz != STATUT_ATT_DISTRIB && this.statusContratGaz != STATUT_KO_DISTRIB);
        console.log('statusElecOK : '+statusElecOK);
        console.log('statusGazOK : '+statusGazOK);
        return ((userProfile == 'HP_Conseiller Niveau 3' || userProfile == 'HP_SystemAdmin') && (statusElecOK || statusGazOK )) ;
    }
    processData() {
        this.findCurrentPftc();
        this.findCurrentBankInfo();
        this.findCurrentMandat();
        this.findCurrentContracts();
        this.findCurrentAgilabContrat();
        this.findCurrentEcheance();
    }
    findCurrentPftc() {
        if(this._masterdata != null && this._masterdata.contratInfoList != null
            && this._masterdata.contratInfoList.pfcInfoList != null  && this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList != null
            && this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data != null) {
            let locauxContrat = this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data._data;
            if(locauxContrat == null || !Array.isArray(locauxContrat)) {
                return;
            }
            for(let i = 0; i < locauxContrat.length; i ++) {
                if(this._selectedpfcid == locauxContrat[i].idPortefeuilleContrat) {
                    this.currentPfc = locauxContrat[i];
                    console.log('contrat locaux : '+JSON.stringify(locauxContrat));
                    this.contratLocaux = null;
                    this.currentPCE='';
                    this.currentPDL='';
                    this.showLink = false;
                    if(locauxContrat[i].locaux.length > 0) {
                        for(let j = 0; j < locauxContrat[i].locaux[0].pointsDeLivraison.length; j ++) {
                            let cont = locauxContrat[i].locaux[0].pointsDeLivraison[j];
                            let contLocaux = locauxContrat[i].locaux[0];
                            if( cont.secteurActivite == 'gaz') {
                                this.currentPCE = cont.numeroPointDeLivraison;
                                this.contratLocaux = contLocaux;
                                this.showLink = true;
                            }
                            if( cont.secteurActivite == 'elec') {
                                this.currentPDL = cont.numeroPointDeLivraison;
                                this.contratLocaux = contLocaux;
                                this.showLink = true;
                            }
                        }
                    }

                    break;
                }
            }
        }
        this.pfcInfoAPI = null;
        this.isPrelevement = false;
        this.isMesualisee = false;
        if(this._secondarydata != null && this._secondarydata.portefeuilleContratInfoList != null
            && this._secondarydata.portefeuilleContratInfoList.data != null && this._secondarydata.portefeuilleContratInfoList.data._data != null) {
            let pfcList = this._secondarydata.portefeuilleContratInfoList.data._data;
            for(let pfc of pfcList) {
                if(pfc.id == this._selectedpfcid) {
                    this.pfcInfoAPI = pfc;
                    this.isPrelevement = pfc.libelleModeEncaissement == 'Prélèvement';
                    this.isMesualisee = pfc.codeRythmeFacturation == 'A';
                    this.codeRythmeFacturation = pfc.codeRythmeFacturation;
                    break;
                }
            }
        }
    } 
    findCurrentBankInfo() {
        if(this.pfcInfoAPI == null || this._secondarydata == null || this._secondarydata.xdataPersonneCoordonneBancaire == null
            || this._secondarydata.xdataPersonneCoordonneBancaire.data == null || this._secondarydata.xdataPersonneCoordonneBancaire.data._data == null) {
            return;
        }
        let dat = this._masterdata.globalParam.data.TAD;
        let bankList = this._secondarydata.xdataPersonneCoordonneBancaire.data._data;
        for(let bank of bankList) {
            if(bank.idCompteBancaire == this.pfcInfoAPI.idCoordonneeBancaireEncaissement) {
                this.currentInfoBank = JSON.parse(JSON.stringify(bank));
                if(dat && this.currentInfoBank != null && this.currentInfoBank.iBAN) {
                    this.currentInfoBank.iBAN = this.currentInfoBank.iBAN.slice(0,4) + '******' + this.currentInfoBank.iBAN.slice(this.currentInfoBank.iBAN.length - 4)
                }
                break;
            }
        }
    }
    findCurrentMandat() {
        this.isStatutMondatError = true;
        this.mandat = null;
        if(this.currentInfoBank == null || this._secondarydata == null
             || this._secondarydata.mandat.data == null || this._secondarydata.mandat.data._data == null) {
            return;
        }
        let mandats = this._secondarydata.mandat.data._data;
        for(let mand of mandats) {
            if(mand.coordonneesBancaire == this.currentInfoBank.iBAN) {
                this.mandat = mand;
                this.isStatutMondatError = false;
                break;
            }
        }
    }
    findCurrentContracts() {
        this.contrats = {};
        if(this._selectedpfcid == null || this._masterdata == null || this._masterdata.contratInfoList == null ||this._masterdata.contratInfoList.data == null 
            || this._masterdata.contratInfoList.data._data == null) {
                return;
        }
        let contratsList =  this._masterdata.contratInfoList.data._data;
        for(let cont of contratsList) {
            console.log('pfc : '+this._selectedpfcid);
            if(cont.idPortefeuilleContrat == this._selectedpfcid) {
                console.log('ptf contract : '+cont.idPortefeuilleContrat);
                console.log('Current Contract hp_CardPaiement : '+JSON.stringify(cont));
                if(cont.energie == 'Electricité') {
                    this.contrats.elec = cont;
                    this.statusContratElec = cont.codeStatutCrm;
                } else {
                    this.contrats.gaz = cont;
                    this.statusContratGaz = cont.codeStatutCrm;
                }
                console.log('Current Status Gaz : '+this.statusContratGaz);
                console.log('Current Status Elec : '+this.statusContratElec);
            }
        }
    }
    findCurrentEcheance() {
       this.echeances = {};
       if(this._pfcdata == null || this._pfcdata.echeanceContrat == null || this.contrats == null) {
           return;
       }
       let currentEch = this._pfcdata.echeanceContrat;
       this.setEcheanceType(currentEch['child-0-echeanceContrat']);
       this.setEcheanceType(currentEch['child-1-echeanceContrat']);
       if(this.echeances.gazMin != null || this.echeances.elecMin != null) {
        this.isMensEnCours = true;
       }
       if(this.echeances.gazMin != null && this.echeances.elecMin != null) {
            let montantTotal = parseFloat(this.echeances.gazMin.montant_ttc) + parseFloat(this.echeances.elecMin.montant_ttc);

            this.montantEcheance = this.formatDecimalTwoDigits(montantTotal)  + ' €' + ' dont ' + this.formatDecimalTwoDigits(parseFloat(this.echeances.gazMin.montant_ttc)) + ' € gaz / ' + this.formatDecimalTwoDigits(parseFloat(this.echeances.elecMin.montant_ttc)) + ' € élec';   
            this.dateEcheance = this.echeances.gazMin.date_decheance;
        } else if(this.echeances.gazMin != null) {
            this.montantEcheance = this.formatDecimalTwoDigits(parseFloat(this.echeances.gazMin.montant_ttc)) + ' €';
            this.dateEcheance = this.echeances.gazMin.date_decheance;
       } else if(this.echeances.elecMin != null) {
            this.montantEcheance = this.formatDecimalTwoDigits(parseFloat(this.echeances.elecMin.montant_ttc)) + ' €';
            this.dateEcheance = this.echeances.elecMin.date_decheance;
       }
    }
    setEcheanceType(ech){
        this.isMensEnCours = false;
       if(ech == null || ech.param == null) {
           return;
       }
       if(this.contrats.elec != null && this.contrats.elec.id == ech.param.contratIdList) {
        this.echeances.elec = ech;
        this.echeances.elecMin = this.findFirstEchInfuture(ech);
       } else if(this.contrats.gaz != null && this.contrats.gaz.id == ech.param.contratIdList) {
        this.echeances.gaz = ech;
        this.echeances.gazMin = this.findFirstEchInfuture(ech);
       }
    }
    findFirstEchInfuture(echList) {
        let keys = Object.keys(echList.data.output);
        if(keys.length == 0) {
            return null;
        }
        let minEch = null;
        let today = new Date();
        for(let key of keys) {
            let currentDate = new Date(echList.data.output[key].date_decheance);
            if(minEch == null && currentDate >= today) {
                minEch = echList.data.output[key];
                minEch.dt = currentDate;
                continue;
            }
            if(minEch != null && currentDate >= today && minEch.dt > currentDate) {
                minEch = echList.data.output[key];
                minEch.dt = currentDate;
            }
        } 
        return minEch;
    }
    findCurrentAgilabContrat() {
        this.contratsAgilab = {};
        this.idContratElec = null;
        this.idContratGaz = null;
        if(this._pfcdata == null || this._pfcdata.infoContrat == null || this.contrats == null) {
            return;
        }
       let currentContrat = this._pfcdata.infoContrat;
       this.conditionPaiement = null; 
       console.log('contract : '+JSON.stringify(currentContrat['child-0-infoContrat']));
       this.setContratAgilabType(currentContrat['child-0-infoContrat']);
       this.setContratAgilabType(currentContrat['child-1-infoContrat']);
    }
    setContratAgilabType(cont) {
        
        if(cont == null || cont.param == null) {
            return;
        }
        if(this.contrats.elec != null && this.contrats.elec.id == cont.param.contratIdList) {
         this.contratsAgilab.elec = cont;
         this.idContratElec = cont.param.contratIdList;
        } else if(this.contrats.gaz != null && this.contrats.gaz.id == cont.param.contratIdList) {
         this.contratsAgilab.gaz = cont;
         this.idContratGaz = cont.param.contratIdList;
        }
        let separateur = '';
        if(this.conditionPaiement != null) {
            separateur = ' et ';
        }
        if(cont.data!= null && cont.data.output != null && cont.data.output.jour_drp != null && cont.data.output.jour_drp != '') {
            let contratType = cont.data.output.electricite.puissance == null ? 'GAZ' : 'ELEC';
            this.conditionPaiement = this.conditionPaiement == null ? '': this.conditionPaiement;
            this.conditionPaiement += separateur + 'Le ' + cont.data.output.jour_drp + ' pour le ' + contratType;
        } 
    }
    processFacture() {
        this.isFacture = false;
        if(this.factureInfo == null || this.factureInfo.output == null || this.factureInfo.output.factures == null) {
            return;
        }
        this.maxDateFacture = null;
        console.log('Factures : '+JSON.stringify(this.factureInfo.output.factures));
        for(let fact of this.factureInfo.output.factures) {
            let currentDate = new Date(fact.date_creation);
            if(fact.statut == null || !fact.statut || fact.statut == 'Soldée'){
                continue;
            }
            if(this.maxDateFacture == null) {
                this.maxDateFacture = fact;
                this.maxDateFacture.dt = currentDate;
                continue;
            }
            if(currentDate > this.maxDateFacture.dt) {
                this.maxDateFacture = fact;
                this.maxDateFacture.dt = currentDate;
                continue;
            }
        }
        if(this.maxDateFacture != null) {
            this.isFacture = true;
            this.maxDateFacture.montant_ttc = this.formatDecimalTwoDigits(this.maxDateFacture.montant_ttc);
        }
    }

//todo 
   /*  closePopupModalReclamationCase() {
        this.showReclamationCase = false;
    }
    openPopupModalReclamationCase() {
        this.showReclamationCase = true;
    }


       handleSubmit(event) {
        this.showSpinner = true;
        event.preventDefault();
        
        const fields = event.detail.fields;
        fields.RecordTypeId = this.reclamationRT;
        fields.ContactId = this.personneData.Id;
        fields.Status = 'HP_PENDING';
        fields.Reason = fields.HP_Motif__c;
        console.log(JSON.stringify(fields));
        this.isTicTac = fields.HP_Type__c == 'HP_TIC_TAC';
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }



    handleSuccess(event) {
        this.showSpinner = false;
        const payload = event.detail;
        //console.log("@@ payload : " + JSON.stringify(event));


        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        this.showReclamationCase = false;
        eval("$A.get('e.force:refreshView').fire();");
        this.dispatchEvent(new ShowToastEvent({
            title: '',


            message: 'Requête créée avec succès',
            variant: 'success'
        }));
       if(!this.isTicTac) {
        window.location.reload();
           return;

       }
        let role = getFieldValue(this.user.data, ROLE_DEV_NAME);
        let val = null;
        if(role == 'HP_Conseiller_Niveau_1') {
            val = 'Niveau 2';
        }


        if(role == 'HP_Conseiller_Niveau_2') {
            val = 'Niveau 3';
        }

        if(val == null) {
            window.location.reload();
            return;
        }
        const fields = {};
        fields[ID_FIELD.fieldApiName] = updatedRecord;
        fields[QUEUESUBLE_FIELD.fieldApiName] = val;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                window.location.reload();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erreur',
                        message: "Erreur d'escalade",
                        variant: 'error'
                    })
                );
                window.location.reload();
            });
    }

  get reclamationRT() {
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'HP_Médiation / Réclamation');
    }


  openReclamationCase(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  event.target.dataset.id,
                actionName: 'view',
            },
        })
    }*/
    showIBAN() {
        this.ibanDisplay = this.currentInfoBank.iBAN;

        setTimeout(() => {
            this.ibanDisplay = '********';
        }, this.delay);

        insertCaseHistoryView({iban : this.ibanDisplay, souscriptionId : null, contactId : this._masterdata.data[0].Id}).then(result => {

        });
    }

    navitageToHistoriqueConsommation(event) {
        event.preventDefault();
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__HP_HistoriqueConsommationContainer'
            },
            state: {
                c__hprefclient: this._masterdata.data[0].ID_Tiers__c,
                c__currentPDL : this.currentPDL,
                c__currentPCE : this.currentPCE,
                c__idContratGaz : this.idContratGaz,
                c__idContratElec : this.idContratElec,
                c__contratLocaux : this.contratLocaux
            }
        });
    }

    navitageToHistoriqueFacturation(event) {
        event.preventDefault();
        const consommationData = {
            idXdata : this._masterdata.data[0].ID_Tiers__c,
            PDL : this.currentPDL,
            PCE : this.currentPCE
        };
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__HP_HistoriqueFacturationContainer'
            },
            state: {
                c__pfcdata: this.pfcdata_factures,
                c__contratLocaux : this.contratLocaux,
                c__idContratGaz : this.idContratGaz,
                c__idContratElec : this.idContratElec,
                c__consommationData : consommationData
            }
        });
    }
    navitageToDossierAide(event){
        this.dispatchEvent(new CustomEvent('opendossieraide', { detail: true}));
    }
    navitageToHistoriquePaiements(event) {
        event.preventDefault();
        const consommationData = {
            idXdata : this._masterdata.data[0].ID_Tiers__c,
            PDL : this.currentPDL,
            PCE : this.currentPCE
        };
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__HP_HistoriquePaiementsContainer'
            },
            state: {
                c__pfcdata: this.pfcdata_factures,
                c__contratLocaux : this.contratLocaux,
                c__idContratGaz : this.idContratGaz,
                c__idContratElec : this.idContratElec,
                c__consommationData : consommationData
            }
        });
    }

    formatDecimalTwoDigits(montant) {
        return (Math.round(montant * 100) / 100).toFixed(2);
    }
}