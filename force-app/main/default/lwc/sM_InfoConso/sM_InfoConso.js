import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
import getFlayoutPCEData from '@salesforce/apex/SM_FlayoutPCE.getFlayoutPCEData'
import getFlayoutPDLData from '@salesforce/apex/SM_FlayoutPDL.lirePdl'
import INTST_FIELD from '@salesforce/schema/Contact.Statut_Internaute__c';
import getURLImpersonationForContact from '@salesforce/apex/SM_AP21_GestionImpersonation.getURLImpersonationForContact';
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";
const FIELDS = [INTST_FIELD];
//Todo externalisé ces paramétres 
const constant ={
    DeveloperName: "Service",
    SobjectType: "Case" ,
    CaseType: "Vie du contrat", 
    CaseSousType: "Suivi consommation Transmission index / contestation index",
    CaseStatus: "Pré-clôturé",
    CaseSousStatut : "Conforme",
    CaseStatusPause:"En traitement",
    IPCreateCase: "IP_CreateCaseLWC_Case"
  }
export default class SM_InfoConso extends NavigationMixin(LightningElement) {
    @api recordId;
    @api numeroVoie;
    @api ville;
    @api libelleVoie;
    @api complementAdresse;
    @api codePostal;
    @api NoCompteContrat;
    @api NoCompteContratMaj;
    @api dateReelleProchaineFacture;
    @api dateTechniqueProchaineFacture;
    @api uniteReleveGaz;
    @api uniteReleveElec;
    @api pce;
    @api pdl;
    @api IdPortefeuilleContrat;
    @api IdBusinessPartner;
    @api idContratElec;
    @api idContratGaz;
    @api factureEnLigne;
    plGaz;
    plElec;
    loadTabs = false;
    dataElec;
    dataGaz;
    newDataGaz = [];
    newDataElec = [];
    dataGazWithPagination;
    dataElecWithPagination;
    paginationGaz = [];
    paginationElec = [];
    error = false;
    checkedPause;
    checkedInteraction;
    noDataCase = false;
    noDataGaz = false;
    noDataElec = false;
    checkedInteraction;
    DRId_Case;
    idBusinessPartner;
    urlec = 'https://page.tobe.found';
    indexToContestElec;
    indexToContestGaz;
    filtreCategorieGaz = [];
    filtreCategorieElec = [];
    filtreMotifGaz = [];
    filtreMotifElec = [];
    showHideFilterMotifGaz = false;
    showHideFilterMotifElec = false;
    showHideFilterCategorieGaz = false;
    showHideFilterCategorieElec = false;
    valueMotifGaz = "";
    valueMotifElec = "";
    valueCategorieGaz = "";
    valueCategorieElec = "";
    filtre;
    type;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) contact;
    @api AccountId;
    navigateToHistoriqueFacture(){
        console.log('navigate to Facture');
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_Historique_Factures'
            },
            state: {
                c__numeroVoie: this.numeroVoie,
                c__libelleVoie: this.libelleVoie,
                c__complementAdresse: this.complementAdresse,
                c__codePostal: this.codePostal,
                c__NoCompteContrat: this.NoCompteContrat,
                c__NoCompteContratMaj: this.NoCompteContratMaj,
                c__ville: this.ville,
                c__IdBusinessPartner: this.IdBusinessPartner,
                c__IdPortefeuilleContrat: this.IdPortefeuilleContrat,
                c__recordId: this.recordId,
                c__pce: this.pce,
                c__pdl: this.pdl,
                c__uniteReleve: this.uniteReleve,
                c__dateProchaineFacture: this.dateProchaineFacture,
            }
        });
    }
    loadPLElec() {
        if(!this.plElec && this.pdl) {
            this.loadTabs = false;
            this.callHistorique({idCompteClient: this.NoCompteContrat, idPDLElec:this.pdl}, 'IP_SM_OperationrechercherDetailFactureElec_SOAP', 'Elec')
            this.callIP({numeroPointDeLivraison: this.pdl}, 'IP_SM_PtLivElec_APISET');
        }
    }
    loadPLGaz() {
        if (!this.plGaz && this.pce) {
            this.plGaz = {};
            let inputMap = {
                PCEIdentifier: this.pce,
                PerimetrePCE: false
            }
            getFlayoutPCEData(inputMap).then(result => {
                if(result) {
                    this.plGaz = {...this.plGaz, ...result};
                }
            }).catch(error => {
                console.log("got error getFlayoutPCEData", error);
            });
            this.callIP({numeroPointDeLivraison: this.pce}, 'IP_SM_PtLivGaz_APISET');
            this.callHistorique({idCompteClient: this.NoCompteContrat, idPDLGAZ:this.pce}, 'IP_SM_OperationrechercherDetailFactureGaz_SOAP', 'Gaz')
        } 
    }
    get showMessage() {
        return this.dateReelleProchaineFacture !== this.dateTechniqueProchaineFacture;
    }
    get isinternaute() {
        return getFieldValue(this.contact.data, INTST_FIELD) === 'Oui';
    }
    get showSpinner () {
        return ((((this.plGaz || this.noDataGaz) && this.pce) || ((this.plElec || this.noDataElec) && this.pdl) || !this.pce || this.error) && this.loadTabs) || (!this.pce && !this.pdl);
    }
    get isCRA () {
        return this.plGaz.ConsommationAnnuelleDeReference !== ""
    }
    get getdateProchaineFactureTechnique() {
        let dateTechniqueProchaineFacture = '-';
        if (this.dateTechniqueProchaineFacture) {
            dateTechniqueProchaineFacture = this.dateTechniqueProchaineFacture.split('-');
            dateTechniqueProchaineFacture = dateTechniqueProchaineFacture[2] + '/' + dateTechniqueProchaineFacture[1] + '/' + dateTechniqueProchaineFacture[0];
        }
        return dateTechniqueProchaineFacture;
    }
    get getdateProchaineFactureReelle() {
        let dateReelleProchaineFacture = '-';
        if (this.dateReelleProchaineFacture) {
            dateReelleProchaineFacture = this.dateReelleProchaineFacture.split('-');
            dateReelleProchaineFacture = dateReelleProchaineFacture[2] + '/' + dateReelleProchaineFacture[1] + '/' + dateReelleProchaineFacture[0];
        }
        return dateReelleProchaineFacture;
    }
    get isPDLPCE() {
        return this.pce && this.pdl;
    }
    get isNotPDLPCE() {
        return !this.pce && !this.pdl;
    }
    get isonlyPDL() {
        return !this.pce && this.pdl;
    }
    get getdateTheoriqueReleve() {
        let dateTheoriqueReleve = '-';
        if (this.plGaz.dateTheoriqueReleveAPI) {
            dateTheoriqueReleve = this.plGaz.dateTheoriqueReleveAPI.split('-');
            dateTheoriqueReleve = dateTheoriqueReleve[2] + '/' + dateTheoriqueReleve[1] + '/' + dateTheoriqueReleve[0];
        }
        return dateTheoriqueReleve;
    }
    get getdateTheoriqueReleveElec() {
        let dateTheoriqueReleve = '-';
        if (this.plElec.dateTheoriqueReleve) {
            dateTheoriqueReleve = this.plElec.dateTheoriqueReleve.split('-');
            dateTheoriqueReleve = dateTheoriqueReleve[2] + '/' + dateTheoriqueReleve[1] + '/' + dateTheoriqueReleve[0];
        }
        return dateTheoriqueReleve;
    }
    get nextDisabled(){
        if(this.nextDisable){
            return true;
        }
        if(this.checkedPause && this.checkedInteraction ){
            return true;
        }
        if(!this.checkedPause && !this.checkedInteraction ){
            return true;
        }
        return false
    }
    //Create Case et tracage d'interaction
    caseNavigate(){
        this.nextDisable = true;
        //Call IP to create Case and get idBP
        this.noDataCase = false;
        if(this.checkedInteraction){
            this.callIPCase({ContextId:this.recordId,DeveloperName:constant.DeveloperName,SobjectType:constant.SobjectType ,CaseType:constant.CaseType,
            CaseSousType:constant.CaseSousType,CaseStatus:constant.CaseStatus,CaseSousStatut:constant.CaseSousStatut},constant.IPCreateCase);
        }
        else if(this.checkedPause){
            this.callIPCase({ContextId:this.recordId,DeveloperName:constant.DeveloperName,SobjectType:constant.SobjectType ,CaseType:constant.CaseType,
            CaseSousType:constant.CaseSousType,CaseStatus:constant.CaseStatusPause},constant.IPCreateCase);
        }   
    }
    callIP(params, name) {
        callIP({ inputMap: params, NameIntergation: name })
          .then(result => {
            if( result  && name === 'IP_SM_PtLivGaz_APISET') {
                // this.plGaz = result;
                this.plGaz = {...this.plGaz, ...{dateTheoriqueReleveAPI: result.dateTheoriqueReleve, nombreRoue: result.nombreRoue}};
            } else if (result) {
                this.plElec = result;
            }
            // this.loadTabs = true;
          })
          .catch(error => {
            this.error = true;
            // this.loadTabs = true;
            console.log("got error callIP", name , error);
          });
    }
    callIPCase(params, name) {
        callIP({ inputMap: params, NameIntergation: name })
          .then(result => {
            if( result ) {
                this.noDataCase = result.length > 0 ? false : true;
                this.DRId_Case = result.Case;
                this.idBusinessPartner = result.idBusinessPartner;
                if(this.DRId_Case && this.idBusinessPartner){
                  //Go to ROS tracerInteraction
                  this.navigateToInteraction();
                  this.closeTab();
                }
                else{
                  console.log("Un problème est survenue lors de la création du Case");
                }
            } else {
              this.noDataCase = true
            }
          })
          .catch(error => {
            this.error = true;
            console.log("got error callIP", name , error);
          });
    }
    callHistorique(params, name, type, callback) {
        callIP({ inputMap: params, NameIntergation: name })
        .then(result => {
            console.log("callHistoriqueConso");
            this.loadTabs = true;
            if( result && result.Result && result.Result.length !== 0) {
                this['data' + type] = result.Result;
                this['data' + type].sort((a, b) => new Date(b.dateFinConsommation) - new Date(a.dateFinConsommation));
                let factureCyclique = null;
                let factureMES = null;
                let factureResiliation = null;
                let filtreCat = [];
                let filtreMotif = [];
                for (let item of this['data' + type]) {
                    if(!filtreCat.includes(item.categorieReleve.libelleCourt)) {
                        filtreCat.push(item.categorieReleve.libelleCourt);
                    }
                    if(!filtreMotif.includes(item.motifReleve.libelleCourt)) {
                        filtreMotif.push(item.motifReleve.libelleCourt);
                    }
                    let motif = item.motifReleve.code;
                    // mise en service 06 
                    if(motif === '06' && factureMES == null){
                        item.contestation = true;
                        factureMES = item;
                    }
                    // résiliation 03
                    else if(motif === '03' && factureResiliation == null){
                        item.contestation = true;
                        factureResiliation = item;
                    }
                    // dernière facture cyclique
                     else if((motif === '01' || motif === '02') && factureCyclique == null){
                        item.contestation = true;
                        factureCyclique = item;
                    }
                }
                if(filtreCat.length > 0) {
                    filtreCat.unshift('Séléctionner tout');
                    // filtreCat.push('Aucun');
                }
                if(filtreMotif.length > 0) {
                    filtreMotif.unshift('Séléctionner tout');
                    // filtreMotif.push('Aucun');
                }
                for ( let cat of filtreCat) {
                    this['filtreCategorie' + type].push ( { label: cat, value: cat } )
                }
                for ( let motif of filtreMotif) {
                    this['filtreMotif' + type].push ( { label: motif, value: motif } )
                }
                //FT3-67 RG1
                if(factureResiliation != null && factureCyclique != null && new Date(factureResiliation.dateFinConsommation) > new Date(factureCyclique.dateFinConsommation)){
                    factureCyclique.contestation = false;
                }
                //FT3-67 RG2
                if(factureMES != null && factureResiliation != null && new Date(factureMES.dateFinConsommation) > new Date(factureResiliation.dateFinConsommation)){
                    if(factureCyclique != null){
                        factureCyclique.contestation = false;
                    }
                    factureResiliation.contestation = false;
                }
                //FT3-67 RG3
                if(factureCyclique != null && (factureMES != null && new Date(factureCyclique.dateFinConsommation) > new Date(factureMES.dateFinConsommation)) && (factureResiliation != null && new Date(factureCyclique.dateFinConsommation) > new Date(factureResiliation.dateFinConsommation))){
                    factureCyclique.contestation = false;
                }
                for (let item of this['data' + type]) {
                    let temp = item.dateFinConsommation.split("T")[0].split('-');
                    item.dateFinConsommationContestation = item.dateFinConsommation;
                    item.dateFinConsommation = temp[2] + '/' + temp[1] + '/' + temp[0];
                    item.simulationFlag = (item.simulationFlag === 'true');
                    if (type === 'Gaz') {
                        item.indexFin = parseInt(item.indexFin, 10);
                        item.indexDebut = parseInt(item.indexDebut, 10);
                        item.quantiteKWh = parseInt(item.quantiteKWh, 10);
                        item.quantiteM3 = parseInt(item.quantiteM3, 10);
                        item.kPCS = parseFloat(item.kPCS);
                    } else {
                        if(!item.cadran.length) {
                            item.cadran = [item.cadran]
                        }
                        for(let cadran of item.cadran) {
                            if((cadran.code === '001' || cadran.code === '002') && item.cadran.length === 1) {
                                cadran.code = 'Base';
                            } else if(cadran.code === '001'){
                                cadran.code = 'HC';
                            }else if(cadran.code === '002') {
                                cadran.code = 'HP';
                            }
                            cadran.indexFin = parseInt(cadran.indexFin, 10);
                            cadran.indexDebut = parseInt(cadran.indexDebut, 10);
                            cadran.quantite = Number.parseInt(cadran.quantite, 10);
                        }
                    }   
                }
                let i,j,elementByPage = 12;
                for (i=0,j=this['data' + type].length; i<j; i+=elementByPage) {
                    this[ 'newData' + type ].push(this['data' + type].slice(i,i+elementByPage));
                    // do whatever
                }
                this.initPagination(0, type);
                if(callback) {
                    let tempType = type === 'Elec' ? 'Gaz' : 'Elec';
                    this['indexToContest' + type] = this['data' + type].filter(conso => conso.idFacture === this['indexToContest' + tempType].idFacture)[0];
                    this.openContestationIndex(tempType);
                }
            } else if (result.success === false) {
                this.error = true;
            }else {
              this['noData' + type] = true;
              console.log("Un problème est survenue lors du chrgement de l'historique de consommation");
            }
        })
        .catch(error => {
            this.error = true;
            console.log("got error callIP", name , error);
        });
    }
    initPagination (pageNumber, type) {
        this['pagination' + type] = [];
        this['data' + type + 'WithPagination'] = this[ 'newData' + type ][pageNumber];
        for(let i=0; i< this[ 'newData' + type ].length; i++) {
            this['pagination' + type].push({number: i+1, selected: i === 0 ? true: false});
        }
    }
    pagination (e) {
        let selectedPage = this['pagination' + e.currentTarget.dataset.type].filter(pagination => pagination.number === (parseInt(e.currentTarget.dataset.page, 10) + 1));
        this.resetSelectedPagination(e.currentTarget.dataset.type);
        selectedPage[0].selected = true;
        this['data' + e.currentTarget.dataset.type + 'WithPagination'] = this[ 'newData' + e.currentTarget.dataset.type ][e.currentTarget.dataset.page];
    }
    resetSelectedPagination(type) {
        for(const page of this['pagination' + type]) {
            page.selected = false;
        }
    }
    // manageTarifAcheminement(tarif) {
    //     let tempValue;
    //     switch (tarif) {
    //         case 'T1':
    //             tempValue = tarif + ' - moins de 6000kwh';
    //             break;
    //         case 'T2':
    //             tempValue = tarif + ' - supérieur ou égal à 6000kwh';
    //             break;
    //         case 'T3':
    //             tempValue = tarif + ' - supérieur ou égal à 300.000kwh';
    //             break;
    //         default:
    //                 tempValue = '';
    //     }
    //     return tempValue;
    // }
    handlePause(event){
        this.checkedPause = event.target.checked;
    }
    handleInteraction(event){
        this.checkedInteraction = event.target.checked;
    }
    closeTab() {
        let close = true;
        const closeclickedevt = new CustomEvent('closeclicked', {
            detail: { close },
        });
        // Fire the custom event
        this.dispatchEvent(closeclickedevt);
    }
      //Navigation vers tracer interaction
    navigateToInteraction(){
        const eventName = 'openInteraction';
        let inputMap;
        //Params pour interaction
        if(this.checkedInteraction ){
            inputMap = {
                isActivateTracerInteractionOS: true,
                isCasNominal:true,
                isPauseInteraction: false,
                DRId_Case:this.DRId_Case,
                StepNameOS:'Historique des consommations',
                refClientIdBP:this.idBusinessPartner,
                isLWC:true
            }
        }
      //Params pour mise en pause
        else if(this.checkedPause){
            inputMap = {
            isActivateTracerInteractionOS: true,
            isCasNominal:false,
            isPauseInteraction: true,
            DRId_Case:this.DRId_Case,
            StepNameOS:'Historique des consommations',
            refClientIdBP:this.idBusinessPartner,
            isLWC:true
            }
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    navigateToEC() {
        console.log("navigate to coords, urlec: ", this.urlec);
        getURLImpersonationForContact({ contactID: this.recordId })
            .then(result => {
                console.log('got result ', result);
                this.urlec = result;
                this.error = undefined;
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: result
                    }
                });
            })
            .catch(error => {
                console.log('got error ', error);
                this.error = error;
                this.urlec = undefined;
            });
    }
    contesterIndex(e) {
        let type = e.currentTarget.dataset.type;
        let idFacture = e.currentTarget.dataset.idfacture;
        this['indexToContest' + type] = this['data' + type].filter(conso => conso.idFacture === idFacture)[0];
        setCache().then(r => {
            if(this.idContratElec === this.idContratElec && !this.dataElec && type === 'Gaz') {
                this.callHistorique({idCompteClient: this.NoCompteContrat, idPDLElec:this.pdl}, 'IP_SM_OperationrechercherDetailFactureElec_SOAP', 'Elec', true)
            } else {
                let tempType = type === 'Elec' ? 'Gaz' : 'Elec';
                this['indexToContest' + tempType] = this['data' + tempType].filter(conso => conso.idFacture === this['indexToContest' + type].idFacture)[0];
                this.openContestationIndex(type);
            }
        })
        .catch(error => {
            console.log("got error setCache", error);
        });
    }
    openContestationIndex(type) {
        console.log('Open Movein');
        var eventName = "opencontestationindex";
        let donneesDerniersIndexReelGaz = {};
        if ( this.indexToContestGaz ) {
            donneesDerniersIndexReelGaz = this.dataGaz.filter(conso => conso.motifReleve.code === '01')[0];
        }
        const inputMap = {
            type: type,
            contestGaz: (this.indexToContestGaz && typeof(this.indexToContestGaz) === 'object') ? JSON.stringify(this.indexToContestGaz) : this.indexToContestGaz,
            donneesDerniersIndexReelGaz: (donneesDerniersIndexReelGaz && typeof(donneesDerniersIndexReelGaz) === 'object') ? JSON.stringify(donneesDerniersIndexReelGaz) : donneesDerniersIndexReelGaz,
            contestElec: (this.indexToContestElec && typeof(this.indexToContestElec) === 'object') ? JSON.stringify(this.indexToContestElec) : this.indexToContestElec,
            nombreRoue: this.plGaz ? parseInt(this.plGaz.nombreRoue) : '',
            idBusinessPartner: this.IdBusinessPartner,
            pce: this.pce,
            pdlCommunicantGaz: this.plGaz && this.plGaz.TypeCompteur && this.plGaz.TypeCompteur.split(' ')[1].toUpperCase() === 'GAZPAR' ? true : false,
            factureEnLigne: this.factureEnLigne === true,
            uniteReleveGaz: this.uniteReleveGaz === 'A'
            // isDual: this.idContratElec === this.idContratGaz
        };
        const event = new CustomEvent(eventName, {
            bubbles: true,
            composed: true,
            detail: inputMap
        });
        this.dispatchEvent(event);
    }
    toggleFilter(e){
        this.filtre = e.currentTarget.dataset.filtre;
        this.type = e.currentTarget.dataset.type;
        if(this.filtre.indexOf('Motif') > -1) {
            this['showHideFilterCategorie' + this.type] = false;
        } else {
            this['showHideFilterMotif' + this.type] = false;
        }
        this['showHideFilter' + this.filtre] = !this['showHideFilter' + this.filtre]
    }
    handleChange(e) {
        for(let val of e.detail.value) { 
            // if(val === 'Aucun') { 
            //     e.detail.value = ["Aucun"];
            //     break;
            // } else 
            if (val === 'Séléctionner tout') {
                e.detail.value = ["Séléctionner tout"];
                break;
            }
        }
        this['value' + this.filtre]  = e.detail.value;
        let listFiltrer = [];
        if((this['valueCategorie' + this.type].length === 0 && this['valueMotif' + this.type].length === 0)
            /*|| (this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Aucun' && ((this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Aucun') || this['valueMotif' + this.type].length === 0))*/
            /*|| (this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Aucun' && ((this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Aucun') || this['valueCategorie' + this.type].length === 0))*/
            || (this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Séléctionner tout' && ((this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout') || this['valueMotif' + this.type].length === 0))
            || (this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout' && ((this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Séléctionner tout') || this['valueCategorie' + this.type].length === 0))
            || (this['valueMotif' + this.type].length === 1 && (this['valueMotif' + this.type][0] === 'Séléctionner tout' /*&& this['valueMotif' + this.type][0] === 'Aucun'*/) && (this['valueCategorie' + this.type].length === 1 && (this['valueCategorie' + this.type][0] === 'Séléctionner tout' /*|| this['valueCategorie' + this.type][0] === 'Motif'*/)))
            ) {
            listFiltrer = this['data' + this.type];
        }
        else {
            for ( let conso of this['data' + this.type]) {
                if ( this['valueCategorie' + this.type].length > 0 /*&& this['valueCategorie' + this.type][0] !== 'Aucun'*/ ) {
                    for(let filter of this['valueCategorie' + this.type]) {
                        if (conso.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                            if ( this['valueMotif' + this.type].length > 0 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                for(let filter of this['valueMotif' + this.type]) {
                                    if (conso.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                        listFiltrer.push(conso);
                                    } 
                                }
                            } else {
                                listFiltrer.push(conso);
                            }
                        } 
                    }
                } else {
                    for(let filter of this['valueMotif' + this.type]) {
                        if (conso.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                            listFiltrer.push(conso);
                        } 
                    }
                }
            }
        }
        let i,j,elementByPage = 12;
        this[ 'newData' + this.type ] =  [];
        for (i=0,j=listFiltrer.length; i<j; i+=elementByPage) {
            this[ 'newData' + this.type ].push(listFiltrer.slice(i,i+elementByPage));
        }
        this.initPagination(0, this.type);
    }
}