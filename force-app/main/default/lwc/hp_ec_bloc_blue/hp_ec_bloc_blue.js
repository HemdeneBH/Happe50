/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 08-01-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { LightningElement, api, track } from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_confirm from '@salesforce/resourceUrl/HP_EC_icon_confirm';
import HP_EC_icon_lamp from '@salesforce/resourceUrl/HP_EC_icon_lamp';

export default class Hp_ec_bloc_blue extends LightningElement {
    iconConfirm = HP_EC_icon_confirm;
    iconLamp = HP_EC_icon_lamp;

    @api confirmationdate;
    @api textBlocBleue;
    @api showIconLampBlocBleue;
    @api showIconConfirmBlocBleue;
  
}