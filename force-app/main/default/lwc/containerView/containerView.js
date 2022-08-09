import { NavigationMixin } from "lightning/navigation";
import { LightningElement, api, track, wire } from 'lwc';
import rechercherContratLightning from "@salesforce/apex/SM_AP53_ContratWS.rechercherContratLightning";
import callSmileHeaderLigthning from "@salesforce/apex/SM_AP67_SmileHeader.callSmileHeaderLigthning";
import getLocauxContrats from "@salesforce/apex/SM_AP71_LocauxContratsApiService.callLocauxContrats";
import getFacturationsPaiements from "@salesforce/apex/SM_AP74_FacturationsPaiementsApiService.callFacturationsPaiements";
import getFacturationsMensualisees from "@salesforce/apex/SM_AP75_FacturationsMApiService.callFacturationsMensualisees";
// import getPrestEnergie from "@salesforce/apex/SM_AP73_GetPrestGazApiService.getPrestEnergie";
// import getSolde from "@salesforce/apex/SM_AP76_GetSoldeService.getSolde";
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
import getServices from "@salesforce/apex/SM_AP78_TranquilityApiService.callTranquility";
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";
import getNotesDebitsCredits from "@salesforce/apex/SM_AP87_NotesDebitsCredits.getNotesDebitsCredits";
// Import message service features required for publishing and the message channel	
import { createMessageContext, releaseMessageContext, publish, subscribe } from 'lightning/messageService';	
import containerToContactMessageChannel from '@salesforce/messageChannel/sm_containertocontact__c';
import PopUp_for_clientVIP from '@salesforce/label/c.SM_CL46_PopUp_for_clientVIP';
import PopUp_for_Retractation from "@salesforce/label/c.SM_CL95_PopUp_for_Retractation";
import irrecouvrable from '@salesforce/label/c.SM_CL93_irrecouvrable';
import callPersonne from "@salesforce/apex/SM_AP29_PersonnesAPI.callPersonneApi";
import hasPermissionEnableLwcAcquisition from '@salesforce/customPermission/SM_EnableLwcAcquisition';


export default class ContainerView extends NavigationMixin(LightningElement) {
  label = {
    PopUp_for_clientVIP,
    PopUp_for_Retractation
}

  listVipCode = ['V1','V2','V3'];
  @api recordId;
  @api rythmeFacturation;
  @track recordId;
  @track data = null;
  @track listRecord = [];
  @track isActive = null;
  @track index;
  @track selectedItem;
  @track firstListAdresses;
  @track secondListAdresses = [];
  @track longList = false;
  @track fullSize = 0;
  @track secondListSize = 0;
  @track openSecondAdresses = false;
  @track progress = 0;
  @track oldindex = 0;
  @track error = false;
  @track errorMessage = null;
  @track contratsWSResponse = null;
  @track newEmmenagement = false;
  @track isContratsManaged = false;
  @track codeClient;
  @track estClientEHS = false;	
  @track estConnuEHS = false;
  @track listOrderedAdresses;
 
  @track DossierRecouvrement;
  @track idPlanPaiement;
  @track isRetractation;

  statutInternaute='';
  isHasEnCours = false;
  test;

  isContactArchive=false;
  clientVIPMessage=this.label.PopUp_for_clientVIP;
  retractationMessage=this.label.PopUp_for_Retractation;
  context = createMessageContext();

  connectedCallback() {
		var self = this;
    // Listener pour capter l'event de raffrachissement de la vue 360
    window.addEventListener("message", function(event){
			if (event.data !== undefined && event.data["OmniScript-Messaging"] !== undefined && event.data["OmniScript-Messaging"].ContextId !== undefined && event.data["OmniScript-Messaging"].ContextId === self.recordId) {
        // console.log("Refresh: connectedCallBack");
			  self.initContainerView();
        self.getCustomerInfos();
      }
		}, false);
    // console.log("Init: connectedCallBack");
    self.initContainerView();
		this.getCustomerInfos();
  }



  disconnectedCallback() {
    releaseMessageContext(this.context);
  }
  get isClientVip() { return this.listVipCode.includes(this.codeClient)}
  //init values vue 360 
  initContainerView() {
    this.data = null;
    this.listRecord = [];
    this.isActive = null;
    this.index = '';
    this.selectedItem = null;
    this.firstListAdresses = [];
    this.secondListAdresses = [];
    this.longList = false;
    this.fullSize = 0;
    this.secondListSize = 0;
    this.openSecondAdresses = false;
    this.progress = 0;
    this.oldindex = 0;
    this.error = false;
    this.errorMessage = null;
    this.contratsWSResponse = null;
    this.isContratsManaged = false;
    this.newEmmenagement = false;
    this.iswarning=false;
    this.isRetractation=false;
  }
  getNotesDebitsCredits() {
    //console.log('## idsfcontact ' + this.recordId);
    this.listRecord[this.index].iswarning =false;
    getNotesDebitsCredits({
      idPortefeuilleContrat: this.listRecord[this.index].IdPortefeuilleContrat
    }).then( result => {
        if ( result !== undefined ) {
          let formNotesDebitsCredits = JSON.parse(JSON.stringify(result));
          for (let i = 0; i < formNotesDebitsCredits.x_data.length; i++) {

              if (formNotesDebitsCredits.x_data[i].statut === 'Validé auto.' || formNotesDebitsCredits.x_data[i].statut === 'Validé' || formNotesDebitsCredits.x_data[i].statut === 'A valider' || formNotesDebitsCredits.x_data[i].statut === 'Refusé' || formNotesDebitsCredits.x_data[i].statut === 'Erreur' || formNotesDebitsCredits.x_data[i].statut === 'Erreur auto') {

                this.listRecord[this.index].iswarning = true;
              }
              if (formNotesDebitsCredits.x_data[i].dateSaisie && formNotesDebitsCredits.x_data[i].dateSaisie.indexOf('-') > 0) {
                  const d = formNotesDebitsCredits.x_data[i].dateSaisie.split('-');
                  formNotesDebitsCredits.x_data[i].dateSaisie = d[2] + '/' + d[1] + '/' + d[0];
              }
              if (formNotesDebitsCredits.x_data[i].dateValidation && formNotesDebitsCredits.x_data[i].dateValidation.indexOf('-') > 0) {
                  const d = formNotesDebitsCredits.x_data[i].dateValidation.split('-');
                  formNotesDebitsCredits.x_data[i].dateValidation = d[2] + '/' + d[1] + '/' + d[0];
              }
          }
          this.listRecord[this.index].notesDebitsCredits= formNotesDebitsCredits;        
        }
    }).catch(error => {
        console.log("got error note debit credit ", error);
    });
  }

  getDossiersAffaire() {

    

    if(this.listRecord && this.listRecord[0] && this.listRecord[0].hasDossiersAffaire === undefined){

      this.listRecord[0].hasDossiersAffaire = false;

    let inputRechercherDA = {
      idPersonne: this.listRecord[0].IdBusinessPartner,
      typeDossierAffaire: 'ZSOL'
    };

    callIP({ inputMap: inputRechercherDA, NameIntergation: 'IP_SM_Rechercher_Dossier_Affaire_SOAP' })
      .then(result => {
        if(result !== undefined){
       
        
        if(result.RechercherDAResponse.listIdsDossierAffaire.length>0 || (result.RechercherDAResponse && result.RechercherDAResponse.listIdsDossierAffaire && result.RechercherDAResponse.listIdsDossierAffaire.idDossierAffaire)){
        this.listRecord[0].hasDossiersAffaire = true;
        }
        
      }
      })
      .catch(error => {
        console.log("got error getDossiersAffaire", error);
      });

    }
  
  }

	/**
	 * Récupération des informations à afficher dans la vue 360
	 */
	getCustomerInfos() {
    this.getClientRetractation(this.recordId);    
    callSmileHeaderLigthning({inputMap: { Id: this.recordId, options: { chainable: false } }}).then(result => {
      if (result !== undefined) {
        console.log(result);
          this.progress = 30;
          this.index = 0;
          let listidsPortefeuilles = [];
          let idPortefeuille;
          if (result.IsArchiveCNIL) {
            this.isContactArchive = result.IsArchiveCNIL;
          }
          if (result.Statut_Internaute) {
            this.statutInternaute = result.Statut_Internaute;
          }

          if (!this.isContactArchive) {
          if (result.Result && result.Result.length) {
            for (const record of result.Result) {
              idPortefeuille = record.IdPortefeuilleContrat
                  ? record.IdPortefeuilleContrat
                  : "";
              listidsPortefeuilles.push(idPortefeuille);
              if (idPortefeuille || (!idPortefeuille && record.FlagCreationContratEnCours)) {
                if(record.FlagCreationContratEnCours) {
                  this.isHasEnCours = true;
                }
                record.EnqSat={};
                record.EnqSat.isPreleve=0;
                record.EnqSat.isMensualise=0;
                record.EnqSat.serDatRegPer=0;
                record.EnqSat.factureEnLigne=0;
                record.EnqSat.clientCapEcoConso=0;
                record.EnqSat.assurenceFacture=0;
                record.EnqSat.clientMaReleve=0;
                record.EnqSat.statutInternaute=0;
                record.EnqSat.isDepannageElec=0;
                record.EnqSat.isDepannageGaz=0;
                record.EnqSat.gazpar=0;
                record.EnqSat.linky=0;
                record.EnqSat.lbGaz=null;
                record.EnqSat.codeGaz=null;
                record.EnqSat.lbElec=null;
                record.EnqSat.codeElec=null;

                this.listRecord.push(record);
              }
            }
            const data = {
              idBp: result.Result[0].IdBusinessPartner,
              origineAppel: "Vue360"
            };
            // Appel temporaire WS contrats pour récuperer les informations CRM 
            this.getContratWS(data);
          } else {
            listidsPortefeuilles.push(
                result.Result.IdPortefeuilleContrat
                ? result.Result.IdPortefeuilleContrat
                : ""
            );
            if (result.Result.IdPortefeuilleContrat || (!result.Result.IdPortefeuilleContrat && result.Result.FlagCreationContratEnCours)) {
              this.listRecord.push(result.Result);
              this.listRecord[0].selected = true;
                this.listRecord[0].key = 0;
                this.listRecord[0].EnqSat={};
                this.listRecord[0].EnqSat.isPreleve=0;
                this.listRecord[0].EnqSat.isMensualise=0;
                this.listRecord[0].EnqSat.serDatRegPer=0;
                this.listRecord[0].EnqSat.factureEnLigne=0;
                this.listRecord[0].EnqSat.clientCapEcoConso=0;
                this.listRecord[0].EnqSat.assurenceFacture=0;
                this.listRecord[0].EnqSat.clientMaReleve=0;
                this.listRecord[0].EnqSat.statutInternaute=0;
                this.listRecord[0].EnqSat.isDepannageElec=0;
                this.listRecord[0].EnqSat.isDepannageGaz=0;
                this.listRecord[0].EnqSat.gazpar=0;
                this.listRecord[0].EnqSat.linky=0;
                this.listRecord[0].EnqSat.lbGaz=null;
                this.listRecord[0].EnqSat.codeGaz=null;
                this.listRecord[0].EnqSat.lbElec=null;
                this.listRecord[0].EnqSat.codeElec=null;

              if(result.Result.FlagCreationContratEnCours && !result.Result.IdPortefeuilleContrat) {
                this.isHasEnCours = true;
                this.progress = 100;
                

                if (this.listRecord[0].NoCompteContrat) {
                  this.listRecord[0].NoCompteContratMaj = this.listRecord[0].NoCompteContrat.substring(this.listRecord[0].NoCompteContrat.length - 9, this.listRecord[0].NoCompteContrat.length);
                }
                this.firstListAdresses = this.listRecord;
              }
            }
            if (result.Result.IdPortefeuilleContrat) {
              const data = {
                idBp: result.Result.IdBusinessPartner,
                origineAppel: "Vue360"
              };
              //Appel temporaire WS contrats pour récuperer les informations CRM 
              this.getContratWS(data);
            }
          }
          // console.log("first list Record...");
          // console.log(this.listRecord)
          if (listidsPortefeuilles.toString().replace(/,/g, '').length > 0) {
            // console.log("Ancien client");
            this.callIP({ CompteClient: this.listRecord[0].NoCompteContrat}, 'IP_SM_RechDossierRecouvrement_SOAP');
            this.callIP({ idPersonne: this.listRecord[0].IdBusinessPartner}, 'IP_SM_RechercherPC_WS');
            this.fullSize = this.listRecord.length;
            //Appel API locaux Contrats pour toutes les adresses
            getLocauxContrats({
                inputMap: { idsPortefeuilleContrat: listidsPortefeuilles.filter(Boolean).join(",")}
            })
            .then(resultLocaux => {
              if (resultLocaux.resultdata && resultLocaux.resultdata.length) {
                // console.log("resultLocaux");
                // console.log(resultLocaux);
                this.progress += 40;
                this.isActive = resultLocaux.resultdata[0].IdLocal;
                // this.listRecord[0].selected = true;
                //A revoir
                this.listRecord[this.index].load = true;
                this.listRecord[this.index].key = this.index;
                this.resetFlyout(this.index);
                for (let i = 0; i < this.fullSize; i++) {
                  this.listRecord[i].loadcontrat = true;
                  let tempResponse = resultLocaux.resultdata.filter(local => local.idPortefeuilleContrat === this.listRecord[i].IdPortefeuilleContrat);
                  // console.log("filtre retour API");
                  if (tempResponse && tempResponse.length > 0) {
                    let customObject = {};
                    customObject = {...tempResponse[0], ...{ListContrats: tempResponse}};
                    this.listRecord[i] = { ...this.listRecord[i], ...customObject };
                    console.log('customObject');
                    console.log(this.listRecord);
                  }
                }
                this.listRecord.forEach(function(record, i) {
                  record.key = i;
                  //Suppression des 0 sur le Numero compte Contrat
                  if (record.NoCompteContrat) {
                    record.NoCompteContratMaj = record.NoCompteContrat.substring(record.NoCompteContrat.length - 9, record.NoCompteContrat.length);
                  }

                });
                // Gestion des contrats
                if (this.contratsWSResponse) {
                  this.manageContrat(this.contratsWSResponse);
                }

                // On vérifie si on a géré les contrats ou pas encore (par la fonction manageContrat)
                // On fait cette vérification pour éviter le double appel de la fonction orderLogement dans le cas ou le ws de récupération des contrats répond tard (getContratWS())
                if(this.isContratsManaged) {
                  this.OrderLogements();
                }

                //Appel API Personne v1 (client EHS + VIP)
                this.callApiPersonneWS(this.recordId);
                //send data to contactview360
                let felNumber = this.listRecord[0].factureEnLigne;
                const message = {
                  recordid : this.recordId,
                  edoc: this.listRecord.length > 0 && this.listRecord[0].eDocument ? true : false,
                  fel: felNumber === '0001' || felNumber === '0002' || felNumber === '0004' ? true : false,
                  account: this.listRecord[0].NoCompteContratMaj,
                  estClientEHS: this.estClientEHS,
                  estConnuEHS: this.estConnuEHS,
                  codeClient: this.codeClient
                };
                publish(this.context, containerToContactMessageChannel, message);
                } else {
                  this.error = true;
                  this.errorMessage = 'Désolé, les informations de notre fournisseur de données sont momentanément indisponibles.'
                }
            }).catch(error => {
              console.log("got error getLocauxContrats", error);
              this.errorMessage = 'Désolé, les informations de notre fournisseur de données sont momentanément indisponibles.'
              this.error = true;
            });
            // On a commenté cet appel parce qu'on fait l'appel du ws à partir de la méthode OrderLogement
            //récuperer information solde
            //this.getSolde(this.index);
            //this.getNotesDebitsCredits();
          } else if(!this.isHasEnCours){
            // console.log("nouveau client");
            this.newEmmenagement = true;
            this.errorMessage = "Ce client ne dispose pas de logement."
            this.progress = 100;
          }
      } else {
            console.log("contact archivé CNIL");
            this.progress = 100;
            this.errorMessage = 'Fiche client inaccessible pour raison d\'archivage CNIL. Veuillez créer une nouvelle fiche client.'
            this.error = true;          
          }
      } else {
          //Traitement d'erreur de récuperation des données de salesforce à traiter
          console.log("error load Local");
      }
    }).catch(error => {
      console.log("got error callSmileHeaderLigthning", error);
      this.errorMessage = 'Désolé, les informations de notre fournisseur de données sont momentanément indisponibles.'
      this.error = true;
    });
  }
  get showBody () {
    return !this.error && this.selectedItem && !this.newEmmenagement && (!this.selectedItem.FlagCreationContratEnCours || (this.selectedItem.FlagCreationContratEnCours && this.selectedItem.IdPortefeuilleContrat));

  }

  get isFlagCreationContratEnCours () {
    let isFlag = false;
    if ( this.listRecord[this.index] && this.listRecord[this.index].FlagCreationContratEnCours  && !this.listRecord[this.index].IdPortefeuilleContrat) {
      isFlag = true;
      this.progress = 100;
    }

    return isFlag;
  }

  partielResetFlyout(type) {
    let listFlyout = ['closepce', 'closepdl', 'closegaz', 'closeelec', 'closeservice', 'closemensualisation'];
    for (const flyout of listFlyout) {
        if(('close' + type) !== flyout && this.selectedItem[flyout]) {
            this.selectedItem[flyout] = false;
        }
    }
  }
  popupEvent(event) {
    this.partielResetFlyout(event.detail.type);
    this.selectedItem['close'+ event.detail.type] = !this.selectedItem['close'+ event.detail.type];
    this.listRecord[this.index]['close'+ event.detail.type] = this.selectedItem['close'+ event.detail.type];
  }
    //Appel pour récuperer le solde d'une seule adresse
    //index: l'index de l'adresse dans l'objet listRecord
  getSolde(index) {
    //recuperer le solde

    let inputSolde = {
      CompteClient: this.listRecord[index].NoCompteContrat,
      IdPortefeuilleContrat: this.listRecord[index].IdPortefeuilleContrat
    };
    // getSolde({ inputMap: inputSolde })
    callIP({ inputMap: inputSolde, NameIntergation: 'IP_SM_CompteClient_Solde' })
      .then(result => {
        // console.log('solde......');
        // console.log(result);
        
        this.progress += 10;
        this.listRecord[index].solde = result.LireCompteClientReturn
          ? result.LireCompteClientReturn
          : {};
        // Added by RJM FT2-668
        this.listRecord[index].firstBlocage = result.FirstBlocage ?  result.FirstBlocage : {};
        
        //
        this.selectedItem = this.listRecord[index];
      })
      .catch(error => {
        console.log("got error getSolde", error);
      });
  }

  //FT2-1307 Afficher présence Payeur divergent sur vue 360
  getPayeurDivergent(index) {
    //recuperer le Payeur Divergent
    console.log('payeur divergent');

    let inputPayeurDivergent = {
      idCompteClient: this.listRecord[index].NoCompteContrat,
    };
    callIP({ inputMap: inputPayeurDivergent, NameIntergation: 'IP_SM_PorteFeuilleContrat_Smile' })
      .then(result => {
        
        this.listRecord[index].payeurdivergent = result.PaiementFacturation ? result.PaiementFacturation : {};
        this.selectedItem = this.listRecord[index].payeurdivergent;
      })
      .catch(error => {
        console.log("got error getPayeurDivergent", error);
      });
  }



  getLastPlanMensualise() {
    if (this.listRecord[this.index].lirePlanMensualisationResponse && this.listRecord[this.index].lirePlanMensualisationResponse.length) {
      for (const item of this.listRecord[this.index].lirePlanMensualisationResponse) {
        if (!this.listRecord[this.index].dernierPlanMensualisation && new Date(item.dateEcheance) >= new Date() ) {
          this.listRecord[this.index].dernierPlanMensualisation = item;
        } else if (new Date(item.dateEcheance) >= new Date() && new Date(item.dateEcheance) < new Date(this.listRecord[this.index].dernierPlanMensualisation.dateEcheance)) {
          this.listRecord[this.index].dernierPlanMensualisation = item;
        }
      }
    }
  }
  handleSecondAdresses() {
    this.openSecondAdresses = !this.openSecondAdresses;
  }
  //Naviger dans les adresse
  //A ce stade on chage d'index et on fait les appels WS s'il sont pas déjà faits
  handleActive(event) {
    this.getRecouvrement(this.listRecord);
    let index = Number.parseInt(event.currentTarget.id.split("-")[0]);
    if (this.oldindex !== index && !Number.isNaN(index)) {
      this.index = index;
      this.oldindex = index;
      for (let y = 0; y < this.listRecord.length; y++) {
        this.resetFlyout(y);
      }
      this.selectedItem = this.listRecord[index];
      if (!this.listRecord[index].load) {
        this.progress = 70;
        // const data = {
        //   PersonneIdentifier: this.listRecord[index].IdBusinessPartner,
        //   idBp: this.listRecord[index].IdBusinessPartner,
        //   NoCompteClient: this.listRecord[index].NoCompteContrat,
        //   idPortefeuille: this.listRecord[index].IdPortefeuilleContrat,
        //   origineAppel: "Vue360"
        // };
        // this.getContratWS(index, data);
        this.getSolde(index);
        this.getPayeurDivergent(index);//FT2-1307 Afficher présence Payeur divergent sur vue 360
        this.getServices(this.selectedItem);
        this.callIP({CompteClient: this.listRecord[this.index].NoCompteContrat}, 'IP_SM_RechDossierRecouvrement_SOAP');
                
        

        this.getPlanMensualisation();
        this.getNotesDebitsCredits();
        //this.getContratWS(index, data);
        //Call prestation Gaz et elec
        //A Revoir
        if(this.selectedItem.contratactifgazWS) {
            let inputMap = {
                PCE: this.selectedItem.contratactifgazWS.numeroPointDeLivraison,
                PersonneIdentifier: this.selectedItem.IdBusinessPartner
            };
            this.getPrestEn(index, inputMap, 'gaz', 'IP_SM_Prestation_Gaz_SOAP');
        }
        if(this.selectedItem.contratactifelecWS) {
            let inputMap = {
                PDL: this.selectedItem.contratactifelecWS.numeroPointDeLivraison,
                PersonneIdentifier: this.selectedItem.IdBusinessPartner
            };
            this.getPrestEn(index, inputMap, 'elec', 'IP_SM_Prestation_Elec_SOAP');
        }
      }
      this.listRecord[index].load = true;
      this.listRecord[index].selected = true;
      this.selectedItem = this.listRecord[index];
      this.openSecondAdresses = false;
      if (this.fullSize > 3) {
        this.longList = true;
        this.secondListSize = this.fullSize - 3;
        this.firstListAdresses = this.listRecord.slice(0, 3);
        this.secondListAdresses = this.listRecord.slice( 3, this.fullSize );
      } else {
        this.firstListAdresses = this.listRecord;
      }
      let felNumber = this.selectedItem.factureEnLigne;
      const message = {
        recordid : this.recordId,
        edoc: this.selectedItem.eDocument ? true : false,
        fel: felNumber === '0001' || felNumber === '0002' || felNumber === '0004' ? true : false,
        account: this.selectedItem.NoCompteContratMaj,
        estClientEHS: this.estClientEHS,
        estConnuEHS: this.estConnuEHS,
        codeClient: this.codeClient
      };
      publish(this.context, containerToContactMessageChannel, message);
      // console.log(this.listRecord);
    }
  }
  //Appel pour récuperer prestation sur le contrat Activé ou Mes en cours
  //index: l'index de l'adresse dans l'objet listRecord
  //inputMap: les information à passer en entrées pour le service
  //type: le type peux être 'elec' ou 'gaz'
  getPrestEn(index, inputMap, type, name) {
    callIP({ inputMap: inputMap, NameIntergation: name })
    // getPrestEnergie({ inputMap: inputMap, type: type })
      .then(result => {
        if (type === "gaz") {
          this.listRecord[index]["itemPrest" + type] = result.resultdata
            ? result.resultdata.Gaz
            : null;
          if (this.listRecord[index]["itemPrest" + type]) {
            this.listRecord[index]["loadPrest" + type] = true;
          }
        } else {
          this.listRecord[index]["itemPrest" + type] = result.resultdata
            ? result.resultdata.Elec
            : null;
          if (this.listRecord[index]["itemPrest" + type]) {
            this.listRecord[index]["loadPrest" + type] = true;
          }
        }
        this.selectedItem = this.listRecord[index];
      })
      .catch(error => {
        console.log("got error getPrestation", error);
      });
  }
  //Rénitiliser les flyouts de toutes les adresses à fermer
  resetFlyout(index) {
    this.listRecord[index].selected = false;
    this.listRecord[index].closepce = false;
    this.listRecord[index].closepdl = false;
    this.listRecord[index].closegaz = false;
    this.listRecord[index].closeelec = false;
    this.listRecord[index].closeservice = false;
    this.listRecord[index].closemensualisation = false;
  }
  //Open Emmenagement Omniscript movein
  //Déclanche un évenement vers le composant aura (composant parent)
  handleOpenEmmenagement() {
    console.log('### hangle pset ' + hasPermissionEnableLwcAcquisition);
    setCache().then(r => {
      const eventName = "openmoveinemmenagement";
      const inputMap = {
        callType: "New",
        fullSize: this.fullSize,

        AccountId: this.listRecord.length > 0 && this.listRecord[this.index].AccountId ? this.listRecord[this.index].AccountId : '' ,

        eDocument: this.listRecord.length > 0 && this.listRecord[0].eDocument ? true : false,
        EnqSat: this.listRecord.length > 0 && this.listRecord[0].EnqSat,
        enableLwcAcquisition: hasPermissionEnableLwcAcquisition
      };
      const event = new CustomEvent(eventName, {
        bubbles: true,
        composed: true,
        detail: inputMap,
        
      });
    this.dispatchEvent(event);
    })
    .catch(error => {
        console.log("got error setCache", error);
    });
  }
  handleOpenEmmenagementNew() {
    setCache().then(r => {
      // console.log(r);
      const eventName = "openmoveinemmenagementnew";
      const inputMap = {
        callType: "New",
        fullSize: this.fullSize
      };
      const event = new CustomEvent(eventName, {
        bubbles: true,
        composed: true,
        detail: inputMap
      });
      this.dispatchEvent(event);
    })
    .catch(error => {
        console.log("got error cache", error);
    });
  }
  manageFacturation(type, index) {
    this.listRecord[index].rythmeFacturation = type;
      if(type === 'A'){
          this.listRecord[index].modePaiement = 'mensualisé'; 
          this.listRecord[index].EnqSat.isMensualise=1;
      }
      else{
          if(this.listRecord[index].modeEncaissement === 'P'){
            this.listRecord[index].modePaiement = 'Prélevé'; 
            this.listRecord[index].EnqSat.isPreleve=1;

          }
          else if(this.listRecord[index].modeEncaissement !== undefined) {
            this.listRecord[index].modePaiement = 'Non prélevé';
          } else {
            this.listRecord[index].modePaiement = 'Mode de paiement indisponible.'
          }
      }
      // periodeFacturation
      if(type === 'S'){
        this.listRecord[index].periodeFacturation = 'FACTURATION TOUS LES 6 MOIS'; 
      }
      else if(type === 'B'){
        this.listRecord[index].periodeFacturation = 'FACTURATION TOUS LES 2 MOIS'; 
      }
  }
  callIP(params, name, callback) {
    callIP({ inputMap: params, NameIntergation: name })
      .then(result => {
        // console.log(name);
        // console.log(result);
        if(result.success !== false || name=='IP_SM_RechDossierRecouvrement_SOAP'){
        
          this.listRecord[this.index].returnrecouvrement=result.LireCompteClientReturn;
         this.DossierRecouvrement=this.listRecord[this.index].returnrecouvrement;


        }
        if( result.success !== false || name === 'IP_SM_RechercherPC_WS' ) {
          this.listRecord[this.index] = { ...this.listRecord[this.index], ...result };
          if(callback) {
            this.listRecord[this.index].loadMensualisee = true;
            this.listRecord[this.index].mensualisations = (this.listRecord[this.index].lirePlanMensualisationResponse && this.listRecord[this.index].lirePlanMensualisationResponse.length) ? this.listRecord[this.index].lirePlanMensualisationResponse : [];
            this.getLastPlanMensualise();
          }
          this.selectedItem = this.listRecord[this.index];
        }
        //A revoir
        // this.progress += 20;
      })
      .catch(error => {
        if (callback) {
          this.listRecord[this.index].loadMensualisee = true;
        }
        console.log("got error callIP ", name , error);
      });
  }
  callAPIPaiement(listidsPortefeuilles) {
    getFacturationsPaiements({ inputMap: {  idsPortefeuilleContrat: listidsPortefeuilles.filter(Boolean).join(",") } }).then(result => {
      // console.log("API paiement APIHOUR.......");
      // console.log(result);
      if ( result.resultdata && result.resultdata.length > 0 ) {
        for(let j = 0 ; j < result.resultdata.length; j++) {                    
          for (let i = 0; i < this.fullSize; i++) {
            if ( result.resultdata[j].idPortefeuilleContrat ===  this.listRecord[i].IdPortefeuilleContrat ){
              this.listRecord[i].loadFacture = true;
              if(result.resultdata[j] && result.resultdata[j].conditionPaiement && result.resultdata[j].conditionPaiement !== '+14B') {
                this.listRecord[i].EnqSat.serDatRegPer=1;
                this.listRecord[i].conditionPaiementMaj = 'Date de règlement personnalisée :   le '+ result.resultdata[j].conditionPaiement.substring(1, 3);
              } else if ( result.resultdata[j] && result.resultdata[j].conditionPaiement === undefined ) {
                  this.listRecord[i].conditionPaiementMaj = 'Information DRP indisponible';
              }              
              this.listRecord[i] = { ...this.listRecord[i], ...result.resultdata[j] };
            }
          }
        }
      }
      //Si le retour de l'API est null
      if(result.resultdata.length === 0 || listidsPortefeuilles.length > result.resultdata.length) {
        for(let j = 0 ; j < listidsPortefeuilles.length; j++) {
          for (let i = 0; i < this.fullSize; i++) {
            if ( listidsPortefeuilles[j] ===  this.listRecord[i].IdPortefeuilleContrat ){
                this.listRecord[i].loadFacture = true;
            }
          }
        }
      }
      // console.log("result Prélevé....");
      // console.log(this.listRecord[this.index]);
      this.getDossiersAffaire();
      this.selectedItem = this.listRecord[this.index];
    })
    .catch(error => {
        // this.listRecord[i].modePaiement = 'Mode de paiement indisponible.';
        this.listRecord[this.index].loadFacture = true;
        console.log("got error getFacturationsPaiements", error);
    });
  }
  getServices(element) {
    let inputMapServices = {
      bpClient: element.IdBusinessPartner/*'306429631'*/,
      numRue: element.numeroVoie/*'22'*/,
      rue: element.libelleVoie/*'RUE D AQUITAINE'*/,
      codePostal: element.codePostal/*'36000'*/,
      commune: element.ville/*'CHATEAUROUX'*/,
    }
    this.listRecord[this.index].titreService = 'SERVICES ET OPTIONS';
    let listServicesActif = [];
    let listServicesInactif = [];
    let listAllServices = [] ;
    //ADE enquete de satisfaction
    if(this.listRecord[this.index].EnqSat === undefined){
      this.listRecord[this.index].EnqSat = {};
    }
    this.listRecord[this.index].EnqSat.statutInternaute=this.statutInternaute === 'Oui' ? 1 : 0;


    if (this.listRecord[this.index].factureEnLigne === '0001') {
      this.listRecord[this.index].EnqSat.factureEnLigne=1;
      listServicesActif.push({
      libOffreMaj: 'FACTURE EN LIGNE',
        actif: true
      });
    }
    if(this.listRecord[this.index].clientMaReleve) {
      this.listRecord[this.index].EnqSat.clientMaReleve =1;
      listServicesActif.push({
        libOffreMaj: 'M@ RELEVE',
        actif: true
      });
    }
    if(this.listRecord[this.index].clientZenBox) {
      listServicesActif.push({
        libOffreMaj: 'ZENBOX',
        actif: true
      });
    }
    if(this.listRecord[this.index].clientCapEcoConso) {
      this.listRecord[this.index].EnqSat.clientCapEcoConso=1;
      listServicesActif.push({
        libOffreMaj: 'CAP ECO CONSO',
        actif: true
      });
    }
    let prev_facture = -1;
    let prev_facture2 = -1;
    let prev_factureResil = -1;
    let prev_factureResil2 = -1;
    this.listRecord[this.index].assurenceFacture = 0;
    if(this.listRecord[this.index].contratsService) {
      for(let i = 0; i < this.listRecord[this.index].contratsService.length ; i++) {
        // SI PREV_FACT et E0004 
        let contrat = this.listRecord[this.index].contratsService[i];
        if(contrat.codeOffre === 'PREV_FACT' && contrat.statutCode === 'E0004') {
          prev_facture =  i;
          this.listRecord[this.index].EnqSat.assurenceFacture = 1;

        } else if (contrat.codeOffre === 'PREV_FACT' && contrat.statutCode === 'E0009') {
          prev_factureResil = i;
        }// SI PREV_FACT2 et E0004
        else if(contrat.codeOffre === 'PREV_FACT2' && contrat.statutCode === 'E0004') {
          prev_facture2 =  i;
          this.listRecord[this.index].EnqSat.assurenceFacture = 1;

        } else if(contrat.codeOffre === 'PREV_FACT2' && contrat.statutCode === 'E0009') {
          prev_factureResil2 =  i;
        }
      }
    }
    //if prev_fact & prev_fact2
    if (/*prev_facture > -1 &&*/ prev_facture2 > -1) {
      // let dateEffetMaj = this.listRecord[this.index].contrats[prev_facture].dateDebutContrat.split('-');
      listServicesActif.push({
        libOffreMaj: 'ASSURANCE FACTURE (2 assurés)',
        actif: true,
        dateEffetMaj: this.listRecord[this.index].contratsService[prev_facture2].dateDebutContrat/*dateEffetMaj[2] + '/' + dateEffetMaj[1] + '/' + dateEffetMaj[0]*/
      });
    //if prev_fact
    } else if (prev_facture > -1) {
      // let dateEffetMaj = this.listRecord[this.index].contrats[prev_facture].dateDebutContrat.split('-');
      listServicesActif.push({
        libOffreMaj: 'ASSURANCE FACTURE',
        actif: true,
        dateEffetMaj: this.listRecord[this.index].contratsService[prev_facture].dateDebutContrat/*dateEffetMaj[2] + '/' + dateEffetMaj[1] + '/' + dateEffetMaj[0]*/
      });
    }
    if (/*prev_facture > -1 &&*/ prev_factureResil2 > -1) {
      // let dateEffetMaj = this.listRecord[this.index].contrats[prev_facture].dateDebutContrat.split('-');
      listServicesInactif.push({
        libOffreMaj: 'ASSURANCE FACTURE (2 assurés)',
        actif: false,
        dateEffetMaj: this.listRecord[this.index].contratsService[prev_factureResil2].dateDebutContrat,/*dateEffetMaj[2] + '/' + dateEffetMaj[1] + '/' + dateEffetMaj[0]*/
        dateResiliationMaj: this.listRecord[this.index].contratsService[prev_factureResil2].dateFinContrat
      });
    //if prev_fact
    } else if (prev_factureResil > -1) {
      // let dateEffetMaj = this.listRecord[this.index].contrats[prev_facture].dateDebutContrat.split('-');
      listServicesInactif.push({
        libOffreMaj: 'ASSURANCE FACTURE',
        actif: false,
        dateEffetMaj: this.listRecord[this.index].contratsService[prev_factureResil].dateDebutContrat,/*dateEffetMaj[2] + '/' + dateEffetMaj[1] + '/' + dateEffetMaj[0]*/
        dateResiliationMaj: this.listRecord[this.index].contratsService[prev_factureResil].dateFinContrat
      });
    }
    //if prev_fact2
    // } else if ( prev_facture2 > -1) {
    //   let dateEffetMaj = this.listRecord[this.index].contratsService[prev_facture2].dateDebutContrat.split('-');
    //   listServicesActif.push({
    //     libOffreMaj: 'ASSURANCE FACTURE',
    //     actif: true,
    //     dateEffetMaj: dateEffetMaj[2] + '/' + dateEffetMaj[1] + '/' + dateEffetMaj[0]
    //   });
    // }
    getServices({ inputMap: inputMapServices})
      .then(result => {
        this.progress += 20;
        this.listRecord[this.index].loadService = true; 
        console.log('Result tranquility : ' + JSON.stringify(result) ) ; 
        if (result && result.return && result.return.messageRetour && result.return.messageRetour.code === 'SUCCESS' && result.return.retour.contratList) {
          for(let contrat of result.return.retour.contratList){
                listAllServices.push(contrat) ; 
          }

          for (let service of result.return.retour.contratList) {
            let dateEffet = service.dateEffet.split('-');
            service.libOffreMaj = this.manageServices(service);
            if(!service.DateResiliation && service.libOffreMaj && service.etatContrat && service.etatContrat.etat === 6) {
              service.actif = true;
              service.dateEffetMaj = dateEffet[2] + '/' + dateEffet[1] + '/' + dateEffet[0];
              listServicesActif.push(service);
            } else if (service.libOffreMaj && service.DateResiliation){
              let dateResiliation  = service.dateResiliation.split('-');
              service.dateResiliationMaj = dateResiliation[2] + '/' + dateResiliation[1] + '/' + dateResiliation[0];
              service.dateEffetMaj = dateEffet[2] + '/' + dateEffet[1] + '/' + dateEffet[0];
              listServicesInactif.push(service);
            }
          }
          listServicesActif = listServicesActif.sort((a, b) => new Date(b.dateEffet) - new Date(a.dateEffet));
          listServicesInactif = listServicesInactif.sort((a, b) => new Date(b.dateEffet) - new Date(a.dateEffet));
        }
        let listJoint = [...listServicesActif, ...listServicesInactif]
        this.listRecord[this.index].listTranquilityServices = listAllServices; 
        this.listRecord[this.index].listServices = listJoint;
        this.listRecord[this.index].listServicesCard = listJoint.slice(0, 4).filter((ser) => {return ser.libOffreMaj != 'FACTURE EN LIGNE'}); // FT1-4372 --> Assurance facture absente de la vue 360
        let servicesActifCount = listServicesActif.length;
        let servicesInactifCount = listServicesInactif.length;
        //FT3-1606 DEQ
        //this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? ('SERVICE ('+ servicesActifCount + ' actif' + (servicesActifCount > 1?'s, ':', ') + servicesInactifCount + ' résilié' + (servicesInactifCount > 1?'s)':') ET OPTIONS')) : 'SERVICES ET OPTIONS';
        this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? 'SERVICE ': 'SERVICES ET OPTIONS';
        this.selectedItem = this.listRecord[this.index];
        //A revoir
        // this.progress += 20;
      })
      .catch(error => {
        this.listRecord[this.index].loadService = true;
        let listJoint = [...listServicesActif, ...listServicesInactif] 
        this.listRecord[this.index].listTranquilityServices = listAllServices; 
       this.listRecord[this.index].listServices = listJoint;
        this.listRecord[this.index].listServicesCard = listJoint.slice(0, 4).filter((ser) => {return ser.libOffreMaj != 'FACTURE EN LIGNE'}); // FT1-4372 --> Assurance facture absente de la vue 360
        let servicesActifCount = listServicesActif.length;
        let servicesInactifCount = listServicesInactif.length;
        //FT3-1606[Moteur de recommandation] DEQ 
        //this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? ('SERVICE ('+ servicesActifCount + ' actif' + (servicesActifCount > 1?'s, ':', ') + servicesInactifCount + ' résilié' + (servicesInactifCount > 1?'s)':')')) : 'SERVICES ET OPTIONS';
       // 
        this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? 'SERVICE ': 'SERVICES ET OPTIONS';
        this.selectedItem = this.listRecord[this.index];
        this.listRecord[this.index].errorService = "Informations services indisponible pour le moment."; 
        console.log("got error Services " , error);
      });
      let listJoint = [...listServicesActif, ...listServicesInactif]
      this.listRecord[this.index].listServices = listJoint;
      this.listRecord[this.index].listServicesCard = listJoint.slice(0, 4).filter((ser) => {return ser.libOffreMaj != 'FACTURE EN LIGNE'}); // FT1-4372 --> Assurance facture absente de la vue 360
      let servicesActifCount = listServicesActif.length;
      let servicesInactifCount = listServicesInactif.length;
      //FT3-1606 DEQ
      //this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? ('SERVICE ('+ servicesActifCount + ' actif' + (servicesActifCount > 1?'s, ':', ') + servicesInactifCount + ' résilié' + (servicesInactifCount > 1?'s)':')')) : 'SERVICES ET OPTIONS';
      this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? 'SERVICE ': 'SERVICES ET OPTIONS';
      this.selectedItem = this.listRecord[this.index];
  }
  manageServices (service) {
    let libelle = '' 
    switch (service.idOffre){
      case 'DEOG0':
        libelle = 'DEGEX+';
        break;
      case 'DEO0':
        libelle = 'DEPEX+';
        break;
      case 'DEG0':
        libelle = 'DEGEX';
        this.listRecord[this.index].EnqSat.isDepannageGaz = 1;
        break;
      case 'DE0':
        libelle = 'DEPEX';
        this.listRecord[this.index].EnqSat.isDepannageElec = 1;
        break;
      case 'GE0':
        libelle = 'GEM';
        break;
      case 'SC3':
        libelle = 'Entretien Chaudière Sérénité';
        break;
      case 'SC4':
        libelle = 'Entretien Chaudière Essentiel';
        break;
      case 'SC5':
        libelle = 'Entretien Chaudière Intégral';
        break;
      case 'PC3':
        libelle = 'Pack Chaudière Tout Inclus';
        break;
      case 'PC1':
        libelle = 'Pack Chauffage Tout Inclus';
        break;
      default:
          libelle = '';
    }
    return libelle;
  }
  // Appel WS contrats d'une seule adresse
  // index: l'index de l'adresse dans l'objet listRecord
  // data: les information à passer en entrées pour le service
  getContratWS(data) {
    rechercherContratLightning({ inputMap: data })
      .then(result => {
        // console.log("service Contrat WS");
        // console.log(result);
        // this.progress += 20;
        if (this.listRecord[this.index].loadcontrat) {
          // console.log("traitement dans contrats ws");
          this.manageContrat(result.resultdata);
          this.OrderLogements();

        } else {
          this.contratsWSResponse = result.resultdata ? result.resultdata : [];
        }
      })
      .catch(error => {
        for(let record of this.listRecord) {
          record.errorContratWs = true;
        }
        console.log("got error getContratsWS", error);
      });
  }
  manageContrat (contrats) {
    if (contrats && contrats.length > 0) {
      for (let contrat of contrats) {

        let temp = this.listRecord.filter(local => local.NoCompteContratMaj === contrat.idPortefeuilleContrat.toString());
        if (temp.length && temp[0].ListContrats && temp[0].ListContrats.filter(local => local.numeroPointDeLivraison === contrat.numeroPointDeLivraison).length && (contrat.typeContrat === "E" || contrat.typeContrat === "GN") ) {
          temp = temp[0];



          contrat.typeCompteur = temp.ListContrats.filter(local => local.numeroPointDeLivraison === contrat.numeroPointDeLivraison)[0].typeCompteur;
          contrat.codeNiveauService = temp.ListContrats.filter(local => local.numeroPointDeLivraison === contrat.numeroPointDeLivraison)[0].codeNiveauService;
          contrat.systemeInfoContractuel = temp.ListContrats.filter(local => local.numeroPointDeLivraison === contrat.numeroPointDeLivraison)[0].systemeInfoContractuel;
          contrat.uniteReleve = temp.ListContrats.filter(local => local.numeroPointDeLivraison === contrat.numeroPointDeLivraison)[0].uniteReleve;
          // console.log(contrat.statutCode, '----', contrat.typeContrat)
          // Added by RJM (FT2-998) 
         // temp.EnqSat={};
         // temp.EnqSat.gazpar=0;
          if(!contrat.dateFinContrat && (contrat.statutCode === "E0005" || contrat.statutCode === "E0006") ){
              if(contrat.typeContrat === "GN") { 
            temp.contratactifgazWS = contrat;
            temp.EnqSat.gazpar = temp.contratactifgazWS.typeCompteur === 'GAZPAR' ? 1 : 0;
            temp.perimetrePCE = false;
              }
              else if(contrat.typeContrat === "E"){
                 temp.contratactifelecWS = contrat; 
                 if((temp.contratactifelecWS.systemeInfoContractuel === 'GINKO' && 
              (temp.contratactifelecWS.codeNiveauService === '2' || temp.contratactifelecWS.codeNiveauService === '1')) 
              ||(temp.contratactifelecWS.systemeInfoContractuel === 'DISCO' && temp.contratactifelecWS.codeNiveauService === '1')
              ||(temp.contratactifelecWS.TypeCompteur === 'LINKY' && temp.contratactifelecWS.codeNiveauService === '0')){
                temp.EnqSat.linky = 1;
          } 
              }
          }
          else if(contrat.dateFinContrat && (contrat.statutCode === "E0005" || contrat.statutCode === "E0006")){
              if(contrat.typeContrat === "GN") { 
              temp.contratinactifgazWS = contrat;
              temp.EnqSat.gazpar = (!temp.contratactifgazWS && temp.contratinactifgazWS.typeCompteur === 'GAZPAR') ? 1 : 0;
              if(!temp.contratactifgazWS) {
                temp.perimetrePCE = true;
              }
            } else if(contrat.typeContrat === "E"){
              temp.contratinactifelecWS = contrat; 
              if((temp.contratinactifelecWS.systemeInfoContractuel === 'GINKO' && 
              (temp.contratinactifelecWS.codeNiveauService === '2' || temp.contratinactifelecWS.codeNiveauService === '1')) 
              ||(temp.contratinactifelecWS.systemeInfoContractuel === 'DISCO' && temp.contratinactifelecWS.codeNiveauService === '1')
              ||(temp.contratinactifelecWS.TypeCompteur === 'LINKY' && temp.contratinactifelecWS.codeNiveauService === '0')){
                temp.EnqSat.linky = 1;
              } 
            }
          }
          //
          else if ( contrat.statutCode !== "E0002" && contrat.statutCode !== "E0009" && contrat.statutCode !== "H0106" &&  contrat.typeContrat === "GN" ) {
                temp.contratactifgazWS = contrat;
                temp.EnqSat.gazpar = temp.contratactifgazWS.typeCompteur === 'GAZPAR' ? 1 : 0;
                temp.perimetrePCE = false;
            
          } else if ((contrat.statutCode === "E0002" || contrat.statutCode === "E0009" || contrat.statutCode === "H0106") &&  contrat.typeContrat === "GN" ) {
            if (
              !temp.contratinactifgazWS ||( contrat.dateFinContrat &&
              new Date( contrat.dateFinContrat.split("/")[1]+ '/' + contrat.dateFinContrat.split("/")[0] + contrat.dateFinContrat.split("/")[2] ) >
              new Date( temp.contratinactifgazWS.dateFinContrat.split("/")[1]+ '/' + temp.contratinactifgazWS.dateFinContrat.split("/")[0] + temp.contratinactifgazWS.dateFinContrat.split("/")[2] ))) {
              temp.contratinactifgazWS = contrat;
              temp.EnqSat.gazpar = (!temp.contratactifgazWS && temp.contratinactifgazWS.typeCompteur === 'GAZPAR') ? 1 : 0;
              if(!temp.contratactifgazWS) {
                temp.perimetrePCE = true;
              }
            }
          } else if (contrat.statutCode !== "E0002" && contrat.statutCode !== "E0009" && contrat.statutCode !== "H0106" && contrat.typeContrat === "E") {
            // Added by RJM (FT2-998) 
            
            temp.contratactifelecWS = contrat; 
            if((temp.contratactifelecWS.systemeInfoContractuel === 'GINKO' && 
            (temp.contratactifelecWS.codeNiveauService === '2' || temp.contratactifelecWS.codeNiveauService === '1')) 
            ||(temp.contratactifelecWS.systemeInfoContractuel === 'DISCO' && temp.contratactifelecWS.codeNiveauService === '1')
            ||(temp.contratactifelecWS.TypeCompteur === 'LINKY' && temp.contratactifelecWS.codeNiveauService === '0')){
              temp.EnqSat.linky = 1;
        } 

            //
          } else if ((contrat.statutCode === "E0002" || contrat.statutCode === "E0009" || contrat.statutCode === "H0106") && contrat.typeContrat === "E") {
            
            if (
              !temp.contratinactifelecWS || ( contrat.dateFinContrat &&
              new Date(contrat.dateFinContrat.split("/")[1]+ '/' + contrat.dateFinContrat.split("/")[0] + contrat.dateFinContrat.split("/")[2]) >
              new Date( temp.contratinactifelecWS.dateFinContrat.split("/")[1]+ '/' + temp.contratinactifelecWS.dateFinContrat.split("/")[0] + temp.contratinactifelecWS.dateFinContrat.split("/")[2]))) {
              temp.contratinactifelecWS = contrat;

              if((temp.contratinactifelecWS.systemeInfoContractuel === 'GINKO' && 
              (temp.contratinactifelecWS.codeNiveauService === '2' || temp.contratinactifelecWS.codeNiveauService === '1')) 
              ||(temp.contratinactifelecWS.systemeInfoContractuel === 'DISCO' && temp.contratinactifelecWS.codeNiveauService === '1')
              ||(temp.contratinactifelecWS.TypeCompteur === 'LINKY' && temp.contratinactifelecWS.codeNiveauService === '0')){
                temp.EnqSat.linky = 1;
              } 

 
            }
          }
        } else if ( temp.length && contrat.typeContrat === "S" ) {
          temp = temp[0];

          if(contrat.statutCode === "E0004" || contrat.statutCode === "E0009"){
          if (temp.contratsService === undefined) {
            temp.contratsService = [];
          }
          temp.contratsService.push(contrat);
        }
          
          // Mapping du contrat service elec verte le plus récent (FT1-4463)
          if(contrat.codeOffre === 'EFOPT_VERT'){

            if(!contrat.dateFinContrat){
              temp.contratserviceelecvert = contrat;
              temp.contratserviceelecvertsansdatefin = true;
            } else if(contrat.dateFinContrat && !temp.contratserviceelecvertsansdatefin){

              if(!temp.contratserviceelecvert){
                temp.contratserviceelecvert = contrat;
              } else {

                if(new Date(temp.contratserviceelecvert.dateFinContrat.split("/")[1] + '/' + temp.contratserviceelecvert.dateFinContrat.split("/")[0] + '/' + temp.contratserviceelecvert.dateFinContrat.split("/")[2]) <
                new Date(contrat.dateFinContrat.split("/")[1] + '/' + contrat.dateFinContrat.split("/")[0] + '/' + contrat.dateFinContrat.split("/")[2])){
                  temp.contratserviceelecvert = contrat;
                }
              }

            }

          // Mapping du contrat service gaz vert le plus récent (FT1-4463)
          } else if(contrat.codeOffre === 'GOPT_VERT'){

            if(!contrat.dateFinContrat){
              temp.contratservicegazvert = contrat;
              temp.contratservicegazvertsansdatefin = true;
            } else if(contrat.dateFinContrat && !temp.contratservicegazvertsansdatefin){

              if(!temp.contratservicegazvert){
                temp.contratservicegazvert = contrat;
              } else {

                if(new Date(temp.contratservicegazvert.dateFinContrat.split("/")[1] + '/' + temp.contratservicegazvert.dateFinContrat.split("/")[0] + '/' + temp.contratservicegazvert.dateFinContrat.split("/")[2]) <
                new Date(contrat.dateFinContrat.split("/")[1] + '/' + contrat.dateFinContrat.split("/")[0] + '/' + contrat.dateFinContrat.split("/")[2])){
                  temp.contratservicegazvert = contrat;
                }
              }

            }
          }
          
        }
      }
    }
    for (const [i,protefeuille] of this.listRecord.entries()) {
      if (protefeuille.contratactifgazWS) {
        protefeuille.titleWS = protefeuille.contratactifgazWS.libelleOffre;
        protefeuille.EnqSat.lbGaz = protefeuille.titleWS;
        protefeuille.EnqSat.codeGaz = protefeuille.codeOffre;


      } else {
        protefeuille.titleWS = "GAZ";
      }
      if (protefeuille.contratactifelecWS) {
        protefeuille.titleElecWS = protefeuille.contratactifelecWS.libelleOffre;
        protefeuille.EnqSat.lbElec = protefeuille.titleElecWS;
        protefeuille.EnqSat.codeElec = protefeuille.codeOffre;

      } else {
        protefeuille.titleElecWS = "Elec";
      }
      protefeuille.loadcontratWS = true;
      protefeuille.key = i;
    }
    this.selectedItem = this.listRecord[this.index];
    this.isContratsManaged = true;
    // console.log("after Manage WS");
    // console.log(this.listRecord);
    // On a commenté cet appel parce qu'on fait l'appel du ws à partir de la méthode OrderLogement
    //this.getServices(this.listRecord[this.index]);
    this.manageFacturationPrestation();
  }
  manageFacturationPrestation() {
    this.getRecouvrement(this.listRecord);
    let paiementMesualiseList = [];
    let paiementPreleveList = [];
    for (let i = 0; i < this.fullSize; i++) {
      if (this.listRecord[i].contratactifelecWS) {
        if ( this.listRecord[i].contratactifelecWS.uniteReleve[this.listRecord[i].contratactifelecWS.uniteReleve.length - 1] === 'A') {
          paiementMesualiseList.push(this.listRecord[i].IdPortefeuilleContrat);
          this.listRecord[i].uniteReleve = 'A';
          this.manageFacturation('A', i);
        } else {
          paiementPreleveList.push(this.listRecord[i].IdPortefeuilleContrat);
          this.listRecord[i].uniteReleve = this.listRecord[i].contratactifelecWS.uniteReleve[this.listRecord[i].contratactifelecWS.uniteReleve.length - 1];
          this.manageFacturation(this.listRecord[i].contratactifelecWS.uniteReleve[this.listRecord[i].contratactifelecWS.uniteReleve.length - 1], i);
        }
      } else if (this.listRecord[i].contratactifgazWS) {
        if ( this.listRecord[i].contratactifgazWS.uniteReleve[this.listRecord[i].contratactifgazWS.uniteReleve.length - 1] === 'A') {
          paiementMesualiseList.push(this.listRecord[i].IdPortefeuilleContrat);
          this.listRecord[i].uniteReleve = 'A';
          this.manageFacturation('A', i);
        } else {
          paiementPreleveList.push(this.listRecord[i].IdPortefeuilleContrat);
          this.listRecord[i].uniteReleve = this.listRecord[i].contratactifgazWS.uniteReleve[this.listRecord[i].contratactifgazWS.uniteReleve.length - 1];
          this.manageFacturation(this.listRecord[i].contratactifgazWS.uniteReleve[this.listRecord[i].contratactifgazWS.uniteReleve.length - 1], i);
        }
      // contrat inactif à revoir
      } else if ( this.listRecord[i].contratinactifelecWS && (!this.listRecord[i].contratinactifgazWS ||(new Date(
        this.listRecord[i].contratinactifelecWS.dateFinContrat.split("/")[1] + '/' +
        this.listRecord[i].contratinactifelecWS.dateFinContrat.split("/")[0] + '/' +
        this.listRecord[i].contratinactifelecWS.dateFinContrat.split("/")[2]
      ) > new Date(
        this.listRecord[i].contratinactifgazWS.dateFinContrat.split("-")[1] + '/' +
        this.listRecord[i].contratinactifgazWS.dateFinContrat.split("-")[0] + '/' +
        this.listRecord[i].contratinactifgazWS.dateFinContrat.split("-")[2]
      )))){
        if ( this.listRecord[i].contratinactifelecWS.uniteReleve[this.listRecord[i].contratinactifelecWS.uniteReleve.length - 1] === 'A') {
          paiementMesualiseList.push(this.listRecord[i].IdPortefeuilleContrat);
          this.listRecord[i].uniteReleve = 'A';
          this.manageFacturation('A', i);
        } else {
          paiementPreleveList.push(this.listRecord[i].IdPortefeuilleContrat);
          this.listRecord[i].uniteReleve = this.listRecord[i].contratinactifelecWS.uniteReleve[this.listRecord[i].contratinactifelecWS.uniteReleve.length - 1];
          this.manageFacturation(this.listRecord[i].contratinactifelecWS.uniteReleve[this.listRecord[i].contratinactifelecWS.uniteReleve.length - 1], i);
        }
      } else if (this.listRecord[i].contratinactifgazWS) {
        if ( this.listRecord[i].contratinactifgazWS.uniteReleve[this.listRecord[i].contratinactifgazWS.uniteReleve.length - 1] === 'A') {
          paiementMesualiseList.push(this.listRecord[i].IdPortefeuilleContrat);
          this.listRecord[i].uniteReleve = 'A';
          this.manageFacturation('A', i);
        } else {
          paiementPreleveList.push(this.listRecord[i].IdPortefeuilleContrat);
          this.listRecord[i].uniteReleve = this.listRecord[i].contratinactifgazWS.uniteReleve[this.listRecord[i].contratinactifgazWS.uniteReleve.length - 1];
          this.manageFacturation(this.listRecord[i].contratinactifgazWS.uniteReleve[this.listRecord[i].contratinactifgazWS.uniteReleve.length - 1], i);
        }
      } else {
        this.listRecord[i].loadMensualisee = true;
        this.listRecord[i].loadFacture = true; 
      }
      // if (this.listRecord[i].contratactifgazWS) {
      //   this.listRecord[i].title = this.listRecord[i].contratactifgazWS.libelleOffre;
      // } else {
      //   this.listRecord[i].title = "GAZ";
      // }
      // if (this.listRecord[i].contratactifelec) {
      //   this.listRecord[i].titleElec = this.listRecord[
      //     i
      //   ].contratactifelec.libelleOffre;
      // } else {
      //   this.listRecord[i].titleElec = "Elec";
      // }
    }
    // console.log(paiementPreleveList);
    // console.log(paiementMesualiseList);
    if (paiementMesualiseList.length > 0) {
        //récuperer Paiement Mensualisees pour toutes les adresses
        getFacturationsMensualisees({ inputMap: { idsPortefeuilleContrat: paiementMesualiseList.filter(Boolean).join(",") } }).then(result => {
          // console.log('paiementMensualisee......');
          // console.log(result);
          // let prelevementListUpdate = []
          for(let i = 0; i < this.fullSize; i++) {
            for (let j = 0 ; j < result.resultdata.length; j++) {
              if ( result.resultdata[j].idPortefeuilleContrat ===  this.listRecord[i].IdPortefeuilleContrat ){
                  this.listRecord[i].loadFacture = true;
                  // this.listRecord[i].modePaiement = 'mensualisé';
                  if(result.resultdata[j] && result.resultdata[j].conditionPaiement && result.resultdata[j].conditionPaiement !== '+14B') {
                    this.listRecord[i].EnqSat.serDatRegPer=1;
                    this.listRecord[i].conditionPaiementMaj = 'Date de règlement personnalisée :   le '+result.resultdata[j].conditionPaiement.substring(1, 3);
                  } else if ( result.resultdata[j] && result.resultdata[j].conditionPaiement === undefined ) {
                      this.listRecord[i].conditionPaiementMaj = 'Information DRP indisponible';
                  }                   
                  this.listRecord[i] = { ...this.listRecord[i], ...result.resultdata[j] };
              }
            }
            if (this.listRecord[i].modePaiement === 'mensualisé' && this.listRecord[i].factures) {
              // prelevementListUpdate.push(this.listRecord[i].IdPortefeuilleContrat);
              // console.log("factureRegul");
              // console.log(this.listRecord[i].factures);
              for(const facture of this.listRecord[i].factures) {
                if(facture.planPaiementDesactiveParFacturation.trim() 
                  && facture.dateComptable
                  && facture.dateEcheance
                  && new Date(facture.dateComptable) < new Date()
                  && new Date() < new Date(facture.dateEcheance)) {
                  this.listRecord[i].isRegul = true;
                  this.listRecord[i].loadMensualisee = true;
                  this.listRecord[i].factureRegul = facture;
                  // console.log('isRegul');
                }
              }
            }
            if(result.resultdata.length === 0) {
              this.listRecord[i].loadMensualisee = true;
              this.listRecord[i].loadFacture = true;   
            }
          }
          // if(prelevementListUpdate.length) {
          //   this.callAPIPaiement(prelevementListUpdate);
          // }
          //Appel Plan Mensualisation
          this.getPlanMensualisation();
          //Si le retour de l'API est null
          if(result.resultdata.length === 0 || result.resultdata.length < paiementMesualiseList.length) {
            for(let j = 0 ; j < paiementMesualiseList.length; j++) {
              for (let i = 0; i < this.fullSize; i++) {
                if ( paiementMesualiseList[j] ===  this.listRecord[i].IdPortefeuilleContrat ){
                    this.listRecord[i].loadFacture = true;
                    this.listRecord[i].loadMensualisee = true;
                    // this.listRecord[i].modePaiement = 'mensualisé';
                }
              }
            }
          }
          console.log("result mesualisee....");
          console.log(this.listRecord[this.index]);
          this.getDossiersAffaire();
          this.selectedItem = this.listRecord[this.index];                      
        })
        .catch(error => {
          // this.listRecord[i].modePaiement = 'Mode de paiement indisponible.';
          console.log("got error getFacturationsMensualisees", error);
        });
    }
    if (paiementPreleveList.length > 0) {
        //Récuperer Facturations Paiements pour toutes les adresses
        this.callAPIPaiement(paiementPreleveList);
    }
    if (paiementPreleveList.length === 0 && paiementMesualiseList.length === 0) {
      for (let i = 0; i < this.fullSize; i++) {
        this.listRecord[i].loadFacture = true;
      }
      this.selectedItem = this.listRecord[this.index];                                      
    }
    // console.log(this.listRecord);
    this.selectedItem = this.listRecord[this.index];
    //Call prestation Gaz et elec
    //A Revoir
    if(this.selectedItem.contratactifgazWS) {
      let inputMap = {
          PCE: this.selectedItem.contratactifgazWS.numeroPointDeLivraison,
          PersonneIdentifier: this.selectedItem.IdBusinessPartner
      };
      this.getPrestEn(this.index, inputMap, 'gaz', 'IP_SM_Prestation_Gaz_SOAP');
    }
    if(this.selectedItem.contratactifelecWS) {
      let inputMap = {
          PDL: this.selectedItem.contratactifelecWS.numeroPointDeLivraison,
          PersonneIdentifier: this.selectedItem.IdBusinessPartner
      };
      this.getPrestEn(this.index, inputMap, 'elec', 'IP_SM_Prestation_Elec_SOAP');
    }
    // WS Affinitaire à refaire avec APIHour
    // this.callIP({IdPersonne: this.listRecord[this.index].idPersonne}, 'IP_SM_ContratAffiniatireServices_Smile')
    // console.log(this.listRecord[this.index]);
  }
  getPlanMensualisation() {
    console.log('getPlanMensualisation');
    if(this.listRecord[this.index].modePaiement === 'mensualisé' && this.listRecord[this.index].factures) {
       console.log("PlanMesualisation");
      let numeroPlanPaiement = this.listRecord[this.index].factures.filter(facture => facture.planPaiementDesactiveParFacturation.trim() === '');
      numeroPlanPaiement = numeroPlanPaiement && numeroPlanPaiement.length > 0 ? numeroPlanPaiement[0].numeroPlanPaiement : '';
     console.log("PlanMesualisation :" + numeroPlanPaiement);
      this.callIP({idPlanMensualisation: numeroPlanPaiement}, 'IP_SM_PlanMensualisation_WS', true);
      this.idPlanPaiement = numeroPlanPaiement;//FT2-1278 INTEGRATION - InitierAjustement 
    } else {
      this.listRecord[this.index].loadMensualisee = true;
    }
  }
  // FT3-697	
  // La fonction getDateDebutContrat(x) est utilisé pour récupéré la date de début de contrat le plus récent pour un logement	
  // Paramètre x pour logement	
  getDateDebutContrat(x) {	
    let dates = [];	
    // CAS 1 : Logement dual => on retourne la dateDebutContrat la plus récente	
    // Contrat Gaz : Actif - Contrat Elec : Actif	
    if(x.contratactifgazWS && x.contratactifgazWS.dateDebutContrat && x.contratactifelecWS && x.contratactifelecWS.dateDebutContrat){	
      if( 	
        new Date(	
          x.contratactifgazWS.dateDebutContrat.split("/")[2], 	
          x.contratactifgazWS.dateDebutContrat.split("/")[1] - 1, 	
          x.contratactifgazWS.dateDebutContrat.split("/")[0]) >	
        new Date(	
          x.contratactifelecWS.dateDebutContrat.split("/")[2], 	
          x.contratactifelecWS.dateDebutContrat.split("/")[1] - 1, 	
          x.contratactifelecWS.dateDebutContrat.split("/")[0]))	
      {	
        return new Date(x.contratactifgazWS.dateDebutContrat.split("/")[2], x.contratactifgazWS.dateDebutContrat.split("/")[1] - 1, x.contratactifgazWS.dateDebutContrat.split("/")[0]);	
      }	
      else {	
        return new Date(x.contratactifelecWS.dateDebutContrat.split("/")[2], x.contratactifelecWS.dateDebutContrat.split("/")[1] - 1, x.contratactifelecWS.dateDebutContrat.split("/")[0]);	
      }	
    }	
    // CAS 2 : Logement Gaz seulement => on retourne la dateDebutContrat du contrat GAZ	
    // Contrat Gaz : Actif	
    if((x.contratactifgazWS) && (x.contratactifgazWS.dateDebutContrat)){	
      return new Date(x.contratactifgazWS.dateDebutContrat.split("/")[2], x.contratactifgazWS.dateDebutContrat.split("/")[1] - 1, x.contratactifgazWS.dateDebutContrat.split("/")[0]);	
    }	
    // CAS 3 : Logement Elec seulement => on retourne la dateDebutContrat du contrat Elec	
    // Contrat Elec : Actif	
    if((x.contratactifelecWS) && (x.contratactifelecWS.dateDebutContrat)){	
      return new Date(x.contratactifelecWS.dateDebutContrat.split("/")[2], x.contratactifelecWS.dateDebutContrat.split("/")[1] - 1, x.contratactifelecWS.dateDebutContrat.split("/")[0]);	
    }	
    // CAS 4 : Logement dual => on retourne la dateDebutContrat la plus récente	
    // Contrat Gaz : Inactif - Contrat Elec : Inactif	
    if(x.contratinactifgazWS && x.contratinactifgazWS.dateDebutContrat && x.contratinactifelecWS && x.contratinactifelecWS.dateDebutContrat){	
      if( 	
        new Date(	
          x.contratinactifgazWS.dateDebutContrat.split("/")[2], 	
          x.contratinactifgazWS.dateDebutContrat.split("/")[1] - 1, 	
          x.contratinactifgazWS.dateDebutContrat.split("/")[0]) >	
        new Date(	
          x.contratinactifelecWS.dateDebutContrat.split("/")[2], 	
          x.contratinactifelecWS.dateDebutContrat.split("/")[1] - 1, 	
          x.contratinactifelecWS.dateDebutContrat.split("/")[0]))	
      {	
        return new Date(x.contratinactifgazWS.dateDebutContrat.split("/")[2], x.contratinactifgazWS.dateDebutContrat.split("/")[1] - 1, x.contratinactifgazWS.dateDebutContrat.split("/")[0]);	
      }	
      else {	
        return new Date(x.contratinactifelecWS.dateDebutContrat.split("/")[2], x.contratinactifelecWS.dateDebutContrat.split("/")[1] - 1, x.contratinactifelecWS.dateDebutContrat.split("/")[0]);	
      }	
    }	
    // CAS 5 : Logement Gaz seulement => on retourne la dateDebutContrat du contrat GAZ	
    // Contrat Gaz : Inactif	
    if((x.contratinactifgazWS) && (x.contratinactifgazWS.dateDebutContrat)){	
      return new Date(x.contratinactifgazWS.dateDebutContrat.split("/")[2], x.contratinactifgazWS.dateDebutContrat.split("/")[1] - 1, x.contratinactifgazWS.dateDebutContrat.split("/")[0]);	
    }	
    // CAS 6 : Logement Elec seulement => on retourne la dateDebutContrat du contrat Elec	
    // Contrat Elec : Inactif	
    if((x.contratinactifelecWS) && (x.contratinactifelecWS.dateDebutContrat)){	
      return new Date(x.contratinactifelecWS.dateDebutContrat.split("/")[2], x.contratinactifelecWS.dateDebutContrat.split("/")[1] - 1, x.contratinactifelecWS.dateDebutContrat.split("/")[0]);	
    }	
    return "";    	
  }	
  // FT3-697 : Afficher les logements du client du plus récent au plus ancien et les contrats actifs avant les contrats inactifs	
  // On fait l'ordre des logements en se basant sur les dates de début des contrats "dateDebutContrat"	
  OrderLogements() {	
    this.resetFlyout(this.index);	
    this.listRecord[this.index].load = false;	
    // Mettre les contrats actifs dans la variables contratActifs et les inactifs dans la variable contratNonActifs pour assurer de mettre les contrats actifs avant les contrats inactifs	
    let contratActifs = [];	
    let contratNonActifs=[];	
    this.listRecord.forEach(function (adrs) {	
      if ((adrs.contratactifelecWS)||(adrs.contratactifgazWS)){	
        contratActifs.push(adrs);	
      }	
      else{	
        contratNonActifs.push(adrs);	
      }	
    });	
    // Ordonner la liste des contrats actifs et des contrats inacitfs	
    // a et b dans la fonction sort ce sont des logements	
    contratActifs.sort((a,b) => {	
      return this.getDateDebutContrat(b) - this.getDateDebutContrat(a);	
    });	
    contratNonActifs.sort((a,b) => {	
      return this.getDateDebutContrat(b) - this.getDateDebutContrat(a);	
    });	
    this.listRecord=contratActifs.concat(contratNonActifs);	
    // réintitialisation des clés de la liste listRecord de 0 à n par le nouveau ordre	
    // Parce que les clés sont utilisées pour identifier le logement sélectionné par ordre 	
    this.listRecord.forEach(function(record, i) {	
      record.key = i;	
      record.selected = false;	
    });	
    // la liste firstListAdresses pour les 3 logements affichés	
    // la liste secondListAdresses pour le reste des logements non visible sur la vue 360	
    if (this.fullSize > 3) {	
      this.longList = true;	
      this.secondListSize = this.fullSize - 3;	
      this.firstListAdresses = this.listRecord.slice(0, 3);	
      this.secondListAdresses = this.listRecord.slice( 3, this.fullSize );	
    } else {	
      this.firstListAdresses = this.listRecord;	
    }	
    this.listRecord[this.index].selected = true;	
    this.selectedItem = this.listRecord[this.index];	
    // load à true pour ne pas refaire l'appel au web services dans la fonction handleActive pour le premier logement	
    this.listRecord[this.index].load = true;	

        // listing des logements pour outil d'estimation
        this.constructListOrderedAdresses(this.listRecord);

    // Récupération des information du premier logement après l'ordre	
    this.getRecouvrement(this.listRecord);
    this.getSolde(this.index);	
    this.getPayeurDivergent(this.index);
    this.getServices(this.selectedItem);	
    this.callIP({CompteClient: this.listRecord[this.index].NoCompteContrat}, 'IP_SM_RechDossierRecouvrement_SOAP');	

    

    this.getPlanMensualisation();	
    this.getNotesDebitsCredits();	
    
  }

  constructListOrderedAdresses(listRecord){
		let Logements = [];
		listRecord.forEach(function (logement) {	
			let itemLogement ;
      let compteContrat = logement.NoCompteContrat ;
			let codePostal = logement.codePostal ; 
			let numeroVoie = logement.numeroVoie ; 
			let libelleVoie = logement.libelleVoie ; 
			let ville = logement.ville ; 
			let codeINSEE = logement.codeINSEE;
			let pdlIdentifier = logement.contratactifelecWS ? logement.contratactifelecWS.numeroPointDeLivraison : (logement.contratinactifelecWS ? logement.contratinactifelecWS.numeroPointDeLivraison : '');
			let complementAdresse    = logement.complementAdresse ;
			let libelleSelect =  numeroVoie + " " + libelleVoie + " " + codePostal + " " + ville + " " + complementAdresse ;
			itemLogement = {compteContrat:compteContrat,codePostal:codePostal,numeroVoie:numeroVoie,libelleVoie:libelleVoie,ville:ville,complementAdresse:complementAdresse,codeINSEE:codeINSEE , libelleSelect : libelleSelect , pdlIdentifier : pdlIdentifier}
			console.log(complementAdresse);
			Logements.push(itemLogement);
		});	
		this.listOrderedAdresses= Logements;
	}

  callApiPersonneWS(idContact) {
    callPersonne({ inputMap: {idContact:idContact}}).then(result => {	
      if(result.estClientEHS && result.estClientEHS == true) {	
        this.estClientEHS = true;	
      } else if(result.estConnuEHS && result.estConnuEHS == true) {	
          this.estConnuEHS = true;	
      }	
      this.codeClient = (result.codeClient) ? result.codeClient : '';
      //send data to contactview360
      let felNumber = this.selectedItem.factureEnLigne;
      const message = {
        recordid : this.recordId,
        edoc: this.listRecord.length > 0 && this.selectedItem.eDocument ? true : false,
        fel: felNumber === '0001' || felNumber === '0002' || felNumber === '0004' ? true : false,
        account: this.selectedItem.NoCompteContratMaj,
        estClientEHS: this.estClientEHS,
        estConnuEHS: this.estConnuEHS,
        codeClient: this.codeClient
      };
      console.log(JSON.stringify(message));
      publish(this.context, containerToContactMessageChannel, message);
    })	
    .catch(error => {	
      console.log("got error callApiPersonneWS", error);	
    });
  }
  // ft3-646 - 22/04/2022
  getRecouvrement(listRecord){
    listRecord.forEach(function (record) {
      //LireSyntheseDossierRecouvrement
      //getIdDossierRecouvrement
      let inputSolde = {
        CompteClient: record.NoCompteContrat,
        IdPortefeuilleContrat: record.IdPortefeuilleContrat
      };
      callIP({ inputMap: inputSolde, NameIntergation: 'IP_SM_CompteClient_Solde' })
        .then(result => {
          record.idDossierRecouvrement=result.LireCompteClientReturn.idDossierRecouvrement;
        })
        .catch(error => {
          console.log("got error getIdDossierRecouvrement", error);
        });

    let inputDossierRecouvrement = {
      idPersonne: record.IdBusinessPartner,
      idCompteClient: record.NoCompteContrat,
      idDossierRecouvrement: record.idDossierRecouvrement

    };
    callIP({ inputMap: inputDossierRecouvrement, NameIntergation: 'IP_SM_LireSyntheseDossierRecouvrement_SOAP' })
      .then(result => {
        console.log(result);
        if(result.CallLireSyntheseDossierRecouvrement.lireSyntheseDossierRecouvrementResponse.lireSyntheseDossierRecouvrementOutput.dossierRecouvrement.jalon){
        var jalonList = (JSON.stringify(result.CallLireSyntheseDossierRecouvrement.lireSyntheseDossierRecouvrementResponse.lireSyntheseDossierRecouvrementOutput.dossierRecouvrement.jalon.typeJalon));
        if(jalonList.includes(irrecouvrable)){
          record.irrecouvrable = true;
        }
      }
    })
      .catch(error => {
        console.log("got error LireSyntheseDossierRecouvrement", error);
      });

			
		});	

  }

  // FT3-1692 
  getClientRetractation(idClient){
    let inputRetractation = {
      recordId: idClient
    };
    
    callIP({ inputMap: inputRetractation, NameIntergation: 'IP_SM_rechercherDemandeRetractation_WS' })
    .then(result => {
      console.log('getClientRetractation......');
      console.log('getClientRetractation',result);
      this.isRetractation = result.isRetractation;
    })
    .catch(error => {
      console.log("got error getClientRetractation", error);
    });
    }
}