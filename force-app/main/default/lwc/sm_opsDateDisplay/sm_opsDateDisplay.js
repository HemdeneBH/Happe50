import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";

const week = new Array("Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche");
const months = new Array("janvier", "février", "mars", "avr", "mai", "juin", "juil", "août", "sept", "oct", "nov", "déc");

export default class Sm_opsDateDisplay extends OmniscriptBaseMixin(LightningElement) {
    _date = "";

    connectedCallback() {
        this.omniUpdateDataJson(this._date);
    }

    @api
    set date(input) {
        if (input) {
            var temp = new Date(input);
            var day = temp.getDay();
            day = (day == 0) ? 6 : day - 1;
            this._date = week[day] + " " + ("0" + temp.getDate()).slice(-2) + " " + months[temp.getMonth()] + " " + temp.getFullYear();
            // Update Omniscript Json to reuse the value in the Omniscript
            this.omniUpdateDataJson(this._date);
        }
        else {
            this._date = "[Date non disponible]";
        }
    }

    get date() {
        return this._date ;
    }
}