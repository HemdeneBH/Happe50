import { LightningElement, api } from "lwc";
import omniscriptCheckbox from "vlocity_cmt/omniscriptCheckbox";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from "./os_toggleCheckboxOverride.html";
    
export default class Os_toggleCheckboxOverride extends OmniscriptBaseMixin(omniscriptCheckbox){

    toggleCheckBoxFn(event){
       this.applyCallResp(event.target.checked);
    }

    render() {
        return template;
    }

}