/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-16-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track, wire } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import updateJourDrp from '@salesforce/apex/HP_EC_UpdateCustomerData.updateJourDrp';
import updateMensualite from '@salesforce/apex/HP_EC_UpdateCustomerData.updateMensualite';
import createCaseMensualite from '@salesforce/apex/HP_EC_UpdateCustomerData.createCaseMensualite';
import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getGrilleTarifaire from '@salesforce/apex/HP_EC_LoadCustomerData.getGrilleTarifaire';

export default class Hp_ec_popinMensualites extends LightningElement {

    @api datemensualite;
    @api montantgaz;
    @api montantelec;
    @api pftcid;
    @api dual;
    @api contactid;

    @track labelButton = 'modifier';
    @track texteAlerte = 'Modifier vos mensualités peut entrainer une régularisation de prix';
    @track badInputMonthly;
    @track badInputAmount;
    @track montantMensuel;
    @track newDate;
    @track newMonthlyAmount;
    @track contractInfo;
    @track idContract;
    @track currentEnergy = 'Electricité';
    @track errorDate;
    @track prixMensuel;
    @track aboMensuel;
    @track inputAmountClass = 'slds-input';
    @track inputDateClass = 'slds-input';
    @track myEventDetails = {'hide' : true, 'newDate':null, 'newAmount':null};
    @track deactivateButton = false;

    titleText = 'ma mensualité';

    iconAlert = HP_EC_icon_alert;
    iconClose = HP_EC_close_icon_light;

    closePopin(event){
        this.dispatchEvent(new CustomEvent('closepopinmensualites', { detail: this.myEventDetails}));
    }
    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    @wire(getContractData)
    wiredContract({error, data}){
        if (data) {
            this.contractInfo = JSON.parse(data);
            this.populateContractInfo();
       }else if(error){
           console.log('*** Error getContractData : '+JSON.stringify(error));
       }
    }

    populateContractInfo(){
        if(this.dual){
            this.montantMensuel = this.montantelec;
        }else{
            this.montantMensuel = this.montantelec ? this.montantelec : this.montantgaz;
        }
        if(this?.contractInfo){
            for(let i = 0; i<this.contractInfo._data.length;i++){
                if(this.contractInfo._data[i].idPortefeuilleContrat == this.pftcid && (this.dual == false || (this.dual == true && this.contractInfo._data[i].energie == this.currentEnergy))){
                    let dateDebutValiditeUs = new Date(this.contractInfo._data[i].dateDebutValidite);
                    let dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
                    this.idContract = this.contractInfo._data[i].id;
                    let contractID = JSON.stringify(this.idContract );
                    getGrilleTarifaire({ idContrat : contractID,  dateContrat :dateDebutValiditeFr})
                    .then(response => {
                        const prix = response?.aboTtc ? parseFloat(response.aboTtc)/11 : 10.00;
                        this.prixMensuel = Math.round(prix * 100) / 100 ;
                        console.log('prix mensuel : '+this.prixMensuel);
                    })
                    .catch(error => {
                        console.log('***ExId Error: ' + JSON.stringify(error));
                    });
                }
            }       
        }
    }

    handleType (event) {
        this.currentEnergy = event.detail;
        this.typeOptions = this.updateOptionsArray(this.typeOptions, event.detail);
        this.montantMensuel = this.currentEnergy == 'Electricité' ? this.montantelec : this.montantgaz;
    }

    get dateMensualiteText(){
        return 'le ' + this.datemensualite + ' du mois';
    }

    typeOptions = [
        {
            value: 'Electricité',
            label: "Élec",
            checked: true
        },
        {
            value: 'Gaz Naturel',
            label: "Gaz",
            checked: false
        }
    ];

    handleChangeDate(event){
        this.newDate = event.target.value;
        this.deactivateButton = false;
    }

    handleChangeMensualite(event){
        this.newMonthlyAmount = event.target.value;
        this.deactivateButton = false;
    }

    validateDateInput(event){
        event.target.value = event.target.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
    }

    validateInputAmount(){
        const prixPlancher = this.prixMensuel < 10 ? 10.00 : this.prixMensuel ;
        const prixMensuelMax = this.montantMensuel * 6;
        const prixMensuelMin = Math.round(this.montantMensuel * 90) / 100;

        if(this.newMonthlyAmount < prixPlancher){
            if(parseFloat(this.newMonthlyAmount) < this.prixMensuel && parseFloat(this.newMonthlyAmount)>= 10){
                this.inputAmountClass = 'input-invalid';
                this.badInputAmount = 'Le montant saisi ne peut être inférieur au prix mensuel de l’abonnement TTC : '+this.prixMensuel + ' €';
                this.deactivateButton = true;
            }else{
                this.inputAmountClass = 'input-invalid';
                this.badInputAmount = 'Le montant ne peut être inférieur à 10€';
                this.deactivateButton = true;
            }
            return false;
        }
        if(parseFloat(this.montantMensuel) > prixPlancher){
            if(parseFloat(this.newMonthlyAmount) < prixMensuelMin || parseFloat(this.newMonthlyAmount) > prixMensuelMax){
                this.inputAmountClass = 'input-invalid';
                this.badInputAmount = 'Le montant saisi doit être compris entre '+ prixMensuelMin +' € et '+ prixMensuelMax +' €';
                this.deactivateButton = true;
                return false;
            }else{
                this.inputAmountClass = 'slds-input';
                this.badInputAmount = '';
                this.deactivateButton = false;
                return true;
            }
        }else{ 
            if(parseFloat(this.newMonthlyAmount)< prixPlancher || parseFloat(this.newMonthlyAmount) > (6 * prixPlancher)){
                this.inputAmountClass = 'input-invalid';
                this.badInputAmount = 'Le montant saisi doit être compris entre '+ prixPlancher +' € et '+6 * prixPlancher+' €';
                this.deactivateButton = true;
                return false;
            }
            return true;
        }
    }

    validateInputDate(){
        if(parseInt(this.newDate)<1 || parseInt(this.newDate)>28){
            this.inputDateClass = 'input-invalid';
            this.badInputMonthly = 'La date de réglement doit être entre 1 et 28';
            this.deactivateButton = true;
            return false;
        } else{ 
            this.inputDateClass  ='slds-input';
            this.badInputMonthly = '';
            this.deactivateButton = false;
            return true;
        }
    }

    updateOptionsArray(array, value) {
        return array.map(option => {
            if (option.value == value) {
                return {...option, checked: true};
            }
            return {...option, checked: false};
        });
    }

    handleSubmit(event){
        let objectInformation = {};
        objectInformation.contactId = this.contactid;
        if(this.newMonthlyAmount && this.newMonthlyAmount != this.montantMensuel && this.validateInputAmount()){
            updateMensualite({contractId : this.idContract, montantMensualite : this.newMonthlyAmount}).then(response => {
                if(response.status == 'FAILED'){
                    this.badInputAmount = 'Modification impossible (votre dernière mise à jour date de moins d\'un an ou une erreur technique est survenue)';
                }else{
                    objectInformation.type = 'Mensualite';
                    objectInformation.oldAmount = this.montantMensuel;
                    objectInformation.newAmount = this.newMonthlyAmount;
                    objectInformation.oldDRP = null;
                    objectInformation.newDRP = null;
                    createCaseMensualite({objectInformation : objectInformation}).then(response => {
                        console.log('success ');
                    }).catch(error => {
                        console.log('Error in create Case mensualité ' + JSON.stringify(error));
                    });
                    this.badInputAmount = '';
                    this.myEventDetails.newAmount = this.newMonthlyAmount;
                    this.dispatchEvent(new CustomEvent('closepopinmensualites', { detail: this.myEventDetails}));
                }
            })
            .catch(error => {
                this.badInputAmount = 'Modification impossible (votre dernière mise à jour date de moins d\'un an ou une erreur technique est survenue)';
                console.log('***ExId updateMensualite Error: ' + JSON.stringify(error));
            });
        }
        if(this.newDate && this.newDate != this.datemensualite && this.validateInputDate()){
            updateJourDrp({contractId : this.idContract, drp : this.newDate}).then(response => {
                if(response.status == 'FAILED'){
                    this.badInputMonthly = 'Modification impossible (votre dernière mise à jour date de moins d\'un an ou une erreur technique est survenue)';
                }else{
                    objectInformation.type = 'DRP';
                    objectInformation.oldAmount = null;
                    objectInformation.newAmount = null;
                    objectInformation.oldDRP = this.datemensualite;
                    objectInformation.newDRP = this.newDate;
                    createCaseMensualite({objectInformation : objectInformation}).then(response => {
                        console.log('success ');
                    }).catch(error => {
                        console.log('Error in create Case mensualité ' + JSON.stringify(error));
                    });
                    this.badInputMonthly = '';
                    this.myEventDetails.newDate = this.newDate;
                    this.dispatchEvent(new CustomEvent('closepopinmensualites', { detail: this.myEventDetails}));
                }
            })
            .catch(error => {
                console.log('***ExId updateJourDrp Error: ' + JSON.stringify(error));
                this.badInputMonthly = 'Modification impossible (votre dernière mise à jour date de moins d\'un an ou une erreur technique est survenue)';
            });
        }
    }                 
}