import { api, LightningElement } from 'lwc';
import template from "./sM_BoutonCreerPayeur.html";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';


export default class sm_os_CreerPayeurDivergent extends OmniscriptBaseMixin(LightningElement){
    @api isPayeurDiv =false;
    _isBtn = true;
    render() {
        //super.render();
        return template;
    }

  
    execute(){
        this.omniApplyCallResp({"isPayeurDiv": true});
        this.omniNextStep();
    }
}