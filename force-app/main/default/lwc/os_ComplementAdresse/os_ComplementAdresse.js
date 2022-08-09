import { LightningElement, api, track } from "lwc";
import omniscriptText from "vlocity_cmt/omniscriptText";
import template from "./os_ComplementAdresse.html";
import { getNamespaceDotNotation } from 'vlocity_cmt/omniscriptInternalUtils'; 
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';




export default class Os_ComplementAdresse extends omniscriptText {

    jsonDataCopy;
    _actionUtilClass = new OmniscriptActionCommonUtil();
    _ns = getNamespaceDotNotation();
    listComplementResult;
    hideSuggestion=true; //Pour cacher la liste des complèments aprés sélection
    oldAddress={"idVoie":"","numero":""}; //L'anciennes valeurs pour complèment d'adresse
    selectedValue='';
    connectedCallback() {
        
        super.connectedCallback();
        
        this.updateOptions();
    }


    render() {
        return template;
    }

    updateOptions() {
        console.log("Executed- updateOptions");
        //vérifier s'il y a une adresse DQE sélectionnée
        if(this.jsonData && this.jsonData.ContactInfo && this.jsonData.ContactInfo.Address && this.jsonData.ContactInfo.Address["SearchByAddress-Block"] && this.jsonData.ContactInfo.Address["SearchByAddress-Block"].idVoie ){
            let idVoie=this.jsonData.ContactInfo.Address["SearchByAddress-Block"].idVoie;
            let numero=(this.jsonData.ContactInfo.Address["SearchByAddress-Block"].numero)?this.jsonData.ContactInfo.Address["SearchByAddress-Block"].numero:'';
            console.log("idVoie=",idVoie);
            console.log("numero=",numero);

            // vérifier si l'adresse a changé 
            if(this.oldAddress.idVoie != idVoie ||  this.oldAddress.numero != numero ){

            console.log("faire un appel DQE");
            const params = {
                input: '{"idVoie":"'+idVoie+'", "numero":"'+numero+'"}',
                sClassName: 'SM_CTRL003_AdresseDQE',
                sMethodName: 'getSuggestionsComplementDQE',
                options: '{}',
            };
    
            this._actionUtilClass
                .executeAction(params, null, this, null, null)
                .then(response => {
                    window.console.log('***response : '+ JSON.stringify(response));
                    this.listComplementResult = response.result.result;
                    this.hideSuggestion=(this.listComplementResult.length>0 || this.oldAddress.idVoie =='')?false:true;
                })
                .catch(error => {
                    window.console.log('***error : '+ JSON.stringify(error));
                });
    
        
            this.oldAddress={"idVoie":idVoie,"numero":numero};

            }

            
        }
    }

    // modifier le complément d'adresse sélectionné
    handleItemSelection(e){
        console.log("Complement=",e.currentTarget.dataset.selected);
        let complement= e.currentTarget.dataset.selected;
        this.template.querySelector("vlocity_cmt-input").value=complement;
        this.hideSuggestion=true;
        this.applyCallResp(complement);
    }   
    
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