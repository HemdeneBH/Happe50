import dataTableCell from "vlocity_cmt/dataTableCell";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';


export default class Sm_fc_CustomDataTableCellAction extends OmniscriptBaseMixin(dataTableCell)  {

    get sRowData(){
        return JSON.stringify(this.rowData);
    }
    connectedCallback() {
        if(this.cellData)
            console.log('dataTableCell' + this.cellData.value);
    }

    renderedCallback() {
        if(this.cellData)
            console.log('dataTableCell' + this.cellData.value);
    }

    handleClick(evt){

        //this.rowData.isPayeurDivergent = true;

        console.log('My Action'+evt.detail);
        
        this.omniApplyCallResp({"isPayeurDivergent" : true});
        this.omniApplyCallResp({"isnewpayeurdivergent" : true});
        this.omniApplyCallResp({"rowdata" : this.rowData})
        this.omniNextStep();
    }

    fakeIconData = [{"dummy" : null}]
}