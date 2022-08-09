/**
 * @File Name          : hp_modifyClientInfos.js
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Mohamed Aamer
 * @Last Modified On   : 24/02/2020 à 11:24:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/01/2020   Mohamed Aamer     Initial Version
**/
import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';
import {
    updateRecord,
    getRecord,
    getFieldValue
} from 'lightning/uiRecordApi';
import getConsentQuestions from '@salesforce/apex/HP_SM008_APIHour.getQuestionsConsentement';
import getConsentResponses from '@salesforce/apex/HP_SM008_APIHour.getReponsesConsentement';
import sendConsentResponses from '@salesforce/apex/HP_SM008_APIHour.sendConsentResponses';
import getSuggestions from '@salesforce/apex/HP_APIGouv.getSuggestions';
import loadContact from "@salesforce/apex/HP_EM020_Contact.loadContact";
import verifyELD from '@salesforce/apex/HP_SM008_APIHour.getZonesDistributions'; // HAPP-186 Verficiation city is ELD 
import sendEmail from '@salesforce/apex/HP_SM015_ContactModifNotification.sendEmail'; // HAPP-39 Envoi Email
import SALUTATION_FIELD  from '@salesforce/schema/Contact.Salutation';
import sendSMS from '@salesforce/apex/HP_SM015_ContactModifNotification.sendSMS'; // HAPP-38 Envoi SMS 
import MOBILE_FIELD from '@salesforce/schema/Contact.MobilePhone';
import FIXE_FIELD from '@salesforce/schema/Contact.Phone';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import Email_FIELD from '@salesforce/schema/Contact.Email';
import NUM_VOIE_FIELD from '@salesforce/schema/Contact.No_Voie__c';
//import INDICATIF_PAYS from '@salesforce/schema/Contact.HP_Indicatif__c';
import MAILING_STREET_FIELD from '@salesforce/schema/Contact.MailingStreet';
import MAILING_CITY from '@salesforce/schema/Contact.MailingCity';
import MAILING_POSTALCODE_FIELD from '@salesforce/schema/Contact.MailingPostalCode';
import ADDITIONAL_ADDRESS_FIELD from '@salesforce/schema/Contact.Complement_adresse__c';	
import ID_CLIENT_XDATA from '@salesforce/schema/Contact.ID_Tiers__c';
import getTelephoneValidation from '@salesforce/apex/HP_SM0017_DQE.getTelephoneValidation';
import getContryCode from '@salesforce/apex/HP_SM003_MetadataManager.getContryCode';
import getEmailValidation from '@salesforce/apex/HP_SM0017_DQE.getEmailValidation'; 
import putPersonne from '@salesforce/apex/HP_SM008_APIHour.updatePersonne';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';


const FIELDS = [MOBILE_FIELD, FIXE_FIELD, FIRSTNAME_FIELD, LASTNAME_FIELD, NUM_VOIE_FIELD, MAILING_STREET_FIELD, MAILING_CITY, ID_CLIENT_XDATA, Email_FIELD,SALUTATION_FIELD,MAILING_POSTALCODE_FIELD,ADDITIONAL_ADDRESS_FIELD];

export default class Hp_modifyClientInfos extends NavigationMixin(LightningElement) {

    @api recordId;

    @track questions;
    @track consentIds;
    @track responses;
    @track searchResult;
    @track curentSearchResult;
    @track delayTimeout;
    @track consentToSend;
    @track tempResult = [];
    @track value = '';
    @track checked = false;
    @track properties;
    @track auto = false;
    @track house;
    @track isError = false;
    @track isGazELD = false;
    @track isElecELD = false;
    @track isElecGazELD = false;
    @track patternMobile = /^(06|07)[0-9]{8}$/;
    @track patternfixe = /^(01|02|03|04|05|09)[0-9]{8}$/;
    @track errorData = false;
    @track mailingStreet;
    @track mailingAddress;
    @track indicatif
    @track codeIso
    @track idClient;
    @track civilite ='';
    @track nom ='';
    @track prenom = '';
    @track numeroFixe = '';
    @track numeroPortable ='';
    @track email ='';
    @track numVoie ='';
    @track voie ='';
    @track complementAdresse ='';
    @track codePostale ='';
    @track ville = '';
    @track pays = '';
    @track infoPersonne;
    @track numMobileFormatted;
    @track numFixeFormatted;
   
    
   
    @track consentementList = [];
    @track loading = true;
    confirmationEmail = false;
    confirmationSMS = false;
    infosEmailToSend = {};
    emailClient = null;
    emailChanged = false;
    numMobileChanged = false;
    consentMethod = 'PUT';

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [MOBILE_FIELD, FIXE_FIELD]
    }) record;
    @wire(getRecord, {
        recordId: '$recordId',
        fields: FIELDS
    }) contact;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: FIELDS
        
    })  wiredRecord({ error, data }) {
        if (data) {
            this.contact.data = data;
            this.numMobileFormatted =  this.formatXdataPhoneNumber(getFieldValue(this.contact.data, MOBILE_FIELD));
            this.numFixeFormatted = this.formatXdataPhoneNumber(getFieldValue(this.contact.data, FIXE_FIELD));
        }
      }

    get firstname() {
        return getFieldValue(this.contact.data, FIRSTNAME_FIELD);
    }
    get lastname() {
        return getFieldValue(this.contact.data, LASTNAME_FIELD);
    }
    get voie() {
        return getFieldValue(this.contact.data, NUM_VOIE_FIELD);
    }
    get street() {
        return getFieldValue(this.contact.data, MAILING_STREET_FIELD);
    }
    get city() {
        return getFieldValue(this.contact.data, MAILING_CITY);
    }

    formatXdataPhoneNumber(phoneNumber){
        if (phoneNumber === null) return;
        return '0'.concat(phoneNumber.slice(phoneNumber.length - 9));
    }
    
    isSendEmailChecked() {
        this.confirmationEmail = !this.confirmationEmail;
    }

    isSendSMSChecked() {
        this.confirmationSMS = !this.confirmationSMS;
    }

    connectedCallback() {
        loadContact({ contactId: this.recordId }).then( resultContact => { 
            console.log('Contact xdataId ' + JSON.stringify(resultContact.ID_Tiers__c));
            this.idClient = resultContact.ID_Tiers__c;
            getConsentQuestions({}).then(resultQuestions => {
              this.questions = resultQuestions;
              this.loading = false;
              
              console.log('@@@@questions: ' + JSON.stringify(this.questions));
              for (let index = 0; index < this.questions.length; index++) {
                  this.consentementList.push({
                      idPersonne: this.idClient,
                      libelleQuestion: '',
                      idQuestion: 0,
                      idQuestionnaire: 0,
                      consent: true,
                      canal: 'Telephone',
                      application: 'HAPPE',
                      name: 'consent' + index,
                      id: '',
                      checkYes: false,
                      checkNo: true
                  });
                  this.consentementList[index].libelleQuestion = this.questions[index].libelleQuestion;
                  this.consentementList[index].idQuestion = parseInt(this.questions[index].idQuestion);
                  this.consentementList[index].idQuestionnaire = parseInt(this.questions[index].idQuestionnaire);
              }
              getConsentResponses({
                  idPersonne:this.idClient
              }).then(resultResponses => {
                 
                  this.responses = resultResponses;
                  console.log('this.responses: ', JSON.stringify(this.responses));
                  for (let index = 0; index < this.questions.length ; index++) {
                      let filterList = {
                          idQuestion: this.consentementList[index].idQuestion,
                          idQuestionnaire: this.consentementList[index].idQuestionnaire,
                      }
                      console.log('filterList: ',JSON.stringify(filterList));
                      
                      let resultFilter = this.responses.filter(function(item) {
                          for (var key in filterList) {
                            if (item[key] === undefined || item[key] != filterList[key])
                              return false;
                          }
                          return true;
                      });
                      console.log('resultFilter: ',JSON.stringify(resultFilter));
                      if(resultFilter.length > 0){
                          this.consentementList[index].idPersonne = resultFilter[0].idPersonne;
                          this.consentementList[index].consent = (resultFilter[0].consent === true);
                          this.consentementList[index].checkYes = resultFilter[0].consent === true ? true : false;
                          this.consentementList[index].checkNo = resultFilter[0].consent === false ? true : false;
                          this.consentementList[index].canal = resultFilter[0].canal;
                          this.consentementList[index].application = resultFilter[0].application;
                          this.consentementList[index].id = resultFilter[0].id;
                      }
                  }
                  console.log('this.consentementList: ', JSON.stringify(this.consentementList));
                  this.loading = false;
              }).catch(errorResponses => {
                  console.log('errorResponses: ',errorResponses);
                  this.loading = false;
                  this.displayToast('Information', "Aucun consentement enregistré pour ce client, veuillez les saisir.", 'info', []);
                  this.consentMethod = 'POST';
              });
          }).catch(resultQuestions => {
              console.log('resultQuestions',resultQuestions)
              if (resultQuestions.length > 0) {
                  this.loading = false;
                  this.displayToast('Erreur', "Une erreur est servenue lors de récupération des questions du consentement", 'error', []);
                  }
          });

              })
              .catch(error => {
                this.loading = false;
                console.log("got error loadContact", error);
              });
  
    }
    renderedCallback() {
        this.emailClient = getFieldValue(this.contact.data, Email_FIELD);
        this.numMobileClient = getFieldValue(this.contact.data, MOBILE_FIELD);
        this.clientXdataId = getFieldValue(this.contact.data, ID_CLIENT_XDATA);
        
        this.value = 'option2';

        if ((getFieldValue(this.record.data, FIXE_FIELD) !== null || getFieldValue(this.record.data, FIXE_FIELD) !== '') && (getFieldValue(this.record.data, MOBILE_FIELD) === null || getFieldValue(this.record.data, MOBILE_FIELD) === '')) {
            this.template.querySelector('.num1').required = false;
            this.template.querySelector('.num2').required = true;
        }
    }


    modifyConsent(index, newConsent) {
        this.consentementList[index].consent = newConsent;
        if (newConsent === 'checkYes') {
            this.consentementList[index].application = 'HAPPE'
            this.consentementList[index].consent = true
            this.consentementList[index].checkYes = true;
            this.consentementList[index].checkNo = false;
        } else {
            this.consentementList[index].application = 'HAPPE'
            this.consentementList[index].consent = false;
            this.consentementList[index].checkYes = false;
            this.consentementList[index].checkNo = true;
        }
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
    }

    getmodifiedConsent(event) {
        this.infosEmailToSend.consentements = true;
        let newConsent = event.target.value;
        console.log('newConsent', newConsent);
        let consentName = event.target.name;
        for (let index = 0; index < this.consentementList.length; index++) {
            if (this.consentementList[index].name === consentName) {
                this.modifyConsent(index, newConsent);
            }
        }
    }

    handleChangeEmail(event){
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
        this.emailClient = event.target.value; 
        this.infosEmailToSend.email = event.target.value;
        this.emailChanged = true;
        this.emailValidation(event);

    }
    handleChangeNumStreet(event){
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
        this.infosEmailToSend.adresse = true;
        this.numVoie = event.currentTarget.value;
        this.infosEmailToSend.numVoie = event.currentTarget.value;
    }
    handleChangeStreet(event){
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
        this.infosEmailToSend.adresse = true;
        this.voie = event.currentTarget.value
        this.infosEmailToSend.voie =  event.currentTarget.value ;
    }
    handleChangePC(event){
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
        this.infosEmailToSend.adresse = true;
        this.codePostale = event.currentTarget.value;
        this.infosEmailToSend.codePostale =  event.currentTarget.value ;
    }
    handleChangeCompAddr(event){
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
        this.infosEmailToSend.adresse = true;
        this.complementAdresse =  event.currentTarget.value ;
        
    }
    handleChangeCity(event){
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
        this.infosEmailToSend.adresse = true;
        this.ville = event.currentTarget.value;
        this.infosEmailToSend.ville =  event.currentTarget.value;

    }

    handleSubmit() {
        let num1valid = this.handleNumeroPortableMessage(this.template.querySelector('.num1').value);
        let num2valid =  this.handleNumeroFixeMessage(this.template.querySelector('.num2').value);   
        console.log('***num1valid***',num1valid);
        console.log('***num2valid***',num2valid);
        let contact = {
                fields: {
                    Id: this.recordId,
                    HP_IsHappe__c: true
                },
        };
        updateRecord(contact).then(() => {
                console.log('update HP_IsHappe__c field ');
        }).catch(error => {
                console.log('Error: ---> updating HP_IsHappe__c ' , JSON.stringify(error));
        });
        console.log( 'SAVE',this.errorData);
        if (this.errorData || num1valid ||num2valid ) {
            this.displayToast('Erreur', "Merci de remplir tout les champs obligatoires", 'error', []);
            this.loading = false;
        } else {
            let infoPersonne = {
                "civilite": "",
                "nom": "",
                "prenom": "",
                "numeroFixe": "",
                "numeroMobile": "",
                "email": "",
                "numVoie": "",
                "voie": "",
                "complementAdresse": " ",
                "codePostal": "",
                "ville": "",
                "pays": "FR"
            };
            // console.log('@@@@@@@@', JSON.stringify(this.template.querySelector('.cmpAdress').value));
            infoPersonne.civilite = this.contact.data.fields.Salutation.value;
            infoPersonne.prenom = this.contact.data.fields.FirstName.value;
            infoPersonne.nom = this.contact.data.fields.LastName.value;
            infoPersonne.numeroFixe =  this.template.querySelector('.num2').value === null?'' :this.template.querySelector('.num2').value;
            infoPersonne.numeroMobile = this.template.querySelector('.num1').value === null?'' :this.template.querySelector('.num1').value;
            infoPersonne.email =this.template.querySelector('.email').value === null?'' :this.template.querySelector('.email').value;
            infoPersonne.numVoie = this.template.querySelector('.noVoie').value;
            infoPersonne.voie = this.template.querySelector('.noStreet').value;
            infoPersonne.complementAdresse = this.template.querySelector('.cmpAdress').value === null?'' :this.template.querySelector('.cmpAdress').value;
            infoPersonne.codePostal = this.template.querySelector('.noPostal').value;
            infoPersonne.ville = this.template.querySelector('.noCity').value;

            console.log('=>', JSON.stringify(infoPersonne));
            console.log('=> ',String(this.contact.data.fields.ID_Tiers__c.value));


            putPersonne({ idXdata: String(this.contact.data.fields.ID_Tiers__c.value), infoPersonne: JSON.stringify(infoPersonne) }).then(res => {
                console.log('Res putPersonne', JSON.stringify(res));
                    console.log('PUT');
                    if(this.infosEmailToSend.adresse){
                        this.infosEmailToSend.adresse = infoPersonne.numVoie +' '+ infoPersonne.voie+' '+ infoPersonne.codePostal +' '+infoPersonne.complementAdresse + ' ' +infoPersonne.ville;

                    }
                    sendConsentResponses({
                        consentToSend: JSON.stringify(this.consentementList)
                    }).then(result => {
                        console.log('Consentement', JSON.stringify(this.consentementList));
                    
                        this.handleSendMode();
                    }).catch(error => {
                        this.loading = false;
                        this.displayToast('Erreur', "Une erreur est survenue lors de la sauvegarde !", 'error', []);
                    });
                
            }).catch(errorupdate => {
                console.log('putPersonneERROR',JSON.stringify(errorupdate))
            })
        }
    }

    handleSendMode() {
        this.sendEmail();
        this.sendSMS();
        this.loading = true;
        let close = true;
        const closeclickedevt = new CustomEvent('closeclicked', {detail: {close},});
        this.dispatchEvent(closeclickedevt);
        this.displayToast('Succès', "Modifications enregistrées avec succès", 'success', []);
    }

    sendEmail() {
        if (this.confirmationEmail) {
            console.log('sendEmail');
            if (this.emailChanged) {
                this.infosEmailToSend.email = this.emailClient;
            }
           /* if(this.infosEmailToSend.adresse && ( this.infosEmailToSend.numVoie || this.infosEmailToSend.voie || this.infosEmailToSend.codePostale || this.infosEmailToSend.ville)){
                this.infosEmailToSend.adresse = this.infosEmailToSend.numVoie +' '+ this.infosEmailToSend.voie+' '+ this.infosEmailToSend.codePostale +' '+ this.infosEmailToSend.ville;
            }*/
            console.log('*****infosEmailToSend******'+JSON.stringify(this.infosEmailToSend));
            sendEmail({
                prenom: this.contact.data.fields.FirstName.value,
                infosEmailToSend: this.infosEmailToSend,
                email: this.emailClient,
                idClient: this.contact.data.fields.ID_Tiers__c.value
            }).then(resultEmail => {
                console.log('result Email: ',resultEmail);
            }).catch(error => {
                console.log('error EMail: ',error);
                this.loading = false;
                this.displayToast('Erreur', "Une erreur est survenue lors de la sauvegarde !", 'error', []);
            });
        }
    }
    sendSMS() {
        if (this.confirmationSMS) {
            console.log('sendSMS');
            let startWithPlus =  this.numMobileClient != null &&  this.numMobileClient.startsWith('+');
            console.log('startWithPlus0',startWithPlus);
            sendSMS({
                prenom: this.contact.data.fields.FirstName.value,
                numMobile: startWithPlus ? (0+this.numMobileClient.substring(3) ) : this.numMobileClient ,
                idClient: this.contact.data.fields.ID_Tiers__c.value
            }).then(resultSMS => {
                console.log('result SMS: ',resultSMS);
            }).catch(error => {
                console.log('error SMS: ',error);
                this.loading = false;
                this.displayToast('Erreur', "Une erreur est survenue lors de la sauvegarde !", 'error', []);
            });
        }
    }

    get consentReady() {
        return true;
    }
    get options() {
        return [{
                label: 'Automatique',
                value: 'option1'
            },
            {
                label: 'Manuelle',
                value: 'option2'
            },
        ];
    }
    handleOnChange(event) {
        if (event.target.value === 'option1') {
            this.template.querySelector('.auto').classList.remove('display-none');
            this.template.querySelector('.manu').classList.add('display-none');

        } else if (event.target.value === 'option2') {
            this.template.querySelector('.auto').classList.add('display-none');
            this.template.querySelector('.manu').classList.remove('display-none');

        }
        this.resetELD(); 
    }

    resetELD() {
        this.isGazELD = false;
        this.isElecELD = false;
        this.isElecGazELD = false
        ;
    }
   

   

    //verification du numero de telephone à partir de l'indicatif et le format 00 00 00 00 00 respecté
    telephoneValidation(event) {
    
        this.indicatif = getFieldValue(this.contact.data, '');
        console.log('indicatif ', this.indicatif);
        getContryCode({ indicatif: this.indicatif }).then(result => {
            this.codeIso = result;

        }).catch(error => {
            console.log('error',JSON.stringify(error))
        })
        if (event.target.value.length >= 10) {
            getTelephoneValidation({ telephone: String(event.target.value),pays:this.codeIso }).then(result => {
                console.log('getTelephoneValidation ', JSON.stringify(result));
                if (result.IdError === 0) {
                    
                    this.displayToast('Info', "Le numero renseigné n'est pas attribué", 'info', []);
                }
               
            }).catch(error => {
                console.log('error',JSON.stringify(error))
            })
        }
     
    }
    //Validation de l'email, se declanche losque .com/.fr ect a voir avce Carl(ajout boutton ou pas)
    emailValidation(event) {
        if (String(event.target.value).includes('.com') || String(event.target.value).includes('.fr')) {
            getEmailValidation({ email: String(event.target.value) }).then(result => {

                console.log('getEmailValidation ', JSON.stringify(result));
                if (result.IdError !== "00") {
                    
                    this.displayToast('Info', "L'email renseigné n'est pas attribué",result.eMail,  'info', []);//result.eMail,
                } else {
                    this.email = event.currentTarget.value;
                }                
            }).catch(error => {
                console.log('error',JSON.stringify(error))
            })
        }
   
    }

    isRequired() {
        if ((this.template.querySelector('.num1').value === null || this.template.querySelector('.num1').value === '') && this.template.querySelector('.num2').value !== null && this.template.querySelector('.num2').value !== '') {
            this.template.querySelector('.num1').required = false;
            this.template.querySelector('.num2').required = true;
        } else if ((this.template.querySelector('.num2').value === null || this.template.querySelector('.num2').value === '') && this.template.querySelector('.num1').value !== null && this.template.querySelector('.num1').value !== '') {
            this.template.querySelector('.num1').required = true;
            this.template.querySelector('.num2').required = false;
        } else if ((this.template.querySelector('.num2').value === null || this.template.querySelector('.num2').value === '') && (this.template.querySelector('.num1').value === null || this.template.querySelector('.num1').value === '')) {
            this.template.querySelector('.num1').required = true;
            this.template.querySelector('.num2').required = false;
        }
    }


    checkMobile(event) {
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
        this.infosEmailToSend.numMobile = event.target.value;
        this.numMobileClient = event.target.value; 
        console.log('numMobileClient: ',this.numMobileClient);
        
        this.numMobileChanged = true;
        this.isRequired();
        this.checkPatternMobile(event);
        this.telephoneValidation(event);
        this.handleNumeroPortableMessage(this.numMobileClient);
    }

    checkFixe(event) {
        this.template.querySelector('.confirmation-email').disabled = false;
        this.template.querySelector('.confirmation-sms').disabled = false;
        this.infosEmailToSend.numFixe = event.target.value;
        this.isRequired();
        this.checkPatternFixe(event);
        this.telephoneValidation(event);
        this.handleNumeroFixeMessage(this.infosEmailToSend.numFixe);
    }

    checkPatternMobile(event) {
        let mobileValue = event.target.value;
        if (mobileValue.length >= 10) {
            let matchMobile = mobileValue.match(this.patternMobile);
            if (matchMobile === null) {
                this.template.querySelector('.mobileError').classList.remove('display-none');
                this.errorData = true;
                console.log('checkPatternMobile true',this.errorData)
            } else {
                this.template.querySelector('.mobileError').classList.add('display-none');
                this.errorData = false;
                this.numeroPortable = event.currentTarget.value;
                console.log('checkPatternMobile false',this.errorData)
            }
        }/* else {
            this.template.querySelector('.mobileError').classList.add('display-none');
            this.errorData = false;
        } */
    }

    checkPatternFixe(event) {
        let fixeValue = event.target.value;
        if (fixeValue.length >= 10) {
            let matchFixe = fixeValue.match(this.patternfixe);
            if (matchFixe === null) {
                this.template.querySelector('.fixeError').classList.remove('display-none');
                this.errorData = true;
                
            } else {
                this.template.querySelector('.fixeError').classList.add('display-none');
                this.errorData = false;
                this.numeroFixe = event.currentTarget.value;
            }
        }/* else {
            this.template.querySelector('.fixeError').classList.add('display-none');
            this.errorData = false;
        } */
    }
    handleNumeroPortableMessage(value) {
        console.log('handleNumeroPortableMessage',(value && (value.length < 10||value.length > 10)) ||  !String(value).trim())
        if ( value === null) return;
        if ( value.length > 0 && value.length !=10 ) {//(value && (value.length < 10||value.length > 10)) ||  !String(value).trim()
            this.template.querySelector('.notvalid1').classList.remove('display-none');
            return this.errorData = true;
        } else if ( value.length == 0 ||  String(value).trim() || value.length == 10) {
            this.template.querySelector('.notvalid1').classList.add('display-none');
            return this.errorData = false;
        }
    }
    handleNumeroFixeMessage(value) {
        if ( value === null) return;
        if ( value.length > 0 && value.length !=10) {// (value && (value.length < 10||value.length > 10)) ||  !String(value).trim() 
            this.template.querySelector('.notvalid2').classList.remove('display-none');
            return this.errorData = true;    
        } else if (value.length == 0 ||  String(value).trim() || value.length == 10) {//(value && (value.length < 10||value.length > 10)) ||  !String(value).trim()
            this.template.querySelector('.notvalid2').classList.add('display-none');
            return this.errorData = false; 
        }
    }

    // display toast message using some parameters
    displayToast(title, message, variant, data) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            messageData: data,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    getSearchResult(event) {
        if (event.target.label === 'Adresse de contact') {
            window.clearTimeout(this.delayTimeout);
            let input = event.target.value;
            let splitSpaceStr = input.split(' ');
            input = input.split(' ').join('+');
            if (input.length > 7 || (splitSpaceStr && splitSpaceStr[1] && splitSpaceStr[1].length > 1)) {
                getSuggestions({
                    input
                }).then(result => {
                    console.log('result GOUV : ', JSON.stringify(result.features[0].properties));
                    this.tempResult = JSON.stringify(result.features);
                    this.searchResult = result.features;
                    this.properties = JSON.stringify(result.features[0].properties);
                    this.isError = false;
                }).catch(error => {
                    console.log('errorSearch', error);
                    this.searchResult = undefined;
                    this.properties = undefined;
                    this.isError = true;
                });
            } else {
                this.searchResult = undefined;
                this.isError = false;
            }
        }
        this.template.querySelector('[data-id="listbox"]').classList.remove('display-none');
    }

    selectedValue(event) {
        this.resetELD();
        this.house = {
            housenumber: event.currentTarget.dataset.housenumber,
            street: event.currentTarget.dataset.street,
            postcode: event.currentTarget.dataset.postcode,
            city: event.currentTarget.dataset.city,
            cmpAdress: '',
            citycode: event.currentTarget.dataset.citycode
        }
        this.displayCityELD(this.house);
        this.template.querySelector('.noVoie').value = this.house.housenumber;
        this.template.querySelector('.noStreet').value = this.house.street;
        this.template.querySelector('.noPostal').value = this.house.postcode;
        this.template.querySelector('.noCity').value = this.house.city;
        this.template.querySelector('.cmpAdress').value = this.house.cmpAdress;

        this.curentSearchResult = event.currentTarget.dataset.name;
        this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
    }

     callAPIGouv(inputdata) {
        let input = 'city=' + inputdata.cityValue + '&postcode=' + inputdata.postcodeValue;
        getSuggestions({
            input
        }).then(result => {
            if (result !== undefined) {
                let citycodeValue = result[0].properties.citycode;
                if (citycodeValue !== undefined) {
                    let data = {
                        postcode: inputdata.postcodeValue,
                        citycode: citycodeValue
                    };
                    // call API Zone distrivbution to diplay ELD city
                    this.displayCityELD(data);
                }
                this.isError = false;
            }
        }).catch(error => {
            console.log('errorSearch function callAPIGouv', error);
            this.isError = true;
        });
    } 

    handleClickELD(){
            this.resetELD();
            let data = {
                postcodeValue : this.template.querySelector('.noPostal').value,
                cityValue : this.template.querySelector('.noCity').value
            };
            this.callAPIGouv(data);
    }

    displayCityELD(data) {
        verifyELD({
            postalCode: data.postcode,
            cityCode: data.citycode
        }).then(resultELD => {
            console.log('testttttttttttt', JSON.stringify(resultELD))
            if (resultELD !== undefined) {
                this.isCityElecELD(resultELD);
                this.isCityGazELD(resultELD);
                if (this.isGazELD === true && this.isElecELD === true) {
                    this.isElecGazELD = true;
                }
            }
        }).catch(error => {
            console.log('error function displayCityELD', error);
        });
    }



    isCityElecELD(data) {
        for (const record of data) {
            if (record.codeDistributeur === 'ENED') {
                this.isElecELD = false;
                break;
            }
            this.isElecELD = true;
        }
    }

    isCityGazELD(data) {
        for (const record of data) {
            if (record.codeDistributeur === 'GRDF') {
                this.isGazELD = false;
                break;
            }
            this.isGazELD = true;
        }
    }

}