import { api, LightningElement } from 'lwc';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';

export default class Hp_ec_popinPayments extends LightningElement {
    titleText = "Mes modes de paiement";
    iconClose = HP_EC_close_icon_light;

    @api echeanceid;
    @api amount;
    @api contact;
    @api titleText;
    @api isEtatInactif;

    @api idPortefeuilleContrat;
    // @api amount;
    // @api echeanceid;

    // Champs contribuables pour hp_ec_paymentModes : START //
    @api titreV1;
    @api titreV2;

    @api labelMoyenPaiement1;
    @api labelMoyenPaiement2;
    @api labelMoyenPaiement3;
    @api labelMoyenPaiement4;
    @api labelMoyenPaiement5;

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

    closePopin (event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('closepopin', { detail: true}));
    }
}