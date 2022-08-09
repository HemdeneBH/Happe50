import { LightningElement, api } from 'lwc';
import omniscriptSelect from "vlocity_cmt/omniscriptSelect";
import template from "./os_resettingRequiredSelect.html";

export default class Os_resettingRequiredSelect extends omniscriptSelect {

    jsonDataCopy;
    firstRendered = false; 

    //override the omniscriptSelect getOptions behavior
    getOptions(i) {
        super.getOptions(i);
        // workaround so that a SetValue presets the picklist value and have the jsonData updated
        // applies when there is one ('-- Clear --') or no options available.
        this._forceJsonToApply = (this._realtimeOptions.length < 2);
    }

    renderedCallback() {
        super.renderedCallback();
        console.log('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
        if (!this.firstRendered) {
            let jsonPath = this.jsonDef.name;
            let vlocBaseMixin = this.template.querySelector('c-os_base-mixin-extension');
            //loadedResetSelect is undefined when first run of OS, and set to null when saved for later then resumed
            if (this.jsonData.loadedResetSelect === null || typeof this.jsonData.loadedResetSelect === 'undefined' || !this.jsonData.loadedResetSelect[jsonPath]) {
                //clear the picklist
                this.elementValue = null;
                //prevent code execution multiple times in the same step (especially when LWC is disconnected)
                this.firstRendered = true
                //prevent code execution  when navigating through different steps
                let newState = { 'loadedResetSelect' : {}};
                newState.loadedResetSelect[jsonPath] = true;
                vlocBaseMixin.omniApplyCallRespApi(newState);
            }
        } 
    }

    render() {
        return template;
    }

}