/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, api, wire, track } from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';

import HP_EC_icon_modify from '@salesforce/resourceUrl/HP_EC_icon_modify'

export default class Hp_ec_popinCotitulaire extends LightningElement {
   

    iconAlert = HP_EC_icon_alert;
    iconClose = HP_EC_close_icon_light;
    iconModify = HP_EC_icon_modify;




    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }
   

    showAddCotitulaire() {
        if(this.addCotitulaire){
            this.addCotitulaire = false;
        }else{
            this.addCotitulaire = true;
        }
    }

    showModifyCotitulaire() {
        if(this.modifyCotitulaire){
            this.modifyCotitulaire = false;
        }else{
            this.modifyCotitulaire = true;
        }
    }
    showDeleteCotitulaire() {
        if(this.deleteCotitulaire){
            this.deleteCotitulaire = false;
        }else{
            this.deleteCotitulaire = true;
        }
    }
    closePopinCotitulaire(event){
        this.dispatchEvent(new CustomEvent('openpopincotitulaire', { detail: false}));
    }

   
    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }
}