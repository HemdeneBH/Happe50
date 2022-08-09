/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 12-07-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
import {NavigationMixin} from "lightning/navigation";
import {LightningElement, track, api, wire } from "lwc";
import loadDataVue360 from '@salesforce/apex/HP_SM028_Vue360Service.loadData';
import {updateRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {subscribe,unsubscribe,createMessageContext,releaseMessageContext,APPLICATION_SCOPE, MessageContext} from 'lightning/messageService';
import openEditNameClient from "@salesforce/messageChannel/hp_openEditNameClient__c";

export default class Hp_containerView extends NavigationMixin(LightningElement) {
    @api recordId;
    @track masterData = null;
    @track dataSecondary = null;
    @track pfcInfoList = {};
    @track progress = 0;
    @track longList = false;
    @track secondListSize;
    @track secondListAdresses;
    @track showData = false;
    @track logResult;
    @track transactionIdList;
    @track showLog = false;
    @track totalDuration = 0;
    @track durationFirstContrat = 0;
    @track totalDurationWithoutNetworkTime = 0;
    @track showMenu = false;
    @track selectedPfc = null;
    @track showSpinner = false;
    @track openSecondAdresses = false;
    @track selectedPfcId;
    @track iconAction;
    @track hasPermissionViewLog = false;
    @track popupstate = true;
    @track modeTab = false;
    @track vue360Variant;
    @track compVariant;
    @track displayResil = false;
    @track diplayDossierAide = false;
    @track classComp = 'hide';
    @track classOPS = 'hide';
    @track clientHasContract = false;
    @track clientHasntContract = false;
    clientHasntContractOrign = false;
    @track diplayOps = false;
    @track compLabel = null;
    @track currentOPS;
    @track opsSelected = false;
    @track isStay = false;
    @track showComp = false;

    @track classEditName = 'hide';
    index = 0;
    locauxContrat;
    startLoadDate = 0;

    @wire(MessageContext)
    messageContext;

    subscription = null;

    connectedCallback() {
        this.loadData();
        this.subscribeToMessageChannel();
    }
    refresh() {
        this.loadData();
    }
    activateresiliation(event) {
        if(event.detail == true) {
            this.displayResil = true;
            this.modeTab = true;
            this.classComp = '';
            this.compLabel = 'Résiliation';
            this.displayComp();
        } else if(event.detail == false) {
            this.modeTab = false;
            this.displayResil = false;
            this.showComp = false;
            this.classComp = 'hide';
            this.compLabel = null;
            this.clientHasntContract = this.clientHasntContractOrign;
        }
    }

    opendossieraide(event){
        if(event.detail == true) {
            this.modeTab = true;
            this.classComp = '';
            this.compLabel = 'Dossier d\'aide';
            this.displayCompAide();
        } else if(event.detail == false) {
            this.modeTab = false;
            this.diplayDossierAide = false;
            this.showComp = false;
            this.classComp = 'hide';
            this.compLabel = null;
            this.clientHasntContract = this.clientHasntContractOrign;
        }
    }
    
    loadData() {
        this.showLog = false;
        this.masterData = null;
        this.dataSecondary = null;
        this.showSpinner = true;
        this.pfcInfoList = {};
        this.progress = 10;
        this.startLoadDate = new Date().getTime();
        this.iconAction = null;
        loadDataVue360({ rootMetadata: 'V1_SOQL_LOAD_CONTACT_FROM_SF_BY_ID', params : this.recordId, randomNumber : Math.floor(Math.random() * Math.floor(1000)), contactId : this.recordId}).then(masterData => {
            this.showSpinner = false;
            this.progress = 30;
            if(!masterData.success) {
                this.iconAction = 'action:bug';
            }
            
            this.masterData = JSON.parse(JSON.stringify(masterData));
            console.log('this.masterData ',JSON.stringify(this.masterData));
            this.transactionIdList = masterData.idTransaction;
            this.hasPermissionViewLog = masterData.globalParam.data.permissionViewLog;
            this.totalDurationWithoutNetworkTime = masterData.duration;
            if(masterData.contratInfoList == null || masterData.contratInfoList.pfcInfoList == null
                || masterData.contratInfoList.pfcInfoList.locauxContratInfoList == null 
                || masterData.contratInfoList.pfcInfoList.locauxContratInfoList.data == null
                || this.masterData.contratInfoList.pfcInfoList.locauxContratInfoList.data._data == null) {
                this.showLog = true;
                this.progress = 100;
                this.totalDuration = new Date().getTime() - this.startLoadDate;
                this.clientHasntContract = true;
                this.clientHasntContractOrign = true;
                return;
            }
            this.clientHasContract = true;
            this.showMenu = true;
            this.locauxContrat = this.masterData.contratInfoList.pfcInfoList.locauxContratInfoList.data._data;
            this.locauxContrat.sort(function(a, b) {
                try {
                    if(a.locaux.length > 0 && b.locaux.length > 0)
                    return a.locaux[0].idLocal - b.locaux[0].idLocal;
                    else
                      return 1;
                }catch(e){ return 0;}
                
            });
            let contactMap = {};
            this.masterData.contratInfoList.data._data.forEach((record, i) => {
                if(contactMap[record.idPortefeuilleContrat] == null) {
                    contactMap[record.idPortefeuilleContrat] = {};
                }
                let separateur = '';
                if(contactMap[record.idPortefeuilleContrat].typeEnergie != null) {
                    separateur = '-';
                } else {
                    contactMap[record.idPortefeuilleContrat].typeEnergie = '';
                }

                if(record.energie.includes('Gaz') && !contactMap[record.idPortefeuilleContrat].typeEnergie.includes('GAZ')) {
                    contactMap[record.idPortefeuilleContrat].typeEnergie += separateur + 'GAZ';
                } else if(record.energie.includes('Elec') && !contactMap[record.idPortefeuilleContrat].typeEnergie.includes('ELEC')) {
                    contactMap[record.idPortefeuilleContrat].typeEnergie += separateur + 'ELEC';
                }
                
            });
            for(let i = 0; i < this.locauxContrat.length - 1; i ++) {
                if(this.locauxContrat[i].locaux.length > 0 &&
                     this.locauxContrat[i + 1].locaux.length > 0 &&
                      this.locauxContrat[i].locaux[0].idLocal == this.locauxContrat[i + 1].locaux[0].idLocal) {
                    this.locauxContrat[i].typeEnergie = contactMap[this.locauxContrat[i].idPortefeuilleContrat].typeEnergie;
                    this.locauxContrat[i + 1].typeEnergie = contactMap[this.locauxContrat[i + 1].idPortefeuilleContrat].typeEnergie;
                    this.locauxContrat[i].duplicate = true;
                    this.locauxContrat[i + 1].duplicate = true;
                }
            }

            for(let i = 0; i<this.locauxContrat.length; i++) {
                var isStay = false;

                for(let j = 0; j<this.masterData.contratInfoList.data._data.length; j++) {
                    let condition = ((this.locauxContrat[i].idPortefeuilleContrat == this.masterData.contratInfoList.data._data[j].idPortefeuilleContrat) 
                                    && ((this.masterData.contratInfoList.data._data[j].codeOffre=='EITR2_STAY_H') || (this.masterData.contratInfoList.data._data[j].codeOffre=='GITR2_STAY_H')));
                    if(condition) {
                        isStay = true;
                        break;
                    }
                }

                if(isStay) {
                    this.locauxContrat[i].isStay = true;
                }
            } 

            if(this.locauxContrat == null || this.locauxContrat.length == null || this.locauxContrat.length == 0) {
                this.showLog = true;
                this.progress = 100;
                this.totalDuration = new Date().getTime() - this.startLoadDate;
                return;
            }
            this.selectedPfcId = this.locauxContrat[0].idPortefeuilleContrat;
            this.locauxContrat.forEach((record, i) => {record.key = i});
                       
            let paramList = this.processDataContrat(this.masterData.contratInfoList.data._data, this.locauxContrat);
            if (this.locauxContrat.length > 3) {
                this.longList = true;
                this.secondListSize = this.locauxContrat.length - 3;
                this.firstListAdresses = this.locauxContrat.slice(0, 3);
                this.secondListAdresses = this.locauxContrat.slice(3, this.locauxContrat.length);
            } else {
                this.firstListAdresses = this.locauxContrat;
            }
            
            let pfcIdList = [];
            paramList.forEach((record, i) => {pfcIdList.push(record.pfcId);});
            loadDataVue360({ rootMetadata: 'V1_EMPTY_SECONDARY_DATA',

             params : {'xdataId' : this.masterData.data[0].ID_Tiers__c,

                       'recordId' : this.recordId,
                       'agilabId' : this.masterData.data[0].HP_AgilabExternalId__c,
                       'pfcIdList' : pfcIdList}, randomNumber : Math.floor(Math.random() * Math.floor(1000)), contactId : this.recordId}).then(dataSecondary => {
                this.dataSecondary =(JSON.parse(JSON.stringify(dataSecondary)));
                this.updateContact();
                this.transactionIdList += ';' + dataSecondary.idTransaction;
                if(!dataSecondary.success) {
                    this.iconAction = 'action:bug';
                }
                this.progress += 30;
                if(this.progress > 97 && this.dataSecondary != null) { 
                    this.showLog = true;
                    this.totalDuration = new Date().getTime() - this.startLoadDate;
                    if(this.iconAction == null) {
                        this.iconAction = 'action:approval';
                    }
                }
            });
            for(let i = 0; i < paramList.length; i ++) {
                this.loadPfcInfo(paramList, i, 40 / paramList.length); 
            }    
        });
    }
    popupEvent() {
        this.popupstate = !this.popupstate;
    }
    
    processDataContrat(contrats, locauxContrat) {
        let pfcMap = {};
        for(let cont of contrats) {
            if(pfcMap[cont.idPortefeuilleContrat] == null) {
                pfcMap[cont.idPortefeuilleContrat]  = [];
            }
            pfcMap[cont.idPortefeuilleContrat].push(cont.id);
        }
        let result= [];
        for(let locaux of locauxContrat) {
            result.push({pfcId : locaux.idPortefeuilleContrat, contratIdList : pfcMap[locaux.idPortefeuilleContrat]});
        }
        return result;
    }
    loadPfcInfo(paramList, index, step) {
        loadDataVue360({ rootMetadata: 'V1_EMPTY_PFC_DATA', params : paramList[index], randomNumber : Math.floor(Math.random() * Math.floor(1000)), contactId : this.recordId}).then(pfcData => {
            this.transactionIdList += ';' + pfcData.idTransaction;
            this.pfcInfoList[pfcData.data.pfcId] = (JSON.parse(JSON.stringify(pfcData)));
            this.progress += step;
            this.totalDurationWithoutNetworkTime += pfcData.duration;
            this.locauxContrat[index].isLoaded = true;
            if(!pfcData.success) {
                this.iconAction = 'action:bug';
            }
            if(index == this.index) {
                this.locauxContrat[index].selected = true;
                this.selectedPfc = this.pfcInfoList[this.locauxContrat[index].idPortefeuilleContrat];
                this.durationFirstContrat = new Date().getTime() - this.startLoadDate;
                
                
            }
            if(this.progress > 97 && this.dataSecondary != null) { 
                this.showLog = true;
                this.totalDuration = new Date().getTime() - this.startLoadDate;
                if(this.iconAction == null) {
                    this.iconAction = 'action:approval';
                }
            }
        });
    }
    viewDetails() {
        this.logResult = JSON.stringify({masterData : this.masterData, dataSecondary : this.dataSecondary, pfcList : this.pfcInfoList},null, 2);
        this.showData = true;
    }
    closePopupModal() {
        this.showData = false;
    }
    changeLocal(event){
        let index = Number.parseInt(event.currentTarget.id.split("-")[0]);
        if(this.locauxContrat[index].isLoaded != true) {
            return;
        }
        if(this.modeTab && this.displayResil) {
            if(!confirm('Voulez vous annuler les modification sur la résiliation en cours ?')) {
                return;
            } else {
                this.modeTab = false;
                this.showComp = false;
                this.displayResil = false;
                this.classComp = 'hide';
            }
        }else if(this.modeTab && !this.displayResil){
            if(!confirm('Voulez vous annuler les modification sur le dossier d\'aide en cours ?')) {
                return;
            } else {
                this.modeTab = false;
                this.showComp = false;
                this.classComp = 'hide';
            }
        }
        this.popupstate = !this.popupstate;
        this.index = index;
        this.locauxContrat.forEach((record, i) => {record.selected = false;});
        this.locauxContrat[this.index].selected = true;
        this.selectedPfc = this.pfcInfoList[this.locauxContrat[this.index].idPortefeuilleContrat];
        this.selectedPfcId = this.locauxContrat[this.index].idPortefeuilleContrat;
    }
    handleSecondAdresses() {
        this.openSecondAdresses = !this.openSecondAdresses;
    }
    updateContact() {
        if(this.dataSecondary == null || this.dataSecondary.xdataPersonne == null
            || this.dataSecondary.xdataPersonne.data == null|| this.dataSecondary.xdataPersonne.data.id == null) {
                return;
        }
        let cont = this.dataSecondary.xdataPersonne.data;
        let contact = {
            fields: {
                Id: this.recordId,
                Salutation: cont.civilite,
                FirstName: cont.prenom,
                LastName: cont.nom,
                No_Voie__c: cont.numVoie,
                MailingStreet: cont.voie,
                Complement_adresse__c: cont.complementAdresse,
                MailingPostalCode: cont.codePostal,
                MailingCity: cont.ville,
                Email: cont.email,
                Phone: cont.numeroFixe,
                MobilePhone: cont.numeroMobile
            },
        };
        if(this.dataSecondary.agilabPersonne.data != null && this.dataSecondary.agilabPersonne.data.output != null && this.masterData.data[0].HP_AgilabExternalId__c === undefined){
            contact.fields.HP_AgilabExternalId__c =  this.dataSecondary.agilabPersonne.data.output.id;
        }
        updateRecord(contact).then(() => {
            console.log('update contact in Salesforce ');
        })
        .catch(error => {
            console.log('Error: ---> updating Contact ' , JSON.stringify(error));
        });
    }
    newidtransaction(event){
        this.transactionIdList += ';' + event.detail;
    }
    displayVue360(){
        this.showComp = false;
        this.compVariant = 'brand-outline';
        this.vue360Variant = 'brand';
        this.classComp = 'hide';
    }
    displayComp(){
        this.showComp = true;
        this.vue360Variant = 'brand-outline';
        this.compVariant = 'brand';
        this.classComp = '';
    }
    displayCompAide(){
        this.showComp = true;
        this.vue360Variant = 'brand-outline';
        this.compVariant = 'brand';
        this.classComp = '';
    }
    openops(event){
        this.currentOPS = event.detail;
        console.log('@@ this.currentOPS  ' + this.currentOPS.Numero_affaire_distributeur__c );
        this.opsSelected = true;
    }
    closeops() {
        this.opsSelected = false;
    }


    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                openEditNameClient,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }
    handleMessage(message) {
        this.compLabel = 'Modification du titulaire';
        this.modeTab = true;
        this.classComp = '';
        this.clientHasntContract = false;
        this.displayComp();
    }

    get isRes() {
        return this.compLabel == 'Résiliation';
    }
    get isDossierAide(){
        return this.compLabel == 'Dossier d\'aide';
    }
    get isEditName() {
        return this.compLabel == 'Modification du titulaire';
    }

    loadoptionvert(event) {
        console.log('@@veroption' + JSON.stringify(event.detail));
        this.masterData.contratInfoList.energieVert.data[event.detail.pfcId] = event.detail.value;
        this.masterData = JSON.parse(JSON.stringify(this.masterData));
    }
}