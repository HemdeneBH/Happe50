import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class EngieCoobAdresses extends OmniscriptBaseMixin(LightningElement){
    //data = '';
    //value='';
    @api selectedAdress;
    @api selectedCC;
    @api selectedObject;
    @api adresses;
    @api tableauAdress = [];
    value = '';

    connectedCallback() {
        var data = JSON.parse(this.adresses);

        console.log('DATA '+data);
        console.log('DATA 0 '+data[0]);
        console.log('DATA NoCompteContrat  '+data[0].NoCompteContrat);
        for (var i = 0; i < data.length; i++) {

            
            this.tableauAdress.push({
 
             label: data[i].numeroVoie+' '+data[i].libelleVoie+' '+data[i].libelleVoie+' '+data[i].complementAdresse+' '+data[i].codePostal+' '+data[i].ville,
             value: data[i].NoCompteContrat
           });
        }
        

    }
    handleSelect(event) {
        const selectedOption = event.detail.value;
        
        let selectedObject  = this.tableauAdress.find(function(element){
                    return element.value === selectedOption;
        });

        

        this.selectedCC = selectedOption;
        this.selectedAdress = selectedObject.label;
        console.log('Option selected with value: ' + selectedOption);
        console.log('selected Label ->' + selectedObject.label);
        console.log('selected Object ->' + selectedObject);
        this.selectedObject = selectedObject;
        this.omniUpdateDataJson(this.selectedObject);

        //this.omniApplyCallResp({[this.selectedAdress]: selectedOption});
        //this.omniApplyCallResp({[this.selectedCC]: selectedObject.label});

    }
    
    
    

    

    
}