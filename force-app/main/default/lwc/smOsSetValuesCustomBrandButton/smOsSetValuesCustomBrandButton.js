import OmniscriptSetValues from "vlocity_cmt/omniscriptSetValues";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from "./smOsSetValuesCustomBrandButton.html";

export default class SmOsSetValuesCustomBrandButton extends OmniscriptBaseMixin(OmniscriptSetValues) {
    _isBtn = true;
    variant = 'brand';
    iconName;
    
    //FT2-1404 Payeur Divergent - Modification du rôle du payeur divergent (Relance - Facture)
    execute(){
        super.execute();
        if(this.jsonDef.propSetMap.label === 'Sauvegarder')
        {
            console.log('sinside sauvegarder');
            this.omniApplyCallResp({ "callMajCCForUpdate": true });
        }
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