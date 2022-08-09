import { api, LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class Sm_mcoob_afficherLogements extends OmniscriptBaseMixin(LightningElement) {


  tableauAdress = [];
  @api adresses;
  @api listeCCmodif;
  @api listeCClireMandat;
  connectedCallback() {
    if (this.omniJsonData) {

      //FT2-1809 - [INT][Modif COOB] modification coob KO
      var dataAdressPrel;
      if (typeof this.adresses == "object") {
        dataAdressPrel = this.adresses;
      }
      else {
        dataAdressPrel = JSON.parse(this.adresses);
      }
      // var dataListeCC=JSON.parse( JSON.stringify(this.omniJsonData.listeCCmodif));
      
      var dataListeCCmandat = JSON.parse(JSON.stringify(this.omniJsonData.listeCClireMandat));

      //console.log("dataListeCC: ", dataListeCC);
      console.log("dataAdressPrel :", dataAdressPrel);
      console.log("dataListeCCmandat :", dataListeCCmandat);

    }


    for (var i = 0; i < dataAdressPrel.length; i++) {
      if (dataListeCCmandat.includes(dataAdressPrel[i].NoCompteContrat)) {

        console.log("comptContrat ", dataAdressPrel[i].NoCompteContrat);
        console.log("adresse ", dataAdressPrel[i].libelleVoie);

        this.tableauAdress.push({

          label: dataAdressPrel[i].numeroVoie + ' ' + dataAdressPrel[i].libelleVoie + ' ' + dataAdressPrel[i].complementAdresse + ' ' + dataAdressPrel[i].codePostal + ' ' + dataAdressPrel[i].ville,
          value: dataAdressPrel[i].NoCompteContrat
        });
      }
    }
  }


}