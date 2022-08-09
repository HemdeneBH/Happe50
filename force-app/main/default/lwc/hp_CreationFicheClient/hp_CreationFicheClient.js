/**
 * @File Name          : hp_CreationFicheClient.js
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Mohamed Aamer
 * @Last Modified On   : 17/02/2020 à 14:50:58
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/12/2019   Mohamed Aamer     Initial Version
**/
import { LightningElement, track,wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import {updateRecord,getRecord } from 'lightning/uiRecordApi';
import getQuestionsConsent from '@salesforce/apex/HP_SM008_APIHour.getQuestionsConsentement';
import sendConsentResponses from '@salesforce/apex/HP_SM008_APIHour.sendConsentResponses';
import getAdresses from '@salesforce/apex/HP_APIGouv.getSuggestions';
import ecrirePersonne from '@salesforce/apex/HP_PersonneController.ecrirePersonne';
import verifyELD from '@salesforce/apex/HP_SM008_APIHour.getZonesDistributions'; // HAPP-186 Verficiation city is ELD 
import getCommunes from '@salesforce/apex/HP_SM008_APIHour.getCommunes'; //HAPP-189
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import SALUTATION_FIELD  from '@salesforce/schema/Contact.Salutation';
import PRENOM_FIELD from '@salesforce/schema/Contact.FirstName';
import NOM_FIELD  from '@salesforce/schema/Contact.LastName';
import NUM_VOIE_FIELD from '@salesforce/schema/Contact.No_Voie__c';
import VOIE_FIELD  from '@salesforce/schema/Contact.MailingStreet';
import CODEPOSTALE_FIELD  from '@salesforce/schema/Contact.MailingPostalCode';
import VILLE_FIELD  from '@salesforce/schema/Contact.MailingCity';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import MOBILE_FIELD from '@salesforce/schema/Contact.MobilePhone';
import FIXE_FIELD from '@salesforce/schema/Contact.Phone';
import XdataID_FIELD from '@salesforce/schema/Contact.ID_Tiers__c';
import COMPLEMENT_ADRESSE_FIELD from '@salesforce/schema/Contact.Complement_adresse__c'; 
import loadContactDoublonsList from '@salesforce/apex/HP_PersonneController.loadContactDoublonsList';
import getTelephoneValidation from '@salesforce/apex/HP_SM0017_DQE.getTelephoneValidation';
import getContryCode from '@salesforce/apex/HP_SM003_MetadataManager.getContryCode';
import getEmailValidation from '@salesforce/apex/HP_SM0017_DQE.getEmailValidation';
//import INDICATIF_PAYS from '@salesforce/schema/Contact.HP_Indicatif__c';
import IS_HAPPE from '@salesforce/schema/Contact.HP_IsHappe__c';
export default class Hp_CreationFicheClient extends NavigationMixin(LightningElement) {
    @track questions;
    @track responses; 
    @track adresses;
    @track adresseActuelle;
    @track modeSaisie = '';
    @track adresseChoisie;
    @track communes;
    @track patternMobile = /^(06|07)[0-9]{8}$/;
    @track patternfixe = /^(01|02|03|04|05|09)[0-9]{8}$/; 
    @track erreurData = false;
    @track isError = false;
    @track isGazELD = false;
    @track isElecELD = false;
    @track isElecGazELD = false;
    @track consentementList = [];
    @track loading = true;
    @track salutation ='';
    @track salutations =[{label:'MR',value:'MR'},{label:'MME',value:'MME'}];
    @track nom ='';
    @track prenom ='';
    @track noVoie ='';
    @track voie ='';
    @track complementAdresse ='';
    @track codePostale ='';
    @track ville ='';
    @track email ='';
    @track numeroPortable ='';
    @track numeroFixe = '';
    @track indicatif = '+33';
    @track doublonsContactList =[];
    @track doublonsPopupModal = false;
    @track indicatifValues;
    @wire(getObjectInfo, {objectApiName : CONTACT_OBJECT})
    contactObjectInfo;

    @wire(
        getPicklistValues,
        {
            recordTypeId: '$contactObjectInfo.data.defaultRecordTypeId',
            fieldApiName: ''
        }
    ) picklistValues({ error, data }) {
        if (data) {
			this.indicatifValues = data;
			console.log('indicatifValues : ',JSON.stringify(this.indicatifValues));
			
		} else if (error) {
			console.log('wiredIndicatifValues error: ',JSON.stringify(error));
			this.indicatifValues = undefined;
		}
    }
    
    connectedCallback() {
       
         getQuestionsConsent().then(resultat => {
            console.log('getQuestionsConsent',JSON.stringify(resultat))
            this.questions = resultat;
            this.loading = false;
             for (let index = 0; index < this.questions.length; index++) {
                 this.consentementList.push({
                     idPersonne: 0,
                     libelleQuestion: '',
                     idQuestion: 0,
                     idQuestionnaire: 0,
                     consent: false,
                     canal: 'Telephone',
                     application: 'HAPPE',
                     name: 'consent'+index,
                     checkYes: false,
                     checkNo: true
                 });
                this.consentementList[index].libelleQuestion = this.questions[index].libelleQuestion;
                this.consentementList[index].idQuestion = parseInt(this.questions[index].idQuestion);
                this.consentementList[index].idQuestionnaire = parseInt(this.questions[index].idQuestionnaire);
            }
        }).catch(erreur => {
            if (erreur.length > 0) {
            this.loading = false;
            this.displayToast('Erreur', "Une erreur est servenue lors de récupération des questions du consentement", 'error', []);
            }
            
           
        });
    }
    renderedCallback(){
        this.modeSaisie = 'manuelle';
    }

    loadDoublonsContact() {
        let infosPersonne = {};
            infosPersonne.prenom = this.prenom;
            infosPersonne.nom = this.nom;
            infosPersonne.numeroFixe = this.indicatif + ((this.numeroFixe != null && this.numeroFixe !== '')?  this.numeroFixe.substring(1):'');
            infosPersonne.numeroMobile =this.indicatif + ((this.numeroPortable != null && this.numeroPortable !== '')?  this.numeroPortable.substring(1):'');
            infosPersonne.email = this.email;
            infosPersonne.numVoie = this.noVoie;
            infosPersonne.voie = this.voie;
            infosPersonne.codePostal = this.codePostale;
            infosPersonne.ville = this.ville;
            infosPersonne.indicatif = this.indicatif;
            console.log('@@@  infosPersonne ' +  JSON.stringify(infosPersonne));
        loadContactDoublonsList({currentContact:infosPersonne}).then(resultat => {
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
            this.searchResult = undefined;
        });
    }

    closedoublonsPopupModal() {
        this.doublonsPopupModal = false;
    }

    linkToContact(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  event.target.dataset.id,
                actionName: 'view',
            },
        })
    }
    handleSubmit() {
        this.doublonsPopupModal = false;
        this.loading = true;
        const fields = {};
        // this.handleSalutationMessage(this.template.querySelector('.civil').value);
        this.handleNomMessage(this.template.querySelector('.nom').value);
        this.handlePrenomMessage(this.template.querySelector('.preno').value);
        this.handleNumeroPortableMessage(this.template.querySelector('.num1').value);
        this.handleNumeroFixeMessage(this.template.querySelector('.num2').value);
        if (this.erreurData) {
				this.displayToast('Erreur', "Merci de remplir tout les champs obligatoires", 'error', []);
                this.loading = false;
            } else {
            let infosPersonne = {
                "civilite" : null,
                "nom" : null,
                "prenom": null,
                "numeroFixe": null,
                "numeroMobile": null,
                "email": null,
                "prospect": false,
                "client": true,
                "numVoie": null,
                "voie": null,
                "complementAdresse": "",
                "codePostal": null,
                "ville": null,
                "pays": "FR"
            };
            infosPersonne.civilite = this.salutation;
            infosPersonne.prenom = this.prenom;
            infosPersonne.nom = this.nom;
            infosPersonne.numeroFixe = this.numeroFixe;
            infosPersonne.numeroMobile = this.numeroPortable;
            infosPersonne.email = this.email;
            infosPersonne.numVoie = this.noVoie;
            infosPersonne.voie = this.voie;
            infosPersonne.codePostal = this.codePostale;
            infosPersonne.ville = this.ville;
            fields[SALUTATION_FIELD.fieldApiName] = this.salutation;
            fields[PRENOM_FIELD.fieldApiName] = this.prenom;
            fields[NOM_FIELD.fieldApiName] = this.nom;
            fields[NUM_VOIE_FIELD.fieldApiName] = this.noVoie;
            fields[VOIE_FIELD.fieldApiName] = this.voie;
            fields[COMPLEMENT_ADRESSE_FIELD.fieldApiName] = this.complementAdresse;
            fields[CODEPOSTALE_FIELD.fieldApiName] = this.codePostale;
            fields[VILLE_FIELD.fieldApiName] = this.ville;
            fields[EMAIL_FIELD.fieldApiName] = this.email;
            fields[MOBILE_FIELD.fieldApiName] = this.numeroPortable;
            fields[FIXE_FIELD.fieldApiName] = this.numeroFixe;
            fields[INDICATIF_PAYS.fieldApiName] = this.indicatif;
            fields[IS_HAPPE.fieldApiName]= true;
            console.log( 'Moulaaa===>', JSON.stringify(infosPersonne));
            ecrirePersonne({ infosPersonneJson: JSON.stringify(infosPersonne) }).then(res => {
                console.log('res: ',res);
                
                let idPersonneXdata = parseInt(res, 10);
                fields[XdataID_FIELD.fieldApiName] = idPersonneXdata;
                for (let index = 0; index < this.consentementList.length; index++) {
                    this.consentementList[index].idPersonne = idPersonneXdata;
                }
                sendConsentResponses({ consentToSend: JSON.stringify(this.consentementList) }).then(resultat => {
                    const recordInput = { apiName: CONTACT_OBJECT.objectApiName, fields };
                    createRecord(recordInput).then(contact => {           
                        let close = true;
                        const closeclickedevt = new CustomEvent('closeclicked', {
                            detail: { close },
                        });
                        this.dispatchEvent(closeclickedevt);
                        this.displayToast('Succès', "Modifications enregistrées avec succès", 'success', []);
                    })
                    .catch(erreur => {
                        this.loading = false;
                        this.displayToast('Erreur', "Une erreur est survenue lors de la sauvegarde  Salesforce!", 'error', []);
                    });
                })
                .catch(erreur => {
                    this.loading = false;
                    this.displayToast('Erreur', "Une erreur est survenue lors de la sauvegarde des consentements du client!", 'error', []);
                });
            }).catch(erreur => {
                this.loading = false;
                this.displayToast('Erreur', "Une erreur est survenue lors de la création du client dans Xdata !", 'error', []);
                console.log('ecrirePersonne: ', JSON.stringify(erreur));
            });

        }
    }
    handleSalutation(event) {
        this.salutation = event.target.value;
        // this.handleSalutationMessage(this.salutation);
    }
    handleSalutationMessage(value) {
       
        if (value == "--None--") {
            this.erreurData = true;
            this.template.querySelector('.civilError').classList.remove('display-none');
        } else if (value !="--None--") {
            this.erreurData = false;
            this.template.querySelector('.civilError').classList.add('display-none');
        }
    }
    handleNom(event) {
        this.nom = event.target.value;
        this.handleNomMessage(this.nom);
    }
    handleNomMessage(value) {
        
        if (!value ||  !String(value).trim()) {
            this.erreurData = true;
            this.template.querySelector('.nomError').classList.remove('display-none');
        } else if (value ||  String(value).trim()) {
            this.erreurData = false;
            this.template.querySelector('.nomError').classList.add('display-none');
        }
    }
    handlePrenom(event) {
        this.prenom = event.target.value;
        this.handlePrenomMessage(this.prenom);
    }
    handlePrenomMessage(value) {
        
        if (!value ||  !String(value).trim()) {
            this.erreurData = true;
            this.template.querySelector('.prenoError').classList.remove('display-none');
        } else if (value ||  String(value).trim()) {
            this.erreurData = false;
            this.template.querySelector('.prenoError').classList.add('display-none');
        }
    }
    handleNoVoie(event) {
        this.noVoie = event.target.value;
    }
    handleVoie(event) {
        this.voie = event.target.value;
        
    }
    handleIndicatif(event) {
        this.indicatif = event.target.value;
    }
    handleCodePostale(event) {
        this.codePostale = event.target.value;
    }
    handleVille(event) {
        this.ville = event.target.value;
    }
    handleEmail(event) {
        this.email = event.target.value;
        this.emailValidation(event);
    }
    handleNumeroPortable(event) {
        this.numeroPortable = event.target.value;
        this.isRequired();
        this.checkPatternMobile(event);
        this.handleNumeroPortableMessage(this.numeroPortable);
    }
    handleNumeroPortableMessage(value) {
        
        if (value.length > 0 && value.length !=10) {
            this.erreurData = true;
            this.template.querySelector('.notvalid1').classList.remove('display-none');
        } else if (value.length == 0 ||  String(value).trim() || value.length == 10) {
            this.erreurData = false;
            this.template.querySelector('.notvalid1').classList.add('display-none');
        }
    }
    handleNumeroFixe(event) {
        this.numeroFixe = event.target.value;
        this.isRequired();
        this.checkPatternFixe(event);
        this.handleNumeroFixeMessage(this.numeroFixe);
    }
    handleNumeroFixeMessage(value) {
        
        if (value.length > 0 && value.length !=10) {
            this.erreurData = true;
            this.template.querySelector('.notvalid2').classList.remove('display-none');
        } else if (value.length == 0 ||  String(value).trim() || value.length == 10) {
            this.erreurData = false;
            this.template.querySelector('.notvalid2').classList.add('display-none');
        }
    }
    handleComplementAdresse(event) {
        this.complementAdresse = event.target.value;
    }

	modifyConsent(index,newConsent) {
        this.consentementList[index].consent = newConsent;
        if (newConsent === 'checkYes') {
            this.consentementList[index].consent = true
            this.consentementList[index].checkYes = true;
            this.consentementList[index].checkNo = false;
        } else {
            this.consentementList[index].consent = false;
            this.consentementList[index].checkYes = false;
            this.consentementList[index].checkNo = true;
        }
    }

	getmodifiedConsent(event) {
        let newConsent = event.target.value;
		let consentName = event.target.name;
		for (let index = 0; index < this.consentementList.length; index++) {
			if (this.consentementList[index].name === consentName) {
				this.modifyConsent(index,newConsent);
			}
		}
	}

    get consentReady() {
        return true;
    }
    get options() {
        return [
            { label: 'Automatique', value: 'automatique' },
            { label: 'Manuelle', value: 'manuelle' },
        ];
    }
//verification du numero de telephone a partir de l'indicatif 
    telephoneValidation(event) {
    
       
        getContryCode({ indicatif:this.indicatif }).then(result => {
            this.codeIso = result;
        }).catch(error => {
            console.log('error',JSON.stringify(error))
        })
        if (event.target.value.length >= 10) {
            getTelephoneValidation({ telephone: String(event.target.value),pays:this.codeIso }).then(result => {
                if (result.IdError === 0) {
                    
                    this.displayToast('Erreur', "Le numero renseigné n'est pas atribué", 'error', []);
                }
               
            }).catch(error => {
                console.log('error',JSON.stringify(error))
            })
        }
     
    }
    //Validation de l'email a en fonction de la terminaison(a verifier avce Carl si ajout de bouton)
    emailValidation(event) {
        if (String(event.target.value).includes('.com') || String(event.target.value).includes('.fr')) {
            getEmailValidation({ email: String(event.target.value) }).then(result => {

                console.log('getTelephoneValidation ', JSON.stringify(result));
                if (result.IdError !== "00") {
                    
                    this.displayToast('Erreur', "L'email presente des erreurs",result.eMail,  'error', []);//result.eMail,
                }
                
            }).catch(error => {
                console.log('error',JSON.stringify(error))
            })
        }
   
    }


    handleOnChange(event){
        if(event.target.value==='automatique'){
            this.template.querySelector('.auto').classList.remove('display-none');
			this.template.querySelector('.manu').classList.add('display-none');
        }else if (event.target.value==='manuelle'){
            this.template.querySelector('.auto').classList.add('display-none');
			this.template.querySelector('.manu').classList.remove('display-none');
        }
        this.resetELD(); 
    }

    isRequired() {
        if( (this.template.querySelector('.num1').value === null || this.template.querySelector('.num1').value === '') && this.template.querySelector('.num2').value !==null && this.template.querySelector('.num2').value !==''){
            this.template.querySelector('.num1').required =false;
            this.template.querySelector('.num2').required =true;
        }
        else if( (this.template.querySelector('.num2').value === null || this.template.querySelector('.num2').value === '') && this.template.querySelector('.num1').value!==null && this.template.querySelector('.num1').value !==''){
            this.template.querySelector('.num1').required =true;
            this.template.querySelector('.num2').required =false;
        }
        else if((this.template.querySelector('.num2').value === null || this.template.querySelector('.num2').value === '')&&(this.template.querySelector('.num1').value === null || this.template.querySelector('.num1').value === '')){
            this.template.querySelector('.num1').required =true;
            this.template.querySelector('.num2').required =false;
        }
    }

    checkPatternMobile(event) {
        let mobileValue = event.target.value;
        if(mobileValue.length>=10) {
            let matchMobile = mobileValue.match(this.patternMobile);
            if(matchMobile === null){
                this.template.querySelector('.mobileError').classList.remove('display-none');
                this.erreurData = true;
            } else {
                this.template.querySelector('.mobileError').classList.add('display-none');
                this.erreurData = false;
            }
        }else {
            this.template.querySelector('.mobileError').classList.add('display-none');
            this.erreurData = false;
        }
        this.telephoneValidation(event);
        
    }
    
    checkPatternFixe(event) {
        let fixeValue = event.target.value;
        
        if(fixeValue.length>=10){
            let matchFixe = fixeValue.match(this.patternfixe);
            if(matchFixe === null) {
                this.template.querySelector('.fixeError').classList.remove('display-none');
                this.erreurData = true;
            } else {
                this.template.querySelector('.fixeError').classList.add('display-none');
                this.erreurData = false;
            }
        }else {
            this.template.querySelector('.fixeError').classList.add('display-none');
            this.erreurData = false;
        }
        this.telephoneValidation(event);
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
			let input = event.target.value;
			let splitSpaceStr = input.split(' ');
			input = input.split(' ').join('+');
				if(input.length>7 || (splitSpaceStr && splitSpaceStr[1] && splitSpaceStr[1].length>1)){
					getAdresses({input}).then(resultat => {
                        this.adresses = resultat.features;
                    }).catch(error => {
						this.searchResult = undefined;
					});
				} else {
					this.searchResult = undefined;
				}
        }
        this.template.querySelector('[data-id="listbox"]').classList.remove('display-none');
    }

    selectedValue(event){
        this.resetELD();
        this.adresseChoisie = {
            housenumber: event.currentTarget.dataset.housenumber,
            street: event.currentTarget.dataset.street,
            postcode:event.currentTarget.dataset.postcode,
            city:event.currentTarget.dataset.city,
            cmpAdress:'',
            citycode: event.currentTarget.dataset.citycode
        }
        this.displayCityELD(this.adresseChoisie);
        this.noVoie = this.adresseChoisie.housenumber;
        this.template.querySelector('.noVoie').value=this.noVoie;
        this.voie = this.adresseChoisie.street;
        this.template.querySelector('.noStreet').value=this.voie;
        this.codePostale = this.adresseChoisie.postcode;
        this.template.querySelector('.noPostal').value=this.codePostale;
        this.ville = this.adresseChoisie.city;
        this.template.querySelector('.noCity').value=this.ville;
        this.complementAdresse = this.adresseChoisie.cmpAdress;
        this.template.querySelector('.cmpAdress').value=this.complementAdresse;
        this.adresseActuelle= event.currentTarget.dataset.name;
        this.template.querySelector('[data-id="listbox"]').classList.add('display-none');
    }

    selectedManuValue(event) {
        this.ville = event.currentTarget.dataset.city.trimEnd();
        this.template.querySelector('[data-id="listboxx"]').classList.add('display-none');
        this.handleClickELD();
    }
    handleValueChange(event) {
        this.salutation = event.target.value;
    }
    
    handleBlur(event) {
        this.codePostale = event.target.value;
        if (this.codePostale.length > 4) {
            this.template.querySelector('.noCity').disabled = false;
            getCommunes({
                postalCode: String(this.codePostale)
            }).then(
                result => {
                    this.communes = result;
                    if( this.communes.length === 1){
                        this.ville =  this.communes[0].ville.trimEnd();
                        this.template.querySelector('[data-id="listboxx"]').classList.add('display-none');
                        this.handleClickELD();
                    }else{
                        this.template.querySelector('.noCity').value = '';
                        this.template.querySelector('[data-id="listboxx"]').classList.remove('display-none');
                    }
                }
            ).catch(error => {
                console.log('errorHandleBlur function getCommunes', JSON.stringify(error));
                this.template.querySelector('.noCity').value = "--None--" ; 
            });
        }else if (this.codePostale.length === 0){
            this.template.querySelector('.noCity').disabled = true;
        }
    }

    resetELD() {
        this.isGazELD = false;
        this.isElecELD = false;
        this.isElecGazELD = false;
    }

    callAPIGouv(inputdata) {
        let input = 'city=' + inputdata.cityValue + '&postcode=' + inputdata.postcodeValue;
        getAdresses({
            input
        }).then(result => {
            if (result !== undefined) {
                let citycodeValue = result[0].properties.citycode;
                console.log('result[0].properties.citycode', JSON.stringify(result[0].properties.citycode));
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
            console.log('errorSearch function callAPIGouv',  JSON.stringify(error));
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