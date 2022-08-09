import { LightningElement ,api } from 'lwc';
import {OmniscriptBaseMixin} from 'vlocity_cmt/omniscriptBaseMixin';

export default class SmOptionsSlider extends OmniscriptBaseMixin(LightningElement) {
   
    initVal = 10;
    optionChoisie;
    /* 
     options c'est un input parameter (mentionné dans la flexCard) fourni au LWC custom dans la flexCard : "smOptionsSelection".
    */
    @api options;
    active;
    
    connectedCallback()
    {
        let _optionList =JSON.parse(JSON.stringify(this.options));
        // on recupère la variable active depuis le json pour modifier l'état du slider à disabled/enabled
        _optionList.forEach(option => {
            if(option.idOption == 'GOPT_VERT'){
                this.active=option.active;
                this.initVal=option.selectedRate != null?option.selectedRate:10;
            }
        });
    }
    handleChange(event) {
        let _optionList =JSON.parse(JSON.stringify(this.options));
        let _selectedValue=event.target.value;
        _optionList.forEach(option => {
            if(option.idOption == 'GOPT_VERT'){
            option.OptionPrice=option.Remote_GetPrixServices.additionalPrices['ZZTAUX_'+_selectedValue]; 
            option.selectedRate=_selectedValue;
            }
        });
        this.omniApplyCallResp({"optionsList":_optionList});
    }
}