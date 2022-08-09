import { NavigationMixin } from "lightning/navigation";
import { LightningElement, api, track} from 'lwc';
import callFacture from "@salesforce/apex/SM_AP04_FacturesApiService.callFactureLWC";
import callFactureDoc from "@salesforce/apex/SM_AP36_DocumentApiService.callFactureLWC";
import callIP from '@salesforce/apex/SM_AP77_CallIPApiService.callIP'
import noFacture from '@salesforce/label/c.SM_NoFacture';
import factureTitle from '@salesforce/label/c.SM_HistoFactureTitle';
import addressTitle from '@salesforce/label/c.SM_HouseAddress';
import facture from '@salesforce/label/c.SM_Facture';
import toHistoConso from '@salesforce/label/c.SM_ToHistoConso';
import clientDemand from '@salesforce/label/c.SM_ClientDemand';
import codeTypeCalcul06 from '@salesforce/label/c.SM_codeTypeCalcul06';

//Todo externalisé ces paramétres
const constant = {
  
  DeveloperName: "Service",
  SobjectType: "Case" ,
  CaseType: "Paiement", 
  CaseSousType: "Information détail facture",
  CaseStatus: "Pré-clôturé",
  CaseStatusPause:"En traitement",
  CaseSousStatut : "Conforme",
  IPCreateCase: "IP_CreateCaseLWC_Case"

}

export default class SM_ModePaiement extends NavigationMixin(LightningElement) {

    label ={
      noFacture,factureTitle,addressTitle,facture,toHistoConso,clientDemand,codeTypeCalcul06
    };


    @api recordId;
    @api numeroVoie;
    @api ville;
    @api libelleVoie;
    @api complementAdresse;
    @api codePostal;
    @api NoCompteContrat;
    @api NoCompteContratMaj;
    @api IdBusinessPartner;
    @api IdPortefeuilleContrat;
    @api pce;
    @api pdl;
    @api uniteReleveGaz;
    @api uniteReleveElec;
    @api dateReelleProchaineFacture;
    @api dateTechniqueProchaineFacture;
    @api EnqSat;

    //params à envoyer vers Situation Compte
    @api solde;
    @api DLP;
    @api soldeColor;

    @track factures = [];
    @track error = false;
    @track index;
    @track noData = false;
    @track factureLink;
    @track start = 0;
    @track limit = 10;
    @track value = [];
    @track nextDisable = false;
    @track checkedPause;
    @track checkedInteraction;
    @track DRId_Case;
    @api AccountId;

    gotalllinks = false;


    handlePause(event){
      this.checkedPause = event.target.checked;
    }

    handleInteraction(event){
      this.checkedInteraction = event.target.checked;
    }

    get nextDisabled(){
      if(this.nextDisable){
        return true;
      }

      if(this.checkedPause && this.checkedInteraction ){
        return true;
      }
      
      if(!this.checkedPause && !this.checkedInteraction ){
        return true;
      }
      
      return false
    }

    get facturePage(){
      return this.factures.slice(this.start,this.limit);
    }

    get checkLast(){
      if(this.limit < this.factures.length){
        return true;
      }
       
      return false;
    }

    get paginationShow(){
      
      if(this.factures.length > 10){
        return true;
      }

      return false;
    }

  
  closeTab() {
    //console.log("closeTab");
    var close = true;
    
    const closeclickedevt = new CustomEvent('closeclicked', {
        detail: { close },
    });

    // Fire the custom event
    this.dispatchEvent(closeclickedevt);
  }

  navigateToHistoConso(){
    console.log("nav to conso");
    this[NavigationMixin.Navigate]({
        type: 'standard__component',
        attributes: {
            componentName: 'c__SM_Cont_InfoConso'
        },
        state: {
          c__numeroVoie: this.numeroVoie,
          c__libelleVoie: this.libelleVoie,
          c__complementAdresse: this.complementAdresse,
          c__codePostal: this.codePostal,
          c__NoCompteContrat: this.NoCompteContrat,
          c__NoCompteContratMaj: this.NoCompteContratMaj,
          c__ville: this.ville,
          c__recordId: this.recordId,
          c__pce: this.pce,
          c__pdl: this.pdl,
          c__uniteReleveGaz: this.uniteReleveGaz, 
          c__uniteReleveElec: this.uniteReleveElec, 
          c__dateReelleProchaineFacture: this.dateReelleProchaineFacture,
          c__dateTechniqueProchaineFacture: this.dateTechniqueProchaineFacture,
          c__IdBusinessPartner: this.IdBusinessPartner,
          c__IdPortefeuilleContrat: this.IdPortefeuilleContrat
      }
    });
  }

  //Navigation vers Situation de compte
  navigateToSituationCompte(){

    console.log("nav to historique de conso");
    const eventName = 'openSituationCompte';

    const inputMap = {
      IdBusinessPartner: this.IdBusinessPartner,
      IdPortefeuilleContrat: this.IdPortefeuilleContrat,
      numeroVoie:this.numeroVoie,
      ville:this.ville,
      libelleVoie:this.libelleVoie,
      complementAdresse:this.complementAdresse,
      codePostal:this.codePostal,
      NoCompteContratMaj:this.NoCompteContratMaj,
      solde: this.solde,
      DLP:this.DLP,
      soldeColor: this.soldeColor
    };
    
    const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
    this.dispatchEvent(event);
  
  }
  
  //Navigation vers tracer interaction
  navigateToInteraction(){
  
    const eventName = 'openInteraction';
    let inputMap;
    //Params pour interaction
      if(this.checkedInteraction ){
        inputMap = {
          isActivateTracerInteractionOS: true,
          isCasNominal:true,
          isPauseInteraction: false,
          DRId_Case:this.DRId_Case,
          StepNameOS:this.label.factureTitle,
          refClientIdBP:this.idBusinessPartner,
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
          StepNameOS:this.label.factureTitle,
          refClientIdBP:this.idBusinessPartner,
          isLWC:true,
          EnqSat:this.EnqSat
        }

       
       
      }
     
      const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
      this.dispatchEvent(event);
  }


  handleClickPrev(){
    if(this.start !== 0 && this.limit !== 0){
        this.start = this.start - 10;
        this.limit = this.limit - 10;
    }
  }

    handleClickNext(){

      if(this.start <= this.factures.length && this.limit < this.factures.length){
        this.start = this.start + 10;
        this.limit = this.limit + 10;
      }
            
    }

    get showSpinner() {
      return this.DRId_Case || (this.factures && this.factures.length > 0  && this.gotalllinks === true ) || this.noData  || this.error ;
    }

    getFactureLink(){
      console.log(this.label.codeTypeCalcul06);
      let ind = 0;
      for(const item of this.factures){
        item.montantTotal = item.montantTotal.toFixed(2).replace(".",",");
        if(item.codeTypeCalcul === '06'){
          item.typeCalcul = this.label.codeTypeCalcul06;
        }
        item.factureLink = '';
        callFactureDoc({inputMap:{idFacture:item.id}})
        .then(result => {
            //console.log("test call fcature doc api" + result);

          //recuperation des factures
          if(result && result.data) {
            //console.log("facture id " + item.id);
            item.factureLink = result.data[0].url;

          }
         
          ind++;
          if (this.factures.length === ind) this.gotalllinks = true;
         
        })
        .catch(error => {
          this.error = true;
          //console.log("got error callFactureDoc ", name , error);
        });
      }
      
      
    }

    //Create Case et tracage d'interaction
    caseNavigate(){
      this.nextDisable = true;
      //Call IP to create Case and get idBP
      this.noData = false;
      console.log("account id " +this.AccountId);
        
      if(this.checkedInteraction){
        this.callIP({ContextId:this.recordId,AccountId:this.AccountId,DeveloperName:constant.DeveloperName,SobjectType:constant.SobjectType ,CaseType:constant.CaseType,
        CaseSousType:constant.CaseSousType,CaseStatus:constant.CaseStatus,CaseSousStatut:constant.CaseSousStatut},constant.IPCreateCase);
      }
      else if(this.checkedPause){
          this.callIP({ContextId:this.recordId,AccountId:this.AccountId,DeveloperName:constant.DeveloperName,SobjectType:constant.SobjectType ,CaseType:constant.CaseType,
          CaseSousType:constant.CaseSousType,CaseStatus:constant.CaseStatusPause},constant.IPCreateCase);
      }   
       
    }

    callIP(params, name) {
      callIP({ inputMap: params, NameIntergation: name })
        .then(result => {
          if( result ) {
          
              this.noData = result.length > 0 ? false : true;
              this.DRId_Case = result.Case;
              this.idBusinessPartner = result.idBusinessPartner;
              if(this.DRId_Case && this.idBusinessPartner){
                //Go to ROS tracerInteraction
                this.navigateToInteraction();
                this.closeTab();
              }
              else{
                alert("Un problème est survenue lors de la création du Case");
              }
              //console.log(this.DRId_Case);
          } else {
            this.noData = true
          }
        })
        .catch(error => {
          this.error = true;
          console.log("got error callIP", name , error);
        });
    }

    connectedCallback() {
      callFacture({ inputMap: { IdBusinessPartner: this.IdBusinessPartner,IdPortefeuilleContrat:this.IdPortefeuilleContrat, excludeSomeBillsType: true}})
        .then(result => {

          //recuperation des factures
          if(result && result.data) {
            this.noData = result.data.length > 0 ? false : true;
            this.factures = result.data; 
            this.factures.sort(function(a,b){
              let c = new Date(a.dateComptable);
              let d = new Date(b.dateComptable);
              return d-c;
            });
           
            this.getFactureLink();
            
          } else {
            this.noData = true
          }
            
        })
        .catch(error => {
          this.error = true;
          //console.log("got error callFacture ", name , error);
        });

       
        
    }
}