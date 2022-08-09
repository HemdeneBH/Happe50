import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
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
import MOBPR_FIELD from '@salesforce/schema/Contact.MobilePrincipalValue__c';
import FIXPR_FIELD from '@salesforce/schema/Contact.TelFixePrincipalValue__c';
import INTST_FIELD from '@salesforce/schema/Contact.Statut_Internaute__c';
import REQUALIF_FIELD from '@salesforce/schema/Contact.A_requalifier__c';
import SEGMKT_FIELD from '@salesforce/schema/Contact.Segment_Marketing__c';


import NOVOIE_FIELD from '@salesforce/schema/Contact.No_Voie__c';
import MAILST_FIELD from '@salesforce/schema/Contact.MailingStreet';
import MAILCI_FIELD from '@salesforce/schema/Contact.MailingCity';
import MAILPO_FIELD from '@salesforce/schema/Contact.MailingPostalCode';
import CPLTAD_FIELD from '@salesforce/schema/Contact.Complement_adresse__c';

import getURLImpersonationForContact from '@salesforce/apex/SM_AP21_GestionImpersonation.getURLImpersonationForContact';
import creerEspaceClientService from '@salesforce/apex/SM_AP72_EspaceClientService.creerEspaceClient';
import renvoyerMailActivationService from '@salesforce/apex/SM_AP72_EspaceClientService.renvoyerMailActivation';

const FIELDS = [SALUT_FIELD, FIRSTNAME_FIELD, LASTNAME_FIELD, REFCLI_FIELD, EMAILPR_FIELD, EMAIL_FIELD, EMAIL_FIELD2, EMAIL_FIELD3, EMAILPR_FIELD_ITEM, PHONE_FIELD, MOBPR_FIELD, FIXPR_FIELD, INTST_FIELD, REQUALIF_FIELD, SEGMKT_FIELD, NOVOIE_FIELD, MAILST_FIELD, MAILCI_FIELD, MAILPO_FIELD, CPLTAD_FIELD];

export default class Contactview360 extends NavigationMixin(LightningElement) {

    label = {
        CREER,
        ANNULER,
        RENVOYER,
        OK
    }
    messageErreur;
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) contact;

    @track selectedEmailValue;
    @track selectedEmailItem;
    @track isNewEmail = false;
    @track creerEspaceClientModel = false;
    @track erreurPopupModel = false;
    @track renvoyerCodeActivationModel = false;
    @track emailNewEspaceClient;

    /* get urlLink() {return "/apex/SM_VFP_ModifInformationPerso?id=" + this.recordId;} */

    get urlLink() { return "/apex/vlocity_cmt__OmniScriptUniversalPageConsole?id={0}&OmniScriptType=Contact&OmniScriptSubType=ModifyInformations&OmniScriptLang=English&PrefillDataRaptorBundle=&scriptMode=vertical&layout=lightning&ContextId={0}"; }


    get salutation() { return getFieldValue(this.contact.data, SALUT_FIELD); }
    get firstname() { return getFieldValue(this.contact.data, FIRSTNAME_FIELD) }
    get lastname() { return getFieldValue(this.contact.data, LASTNAME_FIELD); }
    get refclient() {
        let refcl1 = getFieldValue(this.contact.data, REFCLI_FIELD);
        let refcl2 = String(refcl1);
        if (refcl2.length > 9) {
            return refcl2.substr(-9);
        }
        return refcl2;
    }
    get emailprincipal() { return getFieldValue(this.contact.data, EMAILPR_FIELD); }
    get emailprincipalitem() { return getFieldValue(this.contact.data, EMAILPR_FIELD_ITEM); }
    get email() { return getFieldValue(this.contact.data, EMAIL_FIELD); }
    get email2() { return getFieldValue(this.contact.data, EMAIL_FIELD2); }
    get email3() { return getFieldValue(this.contact.data, EMAIL_FIELD3); }
    get telfixeprincipal() { return getFieldValue(this.contact.data, FIXPR_FIELD); }
    get mobileprincipal() { return getFieldValue(this.contact.data, MOBPR_FIELD); }
    get phoneField() { return getFieldValue(this.contact.data, PHONE_FIELD); }
    get emailField() { return getFieldValue(this.contact.data, EMAIL_FIELD); }
    get arequalifier() { return getFieldValue(this.contact.data, REQUALIF_FIELD); }
    get statutinternaute() { return getFieldValue(this.contact.data, INTST_FIELD); }

    get segmentmarketing() { return getFieldValue(this.contact.data, SEGMKT_FIELD); }

    get novoie() { return getFieldValue(this.contact.data, NOVOIE_FIELD); }
    get mailingstreet() { return getFieldValue(this.contact.data, MAILST_FIELD); }
    get mailingcity() { return getFieldValue(this.contact.data, MAILCI_FIELD); }
    get mailingpostalcode() { return getFieldValue(this.contact.data, MAILPO_FIELD); }
    get complementadresse() { return getFieldValue(this.contact.data, CPLTAD_FIELD); }

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

    updateCoords() {
        const eventName = 'opencoordinates';
        const event = new CustomEvent(eventName, {
            detail: { message: 'open coord tab' }
        });
        this.dispatchEvent(event);
    }

    updateCoordsLWC(){
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_ModifyClientInfosComp'
            },
            state: {
                c__recordId: this.recordId
            }
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
    creerEspaceClient() {
        if(!this.emailNewEspaceClient){
            this.emailNewEspaceClient = getFieldValue(this.contact.data, EMAILPR_FIELD_ITEM) === 'Adresse Mail 1' ? getFieldValue(this.contact.data, EMAIL_FIELD) : (getFieldValue(this.contact.data, EMAILPR_FIELD_ITEM) === 'Adresse Mail 2' ? getFieldValue(this.contact.data, EMAIL_FIELD2) : getFieldValue(this.contact.data, EMAIL_FIELD3));
        }
        //console.log('espaceClientACreer : '+espaceClientACreer);
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

    ouvrirRenvoieCodeActivation() {
        this.renvoyerCodeActivationModel = true
    }
    closeRenvoieCodeActivation() {
        this.renvoyerCodeActivationModel = false;
    }
    closeErreurPopup(){
        this.erreurPopupModel = false;
        this.messageErreur = '';
    }

}