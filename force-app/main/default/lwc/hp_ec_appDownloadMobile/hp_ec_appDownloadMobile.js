/**
 * @description       : 
 * @author            : Dhivya Rollin
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, track, api, wire} from 'lwc';

import HP_EC_app_logo from '@salesforce/resourceUrl/HP_EC_app_logo'

import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_appDownloadMobile extends LightningElement {
    @api lienAppMobile
    logoApp = HP_EC_app_logo;


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