import { LightningElement, track,wire,api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
import checkAllowCreateDP from "@salesforce/apex/SM_AP81_AllowCreateDP.checkAllowCreateDP";
import getErrorMessage from "@salesforce/apex/SM_DelaiePaiementMessageError.getErrorMessage";
import getRecapArticle from "@salesforce/apex/SM_DelaiPaiementArticles.getRecapArticle";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { updateRecord } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import 	Type_FIELD from '@salesforce/schema/Case.Type';
import 	SousType_FIELD from '@salesforce/schema/Case.Sous_type__c';
import 	Origin_FIELD from '@salesforce/schema/Case.Origin';
import 	Status_FIELD from '@salesforce/schema/Case.Status';
import 	AccountId_FIELD from '@salesforce/schema/Case.AccountId';
import 	RecordType_FIELD from '@salesforce/schema/Case.RecordTypeId';
import 	ContactId_FIELD from '@salesforce/schema/Case.ContactId';
import 	MotifIneligibilite_FIELD from '@salesforce/schema/Case.SM_MotifIneligibiliteDelaiPaiement__c';
import 	SousStaut_FIELD from '@salesforce/schema/Case.Sous_statut__c';
import  SM_AdresseConcernee_FIELD from '@salesforce/schema/Case.SM_Adresse_Concernee__c';
import ID_FIELD from '@salesforce/schema/Case.Id';
import creationfilarianne from '@salesforce/resourceUrl/sm_filariannedpcreation';
import 	elementlabel_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.ElementLabel__c';
import 	elapsetime_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.ElapsedTime__c';
import 	elementname_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.ElementName__c';
import 	elementstepnumber_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.ElementStepNumber__c';
import 	elementtype_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.ElementType__c';
import 	name_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.Name';
import 	OmniScriptContextId_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.vlocity_cmt__ContextId__c';
import 	OmniscriptType_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.OmniscriptType__c';
import 	OmniScriptSubType_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.OmniScriptSubType__c';
import 	TrackingEvent_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.TrackingEvent__c';
import 	vlocity_cmt__Timestamp_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.vlocity_cmt__Timestamp__c';
import 	vlocity_cmt__TrackingService from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.vlocity_cmt__TrackingService__c';
import  TRACKING_OBJECT from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c';
import 	caseid_FIELD from '@salesforce/schema/vlocity_cmt__VlocityTrackingEntry__c.CaseId__c';
import { getRecord } from 'lightning/uiRecordApi';
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";

//FT2-1687 Délai de paiement - sauvegarde des infos nécessaires à la validation du superviseur
//Déclaration des champs à mettre à jour dans le case
import 	SoldeConcerneDP_FIELD from '@salesforce/schema/Case.SM_soldeConcerneDP__c';
import 	NbrEcheances_FIELD from '@salesforce/schema/Case.SM_NbrEcheances__c';
import 	DateEcheance1_FIELD from '@salesforce/schema/Case.SM_DateEcheance1__c';
import 	DateEcheance2_FIELD from '@salesforce/schema/Case.SM_DateEcheance2__c';
import 	DateEcheance3_FIELD from '@salesforce/schema/Case.SM_DateEcheance3__c';
import 	DateEcheance4_FIELD from '@salesforce/schema/Case.SM_DateEcheance4__c';
import 	DateEcheance5_FIELD from '@salesforce/schema/Case.SM_DateEcheance5__c';
import 	DateEcheance6_FIELD from '@salesforce/schema/Case.SM_DateEcheance6__c';
import 	DateEcheance7_FIELD from '@salesforce/schema/Case.SM_DateEcheance7__c';
import 	DateEcheance8_FIELD from '@salesforce/schema/Case.SM_DateEcheance8__c';
import 	DateEcheance9_FIELD from '@salesforce/schema/Case.SM_DateEcheance9__c';
import 	DateEcheance10_FIELD from '@salesforce/schema/Case.SM_DateEcheance10__c';
import 	MontantEcheance1_FIELD from '@salesforce/schema/Case.SM_MontantEcheance1__c';
import 	MontantEcheance2_FIELD from '@salesforce/schema/Case.SM_MontantEcheance2__c';
import 	MontantEcheance3_FIELD from '@salesforce/schema/Case.SM_MontantEcheance3__c';
import 	MontantEcheance4_FIELD from '@salesforce/schema/Case.SM_MontantEcheance4__c';
import 	MontantEcheance5_FIELD from '@salesforce/schema/Case.SM_MontantEcheance5__c';
import 	MontantEcheance6_FIELD from '@salesforce/schema/Case.SM_MontantEcheance6__c';
import 	MontantEcheance7_FIELD from '@salesforce/schema/Case.SM_MontantEcheance7__c';
import 	MontantEcheance8_FIELD from '@salesforce/schema/Case.SM_MontantEcheance8__c';
import 	MontantEcheance9_FIELD from '@salesforce/schema/Case.SM_MontantEcheance9__c';
import 	MontantEcheance10_FIELD from '@salesforce/schema/Case.SM_MontantEcheance10__c';


import 	DLP_FIELD from '@salesforce/schema/Case.SM_DLP__c';

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
    @api nomInstitutBancaire;
    @api iBAN;
    @api EnqSat;
    @api transformDateEcheance;
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
    @track showErrorPA=false;
    checkedPause;
    checkedInteraction;
    DRId_Case;
    idBusinessPartner;
    isDataEmpty;
    noDataCase = false;
    @track messageInegibilite;
    @track isDpCreated;
    @track dpcreationerrormsg;
    @track displayTraceInteraction = true;
    @track showtableDP = true;
    @track suffixIneligibilitedp;
    @track interactionDescription;
    //calendar paramas
    @track minDate;
    startdatetimesimulerdp;
    enddatetimesimulerdp;
    startrecapdp;
    endrecapdp;    //afficher le message d'eurreur dans l'interface simulation
    @track showErrorPA=false;
    //vérifier si on a lancé SimulatePlanApurement
    launchSimulatePlanApurement=false;
    //contexte d'inéligiblité4
    ineligibilityContext4=false;
    //affichage du worning lié au ineligiblité code 4
    @track showWorningIneligibilityContext4=false;
    //nombre d'écheance
    @track dateNumberGt3=false;
    //nombre d'écheance & contexte d'inéligiblité
    @track dateDneligibilityContext4=false;
    //total echeances
    @track totalEcheanceDP;
    //Le total des échéances doit correspondre au Montant total
    @track errorTotalAmount=false;
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT }) objectInfo;
    // check if connected user is allowed to create DP
    @wire(checkAllowCreateDP) 
    wirecheckACDP({ error, data }) {
        if (data) {
      this.isDataEmpty = true;
        } else if (error) {
      this.isDataEmpty = false;
        }
    };
    imagefilariane = creationfilarianne;
    handlePause(event){
        this.checkedPause = event.target.checked;
    }
    handleInteraction(event){
        console.log("change");
        this.checkedInteraction = event.target.checked;
    }
    @api
    get nextDisabled(){
        if(this.nextDisable){
            return true;
        }
        if(((this.checkedPause && this.checkedInteraction) || (!this.checkedPause && !this.checkedInteraction)) && !this.messageInegibilite){
            return true;
        }
        return false
    }
    //Create Case et tracage d'interaction
    caseNavigate(){
        this.nextDisable = true;
        this.noDataCase = false;
        if(this.checkedInteraction){
             this.createCase(true);             
        }
        else if(this.checkedPause){
            this.createCase(true);
        }   
    }
    closeTab() {
        let close = true;
        const closeclickedevt = new CustomEvent('closeclicked', {
            detail: { close },
        });
        // Fire the custom event
        this.dispatchEvent(closeclickedevt);
    }
    navigateToInteraction(updateStatusTaskValue){
        const eventName = 'openInteraction';
        let inputMap;
        //Params pour interaction
        if(this.checkedInteraction ){
            inputMap = {
                isActivateTracerInteractionOS: true,
                isCasNominal:true,
                isPauseInteraction: false,
                DRId_Case:this.DRId_Case,
                StepNameOS:'Délai de paiement',
                refClientIdBP:this.IdBusinessPartner,
                //set status task <==A traiter
                updateStatusTask:updateStatusTaskValue,
                ineligibiliteDP:this.messageInegibilite,
                descriptionTraceInteraction:this.interactionDescription,
                isLWC:true,
                EnqSat:this.EnqSat
            }
        }
      //Params pour mise en pause
        else if(this.checkedPause){
            inputMap = {
            isActivateTracerInteractionOS: true,
            isCasNominal:false,
            isPauseInteraction: true,
            DRId_Case:this.DRId_Case,
            StepNameOS:'Délai de paiement',
            refClientIdBP:this.IdBusinessPartner,
            ineligibiliteDP:this.messageInegibilite,
            isLWC:true,
            EnqSat:this.EnqSat
            }
        }
        console.log('EnqSat187'+this.EnqSat);
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    get showSpinner() {
        return (this.listPA && this.listPA.length > 0) || this.noData
    }
    get firstEcheanceMontant(){
        return this.listEcheanceDp[0].montantEcheance;
    }
    get firstDateEcheance(){
        return this.listEcheanceDp[0].dateEcheance;
    }
        // FT1-3943 --> Ibrahim Merabti le 07/07/2020 
     get displayCreateDpButtonConditions(){
         return this.isDataEmpty && Number(this.solde) > 0;             
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
                    if( item.statutPA === 'actif' && item.categoriePA === 'Z1' && item.planApurementRapproche===false){
                        this.showCreateDPButton=false;
                    }
                    //FT1-4154 Si <planApurementRapproche> = true → Le statut du DP devient “Rapproché”
                    if(item.planApurementRapproche===true){
                        item.statutPA=item.statutPA.replace('actif', 'Rapproché');
                    }else{
                        item.statutPA=item.statutPA.replace('actif', 'En cours');
                    }
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
                if(this.listPA[0].statutPA==='Actif' && this.listPA[0].categoriePA==='Z1' && this.listPA[0].planApurementRapproche===false){
                    this.showCreateDPButton=false;
                }
                //FT1-4154 Si <planApurementRapproche> = true → Le statut du DP devient “Rapproché”

                if(this.listPA[0].planApurementRapproche===true){
                    this.listPA[0].statutPA=this.listPA[0].statutPA.replace('Actif', 'Rapproché');
                }else{
                    this.listPA[0].statutPA=this.listPA[0].statutPA.replace('Actif', 'En cours');

                }
                if(this.listPA[0].dateDesactivationPA){
                const d = this.listPA[0].dateDesactivationPA.split('-');                   
                this.listPA[0].dateDesactivationPA= d[2] +'/'+ d[1] +'/'+ d[0];   
                }  
                if (this.listPA[0].echeance && !this.listPA[0].echeance.length) {
                    this.listPA[0].echeance = [this.listPA[0].echeance];
                    this.listPA[0].firstEcheance=this.listPA[0].echeance[0].dateEcheance;                   
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
          console.error('showCreateDPButton:'+this.showCreateDPButton);
    }
    handleChange(event) {
        const field = event.target.name;
        if (field === 'nombreEcheance') {
            this.nombreEcheance = event.target.value;
            if(this.nombreEcheance >3)
            { if(this.ineligibilityContext4==true){
                this.dateNumberGt3=false;
                this.showWorningIneligibilityContext4=false;
                this.dateDneligibilityContext4=true;
                }else{
                this.dateNumberGt3=true;
                this.showWorningIneligibilityContext4=false;
                this.dateDneligibilityContext4=false;
                }            
            }else {
                if(this.ineligibilityContext4==true){
                    this.showWorningIneligibilityContext4=true;
                }
             this.dateNumberGt3=false;
             this.dateDneligibilityContext4=false;
            }
        } else if (field === 'dateReference') {            
            this.dateEcheanceSimuler = event.target.value;
            //mettre le statut de launchSimulatePlanApurement a false 
            this.launchSimulatePlanApurement=false; 
            if(this.checkValidityDateEcheanceSimuler()===false){
                event.target.setCustomValidity("Première échéance invalide.");                
            }else{
                event.target.setCustomValidity(""); 
            }
            event.target.reportValidity();
        }
    }
    //vérifier si la date entre  J+15 et J+30 n'est pas un weekend ni un lundi 
    checkValidityDateEcheanceSimuler(){
        if(this.formatterDate(this.dateEcheanceSimuler)===this.formatterDate(new Date())||(new Date(this.dateEcheanceSimuler)).getDay() === 6 || (new Date(this.dateEcheanceSimuler)).getDay() === 0|| 
                (new Date(this.dateEcheanceSimuler)).getDay() === 1 || (new Date(this.dateEcheanceSimuler))< new Date(this.minDate)|| (new Date(this.dateEcheanceSimuler))> new Date(this.maxDate))
                    return false;
                    else return true;
    }
    showDelaiPaiementCreation(){
        this.startdatetimesimulerdp = Date.now();
        this.createCase();
        this.headerText = 'CRÉATION DÉLAI DE PAIEMENT';
        this.showAdress = false;
        this.showDelaiPaimentSimulation = true;
        this.showTablePa = false;  
        this.showHeaderTableSimulation = false;
        this.showButtonsDP = false;
        //init value dateReference date 
        let today= new Date();
        today.setDate(today.getDate() + 15);
        this.minDate=this.formatterDate(today);
        this.dateEcheanceSimuler=this.minDate;
        today.setDate(today.getDate() + 15);
        this.maxDate=this.formatterDate(today);
        this.montantTotal = this.solde;
        this.displayTraceInteraction = true;
        this.showtableDP = false;
    }
    formatterDate(dateToFormat){
        let vDate= new Date(dateToFormat);
        let dd = String(vDate.getDate()).padStart(2, '0');
        let mm = String(vDate.getMonth()+1).padStart(2, '0'); 
        let yyyy = vDate.getFullYear();        
        return String(yyyy + '-' + mm + '-' + dd);
    }
    simulatePlanApurement(){
        this.showListEcheanceDp=false;           
        var inputCmp = this.template.querySelector(".dateReferenceId");
        var dateReference = new Date(this.dateEcheanceSimuler);
        console.log(this.dateEcheanceSimuler);
        dateReference.setDate(dateReference.getDate()-15);
        dateReference=this.formatterDate(dateReference);
        console.log(dateReference);
        var inputDateReference = dateReference+'T00:00:00';
        //vérifier si un des inputs==vide
        if(this.dateEcheanceSimuler===undefined||this.nombreEcheance===undefined||this.dateEcheanceSimuler===null||this.nombreEcheance===null||this.checkValidityDateEcheanceSimuler()===false){
            inputCmp.setCustomValidity("Première échéance invalide.");   
            inputCmp.reportValidity();
            this.launchSimulatePlanApurement=false; 
            return;
        }else{
            inputCmp.setCustomValidity(""); 
            inputCmp.reportValidity();
        }
        this.launchSimulatePlanApurement=true;                
        //init  showErrorPA      
        this.totalEcheanceDP=this.solde;
        callIP({ inputMap: {dateReference:inputDateReference,nombreEcheance:this.nombreEcheance,montantGlobal:this.montantTotal}, NameIntergation: 'IP_SM_simulerPlanApurement_SOAP' }).then(result => {
            this.showErrorPA=true; 
            if(result.Result.simulerPlanApurementOutput && result.Result.simulerPlanApurementOutput.CodeRetour==='OCTOPUS_SimulerPlanApurement_01'){
                this.showErrorPA=false;
            }
            if(result.Result.simulerPlanApurementOutput.echeance && result.Result.simulerPlanApurementOutput.echeance.length){
            this.listEcheanceDp = result.Result.simulerPlanApurementOutput.echeance;
            }else{
            this.listEcheanceDp = [result.Result.simulerPlanApurementOutput.echeance];
            }
            this.showListEcheanceDp=true;
			/* if(this.listEcheanceDp.length > 3 || this.montantTotal > 500 || this.ineligibilityContext4){
                this.traceInteractionDescription();
                this.checkedInteraction = true;
            }*/
          }).catch(error => {
            this.showErrorPA=true;            
             console.log(error);
        });
    }
        //creer les DP dans SAP (bouton suivant)
        suivantAction(){
            this.enddatetimesimulerdp = Date.now();
            this.createvlocitytrackingentry('Création délai de paiement');
            //chek if 'Appel interrompu - Tracer l'interac' is checked
            if(this.checkedPause){
                console.log('enter trace interaction ');
                this.updateCase('Différé');
                this.navigateToInteraction(false);
                this.closeTab();
                return ;
            }
            //if not cheked if 'Appel interrompu - Tracer l'interac' so start process to validate&create Echanace
            if(this.launchSimulatePlanApurement==false){
                this.showErrorPA=true; 
            }else{ 
                if(parseFloat(this.totalEcheanceDP).toFixed(2)===parseFloat(this.solde).toFixed(2)){
                    this.errorTotalAmount=false;
                }else{
                    this.errorTotalAmount=true;
                    return ;
                }
                if(this.listEcheanceDp.length > 3 || this.montantTotal > 500 || this.ineligibilityContext4){
                    this.traceInteractionDescription();
                    this.checkedInteraction = true;
                }   
                //in case of 'accord cadre'
                if(this.checkedInteraction){
                    console.log('enter trace interaction ');
                    this.updateCase('A traiter');
                    this.navigateToInteraction(true);
                    this.closeTab();
                }else{
                    console.log('enter plan apurement creation ');
                    this.creerPlanApurement();
                }
            }
        }
    // close
    closeDPTab(){
        var close = true;
        const closeclickedevt = new CustomEvent('closeDPTabEvent', {
            detail: close 
        });
         // Fire the custom event
         this.dispatchEvent(closeclickedevt); 
    }
    updateCase(statut){
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.DRId_Case;
        fields[Status_FIELD.fieldApiName] = statut;
        fields[SousStaut_FIELD.fieldApiName] = 'Demande de validation superviseur';
        //FT2-1736 [UAT] [DP] Mail de refus de DP - Adresse erronée-- Ajout de l'adresse concernée lors de l'update case
        var complementAdresse = this.complementAdresse==null? '' :this.complementAdresse;
        fields[SM_AdresseConcernee_FIELD.fieldApiName] = this.numeroVoie +' '+ this.libelleVoie+' '+ complementAdresse+' '+  this.codePostal+' '+  this.ville;
        //FT2-1687 Délai de paiement - sauvegarde des infos nécessaires à la validation du superviseur
        //Stockage des valeurs dans les champs
        if(this.listEcheanceDp.length > 3 || this.montantTotal > 500 || this.ineligibilityContext4){ 
            fields[SoldeConcerneDP_FIELD.fieldApiName] = this.solde;
            fields[NbrEcheances_FIELD.fieldApiName] = this.listEcheanceDp.length;

            for (var i=0;i<this.listEcheanceDp.length;i++) {

                var dateFieldName;
                var montantFieldName;

                if (i==0) {
                    dateFieldName = DateEcheance1_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance1_FIELD.fieldApiName;
                }
                if (i==1) {
                    dateFieldName = DateEcheance2_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance2_FIELD.fieldApiName;
                }
                if (i==2) {
                    dateFieldName = DateEcheance3_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance3_FIELD.fieldApiName;
                }
                if (i==3) {
                    dateFieldName = DateEcheance4_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance4_FIELD.fieldApiName;
                }
                if (i==4) {
                    dateFieldName = DateEcheance5_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance5_FIELD.fieldApiName;
                }
                if (i==5) {
                    dateFieldName = DateEcheance6_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance6_FIELD.fieldApiName;
                }
                if (i==6) {
                    dateFieldName = DateEcheance7_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance7_FIELD.fieldApiName;
                }
                if (i==7) {
                    dateFieldName = DateEcheance8_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance8_FIELD.fieldApiName;
                }
                if (i==8) {
                    dateFieldName = DateEcheance9_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance9_FIELD.fieldApiName;
                }
                if (i==9) {
                    dateFieldName = DateEcheance10_FIELD.fieldApiName;
                    montantFieldName = MontantEcheance10_FIELD.fieldApiName;
                }

                fields[dateFieldName] = this.listEcheanceDp[i].dateEcheance.split("/").reverse().join("-");
                fields[montantFieldName] = this.listEcheanceDp[i].montantEcheance;

            }
            fields[DLP_FIELD.fieldApiName] = this.transformDateEcheance.split("/").reverse().join("-");
        } 

        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() => {
            console.log('statut du case mis à jour');
        }).catch(error => {
            console.log('erreur lors de la MAJ du case '+JSON.stringify(error));
        });
    }
    updateCaseEnd(){
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.DRId_Case;
        fields[Status_FIELD.fieldApiName] = 'Pré-clôturé';
        fields[SousStaut_FIELD.fieldApiName] = 'Demande de validation superviseur';
        const recordInput = { fields };
        updateRecord(recordInput)
                .then(() => {
                    console.log('case mis à jour '+this.DRId_Case);
                })
                .catch(error => {
                    console.log('erreur lors de la maj du case '+JSON.stringify(error));
                });
    }
    navigateToInteractionEnd(){
        const eventName = 'openInteraction';
        let inputMap;
        //Params pour interaction
        inputMap = {
            isActivateTracerInteractionOS: true,
            isCasNominal:true,
            isPauseInteraction: false,
            DRId_Case:this.DRId_Case,
            StepNameOS:'Délai de paiement',
            refClientIdBP:this.IdBusinessPartner,
            isLWC:true,
            EnqSat:this.EnqSat
        }
        console.log('EnqSat SynDP'+inputMap.EnqSat);
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    finishDP(){
        this.endrecapdp = Date.now();
        this.createvlocitytrackingentry('Recap délai de paiement');
        this.updateCaseEnd();
        this.navigateToInteractionEnd();
        this.closeDPTab();
    }
    createCase(callback) {
      const fields = {};    
        let caseStatus
        if(this.checkedInteraction){
             caseStatus = 'Pré-clôturé';
             fields[SousStaut_FIELD.fieldApiName] = 'Conforme';
        }else{
            caseStatus = 'En Traitement';
        }
        fields[Type_FIELD.fieldApiName] = 'Paiement';
        fields[SousType_FIELD.fieldApiName] = "Délai de paiement / plan d'apurement";
        fields[Origin_FIELD.fieldApiName] = 'Phone';
        fields[Status_FIELD.fieldApiName] = caseStatus;
        fields[MotifIneligibilite_FIELD.fieldApiName] = this.messageInegibilite;
        fields[AccountId_FIELD.fieldApiName] = this.AccountId;
        fields[ContactId_FIELD.fieldApiName] =this.recordId;
        
        //fields[SousStaut_FIELD.fieldApiName] = 'Conforme';
        const rtis = this.objectInfo.data.recordTypeInfos;
        //find and set recordType==Service 
        fields[RecordType_FIELD.fieldApiName]= Object.keys(rtis).find(rti => rtis[rti].name === 'Service');
        const recordInput = {
            apiName: CASE_OBJECT.objectApiName,
            fields
        };
        setCache().then(r => {
             console.log("cache has been set for case");
             createRecord(recordInput).then(acase => {
                this.DRId_Case = acase.id;
                console.log('case créé DRId_Case '+this.DRId_Case);
                if(callback){
                    this.navigateToInteraction(false);
                    this.closeTab();
                }
            })
            .catch(error => {
                    console.log('erreur lors de la création du case' +JSON.stringify(error));
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur dans la création Case',
                                message: JSON.stringify(error),
                            variant: 'error',
                        }),
                    );
            });
        }).catch(error => {
                console.log("got error setCache", error);
        });
    }
    createvlocitytrackingentry(stepname){
        //this.enddatetimesimulerdp = Date.now();
        const fields = {};
        fields[elementname_FIELD.fieldApiName] = stepname;
        //fields[elementstepnumber_FIELD.fieldApiName] = '1';
        fields[elementtype_FIELD.fieldApiName] = 'Step';
        fields[name_FIELD.fieldApiName] = 'StepActionTime';
        fields[OmniScriptContextId_FIELD.fieldApiName] = this.recordId;
        fields[OmniscriptType_FIELD.fieldApiName] = 'Délai de paiement';
        fields[OmniScriptSubType_FIELD.fieldApiName] = 'Délai de paiement';
        fields[elementtype_FIELD.fieldApiName] = 'Step';
        fields[TrackingEvent_FIELD.fieldApiName] = 'StepActionTime';
        fields[caseid_FIELD.fieldApiName] = this.DRId_Case ;
        //let timestamp = Date.now();
        fields[vlocity_cmt__Timestamp_FIELD.fieldApiName] = new Date().toISOString();
        fields[vlocity_cmt__TrackingService.fieldApiName] = 'OmniScript';
        fields[elapsetime_FIELD.fieldApiName] = 10;
        console.log('## this.enddatetimesimulerdp '+this.enddatetimesimulerdp);
        console.log('## this.startdatetimesimulerdp '+this.startdatetimesimulerdp);
        let elapsetime; 
        if(stepname === 'Recap délai de paiement'){
            elapsetime = this.endrecapdp - this.startrecapdp; 
            fields[elementstepnumber_FIELD.fieldApiName] = '2';
        }else{
            elapsetime = this.enddatetimesimulerdp - this.startdatetimesimulerdp; 
            fields[elementstepnumber_FIELD.fieldApiName] = '1';
        }
        console.log('## elapsetime '+elapsetime);
        fields[elapsetime_FIELD.fieldApiName] = elapsetime;
        fields[elementlabel_FIELD.fieldApiName] = stepname;
        const recordInput = {
            apiName: TRACKING_OBJECT.objectApiName,
            fields
        };
        createRecord(recordInput).then(tracking => { 
            console.log('Tranking DMT créé '+tracking.id);
        })
        .catch(error => {
                console.log('erreur lors de la création du Tacking DMT ' +JSON.stringify(error));
        });
    }
    @track disableInteraction;
    activateTraceInteractionIneligibility(){
        this.disableInteraction = true;
        //this.messageInegibilite = 'erreur';
        this.checkedInteraction = true;
        console.log('this.nextDisabled  '+this.nextDisabled);
    }
   VerifierEligibilitePlanApurement(){
        console.log('this.nomInstitutBancaire '+this.nomInstitutBancaire);
        console.log('this.iBAN '+this.iBAN);
        console.log('verif eligibilite ');
        callIP({ inputMap: {idPersonne:this.IdBusinessPartner,idCompteClient:this.NoCompteContrat}, NameIntergation: 'IP_SM_VerifierEligibilitePlanApurement_SOAP' }).
        then(result => {
            console.log("idPersonne"+this.IdBusinessPartner+"idCompteClient"+this.NoCompteContrat);  
            //idPersonne0302840710idCompteClient000503960194
            console.log("resp ws eligibilite "+JSON.stringify(result.Response));  
                //eligible==true if (code==0||code==1) & si le profile du USER connecté existe dans SM_Allow_Create_DP__mdt
                if(result && result.Response && result.Response.verifierEligibiliteOutput && result.Response.verifierEligibiliteOutput.statutEligibilite
                    && result.Response.verifierEligibiliteOutput.statutEligibilite.code && ( result.Response.verifierEligibiliteOutput.statutEligibilite.code === '0' || result.Response.verifierEligibiliteOutput.statutEligibilite.code === '1' ||
                    (result.Response.verifierEligibiliteOutput.statutEligibilite.code === '2' && result.Response.verifierEligibiliteOutput.motifNonEligibilite && result.Response.verifierEligibiliteOutput.motifNonEligibilite.code=='4'))){
                    //ADE FT1-2166 conserver le contexte d'inéliblité
                    if(result.Response.verifierEligibiliteOutput.statutEligibilite.code === '2' && result.Response.verifierEligibiliteOutput.motifNonEligibilite && result.Response.verifierEligibiliteOutput.motifNonEligibilite.code=='4')
                    {this.ineligibilityContext4=true;
                    this.showWorningIneligibilityContext4=true;
                    }
                    this.solde=result.Response.verifierEligibiliteOutput.statutEligibilite.montantEligible;
                    //this.showDelaiPaiementCreation();
                     // ineligible 1 et 7 
                    if(result.Response.verifierEligibiliteOutput.statutEligibilite.code === '1' && result.Response.verifierEligibiliteOutput.motifNonEligibilite.code === '7'){
                        getErrorMessage({ errorCode: '7'}).then(resultMsg=> {
                            this.messageInegibilite = resultMsg;
                            this.suffixIneligibilitedp = 'veuillez activer le Prélèvement afin de mettre en place un Délai de Paiement.';
                            this.activateTraceInteractionIneligibility(); 
                        }).catch(error => {
                            console.log('erreur '+JSON.stringify(error))
                            //this.messageInegibilite = JSON.stringify(error);
                            this.messageInegibilite = 'Erreur technique';
                        });
                    }else{
                    this.showDelaiPaiementCreation();
                    }  
                } else {
                    this.ineligibilityContext4=true;
                    this.showWorningIneligibilityContext4=true;
                    if(result && result.Response && result.Response.verifierEligibiliteOutput && result.Response.verifierEligibiliteOutput.statutEligibilite
                        && result.Response.verifierEligibiliteOutput.statutEligibilite.code && result.Response.verifierEligibiliteOutput.statutEligibilite.code === '2'){
                            if(result.Response.verifierEligibiliteOutput.motifNonEligibilite && result.Response.verifierEligibiliteOutput.motifNonEligibilite.code ){
                                console.log('Code erreur inegibilite : '+result.Response.verifierEligibiliteOutput.motifNonEligibilite.code);
                                // Envoyer le code de refus a SAP --> US FT1-3736
                                //var refusDate = new Date(new Date().toString().split('GMT')[0]+' UTC').toISOString().split('.')[0];
                                //var refusMotif = result.Response.verifierEligibiliteOutput.motifNonEligibilite.code;
                                getErrorMessage({ errorCode: result.Response.verifierEligibiliteOutput.motifNonEligibilite.code }).then(resultMsg=> {
                                    this.messageInegibilite = resultMsg;
                                    this.suffixIneligibilitedp = 'impossible de mettre en place un délai de paiement.';
                                    this.activateTraceInteractionIneligibility(); 
                                    //this.headerText = 'PREREQUIS KO';
                                })
                                .catch(error => {
                                    console.log('erreur '+JSON.stringify(error))
                                    //this.messageInegibilite = JSON.stringify(error);
                                    this.messageInegibilite = 'Erreur technique';
                                });
                                  // Envoyer le code de refus a SAP --> US FT1-3736
                                   /* callIP({ inputMap: {idPersonne:this.IdBusinessPartner,dateDeRefus:refusDate,motifDeRefus:refusMotif}, NameIntergation: 'IP_SM_EnvoyerRefusDelaiPaimentSap_SOAP' }).then(result => {
                                                console.log('motif de refus envoyé au SAP');
                                             })*/
                            }
                        }
                    console.log("empty response/non éligible");
                   // this.showDelaiPaiementCreation();
                }
                // en cas d'erreur octopus
                if( result && result.Response && result.Response.verifierEligibiliteOutput && result.Response.verifierEligibiliteOutput.statutEligibilite && 
                    result.Response.verifierEligibiliteOutput.statutEligibilite.messageRetourCode != 'OCTOPUS_VerifierEligibilite_01'){
                        this.messageInegibilite = 'Erreur technique';
                }
                this.totalEcheanceDP=this.solde;
            }).catch(error => {
                this.messageInegibilite = 'Erreur technique';
                console.log(error);
            });
    }
    @wire(getRecapArticle, { idBp: '$IdBusinessPartner' })
    articlerecap;
    creerPlanApurement(){
        var lisEchePa= [];
       console.log('create plan apurement enter');
        var len = this.listEcheanceDp.length;
        for (var i = 0; i < len; i++) {
            var myDate=this.listEcheanceDp[i].dateEcheance;
            myDate=myDate.split("/");
            var newDate=myDate[2]+"-"+myDate[1]+"-"+myDate[0];
            lisEchePa.push({
                dateEcheance: newDate +'T00:00:00', 
                montantEcheance: this.listEcheanceDp[i].montantEcheance,
            });
        }
        console.log('lisEchePa '+JSON.stringify(lisEchePa));
        //this.isDpCreated = true;
        //this.showDelaiPaimentSimulation = false;
        //this.showtableDP = false; 
        callIP({ inputMap: {idPersonne: this.IdBusinessPartner,idCompteClient: this.NoCompteContrat,montantGlobal: this.solde,nombreEcheance: this.listEcheanceDp.length,listEcheance: lisEchePa}, NameIntergation: 'IP_SM_CreerPA_MAJPersonne' }).then(result=> {
           console.log('result '+JSON.stringify(result));
           if(result.success === 'true'){
            this.startrecapdp = Date.now();
                this.isDpCreated = true;
                this.showDelaiPaimentSimulation = false;
                this.showtableDP = false; 
                this.displayTraceInteraction = false;
                this.headerText = '';
           }else{
                this.isDpCreated = false;
                this.dpcreationerrormsg = 'Une erreur est survenue lors de la création du Délai de Paiement, celui-ci n’a pas été créé : '+result.error;
           }
        })
        .catch(error => {
            console.log(error);
            this.dpcreationerrormsg = 'Une erreur est survenue lors de la création du Délai de Paiement, celui-ci n’a pas été créé';
            });
    }
    countTotalPlanApurement(event){
        let value=event.currentTarget.value;
        this.listEcheanceDp[event.currentTarget.dataset.index].montantEcheance=value;
        this.totalEcheanceDP=0;        
        for (var i = 0; i < this.listEcheanceDp.length; i++) {
            this.totalEcheanceDP=this.totalEcheanceDP+parseFloat(this.listEcheanceDp[i].montantEcheance);
        }
    }
    traceInteractionDescription(){
        var description = 'Echéancier du délai de paiement de '+this.solde+'€ avec accord client: <br><br>';
        var len = this.listEcheanceDp.length;
        for (let i = 0; i < len; i++) {
            let index = i + 1;
            description = description + index + ' : ' + this.listEcheanceDp[i].montantEcheance + '€ le '+ this.listEcheanceDp[i].dateEcheance + '  <br>';
        }

        var IBANAnonymise = ""; // Cas où il n y'a pas d'IBAN
        if (this.iBAN) IBANAnonymise = this.iBAN.substring(0, 4) + '...' +this.iBAN.substring(this.iBAN.length - 4 ,this.iBAN.length);

        if (this.nomInstitutBancaire) this.interactionDescription = description + ' <br>Coord bancaires  ' + this.nomInstitutBancaire + '  <br>' + IBANAnonymise;
        else this.interactionDescription = description; //Cas où il n y'a pas de nom d'institut bancaire
    }
}