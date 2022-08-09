/**
 * @description       : 
 * @author            : Dhivya Rollin
 * @group             : 
 * @last modified on  : 06-16-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, track, api, wire} from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import { NavigationMixin } from 'lightning/navigation';
import HP_EC_app_logo from '@salesforce/resourceUrl/HP_EC_app_logo'

export default class Hp_ec_appDownload extends NavigationMixin(LightningElement){
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

  openAppDownloadPage() {
    this[NavigationMixin.GenerateUrl]({
        type: 'comm__namedPage',
         attributes: {
             name:  'Telecharger_Application__c'
            }
        }).then(url => {
            window.open(url, "_blank");
        });
    }
}