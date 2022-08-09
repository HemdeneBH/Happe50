/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-21-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
 import {LightningElement, api, track, wire} from 'lwc';
 import { switchTheme,loadUserTheme} from 'c/hp_ec_utl_styleManager';
 import {  NavigationMixin } from 'lightning/navigation';

 import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
 import getContractsAddresses from '@salesforce/apex/HP_EC_LoadCustomerData.getContractsAddresses';
 import getEmailValidation from '@salesforce/apex/HP_EC_LoadCustomerData.getEmailValidation';
 import getTelephoneValidation from '@salesforce/apex/HP_EC_LoadCustomerData.getTelephoneValidation';
 import getAdressesDQE from '@salesforce/apex/HP_EC_LoadCustomerData.getSuggestionsDQE';
 import getComplementsDQE from '@salesforce/apex/HP_EC_LoadCustomerData.getComplementsDQE';
 import resetPasswordFromProfile from '@salesforce/apex/HP_EC_Util_PasswordManager.resetPasswordFromProfile';
 import updateEmail from '@salesforce/apex/HP_EC_UpdateCustomerData.updateEmail';
 import hpSaveClient from '@salesforce/apex/HP_EC_UpdateCustomerData.hpSaveClient';
 import updateAvatar from '@salesforce/apex/HP_EC_UpdateCustomerData.updateAvatar';
 import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 import ECAVATARMC from '@salesforce/messageChannel/hp_ec_avatarPortal__c';
 import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
 import { MessageContext, publish } from 'lightning/messageService';
 import HP_EC_icon_fox from '@salesforce/resourceUrl/HP_EC_icon_fox'
 import HP_EC_icon_croco from '@salesforce/resourceUrl/HP_EC_icon_croco'
 import HP_EC_icon_fish from '@salesforce/resourceUrl/HP_EC_icon_fish'
 import HP_EC_icon_koala from '@salesforce/resourceUrl/HP_EC_icon_koala'
 import HP_EC_icon_parrot from '@salesforce/resourceUrl/HP_EC_icon_parrot'
 import HP_EC_icon_reindeer from '@salesforce/resourceUrl/HP_EC_icon_reindeer'
 import HP_EC_icon_bear from '@salesforce/resourceUrl/HP_EC_icon_bear'
 import HP_EC_icon_rat from '@salesforce/resourceUrl/HP_EC_icon_rat'
 import HP_EC_icon_chick from '@salesforce/resourceUrl/HP_EC_icon_chick'
 import HP_EC_icon_elephant from '@salesforce/resourceUrl/HP_EC_icon_elephant'
 import HP_EC_icon_doggy from '@salesforce/resourceUrl/HP_EC_icon_doggy'
 import HP_EC_icon_dog from '@salesforce/resourceUrl/HP_EC_icon_dog'
 import HP_EC_icon_rabbit from '@salesforce/resourceUrl/HP_EC_icon_rabbit'
 import HP_EC_icon_cow from '@salesforce/resourceUrl/HP_EC_icon_cow'
 import HP_EC_icon_modify from '@salesforce/resourceUrl/HP_EC_icon_modify'
 import HP_EC_icon_confirm from '@salesforce/resourceUrl/HP_EC_icon_confirm';
 import {
     loadScript,
     loadStyle
 } from 'lightning/platformResourceLoader';
 import jQuery from '@salesforce/resourceUrl/HP_EC_jQuery';
 export default class Hp_ec_profilClient extends LightningElement{
     @api reference;
     @api result;
     @track showToast = false
     @track messageToast
     @track emailDesabledBtn = true
     @track successMessage = false
     @api titleText
     @api messageConfirmationIncorrecte;
     @api messageFormatIncorrecte;
     @api infoBulle;
     @track ContractsAddresses;
     @track showCotitulairePopup = false;
     @track desableMdpBtn = true;
     @track codeIso = 'FRA';
     @track indicatif = '+33';
     @track fixeChanged = false;
     @track fixeDesabledBtn = true;
     @track mobileChanged = false;
     @track mobileDesabledBtn = true;
     @track emailChanged = false
     @track email
     @track numFix
     @track numMobile
     @track adressFacturation
     @track adressFacturationPart1
     @track adressFacturationPart2
     @track checkIsNumFixe
     @track hasListeNumero = false;
     @track hasComplement = false;
     @track adressesDQE;
     @track adressesDQEList;
     @track adressesDQEComplemet;
     @track adresseChoisie = {};
     @track displayInbox = false;
     @track functionDesableBtn = true;
     @track showError = false;
     @track key;
     @track contactId;
     @track consentementList=[];
     @track questions;
     @track responses;
     @track noVoie;
     @track mailingStreet;
     @track mailingPostalCode;
     @track mailingCity;
     @track tabFact = [];
     @track name;
     @track adressPortfeilleContat;
     @track adressPFContratPart1;
     @track adressPFContratPart2;
     
     iconFox = HP_EC_icon_fox;
     iconParrot = HP_EC_icon_parrot;
     iconCroco = HP_EC_icon_croco;
     iconKoala = HP_EC_icon_koala;
     iconFish = HP_EC_icon_fish;
     iconBear = HP_EC_icon_bear;
     iconRabbit = HP_EC_icon_rabbit;
     iconDoggy = HP_EC_icon_doggy;
     iconDog = HP_EC_icon_dog;
     iconCow = HP_EC_icon_cow;
     iconRat = HP_EC_icon_rat;
     iconReindeer = HP_EC_icon_reindeer;
     iconElephant = HP_EC_icon_elephant;
     iconChick = HP_EC_icon_chick;
     iconModify = HP_EC_icon_modify;
     iconConfirm = HP_EC_icon_confirm;
     infosEmailToSend = {};
     divProfilIsShow = false;
     pictoNumerosIsShow = false;
     pictoFacturationIsShow = false;
     newEmailAdress;
     newMDP;
     confirmNewMDP;
     isSelected = false;
     countEmailTentatives  = 0
     listOfAvatarToDisplay;
     //selectedAvatar; 
     @wire(MessageContext) messageContext;
     getAvatar(event){
         //this.selectedAvatar = event.target.src;
         let avatar = event.target.src;
         if(avatar){
             const message = {
                 selectedAvatar:event.target.src
             }
             publish(this.messageContext, ECAVATARMC, message);
             if(this.reference){
                 updateAvatar({idTiers: this.reference, avatar: avatar}).then(response=>
                     {
                        if(response.success == true){
                            console.log("Success avatar change change");
                        }
                     });
             }
         }
     }

     @wire(getContactData)
     wiredGetContactData({ data, error }) {
         if (data) {
             this.result = JSON.parse(data);
             this.contactId = this.result.Id;
             this.name = this.result.FirstName+' '+this.result.LastName;
             this.reference = this.result.ID_Tiers__c;
             // this.adressPortfeilleContat = 
             this.email =  this.result.Email;
             this.numFix = this.result.Phone;
             this.numMobile = this.result.MobilePhone;
             this.adressFacturation = this.result.No_Voie__c+', '+this.result.MailingStreet+' '+this.result.MailingPostalCode+' '+this.result.MailingCity;
             this.adressFacturationPart1 = this.result.No_Voie__c+', '+this.result.MailingStreet;
             this.adressFacturationPart2 = this.result.MailingPostalCode+' '+this.result.MailingCity;
             this.noVoie = this.result.No_Voie__c;
             this.mailingStreet = this.result.MailingStreet;
             this.mailingPostalCode = this.result.MailingPostalCode;
             this.mailingCity = this.result.MailingCity;
         }
         if (error) {
             console.log('Error : ' + JSON.stringify(error));
         }
     }
     connectedCallback() {
         this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
         this.handleSubscription();
         this.populateContractInfo();
     }
     handleSubscription() {
         subscribeMC(this, this.messageContext, this.handleLightningMessage);
     }
     handleLightningMessage(self, subscription, message) {
         if (message.messageType == 'SelectedPortfolio') {
             self.idPortefeuilleContrat = message.messageData.message;
             self.populateContractInfo();
         }
     }

     @wire(getContractsAddresses) 
     wiredContractsAddresses({ error, data }) {
         if (data) {
             this.ContractsAddresses = data;
         }
         else if (error) {
             console.log('Error get addresses'+JSON.stringify(error));
         }
     }
     async populateContractInfo() {
         this.initialiseGlobalVar();
         if (!this.ContractsAddresses) {
             this.ContractsAddresses = await this.getAdressContract();
         }
         if (this.ContractsAddresses) {
             let adressData = JSON.parse(this.ContractsAddresses)._data
             adressData.forEach(keyPortfolio => {
                 if(keyPortfolio.idPortefeuilleContrat == this.idPortefeuilleContrat){
                     keyPortfolio.locaux.forEach(keyLocal=>{
                             this.adressPFContratPart1 = keyLocal.numeroVoie + ' ' + keyLocal.libelleVoie
                             this.adressPFContratPart2 = keyLocal.codePostal + ' ' + keyLocal.ville
                         })
                 }
             });
         }
         if(!this.result){
             const data = await this.getContactData();
             this.result = JSON.parse(data);
             this.contactId = this.result.Id;
             this.name = this.result.FirstName+' '+this.result.LastName;
             this.reference = this.result.ID_Tiers__c;
             // this.adressPortfeilleContat = 
             this.email =  this.result.Email;
             this.numFix = this.result.Phone;
             this.numMobile = this.result.MobilePhone;
             this.adressFacturation = this.result.No_Voie__c+', '+this.result.MailingStreet+' '+this.result.MailingPostalCode+' '+this.result.MailingCity;
             this.adressFacturationPart1 = this.result.No_Voie__c+', '+this.result.MailingStreet;
             this.adressFacturationPart2 = this.result.MailingPostalCode+' '+this.result.MailingCity;
             this.noVoie = this.result.No_Voie__c;
             this.mailingStreet = this.result.MailingStreet;
             this.mailingPostalCode = this.result.MailingPostalCode;
             this.mailingCity = this.result.MailingCity;
         }
     }
     async getAdressContract() {
         return new Promise(async (resolve, reject) => {
             console.log('in get adress pf contart');
             var result = await getContractsAddresses().then(response => {
                 return response;
             }).catch(error => {
                 console.log('***Error getContractsAddresses : ' + JSON.stringify(error));
                 return error;
             });
             resolve(result);
         })
     }
     handlePublish(message) {
         // publishMC(this.messageContext, message, 'SelectedEnergy');
     }
     showPopinCotitulaire(event){
         this.showCotitulairePopup = true;
     }
     openPopinCotitulaire(event){
         if(event.detail === true){
             this.showCotitulairePopup = true;
         }else {
             this.showCotitulairePopup = false;
         }
     }
     closePopinCotitulaire(event){
         this.dispatchEvent(new CustomEvent('openpopinccotitulaire', { detail: false}));
     }
     renderedCallback(){
         loadScript(this, jQuery)
         .then(() => {
             console.log('JQuery loaded.');
             console.log(this.template.querySelector('.hp-profil-carousel'));
         })
         .catch(error=>{
             console.log('Failed to load the JQuery : ' +error);
         });
         const listEl = this.template.querySelector('.hp-profil-carousel');
         const btnLeftEl = this.template.querySelector(`[data-id="left-btn"]`);
         const btnRightEl = this.template.querySelector(`[data-id="right-btn"]`);
         let count = 0;
         btnLeftEl.addEventListener("click", function(e) {
             count++;
             listEl.style.left = count * 285 + 'px';
             listEl.style.transform = "translateX(5%)";
             if (count > -2) {
                 btnRightEl.style.display = 'block';
             }
             if (count >= 0) {
                 btnLeftEl.style.display = 'none';
             }
         });
         btnRightEl.addEventListener("click", function(e) {
             count--;
             listEl.style.left = count * 285 + 'px';
             listEl.style.transform = "translateX(-5%)";
             if (count < 0) {
                 btnLeftEl.style.display = 'block';
             }
             if (count <= -2) {
                 btnRightEl.style.display = 'none';
             }
         });
     }
     @api switchStyle(styleName) {
         switchTheme.call(this, styleName);
     }
     
     async getContactData() {
         return new Promise(async (resolve, reject) => {
             var result = await getContactData()
                 .then(data => {
                     return data;
                 })
                 .catch(error => {
                     console.log('error get contact data: ' + JSON.stringify(error));
                 });
             resolve(result);
         })
     }
     initialiseGlobalVar(){
         this.reference = null;
         this.result = null;
         this.showToast = false
         this.messageToast = null;
         this.emailDesabledBtn = true;
         this.successMessage = false;
         this.ContractsAddresses = null;
         this.showCotitulairePopup = false;
         this.desableMdpBtn = true;
         this.codeIso = 'FRA';
         this.indicatif = '+33';
         this.fixeChanged = false;
         this.fixeDesabledBtn = true;
         this.mobileChanged = false;
         this.mobileDesabledBtn = true;
         this.emailChanged = false
         this.email = null;
         this.numFix = null;
         this.numMobile = null;
         this.adressFacturation = null;
         this.adressFacturationPart1 = null;
         this.adressFacturationPart2 = null;
         this.checkIsNumFixe = null;
         this.hasListeNumero = false;
         this.hasComplement = false;
         this.adressesDQE = null;
         this.adressesDQEList = null;
         this.adressesDQEComplemet = null;
         this.adresseChoisie = {};
         this.displayInbox = false;
         this.functionDesableBtn = true;
         this.showError = false;
         this.key = null;
         this.contactId = null;
         this.consentementList=[];
         this.questions = null;
         this.responses = null;
         this.noVoie = null;
         this.mailingStreet = null;
         this.mailingPostalCode = null;
         this.mailingCity = null;
         this.tabFact = [];
         this.name = null;
         this.adressPortfeilleContat = null;
         this.infosEmailToSend = {};
         this.adressPFContratPart1 = null;
         this.adressPFContratPart2 = null;
         this.divProfilIsShow = false;
         this.pictoNumerosIsShow = false;
         this.pictoFacturationIsShow = false;
         this.newEmailAdress = null;
         this.newMDP = null;
         this.confirmNewMDP = null;
         this.isSelected = false;
         this.countEmailTentatives = 0;
         this.listOfAvatarToDisplay = null;
     }
     handleSubmit() {
         let infosPersonne = {
             "ref" : null,
             "civilite" : null,
             "nom" : null,
             "prenom": null,
             "numeroFixe": "",
             "numeroMobile": "",
             "email": null,
             "prospect": false,
             "client": true,
             "numVoie": null,
             "voie": null,
             "complementAdresse": "",
             "codePostal": null,
             "ville": null,
             "pays": "FR",
             "numeroEtranger":"",
             "stopEmail" : true,
             "stopSms" : true,
             "optinMarketing" : true
         };
         infosPersonne.ref = this.reference;
         infosPersonne.civilite = this.result.Salutation;
         infosPersonne.prenom = this.result.FirstName;
         infosPersonne.nom = this.result.LastName;
         infosPersonne.numeroFixe = this.numFix != null? this.numFix.replace('+33', '0') : null;
         infosPersonne.numeroMobile = this.numMobile != null ? this.numMobile.replace('+33', '0'): null;
         infosPersonne.email = this.email;
         infosPersonne.numVoie =  this.noVoie;
         infosPersonne.voie = this.mailingStreet;
         infosPersonne.codePostal = this.mailingPostalCode;
         infosPersonne.ville = this.mailingCity;
         infosPersonne.id = this.contactId;
         const contactUpdated = hpSaveClient({client:infosPersonne}).then(result => {
             console.log('Succès update xdata  ');
         }).catch(error => {
             console.log('Erreure xdata : '+JSON.stringify(error));
         });
         this.dispatchEvent(new CustomEvent('openpopinconsentements', { detail: false}));
     }
     showDivProfile() {
         this.divProfilIsShow = !this.divProfilIsShow
     }
     
     showPictosNumeros(){
         this.pictoNumerosIsShow = !this.pictoNumerosIsShow
     }

     showPictoFacturation(){
         this.pictoFacturationIsShow = !this.pictoFacturationIsShow
     }

     openVFToast(event){
         if(event.detail === true){
             this.showToast = true;
         }else {
             this.showToast = false;
         }
     }

      displayToast(title, message, variant) {
         const event = new ShowToastEvent({
             title: title,
             message: message,
             variant: variant,
             mode: 'dismissable'
         });
         this.dispatchEvent(event);
     }

     handleEmail(event) {
        //  this.emailChanged = false;
         if(this.email !==  event.target.value ) {
             this.emailChanged = true;
             this.emailDesabledBtn = true;
             //this.emailValidation(event);
         } else {
             this.emailChanged  = false;
         }
         this.infosEmailToSend.email = true;
         this.infosEmailToSend.email = this.email;
         console.log('***********emailChanged ',this.emailChanged);
         //this.emailValidation(event);
     }

     handleBlurEmail(event){
         console.log('***********bluuuuuuuuuuuuur '+event.target.value);
         this.countEmailTentatives = this.countEmailTentatives + 1;
         if( this.emailChanged ) this.emailValidation(event);
     }

     emailValidation(event) {
         let emailEvent = event.target.value;
         //String(event.target.value).includes('.com') || String(event.target.value).includes('.fr') : no one really knows why we verify just .fr and .com
         let isEmailValid = ( String(event.target.value).endsWith('.fr') || String(event.target.value).endsWith('.com')) && String(event.target.value).includes('@') ;
         if (isEmailValid) {
             getEmailValidation({ email: String(emailEvent) }).then(result => {
                 if (result.IdError === "00" || (result.IdError === "95" && this.countEmailTentatives == 3)) {
                     this.emailDesabledBtn = false
                    //  this.email = emailEvent;
                     this.template.querySelector(`[data-id="messageEmail"]`).style.color = '';
                     this.template.querySelector(`[data-id="messageEmail"]`).innerHTML = '';
                 }else{
                     this.template.querySelector(`[data-id="messageEmail"]`).style.color = '#da42bd';
                     this.template.querySelector(`[data-id="messageEmail"]`).innerHTML = "L'email presente des erreurs " + emailEvent;
                 }
             }).catch(error => {
                 console.log('error',JSON.stringify(error));
             })
         }
     }

     emailActions(){
        if(!this.emailDesabledBtn){
            const nvEmail = this.template.querySelector(`[data-id="new-email"]`).value;
            this.email = nvEmail;
            console.log('this.email '+this.email)
            updateEmail({idTiers: this.reference, email: nvEmail}).then(response=>
                {
                   if(response.success == true){
                       console.log("Success email change change, response sucsess "+response.success);
                   }
                });
            this.handleSubmit();
            this.successMessage = true
            setTimeout(()=>{
                this.successMessage = false
            }, 3000);
        }
    }

     checkMdp() {
         this.newMDP = this.template.querySelector(`[data-id="new-mdp"]`).value
         this.confirmNewMDP = this.template.querySelector(`[data-id="confirm-mdp"]`).value
         if(this.newMDP != this.confirmNewMDP){
             this.showError = true;
             this.template.querySelector(`[data-id="message"]`).style.color = '#da42bd';
             this.template.querySelector(`[data-id="message"]`).innerHTML = this.messageConfirmationIncorrecte;
             this.desableMdpBtn = true
          }else if(/^(?=.{8,})(?=.*?\d)(?=.*[\s!\"#$\%&'\(\)\*\+\,\-\.\/\:;<=>?@\[\\\]\^\_\`\{\|\}\~])(?=[a-zA-Z0-9].*?[a-zA-Z0-9].*?[a-zA-Z0-9].*?).*$/.test(this.newMDP) != true){
             this.showError = true;
             this.template.querySelector(`[data-id="message"]`).style.color = '#da42bd';
             this.template.querySelector(`[data-id="message"]`).innerHTML = this.messageFormatIncorrecte;
             this.desableMdpBtn = true;
          }else{
             this.template.querySelector(`[data-id="message"]`).style.color = '';
             this.template.querySelector(`[data-id="message"]`).innerHTML = '';
             this.desableMdpBtn = false;
             this.showError = false;
          }
          return !this.showError; 
     }
     btnMdpAction(){
     if(this.checkMdp()){
         resetPasswordFromProfile({idTiers: this.reference, password: this.newMDP}).then(response=>{
             if(response.success == true){
                 this.successMessage = true
                 setTimeout(()=>{
                 this.successMessage = false
             }, 3000);
             }
             }).catch(error =>{
                 console.log('Error Resetting Password : '+JSON.stringify(error));
             })
         }
     }
     telephoneValidation(event) {
         let tel = event.target.value;
         if(tel.length == 9 && tel[0] != '0') {
             tel = '0' + tel; 
         }
         if (tel.length == 10) {
             getTelephoneValidation({ telephone: String(tel),pays:this.codeIso }).then(result => {
                 if (result.IdError === 0) {
                     // this.messageToast = "Le numero renseigné n'est pas atribué" , 'info';
                     // this.showToast = true
                     if(this.fixeChanged){
                         this.template.querySelector(`[data-id="messageFixe"]`).style.color = '#da42bd';
                         this.template.querySelector(`[data-id="messageFixe"]`).innerHTML = "Le numero renseigné n'est pas atribué";
                     }
                     else{
                         this.template.querySelector(`[data-id="messageMobile"]`).style.color = '#da42bd';
                         this.template.querySelector(`[data-id="messageMobile"]`).innerHTML = "Le numero renseigné n'est pas atribué";
                     }
                 }
                 else{
                     if(this.checkIsNumFixe){
                     this.fixeDesabledBtn = false;
                    //  this.numFix = tel;
                     this.template.querySelector(`[data-id="messageFixe"]`).style.color = '';
                     this.template.querySelector(`[data-id="messageFixe"]`).innerHTML = '';
                     }
                     else{
                     this.mobileDesabledBtn = false;
                    //  this.numMobile = tel;
                     this.template.querySelector(`[data-id="messageMobile"]`).style.color = '';
                     this.template.querySelector(`[data-id="messageMobile"]`).innerHTML = '';
                     }
                 }
             }).catch(error => {
                 console.log('error',JSON.stringify(error));
             });
         }
     }
      handleNumFixe(event) {
         this.checkIsNumFixe = true;
         if(this.numFix !==  event.target.value ) {
             this.fixeChanged = true;
             this.fixeDesabledBtn = true;
         } else {
             this.fixeChanged  = false;
         }
         console.log('***********num fixe changed ',this.fixeChanged);
     }
     handleBlurNumFixe(event){
         console.log('***********bluuuuuuuuuuuuur fixe num ',event.target.value);
         if( this.fixeChanged ) this.telephoneValidation(event);
     }
     numFixeAction(){
         if(!this.fixeDesabledBtn){
            const nvNumFix = this.template.querySelector(`[data-id="new-fixe"]`).value;
            this.numFix = this.addIndicatifToPhoneNumber(nvNumFix);
             this.handleSubmit();
             this.successMessage = true
             setTimeout(()=>{
                 this.successMessage = false
             }, 3000);
         }
     }
     handleNumMobile(event) {
         this.mobileChanged = false;
         this.checkIsNumFixe = false
         if(this.numMobile !==  event.target.value ) {
             this.mobileChanged = true;
             this.mobileDesabledBtn = true;
         } else {
             this.mobileChanged  = false;
         }
         console.log('***********num mobile changed ',this.emailChanged);
     }
     handleBlurNumMobile(event){
         console.log('***********bluuuuuuuuuuuuur mobile num ',event.target.value);
         if( this.mobileChanged ) this.telephoneValidation(event);
     }
     numMobileAction(){
         if(!this.mobileDesabledBtn){
            const nvNumMobile = this.template.querySelector(`[data-id="new-mobile"]`).value;
            this.numMobile =  this.addIndicatifToPhoneNumber(nvNumMobile);
             this.handleSubmit();
             this.successMessage = true
             setTimeout(()=>{
                 this.successMessage = false
             }, 3000);
         }
     }
     //adresse de facturation 
     getSearchResult(event) {
         if (event.target.label === 'Adresse de contact :') {
             if(this.isSelected) {
                 this.isSelected = false;
                 return;
             }
             this.hasComplement = false;
             this.hasListeNumero = false;
             let input = event.target.value;
             let splitSpaceStr = input.split(' ');
             let inputSplit = input.split('|');
             let arrayLength = inputSplit && inputSplit.length;
             input = inputSplit[0];
             if(arrayLength >= 2) input = input + ' '+inputSplit[1];
             input = input.replaceAll('|', ' ');
             //input = input.split(' ').join('+');
                 if(input.length>7 || (splitSpaceStr && splitSpaceStr[1] && splitSpaceStr[1].length>1)){
                     getAdressesDQE({input}).then(resultat => {
                         this.displayInbox = false
                         if(resultat){
                             this.displayInbox = true
                         }
                         this.adressesDQE = resultat;
                         try{
                         this.template.querySelector('[data-id="listbox"]').classList.remove('display-none');
                     }catch(e){}
                         try{
                         this.template.querySelector('[data-id="listboxIn"]').classList.remove('display-none');
                     }catch(e){}
                         try{
                         this.template.querySelector('[data-id="listbox"]').classList.add('display-table');
                     }catch(e){}
                     }).catch(error => {
                         this.searchResult = undefined;
                         try{
                         this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
                     }catch(e){}
                         try{
                         this.template.querySelector('[data-id="listboxIn"]').classList.add('display-none');
                     }catch(e){}
                         try{
                         this.template.querySelector('[data-id="listbox"]').classList.remove('display-table');
                     }catch(e){}
                     });
                 } else {
                     this.searchResult = undefined;
                 try{
                     this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
                 }catch(e){}
                 try{
                 this.template.querySelector('[data-id="listboxIn"]').classList.add('display-none');
                 }catch(e){}
                 try{
                     this.template.querySelector('[data-id="listbox"]').classList.remove('display-table');
                 }catch(e){}
                 }
         }
     }
     selectedValue(event){
         this.noVoie = event.currentTarget.dataset.housenumber;
         this.tabFact.push(this.noVoie);
         this.mailingPostalCode = event.currentTarget.dataset.postcode;
         this.tabFact.push(this.mailingPostalCode);
         this.mailingCity = event.currentTarget.dataset.city;
         this.tabFact.push(this.mailingCity);
         this.mailingStreet = event.currentTarget.dataset.street;
         this.tabFact.push(this.mailingStreet);
         this.adressFacturationPart1 = this.noVoie+', '+this.mailingStreet;
         this.adressFacturationPart2 = this.mailingPostalCode+' '+this.mailingCity;
         this.isSelected = true;
         this.adressesDQEComplemet = undefined;
         let listnum = event.currentTarget.dataset.listenumero;
         let selectedadresseChoisie = {
             id : event.currentTarget.dataset.id,
             label : event.currentTarget.dataset.name,
             numero : event.currentTarget.dataset.housenumber,
             voie :  event.currentTarget.dataset.street,
             codePostal : event.currentTarget.dataset.postcode,
             ville : event.currentTarget.dataset.city,
             idLocalite : event.currentTarget.dataset.citycode,
             listeNumero : event.currentTarget.dataset.listenumero,
             idVoie : event.currentTarget.dataset.idvoie,
             cmpAdress:'',
         }
         this.adresseChoisie = {
             housenumber: event.currentTarget.dataset.housenumber,
             street: event.currentTarget.dataset.street,
             postcode:event.currentTarget.dataset.postcode,
             city:event.currentTarget.dataset.city,
             cmpAdress:'',
             citycode: event.currentTarget.dataset.citycode
         }
         this.adresseActuelle= event.currentTarget.dataset.name;
         if(listnum!=="" && !event.currentTarget.dataset.housenumber){
             listnum = listnum && listnum.toString().split(';');
             this.adressesDQEList =   listnum.map((item)=>({...selectedadresseChoisie,numero:item}));
        
             this.hasListeNumero = true;
         } 
         if(event.currentTarget.dataset.housenumber){
              // call dqe complement adresse
              let input = 'IDVoie='+event.currentTarget.dataset.idvoie+'&IDNum='+event.currentTarget.dataset.housenumber;
              this.template.querySelector('[data-id="listbox"]').style.display='none';
              this.template.querySelector('[data-id="listboxIn"]').style.display='none';
              getComplementsDQE({input}).then(resultat => {
                  this.hasComplement = resultat && resultat.length >0 ;
                  this.adressesDQEComplemet =resultat;
                  if( this.adressesDQEComplemet === undefined || (this.adressesDQEComplemet && this.adressesDQEComplemet.length === 0)) 
                  {
                      this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
                      this.template.querySelector('[data-id="listboxIn"]').classList.add('display-none');
                      this.template.querySelector('[data-id="listbox"]').classList.remove('display-table');
                  }
              }).catch(error => {
                                         console.log('@@ error bb ' + JSON.stringify(error));
                                         {
                                             this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
                                             this.template.querySelector('[data-id="listboxIn"]').classList.add('display-none');
                                             this.template.querySelector('[data-id="listbox"]').classList.remove('display-table');
                                         }
              });
              this.template.querySelector('[data-id="overview"]').value = event.currentTarget.dataset.name;
     }
     }
     selectedSecondValue(event){
         if(this.hasListeNumero){
             this.adresseActuelle= event.currentTarget.dataset.housenumber +' '+ event.currentTarget.dataset.name;
             this.adresseChoisie = {...this.adresseChoisie,housenumber: event.currentTarget.dataset.housenumber}
             let input = 'IDVoie='+event.currentTarget.dataset.idvoie+'&IDNum='+event.currentTarget.dataset.housenumber;
         getComplementsDQE({input}).then(resultat => {
             this.hasComplement = true;
             this.hasListeNumero = false;
             this.adressesDQEComplemet =resultat;
             if( this.adressesDQEComplemet === undefined || (this.adressesDQEComplemet && this.adressesDQEComplemet.length === 0)) 
              {
                     this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
                     this.template.querySelector('[data-id="listboxIn"]').classList.add('display-none');
                     this.template.querySelector('[data-id="listbox"]').classList.remove('display-table');
                 }
         }).catch(error => {
                                    console.log('@@ error ' + JSON.stringify(error));
                                    {
                                     this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
                                     this.template.querySelector('[data-id="listboxIn"]').classList.add('display-none');
                                     this.template.querySelector('[data-id="listbox"]').classList.remove('display-table');
                                 }
         });
     }
     }
     selectedThirdValue(event){
         this.adresseActuelle = this.adresseActuelle +'|'+event.currentTarget.dataset.name;
         this.hasComplement = false;
         this.hasListeNumero = false;
         this.adresseChoisie = {...this.adresseChoisie,cmpAdress: event.currentTarget.dataset.name};
         this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
         this.template.querySelector('[data-id="listboxIn"]').classList.add('display-none');
         this.template.querySelector('[data-id="listbox"]').classList.remove('display-table');
     }
     handleBluradresseFacturation(event){
         console.log('***********bluuuuuuuuuuuuur handel adress fact  ',event.target.value);
         this.functionDesableBtn = false;
     }
     adresseFacturationAction(){
         if(!this.functionDesableBtn){
             this.handleSubmit();
             this.successMessage = true
             setTimeout(()=>{
                 this.successMessage = false
             }, 3000);
         }
     }  
     
     addIndicatifToPhoneNumber(phoneNumber){
        var numPhone;
        if(phoneNumber.length == 9 && phoneNumber[0] != '0') {
            phoneNumber = '0'+phoneNumber; 
        }
        if(phoneNumber.startsWith('0') && phoneNumber.length == 10){
            console.log('in indicatif add ')
            numPhone = phoneNumber.substring(1);
            numPhone = '+33'+numPhone;
        }
        return numPhone;
     }
     
 }