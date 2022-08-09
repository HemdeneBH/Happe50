import { LightningElement, api, track } from 'lwc';
import template from "./sM_CourrierReglementaires.html";

export default class SM_CourrierReglementaires extends LightningElement {

    @track finalList = [];
    _listCourriers;
    @api set listCourriers(value) {
        if(value===null||value==='{jalonCourrierReg}'||value==='[null]'){
            return;
        }

        //FT2-1623: Anomalie_Affichage message d'erreur_dossier recouvrement
        //Pour éviter toutes les erreurs affichés au lancement du parcours et qui concernent les courriers réglementaires, cette ligne a été modifiée.
        //this._listCourriers = JSON.parse(value) -> this._listCourriers = JSON.parse(JSON.stringify(value))

        this._listCourriers = JSON.parse(JSON.stringify(value)) || {};

        for (var i = 0; i < this._listCourriers.length; i++) {

            if (this._listCourriers[i] != null && this.finalList.length < 6) {

                var item = this._listCourriers[i];
                item.rowspan = '1';
                item.montant = item.montant + '€';

                //FT2-1704 Vérification du type de courrier
                if(this._listCourriers[i].nom.includes("L1")){
                item.numeroCourrier = '#1';
                } else if(this._listCourriers[i].nom.includes("L2")){
                    item.numeroCourrier = '#2';
                }

                
                if (this._listCourriers[i + 1] != null &&
                    item.numeroFacture == this._listCourriers[i + 1].numeroFacture) {
                    item.isCourrier2 = true;
                    item.rowspan = '2';

                    let oldDate = item.Date;
                    let oldMontant = item.montant;

                    item.montant2 = this._listCourriers[i + 1].montant + '€';
                    item.date2 = this._listCourriers[i + 1].Date;                        
                    item.montant = oldMontant;
                    item.Date = oldDate;

                    //FT2-1704 Vérification du type de courrier
                    if(this._listCourriers[i].nom.includes("L1")){ 
                      item.numeroCourrier = '#1';
                      item.numeroCourrier2 = '#2';
                    }
                    else if(this._listCourriers[i].nom.includes("L2")){ 
                      item.numeroCourrier = '#2';
                      item.numeroCourrier2 = '#1';
                    }
                    this._listCourriers.splice(i + 1, 1);
                }
                let courrierDateInit1 = item.Date.split('/');
                item.Date = courrierDateInit1[1] + '/' + courrierDateInit1[0] + '/' + courrierDateInit1[2];
                if (item.date2 != null && item.date2 != '') {
                    let courrierDateInit2 = item.date2.split('/');
                    item.date2 = courrierDateInit2[1] + '/' + courrierDateInit2[0] + '/' + courrierDateInit2[2];
                }

                this.finalList.push(item);
            }
        }
        //console.log('line29:'+this.factures);
    }
    get listCourriers() {
        return this._listCourriers;
    }
}