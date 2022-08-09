import { LightningElement, api, wire, track } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_popin_historiqueFacturesPaiements extends LightningElement {

    @api popinTitle
    @api popinBoutton
    @api contractPortfolioData
    @api factures
    @api paiements 
    @api echeances 
    @api plansApurement 
    @api tab2IsActive
    @api tab1IsActive
    @api tab3IsActive
    @api tab4IsActive
    @api contractData = []
    @api contractPortfeillId
    @api tab1isShown
    @api tab2isShown 
    @api tab3isShown 
    @api tab4isShown 
    @api containPlansApurement
    @api modePaiementIsAnuel 

    handleTab1Click(event) {
      this.tab1IsActive = 'slds-tabs_default__content slds-show'
      this.tab2IsActive = 'slds-tabs_default__content slds-hide'
      this.tab3IsActive = 'slds-tabs_default__content slds-hide'
      this.tab4IsActive = 'slds-tabs_default__content slds-hide'
      this.tab1isShown = true;
      this.tab2isShown = false
      this.tab3isShown = false
      this.tab4isShown = false
  }
  handleTab2Click(event) {
      this.tab2IsActive = 'slds-tabs_default__content slds-show'
      this.tab1IsActive = 'slds-tabs_default__content slds-hide'
      this.tab3IsActive = 'slds-tabs_default__content slds-hide'
      this.tab4IsActive = 'slds-tabs_default__content slds-hide'
      this.tab2isShown = true;
      this.tab1isShown = false
      this.tab3isShown = false
      this.tab4isShown = false

  }
  handleTab3Click(event) {
      this.tab3IsActive = 'slds-tabs_default__content slds-show'
      this.tab1IsActive = 'slds-tabs_default__content slds-hide'
      this.tab2IsActive = 'slds-tabs_default__content slds-hide'
      this.tab4IsActive = 'slds-tabs_default__content slds-hide'
      this.tab3isShown = true;
      this.tab2isShown = false
      this.tab1isShown = false
      this.tab4isShown = false
  }
  handleTab4Click(event) {
      this.tab4IsActive = 'slds-tabs_default__content slds-show'
      this.tab1IsActive = 'slds-tabs_default__content slds-hide'
      this.tab3IsActive = 'slds-tabs_default__content slds-hide'
      this.tab2IsActive = 'slds-tabs_default__content slds-hide'
      this.tab4isShown = true;
      this.tab1isShown = false;
      this.tab2isShown = false
      this.tab3isShown = false
  }


    closePopinHisToriqueFacturePaiement(event) {
        this.dispatchEvent(new CustomEvent('openpopinhistoriquefacturespaiements', { detail: false }));
    }

    renderedCallback() {
      if (this.hasRenderedOnce) {
        return;
      }
      loadUserTheme.call(this);
       this.hasRenderedOnce = true;
      // this.populateContractInfo();
    }

    handleSubmit(){}

}