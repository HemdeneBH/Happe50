/** 
 * @description       : FT2-1587/FT2-1332/ FT2-1524 Component displayed in case record page for approval of delai de paiement by superviseur
 * @author            : Karen ROUSSEAU
 * @group             : 
 * @last modified on  : 04-06-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   07-02-2022   Karen ROUSSEAU     Initial Version
 * 1.1   21-02-2022   FT2-AE             Added all the handling for the buttons
**/
import { LightningElement, api, wire, track} from 'lwc';
import { getRecord, getFieldValue, getFieldDisplayValue,updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";

import SM_DLP_PrelevementBloque from '@salesforce/label/c.SM_DLP_PrelevementBloque';


//FT2-1587 Id of user to determine its role
import CurrentUserId from '@salesforce/user/Id';

//FT2-1587 Fields from Case to display in the component
import SoldeConcerneDP_FIELD   from '@salesforce/schema/Case.SM_soldeConcerneDP__c';
import NbrEcheances_FIELD      from '@salesforce/schema/Case.SM_NbrEcheances__c';
import DateEcheance1_FIELD     from '@salesforce/schema/Case.SM_DateEcheance1__c';
import DateEcheance2_FIELD     from '@salesforce/schema/Case.SM_DateEcheance2__c';
import DateEcheance3_FIELD     from '@salesforce/schema/Case.SM_DateEcheance3__c';
import DateEcheance4_FIELD     from '@salesforce/schema/Case.SM_DateEcheance4__c';
import DateEcheance5_FIELD     from '@salesforce/schema/Case.SM_DateEcheance5__c';
import DateEcheance6_FIELD     from '@salesforce/schema/Case.SM_DateEcheance6__c';
import DateEcheance7_FIELD     from '@salesforce/schema/Case.SM_DateEcheance7__c';
import DateEcheance8_FIELD     from '@salesforce/schema/Case.SM_DateEcheance8__c';
import DateEcheance9_FIELD     from '@salesforce/schema/Case.SM_DateEcheance9__c';
import DateEcheance10_FIELD    from '@salesforce/schema/Case.SM_DateEcheance10__c';
import MontantEcheance1_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance1__c';
import MontantEcheance2_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance2__c';
import MontantEcheance3_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance3__c';
import MontantEcheance4_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance4__c';
import MontantEcheance5_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance5__c';
import MontantEcheance6_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance6__c';
import MontantEcheance7_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance7__c';
import MontantEcheance8_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance8__c';
import MontantEcheance9_FIELD  from '@salesforce/schema/Case.SM_MontantEcheance9__c';
import MontantEcheance10_FIELD from '@salesforce/schema/Case.SM_MontantEcheance10__c';
import DLP_FIELD               from '@salesforce/schema/Case.SM_DLP__c';
// FT2-1524 fields from case and contact linked to the case to use for the email sent upon rejection
import SM_TECH_DelaiPaiementRefuse_FIELD from '@salesforce/schema/Case.SM_TECH_DelaiPaiementRefuse__c'; 
import SM_TECH_Nom_FIELD       from '@salesforce/schema/Case.SM_TECH_Nom__c';
import SM_TECH_Civilite_FIELD  from '@salesforce/schema/Case.SM_TECH_Civilite__c';
import VlocityContactEmail_FIELD   from '@salesforce/schema/Case.Vlocity_ContactEmail__c';
import Vlocity_SendEmail_FIELD   from '@salesforce/schema/Case.Vlocity_SendEmail__c';
import EmailPrincipalValue_FIELD   from '@salesforce/schema/Case.Contact.EmailPrincipalValue__c';
import ContactName_FIELD   from '@salesforce/schema/Case.Contact.Name';
import SALUTATION_FIELD  from '@salesforce/schema/Case.Contact.Salutation';
import ID_FIELD from '@salesforce/schema/Case.Id';
// FT2-1332 Champs utilisé pour les boutons approuver/ lancer simulation
import StatusDuDelaiDePaiementFIELD from '@salesforce/schema/Case.SM_StatusDuDelaiDePaiement__c'; 
import MobilePrincipalValueFIELD from '@salesforce/schema/Case.Contact.MobilePrincipalValue__c'; 
import NOCOMPTECONTRATFIELD from '@salesforce/schema/Case.No_Compte_contrat__c'; 
import IDBPFIELD from '@salesforce/schema/Case.Contact.Identifiant_Buisness_Partener__c'; 
import Status_FIELD from '@salesforce/schema/Case.Status';
import MotifIneligibiliteDelaiPaiementFIELD from '@salesforce/schema/Case.SM_MotifIneligibiliteDelaiPaiement__c'; 
import DLP_Formule__FIELD               from '@salesforce/schema/Case.SM_TECH_DLP_Formule__c';



//FT2-1587 Field from User to determine the role of the user
import ROLE_NAME_FIELD         from '@salesforce/schema/User.UserRole.DeveloperName';
const FIELDS = [SoldeConcerneDP_FIELD, NbrEcheances_FIELD, DateEcheance1_FIELD, DateEcheance2_FIELD, DateEcheance3_FIELD, DateEcheance4_FIELD, DateEcheance5_FIELD, DateEcheance6_FIELD, DateEcheance7_FIELD, 
               DateEcheance8_FIELD, DateEcheance9_FIELD, DateEcheance10_FIELD, MontantEcheance1_FIELD, MontantEcheance2_FIELD, MontantEcheance3_FIELD, MontantEcheance4_FIELD, MontantEcheance5_FIELD, MontantEcheance6_FIELD, 
               MontantEcheance7_FIELD, MontantEcheance8_FIELD, MontantEcheance9_FIELD, MontantEcheance10_FIELD, DLP_FIELD,EmailPrincipalValue_FIELD,ContactName_FIELD,SALUTATION_FIELD
               ,StatusDuDelaiDePaiementFIELD,MobilePrincipalValueFIELD,NOCOMPTECONTRATFIELD,IDBPFIELD,MotifIneligibiliteDelaiPaiementFIELD,DLP_Formule__FIELD,Status_FIELD];

export default class SmValidationDelaiPaiementSup extends LightningElement {
   label = {
      SM_DLP_PrelevementBloque
   };
   //FT2-1587 Case Id
   @api recordId;

   //FT2-1332 champs utilisé lors de la simulation de l'échéancier
   @api listEcheanceDpUpdated;
   @api isLoading; 
   @api isWaitingWS;
   //FT2-1587 Minimum and maximum dates for Première échéance field
   @track minDate;
   @track maxDate;

   // FT2-1587 Variables for input values
   @track nombreEcheance;
   @track dateEcheanceSimuler;
   @track declineReason;
   // FT2-1587 Variables to make some fields and buttons editable
   @track fieldsDPdisabled = true;
   @track boutonsDPdisabled = true;
   @track montantEcheanceModified = false;
   //FT2-1332 boolean that manage message errors
   @track errorTotalAmount=false;
   @track errorSimulationNeeded=false;
   @track dpcreationerrormsg;
   // Verifie that the simulation for Plan Apurement was launched
   @track launchSimulatePlanApurement=false;

   connectedCallback() {
      // FT2-1587 
      let today= new Date();
      today.setDate(today.getDate() + 15);
      this.minDate=this.formatterDate(today);
      today.setDate(today.getDate() + 15);
      this.maxDate=this.formatterDate(today);
   }

   // FT2-1587 Retrieve infos to display from case
   @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) 
   currentCase;

   get caseSM_soldeConcerneDP(){
      return getFieldValue(this.currentCase.data, SoldeConcerneDP_FIELD);
   }   
   
   get caseSM_NbrEcheances(){
      return getFieldValue(this.currentCase.data, NbrEcheances_FIELD);
   }

   get caseSM_DateEcheance1Val(){
      return getFieldValue(this.currentCase.data, DateEcheance1_FIELD);
   }

   get caseSM_DateEcheance1(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance1_FIELD);
   }

   get caseSM_DateEcheance2(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance2_FIELD);
   }

   get caseSM_DateEcheance3(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance3_FIELD);
   }

   get caseSM_DateEcheance4(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance4_FIELD);
   }

   get caseSM_DateEcheance5(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance5_FIELD);
   }

   get caseSM_DateEcheance6(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance6_FIELD);
   }

   get caseSM_DateEcheance7(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance7_FIELD);
   }

   get caseSM_DateEcheance8(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance8_FIELD);
   }

   get caseSM_DateEcheance9(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance9_FIELD);
   }

   get caseSM_DateEcheance10(){
      return getFieldDisplayValue(this.currentCase.data, DateEcheance10_FIELD);
   }

   get caseSM_MontantEcheance1(){
      return getFieldValue(this.currentCase.data, MontantEcheance1_FIELD);
   }
     
   get caseSM_MontantEcheance2(){
      return getFieldValue(this.currentCase.data, MontantEcheance2_FIELD);
   }
     
   get caseSM_MontantEcheance3(){
      return getFieldValue(this.currentCase.data, MontantEcheance3_FIELD);
   }
     
   get caseSM_MontantEcheance4(){
      return getFieldValue(this.currentCase.data, MontantEcheance4_FIELD);
   }
     
    get caseSM_MontantEcheance5(){
      return getFieldValue(this.currentCase.data, MontantEcheance5_FIELD);
   }

   get caseSM_MontantEcheance6(){
      return getFieldValue(this.currentCase.data, MontantEcheance6_FIELD);
   }
   
   get caseSM_MontantEcheance7(){
      return getFieldValue(this.currentCase.data, MontantEcheance7_FIELD);
   }

   get caseSM_MontantEcheance8(){
      return getFieldValue(this.currentCase.data, MontantEcheance8_FIELD);
   }

   get caseSM_MontantEcheance9(){
      return getFieldValue(this.currentCase.data, MontantEcheance9_FIELD);
   }

   get caseSM_MontantEcheance10(){
      return getFieldValue(this.currentCase.data, MontantEcheance10_FIELD);
   }

   get caseSM_DLP(){
      return getFieldDisplayValue(this.currentCase.data, DLP_FIELD);
   }
  
   get listDatesEcheances(){
      return [this.caseSM_DateEcheance1, this.caseSM_DateEcheance2, this.caseSM_DateEcheance3, this.caseSM_DateEcheance4, this.caseSM_DateEcheance5, this.caseSM_DateEcheance6, this.caseSM_DateEcheance7, this.caseSM_DateEcheance8, this.caseSM_DateEcheance9, this.caseSM_DateEcheance10];
   }

   get listMontantEcheances(){
      return [this.caseSM_MontantEcheance1, this.caseSM_MontantEcheance2, this.caseSM_MontantEcheance3, this.caseSM_MontantEcheance4, this.caseSM_MontantEcheance5, this.caseSM_MontantEcheance6, this.caseSM_MontantEcheance7, this.caseSM_MontantEcheance8, this.caseSM_MontantEcheance9, this.caseSM_MontantEcheance10];
   }

   // FT2-1587 Construction of the list to display in the table of echeances
   // FT2-1332 added part to get the updated list when simulation is launched or the values are changed
   get listEcheanceDp(){
      var tempListEcheanceDp = [];
      if(this.listEcheanceDpUpdated === undefined ||this.listEcheanceDpUpdated === null){
         for (let i = 0; i < this.caseSM_NbrEcheances; i++){
            tempListEcheanceDp.push({numEcheance: (i +1), dateEcheance: this.listDatesEcheances[i], montantEcheance: this.listMontantEcheances[i]});
         }
      }else{
         tempListEcheanceDp=this.listEcheanceDpUpdated;
      }
      return tempListEcheanceDp;
   }

   // FT2-1587 Variable to get the default value of Nombre d'échéances field
   get is1Selected(){
      return (this.caseSM_NbrEcheances == 1);
   }
   get is2Selected(){
      return (this.caseSM_NbrEcheances == 2);
   }
   get is3Selected(){
      return (this.caseSM_NbrEcheances == 3);
   }
   get is4Selected(){
      return (this.caseSM_NbrEcheances == 4);
   }
   get is5Selected(){
      return (this.caseSM_NbrEcheances == 5);
   }
   get is6Selected(){
      return (this.caseSM_NbrEcheances == 6);
   }
   get is7Selected(){
      return (this.caseSM_NbrEcheances == 7);
   }
   get is8Selected(){
      return (this.caseSM_NbrEcheances == 8);
   }
   get is9Selected(){
      return (this.caseSM_NbrEcheances == 9);
   }
   get is10Selected(){
      return (this.caseSM_NbrEcheances == 10);
   }
   // FT2-1587 Retrieve infos of User
   @wire(getRecord, { recordId: CurrentUserId, fields: [ROLE_NAME_FIELD]}) 
   currentUser;
   set caseSM_DateEcheance1Val(value){
      this.caseSM_DateEcheance1Val= value;
   }
    // FT2-1587 Info: Le superviseur est la personne qui a le rôle responsable d'équipe X
   get isUserSuperviseur(){
      var roleDeveloperName = this.currentUser?.data?.fields?.UserRole?.value?.fields?.DeveloperName?.value;
      return (roleDeveloperName?.includes('Responsable_Equipe'));
   }

   // FT2-1587 RG2 Les conseillers (qui ne sont pas superviseurs) peuvent voir/ouvrir le case mais les éléments du composant seront en lecture seule
   get isUserConseiller(){
      return (!this.isUserSuperviseur);
   }
   // FT2-1332 RG1: Blocking the modified button when the DLP day difference is under 5 days
   get isModifiedDisabled(){
      return (!this.isUserSuperviseur)||(this.isDLP4);
   }
   // FT2-1332 RG1: DP - lorsqu’on ouvre le case de validation après DLP - 5 , on affiche un message d'erreur
   get isDLP4(){
      var RefusDPDate = false;
      var DLPFORMULE = getFieldValue(this.currentCase.data, DLP_Formule__FIELD);
      if(DLPFORMULE!=undefined && DLPFORMULE!=null && DLPFORMULE<5){
         RefusDPDate=true;
         this.fieldsDPdisabled = true;
         this.boutonsDPdisabled = true;
      }
      return RefusDPDate;
   }
   // FT2-1332 Handling changing a value of the list of montantEcheance
   handleEcheanceValueChange(event){
      let newvalue = event.target.value;
      let index = event.target.dataset.index;
      var listEcheanceDptemp = this.listEcheanceDp;
      if(listEcheanceDptemp[index].montantEcheance!=Number(newvalue)){
      listEcheanceDptemp[index].montantEcheance = Number(newvalue);
         this.montantEcheanceModified = true;
      }
      this.listEcheanceDpUpdated = listEcheanceDptemp;
   }
   //FT2-1332 DP - Gestion de la demande de DP par le superviseur cas de validation
   handleApprouver(){
      this.template.querySelector('.errorRaisonRefus').innerHTML='';
      this.dpcreationerrormsg ='';
      var totalEcheanceDP=0;        
      for (var i = 0; i < this.listEcheanceDp.length; i++) {
         totalEcheanceDP+=Number(this.listEcheanceDp[i].montantEcheance);
      }
      totalEcheanceDP= totalEcheanceDP.toFixed(2);
      if(this.caseSM_soldeConcerneDP!=totalEcheanceDP){
         this.errorTotalAmount=true;
      }else{
         this.errorTotalAmount=false;
         var NoCompteContrat = getFieldValue(this.currentCase.data, NOCOMPTECONTRATFIELD);
         var IdBusinessPartner = getFieldValue(this.currentCase.data, IDBPFIELD);
         var lisEchePa= [];
         this.isWaitingWS = true;
         console.log('create plan apurement entered');
         if(this.nombreEcheance===undefined){
            this.nombreEcheance = this.caseSM_NbrEcheances;
         }
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
         callIP({ inputMap: {idPersonne: IdBusinessPartner,idCompteClient: NoCompteContrat,
                  montantGlobal: this.caseSM_soldeConcerneDP,nombreEcheance: this.nombreEcheance,listEcheance: lisEchePa}, NameIntergation: 'IP_SM_CreerPA_MAJPersonne' }).then(result=> {
            console.log('result '+JSON.stringify(result));
            if(result.success === 'true'){
               this.dispatchEvent(
                  ShowToastEvent({
                     title: "Succès",
                     message: 'Le Délai de paiement a bien été mis en place',
                     variant: 'success'
                  })
               );
               this.isWaitingWS = false;
               const fields = {};
               fields[ID_FIELD.fieldApiName] = this.recordId;
               fields[Status_FIELD.fieldApiName] = 'pré-clôturé';
               if(this.montantEcheanceModified){
                  fields[StatusDuDelaiDePaiementFIELD.fieldApiName] = 'VALIDATION du Délai de paiement – avec modification';
               }else{
               fields[StatusDuDelaiDePaiementFIELD.fieldApiName] = 'VALIDATION du Délai de paiement';
               }
               fields[NbrEcheances_FIELD.fieldApiName] = lisEchePa.length;
               if(lisEchePa.length>0){
                  fields[MontantEcheance1_FIELD.fieldApiName] = lisEchePa[0].montantEcheance;
                  fields[DateEcheance1_FIELD.fieldApiName] = lisEchePa[0].dateEcheance;
               }
               if(lisEchePa.length>1){
                  fields[MontantEcheance2_FIELD.fieldApiName] = lisEchePa[1].montantEcheance;
                  fields[DateEcheance2_FIELD.fieldApiName] = lisEchePa[1].dateEcheance;
               }
               if(lisEchePa.length>2){
                  fields[MontantEcheance3_FIELD.fieldApiName] = lisEchePa[2].montantEcheance;
                  fields[DateEcheance3_FIELD.fieldApiName] = lisEchePa[2].dateEcheance;
               }
               if(lisEchePa.length>3){
                  fields[MontantEcheance4_FIELD.fieldApiName] = lisEchePa[3].montantEcheance;
                  fields[DateEcheance4_FIELD.fieldApiName] = lisEchePa[3].dateEcheance;
               }
               if(lisEchePa.length>4){
                  fields[MontantEcheance5_FIELD.fieldApiName] = lisEchePa[4].montantEcheance;
                  fields[DateEcheance5_FIELD.fieldApiName] = lisEchePa[4].dateEcheance;
               }
               if(lisEchePa.length>5){
                  fields[MontantEcheance6_FIELD.fieldApiName] = lisEchePa[5].montantEcheance;
                  fields[DateEcheance6_FIELD.fieldApiName] = lisEchePa[5].dateEcheance;
               }
               if(lisEchePa.length>6){
                  fields[MontantEcheance7_FIELD.fieldApiName] = lisEchePa[6].montantEcheance;
                  fields[DateEcheance7_FIELD.fieldApiName] = lisEchePa[6].dateEcheance;
               }
               if(lisEchePa.length>7){
                  fields[MontantEcheance8_FIELD.fieldApiName] = lisEchePa[7].montantEcheance;
                  fields[DateEcheance8_FIELD.fieldApiName] = lisEchePa[7].dateEcheance;
               }
               if(lisEchePa.length>8){
                  fields[MontantEcheance9_FIELD.fieldApiName] = lisEchePa[8].montantEcheance;
                  fields[DateEcheance9_FIELD.fieldApiName] = lisEchePa[8].dateEcheance;
               }
               if(lisEchePa.length>9){
                  fields[MontantEcheance10_FIELD.fieldApiName] = lisEchePa[9].montantEcheance;
                  fields[DateEcheance10_FIELD.fieldApiName] = lisEchePa[9].dateEcheance;
               }
               const recordInput = { fields };
               updateRecord(recordInput)
               .then(() => { 
                  this.fieldsDPdisabled = true;
                  this.boutonsDPdisabled = true;
               })
               .catch(error => {
                  console.log('Erreur lors de la mise a jour du case après validation du délai de paiement');
                  console.log(error);
               });
            }else{
               this.isWaitingWS = false;
                  this.dpcreationerrormsg = 'Une erreur est survenue lors de la création du Délai de Paiement, celui-ci n’a pas été créé : '+result.error;
            }
         })
         .catch(error => {
               this.isWaitingWS = false;
               console.log(error);
               this.dpcreationerrormsg = 'Une erreur est survenue lors de la création du Délai de Paiement, celui-ci n’a pas été créé';
         });
      }
   }

   // FT2-1587 RG5: à l’ouverture du case, tous les champs sont grisés. Ils se dégrisent au clic sur le bouton Modifier
   handleModifier(){
      if (this.isUserSuperviseur){
         this.fieldsDPdisabled = false;
         this.boutonsDPdisabled = false;
         // FT2-1332 Si la simulation doit être lancé , on grise les boutons
         if(this.errorSimulationNeeded){
            this.boutonsDPdisabled = true;
         }
      }
   }
   // FT2-1332 lancement de simulation de plan d'apurement
   handleSimulatePlanApurement(){
      this.launchSimulatePlanApurement=true;
      this.errorTotalAmount=false;
      this.dpcreationerrormsg ='';
      this.template.querySelector('.errorRaisonRefus').innerHTML='';
      var inputCmp = this.template.querySelector(".dateReferenceId");
      // Si le champ dateEcheanceSimuler est vide (au chargement de la page), on le mets a la date de la premiere échéance
      if(this.dateEcheanceSimuler===undefined||this.dateEcheanceSimuler===null){
         this.dateEcheanceSimuler = this.caseSM_DateEcheance1Val;
      }
      var dateReference = new Date(this.dateEcheanceSimuler);
      dateReference.setDate(dateReference.getDate()-15);
      dateReference=this.formatterDate(dateReference);
      var inputDateReference = dateReference+'T00:00:00';
      //vérifier si un des inputs==vide
      if(this.nombreEcheance===undefined){
         this.nombreEcheance = this.caseSM_NbrEcheances;
      }
      var dateinvalide=false;
      if(this.dateEcheanceSimuler===undefined||this.dateEcheanceSimuler===null||this.checkValidityDatePremierEcheance()===false){
          inputCmp.setCustomValidity("Première échéance invalide.");   
          inputCmp.reportValidity();
          this.launchSimulatePlanApurement=false; 
          dateinvalide = true;
      }else{
          inputCmp.setCustomValidity(""); 
          inputCmp.reportValidity();
          dateinvalide = false;
      }
      if(!dateinvalide){
         this.launchSimulatePlanApurement=true; 
         this.montantEcheanceModified= true;
         this.isLoading=true; 
         console.log("calling IP_SM_simulerPlanApurement_SOAP");         
         callIP({ inputMap: {dateReference:inputDateReference,nombreEcheance:this.nombreEcheance,montantGlobal:this.caseSM_soldeConcerneDP}, NameIntergation: 'IP_SM_simulerPlanApurement_SOAP' }).then(result => {
            if(result.Result.simulerPlanApurementOutput && result.Result.simulerPlanApurementOutput.CodeRetour==='OCTOPUS_SimulerPlanApurement_01'){
               this.boutonsDPdisabled=false;
               this.errorSimulationNeeded=false;
            }else{
               this.dispatchEvent(
                  ShowToastEvent({
                     message: 'Une erreur est survenue lors de la simulation du Délai de Paiement',
                     variant: 'error'
                  })
               );
            }
            // FT2-1332 On rempli la liste d'échéancier retourné par le WS de simulation du plan Apurement
            if(result.Result.simulerPlanApurementOutput.echeance && result.Result.simulerPlanApurementOutput.echeance.length){
               var listEcheanceDptemp = result.Result.simulerPlanApurementOutput.echeance;
               this.listEcheanceDpUpdated = [];
               var tempListEcheanceDp = [];
               var numEcheance = 1;
               for (var echeance in listEcheanceDptemp){
                  tempListEcheanceDp.push({numEcheance: numEcheance, dateEcheance: listEcheanceDptemp[echeance]['dateEcheance'] ,montantEcheance: listEcheanceDptemp[echeance]['montantEcheance']});
                  numEcheance+=1;
               }
               this.nombreEcheance = numEcheance-1;
               this.listEcheanceDpUpdated = tempListEcheanceDp;
            }else{
               var listEcheanceDptemp = [result.Result.simulerPlanApurementOutput.echeance];
               this.listEcheanceDpUpdated = [];
               this.nombreEcheance = 1;
               this.listEcheanceDpUpdated.push({numEcheance: 1, dateEcheance: listEcheanceDptemp[0]['dateEcheance'] ,montantEcheance: listEcheanceDptemp[0]['montantEcheance']});
            }
            this.isLoading=false;               
         }).catch(error => {
            console.log(error);
            this.isLoading=false;               
         });
      }
   }

   //FT2-1332 Vérification des valeurs du nombre d'échéancier/Date d'échancier après un changement
   handleChange(event) {
      const field = event.target.name;
      this.boutonsDPdisabled = true; 
      this.errorSimulationNeeded = true;
      if (field === 'nombreEcheance') {
         this.nombreEcheance = event.target.value;
      } else if (field === 'dateReference') {
         this.dateEcheanceSimuler = event.target.value;
         this.launchSimulatePlanApurement=false; 
         if(this.checkValidityDatePremierEcheance()===false){
            event.target.setCustomValidity("Première échéance invalide.");                
         }else{
            event.target.setCustomValidity(""); 
         }
         event.target.reportValidity();
      }
  }
   // vérifier si la date de la première échéance entre  J+15 et J+30 n'est pas un weekend ni un lundi 
   checkValidityDatePremierEcheance(){
      if(this.formatterDate(this.dateEcheanceSimuler) === this.formatterDate(new Date())
         || (new Date(this.dateEcheanceSimuler)).getDay() === 6 
         || (new Date(this.dateEcheanceSimuler)).getDay() === 0
         || (new Date(this.dateEcheanceSimuler)).getDay() === 1 
         || (new Date(this.dateEcheanceSimuler))< new Date(this.minDate)
         || (new Date(this.dateEcheanceSimuler))> new Date(this.maxDate)
      ){
         return false;
      } else {
         return true;
      }
  }
  
   formatterDate(dateToFormat){
      let vDate= new Date(dateToFormat);
      let dd = String(vDate.getDate()).padStart(2, '0');
      let mm = String(vDate.getMonth()+1).padStart(2, '0'); 
      let yyyy = vDate.getFullYear();        
      return String(yyyy + '-' + mm + '-' + dd);
   }
   handleDeclineReason(event){
      this.declineReason = event.target.value;
   }
   // FT2-1332 Traitement en cas de refus de mise en place de DP
   handleRefuser(){
      this.dpcreationerrormsg ='';
      this.errorTotalAmount=false;
      if(this.declineReason === undefined || this.declineReason === null || this.declineReason === ''){
         this.template.querySelector('.errorRaisonRefus').innerHTML="Merci de remplir le motif.";
      }else{
         this.template.querySelector('.errorRaisonRefus').innerHTML='';
         this.isWaitingWS = true;
      var EmailPrincipalValue = getFieldValue(this.currentCase.data, EmailPrincipalValue_FIELD);
      var ContactName = getFieldValue(this.currentCase.data, ContactName_FIELD);
      var SALUTATION = getFieldValue(this.currentCase.data, SALUTATION_FIELD);
      // FT2-1524 Mise à jour du case avec les données qu'ils faut pour envoyer le mail de refus
      const fields = {};
      fields[ID_FIELD.fieldApiName] = this.recordId;
         fields[StatusDuDelaiDePaiementFIELD.fieldApiName] = 'REFUS du Délai de Paiement';
         fields[Status_FIELD.fieldApiName] = 'pré-clôturé';
         fields[MotifIneligibiliteDelaiPaiementFIELD.fieldApiName] = this.declineReason ;
         //FT2-1736 [UAT] [DP] Mail de refus de DP - Adresse erronée-- Suppression de l'adresse récupéré du contact, afin d'utiliser celle récupéré par le WS - cf: sM_Syn_DP
            if(EmailPrincipalValue != undefined && EmailPrincipalValue != null && EmailPrincipalValue != ''){
      fields[SM_TECH_DelaiPaiementRefuse_FIELD.fieldApiName] = true;
      fields[Vlocity_SendEmail_FIELD.fieldApiName] = true;
      fields[SM_TECH_Nom_FIELD.fieldApiName] = ContactName.toUpperCase();
      fields[SM_TECH_Civilite_FIELD.fieldApiName] = SALUTATION;
      fields[VlocityContactEmail_FIELD.fieldApiName] = EmailPrincipalValue;
         }else{
         // FT2-1332 Envoie d'un SMS si le client ne possède pas une adresse Email valable
            var MobilePrincipalValue = getFieldValue(this.currentCase.data, MobilePrincipalValueFIELD);
               if(MobilePrincipalValue!= undefined && MobilePrincipalValue != null && MobilePrincipalValue != ''){
               MobilePrincipalValue = MobilePrincipalValue.replace(/ /g,'');
               this.callIPSMNotificationSMS({idFormulaireSMS: 'REFUSDELAIPAIEMENT',telephone: MobilePrincipalValue,typologieMarche: 'DGP'}, 'IP_SM_NotificationSMS_SOAP');
                  this.isWaitingWS = false;
            }else{
                  this.isWaitingWS = false;
               this.dispatchEvent(
                  new ShowToastEvent({
                        title: 'Le client n’a pas pu être notifié du refus car pas de mail/tel ou Webservice KO',
                        variant: 'error',
                  })
               );
               return; 
            }
         }
         const recordInput = { fields };
         updateRecord(recordInput)
         .then(() => {         
               this.isWaitingWS = false;
            this.dispatchEvent(
            ShowToastEvent({
               title: "Succès",
               message: 'Le Délai de Paiement est bien refusé et ne sera pas mis en place',
               variant: 'success'
            })
         ); })
         .catch(error => {
               this.isWaitingWS = false;
            console.log('Erreur lors de la mise a jour du case lors du refus DP');
         console.log(error);
      });
   }
}   // FT2- Faire appel à Envoie notification SMS: IP_SM_NotificationSMS_SOAP
   callIPSMNotificationSMS(params, name) {
      console.log("calling IP_SM_NotificationSMS_SOAP");
      callIP({ inputMap: params, NameIntergation: name })
      .then(result => {
         console.log("result :", result);
         if (result) {
            this.showSpinnerLoading = true;
            this.isLoading= false;
            var codeRetour = result.codeRetour;
            if(codeRetour=== 'OCTOPUS_EnvoyerSMS_01'){
               console.log('le SMS a été envoyé avec succès');
            }else{
               this.dispatchEvent(
                  new ShowToastEvent({
                        title: 'Le client n’a pas pu être notifié du refus car pas de mail/tel ou Webservice KO',
                        variant: 'error',
                  })
               );
            }
         }else{
            this.dispatchEvent(
               new ShowToastEvent({
                     title: 'Le client n’a pas pu être notifié du refus car pas de mail/tel ou Webservice KO',
                     variant: 'error',
               })
            );
         }
      })
   }
}