/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, track, api } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
//import portalCustomLogin from '@salesforce/apex/Hp_ec_portalLoginController.customPortalLogin';

export default class Hp_ec_customRegister extends LightningElement {
    @track  login;
    @track pwd;

    communityLogin() {
        customPortalResgister({username : this.login, password : this.pwd})

        .then(result => {
            location.href = result;
        }).catch(error => {
            this.error = error;
        })
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