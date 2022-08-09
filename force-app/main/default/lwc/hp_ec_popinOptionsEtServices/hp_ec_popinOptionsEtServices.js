/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-12-2022
 * @last modified by  : Hemdene Ben Hammouda
**/

import { LightningElement, api, track, wire } from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import updateEnergieVert from '@salesforce/apex/HP_EC_UpdateCustomerData.updateEnergieVert';

export default class Hp_ec_popinOptionsEtServices extends LightningElement {

    iconAlert = HP_EC_icon_alert;
    iconClose = HP_EC_close_icon_light;

    @api option;
    @api texteintroductifpopin;
    @api titrepopin;
    @api textexplicatifpopin;
    @api textealertepopin;
    @api labelbouttonpopin;
    @api etat;
    @api contractid;
    @track spinnerLoad = false;
    
    closePopinFacture(event){
        this.dispatchEvent(new CustomEvent('openpopinoptions', { detail: false}));
    }

    handleClick(event){
        this.spinnerLoad = true;
        if(this.option == 'optionVertElec'){
            updateEnergieVert({
                contractId: JSON.stringify(this.contractid) , energieVert : this.etat == 'Actif' ? '0' : '1'
            }).then(result => {
                console.log('*** Result Update Energie Vert: ' + JSON.stringify(result));
                this.spinnerLoad = false;
                this.dispatchEvent(new CustomEvent('openpopinoptions', { detail: false}));
            }).catch(error => {
                console.log('*** Update Energie Vert: ' + JSON.stringify(error));
                this.spinnerLoad = false;
                this.dispatchEvent(new CustomEvent('openpopinoptions', { detail: false}));
            });
            
        }
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