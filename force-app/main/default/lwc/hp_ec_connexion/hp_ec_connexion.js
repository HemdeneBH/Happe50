/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-03-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track } from 'lwc';
import HP_EC_black_logo from '@salesforce/resourceUrl/HP_EC_black_logo';

import HP_EC_google_logo from '@salesforce/resourceUrl/HP_EC_google_logo';
import HP_EC_facebook_logo from '@salesforce/resourceUrl/HP_EC_facebook_logo';
import HP_EC_app_logo from '@salesforce/resourceUrl/HP_EC_app_logo';
import handleConnection from '@salesforce/apex/HP_EC_LoginFlowController.handleConnection';
import {  NavigationMixin } from 'lightning/navigation';


export default class Hp_ec_connexion extends NavigationMixin(LightningElement) {
    @api titreConnexion;
    @api labelInputEmail;
    @api placeHolderInputEmail;
    @api labelInputMDP;
    @api placeHolderInputMDP;
    @api labelBoutonPrimaire;
    @api labelMDPOoublie;
    @api labelEmailActivation;
    @api messageEchecConnexion;
    @api labelResterConnecte;
    @api labelLienAppMobile;
    @api lienGooglePlay;
    @api lienAppStore;
    @api messageEchecConnexionSocialMedia;

    blackLogo = HP_EC_black_logo;
    googleLogo = HP_EC_google_logo;
    facebookLogo = HP_EC_facebook_logo;
    logoApp = HP_EC_app_logo;
    @track showAppDownload = false;
    @track cssClass = 'hp-bloc-app-happe';

    @track login;
    @track password;
    @track showError = false;
    @track errorMessage;
    @track showSocialLogin = false;

    handleEmailChange(event){
        this.login = event.target.value
    }

    handlePasswordChange(event){
        this.password = event.target.value
    }

    openPopinApp(event){
        this.showAppDownload = !this.showAppDownload;
        if(this.showAppDownload == false){
            this.cssClass = 'hp-bloc-app-happe';
        }else{
            this.cssClass = 'hp-bloc-app-happe-green';
        }
    }

    closePopinApp(event){
        if(event.detail == true){
            this.showAppDownload = false;
            this.cssClass = 'hp-bloc-app-happe';
        }
    }

    handleSubmit(event){
        handleConnection({login : this.login, password : this.password}).then(response=>{
            if(response.success == true){
                this.showError = false;
                window.open(response.myPageUrl, "_self");
                this.errorMessage = undefined;
            }else{
                this.showError = true;
                this.errorMessage = this.messageEchecConnexion;
            }
            
        }).catch(error =>{
            console.log('Error Connection : '+JSON.stringify(error));
        })
    }

    handleForgotPassword(event){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Forgot_Password'
            },
        });
    }

    handleResendActivation(event){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Demande_Activation__c'
            },
        });
    }
 
}