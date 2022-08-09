import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, wire, track} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
import getFlayoutPCEData from '@salesforce/apex/SM_FlayoutPCE.getFlayoutPCEData'
import INTST_FIELD from '@salesforce/schema/Contact.Statut_Internaute__c';
import getURLImpersonationForContact from '@salesforce/apex/SM_AP21_GestionImpersonation.getURLImpersonationForContact';
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";
const FIELDS = [INTST_FIELD];
//Todo externalisé ces paramétres 
const constant ={
    DeveloperName: "Service",
    SobjectType: "Case" ,
    CaseType: "Vie du contrat", 
    CaseSousType: "Suivi consommation Transmission index/Contestation index",
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
    @api isSoldePositif;
    @api SoldeEnCours;
    @api DLP;
    @api ModePrelevement;
    @api offreGaz;
    @api offreElec;
    @api EnqSat;

    plGaz;
    plElec;
    loadTabs = false;
    dataElec;
    dataGaz;
    newDataGaz = [];
    newDataElec = [];
    newDataproductGazArray = [];
    newDataproductElecArray = [];
    dataGazWithPagination;
    dataElecWithPagination;
    dataTrafeOffGazWithPagination;
    dataTrafeOffElecWithPagination;
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
    filtreLibelleConsoGaz = [];
    filtreLibelleConsoElec = [];
    showHideFilterMotifGaz = false;
    showHideFilterMotifElec = false;
    showHideFilterCategorieGaz = false;
    showHideFilterCategorieElec = false;
    showHideFilterLibelleConsoGaz = false;
    showHideFilterLibelleConsoElec = false;
    //@track showHideFournGaz = true;
    valueMotifGaz = "";
    valueMotifElec = "";
    valueCategorieGaz = "";
    valueCategorieElec = "";
    valueLibelleConsoGaz = "";
    valueLibelleConsoElec = "";
    filtre;
    type;
    @track productArray = [];
    @track productGazArray = [];
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) contact;
    @api AccountId;
    connectedCallback() {
        this.callHistorique({idCompteClient: this.NoCompteContrat}, 'IP_SM_consulterDonneesFacture_SOAP');
    }
    navigateToHistoriqueFacture(){
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
            // this.loadTabs = false;
            //LIK this.callHistorique({idCompteClient: this.NoCompteContrat, idPDLElec:this.pdl}, 'IP_SM_OperationrechercherDetailFactureElec_SOAP', 'Elec')
            // this.callHistorique({idCompteClient: this.NoCompteContrat}, 'IP_SM_consulterDonneesFacture_SOAP', 'Elec');
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
            //LIK this.callHistorique({idCompteClient: this.NoCompteContrat, idPDLGAZ:this.pce}, 'IP_SM_OperationrechercherDetailFactureGaz_SOAP', 'Gaz');
            // this.callHistorique({idCompteClient: this.NoCompteContrat}, 'IP_SM_consulterDonneesFacture_SOAP', 'Gaz');
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


    get isTradeOffElec(){
        return this.offreElec && this.offreElec.includes('Référence');
        
    }
    get isTradeOffGaz(){
        return this.offreGaz && this.offreGaz.includes('Référence');
        
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
        if (this.plElec.dateTheoriqueProchaineReleve) {
            dateTheoriqueReleve = typeof(this.plElec.dateTheoriqueProchaineReleve) === 'object' ? this.plElec.dateTheoriqueProchaineReleve[0] : this.plElec.dateTheoriqueProchaineReleve;
            dateTheoriqueReleve = dateTheoriqueReleve.split('-');
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
            setCache().then(r => {              
               this.callIPCase({ContextId:this.recordId,AccountId:this.AccountId,DeveloperName:constant.DeveloperName,SobjectType:constant.SobjectType ,CaseType:constant.CaseType,
                    CaseSousType:constant.CaseSousType,CaseStatus:constant.CaseStatus,CaseSousStatut:constant.CaseSousStatut},constant.IPCreateCase);
            })
            .catch(error => {
                console.log("got error setCache interaction", error);
            });
            
        }
        else if(this.checkedPause){
            setCache().then(r => {
                this.callIPCase({ContextId:this.recordId,AccountId:this.AccountId,DeveloperName:constant.DeveloperName,SobjectType:constant.SobjectType ,CaseType:constant.CaseType,
                CaseSousType:constant.CaseSousType,CaseStatus:constant.CaseStatusPause},constant.IPCreateCase);
            })
            .catch(error => {
                console.log("got error setCache", error);
            });
            
        }   
    }
    callIP(params, name) {
        callIP({ inputMap: params, NameIntergation: name })
          .then(result => {
            if( result  && name === 'IP_SM_PtLivGaz_APISET') {
                this.plGaz = {...this.plGaz, ...{dateTheoriqueReleveAPI: result.dateTheoriqueProchaineReleve, nombreRoue: result.nombreRoue}};
            } else if (result) {
                this.plElec = result;
            }
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



    callHistorique(params, name) {
        callIP({ inputMap: params, NameIntergation: name })
        .then(result => {
            this.loadTabs = true;
            if(result && result.Result && result.Result.listeDonneesFacturation.length !== 0) {
                if(result.Result.listeDonneesFacturation.length === undefined) {
                    result.Result.listeDonneesFacturation = [result.Result.listeDonneesFacturation];
                }

                 //Select Fourniture Tradeoff Data
                this['dataFournElec'] = result.Result.listeDonneesFacturation.filter(donneFacturation => donneFacturation.secteurActivite.code === "5E" );
                this['dataFournGaz'] = result.Result.listeDonneesFacturation.filter(donneFacturation => donneFacturation.secteurActivite.code === "5G");
                
                this.dataFormatTradeoffElec(this['dataFournElec']);
                this.dataFormatTradeoffGaz(this['dataFournGaz']);
                //
               
                
                // Select Non Tradeoff Data
                this['dataElec'] = result.Result.listeDonneesFacturation.filter(donneFacturation => donneFacturation.secteurActivite.code === "5E");
                this['dataGaz'] = result.Result.listeDonneesFacturation.filter(donneFacturation => donneFacturation.secteurActivite.code === "5G");
               
                //
                let types = ['Elec', 'Gaz'];
                for (let type of types) {
                    let factureCyclique = null;
                    let factureMES = null;
                    let factureResiliation = null;
                    let filtreCat = [];
                    let filtreMotif = [];
                    let filtreLibelleConso = [];
                    if (this['data' + type] && this['data' + type].length > 0) {
                        this['data' + type].sort((a, b) => new Date(b.dateReleve) - new Date(a.dateReleve));
                        for (let item of this['data' + type]) {
                            if(!filtreCat.includes(item.categorieReleve.libelleCourt)) {
                                filtreCat.push(item.categorieReleve.libelleCourt);
                            }
                            if(!filtreMotif.includes(item.motifReleve.libelleCourt)) {
                                filtreMotif.push(item.motifReleve.libelleCourt);
                            }
                            if(!filtreLibelleConso.includes('Consommation Fourniture')) {
                              
                                filtreLibelleConso.push('Consommation Fourniture');
                            }
                            if(!filtreLibelleConso.includes('Consommation Acheminement')) {
                                filtreLibelleConso.push('Consommation Acheminement');
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
                    }
                    if(filtreCat.length > 0) {
                        filtreCat.unshift('Séléctionner tout');
                    }
                    if(filtreMotif.length > 0) {
                        filtreMotif.unshift('Séléctionner tout');
                    }
                    if(filtreLibelleConso.length > 0) {
                        filtreLibelleConso.unshift('Séléctionner tout');
                    }
                    for ( let cat of filtreCat) {
                        this['filtreCategorie' + type].push ( { label: cat, value: cat } )
                    }
                    for ( let motif of filtreMotif) {
                        this['filtreMotif' + type].push ( { label: motif, value: motif } )
                    }
                    for ( let conso of filtreLibelleConso) {
                        this['filtreLibelleConso' + type].push ( { label: conso, value: conso } )
                    }

                   
                    //FT3-67 RG1
                    if(factureResiliation != null && factureCyclique != null && new Date(factureResiliation.dateReleve) > new Date(factureCyclique.dateReleve)){
                        factureCyclique.contestation = false;
                    }
                    //FT3-67 RG2
                    if(factureMES != null && factureResiliation != null && new Date(factureMES.dateReleve) > new Date(factureResiliation.dateReleve)){
                        factureResiliation.contestation = false;
                    }
                    //FT3-67 RG3
                    if(factureCyclique != null && (factureMES != null && new Date(factureCyclique.dateReleve) > new Date(factureMES.dateReleve)) && (factureResiliation != null && new Date(factureCyclique.dateReleve) > new Date(factureResiliation.dateReleve))){
                        factureResiliation.contestation = false;
                    }
                    for (let item of this['data' + type]) {
                        item.dateReleveFormat = item.dateReleve;
                        let temp = item.dateReleve.split("T")[0].split('-');
                        item.dateFinConsommationContestation = (item.dateReleve) ? item.dateReleve.substring(0, 19) : item.dateReleve;
                        item.idFacture = item.numeroFacture;
                        item.dateFinConsommation = temp[2] + '/' + temp[1] + '/' + temp[0];
                        item.dateReleve = temp[2] + '/' + temp[1] + '/' + temp[0];
                        item.indexFin = parseInt(isNaN(item.indexFin) ? 0 :  item.indexFin, 10);
                        item.indexDebut = parseInt(isNaN(item.indexDebut) ? 0 : item.indexDebut, 10);
                        item.consommationKwh = parseInt(isNaN(item.consommationKwh) ? 0 : item.consommationKwh, 10);
                        let signe = item.indexFin < item.indexDebut ? '-' : ''
                        if (type === 'Gaz') {
                            item.quantiteM3 = signe + parseInt(isNaN(item.consommationBrute) ? 0 : item.consommationBrute , 10);
                            item.KPCS = parseFloat(item.KPCS);
                        } else {
                            item.consommationKwh = signe + item.consommationKwh; 
                        }
                    }
                    let i,j,elementByPage = 12;
                    for (i=0,j=this['data' + type].length; i<j; i+=elementByPage) {
                        this[ 'newData' + type ].push(this['data' + type].slice(i,i+elementByPage));
                        // do whatever
                    }
                    this.initPagination(0, type);
                } 
             
            } else if (result.success === false) {
                this.error = true;
            }else {
              this['noDataElec'] = true;
              this['noDataGaz'] = true;
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
       
       
       
        if(type === 'Elec' && this.isTradeOffElec || type === 'Gaz' && this.isTradeOffGaz)
        {
            
             this['dataTrafeOff' + type + 'WithPagination'] = this['newDataproduct' + type+ 'Array'][pageNumber];
            for(let i=0; i< this['newDataproduct' + type+ 'Array'].length; i++) {
                this['pagination' + type].push({number: i+1, selected: i === 0 ? true: false});
            }

           
            
        }
        else {
        this['data' + type + 'WithPagination'] = this[ 'newData' + type ][pageNumber];
        for(let i=0; i< this[ 'newData' + type ].length; i++) {
            this['pagination' + type].push({number: i+1, selected: i === 0 ? true: false});
        }
            
        }
       
       
      
    }

    dataFormatTradeoffElec(dataElecInput){

        //Build a Map where dateReleve is a key (for each unique date we can have multiple rows)
              
                let groupedDataMap = new Map();
               
                dataElecInput.forEach(product => {

                    
                   
                if (groupedDataMap.has(product.dateReleve)) {
                    product.consommationKwh = parseInt(isNaN(product.consommationKwh) ? 0 : product.consommationKwh, 10);
                    let PositivKwh = Math.abs(product.consommationKwh);
                    let consoKwh = (parseInt(isNaN(product.indexFin) ? 0 :  product.indexFin, 10)) < (parseInt(isNaN(product.indexDebut) ? 0 : product.indexDebut, 10)) ? PositivKwh-(PositivKwh*2) : PositivKwh;
                    if(product.grilleReleve.libelleCourt === "CONSO FOURN"){
                    
                    groupedDataMap.get(product.dateReleve).sommeConso += consoKwh;
                    groupedDataMap.get(product.dateReleve).products.push(product);
                }else{
                    groupedDataMap.get(product.dateReleve).isAcheminement = true;
                    groupedDataMap.get(product.dateReleve).sommeConsoAch += consoKwh;
                    groupedDataMap.get(product.dateReleve).productsAch.push(product);

                }
                
            } else {
                let newProduct = {};
                newProduct.products = [];
                newProduct.productsAch = [];
                newProduct.isAcheminement = false; 
                newProduct.sommeConso = 0;
                newProduct.sommeConsoAch = 0;
                newProduct.showHideRowSommeElec = true;
                newProduct.showHideRowDelailsElec = false;
                newProduct.showHideFournElec = true;
                newProduct.showHideDateIdElec = false;
                
                let temp = product.dateReleve.split("T")[0].split('-');
                newProduct.showHideRow = false;

                newProduct.dateReleve =  temp[2] + '/' + temp[1] + '/' + temp[0];
                newProduct.dateReleveFormat = product.dateReleve;
                
                newProduct.dateFinConsommationContestation = (product.dateReleve) ? product.dateReleve.substring(0, 19) : product.dateReleve;
                newProduct.idFacture = product.numeroFacture;
                newProduct.type=product.grilleReleve.libelleCourt;
                product.dateFinConsommation = temp[2] + '/' + temp[1] + '/' + temp[0];
                product.indexFin = parseInt(isNaN(product.indexFin) ? 0 :  product.indexFin, 10);
                product.indexDebut = parseInt(isNaN(product.indexDebut) ? 0 : product.indexDebut, 10);
                product.consommationKwh = parseInt(isNaN(product.consommationKwh) ? 0 : product.consommationKwh, 10);
                product.consommationKwh = product.indexFin < product.indexDebut ? product.consommationKwh-(product.consommationKwh*2) : product.consommationKwh;     

                
                
                if(product.grilleReleve.libelleCourt === "CONSO FOURN"){
                newProduct.sommeConso = product.consommationKwh;
                newProduct.products = [product];
                }else{
                newProduct.isAcheminement = true;
                newProduct.sommeConsoAch = product.consommationKwh;
                newProduct.productsAch = [product];  
                }

                groupedDataMap.set(product.dateReleve, newProduct);
                }
                
              
                });

                let itr = groupedDataMap.values();
                let resultt = itr.next();
                let indexElec = 0;
                //For each date calculate rowspan based o the number of the values
                while (!resultt.done) {

                    indexElec = indexElec + 1;
                    if(indexElec%2 == 0){
                        resultt.value.style = 'FournColorPair';
                        resultt.value.styleP = 'AcheColorPair';
                    }
                    else {
                        resultt.value.style = 'FournColorImPair';
                        resultt.value.styleP = 'AcheColorImpair';
                    }

                   resultt.value.rowspan = resultt.value.products.length + 1;
                   resultt.value.rowspanAch = resultt.value.productsAch.length + 1;
                   
                    
                    this.productArray.push(resultt.value);
                    resultt = itr.next();
                }
               

                let i,j,elementByPage = 12;
                let productElecArrayForPagination = [];

                for (i=0,j=this['productArray'].length; i<j; i+=elementByPage) {

                    productElecArrayForPagination = this['productArray'].slice(i,i+elementByPage);
                    this['newDataproductElecArray'].push(productElecArrayForPagination);

                }
                this.initPagination(0, 'Elec');

    }

    dataFormatTradeoffGaz(dataGazInput){


                let groupedGazDataMap = new Map();
                dataGazInput.forEach(gazproduct => {
                   
                    if (groupedGazDataMap.has(gazproduct.dateReleve)) {

                    groupedGazDataMap.get(gazproduct.dateReleve).gazproducts.push(gazproduct);
                    //calculate the sum of consumptionKWH to reduce de number of "Consommation acheminement" Rows
                    groupedGazDataMap.get(gazproduct.dateReleve).sommeConso += parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    
                    } else {

                    let newgazProduct = {};
                    let temp = gazproduct.dateReleve.split("T")[0].split('-');
                   
                    newgazProduct.dateReleve =  temp[2] + '/' + temp[1] + '/' + temp[0];
                    newgazProduct.showHideRowSommeGaz = true;
                    newgazProduct.showHideRowDelailsGaz = false;
                    newgazProduct.showHideFournGaz = true;
                    newgazProduct.showHideDateId = false;
                    newgazProduct.idFacture = gazproduct.numeroFacture;
                    newgazProduct.sommeConso = parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    gazproduct.indexFin = parseInt(isNaN(gazproduct.indexFin) ? 0 :  gazproduct.indexFin, 10);
                    gazproduct.indexDebut = parseInt(isNaN(gazproduct.indexDebut) ? 0 : gazproduct.indexDebut, 10);
                    gazproduct.consommationKwh = parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    let signe = gazproduct.indexFin < gazproduct.indexDebut ? '-' : ''
                    gazproduct.quantiteM3 = signe + parseInt(isNaN(gazproduct.consommationBrute) ? 0 : gazproduct.consommationBrute , 10);
                    gazproduct.KPCS = parseFloat(gazproduct.KPCS);
                    newgazProduct.gazproducts = [gazproduct];
                    groupedGazDataMap.set(gazproduct.dateReleve, newgazProduct);

                    }
                  
                    });
            

                let itrGaz = groupedGazDataMap.values();
                let resultGaz = itrGaz.next();
                let index = 0;

                while (!resultGaz.done) {

                    //Handling Style
                    index = index + 1;
                    if(index%2 == 0){
                            resultGaz.value.style = 'FournColorPair';
                            resultGaz.value.styleP = 'AcheColorPair';
                    }
                    else {
                            resultGaz.value.style = 'FournColorImPair';
                            resultGaz.value.styleP = 'AcheColorImpair';
                    }

                    resultGaz.value.rowspan = resultGaz.value.gazproducts.length + 1;

                   
                    
                    this.productGazArray.push(resultGaz.value);
                    
                    resultGaz = itrGaz.next();
                }

                 let i,j,elementByPage = 12;
                let productGazArrayForPagination = [];

                for (i=0,j=this['productGazArray'].length; i<j; i+=elementByPage) {

                    productGazArrayForPagination = this['productGazArray'].slice(i,i+elementByPage);
                    this['newDataproductGazArray'].push(productGazArrayForPagination);

                }
                this.initPagination(0, 'Gaz');
    }

   
    pagination (e) {
        let selectedPage = this['pagination' + e.currentTarget.dataset.type].filter(pagination => pagination.number === (parseInt(e.currentTarget.dataset.page, 10) + 1));
        this.resetSelectedPagination(e.currentTarget.dataset.type);
        selectedPage[0].selected = true;
        if(e.currentTarget.dataset.type === 'Elec' && this.isTradeOffElec || e.currentTarget.dataset.type === 'Gaz' && this.isTradeOffGaz){
        this['dataTrafeOff' + e.currentTarget.dataset.type + 'WithPagination'] = this[ 'newDataproduct' + e.currentTarget.dataset.type +'Array'][e.currentTarget.dataset.page];
        }
        else{
        this['data' + e.currentTarget.dataset.type + 'WithPagination'] = this[ 'newData' + e.currentTarget.dataset.type ][e.currentTarget.dataset.page];
    }
    }
    resetSelectedPagination(type) {
        for(const page of this['pagination' + type]) {
            page.selected = false;
        }
    }

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
                isLWC:true,
                EnqSat:this.EnqSat
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
            isLWC:true,
            EnqSat:this.EnqSat
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
            // if(this.idContratElec === this.idContratGaz && !this.dataElec && type === 'Gaz') {
            //     //LIK this.callHistorique({idCompteClient: this.NoCompteContrat, idPDLElec:this.pdl}, 'IP_SM_OperationrechercherDetailFactureElec_SOAP', 'Elec', true);
            //     this.callHistorique({idCompteClient: this.NoCompteContrat}, 'IP_SM_consulterDonneesFacture_SOAP', true);
            // } else {
                let tempType = type === 'Elec' ? 'Gaz' : 'Elec';
                this['indexToContest' + tempType] = this['data' + tempType] ? this['data' + tempType].filter(conso => conso.idFacture === this['indexToContest' + type].idFacture)[0] : '';
                this.openContestationIndex(type);
            // }
        })
        .catch(error => {
            console.log("got error setCache", error);
        });
    }

      contesterIndexTradeoff(e) {
        let type = e.currentTarget.dataset.type;
        let idFacture = e.currentTarget.dataset.idfacture;
        this['indexToContest' + type] = this['dataFourn' + type].filter(conso => conso.idFacture === idFacture)[0];
        setCache().then(r => {
            // if(this.idContratElec === this.idContratGaz && !this.dataElec && type === 'Gaz') {
            //     //LIK this.callHistorique({idCompteClient: this.NoCompteContrat, idPDLElec:this.pdl}, 'IP_SM_OperationrechercherDetailFactureElec_SOAP', 'Elec', true);
            //     this.callHistorique({idCompteClient: this.NoCompteContrat}, 'IP_SM_consulterDonneesFacture_SOAP', true);
            // } else {
                let tempType = type === 'Elec' ? 'Gaz' : 'Elec';
                this['indexToContest' + tempType] = this['dataFourn' + tempType] ? this['dataFourn' + tempType].filter(conso => conso.idFacture === this['indexToContest' + type].idFacture)[0] : '';
                this.openContestationIndex(type);
        //}
        })
        .catch(error => {
            console.log("got error setCache", error);
        });
    }
    openContestationIndex(type) {
        console.log('Open Contestation Index');
        var eventName = "opencontestationindex";
        let donneesDerniersIndexReelGaz = {};
        if ( this.indexToContestGaz ) {
            if(this.isTradeOffGaz){
            donneesDerniersIndexReelGaz = this.dataFournGaz.filter(conso => (conso.categorieReleve.code === '01' || conso.categorieReleve.code === 'ZD'|| conso.categorieReleve.code === 'ZT'|| conso.categorieReleve.code === 'Z4' || conso.categorieReleve.code === 'Z1' || conso.categorieReleve.code === 'Z2' || conso.categorieReleve.code === 'Z3')  && ( (conso !== this.indexToContestGaz && this.indexToContestGaz.categorieReleve.code !== '01') || this.indexToContestGaz.categorieReleve.code === '01' || this.indexToContestGaz.motifReleve.code === '06' || this.indexToContestGaz.motifReleve.code === '03' ))[0];
            }else{
            donneesDerniersIndexReelGaz = this.dataGaz.filter(conso =>  (conso.categorieReleve.code === '01' || conso.categorieReleve.code === 'ZD'|| conso.categorieReleve.code === 'ZT'|| conso.categorieReleve.code === 'Z4' || conso.categorieReleve.code === 'Z1' || conso.categorieReleve.code === 'Z2' || conso.categorieReleve.code === 'Z3') && ( (conso !== this.indexToContestGaz && this.indexToContestGaz.categorieReleve.code !== '01') || this.indexToContestGaz.categorieReleve.code === '01' || this.indexToContestGaz.motifReleve.code === '06' || this.indexToContestGaz.motifReleve.code === '03'  ))[0];
        }
        }
        let days = 15;
        let newDate = new Date(Date.now() + days * 24*60*60*1000);
        let day = newDate.getDate().toString().length === 2 ? newDate.getDate() : '0' + newDate.getDate();
        let month = (newDate.getMonth() + 1).toString().length === 2 ? (newDate.getMonth() + 1) : '0' + (newDate.getMonth() + 1);
        let year = newDate.getFullYear();
        newDate = day + '/' + month + '/' + year;
        const inputMap = {
            type: type,
            contestGaz: (this.indexToContestGaz && typeof(this.indexToContestGaz) === 'object') ? JSON.stringify(this.indexToContestGaz) : this.indexToContestGaz,
            donneesDerniersIndexReelGaz: (donneesDerniersIndexReelGaz && typeof(donneesDerniersIndexReelGaz) === 'object') ? JSON.stringify(donneesDerniersIndexReelGaz) : donneesDerniersIndexReelGaz,
            contestElec: (this.indexToContestElec && typeof(this.indexToContestElec) === 'object') ? JSON.stringify(this.indexToContestElec) : this.indexToContestElec,
            nombreRoue: this.plGaz ? parseInt((isNaN(this.plGaz.nombreRoue) || this.plGaz.nombreRoue.toString().length === 0) ? 0 : this.plGaz.nombreRoue) : '',
            idBusinessPartner: this.IdBusinessPartner,
            pce: this.pce.toString(),
            pdlCommunicantGaz: this.plGaz && this.plGaz.TypeCompteur && this.plGaz.TypeCompteur.split(' ')[1].toUpperCase() === 'GAZPAR' ? true : false,
            factureEnLigne: this.factureEnLigne === true,
            isClientMens: (this.uniteReleveGaz === 'A')? true : false,
            idContratGaz: this.idContratGaz,
            isSoldePositif: this.isSoldePositif,
            IdPortefeuilleContrat: this.IdPortefeuilleContrat,
            NoCompteContrat: this.NoCompteContrat,

            dateBlocage: newDate,
            ModePrelevement: this.ModePrelevement,
            DLP: this.DLP,
            numeroVoie: this.numeroVoie,
            ville: this.ville,
            libelleVoie: this.libelleVoie,
            complementAdresse: this.complementAdresse,
            codePostal: this.codePostal,
            AccountId:this.AccountId
            // isDual: this.idContratElec === this.idContratGaz
        };
        console.log(inputMap);
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
             this['showHideFilterLibelleConso' + this.type] = false;
        } else if(this.filtre.indexOf('Categorie') > -1){
            this['showHideFilterMotif' + this.type] = false;
             this['showHideFilterLibelleConso' + this.type] = false;
        }
        else if(this.filtre.indexOf('LibelleConso') > -1){
             this['showHideFilterCategorie' + this.type] = false;
            this['showHideFilterMotif' + this.type] = false;
        }
        this['showHideFilter' + this.filtre] = !this['showHideFilter' + this.filtre]
    }
    handleChange(e) {
       
        for(let val of e.detail.value) { 
            
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

   

    handleChangeTradeOffGaz(e) {
        
        for(let val of e.detail.value) { 
           
            if (val === 'Séléctionner tout') {
                e.detail.value = ["Séléctionner tout"];
                break;
            }
        }
        this['value' + this.filtre]  = e.detail.value;
       
        let listFiltrer = [];
        this.initDataGazTradeoff();  
        
        if((this['valueCategorie' + this.type].length === 0 && this['valueMotif' + this.type].length === 0 && this['valueLibelleConso' + this.type].length ===0)
        ||
        (this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Séléctionner tout' && (((this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout') || this['valueMotif' + this.type].length === 0) && ((this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Séléctionner tout') || this['valueLibelleConso' + this.type].length === 0)))
        ||
        (this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout' && (((this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Séléctionner tout') || this['valueCategorie' + this.type].length === 0) && ((this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Séléctionner tout') || this['valueLibelleConso' + this.type].length === 0)))
        ||
        (this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Séléctionner tout' && (((this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Séléctionner tout') || this['valueCategorie' + this.type].length === 0) && ((this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout') || this['valueMotif' + this.type].length === 0)))
        ||
        (this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Séléctionner tout' && ((this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout') || this['valueMotif' + this.type].length === 0)))
        {
                  let groupedGazDataMap = new Map();
                 this.productGazArray = [];
                this['dataFournGaz'].forEach(gazproduct => {
                   
                    if (groupedGazDataMap.has(gazproduct.dateReleve)) {
                    groupedGazDataMap.get(gazproduct.dateReleve).gazproducts.push(gazproduct);
                    groupedGazDataMap.get(gazproduct.dateReleve).sommeConso += parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    } else {
                    let newgazProduct = {};
                    //let temp = gazproduct.dateReleve.split("T")[0].split('-');
                   
                    newgazProduct.dateReleve =   gazproduct.dateReleve;
                    newgazProduct.showHideRowSommeGaz = true;
                    newgazProduct.showHideRowDelailsGaz = false;
                    newgazProduct.showHideFournGaz = true;
                    newgazProduct.showHideDateId = false;
                    newgazProduct.idFacture = gazproduct.numeroFacture;
                    newgazProduct.sommeConso = parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    gazproduct.indexFin = parseInt(isNaN(gazproduct.indexFin) ? 0 :  gazproduct.indexFin, 10);
                    gazproduct.indexDebut = parseInt(isNaN(gazproduct.indexDebut) ? 0 : gazproduct.indexDebut, 10);
                    gazproduct.consommationKwh = parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    let signe = gazproduct.indexFin < gazproduct.indexDebut ? '-' : ''
                    gazproduct.quantiteM3 = signe + parseInt(isNaN(gazproduct.consommationBrute) ? 0 : gazproduct.consommationBrute , 10);
                    gazproduct.KPCS = parseFloat(gazproduct.KPCS);
                    newgazProduct.gazproducts = [gazproduct];
                    groupedGazDataMap.set(gazproduct.dateReleve, newgazProduct);
                    }
                    
                  
                    });
            

               

               

                let itrGazz = groupedGazDataMap.values();
                let resultGazz = itrGazz.next();
                let index = 0;
                while (!resultGazz.done) {
                    index = index + 1;

                    console.log(index);

                    if(index%2 == 0){
                            resultGazz.value.style = 'FournColorPair';
                            resultGazz.value.styleP = 'AcheColorPair';
                    }
                    else {
                            resultGazz.value.style = 'FournColorImPair';
                            resultGazz.value.styleP = 'AcheColorImpair';
                    }
                   resultGazz.value.rowspan = resultGazz.value.gazproducts.length + 1;
                   
                    
                    this.productGazArray.push(resultGazz.value);
                    
                    resultGazz = itrGazz.next();
                }
                
               
               
               
            listFiltrer = this['productGazArray'];
           
        }
        else {
          
            for ( let conso of this['productGazArray']) {
               
                if ( this['valueCategorie' + this.type].length > 0 && this['valueLibelleConso' + this.type].length > 0 && this['valueMotif' + this.type].length > 0 /*&& this['valueCategorie' + this.type][0] !== 'Aucun'*/ ) {
                   
                 
                    for(let filter of this['valueCategorie' + this.type]) {
                        
    
                    for(let consoP of conso.gazproducts){
                        if (consoP.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                            if ( this['valueMotif' + this.type].length > 0 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                for(let filter of this['valueMotif' + this.type]) {
                                    if (consoP.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                                                 
                                        if ( this['valueLibelleConso' + this.type].length === 1 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                           
                                            for(let filter of this['valueLibelleConso' + this.type]) {
                                                if (((conso.style === 'FournColorPair' || conso.style === 'FournColorImPair') && filter === 'Consommation Fourniture') /*|| filter === 'Séléctionner tout'*/) {
                                                   
                                                    conso.showHideFournGaz = true;
                                                    conso.showHideRowSommeGaz = false;
                                                    conso.showHideRowDelailsGaz = false;
                                                    conso.showHideDateId = false;
                                                    listFiltrer.push(conso);
                                                    
                        
                                                }
                                                else if (((conso.styleP === 'AcheColorPair' || conso.styleP === 'AcheColorImpair') && filter === 'Consommation Acheminement') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    conso.showHideRowSommeGaz = false;
                                                    conso.showHideRowDelailsGaz = true;
                                                    conso.showHideDateId = true;
                                                    conso.showHideFournGaz = false;
                                                    listFiltrer.push(conso);
                                                    
                        
                                                }
                                                else if (filter === 'Séléctionner tout'){
                                                    conso.showHideRowSommeGaz = true;
                                                    conso.showHideRowDelailsGaz = false;
                                                    conso.showHideDateId = false;
                                                    conso.showHideFournGaz = true;
                                                    listFiltrer.push(conso);
                                                    
                                                }
    
                                            }
                                            
                                        }
                                        else if ( this['valueLibelleConso' + this.type].length === 2 ) {
                
                                            conso.showHideFournGaz = true;
                                            conso.showHideRowSommeGaz = false;
                                            conso.showHideRowDelailsGaz = true;
                                            conso.showHideDateId = false;
                                            listFiltrer.push(conso);
                                            
                    
                                      
                                        }
                                        else{
                                            conso.showHideRowSommeGaz = true;
                                            conso.showHideRowDelailsGaz = false;
                                            conso.showHideDateId = false;
                                            conso.showHideFournGaz = true;
                                            listFiltrer.push(conso);
                                           
                                        }
                            
                                        }
                                        
                                    }
                                    
                                }
                        
                        else {
                        listFiltrer.push(conso);
                        
                        }
                    }
                    }
                }
    
                }
                else if ( this['valueCategorie' + this.type].length > 0 && this['valueLibelleConso' + this.type].length > 0  /*&& this['valueCategorie' + this.type][0] !== 'Aucun'*/ ) {
                    
                 
                    for(let filter of this['valueCategorie' + this.type]) {
                        
    
                    for(let consoP of conso.gazproducts){
                        if (consoP.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {                                                            
                                        if ( this['valueLibelleConso' + this.type].length === 1 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                            
                                            for(let filter of this['valueLibelleConso' + this.type]) {
                                                if (((conso.style === 'FournColorPair' || conso.style === 'FournColorImPair') && filter === 'Consommation Fourniture') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    
                                                    conso.showHideFournGaz = true;
                                                    conso.showHideRowSommeGaz = false;
                                                    conso.showHideRowDelailsGaz = false;
                                                    conso.showHideDateId = false;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                        
                                                }
                                                else if (((conso.styleP === 'AcheColorPair' || conso.styleP === 'AcheColorImpair') && filter === 'Consommation Acheminement') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    
                                                    conso.showHideRowSommeGaz = false;
                                                    conso.showHideRowDelailsGaz = true;
                                                    conso.showHideDateId = true;
                                                    conso.showHideFournGaz = false;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                        
                                                }
                                                else if (filter === 'Séléctionner tout'){
                                                    conso.showHideRowSommeGaz = true;
                                                    conso.showHideRowDelailsGaz = false;
                                                    conso.showHideDateId = false;
                                                    conso.showHideFournGaz = true;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                                                }
    
                                            }
                                           
                                        }
                                        else if ( this['valueLibelleConso' + this.type].length === 2 ) {
                
                                            conso.showHideFournGaz = true;
                                            conso.showHideRowSommeGaz = false;
                                            conso.showHideRowDelailsGaz = true;
                                            conso.showHideDateId = false;
                                            listFiltrer.push(conso);
                                            
                    
                                      
                                        }
                                        else{
                                            conso.showHideRowSommeGaz = true;
                                            conso.showHideRowDelailsGaz = false;
                                            conso.showHideDateId = false;
                                            conso.showHideFournGaz = true;
                                            listFiltrer.push(conso);
                                            
                                        }
                            
                                        
                                        
                                    
                                
                                }
                    }
                }
                
    
                }
                else if ( this['valueMotif' + this.type].length > 0 && this['valueLibelleConso' + this.type].length > 0  /*&& this['valueCategorie' + this.type][0] !== 'Aucun'*/ ) {
                    
                 
                    for(let filter of this['valueMotif' + this.type]) {
                        
    
                    for(let consoP of conso.gazproducts){
                        
                        
                        if (consoP.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                                                                       
                                        if ( this['valueLibelleConso' + this.type].length === 1 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                            
                                            for(let filter of this['valueLibelleConso' + this.type]) {
                                               
                                                if (((conso.style === 'FournColorPair' || conso.style === 'FournColorImPair') && filter === 'Consommation Fourniture') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    
                                                    conso.showHideFournGaz = true;
                                                    conso.showHideRowSommeGaz = false;
                                                    conso.showHideRowDelailsGaz = false;
                                                    conso.showHideDateId = false;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                                                   
                        
                                                }
                                                else if (((conso.styleP === 'AcheColorPair' || conso.styleP === 'AcheColorImpair') && filter === 'Consommation Acheminement') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    
                                                    conso.showHideRowSommeGaz = false;
                                                    conso.showHideRowDelailsGaz = true;
                                                    conso.showHideDateId = true;
                                                    conso.showHideFournGaz = false;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                        
                                                }
                                                else if (filter === 'Séléctionner tout'){
                                                    conso.showHideRowSommeGaz = true;
                                                    conso.showHideRowDelailsGaz = false;
                                                    conso.showHideDateId = false;
                                                    conso.showHideFournGaz = true;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                                                }
    
                                            }
                                            
                                        }
                                        else if ( this['valueLibelleConso' + this.type].length === 2 ) {
                
                                            conso.showHideFournGaz = true;
                                            conso.showHideRowSommeGaz = false;
                                            conso.showHideRowDelailsGaz = true;
                                            conso.showHideDateId = false;
                                            if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                    
                                      
                                        }
                                        else{
                                            conso.showHideRowSommeGaz = true;
                                            conso.showHideRowDelailsGaz = false;
                                            conso.showHideDateId = false;
                                            conso.showHideFournGaz = true;
                                           if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                                        }
                            
                                        
                                        
                                    
                                
                                }
                    }
                }
               
    
                } 
                else if ( this['valueCategorie' + this.type].length > 0 && this['valueMotif' + this.type].length > 0  ) {
                    
                   
                    for(let filter of this['valueCategorie' + this.type]) {
                           
       
                       for(let consoP of conso.gazproducts){
                           if (consoP.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {                                                            
                            if ( this['valueMotif' + this.type].length > 0 ) {
                                for(let filter of this['valueMotif' + this.type]) {
                                    if (consoP.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                         
                                                     
                                                        if(!listFiltrer.includes(conso)){
                                                       listFiltrer.push(conso);
                                                        }
                                                      
                           
                                    }
                                }
                            }
                           
                           }
                        }
                    }
                }
                else if ( this['valueMotif' + this.type].length > 0 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                         
                    for(let filter of this['valueMotif' + this.type]) {
                        
                        
                                    for(let consoP of conso.gazproducts){
                                       
                                        if (consoP.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                            if(!listFiltrer.includes(conso)){
                                            listFiltrer.push(conso);
                                        }
                                            
                                        }
                                    
                                    }
                    }
                          
                }
                else if ( this['valueCategorie' + this.type].length > 0 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                   
                    for(let filter of this['valueCategorie' + this.type]) {
                        for(let consoP of conso.gazproducts){
                        if (consoP.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {

                        
                             if(!listFiltrer.includes(conso)){
                                listFiltrer.push(conso);
                             }
                       
                        }
                    }
                }
                }
                else if ( this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Fourniture') {
                      
                       conso.showHideFournGaz = true;
                       conso.showHideRowSommeGaz = false;
                       conso.showHideRowDelailsGaz = false;
                       conso.showHideDateId = false;
                       if(!listFiltrer.includes(conso)){
                       listFiltrer.push(conso);
                       }

                }
               else if ( this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement') {
                  
                   conso.showHideFournGaz = false;
                   conso.showHideRowSommeGaz = false;
                   conso.showHideRowDelailsGaz = true;
                   conso.showHideDateId = true;
                   listFiltrer.push(conso);

                }
                else if ( this['valueLibelleConso' + this.type].length === 2 || this['valueLibelleConso' + this.type] === 'Séléctionner tout') {
                    
                  
                    conso.showHideFournGaz = true;
                    conso.showHideRowSommeGaz = false;
                    conso.showHideRowDelailsGaz = true;
                    conso.showHideDateId = false;
                    listFiltrer.push(conso);
                    
                    
                }
                
                
                    
            }
        }
        
       
        if ( this['valueMotif' + this.type].length > 0 && !(this['valueMotif' + this.type][0] === 'Séléctionner tout')) {

           
           

            for(let result of listFiltrer ){ 

               

                let fillProductsArray = []; 
               

                if(this['valueLibelleConso' + this.type].length === 2){
                   
                    result.showHideFournGaz = true;
                    result.showHideRowSommeGaz = true;
                    result.showHideRowDelailsGaz = false;
                    result.showHideDateId = false;
                }

                if(this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Fourniture'){
                    result.showHideFournGaz = true;
                    result.showHideRowSommeGaz = false;
                    result.showHideRowDelailsGaz = false;
                    result.showHideDateId = false;
                }
                else if(result.isAcheminement === false){
                    result.showHideFournGaz = true;
                    result.showHideRowSommeGaz = false;
                    result.showHideRowDelailsGaz = false;
                    result.showHideDateId = false;
                }
                
                if(this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement'){

                    result.showHideFournGaz = false;
                    result.showHideRowSommeGaz = false;
                    result.showHideRowDelailsGaz = true;
                    result.showHideDateId = true;
                
                }
                
                else if(result.isAcheminement === true && this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement'){
                    result.showHideFournGaz = false;
                    result.showHideRowSommeGaz = false;
                    result.showHideRowDelailsGaz = true;
                    result.showHideDateId = true;
                }

                if(result.gazproducts.length>0){
                    for(let consoP of result.gazproducts){
                     
                        if ((this['valueMotif' + this.type].includes(consoP.motifReleve.libelleCourt))) {
                           
                            fillProductsArray.push(consoP);


                        }
                    }
                    result.gazproducts = fillProductsArray;
                    result.rowspan = fillProductsArray.length +1;
                }

               
                        

               
            
                 
            }
            
        }

         if ( this['valueCategorie' + this.type].length > 0 && !(this['valueCategorie' + this.type][0] === 'Séléctionner tout')) {

           
           

            for(let result of listFiltrer ){ 

               ;

                let fillProductsArray = []; 


                 if(this['valueLibelleConso' + this.type].length === 2){
                   
                    result.showHideFournGaz = true;
                    result.showHideRowSommeGaz = true;
                    result.showHideRowDelailsGaz = false;
                    result.showHideDateId = false;
                }

                 if(this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Fourniture'){
                    result.showHideFournGaz = true;
                    result.showHideRowSommeGaz = false;
                    result.showHideRowDelailsGaz = false;
                    result.showHideDateId = false;
                }
                else if(result.isAcheminement === false){
                    result.showHideFournGaz = true;
                    result.showHideRowSommeGaz = false;
                    result.showHideRowDelailsGaz = false;
                    result.showHideDateId = false;
                }
                
                if(this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement'){

                    result.showHideFournGaz = false;
                    result.showHideRowSommeGaz = false;
                    result.showHideRowDelailsGaz = true;
                    result.showHideDateId = true;
                
                }
                
                else if(result.isAcheminement === true && this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement'){
                    result.showHideFournGaz = false;
                    result.showHideRowSommeGaz = false;
                    result.showHideRowDelailsGaz = true;
                    result.showHideDateId = true;
                }

                if(result.gazproducts.length>0){
                    for(let consoP of result.gazproducts){
                     
                        if ((this['valueCategorie' + this.type].includes(consoP.categorieReleve.libelleCourt))) {
                           
                            fillProductsArray.push(consoP);


                        }
                    }
                    result.gazproducts = fillProductsArray;
                    result.rowspan = fillProductsArray.length +1;
                }

              


              

               
                        

               
            
                  
            }
            
        }
        
            
        let i,j,elementByPage = 12;
        this['newDataproductGazArray'] =  [];
       
       
        for (i=0,j=listFiltrer.length; i<j; i+=elementByPage) {
           
            this['newDataproductGazArray'].push(listFiltrer.slice(i,i+elementByPage));
        }
       
        this.initPagination(0, 'Gaz');
    }

    handleChangeTradeOffElec(e) {
        console.log(this.productArray);
        for(let val of e.detail.value) { 
           
            if (val === 'Séléctionner tout') {
                e.detail.value = ["Séléctionner tout"];
                break;
            }
        }
        this['value' + this.filtre]  = e.detail.value;
      
        let listFiltrer = [];
        this.initDataElecTradeoff();

      
        
        if((this['valueCategorie' + this.type].length === 0 && this['valueMotif' + this.type].length === 0 && this['valueLibelleConso' + this.type].length ===0)
        ||
        (this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Séléctionner tout' && (((this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout') || this['valueMotif' + this.type].length === 0) && ((this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Séléctionner tout') || this['valueLibelleConso' + this.type].length === 0)))
        ||
        (this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout' && (((this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Séléctionner tout') || this['valueCategorie' + this.type].length === 0) && ((this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Séléctionner tout') || this['valueLibelleConso' + this.type].length === 0)))
        ||
        (this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Séléctionner tout' && (((this['valueCategorie' + this.type].length === 1 && this['valueCategorie' + this.type][0] === 'Séléctionner tout') || this['valueCategorie' + this.type].length === 0) && ((this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout') || this['valueMotif' + this.type].length === 0)))
        ||
        (this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Séléctionner tout' && ((this['valueMotif' + this.type].length === 1 && this['valueMotif' + this.type][0] === 'Séléctionner tout') || this['valueMotif' + this.type].length === 0)))
        {
                 let groupedDataMap = new Map();
                 this.productArray = [];
              
               
                this['dataFournElec'].forEach(product => {
    
                    
                   
                if (groupedDataMap.has(product.dateReleve)) {
                    product.consommationKwh = parseInt(isNaN(product.consommationKwh) ? 0 : product.consommationKwh, 10);
                    let PositivKwh = Math.abs(product.consommationKwh);
                    let consoKwh = (parseInt(isNaN(product.indexFin) ? 0 :  product.indexFin, 10)) < (parseInt(isNaN(product.indexDebut) ? 0 : product.indexDebut, 10)) ? PositivKwh-(PositivKwh*2) : PositivKwh;
                if(product.grilleReleve.libelleCourt === "CONSO FOURN"){
                    
                    groupedDataMap.get(product.dateReleve).sommeConso += consoKwh;
                    groupedDataMap.get(product.dateReleve).products.push(product);
                }else{
                    groupedDataMap.get(product.dateReleve).isAcheminement = true;
                    groupedDataMap.get(product.dateReleve).sommeConsoAch += consoKwh;
                    groupedDataMap.get(product.dateReleve).productsAch.push(product);
    
                }
                
            } else {
                let newProduct = {};
                newProduct.products = [];
                newProduct.productsAch = [];
                newProduct.isAcheminement = false; 
                newProduct.sommeConso = 0;
                newProduct.sommeConsoAch = 0;
                newProduct.showHideRowSommeElec = true;
                newProduct.showHideRowDelailsElec = false;
                newProduct.showHideFournElec = true;
                newProduct.showHideDateIdElec = false;
                //let temp = product.dateReleve.split("T")[0].split('-');
                newProduct.showHideRow = false;
    
                newProduct.dateReleve =  product.dateReleve;
                newProduct.dateReleveFormat = product.dateReleve;
                
                newProduct.dateFinConsommationContestation = (product.dateReleve) ? product.dateReleve.substring(0, 19) : product.dateReleve;
                newProduct.idFacture = product.numeroFacture;
                newProduct.type=product.grilleReleve.libelleCourt;
                product.dateFinConsommation = product.dateReleve;
                product.indexFin = parseInt(isNaN(product.indexFin) ? 0 :  product.indexFin, 10);
                product.indexDebut = parseInt(isNaN(product.indexDebut) ? 0 : product.indexDebut, 10);
                product.consommationKwh = parseInt(isNaN(product.consommationKwh) ? 0 : product.consommationKwh, 10);
                product.consommationKwh = product.indexFin < product.indexDebut ? product.consommationKwh-(product.consommationKwh*2) : product.consommationKwh;     
    
                
                
                if(product.grilleReleve.libelleCourt === "CONSO FOURN"){
                newProduct.sommeConso = product.consommationKwh;
                newProduct.products = [product];
                }else{
                newProduct.isAcheminement = true;
                newProduct.sommeConsoAch = product.consommationKwh;
                newProduct.productsAch = [product];  
                }
    
                groupedDataMap.set(product.dateReleve, newProduct);
                }
                
              
                });
    
                
            
    
               
    
                let itr = groupedDataMap.values();
                let resultt = itr.next();
                let indexElec = 0;
                //For each date calculate rowspan based o the number of the values
                while (!resultt.done) {
    
                    indexElec = indexElec + 1;
                    if(indexElec%2 == 0){
                        resultt.value.style = 'FournColorPair';
                        resultt.value.styleP = 'AcheColorPair';
                    }
                    else {
                        resultt.value.style = 'FournColorImPair';
                        resultt.value.styleP = 'AcheColorImpair';
                    }
    
                   resultt.value.rowspan = resultt.value.products.length + 1;
                   resultt.value.rowspanAch = resultt.value.productsAch.length + 1; 
                    
                    this.productArray.push(resultt.value);
                    resultt = itr.next();
                }
                
               
               
            listFiltrer = this['productArray'];
           
        }
        else {
          
           
         
            for ( let conso of this['productArray']) {
               
                if ( this['valueCategorie' + this.type].length > 0 && this['valueLibelleConso' + this.type].length > 0 && this['valueMotif' + this.type].length > 0 /*&& this['valueCategorie' + this.type][0] !== 'Aucun'*/ ) {
                  
                 
                    for(let filter of this['valueCategorie' + this.type]) {
                        
    
                    for(let consoP of conso.products){
                        if (consoP.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                            if ( this['valueMotif' + this.type].length > 0 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                for(let filter of this['valueMotif' + this.type]) {
                                    if (consoP.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                                                 
                                        if ( this['valueLibelleConso' + this.type].length === 1 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                           
                                            for(let filter of this['valueLibelleConso' + this.type]) {
                                                if (((conso.style === 'FournColorPair' || conso.style === 'FournColorImPair') && filter === 'Consommation Fourniture') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    conso.showHideFournElec = true;
                                                    conso.showHideRowSommeElec = false;
                                                    conso.showHideRowDelailsElec = false;
                                                    conso.showHideDateIdElec = false;
                                                    if(!listFiltrer.includes(conso)){
                                                        listFiltrer.push(conso);
                                                    }
                                                   
                        
                                                }
                                                else if (((conso.styleP === 'AcheColorPair' || conso.styleP === 'AcheColorImpair') && filter === 'Consommation Acheminement') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    conso.showHideRowSommeElec = false;
                                                    conso.showHideRowDelailsElec = true;
                                                    conso.showHideDateIdElec = true;
                                                    conso.showHideFournElec = false;
                                                     if(!listFiltrer.includes(conso)){
                                                        listFiltrer.push(conso);
                                                    }
                                                   
                        
                                                }
                                                else if (filter === 'Séléctionner tout'){
                                                    conso.showHideRowSommeElec = true;
                                                    conso.showHideRowDelailsElec = false;
                                                    conso.showHideDateIdElec = false;
                                                    conso.showHideFournElec = true;
                                                    listFiltrer.push(conso);
                                                   
                                                }
    
                                            }
                                          
                                        }
                                        else if ( this['valueLibelleConso' + this.type].length === 2 ) {
                
                                            conso.showHideFournElec = true;
                                            conso.showHideRowSommeElec = false;
                                            conso.showHideRowDelailsElec = true;
                                            conso.showHideDateIdElec = false;
                                            listFiltrer.push(conso);
                                          
                    
                                      
                                        }
                                        else{
                                            conso.showHideRowSommeElec = true;
                                            conso.showHideRowDelailsElec = false;
                                            conso.showHideDateIdElec = false;
                                            conso.showHideFournElec = true;
                                            listFiltrer.push(conso);
                                           
                                        }
                            
                                        }
                                        
                                    }
                                   
                                }
                        
                        else {
                        listFiltrer.push(conso);
                        
                        }
                    }
                    }
                }
               
    
                }
                else if ( this['valueCategorie' + this.type].length > 0 && this['valueLibelleConso' + this.type].length > 0  /*&& this['valueCategorie' + this.type][0] !== 'Aucun'*/ ) {
                    
                
                    for(let filter of this['valueCategorie' + this.type]) {
                        
    
                    for(let consoP of conso.products){
                        if (consoP.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {                                                            
                                        if ( this['valueLibelleConso' + this.type].length === 1 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                            
                                            for(let filter of this['valueLibelleConso' + this.type]) {
                                                if (((conso.style === 'FournColorPair' || conso.style === 'FournColorImPair') && filter === 'Consommation Fourniture') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                 
                                                    conso.showHideFournElec = true;
                                                    conso.showHideRowSommeElec = false;
                                                    conso.showHideRowDelailsElec = false;
                                                    conso.showHideDateIdElec = false;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                        
                                                }
                                                else if (((conso.styleP === 'AcheColorPair' || conso.styleP === 'AcheColorImpair') && filter === 'Consommation Acheminement') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    
                                                    conso.showHideRowSommeElec = false;
                                                    conso.showHideRowDelailsElec = true;
                                                    conso.showHideDateIdElec = true;
                                                    conso.showHideFournElec = false;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                        
                                                }
                                                else if (filter === 'Séléctionner tout'){
                                                    conso.showHideRowSommeElec = true;
                                                    conso.showHideRowDelailsElec = false;
                                                    conso.showHideDateIdElec = false;
                                                    conso.showHideFournElec = true;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                                                }
    
                                            }
                                           
                                        }
                                        else if ( this['valueLibelleConso' + this.type].length === 2 ) {
                
                                            conso.showHideFournElec = true;
                                            conso.showHideRowSommeElec = false;
                                            conso.showHideRowDelailsElec = true;
                                            conso.showHideDateIdElec = false;
                                            listFiltrer.push(conso);
                                           
                    
                                      
                                        }
                                        else{
                                            conso.showHideRowSommeElec = true;
                                            conso.showHideRowDelailsElec = false;
                                            conso.showHideDateIdElec = false;
                                            conso.showHideFournElec = true;
                                            listFiltrer.push(conso);
                                          
                                        }
                            
                                        
                                        
                                    
                                
                                }
                    }
                }
                
    
                }
                else if ( this['valueMotif' + this.type].length > 0 && this['valueLibelleConso' + this.type].length > 0  /*&& this['valueCategorie' + this.type][0] !== 'Aucun'*/ ) {
                    
                
                    for(let filter of this['valueMotif' + this.type]) {
                        
    
                    for(let consoP of conso.products){
                       
                        
                        if (consoP.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                                                                   
                                        if ( this['valueLibelleConso' + this.type].length === 1 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                                            
                                            for(let filter of this['valueLibelleConso' + this.type]) {
                                               
                                                if (((conso.style === 'FournColorPair' || conso.style === 'FournColorImPair') && filter === 'Consommation Fourniture') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                  
                                                    conso.showHideFournElec = true;
                                                    conso.showHideRowSommeElec = false;
                                                    conso.showHideRowDelailsElec = false;
                                                    conso.showHideDateIdElec = false;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                                                   
                        
                                                }
                                                else if (((conso.styleP === 'AcheColorPair' || conso.styleP === 'AcheColorImpair') && filter === 'Consommation Acheminement') /*|| filter === 'Séléctionner tout'*/) {
                                                    
                                                    
                                                    conso.showHideRowSommeElec = false;
                                                    conso.showHideRowDelailsElec = true;
                                                    conso.showHideDateIdElec = true;
                                                    conso.showHideFournElec = false;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                        
                                                }
                                                else if (filter === 'Séléctionner tout'){
                                                    conso.showHideRowSommeElec = true;
                                                    conso.showHideRowDelailsElec = false;
                                                    conso.showHideDateIdElec = false;
                                                    conso.showHideFournElec = true;
                                                    if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                                                }
    
                                            }
                                            
                                        }
                                        else if ( this['valueLibelleConso' + this.type].length === 2 ) {
                
                                            conso.showHideFournElec = true;
                                            conso.showHideRowSommeElec = true;
                                            conso.showHideRowDelailsElec = false;
                                            conso.showHideDateIdElec = false;
                                            if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                    
                                      
                                        }
                                        else{
                                            conso.showHideRowSommeElec = true;
                                            conso.showHideRowDelailsElec = false;
                                            conso.showHideDateIdElec = false;
                                            conso.showHideFournElec = true;
                                           if(!listFiltrer.includes(conso)){
                                                    listFiltrer.push(conso);
                                                    }
                                        }
                            
                                        
                                        
                                    
                                
                                }
                    }
                }
              
    
                } 
                else if ( this['valueCategorie' + this.type].length > 0 && this['valueMotif' + this.type].length > 0  ) {
                    
                   
                    for(let filter of this['valueCategorie' + this.type]) {
                           
       
                       for(let consoP of conso.products){
                           if (consoP.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {                                                            
                            if ( this['valueMotif' + this.type].length > 0 ) {
                                for(let filter of this['valueMotif' + this.type]) {
                                    if (consoP.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                         
                                                   
                                                        if(!listFiltrer.includes(conso)){
                                                       listFiltrer.push(conso);
                                                        }
                                                      
                           
                                    }
                                }
                            }
                           
                           }
                        }
                    }
                }
                else if ( this['valueMotif' + this.type].length > 0 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                           
                    for(let filter of this['valueMotif' + this.type]) {
                       
                        
                                    for(let consoP of conso.products){
                                      
                                        if (consoP.motifReleve.libelleCourt === filter || filter === 'Séléctionner tout') {
                                            if(!listFiltrer.includes(conso)){
                                            listFiltrer.push(conso);
                                        }
                                            
                                        }
                                   
                                    }
                    }
                          
                }
                else if ( this['valueCategorie' + this.type].length > 0 /*&& this['valueMotif' + this.type][0] !== 'Aucun'*/) {
                   
                    for(let filter of this['valueCategorie' + this.type]) {
                        for(let consoP of conso.products){
                        if (consoP.categorieReleve.libelleCourt === filter || filter === 'Séléctionner tout') {

                           if(!listFiltrer.includes(conso)){
                                listFiltrer.push(conso);
                            }
                        
                      
                        }
                    }
                }
                }
                else if ( this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Fourniture') {
                     
                       conso.showHideFournElec = true;
                       conso.showHideRowSommeElec = false;
                       conso.showHideRowDelailsElec = false;
                       conso.showHideDateIdElec = false;
                       if(!listFiltrer.includes(conso)){
                       listFiltrer.push(conso);
                       }

                }
               else if ( this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement') {
                  
                   conso.showHideFournElec = false;
                   conso.showHideRowSommeElec = false;
                   conso.showHideRowDelailsElec = true;
                   conso.showHideDateIdElec = true;
                   listFiltrer.push(conso);

                }
                else if ( this['valueLibelleConso' + this.type].length === 2 || this['valueLibelleConso' + this.type] === 'Séléctionner tout') {
                    
                   
                    conso.showHideFournElec = true;
                    conso.showHideRowSommeElec = true;
                    conso.showHideRowDelailsElec = false;
                    conso.showHideDateIdElec = false;
                    listFiltrer.push(conso);
                    
                    
                }
                
                
                    
            }
        }
        
      
        if ( this['valueMotif' + this.type].length > 0 && !(this['valueMotif' + this.type][0] === 'Séléctionner tout')) {

           
           

            for(let result of listFiltrer ){ 

               

                let fillProductsArray = []; 
                let fillProductsArrayAche = [];

                if(this['valueLibelleConso' + this.type].length === 2){
                  
                    result.showHideFournElec = true;
                    result.showHideRowSommeElec = true;
                    result.showHideRowDelailsElec = false;
                    result.showHideDateIdElec = false;
                }


                if(this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Fourniture'){
                   
                    result.showHideFournElec = true;
                    result.showHideRowSommeElec = false;
                    result.showHideRowDelailsElec = false;
                    result.showHideDateIdElec = false;
                }
                else if(result.isAcheminement === false){
                    result.showHideFournElec = true;
                    result.showHideRowSommeElec = false;
                    result.showHideRowDelailsElec = false;
                    result.showHideDateIdElec = false;
                }
                
                if(this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement'){
                   
                    result.showHideFournElec = false;
                    result.showHideRowSommeElec = false;
                    result.showHideRowDelailsElec = true;
                    result.showHideDateIdElec = true;
                
                }
                
                else if(result.isAcheminement === true && this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement'){
                    result.showHideFournElec = false;
                    result.showHideRowSommeElec = false;
                    result.showHideRowDelailsElec = true;
                    result.showHideDateIdElec = true;
                }

                if(result.products.length>0){
                    for(let consoP of result.products){
                     
                        if ((this['valueMotif' + this.type].includes(consoP.motifReleve.libelleCourt))) {
                            
                            fillProductsArray.push(consoP);


                        }
                    }
                    result.products = fillProductsArray;
                    result.rowspan = fillProductsArray.length +1;
                }

                if(result.productsAch.length>0){

                    for(let conso of result.productsAch){

                            if ((this['valueMotif' + this.type].includes(conso.motifReleve.libelleCourt))){
                            fillProductsArrayAche.push(conso);
                        }
                    }
                
                    result.productsAch = fillProductsArrayAche;
                    result.rowspanAch = fillProductsArrayAche.length +1;
                }
                        

               
            
               
            }
            
        }

         if ( this['valueCategorie' + this.type].length > 0 && !(this['valueCategorie' + this.type][0] === 'Séléctionner tout')) {

           
           

            for(let result of listFiltrer ){ 

             

                let fillProductsArray = []; 
                let fillProductsArrayAche = [];


                if(this['valueLibelleConso' + this.type].length === 2){
                   
                     result.showHideFournElec = true;
                    result.showHideRowSommeElec = true;
                    result.showHideRowDelailsElec = false;
                    result.showHideDateIdElec = false;
                }
                
                
                if(this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Fourniture'){
                    
                    result.showHideFournElec = true;
                    result.showHideRowSommeElec = false;
                    result.showHideRowDelailsElec = false;
                    result.showHideDateIdElec = false;
                }
                else if(result.isAcheminement === false){
                    result.showHideFournElec = true;
                    result.showHideRowSommeElec = false;
                    result.showHideRowDelailsElec = false;
                    result.showHideDateIdElec = false;
                }
                
                if(this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement'){
                  
                    result.showHideFournElec = false;
                    result.showHideRowSommeElec = false;
                    result.showHideRowDelailsElec = true;
                    result.showHideDateIdElec = true;
                
                }
                
                else if(result.isAcheminement === true && this['valueLibelleConso' + this.type].length === 1 && this['valueLibelleConso' + this.type][0] === 'Consommation Acheminement'){
                    result.showHideFournElec = false;
                    result.showHideRowSommeElec = false;
                    result.showHideRowDelailsElec = true;
                    result.showHideDateIdElec = true;
                }

                

                if(result.products.length>0){
                    for(let consoP of result.products){
                     
                        if ((this['valueCategorie' + this.type].includes(consoP.categorieReleve.libelleCourt))) {
                          
                            fillProductsArray.push(consoP);


                        }
                    }
                    result.products = fillProductsArray;
                    result.rowspan = fillProductsArray.length +1;
                }

                if(result.productsAch.length>0){

                    for(let conso of result.productsAch){

                            if ((this['valueCategorie' + this.type].includes(conso.categorieReleve.libelleCourt))){
                            fillProductsArrayAche.push(conso);
                        }
                    }
                
                    result.productsAch = fillProductsArrayAche;
                    result.rowspanAch = fillProductsArrayAche.length +1;
                }
                        

               
            
                  
            }
            
        }
        
            
        let i,j,elementByPage = 12;
        this['newDataproductElecArray'] =  [];
       
        for (i=0,j=listFiltrer.length; i<j; i+=elementByPage) {
           
            this['newDataproductElecArray'].push(listFiltrer.slice(i,i+elementByPage));
        }
    
        this.initPagination(0, 'Elec');
    }



    // Show / Hide Acheminement Details
    toggle(event) {

        let date = event.target.dataset.date;

        this['productGazArray'].forEach(product => {
            if(product.dateReleve == date ){

                product.showHideRowSommeGaz=!product.showHideRowSommeGaz;
                product.showHideRowDelailsGaz=!product.showHideRowDelailsGaz; 

                
            }
        });

        this['productArray'].forEach(product => {
            if(product.dateReleve == date){
            
                product.showHideRowSommeElec=!product.showHideRowSommeElec;
                product.showHideRowDelailsElec=!product.showHideRowDelailsElec;
            }

        });
        
       }


    initDataElecTradeoff(){
         let groupedDataMap = new Map();
                 this.productArray = [];
                 
               
                this['dataFournElec'].forEach(product => {
    
                    
                   
                if (groupedDataMap.has(product.dateReleve)) {
                    product.consommationKwh = parseInt(isNaN(product.consommationKwh) ? 0 : product.consommationKwh, 10);
                    let PositivKwh = Math.abs(product.consommationKwh);
                    let consoKwh = (parseInt(isNaN(product.indexFin) ? 0 :  product.indexFin, 10)) < (parseInt(isNaN(product.indexDebut) ? 0 : product.indexDebut, 10)) ? PositivKwh-(PositivKwh*2) : PositivKwh;
                if(product.grilleReleve.libelleCourt === "CONSO FOURN"){
                    
                    groupedDataMap.get(product.dateReleve).sommeConso += consoKwh;
                    groupedDataMap.get(product.dateReleve).products.push(product);
                }else{
                    groupedDataMap.get(product.dateReleve).isAcheminement = true;
                    groupedDataMap.get(product.dateReleve).sommeConsoAch += consoKwh;
                    groupedDataMap.get(product.dateReleve).productsAch.push(product);
    
                }
                
            } else {
                let newProduct = {};
                newProduct.products = [];
                newProduct.productsAch = [];
                newProduct.isAcheminement = false; 
                newProduct.sommeConso = 0;
                newProduct.sommeConsoAch = 0;
                newProduct.showHideRowSommeElec = true;
                newProduct.showHideRowDelailsElec = false;
                newProduct.showHideFournElec = true;
                newProduct.showHideDateIdElec = false;
                //let temp = product.dateReleve.split("T")[0].split('-');
                newProduct.showHideRow = false;
    
                newProduct.dateReleve =  product.dateReleve;
                newProduct.dateReleveFormat = product.dateReleve;
                
                newProduct.dateFinConsommationContestation = (product.dateReleve) ? product.dateReleve.substring(0, 19) : product.dateReleve;
                newProduct.idFacture = product.numeroFacture;
                newProduct.type=product.grilleReleve.libelleCourt;
                product.dateFinConsommation = product.dateReleve;
                product.indexFin = parseInt(isNaN(product.indexFin) ? 0 :  product.indexFin, 10);
                product.indexDebut = parseInt(isNaN(product.indexDebut) ? 0 : product.indexDebut, 10);
                product.consommationKwh = parseInt(isNaN(product.consommationKwh) ? 0 : product.consommationKwh, 10);
                product.consommationKwh = product.indexFin < product.indexDebut ? product.consommationKwh-(product.consommationKwh*2) : product.consommationKwh;     
    
                
                
                if(product.grilleReleve.libelleCourt === "CONSO FOURN"){
                newProduct.sommeConso = product.consommationKwh;
                newProduct.products = [product];
                }else{
                newProduct.isAcheminement = true;
                newProduct.sommeConsoAch = product.consommationKwh;
                newProduct.productsAch = [product];  
                }
    
                groupedDataMap.set(product.dateReleve, newProduct);
                }
                
              
                });
    
                
            
    
               
    
                let itr = groupedDataMap.values();
                let resultt = itr.next();
                let indexElec = 0;
                //For each date calculate rowspan based o the number of the values
                while (!resultt.done) {
    
                    indexElec = indexElec + 1;
                    if(indexElec%2 == 0){
                        resultt.value.style = 'FournColorPair';
                        resultt.value.styleP = 'AcheColorPair';
                    }
                    else {
                        resultt.value.style = 'FournColorImPair';
                        resultt.value.styleP = 'AcheColorImpair';
                    }
    
                   resultt.value.rowspan = resultt.value.products.length + 1;
                   resultt.value.rowspanAch = resultt.value.productsAch.length + 1; 
                    
                    this.productArray.push(resultt.value);
                    resultt = itr.next();
                }
    }
    
     initDataGazTradeoff(){
                          let groupedGazDataMap = new Map();
                 this.productGazArray = [];
                this['dataFournGaz'].forEach(gazproduct => {
                   
                    if (groupedGazDataMap.has(gazproduct.dateReleve)) {
                    groupedGazDataMap.get(gazproduct.dateReleve).gazproducts.push(gazproduct);
                    groupedGazDataMap.get(gazproduct.dateReleve).sommeConso += parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    } else {
                    let newgazProduct = {};
                    //let temp = gazproduct.dateReleve.split("T")[0].split('-');
                   
                    newgazProduct.dateReleve =   gazproduct.dateReleve;
                    newgazProduct.showHideRowSommeGaz = true;
                    newgazProduct.showHideRowDelailsGaz = false;
                    newgazProduct.showHideFournGaz = true;
                    newgazProduct.showHideDateId = false;
                    newgazProduct.idFacture = gazproduct.numeroFacture;
                    newgazProduct.sommeConso = parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    gazproduct.indexFin = parseInt(isNaN(gazproduct.indexFin) ? 0 :  gazproduct.indexFin, 10);
                    gazproduct.indexDebut = parseInt(isNaN(gazproduct.indexDebut) ? 0 : gazproduct.indexDebut, 10);
                    gazproduct.consommationKwh = parseInt(isNaN(gazproduct.consommationKwh) ? 0 : gazproduct.consommationKwh, 10);
                    let signe = gazproduct.indexFin < gazproduct.indexDebut ? '-' : ''
                    gazproduct.quantiteM3 = signe + parseInt(isNaN(gazproduct.consommationBrute) ? 0 : gazproduct.consommationBrute , 10);
                    gazproduct.KPCS = parseFloat(gazproduct.KPCS);
                    newgazProduct.gazproducts = [gazproduct];
                    groupedGazDataMap.set(gazproduct.dateReleve, newgazProduct);
                    }
                    
                  
                    });
            

               

               

                let itrGazz = groupedGazDataMap.values();
                let resultGazz = itrGazz.next();
                let index = 0;
                while (!resultGazz.done) {
                    index = index + 1;

                    console.log(index);

                    if(index%2 == 0){
                            resultGazz.value.style = 'FournColorPair';
                            resultGazz.value.styleP = 'AcheColorPair';
                    }
                    else {
                            resultGazz.value.style = 'FournColorImPair';
                            resultGazz.value.styleP = 'AcheColorImpair';
                    }
                   resultGazz.value.rowspan = resultGazz.value.gazproducts.length + 1;
                   
                    
                    this.productGazArray.push(resultGazz.value);
                    
                    resultGazz = itrGazz.next();
                }
    }

   
}