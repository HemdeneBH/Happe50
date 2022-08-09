/**   
 *@description       : LWC utilisé pour parser le tableau de mensualités en JSON et le renvoyer a l'omniscript
  @author            : AE
  @group             : 
  @last modified on  : 10-13-2021
  @last modified by  : AE
*/
import { LightningElement,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class SM_AjustementMensParse  extends OmniscriptBaseMixin(LightningElement)  {
    @api tableDataMens;
    @api tableDataMensParsed;
    connectedCallback() {
        //ABA : FT2-1801 BEGINS HERE Correct the parsing following the type of api data
        if(this.tableDataMens!=null){
            if (JSON.stringify(this.tableDataMens).startsWith("[\"")){
                this.tableDataMensParsed = JSON.parse(this.tableDataMens);
                this.omniApplyCallResp({ "DataMensDetails": this.tableDataMensParsed});
            } else {
                this.tableDataMensParsed = this.tableDataMens;
                this.omniApplyCallResp({ "DataMensDetails": this.tableDataMensParsed});
            }
        }
        //ABA : FT2-1801 ENDS HERE Correct the parsing following the type of api data
    }
}