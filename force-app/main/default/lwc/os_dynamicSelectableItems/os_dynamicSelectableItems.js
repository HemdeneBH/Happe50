import { LightningElement, api, track } from "lwc";
import omniscriptSelect from "vlocity_cmt/omniscriptSelect";
import { handleMergeField } from "vlocity_cmt/omniscriptInternalUtils";  // to retrieve merge field from JSON Data

export default class Os_dynamicSelectableItems extends omniscriptSelect {

    @api
    options = [];
    jsonDataCopy;

    connectedCallback() {
        
        super.connectedCallback();
        this.updateOptions();
        this.setDefaultValue();

    }

    setDefaultValue() {

        if(typeof this.elementValue === 'undefined') {
            if(typeof this.jsonDef.propSetMap.lwcInput.defaultValuePath !== 'undefined') {
                //retrieve default value
                let mergeValue = handleMergeField(`%${this.jsonDef.propSetMap.lwcInput.defaultValuePath}%`, 
                                                    this.jsonData, 
                                                    this.scriptHeaderDef ? this.scriptHeaderDef.labelMap : {}, 
                                                    false, 
                                                    false
                                                );
                //apply value on component and in JSON Data
                this.applyCallResp(mergeValue); 
            }
        }
    }

    updateOptions() {
        
        //default options source (deprecated)
        let sourceOptions;
        if(   typeof this.jsonData[this.jsonDef.name+'Const'] !== 'undefined' 
           && this.jsonData[this.jsonDef.name+'Const'].options) {
            sourceOptions = this.jsonData[this.jsonDef.name+'Const'].options;
           }

        //custom option source, using merge field (recommended)
        if(typeof this.jsonDef.propSetMap.lwcInput.optionsPath !== 'undefined' && this.jsonDef.propSetMap.lwcInput.optionsPath != null) {
            try {
                sourceOptions = JSON.parse(handleMergeField( `%${this.jsonDef.propSetMap.lwcInput.optionsPath}%`, 
                                              this.jsonData, 
                                              this.scriptHeaderDef ? this.scriptHeaderDef.labelMap  : {}, 
                                              false, 
                                              false
                                        ));
            } catch(error) {
                //handleMergeField will fail if the merge does not match any node in the JSON Data
                sourceOptions = [];
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
            if(this.options.length === 0 && this.elementValue) {
                let emptyEvent = { target : { value : null }};
                this.handleChange(emptyEvent);
            }
        }
        // surcharger les éléments standards de Vlocity (liste des options + message à afficher dans le cas (pas d'options))
        this._realtimeOptions=this.options;
        this._messageWhenValueMissing='Selectionnez une valeur';
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