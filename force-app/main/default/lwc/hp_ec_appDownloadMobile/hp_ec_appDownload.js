/**
 * @description       : 
 * @author            : Dhivya Rollin
 * @group             : 
 * @last modified on  : 03-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, track, api, wire} from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import HP_EC_app_logo from '@salesforce/resourceUrl/HP_EC_app_logo'

export default class Hp_ec_appDownload extends LightningElement {
    @api lienAppMobile
    logoApp = HP_EC_app_logo;

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        // const lib = new portalLib();
        // this.switchStyle = lib.switchStyle;
        // this.loadUserTheme = lib.loadUserTheme;
        this.loadUserTheme();
        this.hasRenderedOnce = true;
    }

}