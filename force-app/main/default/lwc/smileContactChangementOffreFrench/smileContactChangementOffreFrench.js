import { api, track } from 'lwc';
import OmniscriptHeader from 'vlocity_cmt/omniscriptHeader';
import { allCustomLabels } from 'vlocity_cmt/omniscriptCustomLabels';
import { OMNIDEF } from './smileContactChangementOffreFrench_def.js';
import tmpl from './smileContactChangementOffreFrench.html';
import tmpl_nds from './smileContactChangementOffreFrench_nds.html';

/**
 *  IMPORTANT! Generated class DO NOT MODIFY
 */
export default class smileContactChangementOffreFrench extends OmniscriptHeader {
    @track jsonDef = {};
    @track resume = false;
    @api layout;

    _label = {
        OmniScriptError: allCustomLabels.OmniScriptError,
        OmniScriptNotFound3: allCustomLabels.OmniScriptNotFound3,
        OmniScriptType: allCustomLabels.OmniScriptType,
        OmniScriptSubType: allCustomLabels.OmniScriptSubType,
        OmniScriptLang: allCustomLabels.OmniScriptLang,
        OmniScriptNotFound2: allCustomLabels.OmniScriptNotFound2
    }

    connectedCallback() {
        this.jsonDef = JSON.parse(JSON.stringify(OMNIDEF));
        this.resume = this.jsonDef.response ? this.jsonDef.response.sInstanceId != null : false;
        super.connectedCallback();
    }

    render() {
        return this.layout === 'newport' ? tmpl_nds : tmpl;
    }
}