/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 11-30-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
import { LightningElement, api, track } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';

let DEFAULT_ACTIONS = [{ label: 'Tous', checked: true, name: 'all' }];
const columnsELEC = [
    {label: 'Réf.', fieldName: 'ref_facture', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Date création', fieldName: 'date_creation', type: 'date',sortable: true, hideDefaultActions: true,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, 
    actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
    },
    {label: 'Type', fieldName: 'type_facture', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Montant TTC', fieldName: 'montant_ttc', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Montant restant dû', fieldName: 'montant_restant_du', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Date limite de paiement', fieldName: 'date_limite_de_paiement', type: 'date', hideDefaultActions: true, sortable: false,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
    },
    {label: 'Statut', fieldName: 'statut', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label : 'Actions', type: "button",
        typeAttributes: { fieldName: "show_details",  label: 'Détails' , variant: 'base'}, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
      },
];

const columnsGAZ = [
    {label: 'Réf.', fieldName: 'ref_facture', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Date création', fieldName: 'date_creation', type: 'date',sortable: true, hideDefaultActions: true,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
    },
    {label: 'Type', fieldName: 'type_facture', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Montant TTC', fieldName: 'montant_ttc', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Montant restant dû', fieldName: 'montant_restant_du', type: 'currency', hideDefaultActions: true, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label: 'Date limite de paiement', fieldName: 'date_limite_de_paiement', type: 'date', hideDefaultActions: true, sortable: false,
        typeAttributes: {
            year: "numeric",
            month: "numeric",
            day: "numeric"
        }, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
    },

    {label: 'Statut', fieldName: 'statut', type: 'text', hideDefaultActions: true, actions : DEFAULT_ACTIONS, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }},
    {label : 'Actions', type: "button",
        typeAttributes: { fieldName: "show_details",  label: 'Détails' , variant: 'base'}, cellAttributes: { alignment: 'center', class: {fieldName: 'fieldCSSClass'} }
      },
];

export default class Hp_historiqueFacturation extends NavigationMixin(LightningElement) {
    @track columnsELEC = columnsELEC;
    @track columnsGAZ = columnsGAZ;
    @track factureInfo;
    @track _pcfdata;
    @track _contratLocaux;
    @track facturesELEC = [];
    @track facturesELEC_All = [];
    @track facturesGAZ = [];
    @track facturesGAZ_All = [];
    @track _idContratGaz;
    @track _idContratElec;
    @track createDateActions = [];
    @track statusActions = [];
    @track typeFactureActions = [];
    @track refFactureActions = [];
    @track _consommationData;
    sortedByElec='date_creation';
    defaultSortDirection = 'desc';
    sortDirectionElec = 'desc';
    sortedByGaz='date_creation';
    sortDirectionGaz = 'desc';

    @api
    set pfcdata(value) {
        if(value == null ) {
            return;
        }
        if(value.factureInfo != null) {
            this.factureInfo = value.factureInfo.data; 
        }
        this._pfcdata =  JSON.parse(JSON.stringify(value));
        this.processData();
    }
    get pfcdata() {
        return null;
    }

    @api
    set consommationData(value) {
        if(value == null ) {
            return;
        }
        this._consommationData =  JSON.parse(JSON.stringify(value));
    }
    get consommationData() {
        return null;
    }

    @api
    set contratLocaux(value){
        if(value==null){
            return;
        }
        this._contratLocaux = value;
    }
    get contratLocaux(){
        return null;
    }

    @api
    set idContratElec(value){
        if(value==null){
            return;
        }
        this._idContratElec = value;
    }
    get idContratElec(){
        return null;
    }

    @api
    set idContratGaz(value){
        if(value==null){
            return;
        }
        this._idContratGaz = value;
    }
    get idContratGaz(){
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
        return this.facturesELEC_All.length > 0 ;
    }

    get showGAZ(){
        return this.facturesGAZ.length > 0 ;
    }

    onHandleSortElec(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.facturesELEC];
        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'asc' ? 1 : -1 ) );
        this.facturesELEC = cloneData;
        this.sortDirectionElec = sortDirection;
        this.sortedByElec = sortedBy;
    }

    onHandleSortGaz(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.facturesGAZ];
        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'asc' ? 1 : -1 ) );
        this.facturesELEC = cloneData;
        this.facturesGAZ = sortDirection;
        this.sortedByGaz = sortedBy;
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
        const cols = this.columnsELEC;
        if (actionName !== undefined && actionName !== 'all') {
            if(colDef.fieldName === 'type_facture'){
                this.facturesELEC = this.facturesELEC_All.filter(_fact => _fact.type_facture === actionName);
            }else if(colDef.fieldName === 'ref_facture'){
                this.facturesELEC = this.facturesELEC_All.filter(_fact => _fact.ref_facture === actionName);
            }else if(colDef.fieldName === 'statut'){
                this.facturesELEC = this.facturesELEC_All.filter(_fact => _fact.statut === actionName);
            }
            else if(colDef.fieldName === 'date_creation'){
                this.facturesELEC = this.facturesELEC_All.filter(_fact => String.valueOf(_fact.date_creation) === String.valueOf(actionName));
            }
            
        } else if (actionName === 'all') {
            this.facturesELEC = this.facturesELEC_All;
        }
        cols.find(col => col.label === colDef.label).actions.forEach(action => action.checked = action.name === actionName);
        this.columnsELEC = [...cols];
    }

    handleHeaderActionGAZ(event) {
        const actionName = event.detail.action.name;
        const colDef = event.detail.columnDefinition;
        const cols = this.columnsELEC;
        if (actionName !== undefined && actionName !== 'all') {
            if(colDef.fieldName === 'type_facture'){
                this.facturesGAZ = this.facturesGAZ_All.filter(_fact => _fact.type_facture === actionName);
            }else if(colDef.fieldName === 'ref_facture'){
                this.facturesGAZ = this.facturesGAZ_All.filter(_fact => _fact.ref_facture === actionName);
            }else if(colDef.fieldName === 'statut'){
                this.facturesGAZ = this.facturesGAZ_All.filter(_fact => _fact.statut === actionName);
            }
            else if(colDef.fieldName === 'date_creation'){
                this.facturesGAZ = this.facturesGAZ_All.filter(_fact => String.valueOf(_fact.date_creation) === String.valueOf(actionName));
            }
        } else if (actionName === 'all') {
            this.facturesGAZ = this.facturesGAZ_All;
        }
        cols.find(col => col.label === colDef.label).actions.forEach(action => action.checked = action.name === actionName);
        this.columnsGAZ = [...cols];
    }

    processData(){
        if(this.factureInfo == null || this.factureInfo.output == null || this.factureInfo.output.factures == null) {
            return;
        }
        const factures = this.factureInfo.output.factures;
        
        for(let key in this.factureInfo.output.factures) {
            let typeFacture;
            let statutFacture;
            let fieldCSSClass;
            switch(factures[key].type_facture){
                case '0':
                    typeFacture = 'Simulation';
                    break;   
                case '1':
                    typeFacture = 'Régularisation';
                    break;
                case '2':
                    typeFacture = 'Intermédiaire';
                    break; 
                case '3':
                    typeFacture = 'Mise en service / Contrat';
                    break;  
                case '4':
                    typeFacture = 'Rectificative';
                    break;  
                case '5':
                    typeFacture = 'Résiliation';
                    break;  
                case '6':
                    typeFacture = 'Avoir';
                    break;  
                case '7':
                    typeFacture = 'Ajustement';
                    break;  
                case '8':
                    typeFacture = 'Ponctuelle';
                    break;  
                case '9':
                    typeFacture = 'Remise';
                    break;  
                case '10':
                    typeFacture = 'Régularisation Anticipée';
                    break;  
                case '11':
                    typeFacture = 'Facture bimestrielle';
                    break;  
                case '12':
                    typeFacture = 'Facture de résiliation sur périodicité bimestrielle';
                    break;   
                case '13':
                    typeFacture = 'Régularisation Bimestrielle';
                    break;     
            }
            switch(factures[key].statut){
                case '1' : 
                statutFacture = 'Non soldée';
                break; 
                case '2' : 
                statutFacture = 'Partiellement soldée';
                break; 
                case '3' : 
                statutFacture = 'Soldée';
                break; 
                case '4' : 
                statutFacture = 'Régularisée';
                break; 
                default:
                statutFacture = 'Annulée';
                break;
            }
            if (statutFacture == 'Annulée') {
                fieldCSSClass = 'marked-p3';
            }
            if (factures[key].etat.startsWith('contestee') || factures[key].etat.startsWith('hors seuil') || factures[key].etat.startsWith('bloquee')) {
                fieldCSSClass = 'marked-p2';
            }
            if (factures[key].irrecouvrable != '') {
                fieldCSSClass = 'marked-p1';
            }
            let tempArray = {
                id:key,
                ref_facture:factures[key].ref_facture, 
                date_creation:new Date(factures[key].date_creation),
                type_facture:typeFacture,
                montant_ttc:factures[key].montant_ttc,
                montant_restant_du:factures[key].montant_restant_du,
                date_limite_de_paiement:new Date(factures[key].date_limite_de_paiement),
                statut: statutFacture,
                fieldCSSClass: fieldCSSClass
            };

            const creationDateformatted = new Intl.DateTimeFormat({
                year: 'numeric',
                month: 'numeric',
                day: 'numeric'
            }).format(new Date(factures[key].date_creation));
            //const statutLabel = factures[key].statut!=null ? factures[key].statut : '--';
            const refFacture = factures[key].ref_facture;

            if(this.typeFactureActions.filter(value => value.label !== typeFacture).length !== this.typeFactureActions.length){
                this.typeFactureActions = this.typeFactureActions.filter(value => value.label !== typeFacture);
            }
            if(this.statusActions.filter(value => value.label !== statutFacture).length !== this.statusActions.length){
                this.statusActions = this.statusActions.filter(value => value.label !== statutFacture);
            }
            if(this.refFactureActions.filter(value => value.label !== refFacture).length !== this.refFactureActions.length){
                this.refFactureActions = this.typeFactureActions.filter(value => value.label !== refFacture);
            }
            if(this.createDateActions.filter(value => value.label !== creationDateformatted).length !== this.createDateActions.length){
                this.createDateActions = this.createDateActions.filter(value => value.label !== creationDateformatted);
            }

            this.statusActions.push({label:statutFacture, checked : false, name : statutFacture});
            this.refFactureActions.push({label:factures[key].ref_facture, checked : false, name : factures[key].ref_facture});
            this.typeFactureActions.push({label:typeFacture, checked : false, name:typeFacture});
            this.createDateActions.push({label:creationDateformatted, checked : false, name:creationDateformatted});
            if(factures[key].energie ==='elec'){
                this.facturesELEC_All.push(tempArray);
                this.facturesELEC.push(tempArray);
            }else if(factures[key].energie ==='gaz'){
                this.facturesGAZ.push(tempArray);
                this.facturesGAZ_All.push(tempArray);
            }
            
        }
        if(this.columnsELEC.length > 0){
            this.columnsELEC.forEach(col => {
                if (col.fieldName === 'statut') {
                    col.actions = [...DEFAULT_ACTIONS,...this.statusActions];
                }else if (col.fieldName === 'ref_facture') {
                    col.actions = [...DEFAULT_ACTIONS,...this.refFactureActions];
                }else if (col.fieldName === 'type_facture') {
                    col.actions = [...DEFAULT_ACTIONS,...this.typeFactureActions];
                }else if (col.fieldName === 'date_creation') {
                    col.actions = [...DEFAULT_ACTIONS,...this.createDateActions];
                }
            });
        }
        if(this.columnsGAZ.length > 0){
            this.columnsGAZ.forEach(col => {
                if (col.fieldName === 'statut') {
                    col.actions = [...DEFAULT_ACTIONS,...this.statusActions];
                }else if (col.fieldName === 'ref_facture') {
                    col.actions = [...DEFAULT_ACTIONS,...this.refFactureActions];
                }else if (col.fieldName === 'type_facture') {
                    col.actions = [...DEFAULT_ACTIONS,...this.typeFactureActions];
                }else if (col.fieldName === 'date_creation') {
                    col.actions = [...DEFAULT_ACTIONS,...this.createDateActions];
                }
            });
        }
        
    }
    
    handleRowAction(event){
        let row = event.detail.row;
        console.log('Current Facture : '+JSON.stringify(this.factureInfo.output.factures[row.id]));
        let currentFacture = this.factureInfo.output.factures[row.id];
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__HP_DetailsFactureContainer'
            },
            state: {
                c__currentFacture: currentFacture,
                c__consommationData : this._consommationData
            }
        });
    }

}