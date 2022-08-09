/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 01-31-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';

export default class Hp_ec_popinResiliation extends LightningElement {

    @api popinresiliationtitle;
    @api popinresiliationmessagealerte;
    @api popinresiliationtexteexplicatif;
    @api popinresiliationbouttondemenager;
    @api popinresiliationtexte;
    @api popinresliationtexteresiliation;
    @api popinresiliationnumero;
    @api popinresiliationresilierboutton;

    iconAlert = HP_EC_icon_alert;
    iconClose = HP_EC_close_icon_light;

    closePopinResiliation(event){
        this.dispatchEvent(new CustomEvent('openpopinresiliation', { detail: false}));
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