/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 

 * @last modified on  : 09-16-2020

 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   08-20-2020   Mohamed Aamer   Initial Version
**/
import { LightningElement,wire } from 'lwc';
import getInfoCouleur from '@salesforce/apex/InfoCouleurController.getInfoCouleur';
import createViewBy from '@salesforce/apex/InfoCouleurController.createViewBy';
import getCarousel from '@salesforce/apex/InfoCouleurController.getCarousel';
export default class CarouselInfoCouleur extends LightningElement {
    options = { autoScroll: true, autoScrollTime: 5 };
    isCarousel;
    items = [];
    connectedCallback() {
        getCarousel().then(result => {
            console.log('result getCarousel: ',result);
            this.isCarousel = true;
            getInfoCouleur().then(result => {
                console.log('result getInfoCouleur: ',result);
                result.forEach(info => {
                    let list = {
                        image: info.imgColorSource__c,
                        header: info.Name,
                        description: info.Name,

                        href: info.Info_Url__c,
                        idInfo: info.Id
                    };
                    this.items.push(list); 
                    console.log('result InfoCouleur: ',this.items);

                });
            }).catch(error => {
                console.log('error getInfoCouleur: ',error);
            })
        }).catch(error => {
            console.log('error getCarousel: ',error);
            this.isCarousel = false;
        })
    }
}