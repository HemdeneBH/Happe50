import { LightningElement, track, api } from 'lwc';

export default class Sm_energielogo extends LightningElement {
    @api energie;
    @track isgaz;
    @track iselec;

    connectedCallback(){
        if(this.energie == 'Gaz' || this.energie =='Fioul'){
            this.isgaz = true;
        }
        if(this.energie == 'Electricité'){
            this.iselec = true;
        }
    }
}