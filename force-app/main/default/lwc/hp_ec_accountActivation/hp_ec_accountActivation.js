import { LightningElement, api } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_accountActivation extends LightningElement {

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