import { LightningElement, api } from 'lwc';
import HP_EC_icon_tooltip from '@salesforce/resourceUrl/HP_EC_icon_tooltip'

export default class Hp_ec_tooltip extends LightningElement {
    @api content;
    iconTooltipStyle = "-webkit-mask-image: url(" + HP_EC_icon_tooltip +")";
}