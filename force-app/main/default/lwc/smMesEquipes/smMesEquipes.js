import { LightningElement, api, wire } from 'lwc';
import pubsub from 'c/pubsub';
import getEquipes from '@salesforce/apex/SM_CTRL011_AdministrationEquipes.getEquipes';
import { consoleLogHandler } from 'c/smConsoleLog';
import { searchInArrayOfObj } from 'c/smSearchKeyword';
import { refreshApex } from '@salesforce/apex';
import TeamError from '@salesforce/label/c.SM_COMPO_EQUIPE_ERROR';
import NoTeam from '@salesforce/label/c.SM_COMPO_EQUIPE_NO_TEAM';
import ConsTitleHover from '@salesforce/label/c.SM_COMPO_EQUIPE_CONS_TITLE_HOVER';
import RespTitleHover from '@salesforce/label/c.SM_COMPO_EQUIPE_RESP_TITLE_HOVER';
import Title from '@salesforce/label/c.SM_COMPO_EQUIPE_TITLE';
import { CurrentPageReference } from 'lightning/navigation';

export default class SmMesEquipes extends LightningElement {
    //Valriables permettant d'identifier le contexte (gestion des responsables/gestion des conseillers)
    //La config des variables est définie au niveau de l'app page
    @api isCompResponsable;
    @api isCompConseiler;

    currentPageReference = null;
    toRefresh=null;sitePresta=null; teamError = false; noTeam = false;urlTab=null; oldEquipe = '';
    equipes = []; equipesInit = [];conseillersList= [];nonAssignesList= [];responsablesList= [];responsablesEquipe= [];conseillersEquipe = [];
    label = {
        TeamError,
        NoTeam,
        ConsTitleHover,
        RespTitleHover,
        Title
    }

    connectedCallback() {
        this.register();
    }

    get titleHover(){
        let title = '';
        if(this.isCompResponsable){
            title = this.label.RespTitleHover;
        }else if (this.isCompConseiler){
            title = this.label.ConsTitleHover;
        }
        return title;
    }

    //Récupérer la data: Equipes, Responsables du site, Conseillers du site, Responsables par équipe, Conseillers par équipe
    @wire(getEquipes)
    getEquipes(result) {
        if (result != undefined && result.data != undefined) {
            if(Object.keys(result.data.equipes).length > 0){
                this.noTeam = false;
                this.teamError = false;
                this.handleAllLists(result);
            } else {
                this.noTeam = true;
                this.teamError = false;
            }
            //For refresh apex data after updating users in the lwc component 'smResponsablesEquipes'
            this.toRefresh = result;
        } else {
            consoleLogHandler('error getEquipes: ',JSON.stringify(result));
            this.teamError = true;
            this.noTeam = false;
        }
    }

    // construire les différentes listes
    handleAllLists(result){
        for(var equipe in result.data.equipes){
            let equipeObj = {
                nom:equipe,
                responsables: [],
                conseillers: []
            };
            for (var key in result.data.equipes[equipe]){
                if (key == 'responsablesEquipe') {
                    equipeObj.responsables.push(result.data.equipes[equipe][key]);  
                }
                if (key == 'conseillersEquipe') {
                    equipeObj.conseillers.push(result.data.equipes[equipe][key]);
                }
            }
            this.equipes.push(equipeObj);
            this.equipesInit.push(equipeObj);
        }
        this.sitePresta = result.data.site;
        this.conseillersList = result.data.allConseillers;
        this.responsablesList = result.data.allResponsables;
        this.nonAssignesList = result.data.allNonAssignes;

        consoleLogHandler('All Lists: ',JSON.stringify(result.data));
    }

    // Fonction de recherche
    searchKeyword(event) {
        let value = event.target.value;
        let objElem = 'nom';
        let result = searchInArrayOfObj(value,this.equipesInit,objElem);
        this.equipes = (result == undefined) ? this.equipesInit : result;  
    }

    composeTeam(event){
        //Reset All list to re-compose from the refreshed result
        this.conseillersList = [];this.responsablesList = [];this.nonAssignesList = [];this.equipes = [];this.conseillersEquipe = [];
        this.responsablesEquipe = [];
        
        this.handleAllLists(this.toRefresh);

        //Desélectionner l'ancienne équipe séléctionnée
        if (this.oldEquipe.length>0) {
            this.template.querySelector(`[data-id="${this.oldEquipe}"]`).classList.remove('selected'); 
        }

        let nomEquipe = event.target.dataset.nomEquipe;
        let newArr = nomEquipe.split('_');
        let numEquipe = newArr[1];
        let equipe = this.equipes.find(equipe => equipe.nom === nomEquipe);

        this.oldEquipe = nomEquipe;

        //Sélectionner l'ancienne équipe séléctionnée
        this.template.querySelector(`[data-id="${nomEquipe}"]`).classList.add('selected');

        if (this.isCompConseiler) {
            this.handleTeamList(equipe.conseillers,this.conseillersEquipe);
        }
        //In both cases 'responsables/conseillers' we compose the responsablesEquipe List
        this.handleTeamList(equipe.responsables,this.responsablesEquipe);

        let params = {
            listeResponsables: this.responsablesList,
            listeConseillers: this.conseillersList,
            listeNonAssignes: this.nonAssignesList,
            responsablesEquipe: this.responsablesEquipe,
            conseillersEquipe: this.conseillersEquipe,
            equipeSelectionnee: nomEquipe,
            numEquipeSelectionnee: numEquipe,
            site: this.sitePresta
        };
        if (this.isCompConseiler) {
            params.typeEquipe = 'conseiller';
        } else if (this.isCompResponsable){
            params.typeEquipe = 'responsable';
        }
        pubsub.fire('compoEquipeEvt', params);
        consoleLogHandler('params to send: ',JSON.stringify(params));
    }

    handleTeamList(teamUsers, teamList){
        //If the selected Team has users (responsables ou conseillers)
        if (teamUsers != undefined && teamUsers.length>0) {
            teamUsers[0].forEach(usr => {
                var elem = {
                    label: usr.LastName +' '+usr.FirstName,
                    role: usr.UserRole.Name,
                    value: usr.Username
                };
                teamList.push(elem);
            });
        }
    }

    register(){
        consoleLogHandler('event mesEquipesEvt registred',null);
        pubsub.register('mesEquipesEvt', this.handleEvent.bind(this));
    }

    //Refresh Data with refreshApex
    handleEvent(eventParams){
        refreshApex(this.toRefresh);
        consoleLogHandler('Data refreshed',null);
    }
}