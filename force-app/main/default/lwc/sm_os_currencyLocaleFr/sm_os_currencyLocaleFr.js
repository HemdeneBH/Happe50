/** 
 * @description       : Override of the OmniScript Currency element so that the display format matches the French format (e.g. : '1000,00 €' instead of '€1,000.00')
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 29-07-2020
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   29-07-2020   Patrick THAI     Initial Version
**/

import { LightningElement } from 'lwc';
import omniscriptCurrency from "vlocity_cmt/omniscriptCurrency";

export default class Sm_os_currencyLocaleFr extends omniscriptCurrency {
 
    ////////////////////////////////////////////////////////////////////////////////////////////
    // overrides prepareIMaskProperties() from omniscriptAtomicElement (parent class for omniscriptCurrency)
    //
    prepareIMaskProperties() {
        //default values for this._maskProperties
        super.prepareIMaskProperties();
        //replaces the hard-written US decimal and thousand separators
        this._maskProperties.radix = ',';
        this._maskProperties.thousandsSeparator = '';
        //set two digits after decimal separator
        this._maskProperties.scale = 2;
        this._maskProperties.padFractionalZeros = true;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // overrides getImaskCurrencyAttributes() from omniscriptAtomicElement (parent class for omniscriptCurrency)
    //
    getImaskCurrencyAttributes() {

        // default values for ImaskCurrencyAttributes
        var retAttributes = super.getImaskCurrencyAttributes();
        //reverse the position of the currency symbol
        retAttributes.mask = "num " + this.getCurrencySymbol();   
        return retAttributes;

    }
}