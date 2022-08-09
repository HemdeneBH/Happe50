import { LightningElement, api } from "lwc";
import omniscriptTextarea from "vlocity_cmt/omniscriptTextarea";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from "./os_setInteractionDetailsHeight.html";

export default class Os_setInteractionDetailsHeight extends OmniscriptBaseMixin(omniscriptTextarea) {

    render() {
        return template;
    }

}