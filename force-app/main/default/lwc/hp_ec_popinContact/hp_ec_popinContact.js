import { LightningElement, api } from 'lwc';
import {switchTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import HP_EC_mail from '@salesforce/resourceUrl/HP_EC_mail';
import HP_EC_icon_chat_black from '@salesforce/resourceUrl/HP_EC_icon_chat_black';

import getMessages from './messages'; // fake data

export default class Hp_ec_popinContact extends LightningElement {
    titleText = 'Aide et contact';

    messages = getMessages(); // fake data

    iconClose = HP_EC_close_icon_light;
    iconMail = HP_EC_mail;

    styleIconChat = "-webkit-mask-image: url(" + HP_EC_icon_chat_black + ");";

    closePopin () {
        this.dispatchEvent(new CustomEvent('closepopin', {
            detail: true,
            bubbles: true,
            composed: true
        }));
    }

    handleMessageClick(event){
        event.preventDefault();
        if (event.target && event.target.dataset && event.target.dataset.id) {
            this.dispatchEvent(new CustomEvent('openpopin', {
                detail: {
                    popinID: 'messages',
                    messageID: event.target.dataset.id
                },
                bubbles: true,
                composed: true
            }));
        } else {
            this.dispatchEvent(new CustomEvent('openpopin', {
                detail: { popinID: 'messages' },
                bubbles: true,
                composed: true
            }));
        }
        return false;
    }

    handleChatClick(event){
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('openpopin', {
            detail: { popinID: 'chat' },
            bubbles: true,
            composed: true
        }));
        return false;
    }

    renderedCallback() {}

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }
}