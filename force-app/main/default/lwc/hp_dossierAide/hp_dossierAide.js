/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 12-16-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getClientInfo from '@salesforce/apex/HP_SM001_Agilab.getClientInfo';
import setClientInfo from '@salesforce/apex/HP_SM001_Agilab.setClientInfo';
import getRelatedCases from '@salesforce/apex/HP_SM001_Agilab.getRelatedCases';
import getOpenRelatedCases from '@salesforce/apex/HP_SM001_Agilab.getOpenRelatedCases';
import generatePDF from '@salesforce/apex/HP_GeneratePDFHelper.generatePDF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const OPTIONS = [{label : 'Oui',value:'Oui'},{label : 'Non',value:'Non'}];
const STATUT_CREER = 'H0105';
const STATUT_ATT_DISTRIB = 'H0101';
const STATUT_KO_DISTRIB = 'H0102';
const columns = [
    {label: 'Numéro de la requête', fieldName: 'caseNumber', type: 'button',  hideDefaultActions: true,
    typeAttributes: { value: {
        fieldName: 'caseNumber'
    },
    label: {
        fieldName: 'caseNumber'
    },
    title: {
        fieldName: 'caseNumber'
    },
    name: {
        fieldName: 'caseNumber'
    }, variant: 'base'}},
    {label: 'Statut', fieldName: 'caseStatus', type: 'text', hideDefaultActions: true},
    {label: 'Type Happe', fieldName: 'caseTypeHP', type: 'text', hideDefaultActions: true},
    {label: 'Nom Web', fieldName: 'caseWebName', type: 'text', hideDefaultActions: true},
    {label: 'Objet', fieldName: 'caseSubject', type: 'text', hideDefaultActions: true},
    {label: 'Date de création', fieldName: 'caseCreationDate', type: 'text', hideDefaultActions: true},

    
    
];
export default class Hp_dossierAide extends NavigationMixin(LightningElement) {
    @track columns = columns;
    @track _masterdata;
    @track _pfcdata;
    @track _selectedpfcid;
    @track personneData;
    @track idXdataClient;
    @track dossierAide;
    @track error;
    @track currentPCE;
    @track currentPDL;
    @track currentPfc;
    @track contratLocaux;
    @track contrats;
    @track contratsAgilab;
    @track idContratElec;
    @track idContratGaz;
    @track dateDebutAideGaz;
    @track dateFinAideGaz;
    @track dateDebutAideElec;
    @track dateFinAideElec;
    @track newDateDebutAide;
    @track newDateFinAide;
    @track idContract = null;
    @track statusGaz;
    @track statusElec;
    @track conditionPaiement;
    @track offreElec;
    @track offreGaz;
    @track options = OPTIONS;
    @track relatedCases;
    @track _secondarydata;
    @track montantDu;
    @track pfcInfoAPI;
    @track isPrelevement;
    @track isMensualisee;
    @track prochaineFacture;
    @track prelevement;
    @track montantReglements;
    @track planApurement;
    @track montantTotalApurement;
    @track soldePlanApurement;
    @track relatedCase;
    @track monthlyClient;
    @track statusContratElec;
    @track statusContratGaz;
    @track relatedCasesData;
    @track dateNextInvoiceInput;
    @track situationCompteInput;
    @track relatedCaseNumber;

    
        
    @api
    set masterdata(value) {
        if(value == null ) {
            return;
        }
        this._masterdata = JSON.parse(JSON.stringify(value));
        this.personneData = this._masterdata.data[0];
        this.idXdataClient = this.personneData.ID_Tiers__c;
        this.processData();
        this.loadDossierAide();
        this.loadRelatedCases();
        this.loadOpenRelatedCases();
    }
    get masterdata() {
        return null;
    }

    @api
    set pfcdata(value) {
        if(value == null ) {
            return;
        }
        this._pfcdata =  JSON.parse(JSON.stringify(value));
        this.processData();
    }
    get pfcdata() {
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

    @api
    set secondarydata(value) {
        if(value == null) {
            return;
        }
        console.log('Secondary Data : '+JSON.stringify(value));
        this._secondarydata =JSON.parse(JSON.stringify(value));
        this.findCurrentPftc();
        this.findCurrentSolde();
    }
    get secondarydata() {
        return null;
    }

    get gazLine(){
        let statusGazOK = (this.statusContratGaz != STATUT_CREER && this.statusContratGaz != undefined && this.statusContratGaz != STATUT_ATT_DISTRIB && this.statusContratGaz != STATUT_KO_DISTRIB);
        if(this?.currentPCE && this?.idContratGaz && statusGazOK){
            return 'Gaz : ' + this.offreGaz + ' - N° Contrat : '+this?.idContratGaz+' - '+this.statusGaz+' - PCE : '+this.currentPCE;
        }
        return null;
    }

    get clientName(){
        if(this?.personneData){
            let salutation = this.personneData.Salutation =='MME' ? 'Mme ' : 'M. '; 
            return salutation + this.personneData.FirstName + ' ' + this.personneData.LastName;
        }
    }

    get situationCompte(){
        let toDay = new Date();
        toDay.setMinutes( new Date().getMinutes() - new Date().getTimezoneOffset() );
        this.situationCompteInput = toDay.toISOString().slice(0,10);
        return toDay.toISOString().slice(0,10);
    }
    
    get elecLine(){
        let statusElecOK = (this.statusContratElec != STATUT_CREER && this.statusContratElec != undefined && this.statusContratElec != STATUT_ATT_DISTRIB && this.statusContratElec != STATUT_KO_DISTRIB);
        if(this?.currentPDL && this?.idContratElec && statusElecOK){
            return 'Electricité : ' + this.offreElec + ' - N° Contrat : '+this?.idContratElec+' - '+this.statusElec+' - PDL : '+this.currentPDL;
        }
        return null;
    }

    get aideLineElec(){
        if(this?.dossierAide){
            this.findCurrentDossierAide();
            if(this?.dateDebutAideElec && this?.dateFinAideElec && this?.idContratElec){
                return 'Dosser d\'aides enregistré : Date de début '+ this.dateDebutAideElec + ' - Date de fin : '+this.dateFinAideElec;
            } 
        }
        return null;
    }

    get aideLineGaz(){
        if(this?.dossierAide){
            this.findCurrentDossierAide();
            if(this?.dateDebutAideGaz && this?.dateFinAideGaz && this?.idContratGaz){
                return 'Dosser d\'aides enregistré : Date de début '+ this.dateDebutAideGaz + ' - Date de fin : '+this.dateFinAideGaz;
            } 
        }
        return null;
    }
    
    get activateButton(){
        if(this.idContract && this.newDateDebutAide && this.newDateFinAide){
            return false;
        }else {
            return true;
        }
    }

    get activateButtonPDF(){
        return (!this.monthlyClient || !this.situationCompteInput || !this.montantDu || !this.dateNextInvoiceInput || !this.prelevement || !this.planApurement || !this.relatedCase);
    }

    get clientMensualise(){
        if(this.isMensualisee == true){
            this.monthlyClient = 'Oui';
            return 'Oui';
        }else if(this.isMensualisee == false){
            this.monthlyClient = 'Non';
            return 'Non';
        }else {
            return null;
        }
    }

    get dateNextInvoice(){
        if(this?.prochaineFacture){
            this.dateNextInvoiceInput = this.prochaineFacture;
            return this.prochaineFacture;
        }
    }

    handleSituationCompte(event){
        this.situationCompteInput = event.target.value;
    }

    handleMontantDu(event){
        this.montantDu = event.target.value;
    }

    handleDateNextInvoice(event){
        this.dateNextInvoiceInput = event.target.value;
    }

    handleChangePrelevement(event){
        this.prelevement = event.detail.value;
    }

    handleTextDerniersReglements(event){
        this.montantReglements = event.target.value;
    }

    handleChangeMensualise(event){
        this.monthlyClient = event.detail.value;
    }

    handleChangePlanApurement(event){
        this.planApurement = event.detail.value;
    }

    handleMontantTotalApurement(event){
        this.montantTotalApurement = event.target.value;
    }

    handleSoldePlanApurement(event){
        this.soldePlanApurement = event.target.value;
    }

    handleChangeRelatedCase(event){
        this.relatedCase = event.detail.value;
    }

    handleStartDate(event){
        this.newDateDebutAide = event.target.value;
    }

    handleEndDate(event){
        this.newDateFinAide = event.target.value;
    }

    handleElec(event){
        if(event.target.checked){
            this.idContract = this.idContratElec;
        }else {
            this.idContract = undefined;
        }
    }

    handleGaz(event){
        if(event.target.checked){
            this.idContract = this.idContratGaz;
        }else {
            this.idContract = undefined;
        }
    }

    handleGeneratePDF(event){
        let pdfData={clientName:this.clientName,
                    clientRef:this.idXdataClient,
                    situationCompte:this.situationCompte,
                    montantDu:this.montantDu,
                    dateNextInvoice:this.dateNextInvoiceInput,
                    prelevement:this.prelevement,
                    montantReglements:this.montantReglements,
                    isMensualisee:this.monthlyClient,
                    planApurement:this.planApurement,
                    montantApurement:this.montantTotalApurement,
                    soldeApurement:this.soldePlanApurement,
                    caseId:this.relatedCase};
        generatePDF({informationAideToPdf: JSON.stringify(pdfData)})
        .then((result)=>{
            let attachmentId = result;
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: attachmentId,
                    objectApiName: 'Attachment',
                    actionName: 'view',
                },
            });
        })
        .catch(error=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating Attachment record',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        })
    }

    processData(){
        
        this.findCurrentPfcInfo();
        this.findCurrentContracts();
    }

    loadDossierAide(){
        if(this?.personneData?.ID_Tiers__c){
            getClientInfo({ personId: this.idXdataClient }).then(result => {
                this.dossierAide = result;
                this.error = undefined;
            }).catch(error => {
                console.log('Error : '+JSON.stringify(error));
                this.error = error;
                this.dossierAide = undefined;
            });
        }  
    }

    loadRelatedCases(){
        if(this?.personneData?.Id){
            getRelatedCases({contactId : this.personneData.Id}).then(result => {
                console.log(' all cases result : '+JSON.stringify(result));
                if(result.length>0){
                    this.relatedCasesData = result;
                }else {
                    this.relatedCasesData = undefined;
                }
            }).catch(error => {
                console.log('Error : '+JSON.stringify(error));
                this.relatedCasesData = undefined;
            });
        }
    } 

    loadOpenRelatedCases(){
        if(this?.personneData?.Id){
            getOpenRelatedCases({contactId : this.personneData.Id}).then(result => {
                let cases = [];
                console.log('open cases result : '+JSON.stringify(result));
                if(result.length == 1){
                    this.relatedCase = result[0].Id;
                    this.relatedCaseNumber = result[0].CaseNumber;
                }
                for(var key in result){
                    cases.push({ label: result[key].CaseNumber, value: result[key].Id  });
                }
                this.relatedCases = cases;
            }).catch(error => {
                console.log('Error : '+JSON.stringify(error));
                this.relatedCases = undefined;
            });
        }
    } 

    findCurrentSolde() {
        this.montantDu = 0;
        if(this._secondarydata == null || this._secondarydata.soldePersonne == null
            || this._secondarydata.soldePersonne.data == null 
            || this._secondarydata.soldePersonne.data.output == null
            || this._secondarydata.soldePersonne.data.output.soldes == null || this._selectedpfcid == null) {
            return;
        }
        
        for(let sld of this._secondarydata.soldePersonne.data.output.soldes) {
            let keys = Object.keys(sld);
            if(keys.length == 0) {
                continue;
            }
            if(keys[0] == this._selectedpfcid) {
                this.montantDu = Math.abs(sld[keys[0]]) ;
                break;
            }
        }
        for(let pftc of this._secondarydata.soldePersonne.data.output.portefeuille_contrats) {
            let keys = Object.keys(pftc);
            if(keys.length == 0) {
                continue;
            }
            if(keys[0] == this._selectedpfcid) {
                let pftcTable = pftc[keys[0]];
                let pfcKeys = Object.keys(pftcTable[0]);
                console.log('next date facture : '+JSON.stringify(pftcTable[0][pfcKeys[0]].date_prochaine_facture));
                this.prochaineFacture = pftcTable[0][pfcKeys[0]].date_prochaine_facture;
                break;
            }
        }
    }

    handleSubmit(event){
        let informationsAide = {idClientXdata:this.idXdataClient,idContratXdata:this.idContract,dateDebutAide:this.newDateDebutAide,dateFinAide:this.newDateFinAide};
        console.log('Information Aide : '+JSON.stringify(informationsAide));
        setClientInfo({informationAide:JSON.stringify(informationsAide)}).then(result => {
            if(result === true){
                const evt = new ShowToastEvent({
                    title: 'Succès',
                    message:'Dossier d\'aide envoyé avec succès',
                    variant: 'success',
                });
                this.dispatchEvent(evt);
            }else{
                const evt = new ShowToastEvent({
                    title: 'ERREUR',
                    message: 'Erreur lors de la mise à jour du dossier',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }
        }).catch(error =>{
            const evt = new ShowToastEvent({
                title: 'ERREUR',
                message: 'Erreur lors de la mise à jour du dossier',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        });
    }

    handleRowAction(event){
        let row = event.detail.row;
        console.log('Current Case : '+JSON.stringify(row));
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.caseId,
                objectApiName: 'Case',
                actionName: 'view',
            },
        });
    }

    findCurrentDossierAide(){
        this.dateDebutAideElec = null;
        this.dateDebutAideGaz = null;
        this.dateFinAideElec = null;
        this.dateFinAideGaz = null;
        if(this?.dossierAide){
            if(this.dossierAide.output.logements == null || !Array.isArray(this.dossierAide.output.logements)) {
                return;
            }
            for(let i=0; i<this.dossierAide.output.logements.length;i++){
                if(this.dossierAide.output.logements[i].id_portefeuille_contrat_xdata == this._selectedpfcid){
                    if(this.dossierAide.output.logements[i].id_contrat_xdata == this.idContratElec){
                        this.dateDebutAideElec = this.dossierAide.output.logements[i].aide.date_de_debut_aide;
                        this.dateFinAideElec = this.dossierAide.output.logements[i].aide.date_de_fin_aide;
                    }else {
                        this.dateDebutAideGaz = this.dossierAide.output.logements[i].aide.date_de_debut_aide;
                        this.dateFinAideGaz = this.dossierAide.output.logements[i].aide.date_de_fin_aide;
                    }
                }
            }
        }
    }

    findCurrentPftc(){
        this.pfcInfoAPI = null;
        this.isPrelevement = false;
        this.isMensualisee = false;
        if(this?._selectedpfcid){
            if(this._secondarydata != null && this._secondarydata.portefeuilleContratInfoList != null
                && this._secondarydata.portefeuilleContratInfoList.data != null && this._secondarydata.portefeuilleContratInfoList.data._data != null) {
                let pfcList = this._secondarydata.portefeuilleContratInfoList.data._data;
                for(let pfc of pfcList) {
                    if(pfc.id == this._selectedpfcid) {
                        this.pfcInfoAPI = pfc;
                        this.isPrelevement = pfc.libelleModeEncaissement == 'Prélèvement';
                        this.isMensualisee = pfc.codeRythmeFacturation == 'A';
                        break;
                    }
                }
            }
        } 
    }

    findCurrentPfcInfo(){
        if(this?._masterdata && this?._pfcdata && this?._selectedpfcid){
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
                        this.contratLocaux = null;
                        this.currentPCE='';
                        this.currentPDL='';
                        if(locauxContrat[i].locaux.length > 0) {
                            for(let j = 0; j < locauxContrat[i].locaux[0].pointsDeLivraison.length; j ++) {
                                let cont = locauxContrat[i].locaux[0].pointsDeLivraison[j];
                                let contLocaux = locauxContrat[i].locaux[0];
                                if( cont.secteurActivite == 'gaz') {
                                    this.currentPCE = cont.numeroPointDeLivraison;
                                    this.contratLocaux = contLocaux;
                                }
                                if( cont.secteurActivite == 'elec') {
                                    this.currentPDL = cont.numeroPointDeLivraison;
                                    this.contratLocaux = contLocaux;
                                }
                            }
                        }
                        break;
                    }
                }
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
            if(cont.idPortefeuilleContrat == this._selectedpfcid) {
                if(cont.energie == 'Electricité') {
                    this.contrats.elec = cont;
                    this.idContratElec = cont.id;
                    this.statusElec = cont.libelleStatutCrm;
                    this.offreElec = cont.offre;
                    this.statusContratElec = cont.codeStatutCrm;
                } else {
                    this.contrats.gaz = cont;
                    this.statusGaz = cont.libelleStatutCrm;
                    this.idContratGaz = cont.id;
                    this.offreGaz = cont.offre;
                    this.statusContratGaz = cont.codeStatutCrm;
                }
            }
        }
    }
    closeDossierAide(event){
        this.dispatchEvent(new CustomEvent('opendossieraide', { detail: false}));
    }
}