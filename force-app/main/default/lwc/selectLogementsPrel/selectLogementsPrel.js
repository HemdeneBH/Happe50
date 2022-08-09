import { LightningElement, api, track, wire} from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
 
export default class SelectLogementsPrel extends OmniscriptBaseMixin(LightningElement) {
 
    @api adresses;
    @api listecclwc;
    @api numcc;
    
    tableauAdress = [];
    value = [];
    dataValues = [];
 
    connectedCallback() {

        
        if(this.adresses && this.adresses.length > 0 && this.tableauAdress.length == 0)
        {
            console.log('adresseeeees'+this.adresses);
            this.value = [this.numcc];

            //Verification de la liste "this.adresses" si le format est bon pour faire le "JSON.parse"
            var dataAdressPrel= this.adresses[0].NoCompteContrat ? this.adresses : JSON.parse(this.adresses);
          
            console.log('Paaarsed'+dataAdressPrel);
            

        
            for (var i = 0; i < dataAdressPrel.length; i++)
            {         

                this.tableauAdress.push({
                label: dataAdressPrel[i].numeroVoie+' '+dataAdressPrel[i].libelleVoie+' '+dataAdressPrel[i].complementAdresse+' '+dataAdressPrel[i].codePostal+' '+dataAdressPrel[i].ville,
                value: dataAdressPrel[i].NoCompteContrat
                });     
                
                
            } 
        }

    }


    get options() {
        return this.tableauAdress;
    }

    get selectedValues() {
        //return this.value.join(',');
        return this.value;
    }

    handleChange(e) {

        
        this.dataValues = [];
        this.value = e.detail.value;
        //this.value.push(this.numcc);
        this.dataValues.push({compteClient:''+this.numcc+''});
        for (var i = 0; i < this.value.length; i++)
        {         

            this.dataValues.push({
                compteClient: this.value[i],
            }); 
        }
        
        
        this.omniApplyCallResp({[this.listecclwc] : this.dataValues});
        
    }
        
       
    
}