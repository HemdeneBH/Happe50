import { LightningElement, api } from 'lwc';
import { consoleLogHandler } from 'c/smConsoleLog';
import { searchInArrayOfObj } from 'c/smSearchKeyword';
import { searchMultipleInArrayOfObj } from 'c/smSearchKeyword';
import { filterArrayOfObjByDates } from 'c/smSearchKeyword';
import HistoriqueTitle from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_TITLE';
import RetourHaut from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_RETOUR_HAUT';
import Fermer from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_FERMER';
import Chargement from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_CHARGEMENT';
import NoContacts from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_NO_CONTACTS';
import ErrorLoadingContacts from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_ERROR_CONTACTS';
import Reessayer from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_REESAYER';
import NoContactsSoFar from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_NO_CONTACTS_SOFAR';
import NoContactsFilter from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_NO_CONTACTS_FILTER';
import ErraseFilter from '@salesforce/label/c.SM_HISTORIQUE_SYMPHONIE_ERRASE_FILTER';
import FILTER_LOGO from '@salesforce/resourceUrl/filterLogo';

import getDemandes from '@salesforce/apex/SM_CTRL012_HistoriqueSymphonie.getDemandes';

export default class SmHistoriqueSymphonie extends LightningElement {
    @api idPersonne;

    listeDemandes = []; listeDemandesInit = []; demandeDetails = {}; filterActivites = [];
    isShowDemandeDetails = false; showSpinner = false; noResultFilter = false; errorGetDemandes = false; showAllDemandesBtn = true; nbrDemandes = 0;
    today; todayToShow; lastYear; lastFourYears; fromDate; SoFar = false; noResult = false;
    label = { HistoriqueTitle, RetourHaut, Fermer, Chargement, NoContacts, Reessayer, NoContactsSoFar, ErrorLoadingContacts, NoContactsFilter, ErraseFilter }
    svgURL = `${FILTER_LOGO}#Capa_1`;

    connectedCallback(){
        this.init();
    }
    padTo2Digits(num) {
        return num.toString().padStart(2, '0');
    }
    formatDate(date) {
        return [
          this.padTo2Digits(date.getDate()),
          this.padTo2Digits(date.getMonth() + 1),
          date.getFullYear(),
        ].join('/');
    }
    initDates(){
        let todayOrig = new Date();
        this.todayToShow = this.formatDate(todayOrig);
        consoleLogHandler('today To Show: ',JSON.stringify(this.todayToShow));
        todayOrig.setDate(todayOrig.getDate() + 1);
        this.today = this.formatDate(todayOrig);
        consoleLogHandler('today for callout: '+this.today);

        let lastYearOrig = new Date();
        lastYearOrig.setFullYear(todayOrig.getFullYear()-1);
        this.lastYear = this.formatDate(lastYearOrig);

        let lastFourYearsOrig = new Date();
        lastFourYearsOrig.setFullYear(todayOrig.getFullYear()-4);
        this.lastFourYears = this.formatDate(lastFourYearsOrig);
        
        consoleLogHandler('lastYear: ',JSON.stringify(this.lastYear));
        consoleLogHandler('lastFourYears: ',JSON.stringify(this.lastFourYears));

    }
    sortDemandesByRecentDate(listeDemandes){
        listeDemandes.sort(function(a,b) {
            let date1 = parseInt(a.dateCreation.split('/').reverse().join(''));
            let date2 = parseInt(b.dateCreation.split('/').reverse().join(''));
            if (date1 < date2) {
                return 1;
            }else if (date1 > date2){
                return -1;
            }
            else{return 0;}
        });
    }
    init(){
        this.initDates();
        this.showSpinner = true;
        this.getFirstYearDemandes();
    }  
    getFirstYearDemandes(){
        consoleLogHandler('idPersonne: ',this.idPersonne);
        this.fromDate = this.lastYear;
        getDemandes({
            dateDebut: this.fromDate,
            dateFin: this.today,
            idPersonne: this.idPersonne
        }).then(result => {
            consoleLogHandler('getDemandes result: ',JSON.stringify(result));
            //Une seule demande
            if (result.length == 1) {
                let isError = result[0].isError;
                let isEmpty = result[0].isEmpty;
                //Quand aucune demande historique existe pour le contact
                if (isEmpty) {
                    consoleLogHandler('Aucune demande existe pour le contact: ',null);
                    this.noResultSoFar = true;
                    this.errorGetDemandes = false;
                } else if(isError) { // Erreur lors de la récupération des demandes
                    consoleLogHandler('Erreur lors de la récupération des demandes: ',null);
                    this.errorGetDemandes = true;
                    this.noResultSoFar = false;
                }else {
                    this.errorGetDemandes = false;
                    this.noResultSoFar = false;
                    this.handleDemandes(result);
                }
            } else {
                this.errorGetDemandes = false;
                this.noResultSoFar = false;
                this.handleDemandes(result);
                this.handleActiviteFilter(this.listeDemandesInit);
            }
            this.showSpinner = false;
        })
        .catch(error => {
            consoleLogHandler('@@error getFirstYearDemandes: ',JSON.stringify(error));
            this.showSpinner = false;
            this.errorGetDemandes = true;
        });
    }
    handleDemandes(demandes){
        this.listeDemandes = [...demandes];
        this.listeDemandesInit = [...this.listeDemandes];
        //Trier par date (du plus récent au plus ancien)
        this.sortDemandesByRecentDate(this.listeDemandes);
        this.sortDemandesByRecentDate(this.listeDemandesInit);
        this.nbrDemandes = demandes.length;
    }
    /* Construire la liste des options pour le filtre Activité (Filtre dynamic) en fonction du résultat des demandes récupérées */
    handleActiviteFilter(demandes){
        /* La fonction reduce permet de supprimer les doublons par activité */
        this.filterActivites = demandes.reduce((acc, current) => {
            const x = acc.find(item => item.activite === current.activite);
            if (!x) {
              return acc.concat([current]);
            } else {
              return acc;
            }
        }, []);
        consoleLogHandler('filterActivites: ',JSON.stringify(this.filterActivites));
    }
    getAllDemandes(){
        consoleLogHandler('getAllDemandes: ',null);
        this.showSpinner = true;
        this.noResultFilter = false;
        this.errorGetDemandes = false;
        this.resetFilters();
        this.noResultSoFar = false;
        this.fromDate = this.lastFourYears;
        
        getDemandes({
            dateDebut: this.fromDate,
            dateFin: this.today,
            idPersonne: this.idPersonne
        }).then(result => {
            consoleLogHandler('getAllDemandes result: ',JSON.stringify(result));

            //Une seule demande
            if (result.length == 1) {
                let isError = result[0].isError;
                let isEmpty = result[0].isEmpty;
                //Quand aucune demande historique existe pour le contact
                if (isEmpty) {
                    consoleLogHandler('Aucune demande existe pour le contact: ',null);
                    this.noResult = true;
                    this.errorGetDemandes = false;
                } else if(isError) { // Erreur lors de la récupération des demandes
                    consoleLogHandler('Erreur lors de la récupération des demandes: ',null);
                    this.errorGetDemandes = true;
                    this.noResult = false;
                } else {
                    this.handleDemandes(result);
                }
            } else {
                this.noResult = false;
                this.errorGetDemandes = false;
                this.handleDemandes(result);
                this.handleActiviteFilter(this.listeDemandesInit);
            }
            this.showSpinner = false;
            this.showAllDemandesBtn = false;
        })
        .catch(error => {
            consoleLogHandler('@@error getAllDemandes: ',JSON.stringify(error));
            this.showSpinner = false;
            this.errorGetDemandes = true;
        });
    }
    showFilterCreation(){
        consoleLogHandler('showFilterCreation: ',null);
        if(this.template.querySelector('.filter-block.creation').classList.contains('display')){
            this.template.querySelector('.filter-block.creation').classList.remove('display');
        }else{
            this.template.querySelector('.filter-block.creation').classList.add('display');
            this.template.querySelector('.filter-block.statut').classList.remove('display');
            this.template.querySelector('.filter-block.canal').classList.remove('display');
            this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
            this.template.querySelector('.filter-block.comment').classList.remove('display');
            this.template.querySelector('.filter-block.activite').classList.remove('display');
        }
    }
    showFilterCanal(){
        consoleLogHandler('showFilterCanal: ',null);
        if(this.template.querySelector('.filter-block.canal').classList.contains('display')){
            this.template.querySelector('.filter-block.canal').classList.remove('display');
        }else{
            this.template.querySelector('.filter-block.canal').classList.add('display');
            this.template.querySelector('.filter-block.statut').classList.remove('display');
            this.template.querySelector('.filter-block.creation').classList.remove('display');
            this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
            this.template.querySelector('.filter-block.comment').classList.remove('display');
            this.template.querySelector('.filter-block.activite').classList.remove('display');
        }
    }
    showFilterStatut(){
        consoleLogHandler('showFilterStatut: ',null);
        if(this.template.querySelector('.filter-block.statut').classList.contains('display')){
            this.template.querySelector('.filter-block.statut').classList.remove('display');
        }else{
            this.template.querySelector('.filter-block.statut').classList.add('display');
            this.template.querySelector('.filter-block.canal').classList.remove('display');
            this.template.querySelector('.filter-block.creation').classList.remove('display');
            this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
            this.template.querySelector('.filter-block.comment').classList.remove('display');
            this.template.querySelector('.filter-block.activite').classList.remove('display');
        }
    }
    showFilterActivite(){
        consoleLogHandler('showFilterActivite: ',null);
        if(this.template.querySelector('.filter-block.activite').classList.contains('display')){
            this.template.querySelector('.filter-block.activite').classList.remove('display');
        }else{
            this.template.querySelector('.filter-block.activite').classList.add('display');
            this.template.querySelector('.filter-block.canal').classList.remove('display');
            this.template.querySelector('.filter-block.creation').classList.remove('display');
            this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
            this.template.querySelector('.filter-block.comment').classList.remove('display');
            this.template.querySelector('.filter-block.statut').classList.remove('display');
        }
    }
    showFilterPJ(){
        consoleLogHandler('showFilterPJ: ',null);
        if(this.template.querySelector('.filter-block.piece-jointe').classList.contains('display')){
            this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
        }else{
            this.template.querySelector('.filter-block.piece-jointe').classList.add('display');
            this.template.querySelector('.filter-block.statut').classList.remove('display');
            this.template.querySelector('.filter-block.creation').classList.remove('display');
            this.template.querySelector('.filter-block.canal').classList.remove('display');
            this.template.querySelector('.filter-block.comment').classList.remove('display');
            this.template.querySelector('.filter-block.activite').classList.remove('display');
        }
    }
    showFilterComment(){
        consoleLogHandler('showFilterComment: ',null);
        if(this.template.querySelector('.filter-block.comment').classList.contains('display')){
            this.template.querySelector('.filter-block.comment').classList.remove('display');
        }else{
            this.template.querySelector('.filter-block.comment').classList.add('display');
            this.template.querySelector('.filter-block.statut').classList.remove('display');
            this.template.querySelector('.filter-block.creation').classList.remove('display');
            this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
            this.template.querySelector('.filter-block.canal').classList.remove('display');
        }
    }
    scrollTop(){
        window.scroll(
            {
                top: 0,
                left: 0,
                behavior: 'smooth'
            }
        );
    }
    updateFilterCreation(event){
        let inputDu = this.template.querySelector('input[data-id=creation-input-du]').value;
        let inputAu = this.template.querySelector('input[data-id=creation-input-au]').value;
        consoleLogHandler('inputDu: ',inputDu);
        consoleLogHandler('inputAu: ',inputAu);
        let fromDate = this.formatDate(new Date(inputDu));
        let toDate = this.formatDate(new Date(inputAu));
        consoleLogHandler('fromDate: ',fromDate);
        consoleLogHandler('toDate: ',toDate);
        let objElem = 'dateCreation';
        let result = filterArrayOfObjByDates(inputDu,inputAu,this.listeDemandesInit,objElem);
        this.listeDemandes = result;
        this.sortDemandesByRecentDate(this.listeDemandes);
        this.template.querySelector('.filter-block.creation').classList.remove('display');
        this.noResultFilter = result.length==0 ? true:false;
    }
    updateFilterCanal(event){
        let canaux = [];
        let checkboxSMS = this.template.querySelector('input[data-id=checkbox-sms]');
        let checkboxPortail = this.template.querySelector('input[data-id=checkbox-portail]');
        let checkboxBackOffice = this.template.querySelector('input[data-id=checkbox-backoffice]');
        let checkboxEmail = this.template.querySelector('input[data-id=checkbox-email]');
        let checkboxPartenaire = this.template.querySelector('input[data-id=checkbox-partenaire]');
        let checkboxCourrier = this.template.querySelector('input[data-id=checkbox-courrier]');
        let checkboxTelephone = this.template.querySelector('input[data-id=checkbox-telephone]');
        if(checkboxSMS.checked){
            canaux.push(checkboxSMS.value);
        }
        if(checkboxPortail.checked){
            canaux.push(checkboxPortail.value);
        }
        if(checkboxBackOffice.checked){
            canaux.push(checkboxBackOffice.value);
        }
        if(checkboxEmail.checked){
            canaux.push(checkboxEmail.value);
        }
        if(checkboxPartenaire.checked){
            canaux.push(checkboxPartenaire.value);
        }
        if(checkboxCourrier.checked){
            canaux.push(checkboxCourrier.value);
        }
        if(checkboxTelephone.checked){
            canaux.push(checkboxTelephone.value);
        }
        let objElem = 'canal';
        let result = searchMultipleInArrayOfObj(canaux,this.listeDemandesInit,objElem);
        consoleLogHandler('result: ',JSON.stringify(result));
        this.listeDemandes = result;
        this.sortDemandesByRecentDate(this.listeDemandes);
        this.template.querySelector('.filter-block.canal').classList.remove('display');
        this.noResultFilter = result.length==0 ? true:false;
    }
    updateFilterCommentaire(event){
        let motcle = this.template.querySelector('input[data-id=text-commentaire]').value;
        let objElem = 'commentaire';
        let result = searchInArrayOfObj(motcle,this.listeDemandesInit,objElem);
        consoleLogHandler('result: ',JSON.stringify(result));
        this.listeDemandes = result;
        this.sortDemandesByRecentDate(this.listeDemandes);
        this.template.querySelector('.filter-block.comment').classList.remove('display');
        this.noResultFilter = result.length==0 ? true:false;
    }
    updateFilterStatut(event){
        consoleLogHandler('updateFilterStatut: ',null);
        let statuts = [];
        let checkboxAtraiter = this.template.querySelector('input[data-id=checkbox-atraiter]');
        let checkboxEncours = this.template.querySelector('input[data-id=checkbox-encours]');
        let checkboxEnattente = this.template.querySelector('input[data-id=checkbox-enattente]');
        let checkboxTermine = this.template.querySelector('input[data-id=checkbox-termine]');

        if(checkboxAtraiter.checked){
            statuts.push(checkboxAtraiter.value);
        }
        if(checkboxEncours.checked){
            statuts.push(checkboxEncours.value);
        }
        if(checkboxEnattente.checked){
            statuts.push(checkboxEnattente.value);
        }
        if(checkboxTermine.checked){
            statuts.push(checkboxTermine.value);
        }

        let objElem = 'statut';
        let result = searchMultipleInArrayOfObj(statuts,this.listeDemandesInit,objElem);
        consoleLogHandler('result: ',JSON.stringify(result));
        this.listeDemandes = result;
        this.sortDemandesByRecentDate(this.listeDemandes);
        this.template.querySelector('.filter-block.statut').classList.remove('display');
        this.noResultFilter = result.length==0 ? true:false;
    }
    updateFilterPJ(event){
        let isURLList = [];
        let checkboxAvecPJ = this.template.querySelector('input[data-id=checkbox-avecpj]');
        let checkboxSansPJ = this.template.querySelector('input[data-id=checkbox-sanspj]');

        if(checkboxAvecPJ.checked){
            isURLList.push(true);
        }
        if(checkboxSansPJ.checked){
            isURLList.push(false);
        }

        let objElem = 'isURLExist';
        let result = searchMultipleInArrayOfObj(isURLList,this.listeDemandesInit,objElem);
        consoleLogHandler('result: ',JSON.stringify(result));
        this.listeDemandes = result;
        this.sortDemandesByRecentDate(this.listeDemandes);
        this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
        this.noResultFilter = result.length==0 ? true:false;
    }
    updateFilterActivite(event){
        const activiteList = [];
        this.filterActivites.forEach(activiteElem => {
            let checkboxActiviteElem = this.template.querySelector(`input[data-id=${activiteElem.idActivite}]`);
            if(checkboxActiviteElem.checked){
                activiteList.push(checkboxActiviteElem.value);
            }
        });
        let objElem = 'activite';
        let result = searchMultipleInArrayOfObj(activiteList,this.listeDemandesInit,objElem);
        consoleLogHandler('result: ',JSON.stringify(result));
        this.listeDemandes = result;
        this.sortDemandesByRecentDate(this.listeDemandes);
        this.template.querySelector('.filter-block.activite').classList.remove('display');
        this.noResultFilter = result.length==0 ? true:false;
    }
    hideFilters(){
        consoleLogHandler('hideFilters: ',null);
        this.template.querySelector('.filter-block.creation').classList.remove('display');
        this.template.querySelector('.filter-block.canal').classList.remove('display');
        this.template.querySelector('.filter-block.statut').classList.remove('display');
        this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
        this.template.querySelector('.filter-block.comment').classList.remove('display');
        this.template.querySelector('.filter-block.activite').classList.remove('display');
    }
    resetFilters(){
        this.listeDemandes = this.listeDemandesInit;
        this.template.querySelector('input[data-id=checkbox-sms]').checked = false;
        this.template.querySelector('input[data-id=checkbox-portail]').checked = false;
        this.template.querySelector('input[data-id=checkbox-backoffice]').checked = false;
        this.template.querySelector('input[data-id=checkbox-email]').checked = false;
        this.template.querySelector('input[data-id=checkbox-partenaire]').checked = false;
        this.template.querySelector('input[data-id=checkbox-courrier]').checked = false;
        this.template.querySelector('input[data-id=checkbox-telephone]').checked = false;
        this.template.querySelector('input[data-id=text-commentaire]').checked = false;
        this.template.querySelector('input[data-id=checkbox-atraiter]').checked = false;
        this.template.querySelector('input[data-id=checkbox-encours]').checked = false;
        this.template.querySelector('input[data-id=checkbox-enattente]').checked = false;
        this.template.querySelector('input[data-id=checkbox-termine]').checked = false;
        this.template.querySelector('input[data-id=checkbox-avecpj]').checked = false;
        this.template.querySelector('input[data-id=checkbox-sanspj]').checked = false;
        this.filterActivites.forEach(activiteElem => {
            this.template.querySelector(`input[data-id=${activiteElem.idActivite}]`).checked = false;
        });

        this.template.querySelector('.filter-block.statut').classList.remove('display');
        this.template.querySelector('.filter-block.piece-jointe').classList.remove('display');
        this.template.querySelector('.filter-block.creation').classList.remove('display');
        this.template.querySelector('.filter-block.canal').classList.remove('display');
        this.template.querySelector('.filter-block.activite').classList.remove('display');
        this.template.querySelector('.filter-block.comment').classList.remove('display');

        this.noResultFilter = false;
        this.errorGetDemandes = false;
    }
    openDemandeDetails(event){
        let demandeId = event.currentTarget.dataset.comentId;
        consoleLogHandler('demandeId: ',demandeId);
        let objElem = 'id';
        let result = searchInArrayOfObj(demandeId,this.listeDemandesInit,objElem);
        consoleLogHandler('demandeDetails: ',JSON.stringify(result));
        this.demandeDetails = result[0];

        this.isShowDemandeDetails = true;
        
    }
    closeDemandeDetails() {
        this.isShowDemandeDetails = false;
    }
    closeSubTab(){
        consoleLogHandler('closeSubTab: ',null);
        var close = true;
         const closeclickedevt = new CustomEvent('closeclicked', {
             detail: { close },
         });
         // Fire the custom event
         this.dispatchEvent(closeclickedevt);
    }
    cancelDetailModal(event){
        if (!event) var event = window.event; 
        event.cancelBubble = true;
        if (event.stopPropagation) event.stopPropagation();
    }

}