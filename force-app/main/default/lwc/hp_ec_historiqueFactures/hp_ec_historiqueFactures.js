/**
 * @description       : 
 * @author            : Zaatouche Younes
 * @group             : 
 * @last modified on  : 07-12-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

import { LightningElement, api, track, wire } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';

import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getFacture from '@salesforce/apex/HP_EC_LoadCustomerData.getFactureAgilabData';
import getPaiement from '@salesforce/apex/HP_EC_LoadCustomerData.getPaiement';
import getEcheance from '@salesforce/apex/HP_EC_LoadCustomerData.getEcheanceContractData';
import getPlansApurement from '@salesforce/apex/HP_EC_LoadCustomerData.getPlansApurement';
import getPorteFeuilleContratXdata from '@salesforce/apex/HP_EC_LoadCustomerData.getPorteFeuilleContratXdata';
import getContractDocumentsInfo from '@salesforce/apex/HP_EC_DocumentManager.getContractDocumentsInfo';

import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

export default class Hp_ec_historiqueFactures extends LightningElement {

    @api titleText;
    @api factureLabel; 
    @api paimentLabel;
    @api echeanceLabel;
    @api urlHelp;
    @api planApurementLabel;
    @api labelPopinTitle;
    @api labelPopinBouton;
    @api lienTarif;
    @api contenuToolTip;
    @api tarifURL;
    @track factures;
    @track paiements; 
    @track echeances; 
    @track plansApurement;
    @track contractData;
    @track contractDataToChild;
    @track containPlansApurement = false;
    @track modePaiementIsAnuel = false ;
    @track containEcheancier;
    @track documentsData;
    @track showHistoriqueFactPaiementPopin = false

    cpvUrl = '#'
    tabFactureIsShown = false;
    tabPaiementIsShown = false;
    tabEcheanceIsShown = false;
    tabPlanApurementIsShown = false;
    spinnerLoad = false;
    factureLink = [];
    apurementLink = [];
    echeanceLink = [];
    
    openFacture(event){
        this.showHistoriqueFactPaiementPopin = true;
        this.tabFactureIsShown = true;
        this.tabPaiementIsShown = false;
        this.tabEcheanceIsShown = false;
        this.tabPlanApurementIsShown = false;
    }

    opentPaiement(event){
        this.showHistoriqueFactPaiementPopin = true;
        this.tabPaiementIsShown = true;
        this.tabFactureIsShown = false;
        this.tabEcheanceIsShown = false;
        this.tabPlanApurementIsShown = false;
    }

    opentEcheance(event){
        this.showHistoriqueFactPaiementPopin = true;
        this.tabEcheanceIsShown = true;
        this.tabFactureIsShown = false;
        this.tabPaiementIsShown = false;
        this.tabPlanApurementIsShown = false;
    }

    openPlansApurement(event){
        this.showHistoriqueFactPaiementPopin = true;
        this.tabPlanApurementIsShown = true;
        this.tabFactureIsShown = false;
        this.tabPaiementIsShown = false;
        this.tabEcheanceIsShown = false;
    }

    openPopinHistoriqueFacturePaiement(event){
        if(event.detail === true){
            this.showHistoriqueFactPaiementPopin = true;
        }else {
            this.showHistoriqueFactPaiementPopin = false;
        }
    }

    @wire(getContractData)
     wiredContract({ error, data }) {
         if (data) {
             this.contractData = JSON.parse(data);
            } else if (error) {
                console.log('getContractData '+JSON.stringify(error));
            }
        }

   
    @wire(MessageContext) messageContext;
    connectedCallback() {
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.handleSubscription();
        this.populateContractInfo();
    }

    handleSubscription() {
        subscribeMC(this, this.messageContext, this.handleLightningMessage);
    }

    handleLightningMessage(self, subscription, message) {
        if (message.messageType == 'SelectedPortfolio') {
            self.idPortefeuilleContrat = message.messageData.message;
            self.populateContractInfo();
        }
    }

    handlePublish(message) {
        // publishMC(this.messageContext, message, 'SelectedEnergy');
    }

    initialiseGlobalVar(){
      this.factures = [];
      this.paiements = [];
      this.paiements = [];
      this.echeances = [];
      this.plansApurement = [];
      this.contractDataToChild = [];
      this.spinnerLoad = false;
      this.contractElec = null;
      this.contractGaz = null;
      this.documentsData = null;
      this.modePaiementIsAnuel = false;
      this.containEcheancier = false;
      this.containPlansApurement = false;
      this.factureLink = [];
      this.apurementLink = [];
      this.echeanceLink = [];

    }

    async populateContractInfo() {
      this.initialiseGlobalVar();
      if(!this.contractData) {
        this.spinnerLoad = true;
        const contractDataResult = await this.getContractData();
        this.contractData = JSON.parse(contractDataResult);
      }
      if(!this.idPortefeuilleContrat){
          return;
      }
      
      const factures = await this.getFacture();
       if (factures) {
        let myTab = JSON.parse(factures).output.factures;
        if (myTab.length != 0) {
          this.factures = [...myTab.map(v => ({ ...v, typeFact: this.getTypeFacutre(v.type_facture) }))];
          let today = new Date();
          for (let i = 0; i<this.factures.length; i++) {
            let currentDate = new Date(this.factures[i].date_limite_de_paiement);
            if(this.factures[i].energie == 'elec'){
              this.factures[i].enrg = 'ELECTRICITE';
            }
            else{
              this.factures[i].enrg = 'GAZ';
            }
            if( currentDate < today){
              this.factures[i].retard = true;
            }
            else{
              this.factures[i].retard = false;
            }
          }
        }

      }

      const plansApurementList = await this.getPlansApurement();
      if (plansApurementList) {
        let myTab = JSON.parse(plansApurementList).output.plans_apurement;
        this.containPlansApurement = false
        if (myTab.length > 0) {
          this.plansApurement = [...myTab.map(v => ({ ...v, montant: this.getMontantAurement(v.factures), refFact: this.getRefFactureForApurement(v.factures) }))];
          this.containPlansApurement = true;
        }
      } 
      
      if(this?.contractData.length !=0){
        this.spinnerLoad = false;
          let today = new Date();
          this.contractData._data.forEach(c => {
              let dateFinValidite = new Date(c.dateFinValidite);
              let diffTime = Math.abs(today - dateFinValidite);
              let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
              let isOldContract = (diffDays > 365) && (today > dateFinValidite) ;
              if ((c.codeStatutCrm == 'H0105' || c.codeStatutCrm == 'H0101' ||
              c.codeStatutCrm == 'H0102' || c.codeStatutCrm == 'E0004' || c.codeStatutCrm == 'E0007' || 
              ((c.codeStatutCrm == 'E0009' && isOldContract) || (c.codeStatutCrm == 'H0103' && isOldContract))) && 
              c.idPortefeuilleContrat == this.idPortefeuilleContrat) {
                  c.energie == 'Electricité' ? this.contractElec = c : this.contractGaz = c;
                  
              }
          });

          if(this.contractElec){
            if(!this.documentsData){
              this.documentsData = await this.getContractDocumentsInfo();
            }
            
            if (this.documentsData) {
              var echeanceElecLink = []
                for (let i = 0; i<this.documentsData.output.length; i++) {
                    if (this.documentsData.output[i].id_contrat_xdata == this.contractElec.id) {
                        let documents = this.documentsData.output[i].documents;
                        documents.forEach(c=>{
                          if(c.type_document == "1"){
                            this.factureLink.push(c);
                          }
                          if(c.type_document == "2"){
                            echeanceElecLink.push(c);
                          }
                          if(c.type_document == "3"){
                            this.apurementLink.push(c);
                          }
                        })
                    }
                }
            }
            this.factures = await this.addLinkToFacture(this.factures,this.factureLink);
            this.plansApurement = await this.addLinkToApurement(this.plansApurement,this.apurementLink);
            const paymentsList = await this.getPaiement(this.contractElec);
              if (paymentsList) {
                if (JSON.parse(paymentsList).output.paiements?.length !=0) {
                  let energie = this.contractElec.energie;
                  // const result = JSON.parse(JSON.stringify(paymentsList));
                  let myTab = JSON.parse(paymentsList).output.paiements;
                  if (myTab.length != 0) {
                    this.paiements = [...myTab.map(v => ({ ...v, enrg: energie, type: this.getTypePaiement(v.type_paiement) })),...this.paiements];
                    
                  }
                }
              }
              // const echeanceData = await this.getEcheanceData(this.contractElec);
              // if(!(JSON.parse(echeanceData).status == "FAILED")){
              //   const portfeilContractXdata = await this.getPorteFeuilleContratXdata(this.contractElec);
              //   if (portfeilContractXdata) {
              //     this.modePaiementIsAnuel = false;
              //     let modePaiement =  JSON.stringify(JSON.parse(portfeilContractXdata).libelleRythmeFacturation) 
              //     if (modePaiement == '"Annuel"') {
              //       this.modePaiementIsAnuel = true;
              //     }
              //   }
              //   let result = JSON.parse(echeanceData);
              //   if (result.output) {
              //     let keys = Object.keys(result.output);
              //     for (let key of keys) {
              //       result.output[key].enrg = this.contractElec.energie;
              //       this.echeances.push(result.output[key]);
                  
              //      }
                   
              //   } 
              // }
              // const tabEcheancier = [...echeanceElecLink.map(v => ({ ...v, enrg: 'Electricité'}))];
              // this.echeanceLink = tabEcheancier.sort((a,b)=>{
              //   return  a.id_document_agilab - b.id_document_agilab;
              // })
              // if(this.echeanceLink.length > 0){
              //   this.containEcheancier = true;
              // }
              
          }
          
          if(this.contractGaz){
            if(!this.documentsData){
              this.documentsData = await this.getContractDocumentsInfo();
            }
             if (this.documentsData) {
              var echeanceGazLink = []
                for (let i = 0; i<this.documentsData.output.length;i++) {
                    if (this.documentsData.output[i].id_contrat_xdata == this.contractGaz.id) {
                        let documents = this.documentsData.output[i].documents;
                        documents.forEach(c=>{
                          if(c.type_document == "1"){
                            this.factureLink.push(c);
                          }
                          if(c.type_document == "2"){
                            echeanceGazLink.push(c);
                          }
                          if(c.type_document == "3"){
                            this.apurementLink.push(c);
                          }
                        })
                    }
                }
            }
            this.factures = await this.addLinkToFacture(this.factures,this.factureLink);
            this.plansApurement = await this.addLinkToApurement(this.plansApurement,this.apurementLink);
            const paymentsList = await this.getPaiement(this.contractGaz);
            if (paymentsList) {
              if (JSON.parse(paymentsList).output.paiements?.length !=0) {
                let energie = this.contractGaz.energie;
                let myTab = JSON.parse(paymentsList).output.paiements;
                if (myTab.length != 0) {
                  this.paiements = [...myTab.map(v => ({ ...v, enrg: energie, type: this.getTypePaiement(v.type_paiement) })),...this.paiements]
                  
                }
              }
            }
              // const echeanceData = await this.getEcheanceData(this.contractGaz);
              // if(!(JSON.parse(echeanceData).status == "FAILED")){
              //   const portfeilContractXdata = await this.getPorteFeuilleContratXdata(this.contractGaz);
              //   if (portfeilContractXdata) {
              //     this.modePaiementIsAnuel = false;
              //     let modePaiement =  JSON.stringify(portfeilContractXdata.libelleRythmeFacturation) 
              //     if (modePaiement == '"Annuel"') {
              //       this.modePaiementIsAnuel = true
              //     }
              //   }
              //   let result = JSON.parse(echeanceData);
              //   if (result.output) {
              //     let keys = Object.keys(result.output);
              //     for (let key of keys) {
              //       result.output[key].enrg = this.contractGaz.energie;
              //       this.echeances.push(result.output[key]);
                  
              //      }
                   
              //   }
              // }
              
              
          }
          const tabEcheancier = [...echeanceGazLink.map(v => ({ ...v, enrg: 'gaz'})),...echeanceElecLink.map(v => ({ ...v, enrg: 'Electricité'}))];
              this.echeanceLink = tabEcheancier.sort((a,b)=>{
                return  a.id_document_agilab - b.id_document_agilab;
              })
              if(this.echeanceLink.length > 0){
                this.containEcheancier = true;
              }
        }
    }

    openTarifURL(){
        window.open(this.tarifURL, "_blank");
    }

    getTypeFacutre(type){
        switch (type) {
            case '0':
              return "Simulation"
              break;
            case '1':
                return "Régularisation"
            break;
            case '2':
              return "Intermédiaire"
            break;
            case '3':
              return "SimuMise en service / Contratlation"
            break;
            case '4':
              return "Rectificative"
            break;
            case '5':
              return "Résiliation"
            break;
            case "6":
              return "Avoir"
            break;
            case '7':
              return "Ajustement"
            break;
            case '8':
              return "Ponctuelle"
            break;
            case "9":
              return "Remise"
            break;
            case '10':
              return "Régularisation Anticipée"
            break;
            case "11":
              return "Facture bimestrielle"
            break;
            case '12':
              return "Facture de résiliation sur périodicité bimestrielle"
            break;
            case '13':
              return "Régularisation Bimestrielle"
            break;
        }
    }

    getTypePaiement(type){
        switch (type) {
            case '1':
              return "Carte Bancaire"
            break;
            case '2':
                return "Prélèvement"
            break;
            case '3':
              return "TIP Chèque"
            break;
            case '4':
              return "Virement"
            break;
            case '5':
              return "Espèces"
            break;
            case "6":
              return "Autre"
            break;
            case '7':
              return "Mensualisation"
            break;
            case '8':
              return "Compensation/Avoir"
            break;
            case "9":
              return "Chèque énergie"
            break;
            case '10':
              return "Recouvrement EFFICO"
            break;
            case "11":
              return "Paiement récurrent par carte bancaire"
            break;
            case '12':
              return "Chèque et espèces"
            break;
            case '13':
              return "Chèque énergie ASP"
            break;
            case '14':
              return "Paiement à plusieurs via ShareGroop"
            break;
            case '15':
              return "Recouvrement GERI"
            break;
        }
    }

    getMontantAurement(factures){
      let montant = 0.0
      factures.forEach(c => {
        montant = montant + c.montant_restant_du
      })
      return montant 
    }

    getRefFactureForApurement(factures){
      let tabRefFact = []
      factures.forEach(c => {
        tabRefFact.push(c.ref_facture)
      })
      let refFactures = tabRefFact.join(",")
      return refFactures 
    }

    async getContractData() {
      return new Promise(async (resolve, reject) => {
          var result = await getContractData()
              .then(data => {
                  return data;
              })
              .catch(error => {
                  console.log('error contract data: ' + JSON.stringify(error));
              });
          resolve(result);
      })
  }

    async getFacture() {
      return new Promise(async (resolve, reject) => {
          var result = await getFacture({ id_portefeuille_contrat_xdata: this.idPortefeuilleContrat.toString() })
              .then(data => {
                  return data;
              })
              .catch(error => {
                  console.log('error facture: ' + JSON.stringify(error));
              });
          resolve(result);
      })
  }

  async getEcheanceData(c) {
    return new Promise(async (resolve, reject) => {
        var result = await getEcheance({ id_contrat_xdata: c.id.toString() })
            .then(data => {
                return data;
            })
            .catch(error => {
                console.log('error Eéchéence: ' + JSON.stringify(error));
            });
        resolve(result);
    })
  }

  async getPorteFeuilleContratXdata(c) {
    return new Promise(async (resolve, reject) => {
        var result = await getPorteFeuilleContratXdata({ contractPortfolioXdataId: c.idPortefeuilleContrat })
            .then(data => {
                return data;
            })
            .catch(error => {
                console.log('error getPorteFeuilleContratXdata: ' + JSON.stringify(error));
            });
        resolve(result);
    })
  }
  
  async getPaiement(c) {
    return new Promise(async (resolve, reject) => {
        var result = await getPaiement({ idContratXdata: c.id })
            .then(data => {
                return data;
            })
            .catch(error => {
                console.log('error getPaiement: ' + JSON.stringify(error));
            });
        resolve(result);
    })
  }

  async getPlansApurement() {
    return new Promise(async (resolve, reject) => {
        var result = await getPlansApurement({ idPorteFueilleContrat: this.idPortefeuilleContrat })
            .then(data => {
                return data;
            })
            .catch(error => {
                console.log('error getPlansApurement: ' + JSON.stringify(error));
            });
        resolve(result);
    })
  }

  async getContractDocumentsInfo() {
    return new Promise(async (resolve, reject) => {
        var result = await  getContractDocumentsInfo({idPortfolio : this.idPortefeuilleContrat})
            .then(data => {
                return data;
            })
            .catch(error => {
                console.log('Erreur get document: ' + JSON.stringify(error));
            });
        resolve(result);
    })
  }

  async addLinkToFacture(tabToResolve, tabWithLink) {
    return new Promise(async (resolve, reject) => {
      tabToResolve.forEach((c,index) => {
        for(let i = 0; i < tabWithLink.length; i++){
          if(c.ref_facture == tabWithLink[i].reference_document){
            tabToResolve[index].link = tabWithLink[i].url_document;
            break;
          }
        }
      });
      resolve(tabToResolve);
    })
  }

  async addLinkToApurement(tabToResolve, tabWithLink) {
    return new Promise(async (resolve, reject) => {
      tabToResolve.forEach((c,index) => {
        for(let i = 0; i < tabWithLink.length; i++){
          if(c.id_plan_apurement == tabWithLink[i].reference_document){
            tabToResolve[index].link = tabWithLink[i].url_document;
            break;
          }
        }
      });
      resolve(tabToResolve);
    })
  }
  

}