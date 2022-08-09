/**
 * @File Name          : SM_LWC_NbreInfoCouleur.js
 * @Description        : Js du Composants Compteur des InfoCouleurs non vues
 * @Author             : Jihad AZAMI HASSANI
 * @Last Modified On   : 05-04-2021
 * @Ticket             : FT2-277 / Sprint 10
 * Ver       Date            Author      		    Modification
 * 1.0    05/03/2020   Jihad AZAMI HASSANI     Initial Version
**/
import { LightningElement , track, wire } from 'lwc';
import getNbreInfoCouleurNonLues from '@salesforce/apex/InfoCouleurController.getNbreInfoCouleurNonLues';
import createViewBy from '@salesforce/apex/InfoCouleurController.createViewBy';
import { NavigationMixin } from 'lightning/navigation';


export default class sM_LWC_InfoCouleurNonLues extends NavigationMixin(LightningElement) {
    @track data = [];
    @track error;
    @track idInfoCouleur = '';


    @wire(getNbreInfoCouleurNonLues)
    NbreInfoCouleurNonLues(result) {
            if (result.data) {
                this.data = result.data;
                this.error = undefined;
    
            } else if (result.error) {
                this.error = result.error;
                this.data = undefined;
            }
        }


        refreshComponent(event){
            window.location.reload();
            console.log('refresh');
        }
        
        handleClick(event) {
            this.idInfoCouleur = event.target.dataset.infoid;
            console.log("id Infocouleur :"+this.idInfoCouleur);
            

            createViewBy({ idInfoCouleur: this.idInfoCouleur })
            .then(result => {
                this.NbrsVu = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.NbrsVu = undefined;
            });

          

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.idInfoCouleur,
                    objectApiName: 'InfoCouleur__c',
                    actionName: 'view'
                }
            });

        }
    
    }