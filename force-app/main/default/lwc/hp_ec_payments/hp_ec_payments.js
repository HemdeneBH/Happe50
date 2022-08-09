import { api, LightningElement, wire } from 'lwc';

import { publishMC, subscribeMC, unsubscribeMC } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

export default class Hp_ec_payments extends LightningElement {

    @wire(MessageContext) messageContext;

    // Champs contribuables : START //
    @api titreV1;
    @api titreV2;
    
    @api labelMoyenPaiement1;
    @api labelMoyenPaiement2;
    @api labelMoyenPaiement3;
    @api labelMoyenPaiement4;
    @api labelMoyenPaiement5;
  
    @api labelBoutonPaiement1;
    @api labelBoutonPaiement2;
    @api labelBoutonPaiement3;
    @api labelBoutonPaiement4;
    @api labelBoutonPaiement5;
  
    @api lienEnSavoirPlusPaiement1;
    @api lienEnSavoirPlusPaiement2;
    @api lienEnSavoirPlusPaiement3;
    @api lienEnSavoirPlusPaiement4;
    @api lienEnSavoirPlusPaiement5;
    
    @api showLienEnSavoirPlusPaiement1;
    @api showLienEnSavoirPlusPaiement2;
    @api showLienEnSavoirPlusPaiement3;
    @api showLienEnSavoirPlusPaiement4;
    @api showLienEnSavoirPlusPaiement5;

    @api textModePaiement;
    @api textDatePrelevementPart1;
    @api textDatePrelevementPart2;
    // Champs contribuables : END //

    paymentPopin = false;

    openPopin () {
        this.paymentPopin = true;
    }

    closePopin (event) {
        event.preventDefault();
        event.stopPropagation();
        event.stopImmediatePropagation();
        this.paymentPopin = false;
    }

    connectedCallback() {
        this.handleSubscription();
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this, this.messageContext, this.handleLightningMessage);
        }
    }

    handleLightningMessage(self, subscription, message) {
        if (message.messageType == 'SelectedPortfolio') {
            self.idPortefeuilleContrat = message.messageData.message;
        }
    }
}