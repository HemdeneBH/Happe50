/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-14-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track, wire } from 'lwc';

import ECAVATARMC from '@salesforce/messageChannel/hp_ec_avatarPortal__c';
import { MessageContext, subscribe, APPLICATION_SCOPE } from 'lightning/messageService';
import getAvatar from '@salesforce/apex/HP_EC_UpdateCustomerData.getAvatar';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

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

import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';


export default class Hp_ec_menuHeader extends NavigationMixin(LightningElement){

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
    iconModify = HP_EC_icon_modify;
    
    user;
    @track contactId;
    @track oContactData;
    @track userRef = '';
    @track userName = '';

    @api logo;
    @api titre;
    @api numTel;
    idTier;
    avatarToDisplay;

    @wire(MessageContext) context; 

    @wire(getContactData)   wiredContactData({ error, data }) {
        if (data) {
            this.oContactData = JSON.parse(data);
            this.setUserInfo();
        }
        else if (error) {
            console.log('Error get addresses');
            console.log(error);
            console.log(JSON.stringify(error));
        }
    }

    async getContactData() {
        return new Promise(async (resolve, reject) => {
            var result = await getContactData()
                .then(data => {
                    const contactData = JSON.parse(data);
                    return contactData;
                })
                .catch(error => {
                    console.log('error get contact data: ' + JSON.stringify(error));
                });
            resolve(result);
        })
    }

    @wire(getAvatar, { idTiers: '$idTier' })
    wiredGetAvatar({data, error}){
        if(data){
            this.avatarToDisplay = data.Avatar__c;

        }
        if (error) {
            console.log('Error : ' + JSON.stringify(error));
        }
    }

    async getAvatar() {
        return new Promise(async (resolve, reject) => {
            var result = await getAvatar({idTiers: this.userRef})
                .then(data => {
                    return data;
                })
                .catch(error => {
                    console.log('error get Avatar data: ' + JSON.stringify(error));
                });
            resolve(result);
        })
    }

    connectedCallback(){
        this.subscribMessage();
        this.populateInfo();
    }

    subscribMessage(){
        subscribe(this.context, ECAVATARMC, (message)=>{this.handelMessage(message)}, { scope: APPLICATION_SCOPE });
    }

    handelMessage(message){
        this.avatarToDisplay = message.selectedAvatar;
    }

    async populateInfo(){
        this.initialiseGlobalVar();
        if(!this.oContactData){
            this.oContactData = await this.getContactData();
            if(this.oContactData != null)
                this.setUserInfo();
        }
        if(this.userRef && !this.avatarToDisplay){
                const avatarData = await this.getAvatar();
                if(avatarData){
                    this.avatarToDisplay = avatarData.Avatar__c;
                }
                
        }
    }

    setUserInfo() {
        this.userName = this.oContactData.FirstName + ' ' + this.oContactData.LastName;
        this.userRef = this.oContactData.ID_Tiers__c;
    }

    initialiseGlobalVar(){
        this.avatarToDisplay = null;
        this.userName = null;
        this.userRef = null;
        this.oContactData = null;
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

    navigateToUserProfile(event){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Profil__c'
            },
        });
    }

}