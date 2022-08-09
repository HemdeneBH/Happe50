import { LightningElement, api, track  } from 'lwc';

export default class Hp_ec_listPayements extends LightningElement {
    
        @api listPaymentsTitle;
        @api textRappel;
        @api messageListPayement;
        @api boutonListPaymentLabel;
        @api listPayements;
        @api amount;
        @api showListPayement;
        @api echeanceid;
        @api isEtatInactif;
        @api contact;
        @api payementModeTitle;
        @api montantToPaye;
        @api idPortefeuilleContrat;
        @api soldToDisplay;
        @api isShow;
     
         // Champs contribuables pour hp_ec_paymentModes : START //
         @api titreV1;
         @api titreV2;
     
         @api labelMoyenPaiement1;
         @api labelMoyenPaiement2;
         @api labelMoyenPaiement3;
         @api labelMoyenPaiement4;
         @api labelMoyenPaiement5;
     
         @api lienEnSavoirPlusPaiement1;
         @api lienEnSavoirPlusPaiement2;
         @api lienEnSavoirPlusPaiement3;
         @api lienEnSavoirPlusPaiement4;
         @api lienEnSavoirPlusPaiement5;
     
         @api showLienEnSavoirPlusPaiement1;
         @api showLienEnSavoirPlusPaiement2;
         @api showLienEnSavoirPlusPaiement3;
         @api showLienEnSavoirPlusPaiement4;
         @api showLienEnSavoirPlusPaiement5;
     
         @api textModePaiement;
         @api textDatePrelevementPart1;
         @api textDatePrelevementPart2;
         popinPayementMode = false;
         showListPayementInPopinMode = true;
         

         getReference(event){
          this.listPayements.forEach(elem => {
               if(elem.ref == event.target.value){
                    this.amount = (this.soldToDisplay - parseFloat(elem.montant)).toFixed(2);
                    this.montantToPaye = parseFloat(elem.montant);
                    if(this.montantToPaye <= 0){
                        this.isEtatInactif = true;
                      }
                      else{
                        this.isEtatInactif = false;
                      }
               }
          });
          
          this.echeanceid = event.target.value;

         }

         openPopinPayementMode () {
          this.popinPayementMode = true;
          this.closeListPaiementPopin();
      }
  
      closePopin (event) {
          event.preventDefault();
          event.stopPropagation();
          event.stopImmediatePropagation();
          this.popinPayementMode = false;
          if(event.detail == true){
            this.showListPayementInPopinMode = true;
          }
      }

      renderedCallback() {
          if (this.hasRenderedOnce) {
              return;
          }
          this.hasRenderedOnce = true;
  
                  // Change option selected
          const label = this.template.querySelector('.dropdown__filter-selected')
          const options = Array.from(this.template.querySelectorAll('.dropdown__select-option'))
  
          options.forEach((option) => {
              option.addEventListener('click', () => {
                  label.textContent = option.textContent
              })
          })
  
          // Close dropdown onclick outside
          this.template.addEventListener('click', (e) => {
              const toggle = this.template.querySelector('.dropdown__switch')
              const element = e.target
  
              if (element == toggle) return;
  
              const isDropdownChild = element.closest('.dropdown__filter')		
              
              if (!isDropdownChild) {
                  toggle.checked = false
              }
          })
      }

      closeListPaiementPopin() {
        this.showListPayementInPopinMode = false;
    }


     //  showPopinModePayement(){
     //      console.log('-showPopinModePayement ')
     //      const value = (!showListPayement || payementMode) ? true : false;
     //      return value;
     //  }
    
    }