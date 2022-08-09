/**
 * @author Lahoucine Ikerchalene
 */
 import { LightningElement, track, api, wire } from 'lwc';
 import { NavigationMixin } from 'lightning/navigation';
 import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 import getSuggestionsAdressApi from '@salesforce/apex/HP_APIGouv.getSuggestions';
 import emailPhoneVerifApi from '@salesforce/apex/SM_AP77_EmailPhoneVerificationService.invokeMethodLWC';
 import majPersonne from '@salesforce/apex/SM_AP61_PersonneOctopus.invokeMethodLWC';
 import lirePersonne from '@salesforce/apex/SM_AP61_PersonneOctopus.invokeMethodLWC';
 import { getObjectInfo } from 'lightning/uiObjectInfoApi';
 import { getPicklistValues } from 'lightning/uiObjectInfoApi';
 import { getRecord , getFieldValue} from 'lightning/uiRecordApi';
 import CONTACT_OBJECT from '@salesforce/schema/Contact';
 import MOBILE_PRINCIPAL_FIELD from '@salesforce/schema/Contact.Mobile_Principal__c';
 import TELFIXE_PRINCIPAL_FIELD from '@salesforce/schema/Contact.Tel_Fixe_Principal__c';
 import EMAIL_PRINCIPAL_FIELD from '@salesforce/schema/Contact.Adresse_Mail_Principale__c';
 import SALUT_TIERS from '@salesforce/schema/Contact.ID_Tiers__c';
 import IDENTIFIANT_BUISNESS_PARTENER from '@salesforce/schema/Contact.Identifiant_Buisness_Partener__c';
 import getQuestionsConsements from '@salesforce/apex/ConsentementsHandler.getConsentementsQuestions';
 import getConsentementAnswersData from "@salesforce/apex/SM_ConsentementAnswers_API.getConsentementAnswersData";
 import updateConsentement from "@salesforce/apex/SM_ConsentementAnswers_API.updateConsentement";
 import SM_modifAdresseOption from '@salesforce/label/c.SM_modifAdresseOption';
 import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
 import { publish, MessageContext } from "lightning/messageService";
 import NPAI_FLAG from "@salesforce/messageChannel/sm_npaiflagnotification__c";
 import fetchSmileQuestions from '@salesforce/apex/ConsentementsHandler.fetchSmileQuestions';
 const FIELDS = [SALUT_TIERS, IDENTIFIANT_BUISNESS_PARTENER];
 export default class SM_ModifiyClientInfos_V2 extends NavigationMixin(LightningElement) {
     label = {
         SM_modifAdresseOption
     };
     // @api variables
     @api recordId;
     @api npaiFlag;
     @track questionsConsentements = null;
     @track contact;
     // @track variables
     @track listAddressResult;
     @track listComplementResult;
     @track addressSelected;
     @track showSpinner = false;
     @track isOpenModal = false;
     @track isAddressFieldEmpty = false;
     @track mobilePrincipalOptionsRestricted;
     @track telFixePrincipalOptionsRestricted;
     @track emailPrincipalOptionsRestricted;
     @track adresseChangeOptionsRestricted='';
     @track isDisabledAddressModified = true;
     @track isSendEmailOption = false;
     @track isDisplayStopsSpinner = true;
     @track isErrorCallWsStops = false;
     @track isStopsLoaded = false;
     @track errorMessageOctopusStops = '';
     @track techErrorMessageOctopusStops;

     // Variables DQE
     listNumErrorDQE = [];
     listEmailErrorDQE = [];
     @track msgEmailDQE1 = '';
     @track msgEmailDQE2 = '';
     @track msgEmailDQE3 = '';
     // Variables 
     isSaveToOctupusFinish;
     npaiFlagMessage = "Un code NPAI remonte sur l'adresse email. Merci de saisir une adresse valide";
     isInformErreurOctopus = false;
     informMessageOctopus = '';
     lstCodeInforErrorsOctopus = ['11'];
     isWarningErreurOctopus = false; 
     warningMessageOctopus = '';
     lstCodeWarnErrorsOctopus = ['07', '06'];
     smileQuestions = [];
     // Variables Erreur Format
     listNumErrorFormat = [];
     listEmailErrorFormat = [];
     errorVerifNum = false;
     // Variables Erreur Format
     listOpenSections = ['AdresseContact', 'TelephoneMobile', 'TelephoneFixe', 'Email', 'Consentements', 'Preference'];
     validAdressSelected = true;
     firstLoadPage = true;
     // Variables Mobile Inputs
     mobilePrincipalOptionsOriginal = [];
     mobile1Input;
     mobile2Input;
     mobile3Input;
     mobilePrincipalComboBox;
     // Variables Fixe Inputs
     telFixePrincipalOptionsOriginal = [];
     fixe1Input;
     fixe2Input;
     fixe3Input;
     fixePrincipalComboBox;
     // Variables Email Inputs
     emailPrincipalOptionsOriginal = [];
     email1Input;
     email2Input;
     email3Input;
     emailPrincipalComboBox;
     typeSearchAdress = true;
     emailPrefereOriginale;
     // Variables stops
     oldStops = {};
     newStops = {};
     //Params Recherche Manuelle
     ville = "";
     codePostal="";
     rue="";
     numero="";
     listVilles=[];
     listCodesPostaux=[];
     isCodePostalFieldEmpty = false;
     isCityFieldEmpty = false;
     isStreetFieldEmpty = false;
     listRues = null;
     listNumeros = null;
     selectedVille = false;
     selectedCodePostal = false;
     selectedRue = false;
     disabled = true;
     secondStep = false;
     cacherechercheAuto = null;
     // variables liées aux message channels
     @wire(MessageContext)
     messageContext;
 
     get msgEmail1() {
         return this.msgEmailDQE1;
     }
     get msgEmail2() {
         return this.msgEmailDQE2;
     }
     get msgEmail3() {
         return this.msgEmailDQE3;
     }

     // FT4-185 ajout de handle change des checkbox stops
     handleChangeStops(event) {
         if (event.target.name == 'stopPhoning') {
            this.newStops.stopPhoning = event.target.checked;
         }
         else if (event.target.name == 'stopAmeliorationExperienceClient') {
            this.newStops.stopAmeliorationExperienceClient = event.target.checked;
         }
         else if (event.target.name == 'stopMailing') {
            this.newStops.stopMailing = event.target.checked;
         }
         else if (event.target.name == 'stopAnalyseStatistique') {
            this.newStops.stopAnalyseStatistique = event.target.checked;
         }
         else if (event.target.name == 'stopEmailing') {
            this.newStops.stopEmailing = event.target.checked;
         }
         else if (event.target.name == 'stopProspectionCommerciale') {
            this.newStops.stopProspectionCommerciale = event.target.checked;
         }
         else if (event.target.name == 'stopSMSing') {
            this.newStops.stopSMSing = event.target.checked;
         }
         else if (event.target.name == 'stopPorteAPorte') {
            this.newStops.stopPorteAPorte = event.target.checked;
         }
     }

     NPAIFlagNotification(picklistValue){
         let emailIndex = this.removeSpace(picklistValue).substring(11);
         if(this.firstLoadPage){                 
                  this.emailPrefereOriginale = picklistValue;
                  this.flaggedEmail = this["email"+emailIndex+"Input"].value;
                  this.showNPAIFlag(emailIndex);
         }else{
             this.verfifyNPAIFlag();
         }
     }
     verfifyNPAIFlag(){
         let comboBoxEmailIndex = this.removeSpace(this.emailPrincipalComboBox.value).substring(11);
         let comboBoxEmail = this["email"+comboBoxEmailIndex+"Input"].value;
         // désactiver le flag
         this.clearNPAIFlag(); 
         // si l'adresse de péférence correspond à l'adresse flaggée, afficher le flag
         if(this.emailPrincipalComboBox.value && comboBoxEmail === this.flaggedEmail){
             this.showNPAIFlag(comboBoxEmailIndex);
         }
     }
     showNPAIFlag(emailIndex){
                  // récuperer le data-id du message affichée en dessous l'adresse mail flagée.
                  let msgId = "msgEmailDQE"+emailIndex;
                 // récuperer le data-id du l'adresse mail flagée.
                  let messageElementId =  "errorAdresseMail"+emailIndex+"DQE";
                  this[msgId] = this.npaiFlagMessage;
                  this.template.querySelector("[data-id="+messageElementId+"]").classList.remove('slds-hide');
     }
     clearNPAIFlag(){
                         // désactiver le flg NAPI pour les trois adresses mails
                         this.template.querySelector("[data-id=errorAdresseMail1DQE]").classList.add('slds-hide');
                         this.template.querySelector("[data-id=errorAdresseMail2DQE]").classList.add('slds-hide');
                         this.template.querySelector("[data-id=errorAdresseMail3DQE]").classList.add('slds-hide');
     }
     @wire(fetchSmileQuestions)  
     getSmileQuestions({data}) {
         if ( data ) {
             this.smileQuestions = data;
         } 
     }    // Call when componened loaded

     @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) 
     getContactCallBack({ error, data }) {
         if (data) {
            this.contact = data;
            if(getFieldValue(this.contact,  SALUT_TIERS) && !this.questionsConsentements) {
                 getQuestionsConsements().then(dataQ => {
                     var retourService = {};
                     var resultQuestionsConsements = [];
                     var answersFilter = null;
                     if(dataQ){
                         let temps = JSON.parse(JSON.stringify(dataQ));
                         // *****  modifier les questions de consentement en utlisant les libellés de métadata SM_QuestionConsentement__mdt qui contient **** //
                         if(this.smileQuestions){
                            this.smileQuestions.forEach(sq => {
                                temps.forEach(eq => {
                                    if(sq.codeQuestionnaireQuestion__c === eq.codeQuestionnaireQuestion){
                                        eq.libelleQuestion = sq.LibelleQuestion__c;
                                    }
                                });
                             });
                         }
                         // **********************************************************************************************************************************//
                         for(let i = 0; i < temps.length; i++) {
                             if (temps[i]) {
                                 resultQuestionsConsements.push(temps[i]);
                             }
                         }
                         getConsentementAnswersData({idPersonne: getFieldValue(this.contact,  SALUT_TIERS)}).then(result => {
                            if(resultQuestionsConsements) {
                                 retourService.idPersonne = getFieldValue(this.contact,  SALUT_TIERS);
                                 retourService.idBusinessPartner= getFieldValue(this.contact,  IDENTIFIANT_BUISNESS_PARTENER);
                                 retourService.canal= "Telephone";
                                 retourService.application= "SMILE";
                                 retourService.consentementResult = [];
                                 for (let i = 0; i< resultQuestionsConsements.length; i++) {
                                     if(result !== undefined) {
                                         answersFilter = result.Result.filter(item => resultQuestionsConsements[i].idQuestion === item.idQuestion && resultQuestionsConsements[i].idQuestionnaire === item.idQuestionnaire);
                                     } else {
                                         answersFilter = [];
                                     }
                                     if (answersFilter.length === 0) {
                                         answersFilter = null
                                     } else {
                                         answersFilter = answersFilter[0]
                                     }
                                     let answerMap = null;
                                        answerMap = {
                                            questionLabel: resultQuestionsConsements[i].libelleQuestion,
                                            idQuestionnaire: resultQuestionsConsements[i].idQuestionnaire,
                                            id: answersFilter ? answersFilter.id : answersFilter,
                                            idQuestion: resultQuestionsConsements[i].idQuestion,
                                            consent: answersFilter ? answersFilter.consent.toString() : answersFilter,
                                            key: resultQuestionsConsements[i].idQuestionnaire + "_" +resultQuestionsConsements[i].idQuestion
                                        };
                                    retourService.consentementResult.push(answerMap);
                                 }
                                this.questionsConsentements = retourService;
                            }
                         })
                         .catch(errorThrown1 => {
                             //console.log('got error Consentement Answers', errorThrown1);

                             retourService.idPersonne = getFieldValue(this.contact,  SALUT_TIERS);
                             retourService.idBusinessPartner= getFieldValue(this.contact,  IDENTIFIANT_BUISNESS_PARTENER);
                             retourService.canal= "Telephone";
                             retourService.application= "SMILE";
                             retourService.consentementResult = [];

                             if(resultQuestionsConsements) {
                                for (let i = 0; i< resultQuestionsConsements.length; i++) {
                                    let answerMap = null;
                                       answerMap = {
                                           questionLabel: resultQuestionsConsements[i].libelleQuestion,
                                           idQuestionnaire: resultQuestionsConsements[i].idQuestionnaire,
                                           idQuestion: resultQuestionsConsements[i].idQuestion,
                                           consent: resultQuestionsConsements[i].consent,
                                           key: resultQuestionsConsements[i].idQuestionnaire + "_" +resultQuestionsConsements[i].idQuestion
                   
                                        };
                                    retourService.consentementResult.push(answerMap);
                                }
                                this.questionsConsentements = retourService;
                             }
                         });
                     } else {
                        this.questionsConsentements = undefined;
                     }
                 }).catch(errorThrown2 => {
                     console.log('got error Consentement Questions', errorThrown2);
                 });
             }
         } else if (error) {
             //handle your error
         }
     }
     @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
     objectInfo;
     @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: MOBILE_PRINCIPAL_FIELD})
     getMobilePrincipalPickVal({data}) {
         if (data) {
             this.mobilePrincipalOptionsOriginal = Object.values(data.values);
         }
     }
     @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: TELFIXE_PRINCIPAL_FIELD})
     getTelFixePrincipalPickVal({data}) {
         if (data) {
             this.telFixePrincipalOptionsOriginal = Object.values(data.values);
         }
     }
     @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: EMAIL_PRINCIPAL_FIELD})
     getEmailPrincipalPickVal({data}) {
         if (data) {
             this.emailPrincipalOptionsOriginal = Object.values(data.values);
         }
     }
     get options() {
         return [
             { label: 'Oui', value: 'true' },
             { label: 'Non', value: 'false' },
         ];
     }
     //Option Recherche Manuelle Automatique
     get optionsRecherche() {
         return [
             { label: 'Recherche automatique', value: '1' },
             { label: 'Recherche manuelle', value: '2' },
         ];
     }
     /*get isDisabled() {
         if(this.questionsConsentements && this.questionsConsentements.consentementResult) {
             for(let i = 0; i < this.questionsConsentements.consentementResult.length; i++) {
                 if (this.questionsConsentements.consentementResult[i].consent === null && this.questionsConsentements.consentementResult[i].consentNew === undefined) {
                     return true;
                 }
             }
         }
         return false;
     }*/
     get isConsentements() {
         return this.questionsConsentements && this.questionsConsentements.consentementResult.length > 0
     }
     // Fonctions de traitement
     /**
      * Permet de vérifier les numéros de téléphones renseignés, par l'api DQE
      * @param {*} fields l'ensemble des fields du formulaire
      */
     callVerifyNumsDQEApi(fields) {
         var inputParam, optionsParam = {};
         this.getPhoneInputs();
         inputParam = {
             "mobile1": this.removeSpace((this.mobile1Input) ? this.mobile1Input.value : null),
             "mobile2": this.removeSpace((this.mobile2Input) ? this.mobile2Input.value : null),
             "mobile3": this.removeSpace((this.mobile3Input) ? this.mobile3Input.value : null),
             "phone1": this.removeSpace((this.fixe1Input) ? this.fixe1Input.value : null),
             "phone2": this.removeSpace((this.fixe2Input) ? this.fixe2Input.value : null),
             "phone3": this.removeSpace((this.fixe3Input) ? this.fixe3Input.value : null),
             "service" : "updateContact",
             "contactId": this.recordId
         };
         this.listNumErrorDQE = [];
         if (inputParam.mobile1 || inputParam.mobile2 || inputParam.mobile3 || inputParam.phone1 || inputParam.phone2 || inputParam.phone3) {
             emailPhoneVerifApi({methodName : 'verifyPhoneNumbers', inputMap : inputParam, options : optionsParam}).then(result => {
                 var errorApiVerifyNumDQE = false;
                 if (result) {
                     //console.log('output callVerifyNumsDQEApi: ' + JSON.stringify(result));
                     if (result.Error && result.Error.message) {
                         this.showSpinner = false;
                         errorApiVerifyNumDQE = true;
                         this.dispatchEvent(
                             new ShowToastEvent({
                                 title: 'Erreur DQE',
                                 message: result.Error.message,
                                 variant: 'error',
                             }),
                         );
                     } else {
                         for (const key in result) {
                             if (result[key] === 'KO') {
                                 this.listNumErrorDQE.push(key[0].toUpperCase() + key.slice(1));
                             }
                         }
                     }
                 }
                 if (!errorApiVerifyNumDQE) {
                     // On appel ici cette méthode pour forcer un appel synchrone à "emailPhoneVerifApi"
                     this.callVerifyEmailsDQEApi(fields);
                     //console.log('listNumErrorDQE: ' + this.listNumErrorDQE);
                 }
             }).catch(errorThrown => {
                 console.log('errorThrown: ' + errorThrown);
                 this.showSpinner = false;
                 this.dispatchEvent(
                     new ShowToastEvent({
                         title: 'Erreur Execution',
                         message: errorThrown.message,
                         variant: 'error',
                     }),
                 );
             });
         } else {
             // On appel ici cette méthode pour forcer un appel synchrone à "emailPhoneVerifApi"
             this.callVerifyEmailsDQEApi(fields);
         }
     }
     /**
      * Permet de vérifier les adresses emails renseignées, par l'api DQE
      * @param {*} fields l'ensemble des fields du formulaire
      */
     callVerifyEmailsDQEApi(fields) {
         // réinitialiser
         this.msgEmailDQE1 = '';
         this.msgEmailDQE2 = '';
         this.msgEmailDQE3 = '';
         var inputParam, optionsParam = {};
         this.getEmailInputs();
         inputParam = {
             "email1": this.removeSpace((this.email1Input) ? this.email1Input.value : null),
             "email2": this.removeSpace((this.email2Input) ? this.email2Input.value : null),
             "email3": this.removeSpace((this.email3Input) ? this.email3Input.value : null),
             "service" : "updateContact",
             "contactId": this.recordId
         };
         this.listEmailErrorDQE = [];
         if (inputParam.email1 || inputParam.email2 || inputParam.email3) {
             emailPhoneVerifApi({methodName : 'verifyEmails', inputMap : inputParam, options : optionsParam}).then(result => {
                 var errorApiVerifEmail = false;
                 if (result) {
                     //console.log('output callVerifyEmailsDQEApi: ' + JSON.stringify(result));
                     if (result.Error && result.Error.message) {
                         this.showSpinner = false;
                         errorApiVerifEmail = true;
                         this.dispatchEvent(
                             new ShowToastEvent({
                                 title: 'Erreur DQE',
                                 message: result.Error.message,
                                 variant: 'error',
                             }),
                         );
                     } else {
                         let adressMailTemp = null;
                         for (const key in result) {
                             if (Object.prototype.hasOwnProperty.call(result, key)) {
                                 adressMailTemp = key.slice(1);
                                 if (result[key] === 'KO' && this.getValueElementByQuerySelector('[data-id="Adresse'+ adressMailTemp[0].toUpperCase() + adressMailTemp.slice(1) +'"]')) {
                                     this.listEmailErrorDQE.push('Adresse' + adressMailTemp[0].toUpperCase() + adressMailTemp.slice(1));
                                 }
                                 if(key.startsWith('code')){
                                     var code = result[key];
                                     var message;
                                     switch (code) {
                                         case '91':
                                           message = 'Le format de l’email saisi est invalide. Merci de saisir une adresse valide.';
                                           break;
                                         case '92':
                                             message = 'Le nom de domaine est inconnu. Merci de saisir une adresse valide.';
                                             break;
                                         case '93':
                                             message = 'Le nom de domaine n’est pas autorisé (suspicion SPAM). Merci de saisir une adresse valide.';
                                             break;
                                         case '94':
                                             message = 'L’adresse email n’est pas autorisée (suspicion SPAM). Merci de saisir une adresse valide.';
                                             break;
                                         case '95':
                                             message = 'L’email saisi est un email temporaire jetable. Merci de saisir une adresse valide.';
                                             break;
                                         case '04':
                                             message = 'L’email est vide. Merci de saisir une adresse valide.';
                                             break;
                                         case '02':
                                             message = 'L’email saisi n’existe pas pour ce domaine. Merci de saisir une adresse valide';
                                             break;
                                     }
                                     if(key == 'code1'){
                                         this.msgEmailDQE1 = message;
                                     } else if (key == 'code2'){
                                         this.msgEmailDQE2 = message;
                                     } else if (key == 'code3'){
                                         this.msgEmailDQE3 = message;
                                     }
                                 }
                             }
                         }
                     }
                 }
                 if (this.listNumErrorDQE.length === 0 && this.listEmailErrorDQE.length === 0 && !errorApiVerifEmail) {
                     this.saveToOctupus(this.getInputToSaveInOctopus(), fields);
                 } else {
                     this.showAllErrorDQE();
                     this.showSpinner = false;
                 }
                 //console.log('listNumErrorDQE: ' + this.listNumErrorDQE);
             }).catch(errorThrown => {
                 console.log('errorThrown: ' + errorThrown);
                 this.showSpinner = false;
                 this.dispatchEvent(
                     new ShowToastEvent({
                         title: 'Erreur Execution',
                         message: errorThrown.message,
                         variant: 'error',
                     }),
                 );
             });
         } else {
             if (this.listNumErrorDQE.length === 0 && this.listEmailErrorDQE.length === 0) {
                 // On valide le formulaire ici pour forcer un appel synchrone à "emailPhoneVerifApi"
                 this.saveToOctupus(this.getInputToSaveInOctopus(), fields);
             } else {
                 this.showAllErrorDQE();
                 this.showSpinner = false;
             }
         }
     }

     /**
      * FT4-185
      * Permet de lire les informations du Contact (Les stops) depuis Octopus
      * @param {*} params Les paramètres à passer à la fonction 'lirePersonne' dans 'SM_AP61_PersonneOctopus'
      */
      readFromOctopus(params) {
         let optionsParam = {};
         lirePersonne({methodName: 'lirePersonne', inputMap: params, options : optionsParam}).then(result =>  {
            let codeRetour = null;
            this.isDisplayStopsSpinner = false;
            if (result) {
                if (!result.Error) {
                    // Détermination du code Retour
                    if (result.lirePersonneRet && (typeof result.lirePersonneRet === 'string' || result.lirePersonneRet instanceof String)) {
                        codeRetour = result.lirePersonneRet.replace('OCTOPUS_LirePersonne_', '');
                    } else {
                        codeRetour = null;
                    }
                    // Analyse du code Erreur
                    /* Cas '01' -> Traitement effectué sans erreur */
                    if (codeRetour != null) {
                        if (codeRetour == '01') {
                            this.oldStops.stopPhoning = (result.lirePersonneRes.stopPhoning !== undefined && result.lirePersonneRes.stopPhoning == 'true') ? true : false;
                            this.oldStops.stopMailing = (result.lirePersonneRes.stopMailing !== undefined && result.lirePersonneRes.stopMailing == 'true') ? true : false;
                            this.oldStops.stopEmailing = (result.lirePersonneRes.stopEmailing !== undefined && result.lirePersonneRes.stopEmailing == 'true') ? true : false;
                            this.oldStops.stopPorteAPorte = (result.lirePersonneRes.stopPorteAPorte !== undefined && result.lirePersonneRes.stopPorteAPorte == 'true') ? true : false;
                            this.oldStops.stopProspectionCommerciale = (result.lirePersonneRes.stopProspectionCommerciale !== undefined && result.lirePersonneRes.stopProspectionCommerciale == 'true') ? true : false;
                            this.oldStops.stopAnalyseStatistique = (result.lirePersonneRes.stopAnalyseStatistique !== undefined && result.lirePersonneRes.stopAnalyseStatistique == 'true') ? true : false;
                            this.oldStops.stopAmeliorationExperienceClient = (result.lirePersonneRes.stopAmeliorationExperienceClient !== undefined && result.lirePersonneRes.stopAmeliorationExperienceClient == 'true') ? true : false;
                            this.oldStops.stopSMSing = (result.lirePersonneRes.stopSMSing !== undefined && result.lirePersonneRes.stopSMSing == 'true') ? true : false;
                            this.isStopsLoaded = true;
                        }
                        else {
                            this.techErrorMessageOctopusStops = result.lirePersonneRet + ' - ' + result.lib_err_octopus;
                        }
                    } else {
                        this.techErrorMessageOctopusStops = 'Erreur inconnue lors du chargement depuis Octopus.';
                    }
                    
                } else {
                    this.errorMessageOctopusStops = "Erreur de connexion à Octopus.";
                    this.isErrorCallWsStops = true;
                }
            } else {
                this.isErrorCallWsStops = true;
            }
         }).catch(errorStops => {
            this.isErrorCallWsStops = true;
            console.log('erreur de chargement des stops: ' + errorStops.message);
         });
     }
     
     /**
      * Permet de synchroniser les informations du Contact dans Octopus
      * @param {*} params Les paramètres à passer à l'IP
      */
     saveToOctupus(params, fields) {
         let optionsParam = {};
         majPersonne({ methodName : 'majPersonne', inputMap: params, options : optionsParam}).then(result => {
             let errorApiMajPersonne = false;
             let codeRetour = null;
             if(result) {
                 console.log('output callIP: ' + JSON.stringify(result));
                 if (!result.Error) {
                     // Détermination du code Retour
                     if (result.majPersonneRet && (typeof result.majPersonneRet === 'string' || result.majPersonneRet instanceof String)) {
                         codeRetour = result.majPersonneRet.replace('OCTOPUS_MAJPersonne_', '');
                     } else {
                         codeRetour = null;
                     }
                     // Analyse du code Erreur
                     if (codeRetour !== '01') {
                         if (this.lstCodeInforErrorsOctopus.includes(codeRetour)) {
                             this.isInformErreurOctopus = true;
                             this.informMessageOctopus = result.majPersonneRet + ' - ' + result.lib_err_octopus;
                         } else if (this.lstCodeWarnErrorsOctopus.includes(codeRetour)) {
                             this.isWarningErreurOctopus = true;
                             this.warningMessageOctopus = result.majPersonneRet + ' - ' + result.lib_err_octopus;
                         } else {
                             errorApiMajPersonne = true;
                         }
                     }
                 }
             } else {
                 errorApiMajPersonne = true;
             }
 
             if (errorApiMajPersonne) {
                 // Determination du message d'erreur
                 let errorMessage = '';
                 if (result) {
                     if (result.majPersonneRet && result.lib_err_octopus) {
                         errorMessage = result.majPersonneRet + ' - ' + result.lib_err_octopus;
                     } else if (result.Error && result.Error.message) {
                         errorMessage = result.Error.message;
                     } else if (result.Error) {
                         errorMessage = result.Error;
                     } else {
                         errorMessage = 'Erreur inconnue lors de la sauvegarde dans Octopus.';
                     }
                 }
                 
                 this.showSpinner = false;
                 this.dispatchEvent(
                     new ShowToastEvent({
                         title: 'Erreur Sauvegarde Octopus',
                         message: errorMessage,
                         variant: 'error',
                     }),
                 );
             } else {
                 this.template.querySelector('lightning-record-edit-form').submit(fields);
             }
         }).catch(errorThrown => {
             console.log('errorThrown: ' + errorThrown);
             this.showSpinner = false;
             this.dispatchEvent(
                 new ShowToastEvent({
                     title: 'Erreur Sauvegarde Octopus',
                     message: errorThrown.message,
                     variant: 'error',
                 }),
             );
         });
     } 
     /**
      * Permet de cacher la boxe contenant les suggestions d'adresses
      */
     hideAddressesListBox() {
         this.template.querySelector('[data-id="listAddressSuggested"]').classList.add('slds-hide');
         this.listAddressResult = undefined;
         this.isAddressFieldEmpty=true;
     }
     /**
      * Permet d'afficher les erreurs DQE
      */
     showAllErrorDQE() {
         let errorDiv;
         for (let i=0 ; i<this.listNumErrorDQE.length ; i++) {
             errorDiv = this.template.querySelector('[data-id="error' + this.listNumErrorDQE[i] + 'DQE"]');
             if (errorDiv) {
                 errorDiv.classList.remove('slds-hide');
             }
         }
         for (let i=0 ; i<this.listEmailErrorDQE.length ; i++) {
             errorDiv = this.template.querySelector('[data-id="error' + this.listEmailErrorDQE[i] + 'DQE"]');
             if (errorDiv) {
                 errorDiv.classList.remove('slds-hide');
             }
         }
     }
     /**
      * Permet de cacher les erreurs DQE
      */
     hideAllErrorDQE() {
         let errorDivS = this.template.querySelectorAll('div[data-id*="DQE"]'), i;
         for (i=0 ; i < errorDivS.length ;i++) {
             errorDivS[i].classList.add('slds-hide');
         }
     }
     /**
      * Permet de mettre à jours les valeurs séléctionnables des picklists 
      *    des numéros de telephone de preference
      * ou des adresses mails de preference
      * @param {*} type Type de champs
      */
     refreshOptionsPreferredInputs(type) {
         let index;
         // Traitement pour les numéros mobile
         if (type === 'Mobile' || type === 'BothPhone') {
             this.getPhoneInputs();
             this.mobilePrincipalOptionsRestricted = [];
             if (!this.isAllInputsEmpty('Mobile')) { 
                 // Initialisation des valeurs de picklist
                 if (this.mobilePrincipalOptionsOriginal) {
                     for(index=0; index<this.mobilePrincipalOptionsOriginal.length; index++) {
                         this.mobilePrincipalOptionsRestricted.push(this.mobilePrincipalOptionsOriginal[index]);
                     }
                 }
                 // Filtrage des valeurs de picklist à afficher
                 this.delOptsPreferredOptions(this.mobile1Input, 'Mobile');
                 this.delOptsPreferredOptions(this.mobile2Input, 'Mobile');
                 this.delOptsPreferredOptions(this.mobile3Input, 'Mobile');
                 let currentValueRemoved = true;
                 if (this.mobilePrincipalComboBox) {
                     let selectedValue = this.mobilePrincipalComboBox.value;
                     for (index=0; index<this.mobilePrincipalOptionsRestricted.length; index++) {
                         if (this.mobilePrincipalOptionsRestricted[index].value === selectedValue) {
                             currentValueRemoved = false;
                             break;
                         }
                     }
                     if (this.mobilePrincipalOptionsRestricted.length !== 0) {
                         if (currentValueRemoved) {
                             this.mobilePrincipalComboBox.value = this.mobilePrincipalOptionsRestricted[0].value;
                         } else {
                             this.mobilePrincipalComboBox.value = selectedValue;
                         }
                     }
                 }
             } else {
                 this.mobilePrincipalComboBox.value = null;
             }
         }
         // Traitement pour les numéros fixe : récupération des valeurs de picklist BDD
         if (type === 'Fixe' || type === 'BothPhone') {
             this.getPhoneInputs();
             this.telFixePrincipalOptionsRestricted = [];
             if (!this.isAllInputsEmpty('Fixe')) {
                 // Initialisation des valeurs de picklist
                 if (this.telFixePrincipalOptionsOriginal) {
                     for(index=0; index<this.telFixePrincipalOptionsOriginal.length; index++) {
                         this.telFixePrincipalOptionsRestricted.push(this.telFixePrincipalOptionsOriginal[index]);
                     }
                 }
                 // Filtrage des valeurs de picklist à afficher
                 this.delOptsPreferredOptions(this.fixe1Input, 'Fixe');
                 this.delOptsPreferredOptions(this.fixe2Input, 'Fixe');
                 this.delOptsPreferredOptions(this.fixe3Input, 'Fixe');
                 let currentValueRemoved = true;
                 if (this.fixePrincipalComboBox) {
                     let selectedValue = this.fixePrincipalComboBox.value;
                     for (index=0; index<this.telFixePrincipalOptionsRestricted.length; index++) {
                         if (this.telFixePrincipalOptionsRestricted[index].value === selectedValue) {
                             currentValueRemoved = false;
                             break;
                         }
                     }
                     if (this.telFixePrincipalOptionsRestricted.length !== 0) {
                         if (currentValueRemoved) {
                             this.fixePrincipalComboBox.value = this.telFixePrincipalOptionsRestricted[0].value;
                         } else {
                             this.fixePrincipalComboBox.value = selectedValue;
                         }
                     }
                 }
             } else {
                 this.fixePrincipalComboBox.value = null;
             }
         }
         if (type === 'Email') {
             this.getEmailInputs();
             this.emailPrincipalOptionsRestricted = [];
             if (!this.isAllInputsEmpty('Email')) {
                 // Initialisation des valeurs de picklist
                 if (this.emailPrincipalOptionsOriginal) {
                     for(index=0; index<this.emailPrincipalOptionsOriginal.length; index++) {
                         this.emailPrincipalOptionsRestricted.push(this.emailPrincipalOptionsOriginal[index]);
                     }
                 }
                 // Filtrage des valeurs de picklist à afficher
                 this.delOptsPreferredOptions(this.email1Input, 'Email');
                 this.delOptsPreferredOptions(this.email2Input, 'Email');
                 this.delOptsPreferredOptions(this.email3Input, 'Email');
                 let currentValueRemoved = true;
                 if (this.emailPrincipalComboBox) {
                     let selectedValue = this.emailPrincipalComboBox.value;
                     for (index=0; index<this.emailPrincipalOptionsRestricted.length; index++) {
                         if (this.emailPrincipalOptionsRestricted[index].value === selectedValue) {
                             currentValueRemoved = false;
                             break;
                         }
                     }
                     if (this.emailPrincipalOptionsRestricted.length !== 0) {
                         if (currentValueRemoved) {
                             this.emailPrincipalComboBox.value = this.emailPrincipalOptionsRestricted[0].value;
                         } else {
                             this.emailPrincipalComboBox.value = selectedValue;
                         }
                     }
                 }
             } else {
                 this.emailPrincipalComboBox.value = null;
             }
         }
     }
     /**
      * Permet de supprimer les valeurs non séléctionnables des picklist 
      *    du numéro de telephone mobile de preference
      * ou du numéro de telephone fixe de preference
      * ou de l'email de preference
      */
     delOptsPreferredOptions(input, typeInput) {
         let index, valPickValInBDD, inputValue, hasGoodFormat;
         if (input) {
             inputValue = this.removeSpace(input.value);
             hasGoodFormat = this.verifyFormat(inputValue, typeInput);
             if (!inputValue || inputValue === '' || !hasGoodFormat) {
                 if (typeInput === 'Mobile') {
                     for (index=0; index< this.mobilePrincipalOptionsRestricted.length; index++) {
                         valPickValInBDD = this.removeSpace(this.mobilePrincipalOptionsRestricted[index].value);
                         if(input.dataset.id === valPickValInBDD) {
                             this.mobilePrincipalOptionsRestricted.splice(index, 1);
                             break;
                         }
                     }
                 } else if (typeInput === 'Email') {
                     for (index=0; index< this.emailPrincipalOptionsRestricted.length; index++) {
                         valPickValInBDD = this.removeSpace(this.emailPrincipalOptionsRestricted[index].value);
                         if(input.dataset.id === valPickValInBDD) {
                             this.emailPrincipalOptionsRestricted.splice(index, 1);
                             break;
                         }
                     }
                 } else if (typeInput === 'Fixe') {
                     for (index=0; index< this.telFixePrincipalOptionsRestricted.length; index++) {
                         valPickValInBDD = this.removeSpace(this.telFixePrincipalOptionsRestricted[index].value);
                         valPickValInBDD = valPickValInBDD.replace('Tel','');
                         if(input.dataset.id === valPickValInBDD) {
                             this.telFixePrincipalOptionsRestricted.splice(index, 1);
                             break;
                         }
                     }
                 }
             }
         }
     }
     /**
      * Permet de selectionner une adresse proposée par l'Api Gouv
     * @param {*} event evenement déclencheur
     */
    selectAddressValue(event){
        //console.log("selectedValue");
        let houseAddress = {
            type:           event.currentTarget.dataset.type,
            typez:           event.currentTarget.dataset.typez,
            housenumber:    event.currentTarget.dataset.housenumber,
            name:           event.currentTarget.dataset.name,
            street:         event.currentTarget.dataset.street,
            postcode:       event.currentTarget.dataset.postcode,
            city:           event.currentTarget.dataset.city,
            label:          event.currentTarget.dataset.label
        }
        if (houseAddress.type === "housenumber" || houseAddress.typez === "housenumber") {
            this.template.querySelector('[data-id="noVoie"]').value = houseAddress.housenumber;
            this.template.querySelector('[data-id="Street"]').value = houseAddress.street;
        }
        if (houseAddress.type === "street" || houseAddress.typez === "street") {
            this.template.querySelector('[data-id="Street"]').value = houseAddress.name;
        }
        this.template.querySelector('[data-id="noPostal"]').value = houseAddress.postcode;
        this.template.querySelector('[data-id="City"]').value = houseAddress.city;
        this.addressSelected = event.currentTarget.dataset.label;
        this.template.querySelector('[data-id="listAddressSuggested"]').classList.add('slds-hide');
        this.isAddressFieldEmpty = false;
        this.validAdressSelected = true;
    }
     /**
      * Permet de selectionner un code postal
      * @param {*} event evenement déclencheur
      */
     selectCodePostalValue (event) {
         this.template.querySelector('[data-id="noPostal"]').value = event.currentTarget.dataset.value;
         this.template.querySelector('[data-id="codePostal"]').value = event.currentTarget.dataset.value;
         this.codePostal = event.currentTarget.dataset.value;
         this.isCodePostalFieldEmpty = false;
         this.changeCodePostal(true);
         this.template.querySelector('[data-id="listCodesPostauxSuggested"]').classList.add('slds-hide');
     }
     /**
      * Permet d'afficher la liste des codesPostaux directement lors du clique sur le champs
      * @param {*} event evenement déclencheur
      */
     checkListCodesPostaux() {
         if(this.listCodesPostaux && this.listCodesPostaux.length > 0) {
             this.template.querySelector('[data-id="listCodesPostauxSuggested"]').classList.remove('slds-hide');
         }
     }
     /**
      * Permet de selectionner un code postal
      * @param {*} event evenement déclencheur
      */
     selectVilleValue (event) {
         this.ville = event.currentTarget.dataset.value;
         this.isCityFieldEmpty = false;
         this.template.querySelector('[data-id="ville"]').value = event.currentTarget.dataset.value;
         this.template.querySelector('[data-id="City"]').value = event.currentTarget.dataset.value;
         this.changeVille(true);
         this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
     }
     /**
      * Permet de selectionner un la rue de l'adresse
      * @param {*} event evenement déclencheur
      */
     selectRueValue (event) {
         this.rue = event.currentTarget.dataset.value;
         this.isStreetFieldEmpty = false;
         this.template.querySelector('[data-id="rue"]').value = event.currentTarget.dataset.value;
         this.template.querySelector('[data-id="Street"]').value = event.currentTarget.dataset.value;
         this.changeRue(true);
         this.template.querySelector('[data-id="listRuesSuggested"]').classList.add('slds-hide');
     }
     selectNumeroValue (event) {
         this.numero = event.currentTarget.dataset.value;
         this.template.querySelector('[data-id="noVoie"]').value = event.currentTarget.dataset.value;
         this.template.querySelector('[data-id="numeroRue"]').value = event.currentTarget.dataset.value;
         this.template.querySelector('[data-id="listNumerosSuggested"]').classList.add('slds-hide');
     }
     /**
      * Permet d'afficher la liste des ville directement lors du clique sur le champs
      * @param {*} event evenement déclencheur
      */
     checkListVille() {
         if(this.listVilles && this.listVilles.length > 0) {
             this.template.querySelector('[data-id="listVillesSuggested"]').classList.remove('slds-hide');
         }
     }
     checkListNumero() {
         if(this.listNumeros && this.listNumeros.length > 0) {
             this.template.querySelector('[data-id="listNumerosSuggested"]').classList.remove('slds-hide');
         }
     }
     /**
      * Permet d'effacer les valeurs des vrai fields d'adresse
      */
     clearAdressValues() {
         this.template.querySelector('[data-id="noVoie"]').value = '';
         this.template.querySelector('[data-id="Street"]').value = '';
         this.template.querySelector('[data-id="noPostal"]').value = '';
         this.template.querySelector('[data-id="City"]').value = '';
     }
     /**
      * Permet de concatener les valeurs des fields d'adresse pour les afficher dans un seul champ
      * @param {*} event 
      */
     concatAdressFields(event) {
         //console.log("concatAdressFields");
         let record = event.detail.records;
         let fields = record[this.recordId].fields;
         let noVoie = fields.No_Voie__c.value;
         let street = fields.MailingStreet.value;
         let postalCode = fields.MailingPostalCode.value;
         let city = fields.MailingCity.value;
         let adressConcatenated = '';
         let fakeAdressInputField = this.template.querySelector('[data-id="address"]');
         if (noVoie !== undefined && noVoie !== null && noVoie !== '') {
             adressConcatenated = adressConcatenated + noVoie + ' ';
         }
         if (street !== undefined && street !== null && street !== '') {
             adressConcatenated = adressConcatenated + street + ' ';
         }
         if (postalCode !== undefined && postalCode !== null && postalCode !== '') {
             adressConcatenated = adressConcatenated + postalCode + ' ';
         }
         if (city !== undefined && city !== null && city !== '') {
             adressConcatenated = adressConcatenated + city;
         }
         if (fakeAdressInputField !== undefined) {
             fakeAdressInputField.value = adressConcatenated;
         }
     }
     // Fonctions Event
     /**
      * Permet de récupérer les suggestions d'adresse retournées par l'API Gouv
     * @param {*} event evenement déclencheur
     */
    getAddressSuggestions(event) {
        this.isDisabledAddressModified = false;
        this.isRequiredAddressModified = true;
        let inputValue = event.target.value;
        if (event.target.dataset.id === 'address') {
            inputValue = inputValue.split(' ').join('+');
            if (inputValue !== undefined && inputValue.length === 0) {
                this.hideAddressesListBox();
            } else if (inputValue !== undefined && inputValue.length > 0) {
                let input = inputValue;
                getSuggestionsAdressApi({input}).then(resultApi => {
                    if (resultApi && resultApi.features && resultApi.features.length !== 0) {
                        this.listAddressResult = resultApi.features;
                        console.log(this.listAddressResult);
                        this.isAddressFieldEmpty=false;
                        this.clearAdressValues();
                    }
                }).catch(errorSearchAddress => {
                    this.hideAddressesListBox();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Erreur recherche adresse',
                            message: errorSearchAddress.message,
                            variant: 'error',
                        }),
                    );
                });
                if (this.listAddressResult !== undefined && this.listAddressResult.length > 0) {
                    this.template.querySelector('[data-id="listAddressSuggested"]').classList.remove('slds-hide');
                }
             } else {
                 this.hideAddressesListBox();
             }
             this.validAdressSelected = false;
         }
     }
     /**
      * Définis la valeur de l'option d'envois d'email pour la modification d'adresse 
      * 
      * @param {*} event 
      */
     handleModifAdress(event){
         this.isSendEmailOption = event.target.checked;
         console.log(this.isSendEmailOption );
     }
     /**
      * Permet d'afficher le type de recherche selectionner par le conseiller
      * @param {*} event evenement déclencheur
      */
     handleChangeRecherche(event) {
         if(event.detail.value === '2') {
             this.cacherechercheAuto = this.template.querySelector('[data-id="address"]').value;
         } else {
             let template = this.template;
             let that = this;
             setTimeout(function () {
                 template.querySelector('[data-id="address"]').value = that.cacherechercheAuto;
             }, 0);
         }
         this.typeSearchAdress = (event.detail.value === '1');
     }
     // loadConcatAdresse () {
     //     let adressConcat = '';
     //     if (this.template.querySelector('[data-id="noVoie"]').value !== undefined && this.template.querySelector('[data-id="noVoie"]').value !== null && this.template.querySelector('[data-id="noVoie"]').value !== '') {
     //         adressConcat = adressConcat + this.template.querySelector('[data-id="noVoie"]').value + ' ';
     //     }
     //     if (this.template.querySelector('[data-id="Street"]').value !== undefined && this.template.querySelector('[data-id="Street"]').value !== null && this.template.querySelector('[data-id="Street"]').value !== '') {
     //         adressConcat = adressConcat + this.template.querySelector('[data-id="Street"]').value + ' ';
     //     }
     //     if (this.template.querySelector('[data-id="noPostal"]').value !== undefined && this.template.querySelector('[data-id="noPostal"]').value !== null && this.template.querySelector('[data-id="noPostal"]').value !== '') {
     //         adressConcat = adressConcat + this.template.querySelector('[data-id="noPostal"]').value + ' ';
     //     }
     //     if (this.template.querySelector('[data-id="City"]').value !== undefined && this.template.querySelector('[data-id="City"]').value !== null && this.template.querySelector('[data-id="City"]').value !== '') {
     //         adressConcat = adressConcat + this.template.querySelector('[data-id="City"]').value;
     //     }
     //     this.template.querySelector('[data-id="address"]').value = adressConcat;
     // }
     /**
      * Permet d'afficher les erreurs de format des champs de numéros de téléphone
      * et permet d'empécher l'insertion de charactères autre que des chiffres
      * @param {*} event evenement déclencheur
      */
     handleChangeNumTel(event) {
         let inputId = event.target.dataset.id;
         let numTel = event.target.value;
         let testNumPatt;
         let inputFieldContainer = this.template.querySelector('[data-id="' + inputId + 'Container"]');
         let inputFieldErrorMessage = this.template.querySelector('[data-id="error' + inputId + 'Format"]');
         let indexListErreurFormat = this.listNumErrorFormat.indexOf(inputId);
         var numType;
         // Remove Space 
         if (numTel && numTel !== undefined && numTel !== '') {
             numTel = this.removeSpace(numTel);
         }
         // Replace letters 
         if (inputId.includes('Fixe')) {
             numType = 'Fixe';
         } else if (inputId.includes('Mobile')) {
             numType = 'Mobile';
         }
         testNumPatt = this.verifyFormat(numTel, numType);
         // On affiche l'erreur de format de telephone pour ce field
         if (numTel !== '' && !testNumPatt && inputFieldErrorMessage && inputFieldContainer) {
             inputFieldContainer.classList.add('slds-has-error');
             inputFieldErrorMessage.classList.remove('slds-hide');
             if (indexListErreurFormat === -1) {
                 this.listNumErrorFormat.push(inputId);
             }
         }
         // On cache l'erreur de format de telephone pour ce field 
         else if (((numTel !== '' && testNumPatt) || numTel === '') && inputFieldErrorMessage && inputFieldContainer) {
             inputFieldContainer.classList.remove('slds-has-error');
             inputFieldErrorMessage.classList.add('slds-hide');
             if (indexListErreurFormat !== -1) {
                 this.listNumErrorFormat.splice(indexListErreurFormat, 1);
             }
             this.refreshOptionsPreferredInputs(numType);
             this.disableOrEnableRefusChBox(numType);
         }
     }
     /**
      * Permet d'entourer les champs d'Email d'un halo rouge lorsque le format n'est pas bon
      * @param {*} event evenement déclencheur
      */
     handleChangeEmail(event) {
         let inputId = event.target.dataset.id;
         let email = event.target.value;
         let testEmailPatt;
         let inputFieldContainer = this.template.querySelector('[data-id="' + inputId + 'Container"]');
         let indexListErreurFormat = this.listEmailErrorFormat.indexOf(inputId);
         testEmailPatt = this.verifyFormat(email, 'Email');
         // On affiche le halo rouge autour de ce champ
         if (email !== '' && !testEmailPatt && inputFieldContainer ) {
             inputFieldContainer.classList.add('slds-has-error');
             if (indexListErreurFormat === -1) {
                 this.listEmailErrorFormat.push(inputId);
             }
         }
         // On cache le halo rouge autour de ce champ
         else if (((email !== '' && testEmailPatt) || email === '') && inputFieldContainer) {
             inputFieldContainer.classList.remove('slds-has-error');
             if (indexListErreurFormat !== -1) {
                 this.listEmailErrorFormat.splice(indexListErreurFormat, 1);
             }
             this.refreshOptionsPreferredInputs('Email');
         }
         this.disableOrEnableRefusChBox('Email');
     }
     /**
      * Permet de mettre à jour la valeur des vrais champs de numéros de téléphone préférés
      * @param {*} event evenement déclencheur
      */
     handleChangePreferredNum(event) {
         if (event.currentTarget.dataset.id === 'telFixePrincipalComboBox') {
             this.template.querySelector('[data-id="fixePrincipal"]').value = event.target.value;
         } else if (event.currentTarget.dataset.id === 'mobilePrincipalComboBox') {
             this.template.querySelector('[data-id="mobilePrincipal"]').value = event.target.value;
         }
     }
     /**
      * Permet de mettre à jour la valeur des vrais champs de numéros de téléphone préférés
      * @param {*} event evenement déclencheur
      */
     handleChangePreferredEmail(event) {
         if (event.currentTarget.dataset.id === 'emailPrincipalComboBox') {
             this.template.querySelector('[data-id="emailPrincipal"]').value = event.target.value;
         }
         this.verfifyNPAIFlag();
     }
     /**
      * Permet d'initialiser les valeurs des champs fake
      * @param {*} event evenement déclencheur
      */
     handleLoad(event) {
         try {
             //console.log("handleLoad");
             // Pour eviter que ces fonctions soient appelées en boucles au chargement de la page
             if(this.firstLoadPage) {
                let ret = {
                    ContextId : this.recordId
                }
                this.readFromOctopus(ret);

                 // Suppression des '+33' stocké en bdd
                 this.formatAllPhoneNumbersInput('removeAreaCode');
                 this.concatAdressFields(event);
                 this.refreshOptionsPreferredInputs('Email');
                 this.refreshOptionsPreferredInputs('BothPhone');
                 // Gestion des telephones et email de préférences
                 let mobPrincipalInput = this.template.querySelector('[data-id="mobilePrincipal"]');
                 let mobPrincipalComboBox = this.template.querySelector('[data-id="mobilePrincipalComboBox"]');
                 let fixPrincipalInput = this.template.querySelector('[data-id="fixePrincipal"]');
                 let fixPrincipalComboBox = this.template.querySelector('[data-id="telFixePrincipalComboBox"]');
                 let emailPrincipalInput = this.template.querySelector('[data-id="emailPrincipal"]');
                 let emailPrincipalComboBox = this.template.querySelector('[data-id="emailPrincipalComboBox"]');
                 if (mobPrincipalInput) {
                     mobPrincipalComboBox.value = mobPrincipalInput.value;
                 }
                 if (fixPrincipalInput) {
                     fixPrincipalComboBox.value = fixPrincipalInput.value;
                 }
                 if (emailPrincipalInput) {
                     emailPrincipalComboBox.value = emailPrincipalInput.value;
                 }           
                 // Gestion des cases à cocher de refus
                 let refusMobPrincipal = this.template.querySelector('[data-id="RefusTelMobile"]');
                 let refusFixPrincipal = this.template.querySelector('[data-id="RefusTelFixe"]');
                 let refusEmailPrincipal = this.template.querySelector('[data-id="RefusEmail"]');
                 if (refusMobPrincipal) {
                     this.disableOrEnableInputFields(refusMobPrincipal.dataset.id, refusMobPrincipal.value);
                     this.disableOrEnableRefusChBox('Mobile');
                 }
                 if (refusFixPrincipal) {
                     this.disableOrEnableInputFields(refusFixPrincipal.dataset.id, refusFixPrincipal.value);
                     this.disableOrEnableRefusChBox('Fixe');
                 }
                 if (refusEmailPrincipal) {
                     this.disableOrEnableInputFields(refusEmailPrincipal.dataset.id, refusEmailPrincipal.value);
                     this.disableOrEnableRefusChBox('Email');
                 }
                 // en cas ou le flag NPAI est true ==> afficher un message d'erreur en dessous de l'adresse mail concernée
                 if(this.emailPrincipalComboBox.value && this.npaiFlag === "true"){
                 this.NPAIFlagNotification(this.emailPrincipalComboBox.value);
            }
                 this.firstLoadPage = false;
             }
         } catch(errorOnLoad) {
             console.log('Error Load: ' + errorOnLoad);
             this.dispatchEvent(
                 new ShowToastEvent({
                     title: 'Erreur au chargement de la page.',
                     message: 'Veuillez essayer de rafraichir la page: ' + errorOnLoad.message,
                     variant: 'error',
                 }),
             );
         }
     }
     /**
      * Permet de valider le formulaire dans le cas où on a aucune erreur de validation
      * et permet de faire l'appel à DQE (dèrnière validation du formulaire)
      * et cacher les erreurs DQE précédement affichées
      * @param {*} event evenement déclencheur
      */
     handleSubmit(event) {
         //console.log('handleSubmit');
         let fields = event.detail.fields;
         this.getEmailInputs();
         event.preventDefault();
         // Ajout du champs AddressModifiedSendMail__c
         fields.AddressModifiedSendMail__c = this.isSendEmailOption;
         // On remet le (+33) pour stocker en BDD
         fields.MobilePhone = this.removeOrAddAreaCodeAndSpace(fields.MobilePhone, 'addAreaCode');
         fields.Mobile_2__c = this.removeOrAddAreaCodeAndSpace(fields.Mobile_2__c, 'addAreaCode');
         fields.Mobile_3__c = this.removeOrAddAreaCodeAndSpace(fields.Mobile_3__c, 'addAreaCode');
         fields.Phone = this.removeOrAddAreaCodeAndSpace(fields.Phone, 'addAreaCode');
         fields.Tel_Fixe_2__c = this.removeOrAddAreaCodeAndSpace(fields.Tel_Fixe_2__c, 'addAreaCode');
         fields.Tel_Fixe_3__c = this.removeOrAddAreaCodeAndSpace(fields.Tel_Fixe_3__c, 'addAreaCode');
         // On recupère les valeurs des combobox
         fields.Mobile_Principal__c = this.mobilePrincipalComboBox.value;
         fields.Tel_Fixe_Principal__c = this.fixePrincipalComboBox.value;
         fields.Adresse_Mail_Principale__c = this.emailPrincipalComboBox.value;
         if (!this.validAdressSelected && this.typeSearchAdress) {
             this.isAddressFieldEmpty = true;
         }
         if(!this.typeSearchAdress && !this.selectedRue) {
             this.isStreetFieldEmpty = true;
         }
         if(!this.typeSearchAdress && !this.selectedVille) {
             this.isCityFieldEmpty = true;
         }
         if(!this.typeSearchAdress && !this.selectedCodePostal) {
             this.isCodePostalFieldEmpty = true;
         }
         if ((this.typeSearchAdress && this.isAddressFieldEmpty) 
             || this.template.querySelector('[data-id="City"]').value === '' 
             || (!this.typeSearchAdress && (!this.selectedVille || !this.selectedRue || !this.selectedCodePostal))) {
             this.clearAdressValues();
         } else if (this.listNumErrorFormat.length === 0 && this.listEmailErrorFormat.length === 0){
             this.showSpinner = true;
             this.listNumErrorFormat = [];
             this.hideAllErrorDQE();
             // callVerifyNumsDQEApi ==> callVerifyEmailsDQEApi ==> saveToOctopus
             this.callVerifyNumsDQEApi(fields);
             //this.callVerifyEmailsDQEApi(fields);
             //this.template.querySelector('lightning-record-edit-form').submit(fields);
         }
     }
     /**
      * Permet de gérer les erreurs serveurs de validation du formulaire
      * @param {*} event evenement déclencheur
      */
     handleErrorForm(event) {
         this.formatAllPhoneNumbersInput('removeAreaCode');
         event.preventDefault();
         this.showSpinner = false;
         this.dispatchEvent(
             new ShowToastEvent({
                 title: 'Error!',
                 message: event.detail.message,
                 variant: 'error',
             }),
         );
     }
     /**
      * Permet de quitter l'onglet actif après la sauvegarde
      * et d'afficher un message de succés
      * @param {*} event evenement déclencheur
      */
     handleSucess(event){
         //this.isSaveToOctupusFinish = false
         //console.log('handleSucess');
         const recordName = event.detail.fields.FirstName.value + ' ' + event.detail.fields.LastName.value;
 
         updateConsentement({inputMap : this.questionsConsentements}).then(result => {
             console.log('result updateConsentement: ' + result);
         }).catch(error => {
             console.log('got error Consentement ansower update', error);
         });

         this.showSpinner = false;
         if (this.isInformErreurOctopus) {
             this.dispatchEvent(
                 new ShowToastEvent({
                     title: 'Information',
                     message: this.informMessageOctopus,
                     variant: 'info',
                 }),
             ); 
         }
         if (this.isWarningErreurOctopus) {
             this.dispatchEvent(
                 new ShowToastEvent({
                     title: 'Avertissement',
                     message: this.warningMessageOctopus,
                     variant: 'warning',
                 }),
             ); 
         }
         this.dispatchEvent(
             new ShowToastEvent({
                 title: 'Succès',
                 message: 'Contact ' + recordName + ' a été modifié.',
                 variant: 'success',
             }),
         );
         // revérifier si les nouvelles adresses mails sont valides et puis fermer l'onglet.
         this.callVerifyNPAIFlagApi();
         
     }
     /**
      * Permet d'afficher le modal d'annulation du formulaire
      */
     handleOpenCancelModal() {
         if (this.listAddressResult !== undefined) {
             this.template.querySelector('[data-id="listAddressSuggested"]').classList.add('slds-hide');
         }
         this.isOpenModal = true;
     }
     /**
      * Permet de fermer le modal d'annulation du formulaire
      */
     handleCloseCancelModal() {
         if (this.listAddressResult !== undefined) {
             this.template.querySelector('[data-id="listAddressSuggested"]').classList.remove('slds-hide');
         }
         this.isOpenModal = false;
     }
     /**
      * Permet de fermer l'onglet actif
      */
     handleCloseTab() {
         //console.log("closeTab");
         var close = true;
         const closeclickedevt = new CustomEvent('closeclicked', {
             detail: { close },
         });
         // Fire the custom event
         this.dispatchEvent(closeclickedevt);
     }
     /**
      * Permet d'empêcher l'insertion de charactères non numériques dans les champs de numéros de téléphone
      * @param {*} event 
      */
     // PAS ENCORE UTILISEE
     handleKeyDownNumTel(event) {
         //let content;
         let key = event.which || event.keyCode;
         let ctrl = event.ctrlKey ? event.ctrlKey : ((key === 17) ? true : false);
         var pattAlpha = new RegExp("^[\\Wa-zA-Z]+$");
         //content = event.target.value;
         if( (key !== 86 & ctrl) || !pattAlpha.test(key) ) {
             event.preventDefault();
         }
     }
     /**
      * Permet d'empêcher l'insertion de charactères non numériques dans les champs de numéros de téléphone incluant le copier/coller
      * @param {*} event 
      */
     handleKeyUpNumTel(event) {
         let content;
         let key = event.which || event.keyCode;
         let ctrl = event.ctrlKey ? event.ctrlKey : ((key === 17) ? true : false);
         var pattAlpha = new RegExp("^[\\Wa-zA-Z]+$");
         content = event.target.value;
         if (content)
             content = content.replace(/([\Wa-zA-Z])/g, '');
         if( (key === 86 & ctrl) || !pattAlpha.test(key) ) {
             event.target.value = this.putSpaceBetweenPhoneNumbers(content);
         } else {
             event.preventDefault();
         }
     }
     /**
      * Permet de griser les champs d'Email, de numéros Fixe ou de numéros Mobile lorsque la case à cochée Refus est cochée
      * @param {*} event 
      */
     handleChangeRefus(event) {
         this.disableOrEnableInputFields(event.currentTarget.dataset.id, event.target.value);
     }
     handleChangeConsentements(event) {
         //const selectedOption = event.detail.value;
         this.questionsConsentements.consentementResult.filter(item => item.key === event.target.name)[0].consentNew = event.detail.value;
         //console.log(`Option selected with value: ${selectedOption}`);
         console.log( this.questionsConsentements );
     }

     // Fonctions utilitaires
     /**
      * Permet de récupérer les valeurs des champs de téléphone
      */
     getPhoneInputs() {
         this.mobile1Input = this.template.querySelector('[data-id="Mobile1"]');
         this.mobile2Input = this.template.querySelector('[data-id="Mobile2"]');
         this.mobile3Input = this.template.querySelector('[data-id="Mobile3"]');
         this.mobilePrincipalComboBox = this.template.querySelector('[data-id="mobilePrincipalComboBox"]');
         this.fixe1Input = this.template.querySelector('[data-id="Fixe1"]');
         this.fixe2Input = this.template.querySelector('[data-id="Fixe2"]');
         this.fixe3Input = this.template.querySelector('[data-id="Fixe3"]');
         this.fixePrincipalComboBox = this.template.querySelector('[data-id="telFixePrincipalComboBox"]');
     }
     /**
      * Permet de récupérer les valeurs des champs d'Email
      */
     getEmailInputs() {
         this.email1Input = this.template.querySelector('[data-id="AdresseMail1"]');
         this.email2Input = this.template.querySelector('[data-id="AdresseMail2"]');
         this.email3Input = this.template.querySelector('[data-id="AdresseMail3"]');
         this.emailPrincipalComboBox = this.template.querySelector('[data-id="emailPrincipalComboBox"]');
     }
     /**
      * Permet de savoir si 
      *    tous les champs de teléphones fixes 
      * ou tous les champs de téléphones mobiles son vide
      * ou tous les champs d'Email sont vides
      * @param {*} type Type de téléphone
      */
     isAllInputsEmpty(type) {
         if (type === 'Mobile') {
             if (this.mobile1Input && !this.mobile1Input.value && this.mobile2Input && !this.mobile2Input.value
              && this.mobile3Input && !this.mobile3Input.value) {
                 return true;
             }
         } else if (type === 'Fixe') {
             if (this.fixe1Input && !this.fixe1Input.value && this.fixe2Input && !this.fixe2Input.value
              && this.fixe3Input && !this.fixe3Input.value) {
                 return true;
             }
         } else if (type === 'Email') {
             if (this.email1Input && !this.email1Input.value && this.email2Input && !this.email2Input.value
                 && this.email3Input && !this.email3Input.value) {
                    return true;
                }       
         }
         return false;
     }
     /**
      * Permet de supprimer les espaces dans les numéros de téléphones et d'ajouter le (+33)
      * ou de rajouter les espaces et de supprimer le (+33)
      * @param {*} num Numéro de téléphone
      * @param {*} action Action à effectuer
      */
     removeOrAddAreaCodeAndSpace(num, action) {
         if(num && action === 'removeAreaCode') {
             num = num.replace('+33', '0');
             num = this.putSpaceBetweenPhoneNumbers(num);
         } else if (num && action === 'addAreaCode') {
             num = num.replace('0', '+33');
             num = this.removeSpace(num);
         } else if (num === '') {
             return null;
         }
         return num; 
     }
     /**
      * Permet de formater les numéros de téléphone pour le stockage en BDD ou pour l'affichage
      * @param {*} action Action à effectuer
      */
     formatAllPhoneNumbersInput(action) {
         this.getPhoneInputs();
         if (this.mobile1Input) {this.mobile1Input.value = this.removeOrAddAreaCodeAndSpace(this.mobile1Input.value, action);}
         if (this.mobile2Input) {this.mobile2Input.value = this.removeOrAddAreaCodeAndSpace(this.mobile2Input.value, action);}
         if (this.mobile3Input) {this.mobile3Input.value = this.removeOrAddAreaCodeAndSpace(this.mobile3Input.value, action);}
         if (this.fixe1Input) {this.fixe1Input.value = this.removeOrAddAreaCodeAndSpace(this.fixe1Input.value, action);}
         if (this.fixe2Input) {this.fixe2Input.value = this.removeOrAddAreaCodeAndSpace(this.fixe2Input.value, action);}
         if (this.fixe3Input) {this.fixe3Input.value = this.removeOrAddAreaCodeAndSpace(this.fixe3Input.value, action);}
     }
     /**
      * Permet de mettre en un espace entre les groupes de deux chiffres d'un numéro de téléphone
      * @param {*} num Numéro de téléphone
      */
     putSpaceBetweenPhoneNumbers(num) {
         if (num === null || num === undefined || typeof num !== 'string') {
             return num;
         } 
         return num.toString().replace(/(\d)(?=(\d{2})+(?!\d))/g, '$1 ');
     }
     /**
      * Vérifier le format 
      *    du numéro de telephone mobile de preference
      * ou du numéro de telephone fixe de preference
      * ou de l'email de preference
      * @param {*} str chaine de caractère
      * @param {*} typeStr Type de chaine de caractère
      */
     verifyFormat(str, typeStr) {
         let pattFixe = new RegExp("^0([1-5]|9)[0-9]{8}$");
         let pattMobile = new RegExp("^0(6|7)[0-9]{8}$");
         // eslint-disable-next-line no-useless-escape
         let pattEmail = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
         if (typeStr === 'Fixe') {
             return pattFixe.test(str);
         } else if (typeStr === 'Mobile') {
             return pattMobile.test(str);
         } else if (typeStr === 'Email') {
             return pattEmail.test(str);
         } 
         return false;
     }
     /**
      * Supprimer les espaces dans un string
      * @param {*} str 
      */
     removeSpace(str) {
         if(str && typeof str === 'string') {
             return str.split(' ').join('');
         } 
         return str;
     }
     /**
      * Rendre actif ou non les champs de téléphones ou de mail
      * @param {*} typeFields type de fields ('RefusTelMobile' ou 'RefusTelFixe' ou 'RefusEmail')
      * @param {*} val Activer ou désactiver
      */
     disableOrEnableInputFields(typeFields, val) {
         if (typeFields === 'RefusTelMobile') {
             if (this.mobile1Input) this.mobile1Input.disabled = val;
             if (this.mobile2Input) this.mobile2Input.disabled = val;
             if (this.mobile3Input) this.mobile3Input.disabled = val;
             if (this.mobilePrincipalComboBox) this.mobilePrincipalComboBox.disabled = val;
         } else if (typeFields === 'RefusTelFixe') {
             if (this.fixe1Input) this.fixe1Input.disabled = val;
             if (this.fixe2Input) this.fixe2Input.disabled = val;
             if (this.fixe3Input) this.fixe3Input.disabled = val;
             if (this.fixePrincipalComboBox) this.fixePrincipalComboBox.disabled = val;
         } else if (typeFields === 'RefusEmail') {
             if (this.email1Input) this.email1Input.disabled = val;
             if (this.email2Input) this.email2Input.disabled = val;
             if (this.email3Input) this.email3Input.disabled = val;
             if (this.emailPrincipalComboBox) this.emailPrincipalComboBox.disabled = val;
         }
     }
     /**
      * Rendre actif ou non les cases à cocher de refus
      * @param {*} typeFields type de fields ('Fixe' ou 'Mobile' ou 'Email')
      */
     disableOrEnableRefusChBox(typeFields) {
         let testAllInputsEmpty = this.isAllInputsEmpty(typeFields); 
         let refusCheckBox;
         if (typeFields === 'Fixe') {
             refusCheckBox = this.template.querySelector('[data-id="RefusTelFixe"]');
         } else if (typeFields === 'Mobile') {
             refusCheckBox = this.template.querySelector('[data-id="RefusTelMobile"]');
         } else if (typeFields === 'Email') {
             refusCheckBox = this.template.querySelector('[data-id="RefusEmail"]');
         }
         if (refusCheckBox) {
             refusCheckBox.disabled = !testAllInputsEmpty;
         } 
     }
     /**
      * 
      */
     getInputToSaveInOctopus() {
         console.log('isSendEmailOption' + this.isSendEmailOption);
         let adresseElements = {
             NoVoie: this.getValueElementByQuerySelector('[data-id="noVoie"'),
             Adresse: this.getValueElementByQuerySelector('[data-id="Street"'),
             CodePostal: this.getValueElementByQuerySelector('[data-id="noPostal"'),
             Ville: this.getValueElementByQuerySelector('[data-id="City"'),
             ComplementAdresse: this.getValueElementByQuerySelector('[data-id="complementAdresse"'),
             Chez: this.getValueElementByQuerySelector('[data-id="chez"'),
             isSendEmailOption : this.isSendEmailOption
         };
         let telMobileElements = {
             updatePrincipalMobile: this.getValueElementByQuerySelector('[data-id="mobilePrincipalComboBox"'),
             RefusTelMobile: this.getValueElementByQuerySelector('[data-id="RefusTelMobile"'),
             NewMobile1: this.removeOrAddAreaCodeAndSpace(this.getValueElementByQuerySelector('[data-id="Mobile1"'), 'addAreaCode'),
             NewMobile2: this.removeOrAddAreaCodeAndSpace(this.getValueElementByQuerySelector('[data-id="Mobile2"'), 'addAreaCode'),
             mobile3Block: {   
                 NewMobile3: this.removeOrAddAreaCodeAndSpace(this.getValueElementByQuerySelector('[data-id="Mobile3"'), 'addAreaCode')
             }
         };
         let telFixeElements = {
             updatePrincipalFixe: this.getValueElementByQuerySelector('[data-id="telFixePrincipalComboBox"'),
             RefusTelFixe: this.getValueElementByQuerySelector('[data-id="RefusTelFixe"'),
             NewTelFixe1: this.removeOrAddAreaCodeAndSpace(this.getValueElementByQuerySelector('[data-id="Fixe1"'), 'addAreaCode'),
             NewTelFixe2: this.removeOrAddAreaCodeAndSpace(this.getValueElementByQuerySelector('[data-id="Fixe2"'), 'addAreaCode'),
             Fix3Block: {   
                 NewTelFixe3: this.removeOrAddAreaCodeAndSpace(this.getValueElementByQuerySelector('[data-id="Fixe3"'), 'addAreaCode')
             }
         };
         let emailsElements = {
             updatePrincipalEmail: this.getValueElementByQuerySelector('[data-id="emailPrincipalComboBox"'),
             RefusEmail: this.getValueElementByQuerySelector('[data-id="RefusEmail"'),
             NouvelleAdresseMail1: this.getValueElementByQuerySelector('[data-id="AdresseMail1"'),
             NouvelleAdresseMail2: this.getValueElementByQuerySelector('[data-id="AdresseMail2"'),
             Email3Block: {   
                 NouvelleAdresseMail3: this.getValueElementByQuerySelector('[data-id="AdresseMail3"')
             }
         };
         let choixCanal = {
             /* Stop: {
                 stopPhoning: this.getValueElementByQuerySelector('[data-id="stopPhoning"]'),
                 stopMailing: this.getValueElementByQuerySelector('[data-id="stopMailing"]'),
                 // stopSMSing: this.getValueElementByQuerySelector('[data-id="stopSmsing"]'),
                 stopEmailing: this.getValueElementByQuerySelector('[data-id="stopEmailing"]'),
             }, */
             // FT4-185 ajout de nouveaux stops récupérées depuis WS Octopus
             Stop: {
                stopPhoning: (('stopPhoning' in this.newStops) && (this.oldStops.stopPhoning !== this.newStops.stopPhoning)) ? this.newStops.stopPhoning: null,
                stopMailing: (('stopMailing' in this.newStops) && (this.oldStops.stopMailing !== this.newStops.stopMailing)) ? this.newStops.stopMailing: null,
                stopSMSing: (('stopSMSing' in this.newStops) && (this.oldStops.stopSMSing !== this.newStops.stopSMSing)) ? this.newStops.stopSMSing: null,
                stopEmailing: (('stopEmailing' in this.newStops) && (this.oldStops.stopEmailing !== this.newStops.stopEmailing)) ? this.newStops.stopEmailing: null,
                stopPorteAPorte: (('stopPorteAPorte' in this.newStops) && (this.oldStops.stopPorteAPorte !== this.newStops.stopPorteAPorte)) ? this.newStops.stopPorteAPorte: null,
                stopAnalyseStatistique : (('stopAnalyseStatistique' in this.newStops) && (this.oldStops.stopAnalyseStatistique !== this.newStops.stopAnalyseStatistique)) ? this.newStops.stopAnalyseStatistique: null,
                stopProspectionCommerciale: (('stopProspectionCommerciale' in this.newStops) && (this.oldStops.stopProspectionCommerciale !== this.newStops.stopProspectionCommerciale)) ? this.newStops.stopProspectionCommerciale: null,
                stopAmeliorationExperienceClient: (('stopAmeliorationExperienceClient' in this.newStops) && (this.oldStops.stopAmeliorationExperienceClient !== this.newStops.stopAmeliorationExperienceClient)) ? this.newStops.stopAmeliorationExperienceClient: null,
             },
             CanalPreference: this.getValueElementByQuerySelector('[data-id="canalPreference"]')
         };
         let ret = {
             ChoixElements : {
                 AdresseContact: adresseElements,
                 TelFixe: telFixeElements,
                 TelMobile: telMobileElements,
                 AdresseEmail: emailsElements,
                 ChoixCanal: choixCanal
             },
             ContextId : this.recordId
         }
         console.log('ret: ' + JSON.stringify(ret));
         return ret;
     }
     getValueElementByQuerySelector(selector) {
         let element = this.template.querySelector(selector);
         if (element && (typeof element.value) === 'boolean') {
             return element.value;
         }
         if (element && element.value && element.value !== '') {
             return element.value;
         } 
         return null;
     }
     closeTabsAdressManuelle () {
         let template = this.template;
         setTimeout(function () {
             if (template.querySelector('[data-id="listCodesPostauxSuggested"]')) {
                 template.querySelector('[data-id="listCodesPostauxSuggested"]').classList.add('slds-hide');
             }
             if (template.querySelector('[data-id="listVillesSuggested"]')) {
                 template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
             }
             if (template.querySelector('[data-id="listRuesSuggested"]')) {
                 template.querySelector('[data-id="listRuesSuggested"]').classList.add('slds-hide');
             }
             if (template.querySelector('[data-id="listNumerosSuggested"]')) {
                 template.querySelector('[data-id="listNumerosSuggested"]').classList.add('slds-hide');
             }
         }, 500);
     }
     /**
     * Recherche manuelle code postal
     * @param {*} 
     */
     changeCodePostal(selection) {
         this.isDisabledAddressModified = false;
         this.codePostal = this.template.querySelector('[data-id="codePostal"]').value;
         if(selection === true) {
             this.selectedCodePostal = true; 
         } else {
             this.selectedCodePostal = false;
             this.template.querySelector('[data-id="noPostal"]').value = '';  
         }
         if(this.codePostal.length === 0) {
             this.isCodePostalFieldEmpty = true;
         }
         this.disabled = !(this.selectedVille && this.selectedCodePostal);
         this.listRues = [];
         this.listNumeros = [];
         this.numero = "";
         this.rue = "";
         this.secondStep = false;                   
         let ipName = 'IP_SM_CodesPostauxVilles_APISET';
         if(this.template.querySelector('[data-id="codePostal"]').value && this.template.querySelector('[data-id="codePostal"]').value.toString().length === 5) {
             let inputMap;
             if( this.ville.length < 3 ) {
                 inputMap = {
                     codePostal: this.codePostal.toString()
                 };
             } else {
                 inputMap = {
                     ville: this.ville,
                     codePostal: this.codePostal,
                     villeSelectionnee: this.selectedVille ? 1 : 0
                 };
             }
             this.template.querySelector('[data-id="listCodesPostauxSuggested"]').classList.remove('slds-hide');
             this.callIP(inputMap, ipName, true);
         } else if(!this.codePostal && this.ville.length > 2) {
             let inputMap = {
                 ville: this.ville
             };
             this.callIP(inputMap, ipName, true);            
         }
     }
     changeVille(selection) {
         this.isDisabledAddressModified = false;
         if(selection === true) {
             this.selectedVille = true; 
         } else {
             this.selectedVille = false;
             this.template.querySelector('[data-id="City"]').value = '';
         }
         this.ville = this.template.querySelector('[data-id="ville"]').value;
         if(this.ville.length === 0) {
             this.isCityFieldEmpty = true;
         }
         this.disabled = !(this.selectedVille && this.selectedCodePostal);
         this.listRues = [];
         this.listNumeros = [];
         this.numero = "";
         this.rue = "";
         this.secondStep = false;                   
         let ipName = 'IP_SM_CodesPostauxVilles_APISET';
         if(this.template.querySelector('[data-id="ville"]').value.length > 2) {
             let inputMap;
             if( !this.codePostal || this.codePostal.toString().length !== 5) {
                 inputMap = {
                     ville: this.ville,
                     villeSelectionnee: this.selectedVille ? 1 : 0 
                 };
             } else {
                 inputMap = {
                     ville: this.ville,
                     codePostal: this.codePostal,
                     villeSelectionnee: this.selectedVille ? 1 : 0
                 };
             }
             this.template.querySelector('[data-id="listVillesSuggested"]').classList.remove('slds-hide');
             this.callIP(inputMap, ipName, true);
         } else if(this.ville.length === 0 && this.codePostal && this.codePostal.length === 5) {
             let inputMap = {
                 codePostal: this.codePostal
             };
             this.callIP(inputMap, ipName, true);            
         }
     }
     changeRue(selection) {
         this.isDisabledAddressModified = false;
         if(selection === true) {
             this.selectedRue = true; 
         } else {
             this.selectedRue = false;
             this.template.querySelector('[data-id="Street"]').value = '';
         }
         this.rue = this.template.querySelector('[data-id="rue"]').value;
         if(this.rue.length === 0) {
             this.isStreetFieldEmpty = true;
         }
         var ipName = 'IP_SM_AdressesRues_Smile';
         if(this.template.querySelector('[data-id="rue"]').value.length > 2 && this.codePostal.toString().length === 5 && this.ville) {
             let inputMap = {
                 ville: this.ville,
                 codePostal: this.codePostal,
                 libelleVoie: this.rue               
             };
             this.template.querySelector('[data-id="listRuesSuggested"]').classList.remove('slds-hide');
             if(selection === true) {
                 this.callIP(inputMap, ipName, true);
             } else {
                 this.callIP(inputMap, ipName);               
             } 
         }
     };
     changeNumero() {
         this.isDisabledAddressModified = false;
         this.numero = this.template.querySelector('[data-id="numeroRue"]').value;
         this.template.querySelector('[data-id="noVoie"]').value = this.template.querySelector('[data-id="numeroRue"]').value;
     }
     loadNumero () {
         let ipName = 'IP_SM_AdressesNumeros_Smile';
         if(this.rue.length > 2 && this.codePostal.toString().length === 5 && this.ville) {
                 var inputMap = {
                     ville: this.ville,
                     codePostal: this.codePostal,
                     libelleVoie: this.rue               
                 };
             this.callIP(inputMap, ipName);
         }
     }
     setNextStep(){
         this.secondStep = !this.disabled;
     }
     get showValidateBtn () {
         return !this.typeSearchAdress && !this.secondStep
     }
     /**
     * traitement de la data pour generer deux lists une pour les ville et une pour les codes postaux
     * @param {*} 
     */
     getListsVillesCodesPostaux (list) {
         if(list) {
             this.listVilles = [];
             this.listCodesPostaux = [];
             for (var i = 0 ; i < list.length; i++) {
                 this.listVilles.push(this.removeExtraSpace(list[i].ville));
                 this.listCodesPostaux.push(list[i].codePostal);
             }
             this.listVilles = this.supressionDoublon(this.listVilles);
             this.listCodesPostaux = this.supressionDoublon(this.listCodesPostaux);
         }
     };
     /**
     * suppression des ville et code postal en doublon
     * @param {*} 
     */
     supressionDoublon (list) {
         let newList = [];
         let temp = false;
         for (let i = 0 ; i < list.length; i++) {
             if(i === 0) {
                 newList.push(list[i]);
             } else {
                 temp = false;
                 for(let j = 0; j < newList.length; j++) {
                     if(list[i] === newList[j]) {
                         temp = true;
                     }
                 }
                 if(!temp) {
                     newList.push(list[i]);
                 }
             }
         }
         return newList;
     }
     /**
     * Suppression des espaces de plus sur l'attribut ville
     * @param {*} 
     */
     removeExtraSpace (str) {
         str = str.replace(/[\s]{2,}/g," "); // Enlève les espaces doubles, triples, etc.
         str = str.replace(/^[\s]/, ""); // Enlève les espaces au début
         str = str.replace(/[\s]$/,""); // Enlève les espaces à la fin
         return str;    
     }
     /**
     * function d'appel vers les IP vlocity
     * @param {*} 
     */
     callIP(params, name, callback) {
         callIP({ inputMap: params, NameIntergation: name })
         .then(result => {
             if(name === 'IP_SM_CodesPostauxVilles_APISET') {
                 this.codesPostauxVilles = result._data;
                 if (callback) {
                     this.getListsVillesCodesPostaux(this.codesPostauxVilles);
                 }
             } else if(name === 'IP_SM_AdressesRues_Smile') {
                 this.listRues = result._data;
                 if (callback) {
                     this.loadNumero();
                 }
             } else {
                 this.listNumeros = result._data;
             }
         })
         .catch(error => {
         console.log("got error callIP ", name , error);
         });
     }
 
     callVerifyNPAIFlagApi(){
         let comboBoxEmailIndex = this.removeSpace(this.emailPrincipalComboBox.value).substring(11);
         callIP({inputMap:{ contactId:this.recordId, emailPrincipal:this["email"+comboBoxEmailIndex+"Input"].value,idtiers:null}, NameIntergation:"IP_SM_getNPAIFlag_APISET"})
         .then(result => {
                 const message = {
                     npaiFlag: result.isNPAIFlag
                   }; 
                   // puplier le message pour activer ou désactiver le falg NPAI.             
                   publish(this.messageContext, NPAI_FLAG, message);
                   // et puis fermer l'onglet. 
                   this.handleCloseTab();
            // }          
         })
         .catch(error => {
             console.log('got error ', error);
             // fermer l'onglet 
             this.handleCloseTab();
             return false;
         });
     }
 
 }