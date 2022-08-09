/** 
 * @description       : Override of the OmniScript IP Action element that lets the configuration define a variant and an icon
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 11-04-2020
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   11-04-2020   Patrick THAI     Initial Version
**/
import omniscriptIpAction from "vlocity_cmt/omniscriptIpAction";
import template from "./smOsIpActionCustomIconVariant.html";

export default class SmOsIpActionCustomIconVariant extends omniscriptIpAction {
    
    variant = 'default';
    iconName;
    containerdivclass = "slds-is-relative slds-p-top_xx-small ";
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Retrieve parameters that are contained in the lwcInput from the property set of this 
    // OmniScript element
    //
    getLwcInput() {
        if(this.jsonDef.propSetMap.lwcInput) {
            this.variant  = this.jsonDef.propSetMap.lwcInput.variant  || 'brand';
            this.iconName = this.jsonDef.propSetMap.lwcInput.iconName;
            this.extraclass = this.jsonDef.propSetMap.lwcInput.extraclass;
            this.containerdivclass += this.jsonDef.propSetMap.lwcInput.containerdivextraclass;
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Behavior methods
    //
    //
    connectedCallback() {
        super.connectedCallback();
        this.getLwcInput();
    }

    render() {
        return template;
    }  
}