import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub';
import updateUsers from '@salesforce/apex/SM_CTRL011_AdministrationEquipes.updateUsers';
import UpdateSuccess from '@salesforce/label/c.SM_COMPO_EQUIPE_UPDATE_SUCCESS';
import UpdateError from '@salesforce/label/c.SM_COMPO_EQUIPE_UPDATE_ERROR';
import NoRespError from '@salesforce/label/c.SM_COMPO_EQUIPE_NORESP_ERROR';
import NoConsError from '@salesforce/label/c.SM_COMPO_EQUIPE_NOCONS_ERROR';
import ConsTitle from '@salesforce/label/c.SM_COMPO_EQUIPE_CONS_TITLE';
import RespTitle from '@salesforce/label/c.SM_COMPO_EQUIPE_RESP_TITLE';
import CompConsTitle from '@salesforce/label/c.SM_COMPO_EQUIPE_COMP_CONS_TITLE';
import CompRespTitle from '@salesforce/label/c.SM_COMPO_EQUIPE_COMP_RESP_TITLE';
import { consoleLogHandler } from 'c/smConsoleLog';
import { toastHandler } from 'c/smToastEvent';

export default class SmCompoMesEquipes extends LightningElement {

    isCompResponsable = false; isCompConseiler = false;compTitle='';
    paramsSended = false;
    options = [];
    optionsFiltre = [];
    values = [];
    responsablesEquipe = [];
    showDualList = false;
    isTooMuchUsers = false;
    isNoUser = false;
    noUserMessage = null;
    equipe;
    role;
    listToUpdate={
        oldUsers: [],
        newUsers: [],
        role:undefined
    };
    label = {
        UpdateSuccess,
        UpdateError,
        NoRespError,
        NoConsError,
        CompRespTitle,
        CompConsTitle,
        ConsTitle,
        RespTitle
    }
    showSpinner=false;
    searchedValue = '';
    utilisateursInit = [];
    selectedFilterOptions = [];
    isModalOpen = false;
    _selected;
    resetSelect = false;

    //Fonction de recherche
    searchKeyword(event) {
        this.options = [];
        let value = event.target.value;
        let lowerCaseValue = value.toLowerCase();
        consoleLogHandler('selectedFilterOptions: ',JSON.stringify(this.selectedFilterOptions));
        let result = this.selectedFilterOptions.filter(option => {
            var elem = option.label.toLowerCase();
            return elem.includes(lowerCaseValue);
        });
        this.options = (result == undefined) ? this.selectedFilterOptions : result;
        if (this.values.length>0) {
            this.values.forEach(value => {
                var valueObj = this.utilisateursInit.find(obj => obj.value.toLowerCase() == value.toLowerCase());
                consoleLogHandler('valueObj: ',JSON.stringify(valueObj));
                this.options.push(valueObj);
            });
        } 
    }

    connectedCallback(){
        this.register();
    }


    closeModal() {
        this.isTooMuchUsers = false;
    }

    submitDetails() {
        this.isTooMuchUsers = false;
    }

    //Fonction pour gérer la liste des élements affichés en fonction du filtre choisi
    handleFiltre(e) {
        this.resetSelect = false;
        let filtreSelectionne = e.target.value;
        consoleLogHandler('filtre value: ',JSON.stringify(filtreSelectionne));
        let filtreObject = this.optionsFiltre.find(obj => obj.nom.toLowerCase() == filtreSelectionne.toLowerCase());
        consoleLogHandler('filtreObject: ',JSON.stringify(filtreObject));
        consoleLogHandler('new list: ',JSON.stringify(filtreObject.value));
        this.selectedFilterOptions = filtreObject.value;
        if (this.values.length>0) {
            this.values.forEach(value => {
                var valueObj = this.utilisateursInit.find(obj => obj.value.toLowerCase() == value.toLowerCase());
                consoleLogHandler('valueObj: ',JSON.stringify(valueObj));
                filtreObject.value.push(valueObj);
            });
        }
        
        this.options = filtreObject.value;
    }
    
    //Déterminer quel message à afficher quand l'équipe n'a aucun superviseur/conseiller
    handleNoUserMessage(userList) {
        if (userList.length==0) {
            this.isNoUser = true;
            this.noUserMessage = this.isCompResponsable ? this.label.NoRespError : this.label.NoConsError;
        } else {
            this.isNoUser = false;
            this.noUserMessage = null;
        }
    }


    handleChange(e) {
        this._selected = e.detail.value;

        //Afficher la popup 'plusieurs responsables' uniquement dans le cas composition des responsables
        if (this.isCompResponsable) {
            this.isTooMuchUsers = (this._selected.length>1) ? true:false;  
        }
        this.handleNoUserMessage(this._selected);
        

        let newResponsables = [];
        this.listToUpdate.newUsers = [];
        consoleLogHandler('_selected: ',this._selected);
        this._selected.forEach(responsableUsername => {
            newResponsables.push(responsableUsername);
            let responsable = this.utilisateursInit.find(obj => obj.value.toLowerCase() == responsableUsername.toLowerCase());
            consoleLogHandler('responsable: ',responsable);
            var nouveauResp = {};
            nouveauResp['label'] = responsable.label;
            nouveauResp['value'] = responsableUsername;
            nouveauResp['role'] = this.role;
            this.listToUpdate.newUsers.push(nouveauResp);
        });
        consoleLogHandler('values before: ',this.values);
        this.values = newResponsables;
        consoleLogHandler('values after: ',this.values);
        consoleLogHandler('this.listToUpdate: ',JSON.stringify(this.listToUpdate));
    }

    register(){
        consoleLogHandler('event compoEquipeEvt registred',null);
        pubsub.register('compoEquipeEvt', this.handleEvent.bind(this));
    }

    renderedCallback() {
        //Réinitialiser le filtre 
        if (this.resetSelect) {
            this.template.querySelector('[data-id="filtreSelect"]').selectedIndex = 0;
        }
    }

    handleTeamList(teamUsers, teamList){
        //If the selected Team has users (responsables ou conseillers)
        if (teamUsers != undefined && teamUsers.length>0) {
            teamUsers.forEach(usr => {
                teamList.push({
                    label: usr.LastName +' '+ usr.FirstName,
                    value: usr.Username,
                });
            });
        }
    }

    //Le role cible en fonction de l'équipe séléctionnée
    setRole(eventParams,teamList,name){
        if (teamList.length>0) {
            this.role = teamList[0].role; 
        } else {
            this.role = eventParams.site+name+eventParams.equipeSelectionnee;
        }
    }

    handleEvent(eventParams){
        consoleLogHandler('handleEvent',null);
        if(eventParams) {
            this.role = null;
            this.resetSelect = true;
            this.paramsSended = true;//to delete
            this.oldUser = eventParams.responsableSelectionne;//to delete
            this.options = [];this.values = [];this.utilisateursInit = [];this.selectedFilterOptions = []; this.optionsFiltre = [];this.responsablesEquipe = [];
            this.listToUpdate={
                oldUsers: [],
                newUsers: []
            };
            let itemsCons = [];let itemsResp = [];let itemsNonAssigned = [];
            
            let typeEquipe = eventParams.typeEquipe;
            this.equipe = eventParams.equipeSelectionnee;

            let nonAssignes = eventParams.listeNonAssignes;
            let conseillers = eventParams.listeConseillers;

            this.responsablesEquipe = eventParams.responsablesEquipe;

            this.handleTeamList(nonAssignes,itemsNonAssigned);
            this.handleTeamList(conseillers,itemsCons);

            if (typeEquipe == 'responsable') {
                consoleLogHandler('handle responsables',null);
                this.compTitle = this.label.CompRespTitle;
                let reponsables = eventParams.listeResponsables;
                this.handleTeamList(reponsables,itemsResp);

                this.isCompConseiler = false;
                this.isCompResponsable = true;

                this.setRole(eventParams, eventParams.responsablesEquipe,'_Responsable_');
                this.handleValuesAndUpdateLists(eventParams.responsablesEquipe, this.listToUpdate, this.values);

                this.options.push(...itemsResp);
                this.utilisateursInit.push(...itemsResp);
                this.selectedFilterOptions.push(...itemsResp);
                

            } else if (typeEquipe == 'conseiller') {
                consoleLogHandler('handle conseillers',null);
                this.compTitle = this.label.CompConsTitle;
                this.isCompResponsable = false;
                this.isCompConseiler = true;

                this.setRole(eventParams, eventParams.conseillersEquipe,'_Conseiller_');
                this.handleValuesAndUpdateLists(eventParams.conseillersEquipe, this.listToUpdate, this.values);
            }

            consoleLogHandler('this.role: ',JSON.stringify(this.role));
            
            this.options.push(...itemsCons);
            this.utilisateursInit.push(...itemsCons);
            this.selectedFilterOptions.push(...itemsCons);
            this.options.push(...itemsNonAssigned);
            this.utilisateursInit.push(...itemsNonAssigned);
            this.selectedFilterOptions.push(...itemsNonAssigned);

            if (typeEquipe == 'responsable') {
                this.optionsFiltre.push(
                    {
                        nom: 'Tous les utilisateurs du site',
                        value: this.options
                    },
                    {
                        nom: 'Les responsables',
                        value: itemsResp
                    }
                );
            } else if (typeEquipe == 'conseiller') {
                this.optionsFiltre.push(
                    {
                        nom: 'Tous les utilisateurs du site (sauf responsables)',
                        value: this.options
                    }
                );
            }
            this.optionsFiltre.push(
                {
                    nom: 'Les conseillers',
                    value: itemsCons
                },
                {
                    nom: 'Les utilisateurs sans role',
                    value: itemsNonAssigned
                }
            );

            consoleLogHandler('optionsFiltre: ',JSON.stringify(this.optionsFiltre));
            consoleLogHandler('oldUsers: ',JSON.stringify(this.oldUsers));

            /* Si, à la récupération des informations, l'équipe n'a pas de responsable(s)/conseiller(s), on grise le bouton 'enregistrer' */
            this.handleNoUserMessage(this.values);
            
            this.showDualList = true;
            /* Trier le tableau par nom*/
            if (this.options.length>2) {
                this.options.sort((a,b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0));    
                this.selectedFilterOptions.sort((a,b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0));
            }

            consoleLogHandler('options: ',JSON.stringify(this.options));
            consoleLogHandler('values: ',JSON.stringify(this.values));
        }

        
    }
    
    handleValuesAndUpdateLists(teamUsers,listToUpdate,listValues){
        if (teamUsers.length>0) {
            teamUsers.forEach(usr => {
                listValues.push(...[usr.value]);
                listToUpdate.oldUsers.push({
                    label: usr.label,
                    value: usr.value,
                    role: this.role,
                });
            });
        }
    }

    submitUpdate(){
        consoleLogHandler('submitUpdate',null);
        this.listToUpdate.newUsers.forEach(newUser => {
            consoleLogHandler('newUser: ',JSON.stringify(newUser));
            let findUser = this.listToUpdate.oldUsers.find(obj => obj.value.toLowerCase() == newUser.value.toLowerCase());
            consoleLogHandler('findUser: ',JSON.stringify(findUser));
            if(findUser!=undefined){
                var index = this.listToUpdate.oldUsers.map(function(e) {
                    return e.value;
                }).indexOf(newUser.value);
                consoleLogHandler('index: ',JSON.stringify(index));
                this.listToUpdate.oldUsers.splice(index,1);
                consoleLogHandler('oldUsers splice: ',JSON.stringify(this.listToUpdate.oldUsers));
            }
        });
        this.listToUpdate.role = this.role;
        consoleLogHandler('role: ',JSON.stringify(this.listToUpdate.role));
        consoleLogHandler('oldUsers: ',JSON.stringify(this.listToUpdate.oldUsers));
        consoleLogHandler('newUsers: ',JSON.stringify(this.listToUpdate.newUsers));
        let jsonToSend = JSON.stringify(this.listToUpdate);
        consoleLogHandler('jsonToSend: ',JSON.stringify(jsonToSend));
        this.showSpinner = true;
        updateUsers({json: jsonToSend}).then(result => {
            toastHandler(this,'Success!',this.label.UpdateSuccess,'success');
            pubsub.fire('mesEquipesEvt', '');
            consoleLogHandler('event mesEquipesEvt fired: ',null);
            this.showSpinner = false;
        }).catch(error => {
            this.showSpinner = false;
            toastHandler(this,'Fail!',this.label.UpdateError,'fail');
            consoleLogHandler('error updateUsers: ',JSON.stringify(error));
        })
    }
}