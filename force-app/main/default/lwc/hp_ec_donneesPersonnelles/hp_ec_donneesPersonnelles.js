/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-27-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';

export default class Hp_ec_donneesPersonnelles extends NavigationMixin(LightningElement) {

    @api titre;
    @api consentementLabel;
    @api donneesCollectesLabel;
    @api charteLabel;
    @api charteURL;
    @api popinDonneesCollecteesTitle;
    @api popinDonneesCollecteesTexteExplicatif;
    @api popinDonneesCollecteesMessageErreur;
    @api popinDonneesCollecteesLibelleBouton;
    @api popinConsentementsLibelleBouton;
    @api popinConsentementsTitle;
    @track idClient;
    @track contact;
    @track recordId;

    @track showConsentementsPopup = false;
    @track showDonneesCollectesPopup = false;

    @wire(getContactData)
    wiredContact({ error, data }) {
        if (data) {
             this.contact = JSON.parse(data);
             this.idClient = this.contact.ID_Tiers__c;
             this.recordId = this.contact.Id;
        }else if(error){
            console.log('*** Error getContactData : '+JSON.stringify(error));
        }
    }

    showPopinConsentements(event){
        this.showConsentementsPopup = true;
        
    }

    showPopinDonneesCollectees(event){
        this.showDonneesCollectesPopup = true;
        
    }

    openPopinConsentements(event){
        if(event.detail === true){
            this.showConsentementsPopup = true;
        }else {
            this.showConsentementsPopup = false;
        }
    }

    openPopinDonneesCollectees(event){
        if(event.detail === true){
            this.showDonneesCollectesPopup = true;
        }else {
            this.showDonneesCollectesPopup = false;
        }
    }

    closePopinConsentements(event){
        this.dispatchEvent(new CustomEvent('openpopinconsentements', { detail: false}));
    }

    openCharteURL(){
        window.open(this.charteURL, "_blank");
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