/** 
 * @description       : Override of the OmniScript Select element that copies its valeur to another node when this one is updated
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 03-01-2022
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-01-2022   Patrick THAI     Initial Version
**/

import omniscriptSelect from "vlocity_cmt/omniscriptSelect";
import { dispatchOmniEvent } from 'vlocity_cmt/omniscriptUtils';


export default class smOsSelectCloneValue extends omniscriptSelect {

    ////////////////////////////////////////////////////////////////////////////////////////////
    // Input parameters the LWC override. In the OS, "Edit as JSON" the element and add a 
    // "lwcInput" node to contain the following values. Actual values are retrieved during
    // getLwcInput()
    //
    updateField  = "";         // node of the jsonData to be updated by the cascade update. 
    
     ////////////////////////////////////////////////////////////////////////////////////////////
    // Retrieve parameters that are contained in the lwcInput from the property set of this 
    // OmniScript element
    //
    getLwcInput() {
        this.updateField       = this.jsonDef.propSetMap.lwcInput.updateField;
    }

 
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Updates a node of the jsonData when this override is updated to a specific value
    // @param evt javascript event
    //
    cascadeUpdate(evt) {

        //... update the node called "this.updateField" from the jsonData with the new value of the field
        let updateJson = {};
        updateJson[this.updateField] = evt.target.value;
        //Use an event to apply changes to the JSON Data
        let eventDetail = { "apiResponse" : updateJson };
        dispatchOmniEvent(this, eventDetail, 'omniactionbtn');

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


    handleChange(evt) {
        super.handleChange(evt);
        this.cascadeUpdate(evt);
    }
 

}