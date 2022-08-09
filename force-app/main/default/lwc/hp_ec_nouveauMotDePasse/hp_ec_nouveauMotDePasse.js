/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-24-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track } from 'lwc';
import HP_EC_black_logo from '@salesforce/resourceUrl/HP_EC_black_logo';
import sendResetPasswordEmail from '@salesforce/apex/HP_EC_Util_PasswordManager.sendResetPasswordEmail';
import {  NavigationMixin } from 'lightning/navigation';

export default class Hp_ec_nouveauMotDePasse extends NavigationMixin(LightningElement) {

    blackLogo = HP_EC_black_logo;
    @api titreNouveauMotDePasse;
    @api texteMention;
    @api placeHolderInputEmail;
    @api labelInputEmail;
    @api messageErreurInputEmail;
    @api messageConfirmation;

    @track email;
    @track showSuccess = false;
    @track showError = false;
    @track errorMessage = '';

    handleEmailInput(event){
        this.email = event.target.value;
    }

    isValidInput(){
        if(/^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,})$/.test(this.email) != true){
            this.showError = true;
            this.errorMessage = this.messageErreurInputEmail;
        }else{
            this.showError = false;
        }
        return !this.showError;
    }

    handleResetPassword(event){
        if(this.isValidInput()){
            sendResetPasswordEmail({contactEmail : this.email}).then(response=>{
                if(response.success == true){
                    this.showSuccess = true;
                    this.showError = false;
                    return;
                }else if(response.error == 'utilisateur non trouvé'){
                    this.showError = true;
                    this.showSuccess = false;
                    this.errorMessage = 'Aucun utilisateur associé avec cette adresse e-mail';
                    return;
                }else{
                    this.showError = true;
                    this.showSuccess = false;
                    this.errorMessage = 'Une erreure s\'est produite, merci de réessayer plus tard';
                    return;
                } 
             }).catch(error =>{
                   console.log('Error Setting Password : '+JSON.stringify(error));
               }); 
        }
    }
}