import { api, LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class Sm_mcoob_recap_listAdresses extends OmniscriptBaseMixin(LightningElement) {

     tableauAdress = [];
    @api adresses;
    @api listeCCmodif;

    connectedCallback() {
        if(this.omniJsonData){
        //FT2-1825 BEGINS HERE : Résolution problème lié au parse
        if (JSON.stringify(this.adresses).startsWith("[\"")){
          var dataAdressPrel = JSON.parse(this.adresses);
        } else {
            dataAdressPrel = this.adresses;
        }
        //FT2-1825 ENDS HERE : Résolution problème lié au parse
        var dataListeCC=JSON.parse( JSON.stringify(this.omniJsonData.listeCCmodif));
        //var dataListeCCmandat=JSON.parse( JSON.stringify(this.omniJsonData.listeCClireMandat));

       console.log("dataListeCC: ", dataListeCC);
       console.log("dataAdressPrel :",dataAdressPrel);
       //console.log("dataListeCCmandat :",dataListeCCmandat);

       
    }
  

      for (var i = 0; i < dataAdressPrel.length; i++)
        {         
            if(dataListeCC.includes(dataAdressPrel[i].NoCompteContrat)){
                
                console.log("comptContrat ", dataAdressPrel[i].NoCompteContrat);
                console.log("adresse ", dataAdressPrel[i].libelleVoie);

                this.tableauAdress.push({
 
                    label: dataAdressPrel[i].numeroVoie+' '+dataAdressPrel[i].libelleVoie+' '+dataAdressPrel[i].complementAdresse+' '+dataAdressPrel[i].codePostal+' '+dataAdressPrel[i].ville,
                    value: dataAdressPrel[i].NoCompteContrat
                  });             
            }
         }       
    } 
}