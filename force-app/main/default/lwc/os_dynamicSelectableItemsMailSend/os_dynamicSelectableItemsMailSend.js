import { LightningElement, api, track } from "lwc";
import omniscriptSelect from "vlocity_cmt/omniscriptSelect";
import template from "./os_dynamicSelectableItemsMailSend.html";

export default class os_dynamicSelectableItemsMailSend extends omniscriptSelect {

    @api
    options = [];
    jsonDataCopy;

    connectedCallback() {
        super.connectedCallback();
        // this.updateOptions();
        this.elementValue = this.jsonData.emailPrincipalValue;
        // let sourceOptions = [];
        if(   typeof this.jsonData.PicklistOptions.Email !== 'undefined' 
           && this.jsonData.PicklistOptions.Email.length > 0) {
            for (const mail of this.jsonData.PicklistOptions.Email) {
                if(mail.value.length > 0) {
                    this.options.push(mail);
                }
            }
        }
    }


    render() {
        return template;
    }


    updateOptions() {
        console.log('change Select');
    }

    @api
    set jsonData(value) {
        super.jsonData = value;
        this.jsonDataCopy = value;
        if (value) {
            this.updateOptions();
        }
    }
    get jsonData() {
        return this.jsonDataCopy;
    }
}