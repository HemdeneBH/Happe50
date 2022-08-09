/**   
 *@description       : LWC utilisé pour parser le tableau de string en JSON et le renvoyer a l'omniscript
  @author            : WM
  @group             : 
  @last modified on  : 10-19-2021
  @last modified by  : WM
*/
import { LightningElement, api, track} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class Os_parseTable  extends OmniscriptBaseMixin(LightningElement)  {
    @api tableInput;
    @api tableInputParsed ; 
    @api tableOutput;
    connectedCallback() {
        
        if(typeof this.tableInput === "string" || (Array.isArray(this.tableInput) && this.tableInput.length >0 && typeof this.tableInput[0] == "string")){
            this.tableInputParsed = JSON.parse(this.tableInput);
        } else{
            this.tableInputParsed = JSON.parse(JSON.stringify(this.tableInput));
        } 

        this.omniApplyCallResp({ [this.tableOutput] : this.tableInputParsed});
    }
}