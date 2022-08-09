/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-23-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { api, LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';


import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

import getPorteFeuilleContrat from '@salesforce/apex/HP_EC_LoadCustomerData.getPorteFeuilleContratXdata';
import getCoordonneesBancaires from '@salesforce/apex/HP_EC_LoadCustomerData.getCoordonneesBancaires';

export default class Hp_ec_coordonneesBancaires extends NavigationMixin(LightningElement) {

    @wire(MessageContext) messageContext;

    @api title;

    @track IBAN;
    @track modePaiement;
    @track isPrelevement;
    @track idPortefeuilleContrat;

    async populateContractInfo() {
        console.log('Voici l\'id PorteFeuille sélectionné sur le composant "Hp_ec_coordonneesBancaires" : ' + this.idPortefeuilleContrat);
        this.initializeComponantProperties();

        if (!this.idPortefeuilleContrat) {
            return;
        }

        const ACTIF_PORTE_FEUILLE_RESULT = await this.getPorteFeuilledata(this.idPortefeuilleContrat);
        const ACTIF_PORTE_FEUILLE = JSON.parse(ACTIF_PORTE_FEUILLE_RESULT);

        ACTIF_PORTE_FEUILLE.codeModeEncaissement == '5' ? this.isPrelevement = true : this.isPrelevement = false;
        this.modePaiement = ACTIF_PORTE_FEUILLE.libelleModeEncaissement;

        if(this.isPrelevement) {
            const COORDONNEES_BANCAIRES_RESULT = await this.getCoordonneesBancaires();
            // console.log('COORDONNEES_BANCAIRES_RESULT : ' + COORDONNEES_BANCAIRES_RESULT);

            const COORDONNEES_BANCAIRES_RESULT_PARSED = JSON.parse(COORDONNEES_BANCAIRES_RESULT);
            if(COORDONNEES_BANCAIRES_RESULT_PARSED._data && COORDONNEES_BANCAIRES_RESULT_PARSED._data[0]) {
                // this.IBAN = COORDONNEES_BANCAIRES_RESULT_PARSED._data[0].iBAN;
                this.IBAN = this.formatIBAN(COORDONNEES_BANCAIRES_RESULT_PARSED._data[0].iBAN);
            }
        }
    }

    async getPorteFeuilledata(portefeuilleId) {
        return new Promise(async (resolve, reject) => {
            var result = await getPorteFeuilleContrat({ contractPortfolioXdataId: portefeuilleId }).then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getPorteFeuilleData : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        })
    }

    async getCoordonneesBancaires() {
        return new Promise(async (resolve, reject) => {
            var result = await getCoordonneesBancaires({}).then(response => {
                return response;
            }).catch(error => {
                console.log('***Error getCoordonneesBancaires : ' + JSON.stringify(error));
                return error;
            });
            resolve(result);
        })
    }

    initializeComponantProperties() {
        this.modePaiement           = null;
        this.isPrelevement          = false;
        this.IBAN                   = null;
    }

    connectedCallback() {
        this.handleSubscription();
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.populateContractInfo();
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this, this.messageContext, this.handleLightningMessage);
        }
    }

    handleLightningMessage(self, subscription, message) {
        if (message.messageType == 'SelectedPortfolio') {
            self.idPortefeuilleContrat = message.messageData.message;
            self.populateContractInfo();
        }
    }

    handleNavigationToMesFactures() {
        const config = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Mes_factures__c'
            }
        };
        this[NavigationMixin.Navigate](config);
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

    formatIBAN(iban) {
        return iban.substring(0, 8) + 'xxxxxxxxxxxxxxx' + iban.substring(25, iban.length);
    }
}