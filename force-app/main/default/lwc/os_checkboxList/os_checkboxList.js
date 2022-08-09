import template from "./os_checkboxList.html";
import { LightningElement, track, api } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";

export default class Os_checkboxList extends OmniscriptBaseMixin(LightningElement)  {

    @api
    tablenodename;
    
    @api
    tableNodeData;

    @track
    activeSections = ['A'];

    @api
    fieldlabels;

    @track
    selectedValues;

    @api
    targetnodename;

    @api 
    urlnodename;

    @api
    datenodename;

    connectedCallback(){

        //get data from input nodes
        if (typeof this.omniJsonData[this.tablenodename] !== 'undefined') {
            this.tableNodeData  = JSON.parse(JSON.stringify(this.omniJsonData[this.tablenodename])) ;  // "cloning" instead of assigning because node is read-only (need to set isSelected)
            this.selectedValues = this.omniJsonData[this.targetnodename] ? this.omniJsonData[this.targetnodename] : new Array();
        } else {
            //when no document is retrieved
            this.tableNodeData = new Array();
            this.selectedValues = new Array();
        }

        //retrieve selected rowIds
        let selectedRowIds = [];
        if(Array.isArray(this.selectedValues)) {
            this.selectedValues.forEach(element => {
                let currentRowId  = element.rowId;
                if(currentRowId !== "" && !selectedRowIds.includes(currentRowId))
                    selectedRowIds.push(currentRowId);
            });
        }
        //set selected rows in UI
        if(Array.isArray(this.tableNodeData) && selectedRowIds.length>0) {
            this.tableNodeData.forEach(element => {
                element.isSelected = selectedRowIds.includes(element.rowId);
            });
        }


    }


    render() {
        return template;
    }

    handleCheck(event){
        
        let tempUrl = this.omniJsonData[this.urlnodename] ? this.omniJsonData[this.urlnodename] : new Array();
        let tempDate = this.omniJsonData[this.datenodename] ? this.omniJsonData[this.datenodename] : new Array();

        if(event.target.checked){
            
            let tempTable = this.tableNodeData.filter( x => x.rowId == event.target.value);
            this.selectedValues.push(
                ...tempTable
                );
            tempUrl.push(...tempTable.map(x => x.url));
            tempDate.push(...tempTable.map(ele => 
                `${this.fieldlabels.valueChb}${ele.valueChb}`
            ));

        }
        else{

            this.selectedValues.forEach(x => {

                if(x.rowId == event.target.value){

                    tempUrl = tempUrl.filter( xUrl => {
                        
                        console.log('here is comps ',xUrl.toString() != x.url.toString());
                        return xUrl.toString() != x.url.toString();
                        
                        
                        
                    });         
                    tempDate = tempDate.filter( xDate => xDate.toString() != `${this.fieldlabels.valueChb}${x.valueChb}`);

                }

            })
            this.selectedValues = this.selectedValues.filter(x => x.rowId != event.target.value);

        }

        this.omniApplyCallResp({[this.targetnodename] : this.selectedValues});
        this.omniApplyCallResp({[this.urlnodename] : tempUrl});
        this.omniApplyCallResp({[this.datenodename] : tempDate});


    }
}