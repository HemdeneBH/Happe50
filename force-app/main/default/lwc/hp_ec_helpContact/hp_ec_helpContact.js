/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, api} from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_helpContact extends LightningElement {
    @api buttonLabel;

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