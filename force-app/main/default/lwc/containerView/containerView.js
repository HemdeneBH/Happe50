import { NavigationMixin } from "lightning/navigation";
import { LightningElement,track, api } from "lwc";
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

export default class ContainerView extends NavigationMixin(LightningElement) {
  @api recordId;
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

  connectedCallback() {
		var self = this;
    // Listener pour capter l'event de raffrachissement de la vue 360
    window.addEventListener("message", function(event){
			if (event.data !== undefined && event.data["OmniScript-Messaging"] !== undefined && event.data["OmniScript-Messaging"].ContextId !== undefined && event.data["OmniScript-Messaging"].ContextId === self.recordId) {
        console.log("Refresh: connectedCallBack");
			  self.initContainerView();
        self.getCustomerInfos();
      }
		}, false);
    console.log("Init: connectedCallBack");
    self.initContainerView();
		this.getCustomerInfos();
  }
  
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
    this.newEmmenagement = false;
  }

	/**
	 * Récupération des informations à afficher dans la vue 360
	 */
	getCustomerInfos() {    
    callSmileHeaderLigthning({inputMap: { Id: this.recordId, options: { chainable: false } }}).then(result => {
      if (result !== undefined) {
        console.log(result);
          this.progress = 30;
          this.index = 0;
          let listidsPortefeuilles = [];
          let idPortefeuille;
          if (result.Result && result.Result.length) {
            for (const record of result.Result) {
              idPortefeuille = record.IdPortefeuilleContrat
                  ? record.IdPortefeuilleContrat
                  : "";
              listidsPortefeuilles.push(idPortefeuille);
              if (idPortefeuille) {
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
            this.listRecord.push(result.Result);
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
                console.log("resultLocaux");
                console.log(resultLocaux);
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
                  console.log("filtre retour API");
                  if (tempResponse && tempResponse.length > 0) {
                    let customObject = {};
                    customObject.libelleVoie = tempResponse[0].libelleVoie;
                    customObject.numeroVoie = tempResponse[0].numeroVoie;
                    customObject.complementAdresse = tempResponse[0].complementAdresse;
                    customObject.codePostal = tempResponse[0].codePostal;
                    customObject.ville = tempResponse[0].ville;
                    customObject.numeroPortefeuilleContrat = tempResponse[0].numeroPortefeuilleContrat;
                    customObject.ListContrats = tempResponse;
                    customObject.factureEnLigne = tempResponse[0].factureEnLigne;
                    customObject.clientMaReleve = tempResponse[0].clientMaReleve;
                    customObject.clientZenbox = tempResponse[0].clientZenbox;
                    customObject.clientCapEcoConso = tempResponse[0].clientCapEcoConso;
                    // Version V1 API locaux contrat cette attribut n'existe plus
                    // customObject.dateProchaineFacture = tempResponse[0].dateProchaineFacture;
                    customObject.dateTechniqueProchaineFacture = tempResponse[0].dateTechniqueProchaineFacture;
                    customObject.dateReelleProchaineFacture = tempResponse[0].dateReelleProchaineFacture;
                    customObject.modeEncaissement = tempResponse[0].modeEncaissement;
                    customObject.typeOccupation = tempResponse[0].typeOccupation;
                    customObject.typeResidence = tempResponse[0].typeResidence;
                    customObject.codeINSEE = tempResponse[0].codeINSEE;
                    
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
                  // if(record && record.contrats) {
                  //   for (const contrat of record.contrats) {
                  //     if (contrat.codeStatutContratCRM !== "E0002" && contrat.codeStatutContratCRM !== "E0009" && contrat.codeStatutContratCRM !== "H0106" &&  contrat.typeEnergie === "gaz" ) {
                  //       record.contratactifgaz = contrat;
                  //     } else if ((contrat.codeStatutContratCRM === "E0002" || contrat.codeStatutContratCRM === "E0009" || contrat.codeStatutContratCRM === "H0106") && contrat.typeEnergie === "gaz") {
                  //         if (!record.contratinactifgaz || new Date( contrat.dateFinContrat.split("-")[2], contrat.dateFinContrat.split("-")[1], contrat.dateFinContrat.split("-")[0] ) > new Date(record.contratinactifgaz.dateFinContrat.split("-")[2], record.contratinactifgaz.dateFinContrat.split("-")[1], record.contratinactifgaz.dateFinContrat.split("-")[0])) {
                  //             record.contratinactifgaz = contrat;
                  //             record.perimetrePCE = true;
                  //         }
                  //     } else if (contrat.codeStatutContratCRM !== "E0002" && contrat.codeStatutContratCRM !== "E0009" && contrat.codeStatutContratCRM !== "H0106" && contrat.typeEnergie === "elec") {
                  //       record.contratactifelec = contrat;
                  //     } else if ((contrat.codeStatutContratCRM === "E0002" || contrat.codeStatutContratCRM === "E0009" || contrat.codeStatutContratCRM === "H0106") && contrat.typeEnergie === "elec" ) {
                  //       if ( !record.contratinactifelec ||
                  //         new Date(
                  //           contrat.dateFinContrat.split("-")[2],
                  //           contrat.dateFinContrat.split("-")[1],
                  //           contrat.dateFinContrat.split("-")[0]
                  //         ) >
                  //           new Date(
                  //             record.contratinactifelec.dateFinContrat.split(
                  //               "-"
                  //             )[2],
                  //             record.contratinactifelec.dateFinContrat.split(
                  //               "-"
                  //             )[1],
                  //             record.contratinactifelec.dateFinContrat.split("-")[0]
                  //           )
                  //       ) {
                  //         record.contratinactifelec = contrat;
                  //       }
                  //     }
                  //   }
                  // }
                  
                });
                // Gestion des contrats
                if (this.contratsWSResponse) {
                  this.manageContrat(this.contratsWSResponse);
                }

                this.listRecord[this.index].selected = true;
                if (this.fullSize > 3) {
                  this.longList = true;
                  this.secondListSize = this.fullSize - 3;
                  this.firstListAdresses = this.listRecord.slice(0, 3);
                  this.secondListAdresses = this.listRecord.slice( 3, this.fullSize );
                } else {
                  this.firstListAdresses = this.listRecord;
                }
                // let paiementMesualiseList = [];
                // let paiementPreleveList = [];
                // for (let i = 0; i < this.fullSize; i++) {
                //   if (this.listRecord[i].contratactifelecWS) {
                //     if ( this.listRecord[i].contratactifelecWS.uniteReleve[this.listRecord[i].contratactifelecWS.uniteReleve.length - 1] === 'A') {
                //       paiementMesualiseList.push(this.listRecord[i].IdPortefeuilleContrat);
                //       this.listRecord[i].uniteReleve = 'A';
                //       this.manageFacturation('A', i);
                //     } else {
                //       paiementPreleveList.push(this.listRecord[i].IdPortefeuilleContrat);
                //       this.listRecord[i].uniteReleve = this.listRecord[i].contratactifelecWS.uniteReleve[this.listRecord[i].contratactifelecWS.uniteReleve.length - 1];
                //       this.manageFacturation(this.listRecord[i].contratactifelecWS.uniteReleve[this.listRecord[i].contratactifelecWS.uniteReleve.length - 1], i);
                //     }
                //   } else if (this.listRecord[i].contratactifgazWS) {
                //     if ( this.listRecord[i].contratactifgazWS.uniteReleve[this.listRecord[i].contratactifgazWS.uniteReleve.length - 1] === 'A') {
                //       paiementMesualiseList.push(this.listRecord[i].IdPortefeuilleContrat);
                //       this.listRecord[i].uniteReleve = 'A';
                //       this.manageFacturation('A', i);
                //     } else {
                //       paiementPreleveList.push(this.listRecord[i].IdPortefeuilleContrat);
                //       this.listRecord[i].uniteReleve = this.listRecord[i].contratactifgazWS.uniteReleve[this.listRecord[i].contratactifgazWS.uniteReleve.length - 1];
                //       this.manageFacturation(this.listRecord[i].contratactifgazWS.uniteReleve[this.listRecord[i].contratactifgazWS.uniteReleve.length - 1], i);
                //     }
                //   // contrat inactif à revoir
                //   } else if ( this.listRecord[i].contratinactifelecWS && (!this.listRecord[i].contratinactifgazWS ||(new Date(
                //     this.listRecord[i].contratinactifelecWS.dateFinContrat.split("/")[1] + '/' +
                //     this.listRecord[i].contratinactifelecWS.dateFinContrat.split("/")[0] + '/' +
                //     this.listRecord[i].contratinactifelecWS.dateFinContrat.split("/")[2]
                //   ) > new Date(
                //     this.listRecord[i].contratinactifgazWS.dateFinContrat.split("-")[1] + '/' +
                //     this.listRecord[i].contratinactifgazWS.dateFinContrat.split("-")[0] + '/' +
                //     this.listRecord[i].contratinactifgazWS.dateFinContrat.split("-")[2]
                //   )))){
                //     if ( this.listRecord[i].contratinactifelecWS.uniteReleve[this.listRecord[i].contratinactifelecWS.uniteReleve.length - 1] === 'A') {
                //       paiementMesualiseList.push(this.listRecord[i].IdPortefeuilleContrat);
                //       this.listRecord[i].uniteReleve = 'A';
                //       this.manageFacturation('A', i);
                //     } else {
                //       paiementPreleveList.push(this.listRecord[i].IdPortefeuilleContrat);
                //       this.listRecord[i].uniteReleve = this.listRecord[i].contratinactifelecWS.uniteReleve[this.listRecord[i].contratinactifelecWS.uniteReleve.length - 1];
                //       this.manageFacturation(this.listRecord[i].contratinactifelecWS.uniteReleve[this.listRecord[i].contratinactifelecWS.uniteReleve.length - 1], i);
                //     }
                //   } else if (this.listRecord[i].contratinactifgazWS) {
                //     if ( this.listRecord[i].contratinactifgazWS.uniteReleve[this.listRecord[i].contratinactifgazWS.uniteReleve.length - 1] === 'A') {
                //       paiementMesualiseList.push(this.listRecord[i].IdPortefeuilleContrat);
                //       this.listRecord[i].uniteReleve = 'A';
                //       this.manageFacturation('A', i);
                //     } else {
                //       paiementPreleveList.push(this.listRecord[i].IdPortefeuilleContrat);
                //       this.listRecord[i].uniteReleve = this.listRecord[i].contratinactifgazWS.uniteReleve[this.listRecord[i].contratinactifgazWS.uniteReleve.length - 1];
                //       this.manageFacturation(this.listRecord[i].contratinactifgazWS.uniteReleve[this.listRecord[i].contratinactifgazWS.uniteReleve.length - 1], i);
                //     }
                //   }
                //   // if (this.listRecord[i].contratactifgazWS) {
                //   //   this.listRecord[i].title = this.listRecord[i].contratactifgazWS.libelleOffre;
                //   // } else {
                //   //   this.listRecord[i].title = "GAZ";
                //   // }
                //   // if (this.listRecord[i].contratactifelec) {
                //   //   this.listRecord[i].titleElec = this.listRecord[
                //   //     i
                //   //   ].contratactifelec.libelleOffre;
                //   // } else {
                //   //   this.listRecord[i].titleElec = "Elec";
                //   // }


                // }
                // console.log(paiementPreleveList);
                // console.log(paiementMesualiseList);

                // if (paiementMesualiseList.length > 0) {
                //     //récuperer Paiement Mensualisees pour toutes les adresses
                //     getFacturationsMensualisees({ inputMap: { idsPortefeuilleContrat: paiementMesualiseList.filter(Boolean).join(",") } }).then(result => {
                //       console.log('paiementMensualisee......');
                //       console.log(result);
                //       // let prelevementListUpdate = []
                //       for(let i = 0; i < this.fullSize; i++) {
                //         for (let j = 0 ; j < result.resultdata.length; j++) {
                //           if ( result.resultdata[j].idPortefeuilleContrat ===  this.listRecord[i].IdPortefeuilleContrat ){
                //               this.listRecord[i].loadFacture = true;
                //               // this.listRecord[i].modePaiement = 'mensualisé';
                //               if(result.resultdata[j] && result.resultdata[j].conditionPaiement && result.resultdata[j].conditionPaiement !== '+14B') {
                //                 this.listRecord[i].conditionPaiementMaj = 'Date de règlement personnalisée :   le '+result.resultdata[j].conditionPaiement.substring(1, 3);
                //               } else if ( result.resultdata[j] && result.resultdata[j].conditionPaiement === undefined ) {
                //                   this.listRecord[i].conditionPaiementMaj = 'Information DRP indisponible';
                //               }                   
                //               this.listRecord[i] = { ...this.listRecord[i], ...result.resultdata[j] };
                //           }
                //         }
                //         if (this.listRecord[i].modePaiement === 'mensualisé' && this.listRecord[i].factures) {
                //           // prelevementListUpdate.push(this.listRecord[i].IdPortefeuilleContrat);
                //           console.log("factureRegul");
                //           console.log(this.listRecord[i].factures);
                //           for(const facture of this.listRecord[i].factures) {
                //             if(facture.planPaiementDesactiveParFacturation.trim() 
                //               && facture.dateComptable
                //               && facture.dateEcheance
                //               && new Date(facture.dateComptable) < new Date(new Date())
                //               && new Date(new Date()) < new Date(facture.dateEcheance)) {
                //               this.listRecord[i].isRegul = true;
                //               this.listRecord[i].loadMesualisee = true;
                //               this.listRecord[i].factureRegul = facture;
                //               console.log('isRegul');
                //               return;
                //             }
                //           }
                          
                //         }
                //       }
                //       // if(prelevementListUpdate.length) {
                //       //   this.callAPIPaiement(prelevementListUpdate);
                //       // }

                //       //Appel Plan Mensualisation
                //       if(result.resultdata.length > 0 && !this.listRecord[this.index].isRegul) {
                //         console.log("PlanMesualisation");
                //         this.callIP({idPlanMensualisation: this.listRecord[this.index].factures[0].numeroPlanPaiement}, 'IP_SM_PlanMensualisation_WS', true);
                //       } else {
                //         this.listRecord[this.index].loadMesualisee = true;
                //       }
                //       //Si le retour de l'API est null
                //       if(result.resultdata.length === 0) {
                //         for(let j = 0 ; j < paiementMesualiseList.length; j++) {
                //           for (let i = 0; i < this.fullSize; i++) {
                //             if ( paiementMesualiseList[j] ===  this.listRecord[i].IdPortefeuilleContrat ){
                //                 this.listRecord[i].loadFacture = true;
                //                 // this.listRecord[i].modePaiement = 'mensualisé';
                //             }
                //           }
                //         }
                //       }
                //       console.log("result mesualisee....");
                //       console.log(this.listRecord[this.index]);
                //       this.selectedItem = this.listRecord[this.index];                      
                //     })
                //     .catch(error => {
                //       // this.listRecord[i].modePaiement = 'Mode de paiement indisponible.';
                //       console.log("got error getFacturationsMensualisees", error);
                //     });
                // }
                
                // if (paiementPreleveList.length > 0) {
                //     //Récuperer Facturations Paiements pour toutes les adresses
                //     this.callAPIPaiement(paiementPreleveList);
                // }

                // if (paiementPreleveList.length === 0 && paiementMesualiseList.length === 0) {
                //   for (let i = 0; i < this.fullSize; i++) {
                //     this.listRecord[i].loadFacture = true;
                //   }
                //   this.selectedItem = this.listRecord[this.index];                                      
                // }
                // console.log(this.listRecord);
                // this.selectedItem = this.listRecord[this.index];
                // //Call prestation Gaz et elec
                // //A Revoir
                // if(this.selectedItem.contratactifgazWS) {
                //   let inputMap = {
                //       PCE: this.selectedItem.contratactifgazWS.numeroPointDeLivraison,
                //       PersonneIdentifier: this.selectedItem.IdBusinessPartner
                //   };
                //   this.getPrestEn(this.index, inputMap, "gaz");
                // }
                // if(this.selectedItem.contratactifelecWS) {
                //   let inputMap = {
                //       PDL: this.selectedItem.contratactifelecWS.numeroPointDeLivraison,
                //       PersonneIdentifier: this.selectedItem.IdBusinessPartner
                //   };
                //   this.getPrestEn(this.index, inputMap, "elec");
                // }
                // // WS Affinitaire à refaire avec APIHour
                // // this.callIP({IdPersonne: this.listRecord[this.index].idPersonne}, 'IP_SM_ContratAffiniatireServices_Smile')
                // console.log(this.listRecord[this.index]);

              } else {
                this.error = true;
                this.errorMessage = 'Désolé, les informations de notre fournisseur de données sont momentanément indisponibles.'
              }
            }).catch(error => {
              console.log("got error getLocauxContrats", error);
              this.errorMessage = 'Désolé, les informations de notre fournisseur de données sont momentanément indisponibles.'
              this.error = true;
            });
            //récuperer information solde
            this.getSolde(this.index);
          } else {
            console.log("nouveau client");
            this.newEmmenagement = true;
            this.errorMessage = "Ce client ne dispose pas de logement."
            this.progress = 100;
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
    return !this.error && this.selectedItem && !this.newEmmenagement;
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
        console.log('solde......');
        console.log(result);
        this.progress += 10;
        this.listRecord[index].solde = result.LireCompteClientReturn
          ? result.LireCompteClientReturn
          : {};
        this.selectedItem = this.listRecord[index];
      })
      .catch(error => {
        console.log("got error getSolde", error);
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
        this.getServices(this.selectedItem);
        this.callIP({CompteClient: this.listRecord[this.index].NoCompteContrat}, 'IP_SM_RechDossierRecouvrement_SOAP');
        this.getPlanMensualisation();
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

      console.log(this.listRecord);
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

  //Open Emmenagement Omniscript
  //Déclanche un évenement vers le composant aura (composant parent)
  handleOpenEmmenagement() {
    setCache().then(r => {
      console.log(r);
      const eventName = "openmoveinemmenagement";
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
        console.log("got error setCache", error);
    });
  }

  manageFacturation(type, index) {
      if(type === 'A'){
          this.listRecord[index].modePaiement = 'mensualisé'; 
      }
      else{
          if(this.listRecord[index].modeEncaissement === 'P'){
            this.listRecord[index].modePaiement = 'Prélevé'; 
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
        console.log(name);
        console.log(result);
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
      console.log("API paiement APIHOUR.......");
      console.log(result);
      if ( result.resultdata && result.resultdata.length > 0 ) {
        for(let j = 0 ; j < result.resultdata.length; j++) {                    
          for (let i = 0; i < this.fullSize; i++) {
            if ( result.resultdata[j].idPortefeuilleContrat ===  this.listRecord[i].IdPortefeuilleContrat ){
              this.listRecord[i].loadFacture = true;
              if(result.resultdata[j] && result.resultdata[j].conditionPaiement && result.resultdata[j].conditionPaiement !== '+14B') {
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
    this.listRecord[this.index].titreService = 'SERVICES';
    let listServicesActif = [];
    let listServicesInactif = [];
    if (this.listRecord[this.index].factureEnLigne === '0001') {
      listServicesActif.push({
      libOffreMaj: 'FACTURE EN LIGNE',
        actif: true
      });
    }
    if(this.listRecord[this.index].clientMaReleve) {
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
      listServicesActif.push({
        libOffreMaj: 'CAP ECO CONSO',
        actif: true
      });
    }
    
    let prev_facture = -1;
    let prev_facture2 = -1;
    let prev_factureResil = -1;
    let prev_factureResil2 = -1;
    if(this.listRecord[this.index].contratsService) {
      for(let i = 0; i < this.listRecord[this.index].contratsService.length ; i++) {
        // SI PREV_FACT et E0004 
        let contrat = this.listRecord[this.index].contratsService[i];
        if(contrat.codeOffre === 'PREV_FACT' && contrat.statutCode === 'E0004') {
          prev_facture =  i;
        } else if (contrat.codeOffre === 'PREV_FACT' && contrat.statutCode === 'E0009') {
          prev_factureResil = i;
        }// SI PREV_FACT2 et E0004
        else if(contrat.codeOffre === 'PREV_FACT2' && contrat.statutCode === 'E0004') {
          prev_facture2 =  i;
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
        if (result && result.return && result.return.messageRetour && result.return.messageRetour.code === 'SUCCESS' && result.return.retour.contratList) {
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
        this.listRecord[this.index].listServices = listJoint;
        this.listRecord[this.index].listServicesCard = listJoint.slice(0, 4);
        let servicesActifCount = listServicesActif.length;
        let servicesInactifCount = listServicesInactif.length;
        this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? ('SERVICE ('+ servicesActifCount + ' actif' + (servicesActifCount > 1?'s, ':', ') + servicesInactifCount + ' résilié' + (servicesInactifCount > 1?'s)':')')) : 'SERVICES';
        this.selectedItem = this.listRecord[this.index];
        //A revoir
        // this.progress += 20;
      })
      .catch(error => {
        this.listRecord[this.index].loadService = true;
        let listJoint = [...listServicesActif, ...listServicesInactif]
        this.listRecord[this.index].listServices = listJoint;
        this.listRecord[this.index].listServicesCard = listJoint.slice(0, 4);
        let servicesActifCount = listServicesActif.length;
        let servicesInactifCount = listServicesInactif.length;
        this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? ('SERVICE ('+ servicesActifCount + ' actif' + (servicesActifCount > 1?'s, ':', ') + servicesInactifCount + ' résilié' + (servicesInactifCount > 1?'s)':')')) : 'SERVICES';
        this.selectedItem = this.listRecord[this.index];
        this.listRecord[this.index].errorService = "Informations services indisponible pour le moment."; 
        console.log("got error Services " , error);
      });
      let listJoint = [...listServicesActif, ...listServicesInactif]
      this.listRecord[this.index].listServices = listJoint;
      this.listRecord[this.index].listServicesCard = listJoint.slice(0, 4);
      let servicesActifCount = listServicesActif.length;
      let servicesInactifCount = listServicesInactif.length;
      this.listRecord[this.index].titreService = (servicesActifCount > 0 || servicesInactifCount > 0) ? ('SERVICE ('+ servicesActifCount + ' actif' + (servicesActifCount > 1?'s, ':', ') + servicesInactifCount + ' résilié' + (servicesInactifCount > 1?'s)':')')) : 'SERVICES';
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
        break;
      case 'DE0':
        libelle = 'DEPEX';
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
        } else {
          this.contratsWSResponse = result.resultdata ? result.resultdata : [];
        }
        

      })
      .catch(error => {
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
          if ( contrat.statutCode !== "E0002" && contrat.statutCode !== "E0009" && contrat.statutCode !== "H0106" &&  contrat.typeContrat === "GN" ) {
            temp.contratactifgazWS = contrat;
          } else if ((contrat.statutCode === "E0002" || contrat.statutCode === "E0009" || contrat.statutCode === "H0106") &&  contrat.typeContrat === "GN" ) {
            if (
              !temp.contratinactifgazWS ||( contrat.dateFinContrat &&
              new Date( contrat.dateFinContrat.split("/")[1]+ '/' + contrat.dateFinContrat.split("/")[0] + contrat.dateFinContrat.split("/")[2] ) >
              new Date( temp.contratinactifgazWS.dateFinContrat.split("/")[1]+ '/' + temp.contratinactifgazWS.dateFinContrat.split("/")[0] + temp.contratinactifgazWS.dateFinContrat.split("/")[2] ))) {
              temp.contratinactifgazWS = contrat;
              temp.perimetrePCE = true;
            }
          } else if (contrat.statutCode !== "E0002" && contrat.statutCode !== "E0009" && contrat.statutCode !== "H0106" && contrat.typeContrat === "E") {
            temp.contratactifelecWS = contrat;
          } else if ((contrat.statutCode === "E0002" || contrat.statutCode === "E0009" || contrat.statutCode === "H0106") && contrat.typeContrat === "E") {
            if (
              !temp.contratinactifelecWS || ( contrat.dateFinContrat &&
              new Date(contrat.dateFinContrat.split("/")[1]+ '/' + contrat.dateFinContrat.split("/")[0] + contrat.dateFinContrat.split("/")[2]) >
              new Date( temp.contratinactifelecWS.dateFinContrat.split("/")[1]+ '/' + temp.contratinactifelecWS.dateFinContrat.split("/")[0] + temp.contratinactifelecWS.dateFinContrat.split("/")[2]))) {
              temp.contratinactifelecWS = contrat;
            }
          }
        } else if ( temp.length && contrat.typeContrat === "S" ) {
          temp = temp[0];
          if (temp.contratsService === undefined) {
            temp.contratsService = [];
          }
          temp.contratsService.push(contrat);
        }
      }
    }
    
    for (const [i,protefeuille] of this.listRecord.entries()) {
      if (protefeuille.contratactifgazWS) {
        protefeuille.titleWS = protefeuille.contratactifgazWS.libelleOffre;
      } else {
        protefeuille.titleWS = "GAZ";
      }
      if (protefeuille.contratactifelecWS) {
        protefeuille.titleElecWS = protefeuille.contratactifelecWS.libelleOffre;
      } else {
        protefeuille.titleElecWS = "Elec";
      }
      protefeuille.loadcontratWS = true;
      protefeuille.key = i;
    }
    this.selectedItem = this.listRecord[this.index];
    // console.log("after Manage WS");
    // console.log(this.listRecord);
    this.getServices(this.listRecord[this.index]);
    this.manageFacturationPrestation();
  }

  manageFacturationPrestation() {
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
          console.log('paiementMensualisee......');
          console.log(result);
          // let prelevementListUpdate = []
          for(let i = 0; i < this.fullSize; i++) {
            for (let j = 0 ; j < result.resultdata.length; j++) {
              if ( result.resultdata[j].idPortefeuilleContrat ===  this.listRecord[i].IdPortefeuilleContrat ){
                  this.listRecord[i].loadFacture = true;
                  // this.listRecord[i].modePaiement = 'mensualisé';
                  if(result.resultdata[j] && result.resultdata[j].conditionPaiement && result.resultdata[j].conditionPaiement !== '+14B') {
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
                  return;
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
          // console.log("result mesualisee....");
          // console.log(this.listRecord[this.index]);
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
    if(this.listRecord[this.index].modePaiement === 'mensualisé' && this.listRecord[this.index].factures && !this.listRecord[this.index].isRegul) {
      // console.log("PlanMesualisation");
      this.callIP({idPlanMensualisation: this.listRecord[this.index].factures[0].numeroPlanPaiement}, 'IP_SM_PlanMensualisation_WS', true);
    } else {
      this.listRecord[this.index].loadMensualisee = true;
    }
  }
}