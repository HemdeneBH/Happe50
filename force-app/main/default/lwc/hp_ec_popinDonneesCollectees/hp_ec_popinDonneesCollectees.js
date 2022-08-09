/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-23-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';


import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import CASE_OBJECT from '@salesforce/schema/Case';
import createCaseDonnees from '@salesforce/apex/HP_EC_UpdateCustomerData.createCaseDonnees';


export default class Hp_ec_popinDonneesCollectees extends LightningElement {
    @api popindonneescollecteestitle;
    @api popindonneescollecteestexteexplicatif;
    @api popindonneescollecteesmessageerreur;
    @api popindonneescollecteeslibellebouton;
    @api recordid;

    iconAlert = HP_EC_icon_alert;
    iconClose = HP_EC_close_icon_light;

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;

    get mailRT() {
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Mail');
    }

    closePopinDonneesCollectees(event){
        this.dispatchEvent(new CustomEvent('openpopindonneescollectees', { detail: false}));
    }

    handleCreerDossier(event){
        createCaseDonnees({ 
            contactId:this.recordid
        }).then(resultResponses => {
            console.log('Case created with Id: ' +JSON.stringify(resultResponses));
        }).catch(error => {
            console.log('Error: ' +JSON.stringify(error));
        });
        this.dispatchEvent(new CustomEvent('openpopindonneescollectees', { detail: false}));
    }
    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }
}