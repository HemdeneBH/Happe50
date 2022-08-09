/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-31-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, wire, track } from 'lwc';
import HP_EC_black_logo from '@salesforce/resourceUrl/HP_EC_black_logo';
import { CurrentPageReference } from 'lightning/navigation';
import retrieveActivationParams from '@salesforce/apex/HP_EC_Util_PasswordManager.retrieveActivationParams';
import setPassword from '@salesforce/apex/HP_EC_Util_PasswordManager.setPassword';
import {  NavigationMixin } from 'lightning/navigation';
import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';

const DELAY = 5000;

export default class Hp_ec_activation extends NavigationMixin(LightningElement) {

   iconAlert = HP_EC_icon_alert;
   blackLogo = HP_EC_black_logo;
   @api titreActiverEspaceClient;
   @api placeHolderInputEmail;
   @api labelInputEmail;
   @api messageErreurInputEmail;
   @api messageConfirmation;
   @api labelInputIdentite;
   @api labelInputMDP;
   @api labelInputConfirmationMDP;
   @api placeHolderInputIdentite;
   @api placeHolderInputMDP;
   @api messageFormatIncorrecte;
   @api messageConfirmationIncorrecte;
   @api messageInfoBulle;
   @api messageErreurActivationExpiree;

   @track currentPageReference = null; 
   @track urlStateParameters = null;
   @track nameValue;
   @track emailValue;
   @track password;
   @track passwordConfirmation;
   @track showError = false;
   @track showSuccess = false;
   @track errorMessage;
   @track displayError = false;
 
   @track key;
 
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.key = this.urlStateParameters.key;
          retrieveActivationParams({key:this.key}).then(response=>{
             if(!response.error){
               this.nameValue = response.name ? response.name : this.placeHolderInputIdentite;
               this.emailValue = response.email ? response.email : this.placeHolderInputEmail;
               this.displayError = false;
             }else{
                this.displayError = true;
             }
            
          }).catch(error =>{
            console.log('Error Activation : '+JSON.stringify(error));
        })
       }
    }

    isInputValid() {
      if(this.passwordConfirmation != this.password){
         this.showError = true;
         this.errorMessage = this.messageConfirmationIncorrecte;
      }else if(/^(?=.{8,})(?=.*?\d)(?=.*[\s!\"#$\%&'\(\)\*\+\,\-\.\/\:;<=>?@\[\\\]\^\_\`\{\|\}\~])(?=[a-zA-Z0-9].*?[a-zA-Z0-9].*?[a-zA-Z0-9].*?).*$/.test(this.password) != true){
         this.showError = true;
         this.errorMessage = this.messageFormatIncorrecte;
      }else{
         this.showError = false;
      }
      return !this.showError;
  }

    submitPassword(event){
      if(this.isInputValid()){
         setPassword({key: this.key, password : this.password}).then(response=>{
            if(response.success == true){
               this.showSuccess = true;
               window.clearTimeout(this.delayTimeout);
               this.delayTimeout = setTimeout(() => {
                     this[NavigationMixin.Navigate]({
                        type: 'comm__namedPage',
                        attributes: {
                           name: 'Login'
                        },
                  });
               }, DELAY);
            }else{
               this.showError = true;
               this.errorMessage = 'Une erreure s\'est produite';
            }
         }).catch(error =>{
               console.log('Error Setting Password : '+JSON.stringify(error));
           })
      }      
    }

    handlePassword(event){
      this.password = event.target.value;
    }

    handlePasswordConfirmation(event){
       this.passwordConfirmation  = event.target.value;
    }

    handleNavigation(){
      this[NavigationMixin.Navigate]({
         type: 'comm__namedPage',
         attributes: {
             name: 'Demande_Activation__c'
         },
     });
    }
 
}