import { LightningElement } from 'lwc';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';

export default class Hp_ec_popinChat extends LightningElement {
    titleText = 'Chat';
    iconClose = HP_EC_close_icon_light;

    closePopin (event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('closepopin', {
            detail: true,
            bubbles: true,
            composed: true
        }));
    }
}