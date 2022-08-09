/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 06-14-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

import { LightningElement, track, api, wire} from 'lwc';

import ECAVATARMC from '@salesforce/messageChannel/hp_ec_avatarPortal__c';
import { MessageContext, subscribe, APPLICATION_SCOPE } from 'lightning/messageService';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getAvatar from '@salesforce/apex/HP_EC_UpdateCustomerData.getAvatar';

import HP_EC_mail from '@salesforce/resourceUrl/HP_EC_icon_mail_blue_light'
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
import HP_EC_icon_call_blue from '@salesforce/resourceUrl/HP_EC_icon_call_blue_light'

import { loadScript } from 'lightning/platformResourceLoader';
import jQuery from '@salesforce/resourceUrl/HP_EC_jQuery';
import { switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';


/**
 * @slot menuMobile
 */

export default class Hp_ec_header extends LightningElement {

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
    iconCall = HP_EC_icon_call_blue;
    aideContactIcon = HP_EC_mail;

    @api helpLabel;
    @api contactButtonImg;
    @api disconnectLabel;
    @api phoneNumber;
    @api menuMessage;
    @api menuName;

    menu = false;
    contact = false;
    idTier;
    avatarToDisplay;

    @wire(MessageContext) context; 

    @wire(getContactData)
    wiredGetContactData({ data, error }) {
        if (data) {
            const result = JSON.parse(data);
            this.idTier = result.ID_Tiers__c;

        }
        if (error) {
            console.log('Error : ' + JSON.stringify(error));
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
            var result = await getAvatar({idTiers: this.idTier})
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
        if(!this?.idTier){
            const data = await this.getContactData();
            if(data)
                this.idTier = data.ID_Tiers__c;
        }
        if(this?.idTier && !this.avatarToDisplay){
                const avatarData = await this.getAvatar();
                if(avatarData){
                    this.avatarToDisplay = avatarData.Avatar__c;
                }
        }
    }

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        
        loadUserTheme.call(this);

        this.hasRenderedOnce = true;
        loadScript(this, jQuery)
        .then(() => {
            console.log('JQuery loaded.');
        })
        .catch(error=>{
            console.log('Failed to load the JQuery : ' +error);
        });
    }

    showMenu() {
        if(this.menu){
            this.menu = false;
        }else{
            this.menu = true;
            this.closeContactPopin();
        }
    }

    handleCloseMenuMobile(event) {
        this.menu = false;
    }

    showPopinProfil(event){
        this.menuProfilVisible = true;
    }
    openPopinProfil(event){
        if(event.detail === true){
            this.menuProfilVisible = true;
        }else {
            this.menuProfilVisible = false;
        }
    }
    closePopinProfile(event){
        this.dispatchEvent(new CustomEvent('openpopincprofil', { detail: false}));
    }


    @track menuProfilVisible = false;

    handleClick() {
        if(this.menuProfilVisible){
            this.menuProfilVisible = false;
        }else{
            this.menuProfilVisible = true;
            this.closeContactPopin();
        }
    }

    @api switchStyle(themeToSwitch) {
        switchTheme.call(this, themeToSwitch);
    }

    @api test() {
        console.log('Test successfull');
    }

    handleContactClick (event) {
        event.preventDefault();
        if (this.contact) {
            this.dispatchEvent(new CustomEvent('closepopin', { detail: true, bubbles: true, composed: true}));
        } else {
            this.dispatchEvent(new CustomEvent('openpopin', {
                detail: { popinID : 'contact' },
                bubbles: true,
                composed: true
            }));
        }
        this.contact = !this.contact;
    }
    closeContactPopin(){}
}