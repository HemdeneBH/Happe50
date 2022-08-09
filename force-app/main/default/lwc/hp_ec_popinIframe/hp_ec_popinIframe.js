/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, api, track } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';

export default class Hp_ec_popinIframe extends LightningElement {
    titleText = 'Mon Espace Parrain';
    @api datemensualite;
    @api montantmensuel;

    iconClose = HP_EC_close_icon_light;

    closePopin(event){
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('closepopin', { detail: true}));
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