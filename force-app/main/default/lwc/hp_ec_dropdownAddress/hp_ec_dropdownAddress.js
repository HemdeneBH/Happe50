/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-03-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
import { api, wire, track, LightningElement } from 'lwc';
import { MessageContext } from 'lightning/messageService';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';
import getContractsAddresses from '@salesforce/apex/HP_EC_LoadCustomerData.getContractsAddresses';
import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';

export default class Hp_ec_dropdownAddress extends LightningElement {

    @wire(MessageContext) messageContext;
    @track  oContractsAddresses;
    @track  subscription = null;
    spinnerLoad = true;

    @wire(getContractsAddresses) 
    wiredContractsAddresses({ error, data }) {
        if (data) {
            this.oContractsAddresses = JSON.parse(data);
            console.log('wire get addresses');
            console.log(this.oContractsAddresses);
            this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
            this.setDropdownValues();
        }
        else if (error) {
            console.log('Error get addresses');
            console.log(error);
            console.log(JSON.stringify(error));
        }
    }

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    connectedCallback() {

       this.handleSubscription();
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this, this.messageContext, this.handleLightningMessage);
        }
    } 

    handleLightningMessage(self, subscription, message) {

    }

    handlePublish(message) {
        publishMC(this.messageContext, message, 'SelectedPortfolio');
    }

    handleSelectedAddress() {
        const dropdownElement = this.template.querySelector('[data-id="dropdownAddr"]');
        if (dropdownElement) {
            this.handlePublish(dropdownElement.value);
        }
    }

    setDropdownValues() {
        const dropdownElement = this.template.querySelector('[data-id="dropdownAddr"]');
        let childOption;
        let portfolio;
        let local;
        if(this.oContractsAddresses._data)
            this.spinnerLoad = false;
        if (dropdownElement) {
        for (const keyPortfolio in this.oContractsAddresses._data) {
            portfolio = this.oContractsAddresses._data[keyPortfolio];
            for (const keyLocal in portfolio.locaux) {
                local = portfolio.locaux[keyLocal];
                childOption = document.createElement('option');
                childOption.value = portfolio.idPortefeuilleContrat;
                childOption.label = local.numeroVoie + ' ' + local.libelleVoie + ' ' + local.codePostal + ' ' + local.ville;
                    if (portfolio.idPortefeuilleContrat == this.idPortefeuilleContrat) {
                        childOption.selected = 'selected';
                    }
                dropdownElement.appendChild(childOption);
            }
        }
        this.handleSelectedAddress();
    }

    }

    @api switchStyle(styleName) {
      switchTheme.call(this, styleName);
    }
}