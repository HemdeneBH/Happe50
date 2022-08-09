/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api } from 'lwc';
import HP_EC_black_logo from '@salesforce/resourceUrl/HP_EC_black_logo';

export default class Hp_ec_renouvelerMotDePasse extends LightningElement {

    blackLogo = HP_EC_black_logo;
    @api titreRenouvelerMotDePasse;
    @api placeHolderInputEmail;
    @api labelInputEmail;
    @api messageErreurInputEmail;
    @api messageConfirmation;
    @api labelInputIdentite;
    @api labelInputMDP;
    @api labelInputConfirmationMDP;
    @api placeHolderInputIdentite;
    @api placeHolderInputMDP;
}