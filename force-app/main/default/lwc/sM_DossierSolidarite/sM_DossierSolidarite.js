import { NavigationMixin } from "lightning/navigation";
import { LightningElement, api, track, wire} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import callIP from '@salesforce/apex/SM_AP77_CallIPApiService.callIP';
import getcustomMetadataRecords from '@salesforce/apex/SM_Utilities.getcustomMetadataRecords';
import getArticleByCleMigration from "@salesforce/apex/SM_CTRL004_KnowledgeForLWC.getArticleByCleMigration";
import {getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';
import SM_DOSSIERSOLIDARITETECH_OBJECT from '@salesforce/schema/SM_DossierSolidariteTech__c';
import CATEGORY_FIELD from '@salesforce/schema/SM_DossierSolidariteTech__c.Category__c';
import TYPE_AIDE_FIELD from '@salesforce/schema/SM_DossierSolidariteTech__c.TypeOfAssistance__c';
import STATUT_DOSSIER_FIELD from '@salesforce/schema/SM_DossierSolidariteTech__c.DossierStatus__c';
import ETAPE_FIELD from '@salesforce/schema/SM_DossierSolidariteTech__c.Stage__c';
import MOTIF_FIELD from '@salesforce/schema/SM_DossierSolidariteTech__c.Motif__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_ID from '@salesforce/user/Id';
import GAIA_FIELD from '@salesforce/schema/User.Gaia__c';
import ConseillerSolidarite from '@salesforce/customPermission/sm_conseiller_solidarite';
import ELEC_ICON from '@salesforce/resourceUrl/pictoElec';
import GAZ_ICON from '@salesforce/resourceUrl/pictoGaz';

//Todo externalisé ces paramétres
const constant ={
  DeveloperName: "Service",
  SobjectType: "Case" ,
  CaseType: "Vie du contrat", 
  CaseSousType: "Dossier solidarité",
  CaseStatus: "Pré-clôturé",
  CaseStatusPause:"En traitement",
  CaseSousStatut : "Conforme",
  CaseName : "Dossier solidarité",
  IPCreateCase: "IP_CreateCaseLWC_Case",
  IPGetDetailsPersonnes : "IP_SM_getDetailsPersonnes_APISET",

}


export default class sM_DossierSolidarite extends NavigationMixin(LightningElement) {
    @api currentUserGAIA;
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
    @api consulterPaiementResult ;

    @api civiliteContact;
    @api prenomContact;
    @api nomContact;

    listPconsulterPaiementResult;
    arrayLValue=new Array();
    //arrayL="--";

    @api clientAide;
    @api dateAideFSL;
    @api dossierRecouvrement;

    // Valeurs fiche de renseignement
    @api isMensualisee;
    @api isPrelevee;
    @api soldeEnCours;
    @api dateProchaineFactureSolde;
    @api dateProchaineFacture;
    @api typeDeBlocage;
    @api blocageRelance;
    @api MensualisationSolde;
    @api MontantCumuleEcheance;
    @api ListePaiementDerniersDates;
    @api isContratElec;
    @api isContratGaz;
    @api arriereValue = '';
    @api prelevementValue;
    @api montantPrelevementEnCours;
    @api planApurementEnCoursValue;
    @api clientMensualiseValue;
    @api dateDernierReglement;
    @api contratResilieValue;
    @api salutationValue= '';
    salutationOptions;
    @api nomValue = '';
    @api adressEmailValue = '';
    @api isContratElecValue;
    @api isContratGazValue;

    @api adressEmailIPCalled = false;
    @api adressEmailIPKO = false;

    @api consulterPlanApurement ;
    @api dossierRecouvrementData;
    @api dateFinValiditechequeValue;
    @api dateFinValiditechequeValueFormater;
    @api datefinvaliditeattestationvalueFormater;
    // correction bug cheque energie nulle
    @api validiteChequeEnergie="NON";
    @api validiteAttestation="NON";
    @api typecanalchequeenergievalue;
    @api canalattestationvalue;
    @api datefinvaliditeattestationvalue;

    //pour tester les regles de gestions
    @api aideClientValue;
    @api dateAideFSLvalue;
    @api numeroChequeEnergievalue;
    @api aideClientTest;

    @api serviceRecouverement="NON";
    @api isPlanApurementData="NON";
    @track dossiersAffaire = [];
    @track steps = [];
    @track etapesPrecedentes = [];
    @track etapes = [];
    @api articleKnowledge;
    @track indexVal;


    @api editStatutDossierFieldData;
    @api numeroDossier;
    @api dateEffet;

    @track isLoading = false;
    @track showSpinnerLoading = false; // variable pour afficher le spinner dans la vue principale suite à la modification d'un dossier sol
    @api solde;
    @api DLP;
    @api soldeColor;
    @track error = false;
    @track index;
    @track noData = false;
    @track noDataBis = false;
    @track value = [];
    @track nextDisable = false;
    @track checkedPause;
    @track checkedInteraction;
    @track DRId_Case;
    @track infosChequeEnergie  // informations récupérer à partir de l'API Personne

    @track idDossierAffaire = []; // infos récupérer à partir de WS DossierAffaire

    histoParcoursRelance;
    ResultList;
    @api idDossierRecouvrement;

    @api AccountId;
    @track isClicked = false;
    @api iBAN;
    @api nomInstitutBancaire;
    @api soldeDelaiPaiement;
    @api EnqSat;

    @track openFormModalFicheReng = false;
    @track openFormModal = false;
    @track modifyDSError = false;
    @track openEditFormModal = false;

    
    @track openBlocageRelances = false
    @track openBlocageRelancesCNB = false;
    @track openBlocageRelancesCB = false;

    @track openConfirmDeeleteModal = false;

    @track openBlocageRelancesCBModification = false;

    @track error;
    @track values;
    @track data;
    @track stageFieldData;
    @track stageFieldDataOptions;
    @track statutDossierOptions;
    @track etapeOptions;
    @track statutDossierOptionsLabel;

    @track commentaireFieldData;
    @track stageField;

    @track dateDebutCNB;
    @track dateDebutCB;
    @track dateFinCNB;
    @track dateFinCB;
    @track dateFinPlaceholderCB;


    @track dateDebutConvertedCB;
    @track dateFinConvertedCB;
    @track dateFinConvertedCBForModif;


    @track dateMax;
    @track dateMin;
    @track valueMotifCNB;
    @track valueMotifCB;
    @track productJalonArray = [];
    @track productArray = [];
    @track histoParcoursRelance;
    @track code;
    
    @track description;
    @track statutDossierFieldData;
    @track CategoryFieldData;
    @track typeAideFieldData;

    @track existingCategory;
    @track existingTypeAide;
    @track existingEtape;
    @track existingStatutDossier;

    @track existingMotifCB;
    @track existingDateFinCB;
    @track existingDateFinCBConverted;

    @track editCategoryFieldData;
    @track addedWorkDays;

    @track existingEtapeToUpdate;

    //FT2-1543
    @track showPrelevementRadio ;
    @track hidePrelevementRadio;
    @track planApurementStatutRadio ;
    @track hideplanApurementStatutRadio;
    @track MensualisationSoldeRadio ;
    @track hideMensualisationSoldeRadio;
    @track contratResilieRadio;
    @track chequeEnergieRadio;
    @track hidechequeEnergieRadio;
    @track chequeEnergieValue;
    @track attestationChequeEnergieRadio   
    @track hideattestationChequeEnergieRadio;


    etapeCode1 = '';
    etapeValeurDate1 = '';
    etapeCode2 = '';
    etapeValeurDate2 = '';
    etapeCode3 = '';
	  etapeValeurDate3 = '';
    etapeCode4 = '';
    etapeValeurDate4 = '';
    etapeCode5 = '';
    etapeValeurDate5 = '';
    etapeCode6 = '';
    etapeValeurDate6 = '';
    etapeCode7 = '';
    etapeValeurDate7 = '';
    etapeCode8 = '';
    etapeValeurDate8 = '';
    etapeCode9 = '';
    etapeValeurDate9 = '';
    etapeCode10 = '';
    etapeValeurDate10 = '';
    etapeCode11 = '';
    etapeValeurDate11 = '';
    etapeCode12 = '';
    etapeValeurDate12 = '';
    etapeCode13 = '';
    etapeValeurDate13 = '';
    etapeCode14 = '';
    etapeValeurDate14 = '';
    etapeCode15  = '';
    etapeValeurDate15 = '';


    categoryMap = new Map();
    typeAide = new Map();
    etape = new Map();
    statutDossier = new Map();

    plagesBlocages = new Map();

    motifCB = new Map();


    dateFinConvertedCNB;
    dateDebutConvertedCNB;
    dateFinRequired;


    // Expose the static resource URL for use in the template
    pictoElect = ELEC_ICON;
    pictoGaz   = GAZ_ICON;


    // FT2-1251 : Rendre l'affichage des articles dynamique selon le profil du conseiller (solidarité ou facturation)
      get getCleMigration(){
        return this.hasPermissionAccess ? '000001629' : '000001538';
       }
     


    // FT2-1338 gestion de l'habilitation pour le conseiller solidarite  
    get hasPermissionAccess(){
      return ConseillerSolidarite ? true : false ;
    }

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
  
    get isDelaiPaiement(){
      return this.isPlanApurementData == 'OUI';
    }


    displayFilDariane(e){
      this.isClicked = true;   
      this.steps = [];
      var indexValue;

      //FT2-1766 mutualisation de displayFilDariane & displayFilDarianeModif
      if(typeof(e) === 'number') {
          indexValue = e
      }else if(typeof(e) === 'object'){
          indexValue = e.currentTarget.dataset.key;
      }
      this.dossiersAffaire.forEach(row =>{
          if(row.retourLireDALoop.idDossierAffaire === this.dossiersAffaire[indexValue].retourLireDALoop.idDossierAffaire){
              row.style = 'row-selected'
          } else {
              row.style = '';
          }
      });
      for (let index = 0; index < this.dossiersAffaire[indexValue].sortedJalons.length ; index++) {
              console.log(this.dossiersAffaire[indexValue].sortedJalons[index]);
              this.steps[index] = this.dossiersAffaire[indexValue].sortedJalons[index];
              this.steps[index].label=  this.DateFormaterFilAriane(this.dossiersAffaire[indexValue].sortedJalons[index].valeurDate) + ' : ' + this.dossiersAffaire[indexValue].sortedJalons[index].typeDate.libelleCourt;
              this.steps[index].code = this.dossiersAffaire[indexValue].retourLireDALoop.idDossierAffaire + this.dossiersAffaire[indexValue].sortedJalons[index].typeDate.code;
              this.steps[index].value = index;
              if(index == this.dossiersAffaire[indexValue].sortedJalons.length - 1){
                  this.steps[index].isCompleted = false;
                  this.steps[index].style= "slds-progress__item slds-is-active";
              } 
              else{
                  this.steps[index].isCompleted = true;
                  this.steps[index].style= "slds-progress__item slds-is-completed";
              }
      }  
      if(typeof(e) === 'number') {
          this.showSpinnerLoading= false;
      }
    }




//fonction de formatage de date a dd-mm-yyyy
@api DateFormaterF(inputDate){
  let FormaterDateV=new Date(inputDate);
            const DateFC = new Intl.DateTimeFormat('fr', {
              
              day: '2-digit',

              month: '2-digit',

              year: 'numeric'
                
              })
            const [{value: dd}, , {value: mm}, , {value: yy}] = DateFC.formatToParts(FormaterDateV);
            FormaterDateV=`${dd}-${mm}-${yy}`;
            return FormaterDateV;
}

//fonction de formatage de date a dd/mm/yyyy
@api DateFormaterFilAriane(inputDate){
  let FormaterDateV=new Date(inputDate);
            const DateFC = new Intl.DateTimeFormat('fr', {
              
              day: '2-digit',

              month: '2-digit',

              year: 'numeric'
                
              })
            const [{value: dd}, , {value: mm}, , {value: yy}] = DateFC.formatToParts(FormaterDateV);
            FormaterDateV=`${dd}/${mm}/${yy}`;
            return FormaterDateV;
}


@api FormaterDateConsulterPaiement(inputDate){
  let FormaterDateV=new Date(inputDate);
            const DateFC = new Intl.DateTimeFormat('fr', {
              
              day: '2-digit',

              month: '2-digit',

              year: '2-digit'
                
              })
            const [{value: dd}, , {value: mm}, , {value: yy}] = DateFC.formatToParts(FormaterDateV);
            FormaterDateV=`${dd}/${mm}/${yy}`;
            return FormaterDateV;
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

  // FT2-1253 formatage des dates pour envoie de fiche de renseignement client
  @api formatDateFicheRenseignement(inputDate){
    let dateDay = inputDate.slice(0,2);
    let dateMonth = inputDate.slice(3,5);
    let dateYear = inputDate.slice(6,11);
    var FormaterDateV = dateYear.concat(dateMonth,dateDay);
    return FormaterDateV;
  }
  // KD -> FT2-1335 : SOLI_2 - RDG fiche de renseignement client
  callIPVerifyEmailPhoneNumberContact(params, name) {
    this.isLoading = true;
    callIP({inputMap: params, NameIntergation: name })
    .then(result => {
      if(result && result.EmailVerification!=null){
        var email = result.EmailVerification.email1;
        console.log("IP_SM_VerifyEmailPhoneNumberContact DATA:" +JSON.stringify(result.EmailVerification.email1))
        if(email == 'KO'){
          // Ajout du message d'erreur si retour KO de la validation d'email
          this.adressEmailIPKO = true;
          this.template.querySelector('.error').innerHTML="Le format de l’adresse e-mail est incorrect";
        }else {
          this.adressEmailIPKO = false;
          this.template.querySelector('.error').innerHTML='';
        }

      }
      this.isLoading = false;
      this.adressEmailIPCalled = true;
    })


  }
  //FT2-1252 Récupération du gaia de l'utilisateur actuel
  @wire(getRecord, {
      recordId: USER_ID,
      fields: [GAIA_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
            this.error = error ; 
        } else if (data) {
          this.currentUserGAIA = data.fields.Gaia__c.value;
          console.log('gaia'+this.currentUserGAIA);   
        }

  }

  //FT2-1252 ouverture Fiche Renseignement
  ficheDeRenseignement(){  
    this.openFormModalFicheReng = true;
    this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');
    this.callIPGetDetailsPersonnes({contactId:this.recordId},constant.IPGetDetailsPersonnes);
    this.callIPConsulterPlanApurement({idPersonne: this.IdBusinessPartner, statutPA : "ACTIVE"}, 'IP_SM_consulterPlanApurement_SOAP');
    // formatage des dates affiché sur la popup

    if(this.dateProchaineFactureSolde && this.dateProchaineFactureSolde!='--'){
      this.dateProchaineFacture = this.dateProchaineFactureSolde.replaceAll('-','/');
    }
    if(this.arrayLValue[0]){
      this.dateDernierReglement = this.DateFormaterFilAriane(this.arrayLValue[0].datePaiementValue);
    }
    this.salutationOptions = [
      { label: 'M.', value: 'MR' },
      { label: 'Mme', value: 'MME' },
    ];
    // préremplissage des informations de la popup avec les différents retour IP et les infos de la vue 360
    if(this.isMensualisee || this.isPrelevee){
      this.prelevementValue = "O";
      this.showPrelevementRadio = true;
      this.hidePrelevementRadio = false;
    }else{
      this.prelevementValue = "N";
      this.showPrelevementRadio = false;
      this.hidePrelevementRadio = true;
    }

    if(this.isPlanApurementData==="OUI"){
      this.planApurementEnCoursValue='O';
      this.planApurementStatutRadio = true;
      this.hideplanApurementStatutRadio = false;
      if(this.consulterPlanApurement && this.consulterPlanApurement.planApurement){
        if(this.consulterPlanApurement.planApurement.statutPA==='désactivé'){
            this.planApurementEnCoursValue='N';
            this.planApurementStatutRadio = false;
            this.hideplanApurementStatutRadio = true;
        }
      }
    }else{
      this.planApurementEnCoursValue='N';
      this.planApurementStatutRadio = false;
      this.hideplanApurementStatutRadio = true;
    }
    if(this.MensualisationSolde==='OUI'){
      this.MensualisationSoldeRadio = true;
      this.hideMensualisationSoldeRadio = false;
      this.clientMensualiseValue = 'O';
    }
    if(this.MensualisationSolde==='NON'){
      this.MensualisationSoldeRadio = false;
      this.hideMensualisationSoldeRadio = true;
      this.clientMensualiseValue = 'N';
    }
    if(this.validiteChequeEnergie==='OUI'){
      this.chequeEnergieRadio = true;  
      this.hidechequeEnergieRadio = false;   
      this.chequeEnergieValue = 'O';
    }
    if(this.validiteChequeEnergie==='NON'){
      this.chequeEnergieRadio = false;
      this.hidechequeEnergieRadio = true;   
      this.chequeEnergieValue = 'N';
    }
    if(this.validiteAttestation==='OUI'){
      this.attestationChequeEnergieRadio = true;
      this.hideattestationChequeEnergieRadio = false;
      this.validiteAttestationValue='O';
    }
    if(this.validiteAttestation==='NON'){
      this.attestationChequeEnergieRadio = false;
      this.hideattestationChequeEnergieRadio = true;
      this.validiteAttestationValue='N';
    }
    if(this.isContratElec){
      this.isContratElecValue = 'O';
    }else{
      this.isContratElecValue = 'N';
    }
    if(this.isContratGaz){
      this.isContratGazValue = 'O';
    }else{
      this.isContratGazValue = 'N';
    }
  }

  // FT2-1253 Gestion des boutons de la fiche de renseignement client
  // Bouton annuler
  cancelEnvoyerFiche(){
    this.dateProchaineFacture = '';
    this.dateDernierReglement = '';
    this.prelevementValue = '';
    this.showPrelevementRadio = '';
    this.planApurementEnCoursValue = '';
    this.planApurementStatutRadio = '';
    this.MensualisationSoldeRadio = '';
    this.clientMensualiseValue = '';
    this.chequeEnergieRadio = '';    
    this.chequeEnergieValue = '';
    this.attestationChequeEnergieRadio = '';
    this.validiteAttestationValue = '';
    this.isContratElecValue = '';
    this.isContratGazValue = '';
    this.salutationValue= '';
    this.nomValue = '';
    this.adressEmailValue = '';
    this.montantPrelevementEnCours = '';
    this.adressEmailIPCalled = false;
    this.adressEmailIPKO = false;
    this.openFormModalFicheReng = false;
    this.hidePrelevementRadio = '';
    this.hideplanApurementStatutRadio = '';
    this.hideMensualisationSoldeRadio = '';
    this.hidechequeEnergieRadio = '';
    this.hideattestationChequeEnergieRadio = '';

  }
  montantPrelevementEncoursHandleChange(event){
    this.montantPrelevementEnCours = event.target.value;
  }
  salutationHandleChange(event){
    this.salutationValue = event.target.value;
  }
  nomHandleChange(event){
    this.nomValue = event.target.value;
  }
  adressEmailHandleChange(event){
    this.adressEmailValue = event.target.value;
    this.callIPVerifyEmailPhoneNumberContact({email1:this.adressEmailValue},'IP_SM_VerifyEmailPhoneNumberContact_API');
  }
  onClickArriereRadio(event){
    this.arriereValue = event.target.value;
    var arrAvec= this.template.querySelector('.arrAvec').checked;
    var arrSans= this.template.querySelector('.arrSans').checked;
    if (arrAvec==false && arrSans==false) {
      this.template.querySelector('.errorArrVal').innerHTML="Le champ arriéré doit être renseigné.";
    }else{
      this.template.querySelector('.errorArrVal').innerHTML="";
    }
  }
  onClickPrelevementRadio(event){
    this.hidePrelevementRadio = this.showPrelevementRadio;
    this.showPrelevementRadio = !this.showPrelevementRadio;
    this.prelevementValue = event.target.value;
  }
  onClickPlanApurementEnCoursRadio(event){
    this.hideplanApurementStatutRadio = this.planApurementStatutRadio;
    this.planApurementStatutRadio = !this.planApurementStatutRadio;
    this.planApurementEnCoursValue = event.target.value;
  }
  onClickclientMensualiseRadio(event){
    this.hideMensualisationSoldeRadio = this.MensualisationSoldeRadio;
    this.MensualisationSoldeRadio =  !this.MensualisationSoldeRadio;
    this.clientMensualiseValue = event.target.value;
  }
  onClickContratResilieRadio(event){
    this.contratResilieValue = event.target.value;
    var resilOui= this.template.querySelector('.resilOui').checked;
    var resilNon= this.template.querySelector('.resilNon').checked;
    if (resilOui==false && resilNon==false) {
      this.template.querySelector('.errorContratResil').innerHTML="Le contrat est obligatoire.";
    }else{
      this.template.querySelector('.errorContratResil').innerHTML="";
    }
  }
  onClickChequeEnergieRadio(event){
    this.hidechequeEnergieRadio = false;   
    this.chequeEnergieRadio = true;
    this.chequeEnergieValue = event.target.value;
  }
  onClickChequeEnergieRadioFalse(event){
    this.hidechequeEnergieRadio = true;   
    this.chequeEnergieRadio = false;
    this.chequeEnergieValue = event.target.value;
  }
  onClickAttestationChequeEnergieRadio(event){
    this.hideattestationChequeEnergieRadio = false;
    this.attestationChequeEnergieRadio = true;
    this.validiteAttestationValue = event.target.value;
  }
  onClickAttestationChequeEnergieRadioFalse(event){
    this.hideattestationChequeEnergieRadio = true;
    this.attestationChequeEnergieRadio = false;
    this.validiteAttestationValue = event.target.value;
  }
  onClickContratElec(){
    this.isContratElec = !this.isContratElec;
    if(this.isContratElec){
      this.isContratElecValue = 'O';
    }else{
      this.isContratElecValue = 'N';
    }
  }
  onClickContratGaz(){
    this.isContratGaz = !this.isContratGaz;
    if(this.isContratGaz){
      this.isContratGazValue = 'O';
    }else{
      this.isContratGazValue = 'N';
    }
  }
  // FT2-1253 Gestion des boutons de la fiche de renseignement client
  // Bouton envoyer Fiche client par Email
  saveEnvoyerFiche(){
    this.isLoading = true;
    if(!this.adressEmailIPCalled){
      this.callIPVerifyEmailPhoneNumberContact({email1:this.adressEmailValue},'IP_SM_VerifyEmailPhoneNumberContact_API');
    }
    // FT2-1335 règle de gestion de la fiche, avec les messages d'erreurs pour chaque champ obligatoire

    if((this.adressEmailValue === undefined || this.adressEmailValue === null || this.adressEmailValue === '') || 
      (this.salutationValue === undefined || this.salutationValue === null || this.salutationValue === '') || 
      (this.nomValue === undefined || this.nomValue === null || this.nomValue === '')||
      (this.arriereValue === undefined || this.arriereValue === null || this.arriereValue === '')||
      (this.contratResilieValue === undefined || this.contratResilieValue === null || this.contratResilieValue === '')){
          this.template.querySelectorAll('lightning-combobox').forEach(element => {
          element.reportValidity();
          });
          this.template.querySelectorAll('lightning-input').forEach(element => {
            element.reportValidity();
          });
          var arrAvec= this.template.querySelector('.arrAvec').checked;
          var arrSans= this.template.querySelector('.arrSans').checked;
          if (arrAvec==false && arrSans==false) {
            this.template.querySelector('.errorArrVal').innerHTML="Le champ arriéré doit être renseigné.";
          }else{
            this.template.querySelector('.errorArrVal').innerHTML="";
          }
          var resilOui= this.template.querySelector('.resilOui').checked;
          var resilNon= this.template.querySelector('.resilNon').checked;
          if (resilOui==false && resilNon==false) {
            this.template.querySelector('.errorContratResil').innerHTML="Le contrat est obligatoire.";
          }else{
            this.template.querySelector('.errorContratResil').innerHTML="";
          }
          this.isLoading = false;
          this.dispatchEvent(
            new ShowToastEvent({
                title: 'Veuillez remplir tous les champs obligatoires',
                variant: 'error',
            }),
        );
    }else{
      if(!this.adressEmailIPKO){
      //formatage des informations envoyé a l'IP pour l'envoi de la fiche.
      var ficheFormulaireLabel= 'GDFSUEZ : Fiche de Renseignement de ';
      if(this.civiliteContact != undefined && this.civiliteContact != null && this.civiliteContact != ''){
        ficheFormulaireLabel+=this.civiliteContact+' ';
      }
      if(this.nomContact != undefined && this.nomContact != null && this.nomContact != ''){
        ficheFormulaireLabel+=this.nomContact+' ';
      }
      if(this.prenomContact != undefined && this.prenomContact != null && this.prenomContact != ''){
        ficheFormulaireLabel+=this.prenomContact+' ';
      }
      var dateDernierReglementFormate = '';
      var dateProchaineFactureFormate = '';
      if(this.dateProchaineFacture){
         dateProchaineFactureFormate = this.formatDateFicheRenseignement(this.dateProchaineFacture);
      }
      if(this.dateDernierReglement){
         dateDernierReglementFormate = this.formatDateFicheRenseignement(this.dateDernierReglement);
      }
      if(this.montantPrelevementEnCours < 0 || this.montantPrelevementEnCours === undefined 
        || this.montantPrelevementEnCours === null || this.montantPrelevementEnCours === ''){
          this.montantPrelevementEnCours='0.00';
      }
      this.callIPMailFicheClient({
        canalCode: 'Email',
        canalLibelle: 'EMAIL',
        arriereValeur: this.arriereValue,
        refCompteClientValeur: this.NoCompteContrat,
        CPLogementValeur: this.codePostal,
        civiliteValeur: this.salutationValue,
        civiliteClientValeur: this.civiliteContact,
        clientMensValeur: this.clientMensualiseValue,
        contratGazValeur: this.isContratGazValue,
        contratElecValeur: this.isContratElecValue,


        montantMensValeur: this.MontantCumuleEcheance,
        montantADateValeur: this.soldeEnCours,
        montantPrlValeur: this.montantPrelevementEnCours,
        nomValeur: this.nomValue, 
        nomClientValeur: this.nomContact,
        numLogementValeur: this.numeroVoie,
        planValeur: this.planApurementEnCoursValue,
        prelEnCoursValeur: this.prelevementValue,
        prenomClientValeur: this.prenomContact,


        refClientValeur: this.IdBusinessPartner,
        contratResilValeur: this.contratResilieValue,
        rueLogementValeur: this.libelleVoie,
        villeLogementValeur: this.ville,
        tpnValeur: this.validiteAttestationValue,
        tssValeur: this.chequeEnergieValue,
        adresseMailValeur : this.adressEmailValue, 
        email: this.adressEmailValue,
        modeSynchroneCode: 'test',
        modeSynchroneLibelle: 'test',
        modeEnvoiCode: 'ASYN',
        modeEnvoiLibelle: 'modesynchrone',
        idApplicationCode: 'STRS',
        idApplicationLibelle: 'StreamServe',        
        idFormulaireCode: 'FICHE_RENSEIGNEMENT_MAIL',
        idFormulaireLibelle: ficheFormulaireLabel,
        gaiaValeur: this.currentUserGAIA,
        dateProchainRegValeur: dateProchaineFactureFormate,
        dateDernierRegValeur: dateDernierReglementFormate,
        telFixeValeur: '0000000000',
        telValeur: '0000000000'
      }, 'IP_SM_Mail_Fiche_Client_WS');
    }else{
      this.isLoading = false;
    }
    }
  }

  // FT2-1253 Gestion des boutons de la fiche de renseignement client
  // Appel WS IP_SM_Mail_Fiche_Client
  callIPMailFicheClient(params, name){
    console.log("calling IP_SM_Mail_Fiche_Client");

    console.log(params);
    callIP({ inputMap: params, NameIntergation: name })
    .then(result => {
      this.isLoading = false;
      console.log("result :", result);
      if (result) {
        var codeRetourEmail = result.CodeRetour;
        if(codeRetourEmail=== 'OCTOPUS_EnvoyerCorrespondance_01'){

          const evt = new ShowToastEvent({
            title: "Succès",
            message: 'La fiche de renseignement a bien été envoyée',
            variant: 'success'
          });
          this.dispatchEvent(evt);
          this.cancelEnvoyerFiche();
        }else{
          const evt = new ShowToastEvent({
            title: 'Un problème technique est survenu et la fiche client n\'a pas été envoyée',

            variant: 'error'

          });
          this.dispatchEvent(evt);
        }
    }else{
      const evt = new ShowToastEvent({
        title: 'Un problème technique est survenu et la fiche client n\'a pas été envoyée',

        variant: 'error'

      });
      this.dispatchEvent(evt);
      }
    })
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
  //FT2-1254 Open Blocage Modal
  openBlocageDesRelances(){
      //FT2-1506
      this.getPlagesBlocages();

    if(this.blocageRelance === 'NON'){
      
      this.openBlocageRelances = true;
      this.openBlocageRelancesCNB = true;
      this.openBlocageRelancesCB = false; 

      this.openBlocageRelancesCBModification = false;

      let today = new Date();
      this.dateDebutCNB = today.toISOString();
      let temp = this.dateDebutCNB.split("T")[0].split('-');
      this.dateFinPlaceholderCNB =  temp[2] + '/' + temp[1] + '/' + temp[0];

    }else if(this.blocageRelance === 'OUI'){

      this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');
      
      this.openBlocageRelances = true;
      this.openBlocageRelancesCNB = false;
      this.openBlocageRelancesCB = true;

      this.openBlocageRelancesCBModification = false;
    }
  }

  dateDebutHandleChange(event) {
    this.dateDebutCNB = event.target.value;
  }
  dateFinHandleChange(event) {
    this.dateFinCNB = event.target.value;
  }

  //FT2-1506 - récupération du mapping Motif et plage de blocage
  //FT2-1610 - récupération du mapping Motif et plage de blocage en fonction du parcours et du type de blocage
  getPlagesBlocages(){
    getcustomMetadataRecords({ sObjName: 'SM_PlageBlocageParMotif__mdt' ,sObjFields : 'MasterLabel,DeveloperName,Plagepossible__c,CodeBlocage__c,ParcoursSOL__c,Type__c,'}).then(result => {
      if(result){
        var plagesBlocagesResult = result;
        plagesBlocagesResult.forEach(plage=>{
          if(plage.ParcoursSOL__c ==true && plage.Type__c == 'Relance'){
            this.plagesBlocages.set(plage.CodeBlocage__c,plage.Plagepossible__c);
          }
        });
      }
    })
    .catch(error => {
      this.error = true;
      console.log("got error getcustomMetadataRecords" , error);
    });
  }
  
  //FT2-1457 - Correspondance motif-plage de blocage (Ecran de création de blocage)
  //FT2-1506 - MàJ plage de blocage en fonction des motifs
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

    //FT2-1523 - Gestion des dates dans les formulaires blocage - Correction du bug du champ date de fin mis en évidence même s'il est rempli
    if (this.dateFinCB === undefined || this.dateFinCB == '' || this.dateFinCB === null) {
      this.dateFinRequired = true;
    }
    else {
      this.dateFinRequired = false;
    }
  }

  //FT2-1457 - Correspondance motif-plage de blocage (Ecran de modification de blocage)

  //FT2-1506 - MàJ plage de blocage en fonction des motifs
  motifCBHandleChange(event) {
    this.valueMotifCB = event.target.value;
    this.addedWorkDays = this.plagesBlocages.get(this.valueMotifCB);

    let today = new Date();
    this.dateMax = this.addWorkDays(today, this.addedWorkDays);
    this.dateMax = this.dateMax.toISOString();
  }

  //Close Blocage Modal
  closeBlocageDesRelancesCNB() {

      this.dateFinCNB = '';
      this.valueMotifCNB = ''; 
      this.openBlocageRelances = false;
      this.openBlocageRelancesCNB = false;
  } 
  
  //Close Blocage Modal
 saveBlocageDesRelancesCNB() {
        //ensure that the required fields are filled in
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

  closeBlocageDesRelancesCB(){
    this.openBlocageRelances = false;
    this.openBlocageRelancesCB = false;


    this.openBlocageRelancesCNB = false;
  }

  deleteBlocageDesRelancesCB(){

    this.openConfirmDeeleteModal = true;
  }

  //FT-1340 Modification formulaire client bloqué
  modifyBlocageDesRelancesCB(){
    this.dateFinRequired = false;
    this.openConfirmDeeleteModal = false;
    this.openBlocageRelancesCBModification = true;
    this.openBlocageRelancesCB = false;
    this.openBlocageRelancesCNB = false;
    this.existingDateFinCB = this.dateFinCB;
    this.existingMotifCB = this.motifCB.get(this.valueMotifCB.trim());

    let todayDebut = new Date();
    this.dateMin = todayDebut.toISOString();

    //FT2-1523 - Gestion des dates dans les formulaires blocage - Correction du bug de la date max infinie au cas où le motif n'est pas modifié
    if (this.existingMotifCB != undefined) {
      this.addedWorkDays = this.plagesBlocages.get(this.existingMotifCB);
      let today = new Date();
      this.dateMax = this.addWorkDays(today, this.addedWorkDays);
      this.dateMax = this.dateMax.toISOString();
    }
 
    let tempDebut = this.dateDebutCB.split("/");
    this.dateDebutConvertedCB =  tempDebut[0] + '-' + tempDebut[1] + '-' + tempDebut[2] + 'T00:00:00';
  }

  //FT-1342 Modification blocage relance client bloqué
  updateBlocageDesRelancesCB() {
    if (this.valueMotifCB.length > 1 ) {
      this.valueMotifCB = this.motifCB.get(this.valueMotifCB.trim());
    }
    if (!(this.dateFinCB === undefined || this.dateFinCB === null || this.dateFinCB ==='') && !(this.valueMotifCB === undefined || this.valueMotifCB === null || this.valueMotifCB === '')) {

      if (this.dateFinCB.includes("/")) {
        let tempFin = this.dateFinCB.split("/");
        this.dateFinConvertedCB =  tempFin[0] + '-' + tempFin[1] + '-' + tempFin[2] + 'T00:00:00';
      }
      else if (this.dateFinCB.includes("-")) {
        let tempFin = this.dateFinCB.split("-");
        this.dateFinConvertedCB =  tempFin[0] + '-' + tempFin[1] + '-' + tempFin[2] + 'T00:00:00';
      }
    }

    if((this.dateFinCB === undefined || this.dateFinCB === null || this.dateFinCB ==='') && (this.valueMotifCB === undefined || this.valueMotifCB === null || this.valueMotifCB === '')){

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


    }else if((this.dateFinCB === undefined || this.dateFinCB === null || this.dateFinCB ==='') && !(this.valueMotifCB === undefined || this.valueMotifCB === null || this.valueMotifCB === '')){
      this.template.querySelectorAll('lightning-input').forEach(element => {
        element.reportValidity();
      });
      const evt = new ShowToastEvent({
          title: "Veuillez remplir la date de fin",
          variant: 'error',
      });
      this.dispatchEvent(evt);

    }else if(!(this.dateFinCB === undefined || this.dateFinCB === null || this.dateFinCB ==='') && (this.valueMotifCB === undefined || this.valueMotifCB === null || this.valueMotifCB === '')){
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

  //Annulation Modification formulaire client bloqué
  closeBlocageDesRelancesCBModification(){
    this.openBlocageRelancesCBModification = false;
    this.openBlocageRelancesCNB = false;
    this.openBlocageRelancesCB = true;
    if (this.existingMotifCB != undefined) {
      this.valueMotifCB = this.existingMotifCB;
    }
    this.dateFinCB = this.existingDateFinCB;
    this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');
  }

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



  noDeleteBlocageDesRelancesCB(){
    this.openConfirmDeeleteModal = false;
    this.openBlocageRelances = true;
    this.openBlocageRelancesCB = true;
    this.openBlocageRelancesCNB = false;
    
  }

  delaiDePaiement(){
  }

   //Navigation vers tracer interaction
  navigateToInteraction(){
  
    const eventName = 'openInteraction';
    let inputMap;
    console.debug('EnqSat1239'+JSON.stringify(this.EnqSat))
    //Params pour interaction
      if(this.checkedInteraction ){
        inputMap = {
          isActivateTracerInteractionOS: true,
          isCasNominal:true,
          isPauseInteraction: false,
          DRId_Case:this.DRId_Case,
          StepNameOS:'Dossier Solidarité - Vue Conseiller Facturation',
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
          StepNameOS:'Dossier Solidarité - Vue Conseiller Facturation',
          refClientIdBP:this.idBusinessPartner,
          isLWC:true,
          EnqSat:this.EnqSat
        } 
      }
     
      const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
      this.dispatchEvent(event);
  }

   //Create Case et tracage d'interaction
    caseNavigate(){
      this.nextDisable = true;
      //Call IP to create Case and get idBP
      this.noDataBis = false;
      if(this.checkedInteraction){
        this.callIP({ContextId:this.recordId,AccountId:this.AccountId,DeveloperName:constant.DeveloperName,SobjectType:constant.SobjectType ,CaseType:constant.CaseType,
        CaseSousType:constant.CaseSousType,CaseStatus:constant.CaseStatus,CaseSousStatut:constant.CaseSousStatut, CaseName : constant.CaseName},constant.IPCreateCase);
      }
      else if(this.checkedPause){
          this.callIP({ContextId:this.recordId,AccountId:this.AccountId,DeveloperName:constant.DeveloperName,SobjectType:constant.SobjectType ,CaseType:constant.CaseType,
          CaseSousType:constant.CaseSousType,CaseStatus:constant.CaseStatusPause,CaseName : constant.CaseName},constant.IPCreateCase);
      }   
       
    }

//spinner

    // faire appel à API personne pour la récupération des infos cheques energie
    callIPGetDetailsPersonnes(params, name) {

      console.log("calling " + constant.IPGetDetailsPersonnes);
      console.log(params);

     //declarations des variable 
      let currentDate;
      let startDate;
      let endDate;
      let startDateAttestation;
      let endDateAttestation;


    //initiation des variables 
      this.dateFinValiditechequeValue="--";
      this.datefinvaliditeattestationvalue="--";
      this.typecanalchequeenergievalue="--";
      this.canalattestationvalue="--";
      this.aideClientValue="NON";
      this.dateAideFSLvalue="--";
      this.numeroChequeEnergievalue="--";
      this.dateFinValiditechequeValueFormater="--";
      this.datefinvaliditeattestationvalueFormater="--";

      this.serviceRecouverement="NON";
 
      callIP({ inputMap: params, NameIntergation: name })
        .then(result => {
          this.infosChequeEnergie=result;
          var typecanalchequeenergie=result.resultdata.typeCanalPrefere;
          var canalattestation=result.resultdata.attestationCanal;
          var datefinvaliditecheque=result.resultdata.dateFinValiditeChequeEnergie;
          var datefinvaliditeattestation=result.resultdata.attestationDateFinValidite;
          var datedebutvaliditeattestation=result.resultdata.attestationDateDebutValidite;
          var datedebutvaliditecheque=result.resultdata.dateDebutValiditeChequeEnergie;
          var numeroCheque=result.resultdata.numeroChequeEnergie;
          var civilite=result.resultdata.civilite;
          var prenom=result.resultdata.prenom;
          var nom=result.resultdata.nom;
          
        //  console.log(constant.IPGetDetailsPersonnes+ " DATA:" +JSON.stringify(this.infosChequeEnergie));  

          currentDate=new Date();

          endDate=new Date(datefinvaliditecheque);
          startDate =new Date(datedebutvaliditecheque);

          startDateAttestation=new Date(datedebutvaliditeattestation);
          endDateAttestation=new Date(datefinvaliditeattestation);

          if(civilite!=null){
            this.civiliteContact=civilite;
          }

          if(prenom!=null){
            this.prenomContact=prenom;
          }

          if(nom!=null){
            this.nomContact=nom;
          }

          if(datefinvaliditecheque!=null){
            this.dateFinValiditechequeValue=datefinvaliditecheque;
             this.dateFinValiditechequeValueFormater=this.DateFormaterF( this.dateFinValiditechequeValue);
          }

          if(datefinvaliditeattestation!=null){
            this.datefinvaliditeattestationvalue=datefinvaliditeattestation;
             this.datefinvaliditeattestationvalueFormater=this.DateFormaterF(this.datefinvaliditeattestationvalue);
          }

          if(typecanalchequeenergie!=null){
            this.typecanalchequeenergievalue=typecanalchequeenergie;
          }
          if(canalattestation!=null){
            this.canalattestationvalue=canalattestation;
          }

        if(numeroCheque!=null){
            this.numeroChequeEnergievalue=numeroCheque;
        }
//Si la date du jour est comprise entre dateDebutValiditeChequeEnergie et dateFinValiditeChequeEnergie alors on affiche “OUI” sinon on affiche « NON ».
        if(this.dateFinValiditechequeValue!="--"){
                    if(currentDate < endDate  && currentDate > startDate){
                      this.validiteChequeEnergie="OUI";
                    }else{
                      this.validiteChequeEnergie= "NON";
                    }
                  }

//Si la date du jour est comprise entre attestation dateDebutValidite et attestationdateFinValidite alors on affiche “OUI” sinon on affiche « NON ».
        if(this.datefinvaliditeattestationvalue!="--"){
                  if(currentDate < endDateAttestation  && currentDate > startDateAttestation){
                    this.validiteAttestation="OUI";
                  }else{
                    this.validiteAttestation= "NON";
                  }
                }

 //compteClient_ clientAide :Si les champs de type Booleen sont vides ou non remontés alors c'est la valeur NON qui s'affiche par défaut
 
  this.aideClientValue=this.clientAide;     
                                    
 //compteClient_ dateaideFSL : Formattage de la date Date Aide Fsl en format fr     
 if(this.dateAideFSL != null && this.dateAideFSL != '--') {
 this.dateAideFSLvalue=this.DateFormaterF(this.dateAideFSL);
 }

  //dateProchaineFactureSolde :Formattage de la date en format fr
 // this.dateProchaineFactureSoldevalue=this.DateFormaterF(this.dateProchaineFactureSolde);

  // SERVICE RECOUVEREMENT : Si l’appel renvoi au moins un dossier alors afficher OUI sinon afficher NON

        })
        .catch(error => {
          this.error = true;
          console.log("error while IPGetDetailsPersonnes DATA", constant.IPGetDetailsPersonnes , error);
        });
    }

    // faire appel à LireDossierAffaire qui combine l'appel à rechercher et lire

    callIPLireDossierAffaire(params, name) {
      console.log("calling LireDossierAffaire");
      console.log(params);
      callIP({ inputMap: params, NameIntergation: name })
      .then(result => {
          console.log("result LireDossierAffaire");
          console.log(result);
          
          if (result.dossierAffairesDetailsLoop!=null) {
            //console.log("IP LireDossierAffaire DATA:" +JSON.stringify(result.dossierAffairesDetailsLoop));
           this.noData = result.dossierAffairesDetailsLoop.length > 0 && result.dossierAffairesDetailsLoop[0].retourLireDALoop != null ? false : true;
           //console.log(this.noData);
           //console.log(result.dossierAffairesDetailsLoop.length);
            this.dossiersAffaire = result.dossierAffairesDetailsLoop; 
            this.noDataBis = this.noData;
            this.displayFilDariane(this.indexVal);
        }
        else{
          this.noData = true;
          this.noDataBis = true;
        }
      })
      .catch(error => {
        this.error = true;
        // this.loadTabs = true;
        console.log("got error LireDossierAffaire DATA", name , error);
      });
    }

    navigateToDelaiPaiement(){
        console.log("ouverture délai paiement");
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_Cont_SynDP'
            },
            state: {
                c__numeroVoie: this.numeroVoie.toString(),
                c__libelleVoie: this.libelleVoie.toString(),
                c__complementAdresse: this.complementAdresse.toString(),
                c__codePostal: this.codePostal.toString(),
                c__NoCompteContrat: this.NoCompteContrat.toString(),
                c__NoCompteContratMaj: this.NoCompteContratMaj.toString(),
                c__ville: this.ville.toString(),
                c__recordId: this.recordid,
                c__IdBusinessPartner: this.IdBusinessPartner,
                c__solde: this.soldeDelaiPaiement,
                c__soldeFormat: this.soldeFormater,
                c__AccountId: this.AccountId,
                c__iBAN: this.iBAN,
                c__nomInstitutBancaire: this.nomInstitutBancaire,
                c__EnqSat:this.EnqSat
            }
        }); 
    }

    // faire appel à DossierAffaire
   callIPConsulterPaiement(params, name) {
   
    console.log("calling IP ConsulterPaiement");
    console.log(params);
    callIP({ inputMap: params, NameIntergation: name })
    .then(result => {
        
        if (result.ConsulterPaiementResult!=null) {
          this.consulterPaiementResult = result.ConsulterPaiementResult;
          //console.log("IP ConsulterPaiement DATA :" +JSON.stringify(this.consulterPaiementResult));
         

          //listPaiement_Paiement_datePaiement (les 3 plus récents)+ listPaiement_Paiement_montantTTC (les 3 plus récents)

          this.listPconsulterPaiementResult=this.consulterPaiementResult.listPaiement;
         
          const  arraySortedL = this.listPconsulterPaiementResult.sort((a, b) => new Date(b.datePaiement).valueOf()-new Date(a.datePaiement).valueOf())
          
          let arraySize = arraySortedL.length > 3 ? 3 : arraySortedL.length;

          for (let index = 0; index < arraySize; index++) {
            this.arrayLValue[index] = arraySortedL[index];
            this.arrayLValue[index].datePaiementValue=this.arrayLValue[index].datePaiement;
            this.arrayLValue[index].datePaiement=this.FormaterDateConsulterPaiement(this.arrayLValue[index].datePaiement);
            this.arrayLValue[index].montantTTC=parseFloat(this.arrayLValue[index].montantTTC).toFixed(2).replace(".", ",") + ' €';
            //FT2-1420 
            this.arrayLValue[index].typePiece= this.arrayLValue[index].typePiece.libelleCourt ? this.arrayLValue[index].typePiece.libelleCourt : '';
            
    }

      }
    })
    .catch(error => {
      this.error = true;
      // this.loadTabs = true;
      console.log("error while IP ConsulterPaiement DATA", name , error);
    });
  }

  // faire appel à DossierAffaire
  callIPConsulterPlanApurement(params, name) {
    console.log("calling  IP_SM_consulterPlanApurement");
    console.log(params);
   
    callIP({ inputMap: params, NameIntergation: name })
    .then(result => {
        if (result.Result!=null) {
          this.consulterPlanApurement = result.Result      
          if(this.consulterPlanApurement.planApurement!=null){
              this.isPlanApurementData="OUI";
              this.planApurementEnCoursValue='O';
              this.planApurementStatutRadio = true;
              if(this.consulterPlanApurement && this.consulterPlanApurement.planApurement){
                if(this.consulterPlanApurement.planApurement.statutPA==='désactivé'){
                    this.planApurementEnCoursValue='N';
                    this.planApurementStatutRadio = false;
                }
              }
          }
          console.log(" IP_SM_consulterPlanApurement DATA:" +JSON.stringify(this.consulterPlanApurement));
        }
    })
    .catch(error => {
      this.error = true;
      // this.loadTabs = true;
      console.log("error while IP_SM_consulterPlanApurement DATA", name , error);
    });
  }
   callIP(params, name) {
      callIP({ inputMap: params, NameIntergation: name })
        .then(result => {
          if( result ) {
          
              this.noData = result.length > 0 ? false : true;
              this.noDataBis = this.noData;
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
            this.noDataBis = true;
          }
        })
        .catch(error => {
          this.error = true;
          console.log("got error callIP", name , error);
        });
    }

    //Creer formulaire dossier solidarité

    creerDossier() {            
      this.openFormModal = true;
    }

    annulerCreationDossier() {     

      this.openFormModal = false;
    }

     // FT2-1247 -----> Modification dossier solidarité
    
  modifier(e){
    this.openEditFormModal = true;
    this.modifyDSError = false;
    this.indexVal = e.currentTarget.dataset.key;
    this.fillDossierData(e); 
  }
  fillDossierData(e){
    this.etapesPrecedentes = [];
    this.etapes = [];
    var indexValue = e.currentTarget.dataset.key;
    this.numeroDossier = this.dossiersAffaire[indexValue].retourLireDALoop.idDossierAffaire;
    this.dateEffet = this.dossiersAffaire[indexValue].retourLireDALoop.dateCreationDossierAffaire;
    this.description = this.dossiersAffaire[indexValue].retourLireDALoop.description;
    this.statutDossierFieldData = this.dossiersAffaire[indexValue].retourLireDALoop.statutDossierlibelleCourt;
    this.editCategoryFieldData = this.dossiersAffaire[indexValue].retourLireDALoop.canalDossierAffaireLibelle;
    this.typeAideFieldData = this.dossiersAffaire[indexValue].retourLireDALoop.typeAideDossierAffaireLibelle;
    this.stageFieldData = this.dossiersAffaire[indexValue].FirstJalon.typeDate.libelleCourt;
    this.commentaireFieldData = this.dossiersAffaire[indexValue].retourLireDALoop.commentaire;
    this.existingCategory = this.categoryMap.get(this.editCategoryFieldData);
    this.existingTypeAide = this.typeAide.get(this.typeAideFieldData);
    this.existingStatutDossier = this.statutDossier.get(this.statutDossierFieldData);
    let key = this.stageFieldDataOptions.controllerValues[this.existingStatutDossier];
      this.etapeOptions = this.stageFieldDataOptions.values.filter(opt => opt.validFor.includes(key));
    this.existingEtape = this.etape.get(this.stageFieldData);
    // Recuperer les etapes précedentes 
    /*console.log('Code status dossier au chargement du popup');
    console.log(this.existingStatutDossier);
    console.log('libelle status dossier au chargement du popup');
    console.log(this.statutDossierFieldData);*/
    if(this.dossiersAffaire[indexValue].sortedJalons.length > 1){
      for (let index = 0; index < this.dossiersAffaire[indexValue].sortedJalons.length ; index++) {
        this.etapes[index] = this.dossiersAffaire[indexValue].sortedJalons[index];
        this.etapes[index].label1=this.dossiersAffaire[indexValue].sortedJalons[index].typeDate.libelleCourt;
        this.etapes[index].code = this.dossiersAffaire[indexValue].retourLireDALoop.idDossierAffaire + this.dossiersAffaire[indexValue].sortedJalons[index].typeDate.code;
        this.etapes[index].codeModif = this.dossiersAffaire[indexValue].sortedJalons[index].typeDate.code;
        this.etapes[index].valeurDate = this.dossiersAffaire[indexValue].sortedJalons[index].valeurDate;
        this.etapes[index].value = index;
      }
    }else{
      this.etapes[0] = this.dossiersAffaire[indexValue].FirstJalon;
      this.etapes[0].label1= this.dossiersAffaire[indexValue].FirstJalon.typeDate.libelleCourt;
      this.etapes[0].code = this.dossiersAffaire[indexValue].retourLireDALoop.idDossierAffaire + this.dossiersAffaire[indexValue].FirstJalon.typeDate.code;
      this.etapes[0].codeModif = this.dossiersAffaire[indexValue].FirstJalon.typeDate.code;
      this.etapes[0].valeurDate = this.dossiersAffaire[indexValue].FirstJalon.valeurDate;
      this.etapes[0].value = 0;
    }
    // Affiche des 6 derniers jalons
    if(this.etapes.length>=6){
    this.etapesPrecedentes = this.etapes.slice(this.etapes.length-6,this.etapes.length);
    this.etapesPrecedentes.reverse();
    }
    else{
      this.etapesPrecedentes = this.etapes.slice(0,this.etapes.length);
      this.etapesPrecedentes.reverse();
    }
  }

  // FT2-1248 Ajout du bouton annuler
  annulerEditDossier(){
    this.openEditFormModal = false;
    this.description = '';
    this.existingStatutDossier = '';


    this.statutDossierFieldData = '';//FT2-1504 Smile Affichage message bouton créer dossier
    this.existingCategory = '';
    this.existingTypeAide = '';
    this.typeAideFieldData = '';//FT2-1504 Smile Affichage message bouton créer dossier
    this.existingEtape = '';
    this.stageFieldData = '';//FT2-1504 Smile Affichage message bouton créer dossier


    this.commentaireFieldData = '';
  }
  // FT2-1248 Ajout du bouton Mettre à jour
  saveEditDossier(){
    this.etapeCode1 = '';
    this.etapeValeurDate1 = '';
    this.etapeCode2 = '';
    this.etapeValeurDate2 = '';
    this.etapeCode3 = '';
    this.etapeValeurDate3 = '';
    this.etapeCode4 = '';
    this.etapeValeurDate4 = '';
    this.etapeCode5 = '';
    this.etapeValeurDate5 = '';
    this.etapeCode6 = '';
    this.etapeValeurDate6 = '';
    this.etapeCode7 = '';
    this.etapeValeurDate7 = '';
    this.etapeCode8 = '';
    this.etapeValeurDate8 = '';
    this.etapeCode9 = '';
    this.etapeValeurDate9 = '';
    this.etapeCode10 = '';
    this.etapeValeurDate10 = '';
    this.etapeCode11 = '';
    this.etapeValeurDate11 = '';
    this.etapeCode12 = '';
    this.etapeValeurDate12 = '';
    this.etapeCode13 = '';
    this.etapeValeurDate13 = '';
    this.etapeCode14 = '';
    this.etapeValeurDate14 = '';
    this.etapeCode15  = '';
    this.etapeValeurDate15 = '';
    this.modifyDSError = false;
    // appeler l'ip avec des infos a enregistrer
    var datenow = new Date();
    var etapeValeurDate = '';
    etapeValeurDate =datenow.toISOString().split('.')[0];
    if((this.description === undefined || this.description === null || this.description === '') || 
      (this.existingStatutDossier === undefined || this.existingStatutDossier === null || this.existingStatutDossier === '') || 
      (this.existingCategory === undefined || this.existingCategory === null || this.existingCategory === '') || 
      (this.existingTypeAide === undefined || this.existingTypeAide === null || this.existingTypeAide === '') || 
      (this.existingEtape === undefined || this.existingEtape === null || this.existingEtape === '') || 
      (this.commentaireFieldData === undefined || this.commentaireFieldData === null || this.commentaireFieldData === '')){ 
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
          element.reportValidity();
        });
        this.template.querySelectorAll('lightning-input').forEach(element => {
          element.reportValidity();
        });
        if(this.commentaireFieldData == ''){
          this.template.querySelector('.errorEditComment').innerHTML="Remplissez ce champ.";
        }else{
          this.template.querySelector('.errorEditComment').innerHTML="";
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Veuillez remplir tous les champs obligatoires',
                variant: 'error',
            }),
        );
      } else {
        this.etapeCode1 = this.etapes[0].codeModif;
        this.etapeValeurDate1 = this.etapes[0].valeurDate;
        let longueur = this.etapes.length;
        // il faut ajouter la nouvelle valeur si l'etape est modifié (on ajoute la nouvelle valeur sur etapecodeX)
        if(this.existingEtapeToUpdate && this.etapes[longueur-1].codeModif!=this.existingEtapeToUpdate){
          this.etapes[longueur] = this.dossiersAffaire[0].FirstJalon;
          this.etapes[longueur].codeModif =  this.existingEtape;
          this.etapes[longueur].valeurDate = etapeValeurDate;
          this.etapes[longueur].value = longueur;
        }
        if(this.etapes[1]){
          this.etapeCode2 = this.etapes[1].codeModif;
          this.etapeValeurDate2 = this.etapes[1].valeurDate;
        }
        if(this.etapes[2]){	
          this.etapeCode3 = this.etapes[2].codeModif;
          this.etapeValeurDate3 = this.etapes[2].valeurDate;
        }
        if(this.etapes[3]){
          this.etapeCode4 = this.etapes[3].codeModif;
          this.etapeValeurDate4 = this.etapes[3].valeurDate;
        }
        if(this.etapes[4]){
          this.etapeCode5 = this.etapes[4].codeModif;
          this.etapeValeurDate5 = this.etapes[4].valeurDate;
        }
        if(this.etapes[5]){
          this.etapeCode6 = this.etapes[5].codeModif;
          this.etapeValeurDate6 = this.etapes[5].valeurDate;
        }
        if(this.etapes[6]){
          this.etapeCode7 = this.etapes[6].codeModif;
          this.etapeValeurDate7 = this.etapes[6].valeurDate;
        }    
        if(this.etapes[7]){
          this.etapeCode8 = this.etapes[7].codeModif;
          this.etapeValeurDate8 = this.etapes[7].valeurDate;
        }    
        if(this.etapes[8]){
          this.etapeCode9 = this.etapes[8].codeModif;
          this.etapeValeurDate9 = this.etapes[8].valeurDate;
        }
        if(this.etapes[9]){
          this.etapeCode10 = this.etapes[9].codeModif;
          this.etapeValeurDate10 = this.etapes[9].valeurDate;
        }
        if(this.etapes[10]){
          this.etapeCode11 = this.etapes[10].codeModif;
          this.etapeValeurDate11 = this.etapes[10].valeurDate;
        }
        if(this.etapes[11]){
          this.etapeCode12 = this.etapes[11].codeModif;
          this.etapeValeurDate12 = this.etapes[11].valeurDate;
        }
        if(this.etapes[12]){
          this.etapeCode13 = this.etapes[12].codeModif;
          this.etapeValeurDate13 = this.etapes[12].valeurDate;
        }
        if(this.etapes[13]){
          this.etapeCode14 = this.etapes[13].codeModif;
          this.etapeValeurDate14 = this.etapes[13].valeurDate;
        }
        if(this.etapes[14]){
          this.etapeCode15 = this.etapes[14].codeModif;
          this.etapeValeurDate15 = this.etapes[14].valeurDate;
        }
        /*console.log('this.existingCategory');
        console.log(this.existingCategory);
        console.log('this.commentaireFieldData');
        console.log(this.commentaireFieldData);
        console.log('this.description');
        console.log(this.description);
        console.log('this.existingTypeAide');
        console.log(this.existingTypeAide);
        console.log('this.etapeCode1');
        console.log(this.etapeCode1);
        console.log('this.etapeCode2');
        console.log(this.etapeCode2);
        console.log('this.etapeCode3');
        console.log(this.etapeCode3);
        console.log('this.etapeCode4');
        console.log(this.etapeCode4);
        console.log('this.etapeCode5');
        console.log(this.etapeCode5);
        console.log('this.etapeValeurDate5');
        console.log(this.etapeValeurDate5);
        console.log('this.etapeCode6');
        console.log(this.etapeCode6);
        console.log('this.etapeValeurDate6');
        console.log(this.etapeValeurDate6);
        console.log('this.existingEtapeToUpdate');
        console.log(this.existingEtapeToUpdate);
        console.log('this.existingStatutDossier');
        console.log(this.existingStatutDossier);*/
        this.isLoading = true;
        this.callIPModifierDossierAffaire({ 
          iddossierAffaire: this.numeroDossier,
          description: this.description, 
          statutDossierAffaireCode : this.existingStatutDossier, 
          //statusDossierAffaireLibelleCourt: this.statutDossierFieldData, 
          canalDossierAffaireCode : this.existingCategory, 
          // canalDossierAffaireLibelleCourt : "Back office", 
          typeAideDossierAffaireCode: this.existingTypeAide, 
          // typeAideDossierAffaireLibelleCourt: "Aide CCAS conventionnée", 
          commentaireConseiller : this.commentaireFieldData,
          typeDossierAffaireCode: "ZSOL",
          etapeCode1 : this.etapeCode1,
          etapeValeurDate1: this.etapeValeurDate1,
          etapeCode2 : this.etapeCode2,
          etapeValeurDate2: this.etapeValeurDate2,
          etapeCode3 : this.etapeCode3,
          etapeValeurDate3: this.etapeValeurDate3,
          etapeCode4 : this.etapeCode4,
          etapeValeurDate4: this.etapeValeurDate4,
          etapeCode5 : this.etapeCode5,
          etapeValeurDate5: this.etapeValeurDate5,
          etapeCode6 : this.etapeCode6,
          etapeValeurDate6:this.etapeValeurDate6,
          etapeCode7 :this.etapeCode7,
          etapeValeurDate7:this.etapeValeurDate7,
          etapeCode8 :this.etapeCode8,
          etapeValeurDate8:this.etapeValeurDate8,   
          etapeCode9 :this.etapeCode9,
          etapeValeurDate9:this.etapeValeurDate9,
          etapeCode10 :this.etapeCode10,
          etapeValeurDate10:this.etapeValeurDate10,
          etapeCode11 :this.etapeCode11,
          etapeValeurDate11:this.etapeValeurDate11,
          etapeCode12 :this.etapeCode12,
          etapeValeurDate12:this.etapeValeurDate12,
          etapeCode13 :this.etapeCode13,
          etapeValeurDate13:this.etapeValeurDate13,
          etapeCode14 :this.etapeCode14,
          etapeValeurDate14:this.etapeValeurDate14,
          etapeCode15 : this.etapeCode15,
          etapeValeurDate15:this.etapeValeurDate15
        }, 'IP_SM_Modifier_Dossier_Affaire_SOAP');
        
        //lire dossier affaire
        this.callIPLireDossierAffaire({idPersonne: this.IdBusinessPartner,typeDossierAffaire: "ZSOL"}, 'IP_SM_LireDossierAffaire_LOOP');
      }     
  }
 
  // FT2-1261 Faire appel à modifierDossierAffaire: IP_SM_Modifier_Dossier_Affaire
  callIPModifierDossierAffaire(params, name) {
    console.log("calling IP_SM_Modifier_Dossier_Affaire");
    callIP({ inputMap: params, NameIntergation: name })
    .then(result => {
      console.log("result :", result);
      if (result) {
        this.showSpinnerLoading = true;
        this.isLoading= false;
        //ModifierDAResponseId
        var codeRetourMaj = result.ModifierDAResponseCode;
        if(codeRetourMaj=== 'OCTOPUS_MAJDossierAffaire_00'){
          const evt = new ShowToastEvent({
            title: "Succès",
            message: 'La modification du dossier N°'+ this.numeroDossier+' a bien été prise en compte',
            variant: 'success'
          });
          this.dispatchEvent(evt);
          this.openEditFormModal = false;
        }else{
          this.etapes = this.etapes.splice(0,this.etapes.length-2);
          this.modifyDSError = true;
        }
    }else{
        this.isLoading= false;
        this.etapes = this.etapes.splice(0,this.etapes.length-2);
        this.modifyDSError = true;
      }
    })
  }

  
  editDossierStatusHandleChange(event) {
    this.existingStatutDossier= event.target.value;
    let key = this.stageFieldDataOptions.controllerValues[event.target.value];
    this.etapeOptions = this.stageFieldDataOptions.values.filter(opt => opt.validFor.includes(key));
    var containsExistingEtape= false;
    for (let index = 0; index < this.etapeOptions.length ; index++) {
      if(this.etapeOptions[index].value==this.existingEtape){
        containsExistingEtape = true;
      }
    }
    if(!containsExistingEtape){
      this.existingEtape='';
    }
  }

  editDescriptionHandleChange(event) {
    this.description = event.target.value;
  }
  editCategoryHandleChange(event){
    this.existingCategory = event.target.value; 
  }
  editTypeHandleChange(event){
    this.existingTypeAide = event.target.value; 
  }
  editEtapeHandleChange(event){
    this.existingEtape = event.target.value; 
    this.existingEtapeToUpdate = this.existingEtape;
  }
  editHandleComment(event){
    this.commentaireFieldData = event.target.value; 
  }

// FT2-1250 faire appel à CreerDossierAffaire : IP_SM_Creer_Dossier_Affaire

  descriptionHandleChange(event){

    this.description = event.target.value; 
  }
    /*dossierStatusHandleChange(event){
      this.statutDossierFieldData = event.target.value; 
    }*/

    categoryHandleChange(event){
      this.CategoryFieldData = event.target.value; 
    }

    typeHandleChange(event){
      this.typeAideFieldData = event.target.value; 
    }

    EtapeHandleChange(event){
      this.stageFieldData = event.target.value;
    }

    handleComment(event){
      this.commentValue = event.target.value;
    }

    //Add row dynamically
    /*index = 0;
    dossierAffaire = {
      typeDossierAffaire: "ZSOL",
      stageFieldData: this.stageFieldData
    };*/
    callIPCreerDossierAffaire(params, name) {
      console.log("calling IP_SM_Creer_Dossier_Affaire");
      callIP({ inputMap: params, NameIntergation: name })
      .then(result => {
        console.log(result);
        if (result && result.CreerDAResponseId) {
          
          this.idAffaire = result.CreerDAResponseId;
          console.log("IP_SM_Creer_Dossier_Affaire DATA:" +JSON.stringify(result.CreerDAResponseId)); 
          // toast message if success
          if(this.idAffaire){
            const evt = new ShowToastEvent({
              title: "Succès",
              message: 'La création du dossier a été effectuée',
              variant: 'success'
            });
            this.dispatchEvent(evt);
            this.isLoading = false;
            this.openFormModal = false;
            
            eval("$A.get('e.force:refreshView').fire();");
            
          }else{
      
            const evt = new ShowToastEvent({
              title: 'Une erreur est survenue et le dossier n’a pas été créé',
              variant: 'error'
            });
            this.dispatchEvent(evt);
            this.isLoading = false;
            this.openFormModal = true;
          }
        } else{
          const evt = new ShowToastEvent({
            title: 'Une erreur est survenue et le dossier n’a pas été créé',
            variant: 'error'
          });
          this.dispatchEvent(evt);
          this.openFormModal = true;
          this.isLoading = false;
        }
      })
    }
    
    saveCreationDossier() { 
       // Setting boolean variable to true, this will show the Spinner
       this.isLoading = true;

      if((this.description === undefined || this.description === null || this.description === '') || 
      (this.statutDossierFieldData === undefined || this.statutDossierFieldData === null || this.statutDossierFieldData === '') || 
      (this.CategoryFieldData === undefined || this.CategoryFieldData === null || this.CategoryFieldData === '') || 
      (this.typeAideFieldData === undefined || this.typeAideFieldData === null || this.typeAideFieldData === '') || 
      (this.stageFieldData === undefined || this.stageFieldData === null || this.stageFieldData === '') || 
      (this.commentValue === undefined || this.commentValue === null || this.commentValue === '')){
     
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
          element.reportValidity();
          });
          this.template.querySelectorAll('lightning-input').forEach(element => {
            element.reportValidity();
          });
        
          if(this.commentValue == null){
            this.template.querySelector('.errorCreerComment').innerHTML="Remplissez ce champ.";
          }else{
            this.template.querySelector('.errorCreerComment').innerHTML="";
          }
         
          /*if(this.commentValue == null){
            this.template.querySelector('.errorContratResil').innerHTML="Remplissez ce champ.";
          }else{
            this.template.querySelector('.errorContratResil').innerHTML="";
          }*/
          this.dispatchEvent(
            new ShowToastEvent({
                title: 'Veuillez remplir tous les champs obligatoires',
                variant: 'error',
            }),
        );
        this.isLoading = false;
        
      } else {
        this.callIPCreerDossierAffaire({ 
          idPersonne: this.IdBusinessPartner, idCompteClient: this.NoCompteContrat, description: this.description, 
          statutDossierAffaireCode: this.statutDossierFieldData, 
          canalDossierAffaireCode : this.CategoryFieldData, 
          typeAideDossierAffaireCode: this.typeAideFieldData, 
          etapeCode: this.stageFieldData, commentaireConseiller : this.commentValue, typeDossierAffaire: "ZSOL"
        }, 'IP_SM_Creer_Dossier_Affaire_SOAP'); 

        console.log('Api name '+ this.statutDossierFieldData);
        
        console.log('Api name '+ this.typeAideFieldData);
        
        //lire dossier affaire
        this.callIPLireDossierAffaire({idPersonne: this.IdBusinessPartner,typeDossierAffaire: "ZSOL"}, 'IP_SM_LireDossierAffaire_LOOP');

      }          
      
    }

    get showSpinner() {
      return  this.DRId_Case || (this.dossiersAffaire && this.dossiersAffaire.length > 0) || this.noDataBis  || this.error;
    }
    cancelCreationDossier() { 
      this.description = '';
      this.statutDossierFieldData = '';
      this.CategoryFieldData = '';
      this.typeAideFieldData = '';
      this.stageFieldData = '';
      this.openFormModal = false;
    }
    // Valeur de picklist sans recordType 

    @wire(getObjectInfo,{objectApiName: SM_DOSSIERSOLIDARITETECH_OBJECT})
    objectInfo;
    
   // Category field
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId',fieldApiName: CATEGORY_FIELD})
    categoryPicklistValues({data,error}){
      if(data){
        this.categoriesOptions = data.values;

        this.categoriesOptions.forEach(cat=>{
          this.categoryMap.set(cat.label,cat.value);
          });

        this.error = undefined;
      }
      if(error){
        this.error = error;
        this.categoriesOptions = undefined;
      }
    }
    // Type aide field
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId',fieldApiName: TYPE_AIDE_FIELD })
    typeAidePicklistValues({data,error}){
    if(data){
      this.typeOptions = data.values;

      this.typeOptions.forEach(type=>{
        this.typeAide.set(type.label,type.value);
        });

      this.error = undefined;
    }
    if(error){
      this.error = error;
      this.typeOptions = undefined;
    }
  }

  // Dependent picklist
    
    @wire(getPicklistValues, {recordTypeId:'$objectInfo.data.defaultRecordTypeId', fieldApiName: ETAPE_FIELD})
    stagePicklistValues({data,error}){
      if(data){

        this.stageField = data.values;
        this.stageField.forEach(eta=>{
          this.etape.set(eta.label,eta.value);
        });

        this.stageFieldDataOptions = data;
        this.error = undefined;
      }
      if(error){
        this.error = error;
        this.stageFieldDataOptions = undefined;
      }
    }

    @wire(getPicklistValues, {recordTypeId:'$objectInfo.data.defaultRecordTypeId', fieldApiName: STATUT_DOSSIER_FIELD})
    dossierStatusPicklistValues({data,error}){
      if(data){
        this.statutDossierOptions = data.values;

        this.statutDossierOptions.forEach(stage=>{
          this.statutDossier.set(stage.label,stage.value);
        });

        this.error = undefined;
      }
      if(error){
        this.error = error;
        this.statutDossierOptions = undefined;
      }
    }

    dossierStatusHandleChange(event) {
      this.statutDossierFieldData = event.target.value; 
      console.log('event.target.value '+ event.target.value);
      let key = this.stageFieldDataOptions.controllerValues[event.target.value];
      console.log('keyyyyy '+ key);
      this.etapeOptions = this.stageFieldDataOptions.values.filter(opt => opt.validFor.includes(key));
      console.log(this.etapeOptions);
   }


   // FT2-1254 get Motif Picklist values
   @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId',fieldApiName: MOTIF_FIELD})
   motifPicklistValues({data,error}){
     if(data){


       console.log(data);
       this.motifsOptions = data.values;

       this.motifsOptions.forEach(motiff=>{
        this.motifCB.set(motiff.label,motiff.value);
      });



       this.error = undefined;
     }
     if(error){
       this.error = error;
       this.motifsOptions = undefined;
     }
   }

    //FT2-1265 Ouverture écran blocage pour un client bloqué
    callIPLireCompteClient(params, name) {
      callIP({inputMap: params, NameIntergation: name })
      .then(result => {
        if(result) { 
          if(result.FirstBlocage){
            let tempDateDebutCB = result.FirstBlocage.dateDebutBlocage.split("T")[0].split('-');
            let tempDateFinCB = result.FirstBlocage.dateFinBlocage.split("T")[0].split('-');
            this.dateDebutCB = tempDateDebutCB[0] + '/' + tempDateDebutCB[1] + '/' + tempDateDebutCB[2];
            this.dateFinCB = tempDateFinCB[0] + '/' + tempDateFinCB[1] + '/' + tempDateFinCB[2];
            this.valueMotifCB = result.FirstBlocage.motifBlocage.libelleCourt;
            //this.blocageRelance = 'OUI';
            //this.typeDeBlocage = result.FirstBlocage.motifBlocage.libelleCourt;

            //FT2-1513 Mise à jour des infos de blocage après une suppression
            let today = new Date();
            let tempToday = today.toISOString().split("T")[0].split('-');
            tempToday = new Date(tempToday[0] + '-' + tempToday[1] + '-' + tempToday[2] + 'T00:00:00.0');
    
    
    
            if(tempToday >= new Date(result.FirstBlocage.dateDebutBlocage) && tempToday <= new Date(result.FirstBlocage.dateFinBlocage) && (new Date(result.FirstBlocage.dateDebutBlocage) != new Date(result.FirstBlocage.dateFinBlocage))){
            this.blocageRelance = 'OUI';
            this.typeDeBlocage = result.FirstBlocage.motifBlocage.libelleCourt;
          }

             else {
               this.blocageRelance = 'NON';
               this.typeDeBlocage = '';
              }
          }

        }
        
    })}

    // FT2-1266 Gestion des boutons écran blocage d'un client non bloqué Call IP_SM_MAJCompteClient_SOLI_WS
    callIPMAJCompteClientSOLIWS(params, name) {

      callIP({inputMap: params, NameIntergation: name })
      .then(result => {

        if(result && result.MAJCompteClient) {

            this.code = result.MAJCompteClient.code; 

            //if the web service call is successful
            if(this.code === "OCTOPUS_MAJCompteClient_01"){

              const evt = new ShowToastEvent({
                title: "La création du blocage a bien été faite",
                variant: 'success',
              });
              this.dispatchEvent(evt);

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

              this.blocageRelance = 'NON';
              this.typeDeBlocage = '';

            }
              
        }
    })}



    // FT-1342 Modification d'un blocage client bloqué
    callIPMAJCompteClientSOLIWSModification(params, name) {
 
      callIP({inputMap: params, NameIntergation: name })
      .then(result => {
          console.log(result);
        if(result && result.MAJCompteClient) {
 
            this.code = result.MAJCompteClient.code; 
 
            //if the web service call is successful
            if(this.code === "OCTOPUS_MAJCompteClient_01"){
 
              const evt = new ShowToastEvent({
                title: "La modification du blocage a bien été faite",
                variant: 'success',
              });
              this.dispatchEvent(evt);
 
              this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');
              this.openBlocageRelancesCBModification = false;
              this.openBlocageRelancesCB = true;
            }  
            else{
 
              const evt = new ShowToastEvent({
                title: "Un problème technique est survenu et la modification n’a pas pu se faire",
                variant: 'error',
              });
              this.dispatchEvent(evt);
 
              this.blocageRelance = 'NON';
              this.typeDeBlocage = '';
            }
              
        }
    })}




    // FT2-1341 Gestion des boutons écran blocage d'un client bloqué Call IP_SM_MAJCompteClient_SOLI_WS
    callIPMAJCompteClientSOLIDeleteWS(params, name) {

      callIP({inputMap: params, NameIntergation: name })
      .then(result => {

        if(result && result.MAJCompteClient) {

            this.code = result.MAJCompteClient.code; 

            //if the web service call is successful
            if(this.code === "OCTOPUS_MAJCompteClient_01"){

              const evt = new ShowToastEvent({
                title: "Blocage supprimé avec succès",
                variant: 'success',
              });
              this.dispatchEvent(evt);

              this.openBlocageRelances = true;
              this.openBlocageRelancesCNB = true;
              this.openBlocageRelancesCB = false;
              this.blocageRelance = 'NON';
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
    })}


    // FT2-1254 call IP_SM_SyntheseDossierRecouvrement_SOAP
    callIPSyntheseDossierRecouvrement(params, name) {

      callIP({inputMap: params, NameIntergation: name })
      .then(result => {

          if(result && result.JalonList && result.JalonList.Jalons.length != 0) {
            
              this.histoParcoursRelance= result.JalonList.Jalons;
              this.dataFormat(this.histoParcoursRelance);
              console.log('histoParcoursRelance');
              //console.log(this.histoParcoursRelance);

          } else if (result.success === false) {

              this.error = true;
          }else {
            this['noDataJalons'] = true;
            console.log("Un problème est survenue lors du chrgement de l'historique de consommation");
          }

           

      }).catch(error => {
          console.log("got error IP_SM_SyntheseDossierRecouvrement_SOAP", error);
      });
    }

    // FT2-1254 sort output's result by NFacture

    dataFormat(dataInput){

      let groupedMap = new Map();

      dataInput.forEach(jalon => {

      let temp = jalon.jalonDate.split("T")[0].split('-');
         
      if (groupedMap.has(jalon.jalonNumeroFacture)) {

        jalon.jalonDate =  temp[2] + '/' + temp[1] + '/' + temp[0];
        groupedMap.get(jalon.jalonNumeroFacture).jalons.push(jalon);
      
      } else {

        let newJalon = {};
                
        newJalon.jalonNumeroFacture = jalon.jalonNumeroFacture;
        jalon.jalonDate =  temp[2] + '/' + temp[1] + '/' + temp[0]; 

        newJalon.jalons = [jalon];
        groupedMap.set(jalon.jalonNumeroFacture, newJalon);

      }
        
      });
  

      let itrJalons = groupedMap.values();
      let resultJalons = itrJalons.next();

      //Calculate Rowspan
      while (!resultJalons.done) {

          resultJalons.value.rowspan = resultJalons.value.jalons.length + 1;
          
          this.productJalonArray.push(resultJalons.value);
          
          resultJalons = itrJalons.next();
      }

      //Get only the first n values of the array 
      let n = 6;
      this.productArray = this.productJalonArray.slice(0,n);
    }


    connectedCallback() {
 
      // faire appel à API personne pour la récupération des infos cheques energie
      this.callIPGetDetailsPersonnes({contactId:this.recordId},constant.IPGetDetailsPersonnes);
      this.callIPConsulterPlanApurement({idPersonne: this.IdBusinessPartner, statutPA : "ACTIVE", statutPAlibelleCourt :"actif" }, 'IP_SM_consulterPlanApurement_SOAP');
      this.callIPConsulterPaiement({idPersonne: this.IdBusinessPartner,idCompteClient: this.NoCompteContrat}, 'IP_SM_ConsulterPaiement_SOAP');
      this.callIPLireDossierAffaire({idPersonne: this.IdBusinessPartner,typeDossierAffaire: "ZSOL"}, 'IP_SM_LireDossierAffaire_LOOP');
      //FT2-1513 Mise à jour des infos de blocage après une suppression
      this.callIPLireCompteClient({CompteClient: this.NoCompteContrat}, 'IP_SM_CompteClient_Solde');
      // FT2-1254 call IP_SM_SyntheseDossierRecouvrement_SOAP
      if(this.idDossierRecouvrement && this.idDossierRecouvrement != null && this.idDossierRecouvrement != ''){
      this.idDossierRecouvrement = this.idDossierRecouvrement.replaceAll('"','');
      this.callIPSyntheseDossierRecouvrement({IdPersonne: this.IdBusinessPartner,CompteClient: this.NoCompteContrat,IdDossierRecouvrement: this.idDossierRecouvrement}, 'IP_SM_SyntheseDossierRecouvrement_SOAP');

      }

      if(this.blocageRelance === 'NON' ){
        this.typeDeBlocage = '';
      }

      getArticleByCleMigration({inputMap: {
                cleMigration: this.getCleMigration}})
            .then(result => {
                //console.log(result.article);
                this.articleKnowledge = result.article;
            })
            .catch(error => {
                console.error("Erreur GetKnowledge ", error);
            });

 
           

    }
}