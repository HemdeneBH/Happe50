/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/

import { LightningElement, track, api, wire} from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import HP_EC_chevron_right from '@salesforce/resourceUrl/HP_EC_chevron_right'

import getNavigationMenuItems from '@salesforce/apex/Hp_ec_menuItemsController.getNavigationMenuItems';
import isGuestUser from '@salesforce/user/isGuest';
import basePath from '@salesforce/community/basePath';


export default class Hp_ec_menu extends NavigationMixin(LightningElement){
    
    chevronRight = HP_EC_chevron_right;

    @api logo;
    @api titre;

    @api    menuMessage;
    @api    phoneNumber;
    @api    menuName;
    @api    mobileAppLink;
    @api    buttonRedirectPageAPIName;
    @api    buttonLabel;

    error;
    href = basePath;
    isLoaded;
    menuItems = [];
    publishedState;

    @wire(getNavigationMenuItems, {
        menuName: '$menuName',
        publishedState: '$publishedState'
    })
    wiredMenuItems({ error, data }) {
        if (data && !this.isLoaded) {
            this.menuItems = data
                .map((item, index) => {
                    return {
                        target: item.Target,
                        id: index,
                        label: item.Label,
                        defaultListViewId: item.DefaultListViewId,
                        type: item.Type,
                        accessRestriction: item.AccessRestriction
                    };
                })
                .filter((item) => {
                    // Only show "Public" items if guest user
                    return (
                        item.accessRestriction === 'None' ||
                        (item.accessRestriction === 'LoginRequired' &&
                            !isGuestUser)
                    );
                });
            this.error = undefined;
            this.isLoaded = true;
        } else if (error) {
            this.error = error;
            this.menuItems = [];
            this.isLoaded = true;
            console.log(`Navigation menu error: ${JSON.stringify(this.error)}`);
        }
    }

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        const app =
            currentPageReference &&
            currentPageReference.state &&
            currentPageReference.state.app;
        if (app === 'commeditor') {
            this.publishedState = 'Draft';
        } else {
            this.publishedState = 'Live';
        }
    }

    handleClick() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: this.buttonRedirectPageAPIName
            }
        });
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