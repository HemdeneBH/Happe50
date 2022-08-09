import { api, LightningElement, track, wire } from 'lwc';

import getPaiement from '@salesforce/apex/HP_SM001_Agilab.getPaiement';

let DEFAULT_ACTIONS = [{ label: 'Tous', checked: true, name: 'all' }];

const actions = [
    { label: 'Afficher paiements', name: 'show_paiements' },
];

const columnsDettesElec = [
    {label: 'Id Contrat', fieldName: 'idContrat', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Id facture', fieldName: 'facture', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Réf Dette', fieldName: 'ref_dette', type: 'text',hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Montant TTC', fieldName: 'montant_ttc_dette', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Restant dû TTC', fieldName: 'montant_du_ttc_dette', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Date solde', fieldName: 'date_solde_dette', type: 'date', hideDefaultActions: true, sortable: true,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
    },
    {label: 'Date exigibilité', fieldName: 'date_exigibilite_dette', type: 'date', hideDefaultActions: true, sortable: true,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
    },

    {label: 'Statut', fieldName: 'statut_dette', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {type: 'action', typeAttributes: { rowActions: actions }, hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
];

const columnsDettesGaz = [
    {label: 'Id Contrat', fieldName: 'idContrat', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Id facture', fieldName: 'facture', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Réf Dette', fieldName: 'ref_dette', type: 'text',hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Montant TTC', fieldName: 'montant_ttc_dette', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Restant dû TTC', fieldName: 'montant_du_ttc_dette', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Date solde', fieldName: 'date_solde_dette', type: 'date', hideDefaultActions: true, sortable: true,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
    },
    {label: 'Date exigibilité', fieldName: 'date_exigibilite_dette', type: 'date', hideDefaultActions: true, sortable: true,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
    },

    {label: 'Statut', fieldName: 'statut_dette', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {type: 'action', typeAttributes: { rowActions: actions }, hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
];

const columnsPaiementsDetail = [
    {label: 'Réf paiement', fieldName: 'ref_paiement', type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'center' }},
    {label: 'Montant TTC', fieldName: 'montant_ttc', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center' }},
    {label: 'Date paiement', fieldName: 'date_paiement', type: 'date', hideDefaultActions: true, sortable: false,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, cellAttributes: { alignment: 'center' }
    },
    {label: 'Type paiement', fieldName: 'type_paiement', type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'center' }},
    {label: 'Statut', fieldName: 'statut', type: 'text', hideDefaultActions: true, cellAttributes: { alignment: 'center' }},
];

const columnsPaiementsFlottants = [
    {label: 'Id Contrat', fieldName: 'idContrat', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Réf paiement', fieldName: 'ref_paiement', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center' }},
    {label: 'Montant TTC', fieldName: 'montant_ttc', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center' }},
    {label: 'Date paiement', fieldName: 'date_paiement', type: 'date', hideDefaultActions: true, sortable: true,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, cellAttributes: { alignment: 'center' }
    },
    {label: 'Type paiement', fieldName: 'type_paiement', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center' }},
    {label: 'Statut', fieldName: 'statut', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center' }},
];

export default class Hp_historiquePaiements extends LightningElement {

    @track columnsDettesElec = columnsDettesElec;
    @track columnsDettesGaz = columnsDettesGaz;
    @track columnsPaiementsDetail = columnsPaiementsDetail;

    @track sortDettesElecBy;
    @track sortDirectionDettesElec;
    @track sortDettesGazBy;
    @track sortDirectionDettesGaz;

    @track sortPaiementsElecBy;
    @track sortDirectionPaiementsElec;
    @track sortPaiementsGazBy;
    @track sortDirectionPaiementsGaz;
    @track sortPaiementsFlottantsBy;
    @track sortDirectionPaiementsFlottants;

    @track defaultSortDirection = 'asc';

    @track _pfcdata;
    @track _contratLocaux;
    @track _idContratGaz;
    @track _idContratElec;
    @track _consommationData;
    @track selectedDetteGaz;
    @track selectedDetteElec;
    @track paiementsELEC = [];
    @track paiementsELEC_ALL = [];
    @track paiementsELEC_Output = [];
    @track paiementsGAZ = [];
    @track paiementsGAZ_ALL = [];
    @track paiementsGAZ_Output = [];
    @track noneAffectedPaiements = [];
    @track gazDettes = [];
    @track gazDettes_ALL = [];
    @track elecDettes = [];
    @track elecDettes_ALL = [];
    @track paiementsRelatedToDetteElec = [];
    @track paiementsRelatedToDetteGaz = [];

    @track idContratDettesElecActions = [];
    @track idFactureDettesElecActions = [];
    @track refDettesElecActions = [];
    @track statutDettesElecActions = [];

    @track idContratDettesGazActions = [];
    @track idFactureDettesGazActions = [];
    @track refDettesGazActions = [];
    @track statutDettesGazActions = [];

    @track showPaiementsRelatedToDetteElec = false;
    @track showPaiementsRelatedToDetteGaz = false;

    @track isGazDettesTableReady = false;
    @track isElecDettesTableReady = false;

    isGazResultFetched  = false;
    isElecResultFetched = false;
    
    @track showPaiementsFlottants = false;
    @track isPaiementsFlottantsTableReady = false;
    @track paiementsFlottants_ALL = [];
    @track paiementsFlottants = [];

    @track idContratPaiementsFlottantsActions = [];
    @track refPaiementsFlottantsActions = [];
    @track typePaiementFlottantsActions = [];
    @track statutPaiementFlottantsActions = [];

    @track columnsPaiementsFlottants = columnsPaiementsFlottants;

    @track isElecDettesTableEmpty = false;
    @track isGazDettesTableEmpty = false;

    @track idContratElecNotRetrieved = false;
    @track idContratGazNotRetrieved = false;

    @api
    set pfcdata(value) {
        if(value == null ) {
            return;
        }

        this._pfcdata =  value;
        console.log('this._pfcdata', JSON.parse(JSON.stringify(this._pfcdata)));
    }
    get pfcdata() {
        return null;
    }

    @api
    set contratLocaux(value){
        if(value==null){
            return;
        }
        this._contratLocaux = value;
        console.log('this._contratLocaux', JSON.parse(JSON.stringify(this._contratLocaux)));
    }
    get contratLocaux(){
        return null;
    }

    @api
    set idContratElec(value){
        if(value==null){
            this.idContratElecNotRetrieved = true;
            return;
        }
        this._idContratElec = value;
        console.log('this._idContratElec', JSON.parse(JSON.stringify(this._idContratElec)));

        this.getElecHistoriquePaiements();
    }
    get idContratElec(){
        return null;
    }

    @api
    set idContratGaz(value){
        if(value==null){
            this.idContratGazNotRetrieved = true;
            return;
        }
        this._idContratGaz = value;
        console.log('this._idContratGaz', JSON.parse(JSON.stringify(this._idContratGaz)));

        this.getGazHistoriquePaiements();
    }
    get idContratGaz(){
        return null;
    }

    @api
    set consommationData(value) {
        if(value == null ) {
            return;
        }
        this._consommationData = value;
        console.log('this._consommationData', JSON.parse(JSON.stringify(this._consommationData)));
    }
    get consommationData() {
        return null;
    }

    get isAdressLoaded(){
        if(this?._contratLocaux){
            return this._contratLocaux.numeroVoie != null;
        }else {
            return false;
        }
    }

    get showELEC(){
        return this.elecDettes.length > 0;
    }

    get showGAZ(){
        return this.gazDettes.length > 0;
    }

    getGazHistoriquePaiements() {
        getPaiement({
            idContratXdata: this._idContratGaz
        }).then(result => {
            // console.log('result Gaz',JSON.stringify(result));
            if(result.output?.paiements) {
                this.paiementsGAZ_Output = result.output.paiements;
                // console.log('this.paiementsGAZ_Output :',JSON.parse(JSON.stringify(this.paiementsGAZ_Output)));
            }
        }).catch((error) => {
            console.log('Error Fetching Gaz Paiements',error);
        }).finally(() => {
            this.processData();
        });
    }

    getElecHistoriquePaiements() {
        getPaiement({
            idContratXdata: this._idContratElec
        }).then(result => {
            // console.log('result Elec',JSON.stringify(result));
            if(result.output?.paiements) {
                this.paiementsELEC_Output = result.output.paiements;
                // console.log('this.paiementsELEC_Output :',JSON.parse(JSON.stringify(this.paiementsELEC_Output)));
            }
        }).catch((error) => {
            console.log('Error Fetching Elec Paiements',error);
        }).finally(() => {
            this.processData();
        });
    }

    processData() {
        this.formatData();
        this.getNoneAffectedPaiements();
        this.getGazDettes();
        this.getElecDettes();
    }

    formatData() {
        const paiementsELEC_Output = this.paiementsELEC_Output;
        this.paiementsELEC = [];
        for(let key in paiementsELEC_Output) {
            let typePaiement;
            let statutPaiement;
            let dettesPaiement = [];
            switch(paiementsELEC_Output[key].type_paiement){  
                case '1':
                    typePaiement = 'Carte Bancaire';
                    break;
                case '2':
                    typePaiement = 'Prélèvement';
                    break; 
                case '3':
                    typePaiement = 'TIP Chèque';
                    break;  
                case '4':
                    typePaiement = 'Virement';
                    break;  
                case '5':
                    typePaiement = 'Espèces';
                    break;  
                case '6':
                    typePaiement = 'Autre';
                    break;  
                case '7':
                    typePaiement = 'Mensualisation';
                    break;  
                case '8':
                    typePaiement = 'Compensation/Avoir';
                    break;  
                case '9':
                    typePaiement = 'Chèque énergie';
                    break;  
                case '10':
                    typePaiement = 'Recouvrement EFFICO';
                    break;  
                case '11':
                    typePaiement = 'Paiement récurrent par carte bancaire';
                    break;  
                case '12':
                    typePaiement = 'Chèque et espèces';
                    break;   
                case '13':
                    typePaiement = 'Chèque énergie ASP';
                    break;
                case '14':
                    typePaiement = 'Paiement à plusieurs via ShareGroop';
                    break;   
                case '15':
                    typePaiement = 'Recouvrement GERI';
                    break;    
            }
            switch(paiementsELEC_Output[key].statut){
                case '1' : 
                    statutPaiement = 'attente affectation';
                    break; 
                case '2' : 
                    statutPaiement = 'partiellement affecté';
                    break; 
                case '3' : 
                    statutPaiement = 'affecté';
                    break;
                case '4' : 
                    statutPaiement = 'annulé';
                    break; 
                case '5' : 
                    statutPaiement = 'rejeté';
                    break; 
                case '6' : 
                    statutPaiement = 'remboursé';
                    break; 
                case '7' : 
                    statutPaiement = 'non validé';
                    break; 
                case '8' : 
                    statutPaiement = 'non traité';
                    break; 
            }
            for(let detteKey in paiementsELEC_Output[key].dettes) {
                let statutDette;

                if (paiementsELEC_Output[key].dettes[detteKey].ref_dette.startsWith('DET')) {
                    switch(paiementsELEC_Output[key].dettes[detteKey].statut_dette){
                        case '0' : 
                            statutDette = '';
                            break; 
                        case '1' : 
                            statutDette = 'non soldé';
                            break; 
                        case '2' : 
                            statutDette = 'partiellement soldé';
                            break; 
                        case '3' : 
                            statutDette = 'soldé';
                            break;
                        case '4' : 
                            statutDette = 'annulé';
                            break; 
                        case '5' : 
                            statutDette = 'douteuse';
                            break;
                        case '6' : 
                            statutDette = 'provision 50%';
                            break;
                        case '7' : 
                            statutDette = 'provision 80%';
                            break; 
                        case '8' : 
                            statutDette = 'irrécouvrable';
                            break; 
                    }

                } else if (paiementsELEC_Output[key].dettes[detteKey].ref_dette.startsWith('ECH')) {
                switch(paiementsELEC_Output[key].dettes[detteKey].statut_dette){
                    case '0' : 
                        statutDette = '';
                        break; 
                    case '1' : 
                        statutDette = 'Annulée';
                        break; 
                    case '2' : 
                        statutDette = 'Régularisée';
                        break; 
                    case '3' : 
                        statutDette = 'Partiellement soldée';
                        break;
                    case '4' : 
                        statutDette = 'Soldée';
                        break; 
                    case '5' : 
                        statutDette = 'Non soldée';
                        break; 
                }
                }
                
                let tempDette = {
                    idContrat               : this._idContratElec,
                    facture                 : paiementsELEC_Output[key].dettes[detteKey].facture, 
                    ref_dette               : paiementsELEC_Output[key].dettes[detteKey].ref_dette,
                    montant_ttc_dette       : paiementsELEC_Output[key].dettes[detteKey].montant_ttc_dette,
                    montant_du_ttc_dette    : paiementsELEC_Output[key].dettes[detteKey].montant_du_ttc_dette,
                    statut_dette            : statutDette,
                    date_solde_dette        : paiementsELEC_Output[key].dettes[detteKey].date_solde_dette,
                    date_exigibilite_dette  : paiementsELEC_Output[key].dettes[detteKey].date_exigibilite_dette,
                    // fieldCSSClass            : 'marked'
                };
                dettesPaiement.push(tempDette);
            };

            let tempElement = {
                id              : key,
                idContrat       : this._idContratElec,
                ref_paiement    : paiementsELEC_Output[key].ref_paiement, 
                date_rejet      : paiementsELEC_Output[key].date_rejet,
                type_paiement   : typePaiement,
                montant_ttc     : paiementsELEC_Output[key].montant_ttc,
                date_paiement   : paiementsELEC_Output[key].date_paiement,
                statut          : statutPaiement,
                motif_rejet     :  paiementsELEC_Output[key].motif_rejet,
                dettes          :  dettesPaiement,
            };
            this.paiementsELEC.push(tempElement);
        }
        // console.log('this.paiementsELEC',JSON.parse(JSON.stringify(this.paiementsELEC)));

        const paiementsGAZ_Output = this.paiementsGAZ_Output;
        this.paiementsGAZ = [];
        for(let key in paiementsGAZ_Output) {
            let typePaiement;
            let statutPaiement;
            let dettesPaiement = [];
            switch(paiementsGAZ_Output[key].type_paiement){  
                case '1':
                    typePaiement = 'Carte Bancaire';
                    break;
                case '2':
                    typePaiement = 'Prélèvement';
                    break; 
                case '3':
                    typePaiement = 'TIP Chèque';
                    break;  
                case '4':
                    typePaiement = 'Virement';
                    break;  
                case '5':
                    typePaiement = 'Espèces';
                    break;  
                case '6':
                    typePaiement = 'Autre';
                    break;  
                case '7':
                    typePaiement = 'Mensualisation';
                    break;  
                case '8':
                    typePaiement = 'Compensation/Avoir';
                    break;  
                case '9':
                    typePaiement = 'Chèque énergie';
                    break;  
                case '10':
                    typePaiement = 'Recouvrement EFFICO';
                    break;  
                case '11':
                    typePaiement = 'Paiement récurrent par carte bancaire';
                    break;  
                case '12':
                    typePaiement = 'Chèque et espèces';
                    break;   
                case '13':
                    typePaiement = 'Chèque énergie ASP';
                    break;
                case '14':
                    typePaiement = 'Paiement à plusieurs via ShareGroop';
                    break;   
                case '15':
                    typePaiement = 'Recouvrement GERI';
                    break;    
            }
            switch(paiementsGAZ_Output[key].statut){
                case '1' : 
                    statutPaiement = 'attente affectation';
                    break; 
                case '2' : 
                    statutPaiement = 'partiellement affecté';
                    break; 
                case '3' : 
                    statutPaiement = 'affecté';
                    break;
                case '4' : 
                    statutPaiement = 'annulé';
                    break; 
                case '5' : 
                    statutPaiement = 'rejeté';
                    break; 
                case '6' : 
                    statutPaiement = 'remboursé';
                    break; 
                case '7' : 
                    statutPaiement = 'non validé';
                    break; 
                case '8' : 
                    statutPaiement = 'non traité';
                    break; 
            }

            for(let detteKey in paiementsGAZ_Output[key].dettes) {
                let statutDette;

                if (paiementsGAZ_Output[key].dettes[detteKey].ref_dette.startsWith('DET')) {
                    switch(paiementsGAZ_Output[key].dettes[detteKey].statut_dette){
                        case '0' : 
                            statutDette = '';
                            break; 
                        case '1' : 
                            statutDette = 'non soldé';
                            break; 
                        case '2' : 
                            statutDette = 'partiellement soldé';
                            break; 
                        case '3' : 
                            statutDette = 'soldé';
                            break;
                        case '4' : 
                            statutDette = 'annulé';
                            break; 
                        case '5' : 
                            statutDette = 'douteuse';
                            break;
                        case '6' : 
                            statutDette = 'provision 50%';
                            break;
                        case '7' : 
                            statutDette = 'provision 80%';
                            break; 
                        case '8' : 
                            statutDette = 'irrécouvrable';
                            break; 
                    }

                } else if (paiementsGAZ_Output[key].dettes[detteKey].ref_dette.startsWith('ECH')) {
                switch(paiementsGAZ_Output[key].dettes[detteKey].statut_dette){
                    case '0' : 
                        statutDette = '';
                        break; 
                    case '1' : 
                        statutDette = 'Annulée';
                        break; 
                    case '2' : 
                        statutDette = 'Régularisée';
                        break; 
                    case '3' : 
                        statutDette = 'Partiellement soldée';
                        break;
                    case '4' : 
                        statutDette = 'Soldée';
                        break; 
                    case '5' : 
                        statutDette = 'Non soldée';
                        break; 
                }
                }

                let tempDette = {
                    idContrat               : this._idContratGaz,
                    facture                 : paiementsGAZ_Output[key].dettes[detteKey].facture, 
                    ref_dette               : paiementsGAZ_Output[key].dettes[detteKey].ref_dette,
                    montant_ttc_dette       : paiementsGAZ_Output[key].dettes[detteKey].montant_ttc_dette,
                    montant_du_ttc_dette    : paiementsGAZ_Output[key].dettes[detteKey].montant_du_ttc_dette,
                    statut_dette            : statutDette,
                    date_solde_dette        : paiementsGAZ_Output[key].dettes[detteKey].date_solde_dette,
                    date_exigibilite_dette  : paiementsGAZ_Output[key].dettes[detteKey].date_exigibilite_dette
                };
                dettesPaiement.push(tempDette);
            };

            let tempElement = {
                id              : key,
                idContrat       : this._idContratGaz,
                ref_paiement    : paiementsGAZ_Output[key].ref_paiement, 
                date_rejet      : paiementsGAZ_Output[key].date_rejet,
                type_paiement   : typePaiement,
                montant_ttc     : paiementsGAZ_Output[key].montant_ttc,
                date_paiement   : paiementsGAZ_Output[key].date_paiement,
                statut          : statutPaiement,
                motif_rejet     :  paiementsGAZ_Output[key].motif_rejet,
                dettes          :  dettesPaiement,
            };
            this.paiementsGAZ.push(tempElement);
        }
        // console.log('this.paiementsGAZ',JSON.parse(JSON.stringify(this.paiementsGAZ)));
    }

    getNoneAffectedPaiements() {
        this.paiementsFlottants_ALL = [];

        this.paiementsGAZ.forEach(p => {
            if(p.statut != 'affecté') {
                p.idContrat = this._idContratGaz;
                this.paiementsFlottants_ALL.push(p);
            }
                
        });

        this.paiementsELEC.forEach(p => {
            if(p.statut != 'affecté') {
                p.idContrat = this._idContratElec;
                this.paiementsFlottants_ALL.push(p);
            }
                
        });

        this.paiementsFlottants = this.paiementsFlottants_ALL;
        this.updatePaiementsFlottantsHeadersAction();
        this.paiementsFlottants_ALL.length > 0 ? this.showPaiementsFlottants = true : null;

        // console.log('this.paiementsFlottants_ALL',JSON.parse(JSON.stringify(this.paiementsFlottants_ALL)));
    }

    getGazDettes() {
        if(!this.idContratGazNotRetrieved) {
        this.paiementsGAZ.forEach(p => {
            p.dettes.forEach(d => {
                if (!this.gazDettes_ALL.filter(e => e.ref_dette === d.ref_dette).length > 0)
                    this.gazDettes_ALL.push(d);
            });
        });

            for(let key in this.gazDettes_ALL) {
                this.gazDettes_ALL[key].id = key;
            }
    
            this.gazDettes = this.gazDettes_ALL;
            this.updateDettesGazHeadersAction();
            this.gazDettes_ALL.length > 0 ? this.isGazDettesTableReady = true : this.isGazDettesTableEmpty = true;
        }

        // console.log('this.gazDettes_ALL :',JSON.parse(JSON.stringify(this.gazDettes_ALL)));
    }

    getElecDettes() {
        if(!this.idContratElecNotRetrieved) {
        this.paiementsELEC.forEach(p => {
            p.dettes.forEach(d => {
                if (!this.elecDettes_ALL.filter(e => e.ref_dette === d.ref_dette).length > 0)
                    this.elecDettes_ALL.push(d);
            });
        });

            for(let key in this.elecDettes_ALL) {
                this.elecDettes_ALL[key].id = key;
            }
    
            this.elecDettes = this.elecDettes_ALL;
            this.updateDettesElecHeadersAction();
            this.elecDettes_ALL.length > 0 ? this.isElecDettesTableReady = true : this.isElecDettesTableEmpty = true;
        }
        
        // console.log('this.elecDettes_ALL :',JSON.parse(JSON.stringify(this.elecDettes_ALL)));
    }

    updatePaiementsFlottantsHeadersAction() {
        console.log('this.paiementsFlottants', JSON.parse(JSON.stringify(this.paiementsFlottants)));
        this.idContratPaiementsFlottantsActions = [];
        this.refPaiementsFlottantsActions       = [];
        this.typePaiementFlottantsActions       = [];
        this.statutPaiementFlottantsActions     = [];
        
        for(let key in this.paiementsFlottants) {

            if(this.idContratPaiementsFlottantsActions.filter(value => value.label !== this.paiementsFlottants[key].idContrat).length !== this.idContratPaiementsFlottantsActions.length){
                this.idContratPaiementsFlottantsActions = this.idContratPaiementsFlottantsActions.filter(value => value.label !== this.paiementsFlottants[key].idContrat);
            }
            if(this.refPaiementsFlottantsActions.filter(value => value.label !== this.paiementsFlottants[key].ref_paiement).length !== this.refPaiementsFlottantsActions.length){
                this.refPaiementsFlottantsActions = this.refPaiementsFlottantsActions.filter(value => value.label !== this.paiementsFlottants[key].ref_paiement);
            }
            if(this.typePaiementFlottantsActions.filter(value => value.label !== this.paiementsFlottants[key].type_paiement).length !== this.typePaiementFlottantsActions.length){
                this.typePaiementFlottantsActions = this.typePaiementFlottantsActions.filter(value => value.label !== this.paiementsFlottants[key].type_paiement);
            }
            if(this.statutPaiementFlottantsActions.filter(value => value.label !== this.paiementsFlottants[key].statut).length !== this.statutPaiementFlottantsActions.length){
                this.statutPaiementFlottantsActions = this.statutPaiementFlottantsActions.filter(value => value.label !== this.paiementsFlottants[key].statut);
            }

            this.idContratPaiementsFlottantsActions.push({label:this.paiementsFlottants[key].idContrat, checked : false, name : this.paiementsFlottants[key].idContrat});
            this.refPaiementsFlottantsActions.push({label:this.paiementsFlottants[key].ref_paiement, checked : false, name : this.paiementsFlottants[key].ref_paiement});
            this.typePaiementFlottantsActions.push({label:this.paiementsFlottants[key].type_paiement, checked : false, name : this.paiementsFlottants[key].type_paiement});
            this.statutPaiementFlottantsActions.push({label:this.paiementsFlottants[key].statut, checked : false, name : this.paiementsFlottants[key].statut});
            
            if(this.columnsPaiementsFlottants.length > 0){
                this.columnsPaiementsFlottants.forEach(col => {
                    if (col.fieldName === 'idContrat') {
                        col.actions = [...DEFAULT_ACTIONS,...this.idContratPaiementsFlottantsActions];
                    } else if (col.fieldName === 'ref_paiement') {
                        col.actions = [...DEFAULT_ACTIONS,...this.refPaiementsFlottantsActions];
                    } else if (col.fieldName === 'type_paiement') {
                        col.actions = [...DEFAULT_ACTIONS,...this.typePaiementFlottantsActions];
                    } else if (col.fieldName === 'statut') {
                        col.actions = [...DEFAULT_ACTIONS,...this.statutPaiementFlottantsActions];
                    }
                });
            }

        }
    }

    updateDettesElecHeadersAction() {
        // console.log('updateDettesElecHeadersAction is called');
        this.idContratDettesElecActions = [];
        this.idFactureDettesElecActions = [];
        this.refDettesElecActions       = [];
        this.statutDettesElecActions    = [];

        for(let key in this.elecDettes) {
            const idContrat = this.elecDettes[key].idContrat;
            const idFature = this.elecDettes[key].facture;
            const refDette = this.elecDettes[key].ref_dette;
            const statutDette = this.elecDettes[key].statut_dette;

            if(this.idContratDettesElecActions.filter(value => value.label !== idContrat).length !== this.idContratDettesElecActions.length){
                this.idContratDettesElecActions = this.idContratDettesElecActions.filter(value => value.label !== idContrat);
            }
            if(this.idFactureDettesElecActions.filter(value => value.label !== idFature).length !== this.idFactureDettesElecActions.length){
                this.idFactureDettesElecActions = this.idFactureDettesElecActions.filter(value => value.label !== idFature);
            }
            if(this.refDettesElecActions.filter(value => value.label !== refDette).length !== this.refDettesElecActions.length){
                this.refDettesElecActions = this.refDettesElecActions.filter(value => value.label !== refDette);
            }
            if(this.statutDettesElecActions.filter(value => value.label !== statutDette).length !== this.statutDettesElecActions.length){
                this.statutDettesElecActions = this.statutDettesElecActions.filter(value => value.label !== statutDette);
            }

            this.idContratDettesElecActions.push({label:idContrat, checked : false, name : idContrat});
            this.idFactureDettesElecActions.push({label:idFature, checked : false, name : idFature});
            this.refDettesElecActions.push({label:refDette, checked : false, name : refDette});
            this.statutDettesElecActions.push({label:statutDette, checked : false, name : statutDette});

            if(this.columnsDettesElec.length > 0){
                this.columnsDettesElec.forEach(col => {
                    if (col.fieldName === 'idContrat') {
                        col.actions = [...DEFAULT_ACTIONS,...this.idContratDettesElecActions];
                    } else if (col.fieldName === 'facture') {
                        col.actions = [...DEFAULT_ACTIONS,...this.idFactureDettesElecActions];
                    }else if (col.fieldName === 'ref_dette') {
                        col.actions = [...DEFAULT_ACTIONS,...this.refDettesElecActions];
                    }else if (col.fieldName === 'statut_dette') {
                        col.actions = [...DEFAULT_ACTIONS,...this.statutDettesElecActions];
                    }
                });
            }
        }
    }

    updateDettesGazHeadersAction() {
        // console.log('updateDettesGazHeadersAction is called');
        this.idContratDettesGazActions = [];
        this.idFactureDettesGazActions = [];
        this.refDettesGazActions       = [];
        this.statutDettesGazActions    = [];

        for(let key in this.gazDettes) {
            const idContrat = this.gazDettes[key].idContrat;
            const idFature = this.gazDettes[key].facture;
            const refDette = this.gazDettes[key].ref_dette;
            const statutDette = this.gazDettes[key].statut_dette;

            if(this.idContratDettesGazActions.filter(value => value.label !== idContrat).length !== this.idContratDettesGazActions.length){
                this.idContratDettesGazActions = this.idContratDettesGazActions.filter(value => value.label !== idContrat);
            }
            if(this.idFactureDettesGazActions.filter(value => value.label !== idFature).length !== this.idFactureDettesGazActions.length){
                this.idFactureDettesGazActions = this.idFactureDettesGazActions.filter(value => value.label !== idFature);
            }
            if(this.refDettesGazActions.filter(value => value.label !== refDette).length !== this.refDettesGazActions.length){
                this.refDettesGazActions = this.refDettesGazActions.filter(value => value.label !== refDette);
            }
            if(this.statutDettesGazActions.filter(value => value.label !== statutDette).length !== this.statutDettesGazActions.length){
                this.statutDettesGazActions = this.statutDettesGazActions.filter(value => value.label !== statutDette);
            }

            this.idContratDettesGazActions.push({label:idContrat, checked : false, name : idContrat});
            this.idFactureDettesGazActions.push({label:idFature, checked : false, name : idFature});
            this.refDettesGazActions.push({label:refDette, checked : false, name : refDette});
            this.statutDettesGazActions.push({label:statutDette, checked : false, name : statutDette});

            if(this.columnsDettesGaz.length > 0){
                this.columnsDettesGaz.forEach(col => {
                    if (col.fieldName === 'idContrat') {
                        col.actions = [...DEFAULT_ACTIONS,...this.idContratDettesGazActions];
                    } else if (col.fieldName === 'facture') {
                        col.actions = [...DEFAULT_ACTIONS,...this.idFactureDettesGazActions];
                    }else if (col.fieldName === 'ref_dette') {
                        col.actions = [...DEFAULT_ACTIONS,...this.refDettesGazActions];
                    }else if (col.fieldName === 'statut_dette') {
                        col.actions = [...DEFAULT_ACTIONS,...this.statutDettesGazActions];
                    }
                });
            }
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'show_paiements':
                this.showPaiements(row);
                break;
            default:
        }
    }

    showPaiements(row) {
        switch (this.getDetteTypeEnergie(row)) {
            case 'ELEC':
                this.onHidePaiementsRelatedToDetteElec();
                this.selectedDetteElec = row;
                // console.log('this.selectedDetteElec',JSON.parse(JSON.stringify(this.selectedDetteElec)));
                this.getPaiementsRelatedToDetteElec(this.selectedDetteElec);
                this.showPaiementsRelatedToDetteElec = true;
                this.markSelectedElecDette(this.selectedDetteElec.id);
            
                break;
            case 'GAZ':
                this.onHidePaiementsRelatedToDetteGaz();
                this.selectedDetteGaz = row;
                // console.log('this.selectedDetteGaz',JSON.parse(JSON.stringify(this.selectedDetteGaz)));
                this.getPaiementsRelatedToDetteGaz(this.selectedDetteGaz);
                this.showPaiementsRelatedToDetteGaz = true;
                this.markSelectedGazDette(this.selectedDetteGaz.id);
                break;
            default:
                break;
        }
    }

    markSelectedElecDette(id) {
        this.elecDettes[id].fieldCSSClass = 'marked';
        this.elecDettes = [...this.elecDettes];
    }

    markSelectedGazDette(id) {
        this.gazDettes[id].fieldCSSClass = 'marked';
        this.gazDettes = [...this.gazDettes];
    }

    getPaiementsRelatedToDetteElec(detteElec) {
        this.paiementsRelatedToDetteElec = [];
        
        this.paiementsELEC.forEach(p => {
            if (p.dettes.filter(e => e.ref_dette === detteElec.ref_dette).length > 0)
                this.paiementsRelatedToDetteElec.push(p);
        });

        this.paiementsELEC = this.paiementsELEC.slice(0,9);

        const event = { detail: { fieldName: 'date_paiement', sortDirection: 'asc' }};
        this.onHandleSortPaiementsElec(event);
        // console.log('this.paiementsRelatedToDetteElec',JSON.parse(JSON.stringify(this.paiementsRelatedToDetteElec)));
    }

    getPaiementsRelatedToDetteGaz(detteGaz) {
        this.paiementsRelatedToDetteGaz = [];

        this.paiementsGAZ.forEach(p => {
            if (p.dettes.filter(e => e.ref_dette === detteGaz.ref_dette).length > 0)
                this.paiementsRelatedToDetteGaz.push(p);
        });

        this.paiementsGAZ = this.paiementsGAZ.slice(0,9);

        const event = { detail: { fieldName: 'date_paiement', sortDirection: 'asc' }};
        this.onHandleSortPaiementsGaz(event);

        // console.log('this.paiementsRelatedToDetteGaz',JSON.parse(JSON.stringify(this.paiementsRelatedToDetteGaz)));
    }

    getDetteTypeEnergie(dette) {
        return this.gazDettes.filter(e => e.ref_dette === dette.ref_dette).length > 0 ? 'GAZ' : (this.elecDettes.filter(e => e.ref_dette === dette.ref_dette).length > 0 ? 'ELEC' : '');
    }

    onHidePaiementsRelatedToDetteElec() {
        if(this.selectedDetteElec) {
            this.showPaiementsRelatedToDetteElec = false;
            delete this.elecDettes[this.selectedDetteElec?.id].fieldCSSClass;
            this.elecDettes = [...this.elecDettes];
            this.selectedDetteElec = null;
        }
    }

    onHidePaiementsRelatedToDetteGaz() {
        if(this.selectedDetteGaz) {
            this.showPaiementsRelatedToDetteGaz = false;
            delete this.gazDettes[this.selectedDetteGaz?.id].fieldCSSClass;
            this.gazDettes = [...this.gazDettes];
            this.selectedDetteGaz = null;
        }
    }

    onHandleSortDettesElec(event) {
        this.onHidePaiementsRelatedToDetteElec();
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.elecDettes];
        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'desc' ? 1 : -1 ) );
        this.elecDettes = cloneData;
        for(let key in this.elecDettes) { this.elecDettes[key].id = key; }
        this.sortDirectionDettesElec = sortDirection;
        this.sortDettesElecBy = sortedBy;
    }

    onHandleSortDettesGaz(event) {
        this.onHidePaiementsRelatedToDetteGaz();
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.gazDettes];
        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'desc' ? 1 : -1 ) );
        this.gazDettes = cloneData;
        for(let key in this.gazDettes) { this.gazDettes[key].id = key; }
        this.sortDirectionDettesGaz = sortDirection;
        this.sortDettesGazBy = sortedBy;
    }

    onHandleSortPaiementsElec(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.paiementsRelatedToDetteElec];
        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'desc' ? 1 : -1 ) );
        this.paiementsRelatedToDetteElec = cloneData;
        this.sortDirectionPaiementsElec = sortDirection;
        this.sortPaiementsElecBy = sortedBy;
    }

    onHandleSortPaiementsGaz(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.paiementsRelatedToDetteGaz];
        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'desc' ? 1 : -1 ) );
        this.paiementsRelatedToDetteGaz = cloneData;
        this.sortDirectionPaiementsGaz = sortDirection;
        this.sortPaiementsGazBy = sortedBy;
    }

    onHandleSortPaiementsFlottants(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.paiementsFlottants];
        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'desc' ? 1 : -1 ) );
        this.paiementsFlottants = cloneData;
        this.sortDirectionPaiementsFlottants = sortDirection;
        this.sortPaiementsFlottantsBy = sortedBy;
    }

    sortBy( field, reverse, primer ) {
        const key = primer
            ? function( x ) {
                  return primer(x[field]);
              }
            : function( x ) {
                  return x[field];
              };
        return function( a, b ) {
            a = key(a);
            b = key(b);
            return reverse * ( ( a > b ) - ( b > a ) );
        };
    }

    handleHeaderActionELEC(event) {
        const actionName = event.detail.action.name;
        const colDef = event.detail.columnDefinition;
        this.onHidePaiementsRelatedToDetteElec();

        if (actionName !== undefined && actionName !== 'all') {
            if(colDef.fieldName === 'idContrat'){
                this.elecDettes = this.elecDettes_ALL.filter(_dette => _dette.idContrat === actionName);
            }
            if(colDef.fieldName === 'facture'){
                this.elecDettes = this.elecDettes_ALL.filter(_dette => _dette.facture === actionName);
            }
            if(colDef.fieldName === 'ref_dette'){
                this.elecDettes = this.elecDettes_ALL.filter(_dette => _dette.ref_dette === actionName);
            }
            if(colDef.fieldName === 'statut_dette'){
                this.elecDettes = this.elecDettes_ALL.filter(_dette => _dette.statut_dette === actionName);
            }

            for(let key in this.elecDettes) { this.elecDettes[key].id = key; }

        } else if (actionName === 'all') {
            this.elecDettes = this.elecDettes_ALL;
        }

        this.updateDettesElecHeadersAction();

        const cols = this.columnsDettesElec;
        cols.find(col => col.label === colDef.label).actions.forEach(action => action.checked = action.name === actionName);
        this.columnsDettesElec = [...cols];
    }

    handleHeaderActionGaz(event) {
        const actionName = event.detail.action.name;
        const colDef = event.detail.columnDefinition;
        this.onHidePaiementsRelatedToDetteGaz();
        

        if (actionName !== undefined && actionName !== 'all') {
            if(colDef.fieldName === 'idContrat'){
                this.gazDettes = this.gazDettes_ALL.filter(_dette => _dette.idContrat === actionName);
            }
            if(colDef.fieldName === 'facture'){
                this.gazDettes = this.gazDettes_ALL.filter(_dette => _dette.facture === actionName);
            }
            if(colDef.fieldName === 'ref_dette'){
                this.gazDettes = this.gazDettes_ALL.filter(_dette => _dette.ref_dette === actionName);
            }
            if(colDef.fieldName === 'statut_dette'){
                this.gazDettes = this.gazDettes_ALL.filter(_dette => _dette.statut_dette === actionName);
            }
            for(let key in this.gazDettes) { this.gazDettes[key].id = key; }

        } else if (actionName === 'all') {
            this.gazDettes = this.gazDettes_ALL;
        }

        this.updateDettesGazHeadersAction();

        const cols = this.columnsDettesGaz;
        cols.find(col => col.label === colDef.label).actions.forEach(action => action.checked = action.name === actionName);
        this.columnsDettesGaz = [...cols];
    }

    handleHeaderActionPaiementsFlottants(event) {
        const actionName = event.detail.action.name;
        const colDef = event.detail.columnDefinition;

        if (actionName !== undefined && actionName !== 'all') {
            if(colDef.fieldName === 'idContrat'){
                this.paiementsFlottants = this.paiementsFlottants_ALL.filter(_paiement => _paiement.idContrat === actionName);
            }
            if(colDef.fieldName === 'ref_paiement'){
                this.paiementsFlottants = this.paiementsFlottants_ALL.filter(_paiement => _paiement.ref_paiement === actionName);
            }
            if(colDef.fieldName === 'type_paiement'){
                this.paiementsFlottants = this.paiementsFlottants_ALL.filter(_paiement => _paiement.type_paiement === actionName);
            }
            if(colDef.fieldName === 'statut'){
                this.paiementsFlottants = this.paiementsFlottants_ALL.filter(_paiement => _paiement.statut === actionName);
            }
            for(let key in this.paiementsFlottants) { this.paiementsFlottants[key].id = key; }
        } else if (actionName === 'all') {
            this.paiementsFlottants = this.paiementsFlottants_ALL;
        }
        this.updatePaiementsFlottantsHeadersAction();

        const cols = this.columnsPaiementsFlottants;
        cols.find(col => col.label === colDef.label).actions.forEach(action => action.checked = action.name === actionName);
        this.columnsPaiementsFlottants = [...cols];
    }

}