/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, track, api, wire} from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/HP_EC_variables';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';


export default class Hp_ec_footer_bg extends LightningElement {


    connectedCallback() {
        loadStyle(this, styles);
    }

    @api    copyrightMention;
    @api    contentLegals;
    @api    socialNetworks;
    @api    theme;

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