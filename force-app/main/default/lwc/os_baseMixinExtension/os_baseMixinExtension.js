import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";

export default class Os_baseMixinExtension extends OmniscriptBaseMixin(LightningElement) {

    @api 
    omniApplyCallRespApi(obj){
        this.omniApplyCallResp(obj);
    }

    @api 
    omniUpdateDataJsonApi(obj){
        this.omniUpdateDataJson(obj);
    }

    @api
    omniSaveStateApi(obj){
        this.omniSaveState(obj);
    }

    @api
    omniGetSaveStateApi(obj){
        this.omniGetSaveState(obj);
    }

}