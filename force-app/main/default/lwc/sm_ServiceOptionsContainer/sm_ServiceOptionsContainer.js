import { LightningElement,api } from 'lwc';
import pubsub from 'vlocity_cmt/pubsub';
import {OmniscriptBaseMixin} from 'vlocity_cmt/omniscriptBaseMixin';

export default class Sm_ServiceOptionsContainer extends OmniscriptBaseMixin(LightningElement) {
   
    @api options;
    
    

    connectedCallback() {
        //register events
        
        pubsub.register('sm_serviceoptions', {
            select: this.handleSelectOption.bind(this)
        });
        
    }
   
    handleSelectOption(data) {
        this.updateJsonList(data);
        let action = data.action == 'true'? 'Y':'N';
        console.log("dataAction::"+data.action)
        let resp = {};
        resp[data.selectedNodeName] = action;
        this.omniApplyCallResp(resp);
                
      }
       /* Cette méthode permet de MAJ l'attribut isSelected dans chaque option choisie ou refusée
    et de renovoyer le json mis à jour dans l'OS */
    updateJsonList(data){
        let _optionList =JSON.parse(JSON.stringify(this.options));
        _optionList.forEach(option => {
            if(option.EnergyType == data.optionName){
                option.isSelected=data.action; 
            }
        });
        this.omniApplyCallResp({"optionsList":_optionList});
    }

}