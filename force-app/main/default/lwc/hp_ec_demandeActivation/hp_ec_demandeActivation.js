/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-03-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track } from 'lwc';
import HP_EC_black_logo from '@salesforce/resourceUrl/HP_EC_black_logo';
import reSendActivationEmail from '@salesforce/apex/HP_EC_Util_PasswordManager.reSendActivationEmail';

export default class Hp_ec_demandeActivation extends LightningElement {
    blackLogo = HP_EC_black_logo;
    @api titreNouveauMotDePasse;
    @api texteMention;
    @api placeHolderInputEmail;
    @api labelInputEmail;
    @api messageErreurInputEmail;
    @api messageConfirmation;
    @track email;
    @track showError = false;
    @track showSuccessMessage = false;
    @track errorMessage='';

    handleEmailInput(event){
        this.email = event.target.value;
    }

    isValidInput(){
        if(/^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,})$/.test(this.email) != true){
            this.showError = true;
            this.showSuccess = false;
            this.errorMessage = this.messageErreurInputEmail;
        }else{
            this.showSuccess = true;
            this.showError = false;
        }
        return !this.showError;
    }

    handleSendEmail(event){
        if(this.isValidInput()){
            reSendActivationEmail({contactEmail : this.email}).then(response=>{
                console.log(JSON.stringify(response));
                if(response.success == true){
                    this.showSuccessMessage = true;
                    this.showError = false;
                }else if(response.error == 'utilisateur non trouvé'){
                    this.showError = true;
                    this.showSuccessMessage = false;
                    this.errorMessage = 'Aucun utilisateur associé avec cette adresse e-mail';
                }else{
                    this.showError = true;
                    this.showSuccessMessage = false;
                    this.errorMessage = 'Une erreure s\'est produite, merci de réessayer plus tard';
                } 
            }).catch(error =>{
                console.log('Erreure Demande Activation : '+JSON.stringify(error));
            });
        } 
    }
}