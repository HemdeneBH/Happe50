/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 

 * @last modified on  : 07-07-2021

 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                 Modification
 * 1.0   06-15-2021   Hemdene Ben Hammouda   Initial Version
**/
import { LightningElement, wire, track, api } from 'lwc';
import loadConsoELEC from '@salesforce/apex/HP_SM062_ConsommationManager.getConsommationELEC';
import loadConsoGAZ from '@salesforce/apex/HP_SM062_ConsommationManager.getConsommationGAZ';
import ConsommationGazKo from '@salesforce/label/c.HP_ConsommationGazKo';
import ConsommationElecKo from '@salesforce/label/c.HP_ConsommationElecKo';
import ConsommationKo from '@salesforce/label/c.HP_ConsommationKo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columnsELEC = [
    {label: 'ID Facture', fieldName: 'idFacture', type: 'text', sortable: true, hideDefaultActions: true},
    {label: 'Statut Relève', fieldName: 'typeReleve', type: 'text', sortable: true, hideDefaultActions: true},
    {label: 'Motif Relève', fieldName: 'raison', type: 'text', hideDefaultActions: true},
    {label: 'Nature Index', fieldName: 'categorie', type: 'text', hideDefaultActions: true},
    {label: 'Type Comptage', fieldName: 'typeComptage', type: 'text', hideDefaultActions: true},
    {label: 'Rang Cadran', fieldName: 'rangCadran', type: 'text',sortable: true, hideDefaultActions: true},

    {label: 'Date de la relève', fieldName: 'dateReleve', type: 'date',sortable: true, hideDefaultActions: true,
        typeAttributes: {
            year: "2-digit",
            month: "2-digit",
            day: "2-digit"
        }
    },

    {label: 'Date Début', fieldName: 'dateDebut', type: 'text', hideDefaultActions: true},
    {label: 'Date Fin', fieldName: 'dateFin', type: 'text', hideDefaultActions: true},
    {label: 'Index Début', fieldName: 'indexDebut', type: 'text', hideDefaultActions: true},
    {label: 'Index Fin', fieldName: 'indexFin', type: 'text', hideDefaultActions: true},
    {label: 'Consommation Cadran', fieldName: 'consommationCadran', type: 'text', hideDefaultActions: true},
    {label: 'Mode de redressement', fieldName: 'modeRedressement', type: 'text', hideDefaultActions: true},
    {label: 'Changement Offre', fieldName: 'changementOffre', type: 'text', hideDefaultActions: true},
    {label: 'Motif Rectif', fieldName: 'motifRectification', type: 'text', hideDefaultActions: true},
    {label: 'Type de compteur', fieldName: 'typeCompteur', type: 'text', hideDefaultActions: true},
];

const columnsGAZ = [
    {label: 'ID Facture', fieldName: 'idFacture', type: 'text',sortable: true,  hideDefaultActions: true},
    {label: 'Type de la relève', fieldName: 'typeReleve', type: 'text',  hideDefaultActions: true},
    {label: 'Raison de la relève', fieldName: 'raison', type: 'text', hideDefaultActions: true},
    {label: 'Categorie de la relève', fieldName: 'categorie', type: 'text', hideDefaultActions: true},

    {label: 'Date de la relève', fieldName: 'dateReleve', type: 'date', hideDefaultActions: true, sortable: true,
        typeAttributes: {
            year: "2-digit",
            month: "2-digit",
            day: "2-digit"
        }
    },

    {label: 'Date de début de période de consommation', fieldName: 'dateDebut', type: 'text', hideDefaultActions: true},
    {label: 'Date fin de période de consommation', fieldName: 'dateFin', type: 'text', hideDefaultActions: true},
    {label: 'Volume brut consommé lors de la période de consommation', fieldName: 'volumeBrutGaz', type: 'text', hideDefaultActions: true},
    {label: 'Consommation Cadran', fieldName: 'consommationCadran', type: 'text', hideDefaultActions: true},
    {label: 'Index brut de début de période de consommation', fieldName: 'indexDebut', type: 'text', hideDefaultActions: true},
    {label: 'Index brut de fin de période de consommation', fieldName: 'indexFin', type: 'text', hideDefaultActions: true},
    {label: 'Coefficient Thermique', fieldName: 'kpcs', type: 'text', hideDefaultActions: true},
    {label: 'Origine relève', fieldName: 'originReleve', type: 'text', hideDefaultActions: true},
    {label: 'Type de compteur', fieldName: 'typeCompteur', type: 'text', hideDefaultActions: true},
];
const limitDisplay = 10;
export default class Hp_historiqueConsommation extends LightningElement {
    @track columnsELEC = columnsELEC;
    @track columnsGAZ = columnsGAZ;
    @track consoELECGlobal;
    @track consoGAZGlobal;
    @track isDataELECFirstLoad = true;
    @track isDataGAZFirstLoad = true;
    @track errorELEC;
    @track errorGAZ;
    @track currentIndexELEC = limitDisplay;
    @track currentIndexGAZ = limitDisplay;
    @track consoELECToDisplay;
    @track consoGAZToDisplay;
    @track showLoadMoreELEC;
    @track showLoadMoreGAZ;
    @track _hprefclient;
    @track _currentPDL;
    @track _currentPCE;
    @track _idContratGaz;
    @track _idContratElec;
    @track _contratLocaux;
    @track elecSpinner = true;
    @track gazSpinner = true;
    @track ConsommationKoMessage = ConsommationKo;
    @track ConsommationElecKoMessage = ConsommationElecKo;
    @track ConsommationGazKoMessage = ConsommationGazKo;
    @track remainingRowsElec;
    @track remainingRowsGaz;
    sortedByElec='dateReleve';
    defaultSortDirection = 'desc';

    sortDirectionElec = 'desc';
    sortedByGaz='dateReleve';
    sortDirectionGaz = 'desc';


    get isAdressLoaded(){
        return this._contratLocaux.numeroVoie != null;
    }

    get globalError(){
        return ((this.errorELEC != null && this.errorGAZ != null) || (this.errorELEC != null && !this._currentPCE) || (this.errorGAZ != null && !this._currentPDL));
            
    }

    get showSpinner(){
        return (this.gazSpinner && this.elecSpinner);
    }

    @api
    set hprefclient(value){
        if(value==null){
            return;
        }
        this._hprefclient = value;
    }
    get hprefclient(){
        return null;
    }

    @api
    set currentPDL(value){
        if(value==null){
            return;
        }
        this._currentPDL = value;
    }
    get currentPDL(){
        return null;
    }

    @api
    set currentPCE(value){
        if(value==null){
            this._currentPCE='';
        }else {
            this._currentPCE = value;
        }
    }
    get currentPCE(){
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

    @wire(loadConsoELEC,{idClientXdata:'$_hprefclient',pdl:'$_currentPDL'}) wiredConsoELEC({error,data}){
        if(data){
            this.consoELECGlobal = data;
            if(this.consoELECGlobal.length > this.currentIndexELEC){
                this.consoELECToDisplay = this.consoELECGlobal.slice(0,this.currentIndexELEC);
                this.elecSpinner = false;
                this.showLoadMoreELEC = true;
                this.remainingRowsElec = this.consoELECGlobal.length - this.currentIndexELEC;
            }else if(this.consoELECGlobal.length >0){
                this.consoELECToDisplay = this.consoELECGlobal;
                this.elecSpinner = false;
                this.showLoadMoreELEC = false;
            }else {
                this.consoELECGlobal = undefined;
                this.consoELECToDisplay = undefined;
                this.elecSpinner = false;
                this.showLoadMoreELEC = false;
            }
            this.errorELEC = undefined;
        }
        if(error) {
            console.log(JSON.stringify(error));
            this.errorELEC = error.body.message;
            const evt = new ShowToastEvent({
                title: 'ERREUR',
                message: this.ConsommationElecKoMessage,
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.elecSpinner = false;
        }
    }

    @wire(loadConsoGAZ,{idClientXdata:'$_hprefclient',pce:'$_currentPCE'}) wiredConsoGAZ({error,data}){
        if(data){
            this.consoGAZGlobal = data;
            if(this.consoGAZGlobal.length > this.currentIndexGAZ){
                this.consoGAZToDisplay = this.consoGAZGlobal.slice(0,this.currentIndexGAZ);
                this.gazSpinner = false;
                this.showLoadMoreGAZ = true;
                this.remainingRowsGaz = this.consoGAZGlobal.length - this.currentIndexGAZ;
                
            }else if(this.consoGAZGlobal.length > 0){
                this.consoGAZToDisplay = this.consoGAZGlobal;
                this.gazSpinner = false;
                this.showLoadMoreGAZ = false; 
            }else {
                this.consoGAZGlobal = undefined;
                this.consoGAZToDisplay = undefined;
                this.gazSpinner = false;
                this.showLoadMoreGAZ = false;  
            }
            this.errorGAZ = undefined;
        }
        if(error) {
            this.errorGAZ = error.body.message;
            const evt = new ShowToastEvent({
                title: 'ERREUR',
                message: this.ConsommationGazKoMessage,
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.gazSpinner = false;
        }
    }

    loadMoreELEC(event){
            if((this.consoELECGlobal.length - this.currentIndexELEC) >= limitDisplay){
                const currentELEC = this.consoELECToDisplay;
                const newELEC = this.consoELECGlobal.slice(this.currentIndexELEC,this.currentIndexELEC+limitDisplay);
                const newELECToDisplay = currentELEC.concat(newELEC);
                this.consoELECToDisplay = newELECToDisplay;
                this.currentIndexELEC += limitDisplay;
                this.remainingRowsElec = this.consoELECGlobal.length - this.currentIndexELEC;
                if(this.consoELECGlobal.length < this.currentIndexELEC){
                    this.showLoadMoreELEC = false;
                }
            }else {
                const currentELEC = this.consoELECToDisplay;
                const newELEC = this.consoELECGlobal.slice(this.currentIndexELEC);
                const newELECToDisplay = currentELEC.concat(newELEC);
                this.consoELECToDisplay = newELECToDisplay;
                this.currentIndexELEC = this.consoELECGlobal.length;
                this.showLoadMoreELEC = false;
            }  
        }
    
    loadMoreGAZ(event){
            if((this.consoGAZGlobal.length - this.currentIndexGAZ) >= limitDisplay){
                const currentGAZ = this.consoGAZToDisplay;
                const newGAZ = this.consoGAZGlobal.slice(this.currentIndexGAZ,this.currentIndexGAZ+limitDisplay);
                const newGAZToDisplay = currentGAZ.concat(newGAZ);
                this.consoGAZToDisplay = newGAZToDisplay;
                this.currentIndexGAZ += limitDisplay;
                this.remainingRowsGaz = this.consoGAZGlobal.length - this.currentIndexGAZ;
                if(this.consoGAZGlobal.length < this.currentIndexGAZ){
                    this.showLoadMoreGAZ = false;
                }
            }else {
                const currentGAZ = this.consoGAZToDisplay;
                const newGAZ = this.consoGAZGlobal.slice(this.currentIndexGAZ);
                const newGAZToDisplay = currentGAZ.concat(newGAZ);
                this.consoGAZToDisplay = newGAZToDisplay;
                this.currentIndexGAZ = this.consoGAZGlobal.length;
                this.showLoadMoreGAZ = false;
            }  
        }

      onHandleSortElec(event) {

        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.consoELECToDisplay];

        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'asc' ? 1 : -1 ) );
        this.consoELECToDisplay = cloneData;
        this.sortDirectionElec = sortDirection;
        this.sortedByElec = sortedBy;

    }
    onHandleSortGaz(event) {

        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.consoGAZToDisplay];

        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'asc' ? 1 : -1 ) );
        this.consoGAZToDisplay = cloneData;
        this.sortDirectionGaz = sortDirection;
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
}