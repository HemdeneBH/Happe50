/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 03-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {loadScript } from 'lightning/platformResourceLoader';
import jsStyle from "@salesforce/resourceUrl/HP_EC_StyleManager";

export default class Hp_ec_donnesPersonnelles extends NavigationMixin(LightningElement) {

    @api titre;
    @api consentementLabel;
    @api donnesCollecteesLabel;
    @api charteLabel;
    @api charteURL;

    @track showConsentementsPopup = false;
    @track showDonneesCollecteesPopup = false;

    showPopinConsentements(event){
        this.showConsentementsPopup = true;
        
    }

    showPopinDonneesCollectees(event){
        this.showDonneesCollecteesPopup = true;
        
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
            this.showDonneesCollecteesPopup = true;
        }else {
            this.showDonneesCollecteesPopup = false;
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
        loadScript(this, jsStyle)
        .then(() => {
            
            // this.switchStyle = portalLib.switchStyle;
            // this.loadUserTheme = portalLib.loadUserTheme;
            this.loadUserTheme();
        })
        .catch((error) => {
            console.log('error -> ' + error);
        });
        this.hasRenderedOnce = true;
    }
}