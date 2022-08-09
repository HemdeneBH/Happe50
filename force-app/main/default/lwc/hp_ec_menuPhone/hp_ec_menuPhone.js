/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-07-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, track, api, wire} from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_menuPhone extends LightningElement {
    @api phonenumber;

    get phoneNumberLink(){
        return 'tel:+33'+this.phonenumber;
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