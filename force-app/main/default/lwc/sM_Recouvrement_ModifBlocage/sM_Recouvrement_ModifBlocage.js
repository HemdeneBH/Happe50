import { NavigationMixin } from "lightning/navigation";
import { LightningElement, api, track, wire} from 'lwc';
import { getDataHandler } from "vlocity_cmt/utility";
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";


//FT2-1311 [Suivi coupure] Ouverture écran blocage pour un client bloqué


export default class sM_Recouvrement_ModifBlocage extends OmniscriptBaseMixin(LightningElement) {

    @api typeDeBlocage;
    @api blocageRelance;

    @track error = false;
    @track value = [];
 
    @track openBlocageRelances = false
    @track openBlocageRelancesCNB = false;
    @track openBlocageRelancesCB = false;
    @track openConfirmDeeleteModal = false;
    @track openBlocageRelancesCBModification = false;

    @track error;
    @track values;
    @track data;

    @track dateDebutCNB;
    @track dateDebutCB;
    @track dateFinCNB;
    @track dateFinCB;
    @track dateFinPlaceholderCB;
    @track dateFinConvertedCNB;
    @track dateDebutConvertedCB;
    @track dateFinConvertedCB;
    @track dateFinConvertedCBForModif;
    @track dateMax;
    @track dateMin;
    @track valueMotifCNB;
    @track valueMotifCB;

    @track code;

    @track existingMotifCB;
    @track existingDateFinCB;
    @track existingDateFinCBConverted;

    @track addedWorkDays;

    plagesBlocages = new Map();

    @track motifsOptions = [];
    motifsLoaded = false;
    renderedCallbackcalled = false;

    motifCB = new Map();
    dateDebutConvertedCNB;

    dateFinRequired;

    //Récupération de "NoCompteContrat" et "isBlocageRelance" depuis l'URL


    @track NoCompteContrat='';
    @track isBlocageRelance = '';
    @track isBlocage;
    @wire(CurrentPageReference) currentPageReference; 

    get NoCompteContratFromState(){
        return this.currentPageReference &&
            this.currentPageReference.state.c__NoCompteContrat; 
    }

    get isBlocageRelanceFromState(){
      return this.currentPageReference &&
          this.currentPageReference.state.c__isBlocageRelance; 
   }

    renderedCallback()
    {
      if(this.NoCompteContrat==='')
      {
          this.NoCompteContrat=this.NoCompteContratFromState;
      }
      if(this.isBlocageRelance==='')
      {
          this.isBlocageRelance=this.isBlocageRelanceFromState;
          if (this.isBlocageRelance === 'false') {
            this.isBlocage = false;
          }
          else if (this.isBlocageRelance === 'true') {
            this.isBlocage = true;
          }
      }
      if (this.motifsLoaded === false) {
        this.getMotifs();
        this.getPlagesBlocages();
        this.motifsLoaded = true;
      }
      if (this.renderedCallbackcalled === false) {
        //FT2-1560: CNP - Pré remplissage détails de l'interaction
        //Pré remplissage des détails de l'interaction par défaut
        this.omniApplyCallResp({"blocageedited" : "KO"});
        this.omniApplyCallResp({"nouvfinblocage" : ""});
        this.omniApplyCallResp({"blocagecreated" : "KO"});
        this.omniApplyCallResp({"finblocage" : ""});
        this.omniApplyCallResp({"blocagedeleted" : "KO"});
        this.renderedCallbackcalled = true;
      }
    }


    //AE: FT2-1507 - récupération du mapping Motif et plage de blocage
    //KD: FT2-1758 - Evol technique - Param Motifs et plages des blocages
    getPlagesBlocages(){
      var inputMap = { sObjName: "SM_PlageBlocageParMotif__mdt" , sObjFields : "MasterLabel,DeveloperName,Plagepossible__c,MotifLabel__c,CodeBlocage__c,ParcoursCNP__c,Type__c," };
      let params = {
        type: "apexremote",
        value: {
          className: "SM_Utilities",
          optionsMap: "{}",
          methodName: "getcustomMetadataRecordsForVlocity"
        }
      }
      params.value.inputMap = JSON.stringify(inputMap);
      getDataHandler(JSON.stringify(params)).then(result => {
        let results = JSON.parse(result);
        if(results){
          var plagesBlocagesResult = results.customMetadataRecords;
          plagesBlocagesResult.forEach(plage=>{
            if(plage.ParcoursCNP__c ==true && plage.Type__c == 'Relance'){
              this.plagesBlocages.set(plage.CodeBlocage__c,plage.Plagepossible__c);
            }
            
          });
        }
      }).catch(error => {
          console.log("got error getcustomMetadataRecordsForVlocity" , error);
      });
    }


    //AE: FT2-1542 - Utilisation de l'objet SM_PlageBlocageParMotif__mdt pour récupérer la liste des motifs
    //KD: FT2-1758 - Evol technique - Param Motifs et plages des blocages
    getMotifs(){
      var inputMap = { sObjName: "SM_PlageBlocageParMotif__mdt" , sObjFields : "MasterLabel,DeveloperName,Plagepossible__c,MotifLabel__c,CodeBlocage__c,ParcoursCNP__c,Type__c," };
      let params = {
        type: "apexremote",
        value: {
          className: "SM_Utilities",
          optionsMap: "{}",
          methodName: "getcustomMetadataRecordsForVlocity"
        }
      }
      params.value.inputMap = JSON.stringify(inputMap);
      getDataHandler(JSON.stringify(params)).then(result => {
        let results = JSON.parse(result);
        if(results){ 
          var motifsResult = results.customMetadataRecords;
          this.motifsOptions = [];
          motifsResult.forEach(motif=>{
            if(motif.ParcoursCNP__c ==true && motif.Type__c == 'Relance'){
              this.motifsOptions.push({label: motif.MotifLabel__c, value: motif.CodeBlocage__c});  
            }   
          });

          this.motifsOptions.sort(function(a, b) {
            return a.value.localeCompare(b.value);
         });
        }
      }).catch(error => {
          console.log("got error getcustomMetadataRecordsForVlocity" , error);
      });
    }

  // FT2-1254 Add Working Days 
  addWorkDays(startDate, days) {
    if(isNaN(days)) {
        console.log("Value provided for \"days\" was not a number");
        return
    }
    if(!(startDate instanceof Date)) {
        console.log("Value provided for \"startDate\" was not a Date object");
        return
    }
    // Get the day of the week as a number (0 = Sunday, 1 = Monday, .... 6 = Saturday)
    var dow = startDate.getDay();
    var daysToAdd = parseInt(days);
    // If the current day is Sunday add one day
    if (dow == 0)
        daysToAdd++;
    // If the start date plus the additional days falls on or after the closest Saturday calculate weekends
    if (dow + daysToAdd >= 6) {
        //Subtract days in current working week from work days
        var remainingWorkDays = daysToAdd - (5 - dow);
        //Add current working week's weekend
        daysToAdd += 2;
        if (remainingWorkDays > 5) {
            //Add two days for each working week by calculating how many weeks are included
            daysToAdd += 2 * Math.floor(remainingWorkDays / 5);
            //Exclude final weekend if remainingWorkDays resolves to an exact number of weeks
            if (remainingWorkDays % 5 == 0)
                daysToAdd -= 2;
        }
    }
    startDate.setDate(startDate.getDate() + daysToAdd);
    return startDate;
  }

  //Ouvrir la Modal - En cas d'aucun blocage -> Modal de création de blocage, sinon -> Modal de blocage de client bloqué
  openBlocageDesRelances(){

    if(this.isBlocage === false){
      this.openBlocageRelances = true;
      this.openBlocageRelancesCNB = true;
      this.openBlocageRelancesCB = false; 
      this.openBlocageRelancesCBModification = false;
      let today = new Date();
      this.dateDebutCNB = today.toISOString();
      let temp = this.dateDebutCNB.split("T")[0].split('-');
      this.dateFinPlaceholderCNB =  temp[2] + '/' + temp[1] + '/' + temp[0];

    }else if(this.isBlocage === true){
      this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');
      this.openBlocageRelances = true;
      this.openBlocageRelancesCNB = false;
      this.openBlocageRelancesCB = true;
      this.openBlocageRelancesCBModification = false;

       this.motifsOptions.forEach(motiff=>{
        this.motifCB.set(motiff.label,motiff.value);
      });

    }
  }

  dateDebutHandleChange(event) {
    this.dateDebutCNB = event.target.value;
  }

  dateFinHandleChange(event) {
    this.dateFinCNB = event.target.value;
  }

  //Déterminer la plage date-motif pour l'écran de création de blocage:
  //AE: FT2-1507 - MàJ plage de blocage en fonction des motifs
  motifHandleChange(event) {
    this.valueMotifCNB = event.target.value;
    this.addedWorkDays = this.plagesBlocages.get(this.valueMotifCNB);

    let today = new Date();
    this.dateMax = this.addWorkDays(today, this.addedWorkDays);
    this.dateMax = this.dateMax.toISOString();
  }


  dateDebutCBHandleChange(event) {
    this.dateDebutCB = event.target.value;
  }

  dateFinCBHandleChange(event) {
    this.dateFinCB = event.target.value;

    //FT2-1525 - Gestion des dates dans les formulaires blocage - Correction du bug du champ date de fin mis en évidence même s'il est rempli
    if (this.dateFinCB === undefined || this.dateFinCB == '' || this.dateFinCB === null) {
      this.dateFinRequired = true;
    }
    else {
      this.dateFinRequired = false;
    }

  }

  //Déterminer la plage date-motif pour l'écran de modification de blocage:
  //AE: FT2-1507 - MàJ plage de blocage en fonction des motifs
  motifCBHandleChange(event) {
    this.valueMotifCB = event.target.value;
    this.addedWorkDays = this.plagesBlocages.get(this.valueMotifCB);

    let today = new Date();
    this.dateMax = this.addWorkDays(today, this.addedWorkDays);
    this.dateMax = this.dateMax.toISOString();
  }

  //Création d'un nouveau blocage

  saveBlocageDesRelancesCNB() {
   if((this.dateFinCNB === undefined || this.dateFinCNB === null || this.dateFinCNB === '') && (this.valueMotifCNB === undefined || this.valueMotifCNB === null || this.valueMotifCNB === '')){

    this.template.querySelectorAll('lightning-combobox').forEach(element => {
      element.reportValidity();
    });
    this.template.querySelectorAll('lightning-input').forEach(element => {
      element.reportValidity();
    });  
      const evt = new ShowToastEvent({
          title: "Veuillez remplir tous les champs obligatoires",
          variant: 'error',
      });
      this.dispatchEvent(evt);

    }else if((this.dateFinCNB === undefined || this.dateFinCNB === null || this.dateFinCNB === '') && !(this.valueMotifCNB === undefined || this.valueMotifCB === null || this.valueMotifCNB === '')){
     
      this.template.querySelectorAll('lightning-input').forEach(element => {
        element.reportValidity();
      });

      const evt = new ShowToastEvent({
          title: "Veuillez remplir la date de fin",
          variant: 'error',
      });
      this.dispatchEvent(evt);

    }else if(!(this.dateFinCNB === undefined || this.dateFinCNB === null || this.dateFinCNB === '') && (this.valueMotifCNB === undefined || this.valueMotifCNB === null || this.valueMotifCNB === '')){
      
      this.template.querySelectorAll('lightning-combobox').forEach(element => {
        element.reportValidity();
      });

      const evt = new ShowToastEvent({
          title: "Veuillez remplir le motif",
          variant: 'error',
      });
      this.dispatchEvent(evt);


   }else if(!(this.dateFinCNB === undefined || this.dateFinCNB === null || this.dateFinCNB === '') && !(this.valueMotifCNB === undefined || this.valueMotifCNB === null || this.valueMotifCNB === '') && (this.dateFinCNB < this.dateMax && this.dateFinCNB > this.dateDebutCNB)){


      console.log(this.dateDebutCNB);
      let tempDateDebut = this.dateDebutCNB.split("T")[0].split('-');
      this.dateDebutConvertedCNB =  tempDateDebut[0] + '-' + tempDateDebut[1] + '-' + tempDateDebut[2] + 'T00:00:00';
   
      let temp = this.dateFinCNB.split("-");
      this.dateFinConvertedCNB =  temp[0] + '-' + temp[1] + '-' + temp[2] + 'T00:00:00';

      this.callIPMAJCompteClientSOLIWS({IsModif: "false", CompteClient: this.NoCompteContrat,dateDebutBlocage:this.dateDebutConvertedCNB,dateFinBlocage: this.dateFinConvertedCNB,motifBlocage: this.valueMotifCNB,categorie: "01",actionBlocage: "CREER"}, 'IP_SM_MAJCompteClient_SOLI_WS');
    }  
  
}
  //Fermeture de la Modal de création de blocage
  closeBlocageDesRelancesCNB() {
      this.dateFinCNB = '';
      this.valueMotifCNB = ''; 
      this.openBlocageRelances = false;
      this.openBlocageRelancesCNB = false;
  } 


  //Fermeture de la Modal de modification de blocage

  closeBlocageDesRelancesCB(){
    this.openBlocageRelances = false;
    this.openBlocageRelancesCB = false;
    this.openBlocageRelancesCNB = false;
  }


  //Ouverture de la Modal de confirmation de suppression

  deleteBlocageDesRelancesCB(){
    this.openConfirmDeeleteModal = true;
  }


      //FT2-1313 -> MÃ©thode permettant d'appeler l'IP de modification d'un blocage d'un blocage
      callIPMAJCompteClientSOLIWSModification(parameters, name) {
        let datasourcedef = JSON.stringify({
          "type": "integrationprocedure",
          "value": {
              "ipMethod": name,
              "inputMap": parameters,
          }
        });
        getDataHandler(datasourcedef).then(IPResult => {
  
          if(IPResult) {
            let result = JSON.parse(IPResult);
            if (result.IPResult.MAJCompteClient) {
            this.code = result.IPResult.MAJCompteClient.code; 
            if(this.code === "OCTOPUS_MAJCompteClient_01"){
              const evt = new ShowToastEvent({

                title: "La modification du blocage a bien été faite",

                variant: 'success',
              });
              this.dispatchEvent(evt);

              //FT2-1560: CNP - Pré remplissage détails de l'interaction
              //Pré remplissage des détails de modification de blocage
              this.omniApplyCallResp({"blocageedited" : "OK"});
              let newDateFin = this.dateFinConvertedCBForModif.substring(0,10);
              let temp = newDateFin.split("-");
              newDateFin =  temp[2] + '/' + temp[1] + '/' + temp[0];
              this.omniApplyCallResp({"nouvfinblocage" : newDateFin});
              this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');

              this.openBlocageRelancesCBModification = false;
              this.openBlocageRelancesCB = true;
            }  
            else{
              const evt = new ShowToastEvent({

                title: "Un problème technique est survenu et la modification n'a pas pu se faire",

                variant: 'error',
              });
              this.dispatchEvent(evt);
  
              this.isBlocage = false;
              this.typeDeBlocage = '';      
            }             
        }
      }
        }).catch(error => {
          console.log("failed at getting IP data => " + error);
        });
        
      }

  // AS: FT2-1313 -> Gestion de bouton enregistrer de la modification d'un blocage 

  // AE: FT2-1507 - MàJ plage de blocage en fonction des motifs
  updateBlocageDesRelancesCB() {
    this.addedWorkDays = this.plagesBlocages.get(this.valueMotifCB);

    let today = new Date();
    this.dateMax = this.addWorkDays(today, this.addedWorkDays);
    this.dateMax = this.dateMax.toISOString();

    if (!(this.dateFinCB === undefined || this.dateFinCB === null) && !(this.valueMotifCB === undefined || this.valueMotifCB === null)) {

      if (this.dateFinCB.includes("/")) {
        let tempFin = this.dateFinCB.split("/");
        this.dateFinConvertedCB =  tempFin[0] + '-' + tempFin[1] + '-' + tempFin[2] + 'T00:00:00';
      }
      else if (this.dateFinCB.includes("-")) {
        let tempFin = this.dateFinCB.split("-");
        this.dateFinConvertedCB =  tempFin[0] + '-' + tempFin[1] + '-' + tempFin[2] + 'T00:00:00';
      }
    }

    if((this.dateFinCB === undefined || this.dateFinCB === null) && (this.valueMotifCB === undefined || this.valueMotifCB === null)){

      this.template.querySelectorAll('lightning-combobox').forEach(element => {
        element.reportValidity();
      });
      this.template.querySelectorAll('lightning-input').forEach(element => {
        element.reportValidity();
      });
      const evt = new ShowToastEvent({
          title: "Veuillez remplir tous les champs obligatoires",
          variant: 'error',
      });
      this.dispatchEvent(evt);


    }else if((this.dateFinCB === undefined || this.dateFinCB === null) && !(this.valueMotifCB === undefined || this.valueMotifCB === null)){
      this.template.querySelectorAll('lightning-input').forEach(element => {
        element.reportValidity();
      });
      const evt = new ShowToastEvent({
          title: "Veuillez remplir la date de fin",
          variant: 'error',
      });
      this.dispatchEvent(evt);

    }else if(!(this.dateFinCB === undefined || this.dateFinCB === null) && (this.valueMotifCB === undefined || this.valueMotifCB === null)){
      this.template.querySelectorAll('lightning-combobox').forEach(element => {
        element.reportValidity();
      });
      const evt = new ShowToastEvent({
          title: "Veuillez remplir le motif",
          variant: 'error',
      });
      this.dispatchEvent(evt);

    }else if( (this.dateFinConvertedCB < this.dateMax && this.dateFinConvertedCB > this.dateDebutConvertedCB)){

      if (this.dateFinCB.includes("/")) {
        let temp = this.dateFinCB.split("/");
        this.dateFinConvertedCBForModif =  temp[0] + '-' + temp[1] + '-' + temp[2] + 'T00:00:00';
      } else if (this.dateFinCB.includes("-")) {
        let temp = this.dateFinCB.split("-");
        this.dateFinConvertedCBForModif =  temp[0] + '-' + temp[1] + '-' + temp[2] + 'T00:00:00';
      }
      
      if (this.existingDateFinCB.includes("/")) {
        let tempExistingDateFin = this.existingDateFinCB.split("/");
        this.existingDateFinCBConverted =  tempExistingDateFin[0] + '-' + tempExistingDateFin[1] + '-' + tempExistingDateFin[2] + 'T00:00:00';
      } else if (this.existingDateFinCB.includes("-")) {
        let tempExistingDateFin = this.existingDateFinCB.split("-");
        this.existingDateFinCBConverted =  tempExistingDateFin[0] + '-' + tempExistingDateFin[1] + '-' + tempExistingDateFin[2] + 'T00:00:00';
      }

      if (this.valueMotifCB.length > 1) {
        this.valueMotifCB = this.motifCB.get(this.valueMotifCB);
      }

      this.callIPMAJCompteClientSOLIWSModification({IsModif: "true", CompteClient: this.NoCompteContrat, dateDebutBlocageSupprimer: this.dateDebutConvertedCB, dateFinBlocageSupprimer: this.existingDateFinCBConverted, motifBlocageSupprimer: this.existingMotifCB, categorieSupprimer: "01", actionBlocageSupprimer: "SUPPRIMER",
      dateDebutBlocageCreer: this.dateDebutConvertedCB, dateFinBlocageCreer: this.dateFinConvertedCBForModif, motifBlocageCreer: this.valueMotifCB, categorieCreer: "01", actionBlocageCreer: "CREER",}, 'IP_SM_MAJCompteClient_SOLI_WS');
    } 
  }

  //FT-1340 Modification formulaire client bloquÃ©

  modifyBlocageDesRelancesCB(){
    this.dateFinRequired = false;//FT2-1525 - Gestion des dates dans les formulaires blocage - Correction du bug de la date max infinie au cas où le motif n'est pas modifié	
    this.openConfirmDeeleteModal = false;
    this.openBlocageRelancesCBModification = true;
    this.openBlocageRelancesCB = false;
    this.openBlocageRelancesCNB = false;
    this.existingDateFinCB = this.dateFinCB;

    this.motifsOptions.forEach(motiff=>{
      this.motifCB.set(motiff.label,motiff.value);
    });
    this.valueMotifCB = this.motifCB.get(this.valueMotifCB);

    let todayDebut = new Date();
    this.dateMin = todayDebut.toISOString();
 
    //FT2-1525 - Gestion des dates dans les formulaires blocage - Correction du bug de la date max infinie au cas où le motif n'est pas modifié	
    if (this.existingMotifCB != undefined) {	
      this.addedWorkDays = this.plagesBlocages.get(this.existingMotifCB);	
      let today = new Date();	
      this.dateMax = this.addWorkDays(today, this.addedWorkDays);	
      this.dateMax = this.dateMax.toISOString();	
    }                                     
 

    let tempDebut = this.dateDebutCB.split("/");
    this.dateDebutConvertedCB =  tempDebut[0] + '-' + tempDebut[1] + '-' + tempDebut[2] + 'T00:00:00';
  }

  //Annulation Modification formulaire client bloqué

  closeBlocageDesRelancesCBModification(){

    this.dateFinRequired = false;

    this.openBlocageRelancesCBModification = false;
    this.openBlocageRelancesCNB = false;
    this.openBlocageRelancesCB = true;
    if (this.existingMotifCB != undefined) {
      this.valueMotifCB = this.existingMotifCB;
    }
    this.dateFinCB = this.existingDateFinCB;
    this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');
  }

  //Méthode à éxecuter au cas de la confirmation de suppression:
  yesDeleteBlocageDesRelancesCB(){
    let tempDateDebut = this.dateDebutCB.split("/");
    this.dateDebutConvertedCB =  tempDateDebut[0] + '-' + tempDateDebut[1] + '-' + tempDateDebut[2] + 'T00:00:00';
    let temp = this.dateFinCB.split("/");
    this.dateFinConvertedCB =  temp[0] + '-' + temp[1] + '-' + temp[2] + 'T00:00:00';

    let motifSupp;
    motifSupp = this.motifCB.get(this.valueMotifCB);

    this.callIPMAJCompteClientSOLIDeleteWS({IsModif: "false", CompteClient: this.NoCompteContrat,dateDebutBlocage:this.dateDebutConvertedCB,dateFinBlocage: this.dateFinConvertedCB, categorie: "01",motifBlocage: motifSupp,actionBlocage: "SUPPRIMER"}, 'IP_SM_MAJCompteClient_SOLI_WS');
    this.openConfirmDeeleteModal = false;
    this.openBlocageRelances = true;
    this.openBlocageRelancesCB = true;
    this.openBlocageRelancesCNB = false;
  }

  //Méthode à éxecuter au cas d'annulation de suppression:

  noDeleteBlocageDesRelancesCB(){
    this.openConfirmDeeleteModal = false;
    this.openBlocageRelances = true;
    this.openBlocageRelancesCB = true;
    this.openBlocageRelancesCNB = false;  
  }

    //Méthode permettant d'appeler l'IP de récupération des informations du compte client

    callIPLireCompteClient(parameters, name) {
      let datasourcedef = JSON.stringify({
        "type": "integrationprocedure",
        "value": {
            "ipMethod": name,
            "inputMap": parameters,
        }
      });
      console.log("datasourcedef: " + datasourcedef);
      getDataHandler(datasourcedef).then(IPResult => {
        if(IPResult) {     
          let result = JSON.parse(IPResult);
          let tempDateDebutCB = result.IPResult.FirstBlocage.dateDebutBlocage.split("T")[0].split('-');
          let tempDateFinCB = result.IPResult.FirstBlocage.dateFinBlocage.split("T")[0].split('-');
          this.dateDebutCB = tempDateDebutCB[0] + '/' + tempDateDebutCB[1] + '/' + tempDateDebutCB[2];
          this.dateFinCB = tempDateFinCB[0] + '/' + tempDateFinCB[1] + '/' + tempDateFinCB[2];
          this.valueMotifCB = result.IPResult.FirstBlocage.motifBlocage.libelleCourt;

          this.isBlocage = true;

          this.isBlocageRelance = "true";
          this.typeDeBlocage = result.IPResult.FirstBlocage.motifBlocage.libelleCourt;
          console.log(this.typeDeBlocage);
        }
      }).catch(error => {
        console.log("failed at getting IP data => " + error);
      });
      
    }




    //Méthode permettant d'appeler l'IP de création d'un blocage

    callIPMAJCompteClientSOLIWS(parameters, name) {
      let datasourcedef = JSON.stringify({
        "type": "integrationprocedure",
        "value": {
            "ipMethod": name,
            "inputMap": parameters,
        }
      });
      getDataHandler(datasourcedef).then(IPResult => {

        if(IPResult) {
          let result = JSON.parse(IPResult);
          if (result.IPResult.MAJCompteClient) {
          this.code = result.IPResult.MAJCompteClient.code; 
          if(this.code === "OCTOPUS_MAJCompteClient_01"){
            const evt = new ShowToastEvent({

              title: "La création du blocage a bien été faite",

              variant: 'success',
            });
            this.dispatchEvent(evt);

            //FT2-1560: CNP - Pré remplissage détails de l'interaction
            //Pré remplissage des détails de création de blocage
            this.omniApplyCallResp({"blocagecreated" : "OK"});
            let dateFin = this.dateFinConvertedCNB.substring(0,10);
            let temp = dateFin.split("-");
            dateFin =  temp[2] + '/' + temp[1] + '/' + temp[0];
            this.omniApplyCallResp({"finblocage" : dateFin});
            this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');

            this.openBlocageRelances = true;
            this.openBlocageRelancesCNB = false;
            this.openBlocageRelancesCB = true;
          }  
          else{
            const evt = new ShowToastEvent({

              title: "Un problème technique est survenu et la création n’a pu se faire",

              variant: 'error',
            });
            this.dispatchEvent(evt);

            this.isBlocage = false;
            this.typeDeBlocage = '';      
          }             
      }
    }
      }).catch(error => {
        console.log("failed at getting IP data => " + error);
      });
      
    }


    //Méthode permettant d'appeler l'IP de suppression d'un blocage



    callIPMAJCompteClientSOLIDeleteWS(parameters, name) {
      let datasourcedef = JSON.stringify({
        "type": "integrationprocedure",
        "value": {
            "ipMethod": name,
            "inputMap": parameters,
        }
      });
      console.log("datasourcedef: " + datasourcedef);
      getDataHandler(datasourcedef).then(IPResult => {

        if(IPResult) {
          let result = JSON.parse(IPResult);
          if (result.IPResult.MAJCompteClient) {
          this.code = result.IPResult.MAJCompteClient.code; 
          if(this.code === "OCTOPUS_MAJCompteClient_01"){
            const evt = new ShowToastEvent({

              title: "Blocage supprimé avec succès",

              variant: 'success',
            });
            this.dispatchEvent(evt);
            
            //FT2-1560: CNP - Pré remplissage détails de l'interaction
            //Pré remplissage des détails de suppression de blocage
            this.omniApplyCallResp({"blocagedeleted" : "OK"});

            this.isBlocage = false;
            this.openBlocageDesRelances();
            this.typeDeBlocage = '';
            this.dateFinCNB = '';
            this.valueMotifCNB = '';
            let today = new Date();
            this.dateDebutCNB = today.toISOString();
          }  
          else{
            const evt = new ShowToastEvent({

              title: "Une erreur technique est survenue, la suppression du blocage n’a pas été faite",

              variant: 'error',
            });
            this.dispatchEvent(evt);           
          }             
      }
    }
      }).catch(error => {
        console.log("failed at getting IP data => " + error);
      });
      
    }
}