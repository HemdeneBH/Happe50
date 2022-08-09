import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track, wire } from 'lwc';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import CONTACT_ID from '@salesforce/schema/User.ContactId';
import CONTACT_NAME from '@salesforce/schema/Contact.Name';
import CONTACT_REFERENCE_CLIENT from '@salesforce/schema/Contact.Identifiant_Buisness_Partener__c';

import HP_EC_AvantBold from '@salesforce/resourceUrl/HP_EC_AvantBold'
import HP_EC_AvantRegular from '@salesforce/resourceUrl/HP_EC_AvantRegular'

import HP_EC_app_logo from '@salesforce/resourceUrl/HP_EC_app_logo'

import HP_EC_chevron_right from '@salesforce/resourceUrl/HP_EC_chevron_right'

import HP_EC_white_logo from '@salesforce/resourceUrl/HP_EC_white_logo'
import HP_EC_black_logo from '@salesforce/resourceUrl/HP_EC_black_logo'

import HP_EC_icon_fox from '@salesforce/resourceUrl/HP_EC_icon_fox'
import HP_EC_icon_croco from '@salesforce/resourceUrl/HP_EC_icon_croco'
import HP_EC_icon_fish from '@salesforce/resourceUrl/HP_EC_icon_fish'
import HP_EC_icon_koala from '@salesforce/resourceUrl/HP_EC_icon_koala'
import HP_EC_icon_parrot from '@salesforce/resourceUrl/HP_EC_icon_parrot'

import HP_EC_icon_reindeer from '@salesforce/resourceUrl/HP_EC_icon_reindeer'
import HP_EC_icon_bear from '@salesforce/resourceUrl/HP_EC_icon_bear'
import HP_EC_icon_rat from '@salesforce/resourceUrl/HP_EC_icon_rat'
import HP_EC_icon_chick from '@salesforce/resourceUrl/HP_EC_icon_chick'
import HP_EC_icon_elephant from '@salesforce/resourceUrl/HP_EC_icon_elephant'

import HP_EC_icon_doggy from '@salesforce/resourceUrl/HP_EC_icon_doggy'
import HP_EC_icon_dog from '@salesforce/resourceUrl/HP_EC_icon_dog'
import HP_EC_icon_rabbit from '@salesforce/resourceUrl/HP_EC_icon_rabbit'
import HP_EC_icon_cow from '@salesforce/resourceUrl/HP_EC_icon_cow'
import HP_EC_icon_modify from '@salesforce/resourceUrl/HP_EC_icon_modify'

import USER_ID from '@salesforce/user/Id';

// We can get the community Id for use in the callout
import communityId from '@salesforce/community/Id';

// Get the base path for navigating to non-named pages
import communityBasePath from '@salesforce/community/basePath';


export default class hp_navigationMenu extends NavigationMixin(LightningElement){

    logoApp = HP_EC_app_logo;
    chevronRight = HP_EC_chevron_right;
    logoHappeWhite = HP_EC_white_logo;
    logoHappeBlack = HP_EC_black_logo;
    iconFox = HP_EC_icon_fox;
    iconParrot = HP_EC_icon_parrot;
    iconCroco = HP_EC_icon_croco;
    iconKoala = HP_EC_icon_koala;
    iconFish = HP_EC_icon_fish;
    iconBear = HP_EC_icon_bear;
    iconRabbit = HP_EC_icon_rabbit;
    iconDoggy = HP_EC_icon_doggy;
    iconDog = HP_EC_icon_dog;
    iconCow = HP_EC_icon_cow; 
    iconRat = HP_EC_icon_rat;
    iconReindeer = HP_EC_icon_reindeer;
    iconElephant = HP_EC_icon_elephant;
    iconChick = HP_EC_icon_chick;   
    HP_EC_AvantBold = HP_EC_AvantBold;
    HP_EC_AvantRegular = HP_EC_AvantRegular;
    iconModify = HP_EC_icon_modify;
    
    user;
    @track contactId;

    @api logo;
    @api titre;
    @api numTel;
    @api labelDashboard;
    @api labelMyContract;
    @api labelMyInvoice;
    @api labelMyDocuments;
    @api labelMyConsumption;
    @api labelMySponsorSpace;
    @api logoAppMobile;
    @api lienAppMobile

    @api nameClient;
    @api refClient;

    @wire(getRecord, { recordId: USER_ID, fields: [CONTACT_ID] })
    wiredBody({ error, data }) {
        if (data) {

            this.user = data;
            console.log('User : ', this.user);

            this.contactId = this.user.fields.ContactId.value;
            console.log('ContactId', this.user.fields.ContactId.value);

        } else if(error) {
            console.log('error', error)
        }
    }

    @wire(getRecord, { recordId: '$contactId', fields: [CONTACT_NAME, CONTACT_REFERENCE_CLIENT] })
    wiredContact({ error, data }) {
        if (data) {
            console.log('data', data);
            this.nameClient = data.fields.Name.value;
            this.refClient = data.fields.Identifiant_Buisness_Partener__c.value;
        } else if(error) {
            console.log('error', error)
        }
    }


    //Navigate to home page
    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }

    // Navigation to User Profile page
    navigateToUserProfile() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                pageName: 'User_Profile',
                recordId:  USER_ID,
                actionName: "view"
            },
        });
    }

    //Navigate to home page
    navigateToMyDashboardPage() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'HP_Dashboard__c'
            },
        });
    }
    
    // Navigation to HP_MyContract page
    navigateToMyContract() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'HP_MyContract__c'
            },
        });
    }

    // Navigation to HP_MyInvoice page
    navigateToMyInvoice() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'HP_MyInvoice__c'
            },
        });
    }

    // Navigation to HP_MyDocuments page
    navigateToMyDocuments() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'HP_MyDocuments__c'
            },
        });
    }

    // Navigation to HP_MyConsumption page
    navigateToMyConsumption() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'HP_MyConsumption__c'
            },
        });
    }
    
    // Navigation to HP_MySponsorSpace page
    navigateToMySponsorSpace() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'HP_MySponsorSpace__c'
            },
        });
    } 

}