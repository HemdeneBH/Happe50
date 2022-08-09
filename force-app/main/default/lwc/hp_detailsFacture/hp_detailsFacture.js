/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 11-01-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getRelatedCases from '@salesforce/apex/HP_SM067_DetailsFactureController.getRelatedCasesByRefFacture';
import loadConsoELEC from '@salesforce/apex/HP_SM062_ConsommationManager.getConsommationELEC';
import loadConsoGAZ from '@salesforce/apex/HP_SM062_ConsommationManager.getConsommationGAZ';

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
    {label: 'Date d\'ouverture', fieldName: 'caseCreationDate', type: 'text', hideDefaultActions: true},

    {label: 'Statut', fieldName: 'caseStatus', type: 'text', hideDefaultActions: true},
    {label: 'Type Happe', fieldName: 'caseTypeHP', type: 'text', hideDefaultActions: true},
];
const limitDisplay = 2;
export default class Hp_detailsFacture extends NavigationMixin(LightningElement){
    
    @track _currentFacture;
    @track tpeFacture;
    @track columns = columns;
    @track refFacture ;
    @track relatedCases;
    @track relatedCasesToDisplay;
    @track _hprefclient;
    @track _currentPCE;
    @track _currentPDL;
    @track consommation;
    @track minIndex;
    @track maxIndex;
    @track _consommationData;
    @track isHPHC = false;
    @track showAll = false;

    @api
    set currentFacture(value) {
        if(value == null ) {
            return;
        }
        this._currentFacture =  JSON.parse(JSON.stringify(value));
        this.refFacture =  this._currentFacture.ref_facture;
        this.processData();
    }
    get currentFacture() {
        return null;
    }

    @api
    set consommationData(value) {
        if(value == null ) {
            return;
        }
        this._consommationData =  JSON.parse(JSON.stringify(value));
        this._hprefclient = this._consommationData.idXdata;
        this._currentPCE = this._consommationData.PCE != null ? this._consommationData.PCE : undefined;
        this._currentPDL = this._consommationData.PDL != null ? this._consommationData.PDL : undefined;
        this.processConsommation();
    }
    get consommationData() {
        return null;
    }

    @wire(getRelatedCases, {refFacture:'$refFacture'})wiredConsommation({error,data}){
        if(data){
            this.relatedCases = data;
            if(this.relatedCases.length > limitDisplay){
                this.relatedCasesToDisplay = this.relatedCases.slice(0,limitDisplay);
            }else if(this.relatedCases.length > 0){
                this.relatedCasesToDisplay = this.relatedCases;
            }
        }if(error){
            console.log('error: '+JSON.stringify(error));
        }
    }

    get numberOfCases(){
        if(this?.relatedCases){
            return this.relatedCases.length;
        }else{
            return 0;
        }
    }

    get cardTitle(){
        return ('Détails Facture '+this._currentFacture.ref_facture + ' - '+this._currentFacture.energie).toUpperCase();
    }

    get blocTitle(){
        return this.typeFacture + ' - ' + this._currentFacture.etat;
    }

    get eligiblePa(){
        return this._currentFacture.eligible_pa == true ? 'Oui' : 'Non'; 
    }

    get ouvertureCB(){
        return this._currentFacture.ouverture_cb == true ? 'Oui' : 'Non'; 
    }

    get createDate(){
        return this.formatDate(this._currentFacture.date_creation);
    }

    get dateLimite(){
        return this.formatDate(this._currentFacture.date_limite_de_paiement);
    }

    get dateDebutFacturation(){
        return this.formatDate(this._currentFacture.date_debut_facturation);
    }

    get dateFinFacturation(){
        return this.formatDate(this._currentFacture.date_fin_facturation);
    }

    get showRelatedCases(){
        if(this.relatedCases){
            return this.relatedCases.length>0;
        }else{
            return false;
        }
    }

    get prestataireRecouvrement() {
        return this._currentFacture.prestataire_recouvrement;
    }

    get recouvrementDate(){
        return this.formatDate(this._currentFacture.recouvrement);
    }

    get recouvrementEndDate(){    
        return this.formatDate(this._currentFacture.date_fin_recouvrement);
    }

    get irrecouvrableDate(){
        return this.formatDate(this._currentFacture.irrecouvrable);
    }

    get surEndettementStart(){
        return this.formatDate(this._currentFacture.surendettement_at);
    }

    get surEndettementEnd(){
        return this.formatDate(this._currentFacture.fin_surendettement_at);
    }

    get statutFacture(){
        let statut = '--';
        if(this?._currentFacture){
            switch(this._currentFacture.statut){
                case '1' : 
                    statut = 'Non soldée';
                    break; 
                    case '2' : 
                    statut = 'Partiellement soldée';
                    break; 
                    case '3' : 
                    statut = 'Soldée';
                    break; 
                    case '' :
                    statut = 'Annulée';
                    break;
            }
        }
        return statut;
    }

    get modalitePaiement(){
        let str = '';
        let tempArray = [];
            for(let key in this._currentFacture.modalite_de_paiement){
                switch(this._currentFacture.modalite_de_paiement[key]){   
                    case '1':
                        if(tempArray.includes('Carte Bancaire')){
                            break;
                        }else {
                            tempArray.push('Carte Bancaire');
                            break;
                        }
                    case '2':
                        if(tempArray.includes('Prélèvement')){
                            break;
                        }else {
                            tempArray.push('Prélèvement');
                            break;
                        }
                    case '3':
                        if(tempArray.includes('TIP Chèque')){
                            break;
                        }else {
                            tempArray.push('TIP Chèque');
                            break;
                        } 
                    case '4':
                        if(tempArray.includes('Virement')){
                            break;
                        }else {
                            tempArray.push('Virement');
                            break;
                        }
                    case '5':
                        if(tempArray.includes('Espèces')){
                            break;
                        }else {
                            tempArray.push('Espèces');
                            break;
                        }  
                    case '6':
                        if(tempArray.includes('Autre')){
                            break;
                        }else {
                            tempArray.push('Autre');
                            break;
                        }
                    case '7':
                        if(tempArray.includes('Mensualisation')){
                            break;
                        }else {
                            tempArray.push('Mensualisation');
                            break;
                        } 
                    case '8':
                        if(tempArray.includes('Compensation/Avoir')){
                            break;
                        }else {
                            tempArray.push('Compensation/Avoir');
                            break;
                        }  
                    case '9':
                        if(tempArray.includes('Chèque énergie')){
                            break;
                        }else {
                            tempArray.push('Chèque énergie');
                            break;
                        }
                    case '10':
                        if(tempArray.includes('Recouvrement')){
                            break;
                        }else {
                            tempArray.push('Recouvrement');
                            break;
                        }
                    case '11':
                        if(tempArray.includes('Paiement récurrent par carte bancaire')){
                            break;
                        }else {
                            tempArray.push('Paiement récurrent par carte bancaire');
                            break;
                        }
                    case '12':
                        if(tempArray.includes('Chèque et espèces')){
                            break;
                        }else {
                        tempArray.push('Chèque et espèces');
                        break;   
                }
            }
            }
                for(let i=0;i<tempArray.length;i++){
                    str = str+tempArray[i];
                    if(i+1 < tempArray.length){
                        str = str + ' - ';
                    }
                }
        return str;
    }

    showAllCases(event){
        this.showAll = true;
    }

    closeModal(event){
        this.showAll = false;
    }

    formatDate(dateStr){
        if(dateStr != '' && dateStr != undefined){
            return new Intl.DateTimeFormat({
                year: 'numeric',
                month: 'numeric',
                day: 'numeric'
            }).format(new Date(dateStr));
        }else{
            return '';
        }
    }
    processData(){
            switch(this._currentFacture.type_facture){
                case '0':
                    this.typeFacture = 'Simulation';
                    break;   
                case '1':
                    this.typeFacture = 'Régularisation';
                    break;
                case '2':
                    this.typeFacture = 'Intermédiaire';
                    break; 
                case '3':
                    this.typeFacture = 'Mise en service / Contrat';
                    break;  
                case '4':
                    this.typeFacture = 'Rectificative';
                    break;  
                case '5':
                    this.typeFacture = 'Résiliation';
                    break;  
                case '6':
                    this.typeFacture = 'Avoir';
                    break;  
                case '7':
                    this.typeFacture = 'Ajustement';
                    break;  
                case '8':
                    this.typeFacture = 'Ponctuelle';
                    break;  
                case '9':
                    this.typeFacture = 'Remise';
                    break;  
                case '10':
                    this.typeFacture = 'Régularisation Anticipée';
                    break;  
                case '11':
                    this.typeFacture = 'Facture bimestrielle';
                    break;  
                case '12':
                    this.typeFacture = 'Facture de résiliation sur périodicité bimestrielle';
                    break;   
                case '13':
                    this.typeFacture = 'Régularisation Bimestrielle';
                    break;     
            }
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

    processConsommation(){
        if(this._currentFacture.energie ==='elec' && this._currentPDL && this._hprefclient){
            loadConsoELEC({idClientXdata:this._hprefclient,pdl:this._currentPDL}).then(result =>{
                console.log('Result Elec : '+JSON.stringify(result));
                this.consommation =result;
                console.log('Consommation Elec : '+JSON.stringify(this.consommation));
                this.maxIndex = null;
                this.minIndex = null;
                for(let cons of this.consommation){
                    const formattedFacture = 'FACT'+cons.idFacture;
                    if(formattedFacture != this._currentFacture.ref_facture){
                        continue;
                    }
                    if(cons.typeComptage === 'Comptage HPHC'){
                        this.isHPHC = true;
                    }
                    if(this.maxIndex == null && this.minIndex == null){
                        this.maxIndex = cons.indexFin;
                        this.minIndex = cons.indexDebut;
                        continue;
                    }if(this.maxIndex < cons.indexFin){
                        this.maxIndex = cons.indexFin;
                        
                    }if(this.minIndex > cons.indexDebut){
                        this.minIndex = cons.indexDebut;
                    }
            }
            }).catch(error => {
                console.log('Error : '+JSON.stringify(error));
            }); 
        }else if(this._currentFacture.energie ==='gaz' && this._currentPCE && this._hprefclient) {
            loadConsoGAZ({idClientXdata:this._hprefclient,pce:this._currentPCE}).then(result =>{
                console.log('Result : '+JSON.stringify(result));
                this.consommation =result;
                this.maxIndex = null;
                this.minIndex = null;
                for(let cons of this.consommation){
                    const formattedFacture = 'FACT'+cons.idFacture;
                    if(formattedFacture != this._currentFacture.ref_facture){
                        continue;
                    }
                    if(this.maxIndex == null && this.minIndex == null){
                        this.maxIndex = cons.indexFin;
                        this.minIndex = cons.indexDebut;
                        continue;
                    }if(this.maxIndex < cons.indexFin){
                        this.maxIndex = cons.indexFin;
                        
                    }if(this.minIndex > cons.indexDebut){
                        this.minIndex = cons.indexDebut;
                    }
            }
            }).catch(error => {
                console.log('Error : '+JSON.stringify(error));
            }); 
        }
    }
}