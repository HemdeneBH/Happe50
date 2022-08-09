import { LightningElement, api } from 'lwc';
import omniscriptSelect from "vlocity_cmt/omniscriptSelect";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from "./sm_mcoob_mandat_emailselected.html";

export default class Sm_mcoob_mandat_emailselected extends omniscriptSelect {


    @api
    options = [];
    jsonDataCopy;

    connectedCallback() {
        
        super.connectedCallback();
        this.updateOptions();
        if(typeof this.elementValue === 'undefined') {
            if(typeof this.jsonDef.propSetMap.lwcInput.defaultValuePath !== 'undefined') {
                this.elementValue = this.jsonData[this.jsonDef.propSetMap.lwcInput.defaultValuePath];
            }
        }
    }


    render() {
        return template;
    }


    updateOptions() {
        
        //default options source
        let sourceOptions;
        if(   typeof this.jsonData[this.jsonDef.name+'Const'] !== 'undefined' 
           && this.jsonData[this.jsonDef.name+'Const'].options) {
            sourceOptions = this.jsonData[this.jsonDef.name+'Const'].options;
           }

        //custom parameters
        if(typeof this.jsonDef.propSetMap.lwcInput !== 'undefined') {

            //search for custom node for options
            if(typeof this.jsonDef.propSetMap.lwcInput.optionsPath !== 'undefined') {
                let optionsPath = this.jsonDef.propSetMap.lwcInput.optionsPath;
                let currentNode = this.jsonData;
                if(optionsPath !== null) {
                    optionsPath.split(':').forEach(childNodeName => {
                        if(currentNode !== null && typeof currentNode[childNodeName] !== 'undefined')
                            currentNode = currentNode[childNodeName];
                    });
                    sourceOptions = currentNode;
                }
        
            }
        
        }

        //add select options to picklist
        this.options = [];
        if(Array.isArray(sourceOptions)) {
            sourceOptions.forEach(element => {
                if(element !== null && element.value !== "") 
                    this.options.push(element);
            });

            //empty picklist in JSONData when no value is found
            if(this.options.length === 0) {
                let emptyEvent = { target : { value : "null" }};
                this.handleChange(emptyEvent);
            }
        }
    }

    @api
    set jsonData(value) {
        super.jsonData = value;
        this.jsonDataCopy = value;
        if (value) {
            this.updateOptions();
        }
    }
    get jsonData() {
        return this.jsonDataCopy;
    }

}