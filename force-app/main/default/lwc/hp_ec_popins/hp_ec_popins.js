import { LightningElement, api } from 'lwc';

export default class Hp_ec_popins extends LightningElement {
    showChat = false;
    showContact = false;
    showHistory = false;
    showMessages = false;

    openedMessage = null;

    @api
    openPopin(event) {
        this.closePopin();
        if (event && event.detail && event.detail.popinID) {
            console.log('open popin', event.detail.popinID)
            switch (event.detail.popinID) {
                case 'chat':
                    this.showChat = true;
                break;
                case 'contact':
                    this.showContact = true;
                break;
                case 'history':
                    this.showHistory = true;
                break;
                case 'messages':
                    this.showMessages = true;
                    if (event.detail.messageID) {
                        this.openedMessage = event.detail.messageID;
                    }
                break;
            }
        }
    }

    @api
    closePopin() {
        this.showChat = false;
        this.showContact = false;
        this.showHistory = false;
        this.showMessages = false;
    }
}