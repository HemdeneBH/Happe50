import { LightningElement, api } from 'lwc';

export default class Sm_os_opsTableauCreneau extends LightningElement {
    @api x;
    @api y;
    @api libelle;
    @api selected;

    handleSelect() {
        console.log("handleSelect");
        this.dispatchEvent(new CustomEvent('select', {
            detail: { x: this.x, y: this.y }
        }));
    }

    get myclass() {
        return this.selected ? "creneau selected" : "creneau";
    }
}