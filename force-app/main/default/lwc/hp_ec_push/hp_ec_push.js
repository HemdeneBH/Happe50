/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, api, track } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import HP_EC_img_push from '@salesforce/resourceUrl/HP_EC_img_push';
import HP_EC_icon_flagtag from '@salesforce/resourceUrl/HP_EC_icon_flagtag';


export default class Hp_ec_push extends LightningElement {
    

    imgPush = HP_EC_img_push;
    flagTag = HP_EC_icon_flagtag;

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