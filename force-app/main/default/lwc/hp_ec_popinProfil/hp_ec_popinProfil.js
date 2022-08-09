/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-31-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, wire, track } from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import { NavigationMixin } from 'lightning/navigation';

import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import basePath from "@salesforce/community/basePath";
import HP_EC_icon_modify from '@salesforce/resourceUrl/HP_EC_icon_modify'

export default class Hp_ec_popinProfil extends NavigationMixin(LightningElement) {
   

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }
   

    closePopinProfil(event){
        this.dispatchEvent(new CustomEvent('openpopinprofil', { detail: false}));
    }

   
    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    get logoutLink() {
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        return sitePrefix + "/secur/logout.jsp";
    }

    handleNavigateToProfil(event){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Profil__c'
            },
        });
        this.dispatchEvent(new CustomEvent('openpopinprofil', { detail: false}));
    }
}