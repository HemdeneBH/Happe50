import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { LightningElement, api, track} from 'lwc';
import { getDataHandler } from "vlocity_cmt/utility";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SM_SituationCompte extends OmniscriptBaseMixin(LightningElement) {
    @api recordId;
    @api factures= [];// la liste des factures (histoFacture)
    @api IdBusinessPartner;
    @api IdPortefeuilleContrat;
    @api NoCompteContratMaj;
    @track tabledata= [];//les données à afficher dans le tableau (factures+règlements)
    @track tdPagination= [];
    @track currentPage=[];
    @track paginationIndex=[];
    @track noData= true;
    @track showFilterIcon =true;
    @track error = false;
    @track tableLimit=12;
    @track showInfoModal = false;

    @track dateRejetPrel;
    @track motifRejetPrel;
    @track dateRejetExists = false;
    @track motifRejetExists = false;
    @track motifsRefus = [];
    // FT2-1651 Situation de compte-RSSI-Cryptage IBAN 2/3 : Affichage de la pop up pour la pièce comptable EP
    @track IbanCrypted;
    @track showSpinnerIban = false;

    @track typePieceIsPrel = false;
    @track typePieceIsRC = false;

    transcoTypePiece = {
        E: 'Règlement',
        R: 'Règlement Engie'
    };
    transcoTypeReglement = {
        EA: 'Espèce',
        EB: 'CB',
        EC: 'Espèce',
        EE: 'TIP',
        EG: 'Chèque',
        EI: 'CB',
        EJ: 'Chèque Energie',
        EK: 'CB en ligne - portail client',
        EL: 'CB par téléphone',
        EM: 'Espèce',
        EP: 'Prélèvement',
        ES: 'Chèque',
        ET: 'TIP',
        EV: 'Virement',
        EW: 'Virement',
        RC: 'Chèque',
        RV: 'Virement',
        CE: 'Chèque Energie',
        EO: 'E-TIP',
        ER: 'Espèce',
        AB: 'Pièce générale',
        PR: 'Règlement recouvrement'
    };
    //des variabless pour la tri est les filtres
    @track tableBackup =[];
    @track filters= [];
    @track hasFilters= false;
    @track compareField='orderDate';
    @track orderDirection='asc';  
    @track orderColumn = {
        DEF : {
            isAsc : true
        },
        DR : {
            isAsc: false
        }
    }
    @track filterVisiblility={
        type:false,
        libFacture:false,
        typeReg:false
    }
    //FT2-1376 -> Modification libellés pour le ttype de réglement.
    // EL -> CB par téléphone et EK -> CB en ligne - portail client 
    @track filtreOptions={
        type:[
            { label: 'Tous', value: 'Tous' },
            { label: 'Facture', value: 'Facture' },
            { label: 'Règlement', value: 'Règlement' },
            { label: 'Règlement Engie', value: 'Règlement Engie' }],
        libFacture:[
            { label: 'Tous', value: 'Tous' },
            { label: 'Facture périodique', value: 'Facture périodique' },
            { label: 'Facture intermédiaire', value: 'Facture intermédiaire' },
            { label: 'Facture rectificative', value: 'Facture rectificative' },
            { label: 'Facture de résiliation', value: 'Facture de résiliation' },
            { label: 'Facture de régularisation', value: 'Facture de régularisation' },
            { label: 'Facture', value: 'Facture' },
            { label: 'Facture de Souscription', value: 'Facture de Souscription' }],
        typeReg:[
            { label: 'Tous', value: 'Tous' },
            { label: 'Chèque', value: 'Chèque' },
            { label: 'Prélèvement', value: 'Prélèvement' },
            { label: 'CB par téléphone', value: 'CB par téléphone' },
            { label: 'CB en ligne - portail client', value: 'CB en ligne - portail client' },
            { label: 'Espèce', value: 'Espèce' },
            { label: 'TIP', value: 'TIP' },
            { label: 'E-TIP', value: 'E-TIP' },
            { label: 'Chèque Energie', value: 'Chèque Energie' },

            { label: 'Virement', value: 'Virement' },
            { label: 'Pièce générale', value: 'Pièce générale'},
            { label: 'Règlement recouvrement', value:'Règlement recouvrement'}]

    }
    @track columnFilters ={
        type:["Facture","Règlement","Règlement Engie"],
        libFacture:['Facture périodique','Facture intermédiaire','Facture rectificative','Facture de résiliation','Facture de régularisation','Facture de Souscription','Facture'],

        typeReg:['Chèque','Prélèvement','CB','Espèce','TIP','E-TIP','Chèque Energie','Virement','Pièce générale','Règlement recouvrement']

    };
    @track filtreValues={
        type:[],
        libFacture:[],
        typeReg:[]
    }
    /* préparation des données factures */
    filterDataFactures(data){
        console.log("data",JSON.stringify(data));
        //filtrage des factures
        for(var i=0;i<data.length;i++){
            if(parseFloat(data[i].montantTotal) >= 0)
                data[i].isDebit=true;
            else 
                data[i].isDebit=false;
            if(!data[i].typeCalcul || data[i].typeCalcul =='')
                data[i].typeCalcul ='Facture';
            data[i].orderDate=data[i].dateComptable;
            data[i].typePiece='Facture';
            data[i].isFacture = true;
        }
        console.log("data",JSON.stringify(data));
        return data;
    }

    get showSpinner() {
        return this.DRId_Case || (this.factures && this.factures.length > 0  && this.gotalllinks === true ) || this.noData  || this.error || this.factures.length==0 ;
      }

    // get facture Link
    getFactureLink(data){
        let ind = 0;
        for(const item of data){
          item.montantTotal = item.montantTotal.toFixed(2).replace(".",",");
          if(item.codeTypeCalcul === '06'){
            item.typeCalcul = 'Facture de Souscription';
          }
          item.factureLink = '';
          const params = {
                input: JSON.stringify({
                    idFacture:item.id                    
                }),
                sClassName: 'SM_AP04_FacturesApiService',
                sMethodName: 'callFactureLinkLWC',
                options: '{}',
            };
            this.omniRemoteCall(params)
            .then(res => {
                if(res.result.result && res.result.result.data) {
                    item.factureLink=res.result.result.data[0].url;
                }
                ind++;
                if (this.factures.length === ind) this.gotalllinks = true;
            });
        }
        return data;
      }
    /* methodes de pagination */
    pageSlice(data,elementByPage){
        let result=[];
        for(let i=0; i<data.length; i+=elementByPage) {
            result.push(data.slice(i,i+elementByPage));
        }
        this.paginationIndex=[];
        for(let i=0; i< result.length; i++) {
            this.paginationIndex.push({number: i+1, selected: i === 0 ? true: false});
        }
        return result;
    } 
    pagination (e) {
        let selectedPage = this.paginationIndex.filter(pagination => pagination.number === (parseInt(e.currentTarget.dataset.page, 10) + 1));
        this.resetSelectedPagination(e.currentTarget.dataset.type);
        selectedPage[0].selected = true;
        this.currentPage= this.tdPagination[e.currentTarget.dataset.page];
    }
    resetSelectedPagination(type) {
        for(const page of this.paginationIndex ) {
            page.selected = false;
        }
    }
    format10FirstDigitOfDate(d) {
        // On vérifie si on a vraiement une date
        let dd = Date.parse(d) || 0;
        if (dd) {
            let date = new Date(d);
            return date.getFullYear() + '-' + ("0" + (date.getMonth()+1)).slice(-2) + '-' + ("0" + date.getDate()).slice(-2);
        } else {
            return '';
        }
    }
    filterDataPaiement(e) {
        let listPaiement = [];
        if(e) {
            for (const item of e) {
                if (item.typePaiement && item.typePaiement.code in this.transcoTypePiece) {
                    let data = {};
                    data.orderDate = this.format10FirstDigitOfDate(item.dateComptable);
                    data.dateReglement = this.format10FirstDigitOfDate(item.datePaiement);
                    data.typePieceCode = item.typePaiement.code;
                    data.typePiece = this.transcoTypePiece[item.typePaiement.code];
                    data.typeReglementCode = item.typePiece.code;
                    data.typeReglement = this.transcoTypeReglement[item.typePiece.code];
                    data.paiementRejete = (item.motifRejet && item.motifRejet.code && item.dateRejet) ? true : false;
                    data.statutReglement = data.paiementRejete ? 'Rejeté' : 'Payé';
                    data.montantTotal = item.montantTTC;

                    //FT2-1599 -> [Situation de compte]-Motif de rejet de prélèvement
                    //Récupération de la date de rejet
                    if (data.paiementRejete) {

                        //Changement du format de la date de rejet (AAAA-MM-JJTHH:MM:SS -> JJ/MM/AAAA)
                        let timeRemoved = item.dateRejet.split("T")[0];
                        let dateSplitted = timeRemoved.split("-");
                        let dateRejetFormatted = dateSplitted[2] + '/' + dateSplitted[1] + '/' + dateSplitted[0]

                        //Affectation de la date de rejet à la table des données
                        data.dateRejet = dateRejetFormatted;

                        //Affection du motif de rejet selon le code de rejet
                        let motifFound = false;
                        for (var i=0; i<this.motifsRefus.length; i++){
                            if (item.motifRejet.code === this.motifsRefus[i].code) {
                                data.motifRejet = this.motifsRefus[i].libelle; 
                                motifFound = true;
                            }
                        }

                        if (!motifFound) data.motifRejet = item.motifRejet.libelleCourt;
                    }


                    if (item.typePaiement.code === 'R') {
                        data.isDebit = !data.rejetPaiement;
                    }
                    if (item.typePaiement.code === 'E') {
                        data.isDebit = data.rejetPaiement;
                    }
                    //FT2-1644 Colonne dans laquelle une icône “i” est visible pour la pièce de type de règlement - Prélèvement rejeté EP
                    if (data.typeReglementCode === 'EP' && data.paiementRejete) {
                        data.isPrel = true;
                    }
                    
                    //FT2-1600 Colonne dans laquelle une icône “i” est visible pour la pièce de type de règlement - Chèque de remboursement rejeté RC
                    if (data.typeReglementCode === 'RC' && data.paiementRejete) {
                        data.isRC = true;
                    }
                    data.isPaiement = true;
                    data.classCSS = 'lignePaiement';
                    listPaiement.push(data);
                }
            }
        }
        return listPaiement;
    }
    /* une methode d'ordonancement des lignes de tableau*/
    dynamicSort(field,order){
        return function(a,b) {
            if(order=='asc')
            return ( Date.parse(a[field]) < Date.parse(b[field]) )?-1:( Date.parse(a[field]) > Date.parse(b[field]) )?1:0;
        else 
            return ( Date.parse(a[field]) < Date.parse(b[field]) )?1:( Date.parse(a[field]) > Date.parse(b[field]) )?-1:0;
        }
    }
    addFilterItem(column,valuesArray){
        for(let value of valuesArray)
            if(this.filters.findIndex(obj => obj.column ==column && obj.value == value)==-1){
                if(column =='libFacture' && value =='Facture')
                    this.filters.push({"column":column,"value":value,"alternativeTitle":"Libellé: Facture"});
                else
                    this.filters.push({"column":column,"value":value});
            }
            console.log("this.filters==",JSON.stringify(this.filters));
    }
    orderHandler(e){
        this.orderColumn[e.currentTarget.dataset.orderby].isAsc=(e.currentTarget.dataset.order!='asc')?true:false;
        //ajouter filtre si réglement 
        if(e.currentTarget.dataset.orderby=='DR' && this.filters.findIndex(obj => obj.value =='Règlement')==-1){
            this.filters.push({"column":"type","value":"Règlement"});
            this.filters.push({"column":"type","value":"Règlement Engie"});
            this.hasFilters=true;
            this.applyFilters();
        }
        //trier tableData
        this.tabledata.sort(this.dynamicSort(this.compareField,(e.currentTarget.dataset.order!='asc')?'asc':'desc'));
        //actualiser les pages
        this.actualisePages();
    }
    filterTagClose(e){
        this.reCheckSelectedFilters(e.currentTarget.dataset.column,e.currentTarget.dataset.value);
        this.filters=this.filters.filter(filter=> !(filter.value == e.currentTarget.dataset.value && filter.column ==e.currentTarget.dataset.column));
        this.tabledata=this.tableBackup;
        this.hasFilters=this.filters.length > 0;
        if(this.hasFilters)
            this.applyFilters();
        else 
            this.tabledata=this.tableBackup;
        this.actualisePages();
    }
    applyFilters(){
        if(this.hasFilters){
            var filters= this.filters.map(function (filter) {
                return filter.value;
            });
            if(this.filters.findIndex(obj => obj.column =='type')!=-1)
                this.tabledata=this.tabledata.filter(record => filters.includes(record.typePiece));
            if(this.filtreValues.libFacture.findIndex(obj => obj =='Tous')!=-1 && this.filtreValues.typeReg.findIndex(obj => obj =='Tous')!=-1){
                this.tabledata=this.tableBackup;
                if(this.filtreValues.type.findIndex(obj => obj =='Facture' || obj =='Tous') == -1)
                    this.filtreValues.type.push('Facture');
                if(this.filtreValues.type.findIndex(obj => obj =='Règlement' || obj =='Tous') == -1)
                    this.filtreValues.type.push('Règlement');
                if(this.filtreValues.type.findIndex(obj => obj =='Règlement Engie' || obj =='Tous') == -1)
                    this.filtreValues.type.push('Règlement Engie');
            }else{
            if(this.filters.findIndex(obj => obj.column =='libFacture')!=-1)
                this.tabledata=this.tabledata.filter(record => filters.includes(record.typeCalcul));
            if(this.filters.findIndex(obj => obj.column =='typeReg')!=-1)
                this.tabledata=this.tabledata.filter(record => filters.includes(record.typeReglement));
            }
        }else
            this.tabledata=this.tableBackup;
    }
    resetFilters(){
        this.tabledata=this.tableBackup;
        this.filters=[];
        this.hasFilters=false;
        this.filtreValues={
            type:[],
            libFacture:[],
            typeReg:[]
        }
        this.actualisePages();
    }
    reCheckSelectedFilters(column,removedValue){
        let columnFilters =this.columnFilters;
        if (this.filtreValues[column].findIndex(obj => obj == 'Tous') != -1) {
            let filters=columnFilters[column].filter(filter => filter != removedValue);
            this.filtreValues[column]=filters;
        }else{
            this.filtreValues[column]=this.filtreValues[column].filter(filter => filter != removedValue);
        }
    }
    toggleFilter(e){
        let filtre = e.currentTarget.dataset.filtre;
        this.filterVisiblility[filtre] = !this.filterVisiblility[filtre];
    }
    handleFilterChange(e){
        this.removeColumnFilters(e.currentTarget.dataset.filtre);
        this.tabledata=this.tableBackup;
        if( e.detail.value.findIndex(obj => obj =='Tous')!=-1){
            e.detail.value = ["Tous"];
            this.filtreValues[e.currentTarget.dataset.filtre]=["Tous"];
            let filtersList=(e.currentTarget.dataset.filtre=='type')?this.columnFilters.type:(e.currentTarget.dataset.filtre=='libFacture')?this.columnFilters.libFacture:((e.currentTarget.dataset.filtre=='typeReg'))?this.columnFilters.typeReg:[];
            this.addFilterItem(e.currentTarget.dataset.filtre,filtersList);
        }else{
            this.filtreValues[e.currentTarget.dataset.filtre]=e.detail.value;
            this.addFilterItem(e.currentTarget.dataset.filtre,this.filtreValues[e.currentTarget.dataset.filtre]);
        }
        if(e.currentTarget.dataset.filtre == 'libFacture'){
            this.addFilterItem('type',['Facture']);
            if(this.filtreValues.type.findIndex(obj => obj =='Facture' || obj =='Tous') == -1)
                this.filtreValues.type.push('Facture');
        }
        if(e.currentTarget.dataset.filtre == 'typeReg'){
            this.addFilterItem('type',['Règlement','Règlement Engie']);
            if(this.filtreValues.type.findIndex(obj => obj =='Règlement' || obj =='Tous') == -1)
                this.filtreValues.type.push('Règlement');
            if(this.filtreValues.type.findIndex(obj => obj =='Règlement Engie' || obj =='Tous') == -1)
                this.filtreValues.type.push('Règlement Engie');
        }
        this.checkHasFilters();
        this.applyFilters();
        this.actualisePages();
    }
    checkHasFilters(){
        this.hasFilters= (this.filters.length > 0)?true:false;
    }
    removeColumnFilters(column){
        this.filters=this.filters.filter(filter=>filter.column != column);
        this.filtreValues[column]=[];
    }
    actualisePages(){
        //actualiser les pages
        this.tdPagination=this.pageSlice(this.tabledata,this.tableLimit);
        this.currentPage=this.tdPagination.length>0?this.tdPagination[0]:[];
        this.showFilterIcon=this.tabledata.length == 0 && this.tableBackup.length == 0;
        this.noData=this.tabledata.length == 0
    }

    connectedCallback() {

        // récupèrer les données de l'OS
        const input= JSON.parse(this.omniJsonDataStr);
        this.IdBusinessPartner= input.IdBusinessPartner;
        this.IdPortefeuilleContrat= input.IdPortefeuilleContrat;
        //FT2-1651 Récupération du NoCompteContrat depuis l'input omniscript
        this.NoCompteContratMaj= input.NoCompteContratMaj;

        //get liste des factures
        const params = {
            input: JSON.stringify({
                IdBusinessPartner:this.IdBusinessPartner,
                IdPortefeuilleContrat:this.IdPortefeuilleContrat,
                excludeSomeBillsType:true
            }),
            sClassName: 'SM_AP04_FacturesApiService',
            sMethodName: 'callFactureLWC',
            options: '{}',
        };
        this.omniRemoteCall(params)
        .then(res => {
            console.log("resopnse===="+JSON.stringify(res));
            if(res.result.result && res.result.result.data) {

                this.factures=res.result.result.data;
                this.tabledata=this.filterDataFactures(this.factures);
                // récupération des liens vers factures
                this.tabledata=this.getFactureLink(this.tabledata);
                // les factures en 6 ne doivent pas s'afficher
                this.tabledata= this.tabledata.filter(function(record) {
                    return record.numeroFacture[0] != '6';
                });
                console.log("after____"+this.tabledata);
            }
            //Traitement Paiement
            let dataPaiement = [];
           
            dataPaiement = this.filterDataPaiement(input.ConsulterPaiementResult.listPaiement);

            if (dataPaiement.length !== 0) {
                //this.noData = false;
                console.log(dataPaiement);
                this.tabledata = this.tabledata.concat(dataPaiement);
            }
            //ordonner les lignes du tableau
            this.tabledata.sort(this.dynamicSort(this.compareField,this.orderDirection));
            //version backup (filters)
            this.tableBackup=this.tabledata;
            // faire la pagination 
            this.actualisePages();
            this.noData = this.tabledata.length > 0 ? false : true;
        }).catch(error => {
            this.error = true;
            //console.log("got error callFacture ", name , error);
        });
    }

    //FT2-1599 -> [Situation de compte]-Motif de rejet de prélèvement
    //Fonction à exécuter lors du clic sur l'icone (i) pour ouvrir la popup
    openInfoModal(event) {
        //Variable mise à "true" pour permettre à l'HTML d'afficher la popup
        this.showInfoModal = true;

        //Recupération de la date de rejet et du motif de rejet de l'HTML
        let dateRej = event.currentTarget.dataset.daterejet;
        let motifRej = event.currentTarget.dataset.motifrejet;
        //Recupération du type de la pièce depuis l'HTML
        let typepiece = event.currentTarget.dataset.typepiece;
        //FT2-1651 Recupération de la date de reglement et le montant total depuis l'HTML
        let dateReglement = event.currentTarget.dataset.datereglement;
        let montantTotal = event.currentTarget.dataset.montanttotal;

        //Mise à jour des booleans typePieceIsRC et typePieceIsRC en fonction de l'html
        if(typepiece === 'isrc'){
            this.typePieceIsRC = true;
        }
        //FT2-1651 Situation de compte-RSSI-Cryptage IBAN 2/3 : Affichage de la pop up pour la pièce comptable EP
        // Si la pièce est type prélévement, on lance l'IP pour récuperer l'IBAN et l'afficher sur la popup
        if(typepiece === 'isprel'){
            this.typePieceIsPrel = true;
            this.showSpinnerIban=true;
            dateReglement = dateReglement.replaceAll('-', '');
            montantTotal = montantTotal.replace('.', ',');
            this.callIPIBANremonteCrypte({NumContractAccount: this.NoCompteContratMaj,DatePaiement: dateReglement,TypePaiement: 'EP',MntPaiment: montantTotal}, 'IP_SM_IBANremonteParPaiement_API');
        }
        //Remplissage de la variable de la date de rejet affichée dans le Modal
        if (dateRej) {
            this.dateRejetExists = true;
            this.dateRejetPrel = dateRej;
            
        } else {
            //Dans le cas où une date n'existe pas, mise de dateRejetExists à false pour empêcher la ligne de s'afficher
            this.dateRejetExists = false;
        }

        //Remplissage de la variable du motif de rejet affiché dans le Modal
        if (motifRej) {
            this.motifRejetExists = true;
            this.motifRejetPrel = motifRej;
        } else {
            //Dans le cas où un motif n'existe pas, mise de motifRejetExists à false pour empêcher la ligne de s'afficher
            this.motifRejetExists = false;
        }
    }
    //FT2-1651 Appel de l'IP pour récuperer l'IBAN a afficher lors du clic sur le (i)
    callIPIBANremonteCrypte(params, name){
        let datasourcedef = JSON.stringify({
            "type": "integrationprocedure",
            "value": {
                "ipMethod": name,
                "inputMap": params,
            }
        });
        getDataHandler(datasourcedef).then(IPResult => {
            if(IPResult) {
                let result = JSON.parse(IPResult);
                if (result) {
                    this.IbanCrypted = result.IPResult.IBANResult.IBAN;
                    this.IbanCrypted = this.IbanCrypted.substring(0, 4) + 'XXXXXXXXXXXXXXXXXXX' +this.IbanCrypted.substring(this.IbanCrypted.length - 4 ,this.IbanCrypted.length);
                }  
                else{
                    const evt = new ShowToastEvent({
                    title: "Une erreur est survenue. Veuillez contacter votre administrateur.",
                    variant: 'error',
                    });
                    this.dispatchEvent(evt);    
                }             
            }
            this.showSpinnerIban=false;
        }).catch(error => {
            const evt = new ShowToastEvent({
                title: "Une erreur est survenue. Veuillez contacter votre administrateur.",
                variant: 'error',
            });
            this.dispatchEvent(evt);  
            this.showSpinnerIban=false; 
        });
    }

    //FT2-1599 -> [Situation de compte]-Motif de rejet de prélèvement
    //Fonction à exécuter lors du clic sur le bouton Fermer pour fermer la popup
    closeInfoModal() {
        //Variable mise à "false" pour permettre à l'HTML de fermer la popup
        this.showInfoModal = false;
        //FT2-1600 réinitialisation des booléens typePieceIsRC et typePieceIsPrel à la fermeture de la popup. 
        this.typePieceIsPrel = false;
        this.typePieceIsRC = false;
        //FT2-1651 On vide le champ d'IBAN quand on ferme la popup
        this.IbanCrypted='';
    }

    //FT2-1599 -> [Situation de compte]-Motif de rejet de prélèvement
    //Récupération des motifs de rejet de la custom Metadata SM_Mapping_SituationCompteRejet__mdt et mapping des données
    getMotifsRefus() {
        var inputMap = { sObjName: "SM_Mapping_SituationCompteRejet__mdt", sObjFields: "CodeRejet__c,LibelleRejet__c," };
        let params = {
            type: "apexremote",
            value: {
                className: "SM_Utilities",
                optionsMap: "{}",
                methodName: "getcustomMetadataRecordsForVlocity"
            }
        }
        params.value.inputMap = JSON.stringify(inputMap);
        getDataHandler(JSON.stringify(params)).then(result => {
            let results = JSON.parse(result);
            if (results) {
                this.motifsRefus = [];
                var resultMotifs = results.customMetadataRecords;
                resultMotifs.forEach(motif => {
                    this.motifsRefus.push({libelle: motif.LibelleRejet__c, code: motif.CodeRejet__c});
                });
            }
        }).catch(error => {
            console.log("got error getcustomMetadataRecordsForVlocity", error);
        });
    }

    //FT2-1599 -> [Situation de compte]-Motif de rejet de prélèvement
    //Récupération des motifs au lancement du LWC
    renderedCallback(){
        this.getMotifsRefus();
    }
}