import { LightningElement,api} from 'lwc';

export default class Cmn_adress extends LightningElement {
    @api numerovoie;
    @api libellevoie;
    @api complementadresse;
    @api codepostal;
    @api ville;
    @api isLast;
    @api loaded;
}