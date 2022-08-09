/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 07-08-2022
 * @last modified by  : Hemdene Ben Hammouda
**/

import { LightningElement, track, api, wire} from 'lwc';

import HP_EC_mail from '@salesforce/resourceUrl/HP_EC_icon_mail_blue_light'
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import basePath from "@salesforce/community/basePath";
import { loadScript } from 'lightning/platformResourceLoader';

export default class Hp_ec_header extends LightningElement {

    aideContactIcon = HP_EC_mail;

    @api helpLabel;
    @api contactButtonImg;
    @api disconnectLabel;
    @api tagCommander;
    @api urlHelp;

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        if (this.tagCommander) {
            loadScript(this, this.tagCommander)
            .catch(error=>{
                console.log('Failed to load the JQuery : ' +error);
            });
        }
        
        this.hasRenderedOnce = true;
    }

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    handleContactClick (event) {
        // event.preventDefault();
        // this.dispatchEvent(new CustomEvent('openpopin', {
        //     detail: { popinID : 'contact' },
        //     bubbles: true,
        //     composed: true
        // }));

        window.open(this.urlHelp, '_blank');
    }

    get logoutLink() {
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        return sitePrefix + "/secur/logout.jsp";
    }


}