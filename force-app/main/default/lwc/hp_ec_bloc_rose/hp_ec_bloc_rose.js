/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 08-01-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { LightningElement, api, track } from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_lamp from '@salesforce/resourceUrl/HP_EC_icon_lamp';
import HP_EC_icon_confirm from '@salesforce/resourceUrl/HP_EC_icon_confirm';

export default class Hp_ec_bloc_rose extends LightningElement {
    iconLamp = HP_EC_icon_lamp;
    iconConfirm = HP_EC_icon_confirm;

    @track showRelevePopin = false;

    @api idclient;
    @api isperiodeargaz;
    @api isperiodearelec;
    @api contractgaz;
    @api contractelec;
    @api typecomptage;
    @api pdl;
    @api pce;
    @api lastestindexelec;
    @api lastestindexhpelec;
    @api latestindexgaz;

    @api textBlocRose;
    @api showIconLampBlocRose;
    @api showIconConfirmBlocRose;

    @api titlePopinReleve;
    @api messageIndexError;
    @api messageIndexNoValidError;
    @api customUrlPopinReleve;
    @api customUrlLabelPopinReleve;
    
    openRelevePopin(event){
        this.showRelevePopin = true;
    }

    closeRelevePopin(event){
        if(event.detail === true){
            this.showRelevePopin = true;
        }else if(event.detail === false){
            this.showRelevePopin = false;
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

    hanldeEnvoieIndexEvent(event) {
        // console.log('event.detail in hp_ec_bloc_rose : '+ event.detail);
        const envoieIndexEvent = new CustomEvent("envoieindexevent", {
            detail: event.detail
        });
        this.dispatchEvent(envoieIndexEvent);
    }
}