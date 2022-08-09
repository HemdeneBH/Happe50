import { LightningElement} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class SM_vlocity_tableauEnergie extends OmniscriptBaseMixin(LightningElement) {
    tab;
    consoElec;
    consoGaz;

    get isPDLPCE() {
        return this.consoElec && this.consoGaz;
    }

    get isNotPDLPCE() {
        return !this.consoElec && !this.consoGaz;
    }

    get isonlyPDL() {
        return !this.consoGaz && this.consoElec;
    }

    connectedCallback() {
        console.log('AAAAAAAAAAAAAAAAAAAA');
        this.consoElec = this.omniJsonData.contestElec;
        this.consoGaz = this.omniJsonData.contestGaz;
        console.log(this.consoElec);
        console.log(this.consoGaz);
        if(this.consoGaz && this.consoGaz.length > 0) {
            this.consoGaz = JSON.parse(this.consoGaz);
            this.omniApplyCallResp({"contestGaz": this.consoGaz});
            //this.omniJsonData.contestGaz = this.consoGaz;
            //this.omniJsonData.donneesDerniersIndexReelGaz = JSON.parse(this.omniJsonData.donneesDerniersIndexReelGaz);
            if (this.omniJsonData.donneesDerniersIndexReelGaz && this.omniJsonData.donneesDerniersIndexReelGaz.length > 0) {
                this.omniApplyCallResp({"donneesDerniersIndexReelGaz": JSON.parse(this.omniJsonData.donneesDerniersIndexReelGaz)});
            }
        }
        if(this.consoElec && this.consoElec.length > 0) {
            this.consoElec = JSON.parse(this.consoElec);
            this.omniApplyCallResp({"contestElec": this.consoElec});
        }
        // this.tab = this.omniJsonData.type === 'Gaz' ? true : false;
    }

    swichTabGaz() {
        this.omniApplyCallResp({"type":"Gaz"});
    }
    swichTabElec() {
        this.omniApplyCallResp({"type":"Elec"});
    }
}