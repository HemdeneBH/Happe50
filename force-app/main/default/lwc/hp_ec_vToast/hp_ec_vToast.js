import { LightningElement,api } from 'lwc';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';

export default class Hp_ec_vToast extends LightningElement {
    
    @api messageToast
    iconClose = HP_EC_close_icon_light;
    
    closePopinToast(event) {
        this.dispatchEvent(new CustomEvent('openpopintoats', { detail: false }));
    }
}