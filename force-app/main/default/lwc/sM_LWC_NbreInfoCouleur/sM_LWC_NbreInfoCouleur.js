/**
 * @File Name          : SM_LWC_NbreInfoCouleur.js
 * @Description        : Js du Composants Compteur des InfoCouleurs non vues
 * @Author             : Jihad AZAMI HASSANI
 * @Last Modified On   : 05/03/2020 à 14:26:18
 * @Ticket             : FT2-277 / Sprint 10
 * Ver       Date            Author      		    Modification
 * 1.0    05/03/2020   Jihad AZAMI HASSANI     Initial Version
**/
import { LightningElement , track, wire } from 'lwc';
import getNbreInfoCouleurBleu from '@salesforce/apex/InfoCouleurController.getNbreInfoCouleurBleu';
import getNbreInfoCouleurRouge from '@salesforce/apex/InfoCouleurController.getNbreInfoCouleurRouge';
import getNbreInfoCouleurViolette from '@salesforce/apex/InfoCouleurController.getNbreInfoCouleurViolette';

export default class SM_LWC_NbreInfoCouleur extends LightningElement {

    //Wire get all infoCouleur records by color from "InfoCouleurController" apex class
    @wire(getNbreInfoCouleurBleu)NbreInfoCouleurBleu;
    @wire(getNbreInfoCouleurRouge)NbreInfoCouleurRouge;
    @wire(getNbreInfoCouleurViolette)NbreInfoCouleurViolette;

    //Style the header of standard controller
    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `c-s-m_-l-w-c_-nbre-info-couleur .slds-icon-action-info {
            background-color: #fcb95b;
        }
        c-s-m_-l-w-c_-nbre-info-couleur .slds-text-heading_small{
        font-size: 20px;
        font-weight: bold;
        }`;
        this.template.querySelector('lightning-card').appendChild(style);
    }

}