import OmniscriptMultiselect from "vlocity_cmt/omniscriptMultiselect";

export default class SM_vocity_multiSelectWithReset extends OmniscriptMultiselect {

    // Variable permet de savoir si resetValue a été sélectionnée sur cette itération ou sur l'itération précédente.
    hadResetValue=false; 

    handleChange(evt){
        super.handleChange(evt);
        if(typeof this.jsonDef.propSetMap.lwcInput !== 'undefined' && this.jsonDef.propSetMap.lwcInput.resetOption!== 'undefined') {
            // condition pour désélectionner les autres valeurs si la resetValue a été sélectionnée.
            if(this.elementValue && this.elementValue.toString().includes(this.jsonDef.propSetMap.lwcInput.resetOption) && !this.hadResetValue){
                this.hadResetValue=true;
                this.elementValue=this.jsonDef.propSetMap.lwcInput.resetOption;
            } // condition pour désélectionner la resetValue si une autre valeur (pas la resetValue) a été sélectionnée
            else if(this.elementValue && this.elementValue.toString().includes(this.jsonDef.propSetMap.lwcInput.resetOption) && this.elementValue.toString().includes(';') && this.hadResetValue ){
                this.elementValue=this.elementValue.toString().replace(this.jsonDef.propSetMap.lwcInput.resetOption,"").replace(/(;)\1+/g, '$1');
            } // réinitialiser la variable hadResetValue.
            else if(this.elementValue && !this.elementValue.toString().includes(this.jsonDef.propSetMap.lwcInput.resetOption))
                this.hadResetValue=false;
        }
    }
}