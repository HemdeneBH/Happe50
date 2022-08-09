/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-02-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api } from 'lwc';
import HP_EC_black_logo from '@salesforce/resourceUrl/HP_EC_black_logo';
import HP_EC_purple_close_icon from '@salesforce/resourceUrl/HP_EC_purple_close_icon';
import HP_EC_googleplay from '@salesforce/resourceUrl/HP_EC_googleplay';
import HP_EC_appStore from '@salesforce/resourceUrl/HP_EC_appStore';
import HP_EC_app_logo from '@salesforce/resourceUrl/HP_EC_app_logo'


export default class Hp_ec_popinApp extends LightningElement {

    @api liengoogleplay;
    @api lienappstore;

    blackLogo = HP_EC_black_logo;
    closeIcon = HP_EC_purple_close_icon;
    googleplay = HP_EC_googleplay;
    logoApp = HP_EC_app_logo;
 
    appStore = HP_EC_appStore;

    closePopinApp(event){
        this.dispatchEvent(new CustomEvent('closepopinapp', { detail: true}));
    }
    closePopin(event){
        this.dispatchEvent(new CustomEvent('closepopinapp', { detail: true}));
    }

}