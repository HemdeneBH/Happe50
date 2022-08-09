/**
 * @description       : 
 * @author            : Dhivya Rollin
 * @group             : 
 * @last modified on  : 05-06-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, track, api, wire} from 'lwc';
import {switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';
import {  NavigationMixin } from 'lightning/navigation';

export default class Hp_ec_blocDemenagement extends NavigationMixin(LightningElement) {

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

    handleClick(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Demenagement__c'
            },
        });
    }

}