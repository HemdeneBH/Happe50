/** 
 * @description       : Override of the OmniScript set values element that lets the configuration define a variant and an icon
 * @author            : Khady DIEME
 * @group             : 
 * @last modified on  : 12-11-2021
 * @last modified by  : Khady DIEME
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   12-11-2021   Khady DIEME     Initial Version
**/

import OmniscriptSetValues from "vlocity_cmt/omniscriptSetValues";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from "./smOsSetValuesCustomIconVariant.html";


export default class SmOsSetValuesButton extends OmniscriptBaseMixin(OmniscriptSetValues) {
    _isBtn = true;
    variant = 'neutral';
    iconName;
    
    execute(){
        super.execute();
        this.omniNextStep();
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Retrieve parameters that are contained in the lwcInput from the property set of this 
    // OmniScript element
    //
    getLwcInput() {
        if(this.jsonDef.propSetMap.lwcInput) {
            this.variant  = this.jsonDef.propSetMap.lwcInput.variant  || 'neutral';
            this.iconName = this.jsonDef.propSetMap.lwcInput.iconName;
        }
    }

   
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Behavior methods
   
    connectedCallback() {
        super.connectedCallback();
        this.getLwcInput();
    }

    render() {
        return template;
    }  
}