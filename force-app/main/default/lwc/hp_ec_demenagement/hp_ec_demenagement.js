/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-06-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { api, LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from "lightning/navigation";
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';
import USER_ID from '@salesforce/user/Id';
import CONTACT_ID from '@salesforce/schema/User.ContactId';
import CONTACT_SALUTATION from '@salesforce/schema/Contact.Salutation';
import CONTACT_FIRSTNAME from '@salesforce/schema/Contact.FirstName';
import CONTACT_LASTNAME from '@salesforce/schema/Contact.LastName';
import CONTACT_EMAIL from '@salesforce/schema/Contact.Email';
import CONTACT_PHONE from '@salesforce/schema/Contact.Phone';

export default class Hp_ec_demenagement extends NavigationMixin(LightningElement) {

    @api title;
    @api subtitle;
    @api leftStepNumber;
    @api leftStepTitle;
    @api leftStepText;
    @api centerStepNumber;
    @api centerStepTitle;
    @api centerStepText;
    @api rightStepNumber;
    @api rightStepTitle;
    @api rightStepText;
    user;
    @track contactId;
    salutation;
    firstName;
    lastName;
    email;
    phone;

    @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID] })
    wiredBody({ error, data }) {
        if (data) {
            this.user = data;
            console.log('User : ', this.user);
            this.contactId = this.user.fields.ContactId.value;
            console.log('ContactId', this.user.fields.ContactId.value);
        } else if(error) {
            console.log('error', error)
        }
    }

    @wire(getRecord, { recordId: '$contactId', fields: [CONTACT_SALUTATION,CONTACT_FIRSTNAME,CONTACT_LASTNAME,CONTACT_EMAIL,CONTACT_PHONE] })
    wiredContact({ error, data }) {
        if (data) {
            console.log('data', data);
            this.salutation = data.fields.Salutation.value;
            this.firstName = data.fields.FirstName.value;
            this.lastName = data.fields.LastName.value;
            this.email = data.fields.Email.value;
            this.phone = data.fields.Phone.value;
        } else if(error) {
            console.log('error', error)
        }
    }
    /**
     * TODO : retrieve the params of the url
     */
    handleSouscrirePourMonNouveauLogement() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: 'https://www.happ-e.fr/souscription?client_happe=1&switch_type=EM&civilite=CIVILITE&lastname=NOM&firstname=PRENOM&email=EMAIL&phone=TELEPHONE&paiement=TYPEPAIEMENT&facturation=FREQUENCEPAIEMENT&EC=1'
            }
        };
        this[NavigationMixin.Navigate](config);
    }

    handleNavigateToPreviousPage() {
        window.history.back();
    }

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    @api switchStyle(styleName) {
      switchTheme.call(this, styleName);
  }
  
}