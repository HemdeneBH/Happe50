/**
 * @description       : 
 * @author            : Dhivya ROLLIN
 * @group             : 
 * @last modified on  : 04-29-2022
 * @last modified by  : Dhivya ROLLIN
**/
import { api, LightningElement } from 'lwc';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_download from '@salesforce/resourceUrl/HP_EC_icon_download';

export default class Hp_ec_historiqueDesFactures extends LightningElement {
    @api title;
    
    iconDownload = HP_EC_icon_download ;
    
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