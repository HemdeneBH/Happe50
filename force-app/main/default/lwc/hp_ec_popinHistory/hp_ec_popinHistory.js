import { LightningElement, api, wire, track } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import HP_EC_icon_file from '@salesforce/resourceUrl/HP_EC_icon_file';
import HP_EC_icon_download from '@salesforce/resourceUrl/HP_EC_icon_download';
import HP_EC_icon_euro from '@salesforce/resourceUrl/HP_EC_icon_euro'; // @todo: Replace with € symbol

export default class Hp_ec_popinHistory extends LightningElement {
    @api titleText
    @api popinBoutton
    @api contenuToolTip;
    @api urlHelp;
     //data
     @api invoices 
     @api payments 
     @api schedules 
     @api clearancePlans
     @api showInvoices 
     @api showPayments 
     @api showSchedules 
     @api showClearancePlans 
     @api containPlansApurement
     @api modePaiementIsAnuel 
     @api downloadUrl

    iconClose = HP_EC_close_icon_light;
    styleIconFile = "-webkit-mask-image: url(" + HP_EC_icon_file + ");";
    styleIconDownload = "-webkit-mask-image: url(" + HP_EC_icon_download + ");";
    styleIconEuro = "-webkit-mask-image: url(" + HP_EC_icon_euro + ");";
    
    handleShowInvoices(event) {
        event.preventDefault();
        this.showInvoices = true;
        this.showPayments = false;
        this.showSchedules = false;
        this.showClearancePlans = false;
    }

    handleShowPayments(event) {
        event.preventDefault();
        this.showInvoices = false;
        this.showPayments = true;
        this.showSchedules = false;
        this.showClearancePlans = false;
    }

    handleShowSchedules(event) {
        event.preventDefault();
        this.showInvoices = false;
        this.showPayments = false;
        this.showSchedules = true;
        this.showClearancePlans = false;
    }

    handleShowClearancePlans(event) {
        event.preventDefault();
        this.showInvoices = false;
        this.showPayments = false;
        this.showSchedules = false;
        this.showClearancePlans = true;
    }

    handleSelectChange(event) {
        switch (event.target.value) {
            case 'invoices':
                this.handleShowInvoices(event);
            break;
            case 'payments':
                this.handleShowPayments(event);
            break;
            case 'schedules':
                this.handleShowSchedules(event);
            break;
            case 'clearance-plans':
                this.handleShowClearancePlans(event);
            break;
        }
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

    closePopin (event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('closepopin', {
            detail: true,
            bubbles: true,
            composed: true
        }));
    }

    contactPopin (event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('openpopin', {
            detail: { popinID : 'contact' },
            bubbles: true,
            composed: true
        }));
    }

    handleContactClick (event) {
        // event.preventDefault();
        // this.dispatchEvent(new CustomEvent('openpopin', {
        //     detail: { popinID : 'contact' },
        //     bubbles: true,
        //     composed: true
        // }));
    
        window.open(this.urlHelp);
    }
}