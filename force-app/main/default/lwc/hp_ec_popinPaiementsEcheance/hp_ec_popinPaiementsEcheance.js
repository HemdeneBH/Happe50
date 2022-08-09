import { LightningElement, api, track } from 'lwc';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';

export default class Hp_ec_popinPaiementsEcheance extends LightningElement {
    iconClose = HP_EC_close_icon_light;

    @api listPaymentsTitle;
    @api textRappel;
    @api messageListPayement;
    @api boutonListPaymentLabel;
    @api listPayements;
    @api amount;
    @api showListPayement;
    @api echeanceid;
    @api isEtatInactif;
    @api contact;
    @api payementModeTitle;
    @api montantToPaye;
    @api soldToDisplay;
    @api isShow;

    closePopin (event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('closepopin', { detail: true}));
    }

}