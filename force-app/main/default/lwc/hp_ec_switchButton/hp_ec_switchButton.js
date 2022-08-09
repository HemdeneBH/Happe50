import { LightningElement, api, track } from 'lwc';

export default class Hp_ec_switchButton extends LightningElement {
    @api options;
    @api name;

    get stringifiedOptions () {
        return JSON.stringify(this.options)
    }
    handlechange (event) {
        const changeEvent = new CustomEvent("switchchange", {
            detail: event.target.value,
            bubbles: true, 
            composed: true
        });
        this.dispatchEvent(changeEvent);
    }
}