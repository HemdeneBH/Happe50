/**
 * @File Name          : sM_LWC_POC_InfoCouleurVue.js
 * @Description        : Js du composant Carrousel
 * @Author             : Jihad AZAMI HASSANI
 * @Last Modified On   : 05/03/2020 à 14:26:18
 * @Ticket             : FT2-289, FT2-291/ Sprint 10
 * Ver       Date            Author      		    Modification
 * 1.0    05/03/2020   Jihad AZAMI HASSANI     Initial Version
**/
import { LightningElement, track, wire } from 'lwc';
import getInfoCouleur from '@salesforce/apex/InfoCouleurController.getInfoCouleur';
import createViewBy from '@salesforce/apex/InfoCouleurController.createViewBy';
import getCarousel from '@salesforce/apex/InfoCouleurController.getCarousel';

export default class SM_LWC_POC_InfoCouleurVue extends LightningElement {
    @track NbrsVu;
    @track error;
    @track idInfoCouleur = '';
    @track isCarousel;


    //Wire get all infoCouleur records
    @wire(getInfoCouleur) infoCouleurs;

    //Wire test if infoCouleur is empty
    @wire(getCarousel) isCarousel;


    //Au clic handleItemClicked déclenche la méthode createViewBy du Controller 
    //Redirige vers la page de l’info qu’on a cliqué et incrémente la liste associer des nombres de vues
    handleItemClicked(event) {
        this.idInfoCouleur = event.currentTarget.dataset.url;
        createViewBy({ idInfoCouleur: this.idInfoCouleur })
            .then(result => {
                this.NbrsVu = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.NbrsVu = undefined;
            });
    }

    // Carrousel non responsive, on insert cette ligne, de style qui modifie le tag slot pour 
    //mise en page + éviter que ce soit déformer
    /*renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `c-s-m_-l-w-c_-p-o-c_-info-couleur-vue slot[interop-carousel_carousel]{
            display:contents;
        }`;
        this.template.querySelector('lightning-carousel').appendChild(style);
    }*/
}