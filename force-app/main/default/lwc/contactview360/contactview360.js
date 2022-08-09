import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CREER from '@salesforce/label/c.SM_CL35_Creer';
import ANNULER from '@salesforce/label/c.SM_CL36_Annuler';
import RENVOYER from '@salesforce/label/c.SM_CL37_Renvoyer';
import OK from '@salesforce/label/c.SM_CL38_OK';
import SALUT_FIELD from '@salesforce/schema/Contact.Salutation';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import REFCLI_FIELD from '@salesforce/schema/Contact.Identifiant_Buisness_Partener__c';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import EMAIL_FIELD2 from '@salesforce/schema/Contact.Adresse_Mail_2__c';
import EMAIL_FIELD3 from '@salesforce/schema/Contact.Adresse_Mail_3__c';
import EMAILPR_FIELD from '@salesforce/schema/Contact.EmailPrincipalValue__c';
import EMAILPR_FIELD_ITEM from '@salesforce/schema/Contact.Adresse_Mail_Principale__c';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import MOBILE_FIELD from '@salesforce/schema/Contact.MobilePrincipalValue__c';
import FIXPR_FIELD from '@salesforce/schema/Contact.TelFixePrincipalValue__c';
import INTST_FIELD from '@salesforce/schema/Contact.Statut_Internaute__c';
import REQUALIF_FIELD from '@salesforce/schema/Contact.A_requalifier__c';
import SEGMKT_FIELD from '@salesforce/schema/Contact.Segment_Marketing__c';
import NOVOIE_FIELD from '@salesforce/schema/Contact.No_Voie__c';
import MAILST_FIELD from '@salesforce/schema/Contact.MailingStreet';
import MAILCI_FIELD from '@salesforce/schema/Contact.MailingCity';
import MAILPO_FIELD from '@salesforce/schema/Contact.MailingPostalCode';
import CPLTAD_FIELD from '@salesforce/schema/Contact.Complement_adresse__c';
import ID_Tiers_FIELD from '@salesforce/schema/Contact.ID_Tiers__c';



import getURLImpersonationForContact from '@salesforce/apex/SM_AP21_GestionImpersonation.getURLImpersonationForContact';
import creerEspaceClientService from '@salesforce/apex/SM_AP72_EspaceClientService.creerEspaceClient';
import renvoyerMailActivationService from '@salesforce/apex/SM_AP72_EspaceClientService.renvoyerMailActivation';
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";
import rechercherContratLightning from "@salesforce/apex/SM_AP53_ContratWS.rechercherContratLightning";
import { createMessageContext, releaseMessageContext ,subscribe, unsubscribe,APPLICATION_SCOPE } from 'lightning/messageService';
import npaiFlagNotification from "@salesforce/messageChannel/sm_npaiflagnotification__c";
import containerToContactMessageChannel from '@salesforce/messageChannel/sm_containertocontact__c';
import getContractActif from "@salesforce/apex/SM_AP87_ContratActifList.getContractActif";
import edocactive from '@salesforce/resourceUrl/edocactif';
import callIP from '@salesforce/apex/SM_AP77_CallIPApiService.callIP';
import checkActivateOKTAECService from '@salesforce/apex/SM_CTRL009_CheckActivateOKTAEC.checkActivateOKTAEC';

const FIELDS = [ID_Tiers_FIELD,SALUT_FIELD, FIRSTNAME_FIELD, LASTNAME_FIELD, REFCLI_FIELD, EMAILPR_FIELD, EMAIL_FIELD, EMAIL_FIELD2, EMAIL_FIELD3, EMAILPR_FIELD_ITEM, PHONE_FIELD,MOBILE_FIELD, FIXPR_FIELD, INTST_FIELD, REQUALIF_FIELD, SEGMKT_FIELD, NOVOIE_FIELD, MAILST_FIELD, MAILCI_FIELD, MAILPO_FIELD, CPLTAD_FIELD];

export default class Contactview360 extends NavigationMixin(LightningElement) {
    label = {
        CREER,
        ANNULER,
        RENVOYER,
        OK
    }
    listVipCode = ['V1','V2','V3'];
    infoTitlePopup=false;
    @api recordId;
    @api edocument;
    @api flagNPAI;
    @api accountUndefined;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) contact;
    @track selectedEmailValue;
    @track selectedEmailItem;
    @track isNewEmail = false;
    @track creerEspaceClientModel = false;
    @track erreurPopupModel = false;
    @track renvoyerCodeActivationModel = false;
    @track emailNewEspaceClient;
    @track codeClient;
    @track estClientEHS = false;	
    @track estConnuEHS = false;
    imgedocactif = edocactive;
    connectedCallback() {

        this.accountUndefined = true;
        this.subscribeContainerToContactMessageChannel();
        this.subscribenpaiFlagNotification();
        this.getNPAIFlag();
    }
    context = createMessageContext();
    containerToContactSubscription = null;
    npaiFlagNotification = null;
    @track eDocumentStatus = '';
    felStatusMap = new Map();
    eDocumentStatusMap = new Map();
    accountContractMap = new Map();



    getNPAIFlag(){
    callIP({inputMap:{ contactId:this.recordId, idtiers:null}, NameIntergation:"IP_SM_getNPAIFlag_APISET"})
        .then(result => {
            console.log('got result ', result);
            this.flagNPAI = result.isNPAIFlag;
            return this.flagNPAI;            
        })
        .catch(error => {
            console.log('got error ', error);
            return false;
        });

    }
    subscribeContainerToContactMessageChannel() {
        if (this.containerToContactSubscription) {
            return;
        }
        this.containerToContactSubscription = subscribe(this.context, containerToContactMessageChannel, (message) => {
            this.handleContainerToContactMessage(message);
        });
     }
     subscribenpaiFlagNotification() {
        if (this.npaiFlagNotification) {
            return;
        }
        this.npaiFlagNotification = subscribe(this.context, npaiFlagNotification, (message) => {
            this.handleNpaiFlagNotificationMessage(message);
        },{ scope: APPLICATION_SCOPE });
     }

     handleContainerToContactMessage(message) {

        if(message.account !== undefined){
            this.accountContractMap.set(message.recordid, message.account);
            this.felStatusMap.set(message.recordid, message.fel);
            this.eDocumentStatusMap.set(message.recordid, message.edoc);
            this.eDocumentStatus = this.eDocumentStatusMap.get(this.recordId);
            this.codeClient = message.codeClient;
            this.estClientEHS = message.estClientEHS;
            this.estConnuEHS = message.estConnuEHS;
            this.accountUndefined = false;
        } else {
            this.accountUndefined = false;
        }
        }

    handleNpaiFlagNotificationMessage(message) {
            this.flagNPAI = message.npaiFlag;
    }

    disconnectedCallback() {
        releaseMessageContext(this.context);
    }
    /* get urlLink() {return "/apex/SM_VFP_ModifInformationPerso?id=" + this.recordId;} */
    get urlLink() { return "/apex/vlocity_cmt__OmniScriptUniversalPageConsole?id={0}&OmniScriptType=Contact&OmniScriptSubType=ModifyInformations&OmniScriptLang=English&PrefillDataRaptorBundle=&scriptMode=vertical&layout=lightning&ContextId={0}"; }
    get salutation() { return getFieldValue(this.contact.data, SALUT_FIELD); }
    get firstname() { return getFieldValue(this.contact.data, FIRSTNAME_FIELD) }
    get lastname() { return getFieldValue(this.contact.data, LASTNAME_FIELD); }
    get idtiers() { return getFieldValue(this.contact.data, ID_Tiers_FIELD); }
    get refclient() {
        let refcl1 = getFieldValue(this.contact.data, REFCLI_FIELD);
        let refcl2 = String(refcl1);
        if (refcl2.length > 9) {
            return refcl2.substr(-9);
        }
        return refcl2;
    }
    get refclient_OKTA() { return getFieldValue(this.contact.data, REFCLI_FIELD); }
    get emailprincipal() { return getFieldValue(this.contact.data, EMAILPR_FIELD); }
    get emailprincipalitem() { return getFieldValue(this.contact.data, EMAILPR_FIELD_ITEM); }
    get email() { return getFieldValue(this.contact.data, EMAIL_FIELD); }
    get email2() { return getFieldValue(this.contact.data, EMAIL_FIELD2); }
    get email3() { return getFieldValue(this.contact.data, EMAIL_FIELD3); }
    get telfixeprincipal() { return getFieldValue(this.contact.data, FIXPR_FIELD); }
    get mobileprincipal() { return getFieldValue(this.contact.data, MOBILE_FIELD); }
    get emailField() { return getFieldValue(this.contact.data, EMAIL_FIELD); }
    get arequalifier() { return (getFieldValue(this.contact.data, REQUALIF_FIELD) || this.flagNPAI);}
    get statutinternaute() { return getFieldValue(this.contact.data, INTST_FIELD); }
    get segmentmarketing() { return getFieldValue(this.contact.data, SEGMKT_FIELD); }
    get novoie() { return getFieldValue(this.contact.data, NOVOIE_FIELD); }
    get mailingstreet() { return getFieldValue(this.contact.data, MAILST_FIELD); }
    get mailingcity() { return getFieldValue(this.contact.data, MAILCI_FIELD); }
    get mailingpostalcode() { return getFieldValue(this.contact.data, MAILPO_FIELD); }
    get complementadresse() { return getFieldValue(this.contact.data, CPLTAD_FIELD); }
    get isClientVip() { return this.listVipCode.includes(this.codeClient)}
    get codeClient() { return this.codeClient }
    get ismister() {
        let salutation = getFieldValue(this.contact.data, SALUT_FIELD);
        return (salutation === 'MR') ? true : false;
    }
    get ismadame() {
        let salutation = getFieldValue(this.contact.data, SALUT_FIELD);
        return (salutation === 'MRS' || salutation === 'MME' || salutation === 'MLLE') ? true : false;
    }
    get isother() {
        let salutation = getFieldValue(this.contact.data, SALUT_FIELD);
        return (salutation != 'MR' && salutation != 'MRS' && salutation != 'MME' && salutation != 'MLLE') ? true : false;
    }
    get isinternaute() {
        return getFieldValue(this.contact.data, INTST_FIELD) === 'Oui';
    }
    get becomesinternaute() {
        return getFieldValue(this.contact.data, INTST_FIELD) === 'En cours';
    }
    get notinternaute() {
        return getFieldValue(this.contact.data, INTST_FIELD) === 'Aucun' || getFieldValue(this.contact.data, INTST_FIELD) === null ||  getFieldValue(this.contact.data, INTST_FIELD) === '' || getFieldValue(this.contact.data, INTST_FIELD) === 'Non' || getFieldValue(this.contact.data, INTST_FIELD) === 'A eu un compte en ligne';
    }
    get numvoierue() {
        let novoie = getFieldValue(this.contact.data, NOVOIE_FIELD);
        let mailingstreet = getFieldValue(this.contact.data, MAILST_FIELD);
        if (novoie === null) {
            return mailingstreet;
        }
        return novoie + ' ' + mailingstreet;
    }
    get isThereAnEmail() {
        return getFieldValue(this.contact.data, EMAIL_FIELD) !== null ||
            getFieldValue(this.contact.data, EMAIL_FIELD2) !== null ||
            getFieldValue(this.contact.data, EMAIL_FIELD3) !== null;
    }
    get messageEhsActif() { return "La chaudière est entretenue par Engie Home Services"}
    get messageEhsConnu() { return "Client Connu par Engie Home Service (Prospect ou Ancien Client)"}
    get messageClientVIP() { return "Client VIP"}
    updateCoords() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_ModifyClientInfosComp'
            },
            state: {
                c__recordId: this.recordId,
                c__npaiFlag: (this.flagNPAI).toString()
            }
        });
    }
    updateTitulaire() {
        setCache().then(r => {
            const data = {
                idBp: this.refclient,
                origineAppel: "Vue360"
            };
            rechercherContratLightning({ inputMap: data })
            .then(result => {
                console.log(result.resultdata);
                let nbrContrat = 0;
                let listResponse = [];
                let listContrat = [];
                for (const [i,contrat] of result.resultdata.entries()) {
                    //E0001 E0003 E0004 E0005, E0006
                    if(contrat.typeContrat === "GN" || contrat.typeContrat === "E") {
                        getContractActif({ contractCode: contrat.statutCode}).then(resultContractActif=> {
                            listResponse.push(resultContractActif);
                            if(resultContractActif) {
                                listContrat.push(contrat);
                                nbrContrat++;
                            }
                            console.log(i);
                            if (listResponse.length === result.resultdata.length) {
                                // si un contrat ou 2 contrat avec une offre dual
                                if (nbrContrat > 0) {
                                    const eventName = "openedittitulaire";
                                    const inputMap = {
                                        test: true
                                    };
                                    const event = new CustomEvent(eventName, {
                                        bubbles: true,
                                        composed: true,
                                        detail: inputMap
                                    });
                                    this.dispatchEvent(event);
                                } else {
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Modification titullaire du compte impossible',
                                            message: 'le client ne dispose d\'aucun contrat actif sur son compte.',
                                            variant: 'error',
                                        }),
                                    );
                                }
                            }
                        }).catch(error => {
                            console.log(error);
                        });
                    }
                    // if ( (contrat.statutCode === "E0001" || contrat.statutCode === "E0003" || contrat.statutCode === "E0004" || contrat.statutCode === "E0005" || contrat.statutCode === "E0006") 
                    //     &&  ( )) {
                    // }
                }
            })
            .catch(error => {
                console.log("got error getContratsWS", error);
            });
        }).catch(error => {
            console.log("got error setCache", error);
        });
    }
    /*
    navigateToModePaiement(){
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_Mode_Paiement'
            },
            state: {
                c__numeroVoie: this.listrecord[this.index].numeroVoie.toString(),
                c__libelleVoie: this.listrecord[this.index].libelleVoie.toString(),
                c__complementAdresse: this.listrecord[this.index].complementAdresse.toString(),
                c__codePostal: this.listrecord[this.index].codePostal.toString(),
                c__NoCompteContrat: this.listrecord[this.index].NoCompteContrat.toString(),
                c__ville: this.listrecord[this.index].ville.toString(),
                c__recordId: this.recordid
            }
        });
    }*/
    urlec = 'https://page.tobe.found';
    navigateToEC() {
        console.log("navigate to coords, urlec: ", this.urlec);
        getURLImpersonationForContact({ contactID: this.recordId })
            .then(result => {
                console.log('got result ', result);
                this.urlec = result;
                this.error = undefined;
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: result
                    }
                });
            })
            .catch(error => {
                console.log('got error ', error);
                this.error = error;
                this.urlec = undefined;
            });
    }
    get listeEmails() {
        let emails = [];
        let email1 = getFieldValue(this.contact.data, EMAIL_FIELD);
        let email2 = getFieldValue(this.contact.data, EMAIL_FIELD2);
        let email3 = getFieldValue(this.contact.data, EMAIL_FIELD3);
        if (email1) {
            emails.push({ label: email1, value: 'Adresse Mail 1' });
        }
        if (email2) {
            emails.push({ label: email2, value: 'Adresse Mail 2' });
        }
        if (email3) {
            emails.push({ label: email3, value: 'Adresse Mail 3' });
        }
        return emails;
    }
    handleChangeEmail(event) {
        this.selectedEmailItem = event.detail.value;
        this.emailNewEspaceClient = this.selectedEmailItem === 'Adresse Mail 1' ? getFieldValue(this.contact.data, EMAIL_FIELD) : (this.selectedEmailItem === 'Adresse Mail 2' ? getFieldValue(this.contact.data, EMAIL_FIELD2) : getFieldValue(this.contact.data, EMAIL_FIELD3));
        this.isNewEmail = (this.selectedEmailItem !== getFieldValue(this.contact.data, EMAILPR_FIELD_ITEM)) ? true : false;
    }
    ouvrirCreationEspaceClient() {
        this.creerEspaceClientModel = true
    }
     validateEmail(email) {
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
      }
    creerEspaceClient(event) {
        console.log("email value"+this.emailNewEspaceClient);
        //if email is empty
        if(!this.emailNewEspaceClient){
            this.emailNewEspaceClient = getFieldValue(this.contact.data, EMAILPR_FIELD_ITEM) === 'Adresse Mail 1' ? getFieldValue(this.contact.data, EMAIL_FIELD) : (getFieldValue(this.contact.data, EMAILPR_FIELD_ITEM) === 'Adresse Mail 2' ? getFieldValue(this.contact.data, EMAIL_FIELD2) : getFieldValue(this.contact.data, EMAIL_FIELD3));
        }
        //validation picklist mail        
        if(!this.emailNewEspaceClient){
        if(this.isThereAnEmail){
            console.log("EmailPicklist1");
            let inputCmp = this.template.querySelector(".EmailPicklist");
            inputCmp.setCustomValidity("Veuillez compléter ce champ.");   
            inputCmp.reportValidity();  
            return ;  
        }else{
            console.log("EmailPicklist2");
            let inputCmp = this.template.querySelector(".EmailInput");
            inputCmp.setCustomValidity("Veuillez compléter ce champ.");   
            inputCmp.reportValidity();  
            return ;  
        }    
        }else{           
            if(!this.validateEmail(this.emailNewEspaceClient)){
                console.log("validation"+this.isThereAnEmail);
                if(this.isThereAnEmail){
                    console.log("EmailPicklist");
                    let inputCmp = this.template.querySelector(".EmailPicklist");
                    inputCmp.setCustomValidity("Format incorrect.");   
                    inputCmp.reportValidity();  
                    return ;  
                }else{
                    console.log("EmailInput");
                    let inputCmp = this.template.querySelector(".EmailInput");
                    inputCmp.setCustomValidity("Format incorrect.");   
                    inputCmp.reportValidity();  
                    return ;  
                }
            }
        }  
        console.log("email value after"+this.emailNewEspaceClient);
        //console.log('espaceClientACreer : '+espaceClientACreer);
        //ADE FT4-37
        checkActivateOKTAECService().then(result=>{           
            if(result === true){
              
                var lisApplication= [];
                lisApplication.push({
                    application: 'XDATA_DGP', 
                    referenceClient: this.idtiers
                });
                lisApplication.push({
                    application: 'SYMPHONIE_DGP', 
                    referenceClient: this.refclient_OKTA
                });

                let createEspaceClientOkta = {
                        email:this.emailNewEspaceClient,
                     login:this.emailNewEspaceClient,
                     nom:this.lastname,
                     prenom:this.firstname,
                        idBP : this.refclient_OKTA,
                        idTIER : this.idtiers,
                        referencesSI:lisApplication
                };
                console.log('createEspaceClientOkta : '+createEspaceClientOkta);
                //OKTA is active
                callIP({inputMap: createEspaceClientOkta, NameIntergation:"IP_SM_EspaceClientOKTA"})    
                .then(result => {
                    console.log('espaceClientACreer : '+result);
                    if(result.EspaceClientCree === true){
                        const evt = new ShowToastEvent({
                            title: '',
                            message: 'C\'est fait! Un email a été envoyé au client pour qu\'il active son Espace Client.',
                            variant: 'success',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    }
                    else if(result.EspaceClientExistant === true){ 
                        this.erreurPopupModel = true;
                        this.messageErreur = 'Le client possède déjà un espace client actif pour ses contrats d’énergie au sein d\'ENGIE. Il peut se connecter dès à présent à tous ses espaces client avec le même identifiant et mot de passe.';
                        this.infoTitlePopup = true;
                    }     
                    else if(result.IdTierExist === false){ 
                        this.erreurPopupModel = true;
                        this.messageErreur = 'Suite à des problèmes techniques, la création de l\'espace-client a été retardée.\n L\'email d’activation de l\'espace client sera envoyé automatiquement dans la journée.';
                        this.infoTitlePopup = true;
                    }      
                    else{
                        this.erreurPopupModel = true;
                        this.messageErreur = 'Erreur lors de la création de l\'espace client';
                        this.infoTitlePopup = true;
                    } 
                                                       
                    this.closeCreationEspaceClient();

                })
                .catch(error => {
                    this.erreurPopupModel = true;
                    console.log('Erreur lors de la création EC ', error);
                });
            }else{
                //OKTA is inactive
                creerEspaceClientService({espaceClientACreerMap : 
                    {
                        prenom : this.firstname,
                        nom : this.lastname,
                        civilite : this.salutation,
                        email : this.emailNewEspaceClient,
                        numeroBP : this.refclient
                    }
                })
                .then(result=>{
                if(result === 'OK'){
                    const evt = new ShowToastEvent({
                        title: '',
                        message: 'C\'est fait! Un email a été envoyé au client pour qu\'il active son Espace Client.',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }
                else{
                    this.erreurPopupModel = true;
                    this.messageErreur = result;
                }
                this.closeCreationEspaceClient();
                })
                .catch(error => {
                this.erreurPopupModel = true;
                console.log('Erreur lors de la création EC ', error);
                });
            }
        })
        //console.log('activer_OKTAEC'+activer_OKTAEC);

    }
    handleOpenFreeServices() {
        console.log("openfreeservices");
        setCache().then(r => {
          const eventName = "openfreeservices";
          const inputMap = {
            eDocumentStatus: this.eDocumentStatusMap.get(this.recordId),
            felStatus: this.felStatusMap.get(this.recordId),
            customerAreaUnavailable : this.isinternaute || this.becomesinternaute ? false : true,
            noEmail : this.isThereAnEmail ? false : true,
            recordId : this.recordId,
            accountContract : this.accountContractMap.get(this.recordId)
          };
          const event = new CustomEvent(eventName, {
            bubbles: true,
            composed: true,
            detail: inputMap
          });
        this.dispatchEvent(event);
        })
        .catch(error => {
            console.log("got error setCache", error);
        });
      }
    closeCreationEspaceClient() {
        this.creerEspaceClientModel = false;
        this.emailNewEspaceClient = null;
        this.isNewEmail = false;
    }
    saveMethod() {
        // Creation espace client
        this.closeCreationEspaceClient();
    }
    handleChangeNewEmail(event){
        this.emailNewEspaceClient = event.target.value;
    }
    renvoyerMailActivation(){
        //ADE FT4-106
        checkActivateOKTAECService().then(result=>{   
         //if Okta isn't active        
         if(result === false){
            renvoyerMailActivationService(
                {
                    mailActivationMap : {
                        email : this.emailprincipal,
                        numeroBP : this.refclient
                    }
                })
                .then(result=> {
                    if(result === 'OK'){
                        const evt = new ShowToastEvent({
                            title: '',
                            message: 'C’est fait ! Un email a été renvoyé au client pour qu’il active son Espace Client.',
                            variant: 'success',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    }
                    else{
                        this.erreurPopupModel = true;
                        this.messageErreur = result;
                    }
                    this.closeRenvoieCodeActivation();
                    
                })
                .catch(error => {
                    this.closeRenvoieCodeActivation();
                    this.erreurPopupModel = true;
                    this.messageErreur = 'Une erreur technique est survenue. Contactez votre administrateur.';
                    console.log('Erreur lors du renvoi de l email d activation ', error);
            });
        }
        
        
        //if okta is active
        else{
       
            callIP({inputMap:{ 
                email : this.emailprincipal,
                numeroBP : this.refclient_OKTA,
                NameIntergation:"IP_SM_RenvoyerMailECOKTA"},
                 NameIntergation:"IP_SM_RenvoyerMailECOKTA"})
                    .then(result => {
                        if(result.isSuccess === true){
                            const evt = new ShowToastEvent({
                                title: '',
                                message: 'C\'est fait! Un email a été envoyé au client pour qu\'il active son Espace Client.',
                                variant: 'success',
                                mode: 'dismissable'
                            });
                            this.dispatchEvent(evt);
                        }
                        else{
                            this.erreurPopupModel = true;
                            this.messageErreur = 'Erreur lors de l\'envoi du mail d\'activation.';
                            this.infoTitlePopup = true;
                        }                                      
                        this.closeRenvoieCodeActivation();
     
                    })
                    .catch(error => {
                        this.erreurPopupModel = true;
                        console.log('Erreur lors de la création EC ', error);
                    }); 
        }
        })
    }
    ouvrirRenvoieCodeActivation() {
        this.renvoyerCodeActivationModel = true
    }
    closeRenvoieCodeActivation() {
        this.renvoyerCodeActivationModel = false;
    }
    closeErreurPopup(){
        this.erreurPopupModel = false;
        this.infoTitlePopup=false;
        this.messageErreur = '';
    }


}