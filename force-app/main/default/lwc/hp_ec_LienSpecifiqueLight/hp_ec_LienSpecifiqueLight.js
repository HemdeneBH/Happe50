/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 05-26-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { api, LightningElement } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_LienSpecifiqueLight extends NavigationMixin(LightningElement) {
    
    @api titre;
    @api lienSpecifique;

    handleNavigationToLienSpecifique() {
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: this.lienSpecifique
            }
        };
        this[NavigationMixin.Navigate](config);
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