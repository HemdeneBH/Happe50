import { LightningElement, track,wire,api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
import checkAllowCreateDP from "@salesforce/apex/SM_AP81_AllowCreateDP.checkAllowCreateDP";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import CASE_OBJECT from '@salesforce/schema/Case';
import 	Type_FIELD from '@salesforce/schema/Case.Type';
import 	SousType_FIELD from '@salesforce/schema/Case.Sous_type__c';
import 	Origin_FIELD from '@salesforce/schema/Case.Origin';
import 	Status_FIELD from '@salesforce/schema/Case.Status';
import 	AccountId_FIELD from '@salesforce/schema/Case.AccountId';
import 	RecordType_FIELD from '@salesforce/schema/Case.RecordTypeId';
import 	ContactId_FIELD from '@salesforce/schema/Case.ContactId';
import { getRecord } from 'lightning/uiRecordApi';


export default class SM_Syn_DP extends LightningElement {


    @api numeroVoie;
    @api ville;
    @api libelleVoie;
    @api complementAdresse;
    @api codePostal;
    @api IdBusinessPartner;
    @api solde;
    @api soldeFormat;
    @api AccountId;
    @api recordId;
    //input for IP_SM_VerifierEligibilitePlanApurement_SOAP
    @api NoCompteContrat;
  
    @track error; 
    @track treeItems;
    @track currentExpanded = ['En cours'];    
    @track listPA;
    @track noData = false;
    @track showTablePa=false;
    @track showCreateDPButton=true;

    @track dateEcheanceSimuler;
    @track nombreEcheance=1;
    @api montantTotal;
    @track listEcheanceDp;
    @track showDelaiPaimentSimulation;
    @track showHeaderTableSimulation = true;
    @track showButtonsDP = true;
    @track showAdress = true;
    @track showListEcheanceDp;
    @track headerText = 'SYNTHÈSE DES DÉLAIS DE PAIEMENT';
    
    //calendar paramas
    @track minDate;
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT }) objectInfo;
    // check if connected user is allowed to create DP
    @wire(checkAllowCreateDP) 
    wirecheckACDP;



    get showSpinner() {
        return (this.listPA && this.listPA.length > 0) || this.noData
    }

    connectedCallback() {
    this.consulterPlanApurement({idPersonne: this.IdBusinessPartner}, 'IP_SM_consulterPlanApurement_SOAP');
    }

    consulterPlanApurement(params, name) {
        callIP({ inputMap: params, NameIntergation: name })
          .then(result => {            
            this.listPA = result.Result.planApurement;               
            if(this.listPA && this.listPA.length) {    
                this.listPA.sort(function(a, b) {
                    var textA = a.statutPA.toUpperCase();
                    var textB = b.statutPA.toUpperCase();
                    return (textB > textA) ? -1 : (textB < textA) ? 1 : 0;
                });
                
                for (const item of this.listPA) {                   
                    if( item.statutPA === 'actif' && item.categoriePA === 'Z1' ){
                        this.showCreateDPButton=false;
                    }
                    item.statutPA=item.statutPA.replace('actif', 'En cours');
                    item.statutPA = item.statutPA.charAt(0).toUpperCase() +  item.statutPA.slice(1); 
                    if(item.dateDesactivationPA){
                    const d = item.dateDesactivationPA.split('-');                   
                    item.dateDesactivationPA= d[2]+'/'+d[1]+'/'+d[0];   }                 
                    if (item.echeance && !item.echeance.length) {
                        item.echeance = [item.echeance];
                        item.firstEcheance=item.echeance[0].dateEcheance;
                        item.echeances=1;
                    }else if(item.echeance && item.echeance.length){
                        item.echeance = item.echeance.sort((a, b) => b.dateEcheance - a.dateEcheance);                    
                        item.firstEcheance=item.echeance[0].dateEcheance;
                        item.echeances = item.echeance.length;
                        for (const ech of item.echeance){
                            if(ech && ech.statutEcheance==='rapproché'){
                                ech.cercle=true;
                            }else if (ech && ech.statutEcheance==='due'){
                                ech.triangle=true;
                            }else if (ech && ech.statutEcheance==='impayé'){
                                ech.cross=true;
                            }
                        }

                    }                      
                }
            } else if(result.Result.planApurement) {
                this.listPA = [result.Result.planApurement];
                this.listPA[0].statutPA = this.listPA[0].statutPA.charAt(0).toUpperCase() +  this.listPA[0].statutPA.slice(1); 
                if(this.listPA[0].statutPA==='Actif' && this.listPA[0].categoriePA==='Z1'){
                    this.showCreateDPButton=false;
                }
                this.listPA[0].statutPA=this.listPA[0].statutPA.replace('Actif', 'En cours');
                if(this.listPA[0].dateDesactivationPA){
                const d = this.listPA[0].dateDesactivationPA.split('-');                   
                this.listPA[0].dateDesactivationPA= d[2] +'/'+ d[1] +'/'+ d[0];   
                }  

                if (this.listPA[0].echeance && !this.listPA[0].echeance.length) {
                    this.listPA[0].firstEcheance=this.listPA[0].echeance[0].dateEcheance;
                    this.listPA[0].echeance = [this.listPA[0].echeance];                   
                }
                if (this.listPA[0].echeance && this.listPA[0].echeance.length) {                
                    this.listPA[0].echeance =  this.listPA[0].echeance.sort((a, b) => b.dateEcheance - a.dateEcheance);                    
                    this.listPA[0].firstEcheance = this.listPA[0].echeance[0].dateEcheance;                   
                }
                this.listPA[0].echeances = this.listPA[0].echeance.length;
                if(this.listPA[0].echeance  && this.listPA[0].echeance.length){
                for (const ech of this.listPA[0].echeance){
                    if(ech && ech.statutEcheance === 'rapproché'){
                        ech.cercle=true;
                    }else if (ech && ech.statutEcheance === 'due'){
                        ech.triangle=true;
                    }else if (ech && ech.statutEcheance === 'impayé'){
                        ech.cross=true;
                    }
                }
            }
            }
            if(!this.listPA || (this.listPA && this.listPA.length === 0)) {
                this.noData = true;                
            } 
           else{
                this.showTablePa=true;
            } 
            this.error = undefined;    
          })
          .catch(error => {
            this.noData = true;
            this.showCreateDPButton=false;
            console.log('error');            
            
          });
    }
   
    handleChange(event) {
        const field = event.target.name;
        if (field === 'nombreEcheance') {
            this.nombreEcheance = event.target.value;
        } else if (field === 'dateReference') {            
            this.dateEcheanceSimuler = event.target.value;
            if((new Date(this.dateEcheanceSimuler)).getDay() === 6 || (new Date(this.dateEcheanceSimuler)).getDay() === 0){
                event.target.setCustomValidity("Première échéance invalide.");                
            }else{
                event.target.setCustomValidity(""); 
            }
            event.target.reportValidity();
        }
    }

    showDelaiPaiementCreation(){
        this.createCase();
        this.headerText = 'CREATION';
        this.showAdress = false;
        this.showDelaiPaimentSimulation = true;
        this.showTablePa = false;  
        this.showHeaderTableSimulation = false;
        this.showButtonsDP = false;
        //init value dateReference date 
        let today= new Date();
        today.setDate(today.getDate() + 15);
        let dd = String(today.getDate()).padStart(2, '0');
        let mm = String(today.getMonth()+1).padStart(2, '0'); 
        let yyyy = today.getFullYear();
        today =  yyyy + '-' + mm + '-' + dd;
        this.minDate=String(today);
        this.dateEcheanceSimuler=this.minDate;
        this.montantTotal = this.solde;

    }
  
    simulatePlanApurement(){
        this.showListEcheanceDp=false;
        var inputCmp = this.template.querySelector(".dateReferenceId");
        var dateReference = this.dateEcheanceSimuler+'T00:00:00';
        console.log('Params'+this.dateEcheanceSimuler+'days'+(new Date(this.dateEcheanceSimuler)).getDay());
        //vérifier si un des inputs==vide
        if(this.dateEcheanceSimuler===undefined||this.nombreEcheance===undefined||this.dateEcheanceSimuler===null||this.nombreEcheance===null){
            console.log('Params are null');
            return;
        }
      
        //check if weekend
        if((new Date(this.dateEcheanceSimuler)).getDay() === 6 || (new Date(this.dateEcheanceSimuler)).getDay() === 0){
            inputCmp.setCustomValidity("Première échéance invalide.");   
            inputCmp.reportValidity();
            return ;             
        }else{
            inputCmp.setCustomValidity(""); 
            inputCmp.reportValidity();
        }
       


     
        
        callIP({ inputMap: {dateReference:dateReference,nombreEcheance:this.nombreEcheance,montantGlobal:this.montantTotal}, NameIntergation: 'IP_SM_simulerPlanApurement_SOAP' }).then(result => {
            console.log(' result '+result);
            if(result.Result.simulerPlanApurementOutput.echeance && result.Result.simulerPlanApurementOutput.echeance.length){
            this.listEcheanceDp = result.Result.simulerPlanApurementOutput.echeance;
            }else{
            this.listEcheanceDp = [result.Result.simulerPlanApurementOutput.echeance];
            }
            this.showListEcheanceDp=true;
          }).catch(error => {
             console.log(error);
             
        });
       
    } 
    
    // close
    closeDPTab(){
        var close = true;
        const closeclickedevt = new CustomEvent('closeDPTabEvent', {
            detail: { close },
        });

         // Fire the custom event
         this.dispatchEvent(closeclickedevt); 
    }

    createCase() {
        console.log('record'+this.AccountId);
      const fields = {};        
        fields[Type_FIELD.fieldApiName] = 'Paiement';
        fields[SousType_FIELD.fieldApiName] = "Délai de paiement / plan d'apurement";
        fields[Origin_FIELD.fieldApiName] = 'Phone';
        fields[Status_FIELD.fieldApiName] = 'En Traitement';
        fields[AccountId_FIELD.fieldApiName] = this.AccountId;
        fields[ContactId_FIELD.fieldApiName]=this.recordId;
        const rtis = this.objectInfo.data.recordTypeInfos;
        //find and set recordType==Service 
        fields[RecordType_FIELD.fieldApiName]= Object.keys(rtis).find(rti => rtis[rti].name === 'Service');

        const recordInput = {
            apiName: CASE_OBJECT.objectApiName,
            fields
        };

        createRecord(recordInput)
        .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erreur dans la création Case',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
    VerifierEligibilitePlanApurement(){
        callIP({ inputMap: {idPersonne:this.IdBusinessPartner,idCompteClient:this.NoCompteContrat}, NameIntergation: 'IP_SM_VerifierEligibilitePlanApurement_SOAP' }).
            then(result => {
                //eligible==true if (code==0||code==1) & si le profile du USER connecté existe dans SM_Allow_Create_DP__mdt
                if(result && result.Response && result.Response.verifierEligibiliteOutput && result.Response.verifierEligibiliteOutput.statutEligibilite
                    && result.Response.verifierEligibiliteOutput.statutEligibilite.code && ( result.Response.verifierEligibiliteOutput.statutEligibilite.code === '0' || result.Response.verifierEligibiliteOutput.statutEligibilite.code === '1' )){
                    this.solde=result.Response.verifierEligibiliteOutput.statutEligibilite.montantEligible;
                    this.showDelaiPaiementCreation();
                } else {
                    console.log("empty response/non éligible");
                     //this.showDelaiPaiementCreation();
                }
            }).catch(error => {
                console.log(error);
                
            });
    }
     

}