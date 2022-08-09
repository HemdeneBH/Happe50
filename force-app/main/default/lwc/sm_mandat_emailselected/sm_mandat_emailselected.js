import { LightningElement, api } from 'lwc';
import omniscriptSelect from "vlocity_cmt/omniscriptSelect";
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from "./sm_mandat_emailselected.html";

export default class Sm_mandat_emailselected extends omniscriptSelect {


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
                if(element !== null && element.value !== "");
                    this.options.push(element);
            });

            //empty picklist in JSONData when no value is found
            if(this.options.length === 0) {
                let emptyEvent = { target : { value : "null" }};
                this.handleChange(emptyEvent);
            }
            /*FT2-1585 : étape Mandat & eDocuments - gestion des erreurs sur les canaux SMS et email :  Gerer le cas d'une liste de numero de telephone ou d'adresse email vide c'est le cas d'un contact qui n'a pas d'adresse email ou numero de telephone dans sa fiche client pour lequel on veut créer un espace client à travers le parcours prélèvement */
        }else {
            let emptyEvent = { target : { value : "null" }};
            this.handleChange(emptyEvent);
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