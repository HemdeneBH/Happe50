/**
 *@description       : Tableau qui affiche la liste des blocages
  @author            : KD
  @group             : FT2
  @last modified on  : 26-05-2022
  @last modified by  : HBO
*/

import { LightningElement, api, track, wire} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { CurrentPageReference } from 'lightning/navigation';
import { getDataHandler } from "vlocity_cmt/utility";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SM_vlocity_SyntheseBlocageTableau extends OmniscriptBaseMixin(LightningElement)  {
 
  @wire(CurrentPageReference) currentPageReference;
  @track isModalOpenBlocage=false;

  @track plagesBlocage = new Map();
  @track motifsBlocageOptions = [];
  @track motifCB = new Map();
  @track dateMax;
  @track dateMin;
  @track isOpenDecaissement = false;
  @track isOpenFacture = false;
  @track isOpenPrelevement = false;
  @track isOpenRelance = false;

  @track modifySuppBlocage;
  @track isModifSuppOpen;
  @track isCreate;
  @track isModifOpen;
  @track valueMotif;
  @track valueMotifCB;
  @track dateFinValue;

  @track listeBlocagesUpdated = [];
  @track listeBlocagesInitiale =  new Map();
  @track showSpinnerLoading = false; // variable pour afficher le spinner dans la vue principale
  @track openConfirmDeeleteModal = false;
  @track dateFinCB;
  @track dateDebutCB;
  @track isSupp = false;
  @track existingMotifCB;
  @track existingDateFinCB;
  @track existingDateFinCBConverted;
  @track dateFinPlaceholderCB;
  @track addedWorkDays;
  dateFinRequired;
  @track dateDebutConvertedCB;
  @track dateFinConvertedCB;
  @track dateFinConvertedCBForModif;

  @api listSyntheseBlocage;
  @api blocageRelance;
  @api blocageFacture;
  @api blocagePrelevement;
  @api blocageDecaissement;
  @api noCompteContrat;
  @api 
  tableData = [];

  @track callbackCalled = false;

  theme = "slds";
  @api sizeTab = 0;
    //Initialisation des colonnes à afficher dans le tableau
    columns = [{
        "fieldName": "type",
        "label": "TYPE DE BLOCAGE",
        "searchable": false,
        "sortable": true,
        "type": "text",
        "editable": "false",
        "userSelectable": "false",
        "visible": "true"
        },
        {
        "fieldName": "dateDebut",
        "label": "DATE DE DÉBUT",
        "searchable": false,
        "sortable": true,
        "type": "date",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
        "fieldName": "dateFin",
        "label": "DATE DE FIN",
        "searchable": false,
        "sortable": true,
        "type": "date",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
          "fieldName": "motif",
          "label": "MOTIF",
          "searchable": false,
          "sortable": true,
          "type": "text",
          "editable": "false",
          "userSelectable": "true",
          "visible": "true"
        },
        { //FT2-1618 -Bouton permettant d'ouvrir la popup de Modification/Suppression du blocage
          "fieldName": "modifSuppBlocage",
          "label": "",
          "searchable": false,
          "sortable": true,
          "type": "url",
          "editable": "false",
          "userSelectable": "true",
          "visible": "true"
        }
    ];
    
    renderedCallback(){

      if (this.callbackCalled === false) {
        this.showSpinnerLoading = true;
        this.callIPLireCompteClient({CompteClient: this.noCompteContrat}, 'IP_SM_CompteClient_Solde');
        if(this.listeBlocagesUpdated.length == 0){
          if(this.isSupp == false){
          this.listeBlocagesUpdated = this.listSyntheseBlocage;
          }
          this.callbackCalled = true;
        }
    }

  }

    //FT2-1618 -externalisation du traitement de mise à jour des boolean permettant d'afficher le bon titre de la popup
    getPopupData(type){

      if(type == 'Relance')
      {
        this.isOpenRelance = true;
        this.categorieValue = "01";
      }
      else if(type == 'Facture' || type == 'Facturation')
      {
        this.isOpenFacture = true;
        this.categorieValue = "05";
      }
      else if(type == 'Decaissement')
      {
        this.isOpenDecaissement = true;
        this.categorieValue = "03";
      }
      else if(type == 'Prelevement' || type == 'Encaissement')
      {
        this.isOpenPrelevement = true;
        this.categorieValue = "02";
      }
      this.getPlagesMotifsBlocages(type);
    
  }
    
    // When the user clicks on Save, open the popup
    handleAction(e) {
      this.isModalOpenBlocage=true;
      this.isCreate=true;
      var typeOfBlocage = e.currentTarget.dataset.typeblocage;

      //FT2-1618 - mise à jour des boolean permettant d'afficher le bon titre de la popup
      if(typeOfBlocage!=undefined){
        this.getPopupData(typeOfBlocage);
      }

      //FT2-1608 - Date de début du Blocage
      let today = new Date();
      this.dateMin = today.toISOString();
    }

    closeBlocageModal(){
      this.isModalOpenBlocage=false;
      this.isModifSuppOpen=false;
      
      //FT2-1608 - mise à jour des boolean permettant d'afficher le bon titre de la popup
      this.isOpenDecaissement=false;
      this.isOpenFacture=false;
      this.isOpenPrelevement=false;
      this.isOpenRelance=false;
      this.openConfirmDeeleteModal = false;
      this.openConfirmDeeleteModal = false;

      //FT2-1608 - vider les champs à la fermeture de la popup
      this.valueMotif = '';
    }

    closeBlocageCBModification(){
      this.dateFinRequired = false;
      this.isModifSuppOpen=true;
  
      if(this.existingMotifCB != undefined) {
        this.valueMotifCB = this.existingMotifCB;
      }
      this.dateFinCB = this.existingDateFinCB;
      this.callIPLireCompteClient({CompteClient: this.noCompteContrat}, 'IP_SM_CompteClient_Solde');
    }
    //US FT2-1624 ENDS HERE

    //FT2-1608 - récupération du mapping Motif et plage de blocage en fonction du parcours et du type de blocage
    
    getPlagesMotifsBlocages(typeblocage){
      var inputMap = { sObjName: "SM_PlageBlocageParMotif__mdt" , sObjFields : "MasterLabel,DeveloperName,Plagepossible__c,CodeBlocage__c,ParcoursBlocages__c,Type__c,MotifLabel__c," };
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
        this.motifsBlocageOptions = [];
        let results = JSON.parse(result);
        if(results){

          var plagesAndMotifsResult = results.customMetadataRecords;
          plagesAndMotifsResult.forEach(plageAndMotif=>{
           
            if(plageAndMotif.ParcoursBlocages__c === true && plageAndMotif.Type__c == typeblocage){

              this.plagesBlocage.set(plageAndMotif.CodeBlocage__c, plageAndMotif.Plagepossible__c);
              this.motifsBlocageOptions.push({label: plageAndMotif.MotifLabel__c, value: plageAndMotif.CodeBlocage__c});
            }
          });
        }
      }).catch(error => {
      });
    }

    //FT2-1608 - Méthode permettant d'ajouter un nombre jours ouvrables à une date de début 
    addWorkDays(startDate, days) {
      if(isNaN(days)) {
          return
      }
      if(!(startDate instanceof Date)) {
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

    //FT2-1608 - Au clic sur un motif ,on calcule la date de fin correspondante à la plage
    motifHandleChange(event) {
      this.valueMotif = event.target.value;
      var addedWorkDays;
      if(this.valueMotif!=undefined){
        addedWorkDays  = this.plagesBlocage.get(this.valueMotif);
        let today = new Date();
        this.dateMax = this.addWorkDays(today, addedWorkDays);
        this.dateMax = this.dateMax.toISOString();
      }   
    }

    //Déterminer la plage date-motif pour l'écran de modification de blocage:
    motifCBHandleChange(event) {
      this.valueMotifCB = event.target.value;

      //var addedWorkDays;
      if(this.valueMotifCB!=undefined){
        this.addedWorkDays = this.plagesBlocage.get(this.valueMotifCB);
        let today = new Date();
        this.dateMax = this.addWorkDays(today, this.addedWorkDays);
        this.dateMax = this.dateMax.toISOString();
      }   
    }
    //FT2-1608 - Au clic sur une date on récupère la bonne valeur
    dateFinHandleChange(event) {
      this.dateFinValue = event.target.value;
    }
     
    dateDebutCBHandleChange(event){
      this.dateDebutCB = event.target.value;
    }

    dateFinCBHandleChange(event){
      this.dateFinCB = event.target.value;
      if(this.dateFinCB === undefined || this.dateFinCB == '' || this.dateFin === null){
        this.dateFinRequired = true;
      } else{
        this.dateFinRequired = false;
      }
    }

    //FT2-1618 - Au clic sur le crayon on ouvre la popup de Modification/Suppression du blocage 
    handleModifySuppBlocage(event){
      this.modifySuppBlocageOK = event.detail;

      if(this.modifySuppBlocageOK === true){
        this.isModalOpenBlocage = true;
      }
    }

    //FT2-1618 - Au clic sur le crayon on récupère les informations de la ligne du tableau
    handleRowData(event){
      this.rowData = event.detail;
      var typeOfBlocage;
      typeOfBlocage = this.rowData.type;
      let tempDateDebut = this.rowData.dateDebut.split("-");
      this.dateDebutCB =  tempDateDebut[0] + '/' + tempDateDebut[1] + '/' + tempDateDebut[2]; 
      let tempDatefin = this.rowData.dateFin.split("-");
      this.dateFinCB =  tempDatefin[0] + '/' + tempDatefin[1] + '/' + tempDatefin[2];
      this.valueMotifCB = this.rowData.motif;
      if(typeOfBlocage!=undefined){
        this.getPopupData(typeOfBlocage);
        this.isModifSuppOpen = true;
      }
    }
     
    //FT2-1609 Enregistrement du blocage créé 
    createBlocage() {

      //ensure that the required fields are filled in
      if((this.dateFinValue === undefined || this.dateFinValue === null || this.dateFinValue === '') && (this.valueMotif === undefined || this.valueMotif === null || this.valueMotif === '')){

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


      }else if((this.dateFinValue === undefined || this.dateFinValue === null || this.dateFinValue === '') && !(this.valueMotif === undefined || this.valueMotif === null || this.valueMotif === '')){
        
        this.template.querySelectorAll('lightning-input').forEach(element => {
          element.reportValidity();
        });
        const evt = new ShowToastEvent({
            title: "Veuillez remplir la date de fin",
            variant: 'error',
        });
        this.dispatchEvent(evt);

      }else if(!(this.dateFinValue === undefined || this.dateFinValue === null || this.dateFinValue === '') && (this.valueMotif === undefined || this.valueMotif === null || this.valueMotif === '')){
        
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
          element.reportValidity();
        });
        const evt = new ShowToastEvent({
            title: "Veuillez remplir le motif",
            variant: 'error',
        });
        this.dispatchEvent(evt);

      }else if(!(this.dateFinValue === undefined || this.dateFinValue === null || this.dateFinValue === '') && !(this.valueMotif === undefined || this.valueMotif === null || this.valueMotif === '') && (this.dateFinValue < this.dateMax && this.dateFinValue > this.dateMin)){


        let tempDateDebut = this.dateMin.split("T")[0].split('-');
        this.dateDebutConvertedCNB =  tempDateDebut[0] + '-' + tempDateDebut[1] + '-' + tempDateDebut[2] + 'T00:00:00';
      
        let temp = this.dateFinValue.split("-");
        this.dateFinConvertedCNB =  temp[0] + '-' + temp[1] + '-' + temp[2] + 'T00:00:00';
        this.callIPMAJCompteClientSOLIWS({IsModif: "false", CompteClient: this.noCompteContrat,dateDebutBlocage:this.dateDebutConvertedCNB,dateFinBlocage: this.dateFinConvertedCNB,motifBlocage: this.valueMotif,categorie: this.categorieValue,actionBlocage: "CREER"}, 'IP_SM_MAJCompteClient_SOLI_WS');
      }  
  
    }

    //FT2-1609 Méthode permettant d'appeler l'IP de création d'un blocage

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
            if(parameters.actionBlocage == "CREER"){
            const evt = new ShowToastEvent({
              title: "La création du blocage a bien été faite",
              variant: 'success',
            });
            this.dispatchEvent(evt);
          
            }
            else if(parameters.actionBlocage == "SUPPRIMER"){

              const evt = new ShowToastEvent({

                title: "Blocage supprimé avec succès",
  
                variant: 'success',
              });
              this.dispatchEvent(evt);
              // FT2-1849 Manage the refresh of data and spinner only with this.showSpinnerLoading
              // eval("$A.get('e.force:refreshView').fire();");

            }
            // FT2-1849 :  this.showSpinnerLoading is set to true in method yesDeleteBlocage
            // this.showSpinnerLoading = true;
            this.closeBlocageModal();

            this.callIPLireCompteClient({CompteClient: this.noCompteContrat}, 'IP_SM_CompteClient_Solde'); 
          }  
          else{
            if(parameters.actionBlocage == "CREER"){
              const evt = new ShowToastEvent({

                title: "Un problème technique est survenu et la création n’a pu se faire",

                variant: 'error',
              });
              this.dispatchEvent(evt);

            }
            else if(parameters.actionBlocage == "SUPPRIMER"){
              
              const evt = new ShowToastEvent({

                title: "Un problème technique est survenu et la suppression n’a pas été faite",

                variant: 'error',
              });
              this.dispatchEvent(evt);
            }
            this.closeBlocageModal();      
          }             
      }
    }
      }).catch(error => {
        console.log("failed at getting IP data => " + error);
      }).finally(() => {
        // FT2-1849
        this.showSpinnerLoading = false;
      });  
    }

    //FT2-1609 Méthode permettant de mettre à jour les informations du blocage
    callIPLireCompteClient(parameters, name) {
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

          // FT2-1849 à l'initialisation du traitement, qu'il y ait des blocages retournés ou pas, vider variable this.listeBlocagesUpdated et débloquer les boutons prélèvement, décaissement, facture et relance
          // les variables seront mises à jour si le WS retourne des blocages
            this.blocagePrelevement = false;
            this.blocageDecaissement = false;
            this.blocageFacture = false;
            this.blocageRelance = false;
            this.listeBlocagesUpdated = [];

          if(!result.IPResult.LireCompteClientReturn.blocages){
            this.showSpinnerLoading = false;
          }

          if(result.IPResult.LireCompteClientReturn.blocages){

          this.listeBlocagesInitiale = result.IPResult.LireCompteClientReturn.blocages;         
          if (Array.isArray(this.listeBlocagesInitiale)) {
            
            this.listeBlocagesInitiale.forEach(blocage=>{

            let categorieBlocage = '';
            let dateDebutconverted;
            let dateFinconverted;

            let tempDateDebut = blocage.dateDebutBlocage.split("T")[0].split('-');            
            dateDebutconverted =  tempDateDebut[0]+ '-' + tempDateDebut[1] + '-' + tempDateDebut[2];

            let tempDateFin = blocage.dateFinBlocage.split("T")[0].split('-');            
            dateFinconverted =  tempDateFin[0]+ '-' + tempDateFin[1] + '-' + tempDateFin[2];

            let today = new Date();
            today = today.toISOString();
            let tempDate;
            tempDate = today.split("T")[0].split('-');
            let todayconverted;
            todayconverted =  tempDate[0]+ '-' + tempDate[1] + '-' + tempDate[2];

            if (dateFinconverted >= todayconverted){
              if(blocage.categorie === '01'){
                categorieBlocage = 'Relance';
                this.blocageRelance = true;
              }
              else if(blocage.categorie === '05'){
                categorieBlocage = 'Facturation';
                this.blocageFacture = true;
              }
              else if(blocage.categorie === '03'){
                categorieBlocage = 'Decaissement';
                this.blocageDecaissement = true;
              }
              else if(blocage.categorie === '02'){
                categorieBlocage = 'Encaissement';
                this.blocagePrelevement = true;
              }

              this.listeBlocagesUpdated.push({type: categorieBlocage, motif: blocage.motifBlocage.libelleCourt, dateDebut: dateDebutconverted, dateFin: dateFinconverted });
            }
          });
          this.showSpinnerLoading = false; 
        }
          }
        }
          else{
            this.isSupp = true
            this.listeBlocagesUpdated.splice(0,this.listeBlocagesUpdated.length);
            this.showSpinnerLoading = false; 
          }         
        
      }).catch(error => {
        this.showSpinnerLoading = false; 
        console.log("failed at getting IP data => " + error);
      }).finally(() => {
        // FT2-1849
        this.showSpinnerLoading = false;
      }); 
    }

     
    //FT2-1619 Ouverture de la popup permettant de confirmer le suppression
    deleteBlocageConfirmModal(){
      this.openConfirmDeeleteModal = true;
    }

    //FT2-1619 suppression du blocage
    yesDeleteBlocage(){
      // FT2-1849
      this.showSpinnerLoading = true;

      let tempDateDebut = this.dateDebutCB.split("/");
      this.dateDebutConvertedCB =  tempDateDebut[0] + '-' + tempDateDebut[1] + '-' + tempDateDebut[2] + 'T00:00:00.0';
      
      let tempDateFin = this.dateFinCB.split("/");
      this.dateFinConvertedCB =  tempDateFin[0] + '-' + tempDateFin[1] + '-' + tempDateFin[2] + 'T00:00:00.0';

     //let motifCB = new Map();
      this.motifsBlocageOptions.forEach(motif=>{
        this.motifCB.set(motif.label,motif.value);
      });
      let motifSupp;
      motifSupp = this.motifCB.get(this.valueMotifCB);
      this.callIPMAJCompteClientSOLIWS({IsModif: "false", CompteClient: this.noCompteContrat,dateDebutBlocage:this.dateDebutConvertedCB,dateFinBlocage: this.dateFinConvertedCB,motifBlocage: motifSupp,categorie: this.categorieValue,actionBlocage: "SUPPRIMER"}, 'IP_SM_MAJCompteClient_SOLI_WS');

    }

    //FT2-1619 Fermeture de la popup permettant de confirmer le suppression
    noDeleteBlocage(){
      this.openConfirmDeeleteModal=false;
    }

    //KDI: FT2-1620 [Gestion blocages] Modification du blocage

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
            this.showSpinnerLoading = true;
            this.closeBlocageModal();

            this.callIPLireCompteClient({CompteClient: this.noCompteContrat}, 'IP_SM_CompteClient_Solde'); 
            this.isModifOpen = false;
            this.isModifSuppOpen = true;
          }  
          else{
            const evt = new ShowToastEvent({
              title: "Un problème technique est survenu et la modification n’a pu se faire",
              variant: 'error',
            });
            this.dispatchEvent(evt);
            this.closeBlocageModal();      
          }             
      }
    }
      }).catch(error => {
        console.log("failed at getting IP data => " + error);
      });  
    }

  //KDI: FT2-1620 [Gestion blocages] Modification du blocage
    modifyBlocage(){
      this.isCreate = false;
      this.dateFinRequired = false;
      this.openConfirmDeeleteModal = false;
      this.isModifSuppOpen = false;    
      this.existingDateFinCB = this.dateFinCB; 

      this.motifsBlocageOptions.forEach(motif=>{
        this.motifCB.set(motif.label,motif.value);
      });

      if (this.valueMotifCB.length>1) this.existingMotifCB = this.motifCB.get(this.valueMotifCB);
      else this.existingMotifCB = this.valueMotifCB;
   
      let todayDebut = new Date();
      this.dateMin = todayDebut.toISOString();
      var addedWorkDays;
      if (this.existingMotifCB != undefined) {
        addedWorkDays = this.plagesBlocage.get(this.existingMotifCB);
        let today = new Date();
        this.dateMax = this.addWorkDays(today, addedWorkDays);
        this.dateMax = this.dateMax.toISOString();
      }
      let tempDebut = this.dateDebutCB.split("/");
      this.dateDebutConvertedCB =  tempDebut[0] + '-' + tempDebut[1] + '-' + tempDebut[2] + 'T00:00:00';
    }

    //KDI: FT2-1620 [Gestion blocages] Modification du blocage
    updateBlocage() {
      this.motifsBlocageOptions.forEach(motif=>{
        this.motifCB.set(motif.label,motif.value);
      });
      if (this.valueMotifCB.length > 1) {
        this.valueMotifCB = this.motifCB.get(this.valueMotifCB);
      }
      var addedWorkDays;
      if(this.valueMotifCB!=undefined){
        addedWorkDays = this.plagesBlocage.get(this.valueMotifCB);
        let today = new Date();
        this.dateMax = this.addWorkDays(today, addedWorkDays);
        this.dateMax = this.dateMax.toISOString();
      }  
      if (!(this.dateFinCB === undefined || this.dateFinCB === null) && !(this.valueMotifCB === undefined || this.valueMotifCB === null)) {
  
        if (this.dateFinCB.includes("/")) {
          let tempDateFin = this.dateFinCB.split("/");
          this.dateFinConvertedCB =  tempDateFin[0] + '-' + tempDateFin[1] + '-' + tempDateFin[2] + 'T00:00:00';
        }
        else if (this.dateFinCB.includes("-")) {
          let tempDateFin = this.dateFinCB.split("-");
          this.dateFinConvertedCB =  tempDateFin[0] + '-' + tempDateFin[1] + '-' + tempDateFin[2] + 'T00:00:00';
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
          let tempDate = this.dateFinCB.split("/");
          this.dateFinConvertedCBForModif =  tempDate[0] + '-' + tempDate[1] + '-' + tempDate[2] + 'T00:00:00';
        } else if (this.dateFinCB.includes("-")) {
          let tempDate = this.dateFinCB.split("-");
          this.dateFinConvertedCBForModif =  tempDate[0] + '-' + tempDate[1] + '-' + tempDate[2] + 'T00:00:00';
        }
        
        if (this.existingDateFinCB.includes("/")) {
          let tempExistingDateFin = this.existingDateFinCB.split("/");
          this.existingDateFinCBConverted =  tempExistingDateFin[0] + '-' + tempExistingDateFin[1] + '-' + tempExistingDateFin[2] + 'T00:00:00';
        } else if (this.existingDateFinCB.includes("-")) {
          let tempExistingDateFin = this.existingDateFinCB.split("-");
          this.existingDateFinCBConverted =  tempExistingDateFin[0] + '-' + tempExistingDateFin[1] + '-' + tempExistingDateFin[2] + 'T00:00:00';
        }

        this.motifsBlocageOptions.forEach(motif=>{
          this.motifCB.set(motif.label,motif.value);
        });
        if (this.valueMotifCB.length > 1) {
          this.valueMotifCB = this.motifCB.get(this.valueMotifCB);
        }
        
        this.callIPMAJCompteClientSOLIWSModification({IsModif: "true", CompteClient: this.noCompteContrat, dateDebutBlocageSupprimer: this.dateDebutConvertedCB, dateFinBlocageSupprimer: this.existingDateFinCBConverted, motifBlocageSupprimer: this.existingMotifCB, categorieSupprimer: this.categorieValue, actionBlocageSupprimer: "SUPPRIMER",
      dateDebutBlocageCreer: this.dateDebutConvertedCB, dateFinBlocageCreer: this.dateFinConvertedCBForModif, motifBlocageCreer: this.valueMotifCB, categorieCreer: this.categorieValue, actionBlocageCreer: "CREER",}, 'IP_SM_MAJCompteClient_SOLI_WS');
      } 
    }
}