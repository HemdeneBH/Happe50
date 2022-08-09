import { LightningElement, api } from 'lwc';
import HP_EC_mail from '@salesforce/resourceUrl/HP_EC_mail'


export default class Hp_ec_message extends LightningElement {
    @api message;
    iconMail = HP_EC_mail;

    get messageClass () {
        var msgClass = 'message-container';

        if (!this.message.read && !this.message.sent) {
            msgClass += ' new';
        } else if (this.message.sent) {
            msgClass +=  ' sent';
        }

        if (this.message.open) {
            msgClass += ' open';
        }

        return msgClass;
    }

    toggleMessage () {
        this.dispatchEvent(new CustomEvent('togglemessage', { detail: {id: this.message.id }}));
    }

    handleNewMessage () {
        this.dispatchEvent(new CustomEvent('newmessage', { detail: {id: this.message.id }}));
    }
}