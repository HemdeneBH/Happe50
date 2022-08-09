/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 11-04-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
import { LightningElement, track,wire, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import loadContact from "@salesforce/apex/HP_EM020_Contact.loadContact";
import getConsentResponses from '@salesforce/apex/HP_SM008_APIHour.getReponsesConsentement';

import getAdresses from '@salesforce/apex/HP_CALL007_DQE.getSuggestions';
import getAdressesDQE from '@salesforce/apex/HP_CALL007_DQE.getSuggestionsDQE';
import getComplementsDQE from '@salesforce/apex/HP_CALL007_DQE.getComplementsDQE';

import getQuestionsConsent from '@salesforce/apex/HP_SM008_APIHour.getQuestionsConsentement';
import getEmailValidation from '@salesforce/apex/HP_SM0017_DQE.getEmailValidation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTelephoneValidation from '@salesforce/apex/HP_SM0017_DQE.getTelephoneValidation';
import getContryCode from '@salesforce/apex/HP_SM003_MetadataManager.getContryCode';

import verifyELD from '@salesforce/apex/HP_SM008_APIHour.getZonesDistributions';
import getCommunes from '@salesforce/apex/HP_SM008_APIHour.getCommunes'; //HAPP-189
import loadContactDoublonsList from '@salesforce/apex/HP_PersonneController.loadContactDoublonsList';
import saveClient from '@salesforce/apex/HP_PersonneController.mergeClientWithConsentement';
import sendSMS from '@salesforce/apex/HP_SM015_ContactModifNotification.sendSMS';
import sendEmail from '@salesforce/apex/HP_SM015_ContactModifNotification.sendEmail'; 
import getPersonneXdataId from '@salesforce/apex/HP_PersonneController.getPersonneXdataId';

import stopEmailPhrase from '@salesforce/label/c.HP_stopEmailPhrase';
import stopSmsPhrase from '@salesforce/label/c.HP_stopSmsPhrase';
import optinMarketingPhrase from '@salesforce/label/c.HP_optinMarketingPhrase';

export default class Hp_createModifyContact extends NavigationMixin(LightningElement) {
    @track salutations =[{label:'MR',value:'MR'},{label:'MME',value:'MME'}];
    @track modeAdresse =[{ label: 'Automatique', value: 'automatique' },{ label: 'Manuelle', value: 'manuelle' }];
    @track consentementList = [];
    @track yesNo = [
        { label: 'Oui', value: 'oui' },
        { label: 'Non', value: 'non' }
    ];
    @track modeSaisie = 'manuelle';
    @track email;
    @track numeroPortable;
    @track numeroFixe;
    @track numeroEtranger;
    @track indicatifValues;
    @track codeIso = 'FRA';
    @track indicatif = '+33';
    @track adresses;
    @track adressesDQE;
    @track adressesDQEList;
    @track adresseActuelle;
    @track isGazELD = false;
    @track isElecELD = false;
    @track isElecGazELD = false;
    @track communes;
    @track adresseChoisie = {};
    @track loading = true;
    @track doublonsPopupModal = false;
    @track doublonsContactList =[];
    @api recordid;
    @track titlePage = 'Création de la fiche client';
    @track isCreation = true;
    @track isModification = false;
    @track hasListeNumero = false;
    @track hasComplement = false;
    @track adressesDQEComplemet;

    @track astrxShow=true;

    
    idClient;
    idClientFromAgilab;
    confirmationEmail;
    confirmationSMS;
    isSelected = false;
    infosEmailToSend = {};

    @track stopEmail=false;
    @track stopSms=false;
    @track optinMarketing=false;

    isXdataIdOk = true;


    emailChanged = false;
    emailErrorMessage = '"Merci de vérifier l\'email';
    get addressAuto() {
        return this.modeSaisie == 'automatique';
    }
    handleOnChange(event){
        this.modeSaisie = event.target.value;
    }
    loadClientAndResponse() {
        loadContact({ contactId: this.recordid }).then( resultContact => { 

            this.idClient = resultContact.ID_Tiers__c;

            this.salutation = resultContact.Salutation;
            this.prenom = resultContact.FirstName;
            this.nom = resultContact.LastName;
            this.numeroFixe = resultContact.Phone != null? resultContact.Phone.replace('+33', '0') : null;
            this.numeroPortable = resultContact.MobilePhone != null ? resultContact.MobilePhone.replace('+33', '0'): null;
            this.email = resultContact.Email;
            this.adresseChoisie.housenumber = resultContact.No_Voie__c;
            this.adresseChoisie.street = resultContact.MailingStreet;
            this.adresseChoisie.postcode = resultContact.MailingPostalCode;
            this.adresseChoisie.city = resultContact.MailingCity;
            this.adresseChoisie.cmpAdress = resultContact.Complement_adresse__c;
            this.numeroEtranger = resultContact.HP_Numero_etranger__c;
            this.stopEmail = resultContact.HP_StopEmail__c ;
            this.stopSms = resultContact.HP_StopSMS__c ;
            this.optinMarketing = resultContact.HP_OptinMarketing__c;
            getConsentResponses({ 
                idPersonne:this.idClient
            }).then(resultResponses => {
                this.responses = resultResponses;
                console.log('this.responses: ', JSON.stringify(this.responses));
                let responseMap = {};
                for (let i = 0; i < this.responses.length ; i++) {
                    responseMap[this.responses[i].idQuestionnaire + '-' + this.responses[i].idQuestion] = {};
                    responseMap[this.responses[i].idQuestionnaire + '-' + this.responses[i].idQuestion].consent = this.responses[i].consent; 
                    responseMap[this.responses[i].idQuestionnaire + '-' + this.responses[i].idQuestion].id = this.responses[i].id; 
                }
                for(let i = 0; i < this.consentementList.length; i ++) {
                    let resp = responseMap[this.consentementList[i].idQuestionnaire + '-' + this.consentementList[i].idQuestion];
                    if(resp == null) {
                        continue;
                    }
                    this.consentementList[i].id = resp.id;
                    this.consentementList[i].response = (resp.consent ? 'oui' : 'non');
                }
            }).catch(errorResponses => {
                console.log('errorResponses: ',errorResponses);
                this.loading = false;
                this.displayToast('Information', "Aucun consentement enregistré pour ce client, veuillez les saisir.", 'info', []);
                this.consentMethod = 'POST';
            });
        })
        .catch(error => {
            this.loading = false;
            console.log("got error loadContact", error);
        });
    }
    connectedCallback() {
    if(this.recordid != null) {
        this.titlePage = 'Modification de la fiche client'; 
        this.isCreation = false;
        this.isModification = true;
    }
        getQuestionsConsent().then(resultat => {
            console.log('getQuestionsConsent',JSON.stringify(resultat))
            this.questions = resultat;
            this.loading = false;
            for (let index = 0; index < this.questions.length; index++) {
                this.consentementList.push({
                    idPersonne: 0,
                    libelleQuestion: this.questions[index].libelleQuestion,
                    idQuestion: parseInt(this.questions[index].idQuestion),
                    idQuestionnaire: parseInt(this.questions[index].idQuestionnaire),
                    consent: false,
                    canal: 'Telephone',
                    application: 'HAPPE',
                    name: 'consent'+index ,
                    response : 'non'
                });
            }
            this.loading = false;
            if(this.isModification) {
                this.loadClientAndResponse();
            }
        }).catch(erreur => {
            this.loading = false;
            this.displayToast('Erreur', "Une erreur est servenue lors de récupération des questions du consentement", 'error');
        });
    }
    handleEmail(event) {
        this.emailChanged = false;
        if(this.email !==  event.target.value ) {
            this.emailChanged = true;
        } else {
            this.emailChanged  = false;
        }
        this.email = event.target.value;
        this.infosEmailToSend.email = true;
        this.infosEmailToSend.email = this.email;



       
        console.log('***********emailChanged ',this.emailChanged);


        //this.emailValidation(event);
        this.activateEmailSMSCheckbox();
        
    }
    handleBlurEmail(event){
        console.log('***********bluuuuuuuuuuuuur ',event.target.value);
        console.log('***********email ',this.email);



        if( this.emailChanged ) this.emailValidation(event);


    }
    emailValidation(event) {
        //String(event.target.value).includes('.com') || String(event.target.value).includes('.fr') : no one really knows why we verify just .fr and .com
        let isEmailValid = ( String(event.target.value).endsWith('.fr') || String(event.target.value).endsWith('.com')) && String(event.target.value).includes('@') ;
        console.log('***********isEmailValid ',isEmailValid);
        if (isEmailValid) {
            getEmailValidation({ email: String(event.target.value) }).then(result => {
                console.log('getTelephoneValidation ', JSON.stringify(result));
                if (result.IdError !== "00") {
                    this.displayToast('Info', "L'email presente des erreurs " + this.email, 'info');
                }
                
                console.log('this.idClient ', JSON.stringify(this.idClient));
            }).catch(error => {
                console.log('error',JSON.stringify(error));
           




            })

        this.loading = true;
        getPersonneXdataId({email: String(this.email) }).then(result =>{
            console.log('resultat ', JSON.stringify(result));
            this.loading = false;                 



            if(this.isCreation){
                if (result && result[0] &&  result[0].error === "Cet email n'est pas associé à un id xdata dans la base agilab.") {
                    this.isXdataIdOk = true;
                }else{
                    this.displayToast('Erreur', "Le mail est déjà utilisé pour un autre compte client. Veuillez en saisir un autre.", 'error');
                    this.emailErrorMessage ='Le mail est déjà utilisé pour un autre compte client. Veuillez en saisir un autre.';
                    this.isXdataIdOk = false;
                } 
            }else{

                if (result && result[0] &&  result[0].error === "Cet email n'est pas associé à un id xdata dans la base agilab.") {
                    this.isXdataIdOk = true;
                } else {
                    console.log('this.idClient***',this.idClient);
                    let item = result && result[0];
                    this.idClientFromAgilab = result && result[0] && result[0].id_client_xdata
                    console.log('idClientFromAgilab*******',this.idClientFromAgilab);
                        
                        if (result.length > 1) {
                            this.isXdataIdOk = false;
                            this.displayToast('Erreur', "Plusieurs résultat !", 'error');
                            this.emailErrorMessage = 'Plusieurs résultat !'
                        }
                        else if (this.idClientFromAgilab !== undefined && this.idClientFromAgilab !== null && this.idClient && (this.idClientFromAgilab.toString() !== this.idClient.toString())) 
                        { this.displayToast('Erreur', "Le mail est déjà utilisé pour un autre compte client. Veuillez en saisir un autre.", 'error');
                        this.emailErrorMessage ='Le mail est déjà utilisé pour un autre compte client. Veuillez en saisir un autre.';
                        this.isXdataIdOk = false;
                    }
                    else if ((this.idClientFromAgilab === undefined || this.idClientFromAgilab === null) && item.email ) {
                        this.displayToast('Erreur', "Client non initialisé, modifier l’email dans AGILAB", 'error');
                        this.emailErrorMessage ='Client non initialisé, modifier l’email dans AGILAB';
                        this.isXdataIdOk = false;
                    }
                    else if (this.idClientFromAgilab !== undefined && this.idClientFromAgilab !== null && this.idClient && (this.idClientFromAgilab.toString() === this.idClient.toString())){
                        this.isXdataIdOk = true;
                    }
               
            }
            }
           
        }
            ).catch(error => {
                this.loading = false
            })





        }
    }
    displayToast(title, message, variant) {
		const evt = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant
		});
		this.dispatchEvent(evt);
    }
    isRequired() {
        if( (this.template.querySelector('.num1').value === null || this.template.querySelector('.num1').value === '') && this.template.querySelector('.num2').value !==null && this.template.querySelector('.num2').value !==''){
            this.template.querySelector('.num1').required =false;
            this.template.querySelector('.num2').required =true;
            this.astrxShow = false;
        }
        else if( (this.template.querySelector('.num2').value === null || this.template.querySelector('.num2').value === '') && this.template.querySelector('.num1').value!==null && this.template.querySelector('.num1').value !==''){
            this.template.querySelector('.num1').required =true;
            this.template.querySelector('.num2').required =false;
            this.astrxShow = true;

        }
        else if((this.template.querySelector('.num2').value === null || this.template.querySelector('.num2').value === '')&&(this.template.querySelector('.num1').value === null || this.template.querySelector('.num1').value === '')){
            this.template.querySelector('.num1').required =true;
            this.template.querySelector('.num2').required =false;
            this.astrxShow = true;

        }
    }
    handleNumeroPortable(event) {
        this.activateEmailSMSCheckbox();
        this.numeroPortable = event.target.value;
        
        this.infosEmailToSend.numMobile = true;
        this.infosEmailToSend.numMobile = this.numeroPortable;
        this.isRequired();
        this.telephoneValidation(event);
        // if(this.numeroPortable!="" && this.numeroPortable!=null){
        //     this.astrxShow = true; 
        // }else{
        //     this.astrxShow = false;
        // }
    }
    handleNumeroFixe(event) {
        this.activateEmailSMSCheckbox();
        this.numeroFixe = event.target.value;
        
        this.infosEmailToSend.numFixe = true;
        this.infosEmailToSend.numFixe = this.numeroFixe;
        this.isRequired();
        this.telephoneValidation(event);
        // if(this.numeroPortable!="" && this.numeroPortable!=null){
        //     this.astrxShow = true; 
        // }else{
        //     this.astrxShow = false;
        // }
    }
    handleNumeroEtranger(event) {
        this.numeroEtranger = event.target.value;





        this.infosEmailToSend.numeroEtranger = this.numeroEtranger;
        this.activateEmailSMSCheckbox();





    }
    telephoneValidation(event) {
       /* getContryCode({ indicatif:this.indicatif }).then(result => {
            this.codeIso = result;
        }).catch(error => {
            console.log('error',JSON.stringify(error))
        })*/
        let tel = event.target.value;
        if(tel.length == 9 && tel[0] != '0') {
            tel = '0' + tel; 
        }
        if (tel.length == 10) {
            getTelephoneValidation({ telephone: String(tel),pays:this.codeIso }).then(result => {
                if (result.IdError === 0) {
                    ;
                    this.displayToast('Info', "Le numero renseigné n'est pas atribué", 'info');
                }
            }).catch(error => {
                console.log('error',JSON.stringify(error));
            });
        }
    }
    handleIndicatif(event) {
        this.indicatif = event.target.value;
    }
    getSearchResult(event) {
        if (event.target.label === 'Adresse de contact') {
            if(this.isSelected) {
                this.isSelected = false;
                return;
            }
            this.hasComplement = false;
            this.hasListeNumero = false;
            this.activateEmailSMSCheckbox();
            let input = event.target.value;
            let splitSpaceStr = input.split(' ');
            let inputSplit = input.split('|');
            let arrayLength = inputSplit && inputSplit.length;
            input = inputSplit[0];
            if(arrayLength >= 2) input = input + ' '+inputSplit[1];
            console.log('@@  input ' + JSON.stringify(input));
            input = input.replaceAll('|', ' ');
            console.log('@@  call dqe ' + JSON.stringify(input));
            console.log('@@  this.adresseActuelle  dqe ' + JSON.stringify( this.adresseActuelle ));
			//input = input.split(' ').join('+');
				if(input.length>7 || (splitSpaceStr && splitSpaceStr[1] && splitSpaceStr[1].length>1)){
					/*getAdresses({input}).then(resultat => {
                        this.adresses = resultat.features;
                        this.template.querySelector('[data-id="listbox"]').classList.remove('display-none');
                    }).catch(error => {
                        this.searchResult = undefined;
                        this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
                    });*/
                    getAdressesDQE({input}).then(resultat => {
                        console.log('@@ resultat ' + JSON.stringify(resultat));
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
        this.isSelected = true;
        this.resetELD();
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
        this.displayCityELD(this.adresseChoisie);
        this.adresseActuelle= event.currentTarget.dataset.name;
        if(listnum!=="" && !event.currentTarget.dataset.housenumber){
            listnum = listnum && listnum.toString().split(';');
            console.log('listnum;',listnum);
            this.adressesDQEList =   listnum.map((item)=>({...selectedadresseChoisie,numero:item}));
            console.log('this.adressesDQEList :;',JSON.stringify(this.adressesDQEList) );
            this.hasListeNumero = true;
        } 
        if(event.currentTarget.dataset.housenumber){
             // call dqe complement adresse
             let input = 'IDVoie='+event.currentTarget.dataset.idvoie+'&IDNum='+event.currentTarget.dataset.housenumber;
             console.log('url complement dqe ********** :;',JSON.stringify(input) );
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
            console.log('@@ resultat complement dqe secondSecelction***** ' + JSON.stringify(resultat));
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
        console.log('@@@@@@@@@@@@@@@@adresseChoisie thirdSelection ******:',JSON.stringify(this.adresseChoisie));
        this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
        this.template.querySelector('[data-id="listboxIn"]').classList.add('display-none');
        this.template.querySelector('[data-id="listbox"]').classList.remove('display-table');
    }
    resetELD() {
        this.isGazELD = false;
        this.isElecELD = false;
        this.isElecGazELD = false;
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
    displayCityELD(data) {
        verifyELD({
            postalCode: data.postcode,
            cityCode: data.citycode
        }).then(resultELD => {
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
    handleBlur(event) {
        this.codePostale = event.target.value;
        if (this.codePostale.length == 5) {
            this.loading = true;
            //this.template.querySelector('.noCity').disabled = false;
            getCommunes({
                postalCode: String(this.codePostale)
            }).then(
                result => {
                    this.loading = false;
                    this.communes = result;
                    if( this.communes.length === 1){
                        this.adresseChoisie.city = this.communes[0].ville.trimEnd();
                        this.template.querySelector('.noCity').value = this.adresseChoisie.city;
                        this.template.querySelector('[data-id="listboxx"]').classList.add('display-none');
                        //this.template.querySelector('.noCity').disabled = true;
                        this.handleClickELD();
                    }else{
                        this.template.querySelector('.noCity').value = '';
                        this.template.querySelector('[data-id="listboxx"]').classList.remove('display-none');
                    }
                }
            );
        }else {
            //this.template.querySelector('.noCity').disabled = true;
            this.template.querySelector('.noCity').value = '';
            this.template.querySelector('[data-id="listboxx"]').classList.add('display-none');
        }
    }
    handleClickELD(){
        this.resetELD();
        console.log('@@this.adresseChoisie.postcode ' + this.adresseChoisie.postcode);
        console.log('@@this.adresseChoisie.city ' + this.adresseChoisie.city);
        let data = {
            postcodeValue : this.adresseChoisie.postcode,
            cityValue : this.adresseChoisie.city
        };
        this.callAPIGouv(data);
    }
    callAPIGouv(inputdata) {
        this.loading = true;
        let input = 'city=' + inputdata.cityValue + '&postcode=' + inputdata.postcodeValue;
        getAdresses({
            input
        }).then(result => {
            this.loading = false;
            if (result !== undefined) {
                let citycodeValue =result.features[0].properties.citycode;
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
        });
    }
    handleNoVoie(event) {
        this.adresseChoisie.housenumber = event.target.value;
        this.infosEmailToSend.adresse = true;
        this.activateEmailSMSCheckbox();
    }
    handleVoie(event) {
        this.adresseChoisie.street = event.target.value;
        this.infosEmailToSend.adresse = true;
        this.activateEmailSMSCheckbox();
    }
    handleCodePostale(event) {
        this.adresseChoisie.postcode = event.target.value;
        this.infosEmailToSend.adresse = true;
        this.activateEmailSMSCheckbox();
        this.handleBlur(event);
    }
    handleVille(event) {
        this.adresseChoisie.city = event.target.value;
        this.infosEmailToSend.adresse = true;
        this.activateEmailSMSCheckbox();
    }
    handleComplementAdresse(event) {
        this.adresseChoisie.cmpAdress = event.target.value;
        this.infosEmailToSend.adresse = true;
        this.activateEmailSMSCheckbox();
    }
    selectedManuValue(event) {
        this.adresseChoisie.city = event.currentTarget.dataset.city.trimEnd();
        this.template.querySelector('.noCity').value = this.adresseChoisie.city;
        this.template.querySelector('[data-id="listboxx"]').classList.add('display-none');
        //this.template.querySelector('.noCity').disabled = true;
        this.handleClickELD();
    }
    loadDoublonsContact() {
        if(!this.validateData()) {
            return;
        }
        console.log('record Id : '+this.recordid);
        this.loading = true;
        let infosPersonne = {};
            infosPersonne.prenom = this.prenom;
            infosPersonne.nom = this.nom;
            infosPersonne.numeroFixe =  ((this.numeroFixe != null && this.numeroFixe !== '')? (this.numeroFixe.length == 9 ?  '+33' +this.numeroFixe : '+33' +this.numeroFixe.substring(1)):'');
            infosPersonne.numeroMobile =((this.numeroPortable != null && this.numeroPortable !== '')? (this.numeroPortable.length == 9 ?  '+33' +this.numeroPortable : '+33' +this.numeroPortable.substring(1)):'');
            infosPersonne.email = this.email;
            infosPersonne.numVoie = this.noVoie;
            infosPersonne.voie = this.voie;
            infosPersonne.codePostal = this.codePostale;
            infosPersonne.ville = this.ville;
            infosPersonne.stopEmail = this.stopEmail;
            infosPersonne.stopSms = this.stopSms;
            infosPersonne.optinMarketing = this.optinMarketing,
            console.log('@@@  infosPersonne ' +  JSON.stringify(infosPersonne));
            this.isRequired();
        loadContactDoublonsList({currentContact:infosPersonne}).then(resultat => {
            this.loading = false;
            this.doublonsContactList =  resultat;
            console.log('@@@  doublonsPopupModal ' +  JSON.stringify(resultat));
            if(this.doublonsContactList == null || this.doublonsContactList.length === 0) {

                this.handleSubmit();
                this.doublonsContactList = null;
            } else {
                this.doublonsPopupModal = true;
                this.doublonsContactList = resultat;
            }
        }).catch(error => {
            this.loading = false;
            this.searchResult = undefined;
        });
    }
    validateData() {
        let valid = true;
        this.template.querySelectorAll('.validation').forEach(element => {
            valid = element.reportValidity() & valid;
        });
        if ( this.email && this.emailChanged && !this.isXdataIdOk ) {
            this.displayToast('Erreur',  this.emailErrorMessage, 'error');
            return false;
        }
        if(!valid) {
            this.displayToast('Erreur', "Merci de remplir tout les champs obligatoires", 'error');
            return false;
        }
        /*if(this.isEmpty(this.salutation) || this.isEmpty(this.prenom) || this.isEmpty(this.nom) || this.isEmpty(this.email) ||
        this.isEmpty(this.adresseChoisie.housenumber) || this.isEmpty(this.adresseChoisie.street) || this.isEmpty(this.adresseChoisie.postcode) || this.isEmpty(this.adresseChoisie.city) ||
        (this.isEmpty(this.numeroFixe) && this.isEmpty(this.numeroPortable))) {
            this.displayToast('Erreur', "Merci de remplir tout les champs obligatoires", 'error');
            return false;
        }*/
        return true;
    }
    isEmpty(str) {
        return (!str || 0 === str.length);
    }
    handleSubmit() {
        if(!this.validateData()) {
            return ;
        }
        let infosPersonne = {
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
        infosPersonne.civilite = this.salutation;
        infosPersonne.prenom = this.prenom;
        infosPersonne.nom = this.nom;
        infosPersonne.numeroFixe = ((this.numeroFixe != null && this.numeroFixe !== '')? (this.numeroFixe.length == 9 ?   '0' + this.numeroFixe : this.numeroFixe):'');
        infosPersonne.numeroMobile = ((this.numeroPortable != null && this.numeroPortable !== '')? (this.numeroPortable.length == 9 ? '0' + this.numeroPortable : this.numeroPortable):'');
        infosPersonne.email = this.email;
        infosPersonne.numVoie =  this.adresseChoisie.housenumber;
        infosPersonne.voie = this.adresseChoisie.street;
        infosPersonne.codePostal = this.adresseChoisie.postcode;
        infosPersonne.ville = this.adresseChoisie.city;
        infosPersonne.complementAdresse = this.adresseChoisie.cmpAdress;
        infosPersonne.stopEmail = this.stopEmail;
        infosPersonne.stopSms = this.stopSms;
        infosPersonne.optinMarketing = this.optinMarketing;
        console.log('condition num etranger ' + (this.isModification && this.numeroEtranger != null && this.numeroEtranger !== ''));


        console.log('condition num etranger ' + (this.isModification && this.numeroEtranger != null && this.numeroEtranger !== ''));

       if(this.isModification && this.numeroEtranger != null && this.numeroEtranger !== '') infosPersonne.numeroEtranger = this.numeroEtranger;
       console.log('after condition num etranger ' +this.numeroEtranger);


        if(this.recordid != null) {
            infosPersonne.id = this.recordid;
        }
        for(let i = 0; i < this.consentementList.length; i ++) {
            this.consentementList[i].consent = (this.consentementList[i].response == 'oui');
        }
        this.loading = true;
        console.log('this.consentementList ' + JSON.stringify(this.consentementList));
        console.log('infosPersonne : '+infosPersonne);

        saveClient({client:infosPersonne, indicateur: this.indicatif, concentementList:this.consentementList}).then(resultat => {
            this.loading = false;
            if(this.recordid == null) {
                eval("$A.get('e.force:closeQuickAction').fire();");
                console.log('@@ resultat  ' + JSON.stringify(resultat));
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId:  resultat,
                        actionName: 'view'
                    }
                });
            }
        let message = "Création de client avec succès";
        if(this.recordid != null) {
            if(this.infosEmailToSend.adresse){
                infosPersonne.complementAdresse = infosPersonne.complementAdresse === undefined ? '' : infosPersonne.complementAdresse;
                this.infosEmailToSend.adresse = infosPersonne.numVoie +' '+ infosPersonne.voie+' '+ infosPersonne.codePostal +' '+infosPersonne.complementAdresse + ' ' +infosPersonne.ville;
            }
            this.sendEmail();
            this.sendSMS();
            message = "Modification de client avec succès";
        }
        const event = new CustomEvent('closeupdate', { detail: infosPersonne});
        this.dispatchEvent(event);
        this.displayToast('Succès', message, 'success');
        }).catch(error => {
            this.loading = false;
        });
    }
    closedoublonsPopupModal() {
        this.doublonsPopupModal = false;
    }
    handleValueChange(event) {
        this.salutation = event.target.value;
    }
    handlePrenom(event) {
        this.prenom = event.target.value;
    }
    handleNom(event) {
        this.nom = event.target.value;
    }
    linkToContact(event) {
        this.doublonsPopupModal = false;
        eval("$A.get('e.force:closeQuickAction').fire();");
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  event.target.dataset.id,
                actionName: 'view',
            },
        })
    }
    consentementchanged(event) {
        console.log('@@ idquiestion ' +  event.currentTarget.dataset.id);
        console.log('@@ response ' +  event.target.value);
        this.activateEmailSMSCheckbox();
        this.infosEmailToSend.consentements = true;
        for(let i = 0; i < this.consentementList.length; i ++) {
            if(this.consentementList[i].name == event.currentTarget.dataset.id) {
                this.consentementList[i].response = event.target.value;
                return;
            }
        }
    }
    activateEmailSMSCheckbox() {
        try{
            this.template.querySelector('.confirmation-email').disabled = false;
        }catch(e){}
        try{
            this.template.querySelector('.confirmation-sms').disabled = false;
        }catch(e){}
    } 
    isSendEmailChecked() {
        this.confirmationEmail = !this.confirmationEmail;
    }
    isSendSMSChecked() {
        this.confirmationSMS = !this.confirmationSMS;
    }
    sendEmail() {
        if (this.confirmationEmail) {
            console.log('sendEmail');
            console.log('infosEmailToSend: '+JSON.stringify(this.infosEmailToSend));
            sendEmail({
                prenom: this.prenom,
                infosEmailToSend: this.infosEmailToSend,
                email: this.email,
                idClient:this.idClient
            }).then(resultEmail => {
                console.log('result Email: ',resultEmail);
            }).catch(error => {
                console.log('error EMail: ',error);
                this.loading = false;
                this.displayToast('Erreur', "Une erreur est survenue lors de la sauvegarde !", 'error');
            });
        }
    }
    sendSMS() {
        if (this.confirmationSMS) {
            console.log('sendSMS');
            console.log('this.prenom:', this.prenom);
            let prenom = this.getName(this.prenom);
            let startWithPlus =  this.numeroPortable != null &&  this.numeroPortable.startsWith('+');
            console.log('prenom:', prenom);
            sendSMS({
                prenom: prenom,
                numMobile: startWithPlus ? (0+this.numeroPortable.substring(3) ) : this.numeroPortable,
                idClient: this.idClient
            }).then(resultSMS => {
                console.log('result SMS: ',resultSMS);
            }).catch(error => {
                console.log('error SMS: ',error);
                this.loading = false;
                this.displayToast('Erreur', "Une erreur est survenue lors de la sauvegarde !", 'error');
            });
        }
    }
    getName(name){
        let map = {
            'a' : 'à|á|â|ã|À|Á|Â|Ã',
            'e' : 'è|é|ê|ë|È|É|Ê|Ë',
            'i' : 'ì|í|î|ï|Ì|Í|Î|Ï',
            'o' : 'ò|ó|ô|õ|Ò|Ó|Ô|Õ',
            'u' : 'ù|ú|û|ü|Ù|Ú|Û|Ü',
            'c' : 'ç|Ç',
            'n' : 'ñ|Ñ'
        }
        for(let pattern in map){
            name = name.replace(new RegExp(map[pattern], 'g'), pattern);
        }
        return name;
    }
    closeInterface() {
        eval("$A.get('e.force:closeQuickAction').fire();");
        const event = new CustomEvent('closeupdate', { detail: null});
        this.dispatchEvent(event);
    }

    //marketing consents

    marketingLabels = {
        stopEmailPhrase,
        stopSmsPhrase,
        optinMarketingPhrase
    };

    get stopsmsyes(){
        console.log('StopSms : '+this.stopSms);
        if (this.stopSms === true) return 'oui';
        return 'non';
    }

    get stopemailyes(){
        console.log('StopEmail : '+this.stopEmail);
        if (this.stopEmail === true) return 'oui';
        return 'non';
    }

    get optinmarketingyes(){
        console.log('OptinMarketing : '+ this.optinMarketing);
        if (this.optinMarketing === true) return 'oui';
        return 'non';
    }

    getmodifiedStopemail(event){
        let result  = event.target.value;
        if( result === 'oui'){
            this.stopEmail = true;
        }else{
            this.stopEmail = false;
        }
    }

    getmodifiedStopsms(event){
        let result  = event.target.value;
        if( result === 'oui'){
            this.stopSms = true;
        }else{
            this.stopSms = false;
        }
    }

    getmodifiedOptinmarketing(event){
        let result  = event.target.value;
        if( result === 'oui'){
            this.optinMarketing = true;
        }else{
            this.optinMarketing = false;
        }
    }
}