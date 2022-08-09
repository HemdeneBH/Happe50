/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-13-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import basePath from '@salesforce/community/basePath';

export default class hp_ec_menuItemMobile extends NavigationMixin(
    LightningElement
) {
    /**
     * The NavigationMenuItem from the Apex controller,
     * contains a label and a target.
     */
    @api item = {};
    @track theme;

    @track href = '#';

    /**
     * the PageReference object used by lightning/navigation
     */
    pageReference;


    connectedCallback() {
        const { type, target, defaultListViewId } = this.item;

        // get the correct PageReference object for the menu item type
        if (type === 'SalesforceObject') {
            // aka "Salesforce Object" menu item
            this.pageReference = {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: target
                },
                state: {
                    filterName: defaultListViewId
                }
            };
        } else if (type === 'InternalLink') {
            // aka "Site Page" menu item

            // WARNING: Normally you shouldn't use 'standard__webPage' for internal relative targets, but
            // we don't have a way of identifying the Page Reference type of an InternalLink URL
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: basePath + target
                }
            };
        } else if (type === 'ExternalLink') {
            // aka "External URL" menu item
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: target
                }
            };
        }

        // use the NavigationMixin from lightning/navigation to generate the URL for navigation.
        if (this.pageReference) {
            this[NavigationMixin.GenerateUrl](this.pageReference).then(
                (url) => {
                    this.href = url;
                }
            );
        }
    }

    handleNavigation() {
        this.dispatchEvent(new CustomEvent('navigation'));
    }

    handleClick(evt) {
        // use the NavigationMixin from lightning/navigation to perform the navigation.
        evt.stopPropagation();
        evt.preventDefault();
        this.handleNavigation();
        if (this.pageReference) {
            this[NavigationMixin.Navigate](this.pageReference);
        } else {
            console.log(
                `Navigation menu type "${
                    this.item.type
                }" not implemented for item ${JSON.stringify(this.item)}`
            );
        }

        const closeMenuEvent = new CustomEvent('closemenumobile');
        this.dispatchEvent(closeMenuEvent);
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