/**
 *@description       : Cellule qui contient le bonton permettant de modifier le blocage
  @author            : HBO
  @group             : FT2
  @last modified on  : 05-05-2022
  @last modified by  : HBO
*/


import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import dataTableCell from "vlocity_cmt/dataTableCell";
import { LightningElement, api} from 'lwc';


export default class Sm_vlocity_SyntheseBlocageTableCellAction extends OmniscriptBaseMixin(dataTableCell) {

    @api modifySuppBlocageOK;

    get sRowData(){
        return JSON.stringify(this.rowData);
    }

    openModifySuppModal(){
        this.modifySuppBlocageOK = true;

        // Creates modifySuppEvent with the data.
        const modifySuppEvent = new CustomEvent("modifysuppblocageok", {detail: this.modifySuppBlocageOK});
    
        // Dispatches the event.
        this.dispatchEvent(modifySuppEvent);


        // Create rowDataEvent with the data.
        const rowDataEvent = new CustomEvent("rowdata", {detail: this.rowData});

    
        // Dispatches the event.
        this.dispatchEvent(rowDataEvent);


    }


}