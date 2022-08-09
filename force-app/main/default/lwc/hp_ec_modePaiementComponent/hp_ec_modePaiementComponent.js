import { api, LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

import { publishMC, subscribeMC, unsubscribeMC } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getSoldeEffectifData from '@salesforce/apex/HP_EC_LoadCustomerData.getSoldeEffectifData';
import getFactureAgilabData from '@salesforce/apex/HP_EC_LoadCustomerData.getFactureAgilabData';
import getEcheanceContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getEcheanceContractData';
import getInfoContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getInfoContractData';
import getPorteFeuilleContrat from '@salesforce/apex/HP_EC_LoadCustomerData.getPorteFeuilleContratXdata';

export default class Hp_ec_modePaiementComponent extends NavigationMixin(LightningElement) {

  @wire(MessageContext) messageContext;

  @track version1 = false;
  @track version2 = false;

  @api titleV1;
  @api titleV2;

  @api textModePaiement;

  @track codeModeEncaissement;
  @track libelleModeEncaissement;
  @track datePrelevement;
  @track solde;

  @track etatDuService = 'Actif';  
  

  @api labelMoyenPaiement1;
  @api labelMoyenPaiement2;
  @api labelMoyenPaiement3;
  @api labelMoyenPaiement4;
  @api labelMoyenPaiement5;

  @api labelBoutonPaiement1;
  @api labelBoutonPaiement2;
  @api labelBoutonPaiement3;
  @api labelBoutonPaiement4;
  @api labelBoutonPaiement5;

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


  @api labelAideSolidariteLogement;
  @api labelCreditUtilise;
  @api labelCreditRestant;

  @api textDatePrelevementPart1;
  @api textDatePrelevementPart2;


  @track contractData;
  @track contractPortfolioData;
  @track InfoContractData;


  @track contractInfo;
  @track contractGaz;
  @track contractElec;
  @track actifPRTF;
  @track soldeEffectifData;
  @track factureAgilabData;
  @track echeanceContractData;


  @wire(getContractData)
  wiredContract({ error, data }) {
    if (data) {
      this.contractInfo = JSON.parse(data);
    } else if (error) {
      console.log(JSON.stringify(error));
    }
  }

  @wire(getSoldeEffectifData)
  wiredSoldeEffectifData({ error, data }) {
    if (data) {
      this.soldeEffectifData = JSON.parse(data);
    } else if (error) {
      console.log(JSON.stringify(error));
    }
  }

  async populateContractInfo() {
    console.log('Voici l\'id PorteFeuille sélectionné : '+ this.idPortefeuilleContrat);
    this.initializeComponantProperties();
    
    if(!this.contractInfo){
      this.contractInfo = await JSON.parse(this.getContractdata());
    }
    if(!this.idPortefeuilleContrat){
      return;
    }
    if(this.contractInfo){
      this.actifPRTF = await this.getPorteFeuilledata(this.idPortefeuilleContrat);
      console.log('this.actifPRTF : '+ JSON.stringify(this.actifPRTF));
      this.actifPRTF.codeModeEncaissement == '5' ? this.version2 = true : this.version1 = true;
      
      this.contractInfo._data.forEach(c => {
        if (c.idPortefeuilleContrat == this.idPortefeuilleContrat) {
            c.energie == 'Electricité' ? this.contractElec = c : this.contractGaz = c;
        }
      });

      if(this.version2) {
        if(this.contractElec) {
          console.log('this.contractElec.id : '+ this.contractElec.id);
          this.InfoContractData = await this.getInfoContractdata(this.contractElec.id.toString());
          console.log('this.InfoContractData for elec : ' + this.InfoContractData);
          if(this.InfoContractData?.output?.jour_drp) {
            this.datePrelevement = this.InfoContractData.output.jour_drp;
          }
        }
        if(this.contractGaz) {
          console.log('this.contractGaz.id : '+ this.contractGaz.id);
          this.InfoContractData = await this.getInfoContractdata(this.contractGaz.id.toString());
          console.log('this.InfoContractData for gaz : ' + JSON.stringify(this.InfoContractData));
          if(this.InfoContractData?.output?.jour_drp) {
            this.datePrelevement = this.InfoContractData.output.jour_drp;
          }
        }
      }

      if(this.version1) {
        if(!this.soldeEffectifData) {
          this.soldeEffectifData = await JSON.parse(this.getSoldeEffectifData());
        }
        if(this.etatDuService == 'Actif' && this.soldeEffectifData) {
          // console.log('this.soldeEffectifData : ' + JSON.stringify(this.soldeEffectifData));
          if(this.soldeEffectifData.output?.soldes) {
            this.soldeEffectifData.output.soldes.forEach(s => {
              let keys = Object.keys(s);
              for (let key of keys) {
                if(key == this.idPortefeuilleContrat) {
                  this.solde = s[key];
                }
              }
            });
            this.solde == 0 ? this.etatDuService = 'Inactif': this.etatDuService = 'Actif';
            console.log('this.etatDuService after solde check : '+this.etatDuService);
          }
        }
        if(this.etatDuService == 'Actif' && this.contractElec) {
          this.echeanceContractData = await this.getEcheanceContractData(this.contractElec.id.toString());
          console.log('this.echeanceContractData elec: ' + JSON.stringify(this.echeanceContractData));
                if (this.echeanceContractData.output) {
                  let keys = Object.keys(this.echeanceContractData.output);
                  let today_Date = new Date();
                  for (let key of keys) {
                    if (this.echeanceContractData.output[key].ouverture_cb != null) {
                      let ouvertureCB_Date = new Date(this.echeanceContractData.output[key].ouverture_cb);
                      ouvertureCB_Date > today_Date ? this.etatDuService = 'Inactif':this.etatDuService = 'Actif';
                    }
                  }
                }
          console.log('this.etatDuService after echeance elec check : '+this.etatDuService);
        }
        if(this.etatDuService == 'Actif' && this.contractGaz) {
          this.echeanceContractData = await this.getEcheanceContractData(this.contractGaz.id.toString());
          console.log('this.echeanceContractData gaz: ' + JSON.stringify(this.echeanceContractData));
          if (this.echeanceContractData.output) {
            let keys = Object.keys(this.echeanceContractData.output);
            let today_Date = new Date();
            for (let key of keys) {
              if (this.echeanceContractData.output[key].ouverture_cb != null) {
                let ouvertureCB_Date = new Date(this.echeanceContractData.output[key].ouverture_cb);
                ouvertureCB_Date > today_Date ? this.etatDuService = 'Inactif':this.etatDuService = 'Actif';
              }
            }
          }
          console.log('this.etatDuService after echeance gaz check : '+this.etatDuService);
        }
        if(this.etatDuService == 'Actif' && this.factureAgilabData == null) {
          this.factureAgilabData =  await this.getFactureData(this.idPortefeuilleContrat);
          console.log('this.factureAgilabData : ' + this.factureAgilabData);
          if(this.factureAgilabData?.output?.factures) {
            this.factureAgilabData.output.factures.forEach(f => {
              if( !(f.ouverture_cb == true && (f.statut == '1' || f.statut == '2')) ) {
                this.etatDuService = 'Inactif';
              }
            });
          }
        }
      }
    }
  }

  async getPorteFeuilledata(portefeuilleId){
    return new Promise(async (resolve, reject) => {
        var result = await getPorteFeuilleContrat({ contractPortfolioXdataId: portefeuilleId }).then(response => {
            return response;
        }).catch(error => {
            console.log('***Error getPorteFeuilleData : ' + JSON.stringify(error));
            return error;
        }); 
        resolve(result);
    })
  }

  async getFactureData(portefeuilleId){
    return new Promise(async (resolve, reject) => {
        var result = await getFactureAgilabData({ id_portefeuille_contrat_xdata: portefeuilleId }).then(response => {
            return response;
        }).catch(error => {
            console.log('***Error getFactureAgilabData : ' + JSON.stringify(error));
            return error;
        }); 
        resolve(result);
    })
  }

  async getContractdata(contractId){
    return new Promise(async (resolve, reject) => {
        var result = await getContractData({}).then(response => {
            return response;
        }).catch(error => {
            console.log('***Error getContractData : ' + JSON.stringify(error));
            return error;
        }); 
        resolve(result);
    })
  }

  async getSoldeEffectifData(contractId){
    return new Promise(async (resolve, reject) => {
        var result = await getSoldeEffectifData({}).then(response => {
            return response;
        }).catch(error => {
            console.log('***Error getSoldeEffectifData : ' + JSON.stringify(error));
            return error;
        }); 
        resolve(result);
    })
  }

  async getInfoContractdata(contractId){
    return new Promise(async (resolve, reject) => {
        var result = await getInfoContractData({ id_contrat_xdata: contractId }).then(response => {
            return response;
        }).catch(error => {
            console.log('***Error getPorteFeuilleData : ' + JSON.stringify(error));
            return error;
        }); 
        resolve(result);
    })
  }

  async getEcheanceContractData(contractId){
    return new Promise(async (resolve, reject) => {
        var result = await getEcheanceContractData({ id_contrat_xdata: contractId }).then(response => {
            return response;
        }).catch(error => {
            console.log('***Error getEcheanceContractData : ' + JSON.stringify(error));
            return error;
        }); 
        resolve(result);
    })
  }

  initializeComponantProperties() {
    this.version1 = false;
    this.version2 = false;
    this.actifPRTF = null;
    this.contractGaz = null;
    this.contractElec = null;
    this.datePrelevement = null;
    this.factureAgilabData = null;
    this.echeanceContractData = null;
  }

  connectedCallback() {
    this.handleSubscription(); 
  }
  handleSubscription() {
      if (!this.subscription) {
          subscribeMC(this,this.messageContext, this.handleLightningMessage);
      }
  } 
  handleLightningMessage(self,subscription, message) {
      if(message.messageType == 'SelectedPortfolio'){
          self.idPortefeuilleContrat = message.messageData.message;
          self.populateContractInfo();
      }
  }
  // handlePublish(message) {
  //     publishMC(this.messageContext, message, 'SelectedEnergy');
  // }

  handleNavigateEnSavoirPlusPaiement1() {
    const config = {
      type: 'standard__webPage',
      attributes: {
        url: this.lienEnSavoirPlusPaiement1
      }
    };
    this[NavigationMixin.Navigate](config);
  }

  handleNavigateEnSavoirPlusPaiement2() {
    const config = {
      type: 'standard__webPage',
      attributes: {
        url: this.lienEnSavoirPlusPaiement2
      }
    };
    this[NavigationMixin.Navigate](config);
  }

  handleNavigateEnSavoirPlusPaiement3() {
    const config = {
      type: 'standard__webPage',
      attributes: {
        url: this.lienEnSavoirPlusPaiement3
      }
    };
    this[NavigationMixin.Navigate](config);
  }

  handleNavigateEnSavoirPlusPaiement4() {
    const config = {
      type: 'standard__webPage',
      attributes: {
        url: this.lienEnSavoirPlusPaiement4
      }
    };
    this[NavigationMixin.Navigate](config);
  }

  handleNavigateEnSavoirPlusPaiement5() {
    const config = {
      type: 'standard__webPage',
      attributes: {
        url: this.lienEnSavoirPlusPaiement5
      }
    };
    this[NavigationMixin.Navigate](config);
  }

  get isEtatInactif(){
    if(this.etatDuService == 'Inactif')
      return true;

    return false;
  }

}