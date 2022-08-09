import OmniscriptText from "vlocity_cmt/omniscriptText";
 
export default class SM_vlocity_maskInput_4 extends OmniscriptText {
    _pattern = '0000';
    handleBlur(evt) {
        if (evt.target && typeof evt.target.value === 'string') {
            this.applyCallResp(evt.target.value.padStart(this._pattern.length, '0'));
        } else {
            this.applyCallResp(evt.target.value);
        }
    }
}