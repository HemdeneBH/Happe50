import { LightningElement, track, api } from 'lwc';

export default class Sm_notedebitcreditalert extends LightningElement {
    @track displayalert;
    @api datevalidation;
    @api statut;

    connectedCallback(){
        let today = new Date();
        this.datevalidation = new Date(this.datevalidation);
        
        if(this.statut == 'A valider' || ( (this.statut == 'Refusé' || this.statut == 'Erreur' || this.statut == 'Erreur auto' )  && this.monthDiff(this.datevalidation,today) < 2 ) ){
            this.displayalert = true;
        }
    }

    monthDiff(d1, d2) {
        var months;
        if(d1 == null || d2 == null){
            months = 0;
        }else{
            months = (d2.getFullYear() - d1.getFullYear()) * 12;
            months -= d1.getMonth();
            months += d2.getMonth();
        }
        console.log('mont diff '+months);
        return months <= 0 ? 0 : months;
    }
}