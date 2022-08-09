/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 04-14-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { LightningElement, api, track } from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_confirm from '@salesforce/resourceUrl/HP_EC_icon_confirm';

export default class Hp_ec_bloc_blue extends LightningElement {
    iconConfirm = HP_EC_icon_confirm;
  
    @api confirmationdate;
  
}