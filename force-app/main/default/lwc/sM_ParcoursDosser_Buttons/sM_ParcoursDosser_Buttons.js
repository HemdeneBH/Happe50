import { LightningElement, api, track, wire } from 'lwc';
import { getDataHandler } from "vlocity_cmt/utility";
import { CurrentPageReference } from 'lightning/navigation';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SM_ParcoursDosser_Buttons extends OmniscriptBaseMixin(LightningElement) {

  @api caseId;
  @api datePresta;
  @api civilite;
  @api nom;
  @api prenom;
  @api telephonemobile;
  @api telephonefixe;
  @api idsap;
  @api loginuser;
  @api iddossiercoupure;
  @api iddistributeur;
  @api idfournisseur;
  @track PDL = '';
  @track contactId = '';
  @track idBP = '';
  @track idContrat = '';
  @wire(CurrentPageReference) currentPageReference;
  @track renderedCallbackExecuted = false;
  @track openRetablissementConfirmModal = false;
  @track openAnnulationConfirmModal = false;
  @track openRestaurationConfirmModal = false;
  @track code = "";
  @track vlcStatus = "";
  @track vlcUseQueueableApexRemoting;
  @track vlcMessage;
  @track vlcIPData;
  @track prisEnCompteDistrib;
  @track showSpinnerLoading = false;
  urgent = false;

  _listButtons = [];


  @api set listButtons(value) {
    this._listButtons = value || {};
  }

  get listButtons() {
    return this._listButtons;
  }

  //FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
  //Récupération du PDL et du contactId depuis l'URL
  get PDLFromState() {
    return this.currentPageReference &&
      this.currentPageReference.state.c__PDL;
  }

  get ContactIdFromState() {
    return this.currentPageReference &&
      this.currentPageReference.state.c__id;
  }

  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Récupération de l'idPersonne depuis l'URL
  get BPFromState() {
    return this.currentPageReference &&
      this.currentPageReference.state.c__IdBusinessPartner;
  }

  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Récupération de l'idContrat depuis l'URL
  get idContratFromState() {
    return this.currentPageReference &&
      this.currentPageReference.state.c__idContrat;
  }

  renderedCallback() {
    if (!this.renderedCallbackExecuted) {
      this.PDL = this.PDLFromState;
      this.contactId = this.ContactIdFromState;
      this.idBP = this.BPFromState;
      this.idContrat = this.idContratFromState;

      //FT2-1560: CNP - Pré remplissage détails de l'interaction
      //Pré remplissage des détails de l'interaction par défaut
      this.omniApplyCallResp({ "coupurecanceled": "KO" });
      this.omniApplyCallResp({ "reductioncanceled": "KO" });
      this.omniApplyCallResp({ "retablissementcreated": "KO" });
      this.omniApplyCallResp({ "dateopsretab": "" });
      this.omniApplyCallResp({ "urgenteretab": "" });
      this.omniApplyCallResp({ "restaurationcreated": "KO" });
      this.omniApplyCallResp({ "dateopsrestauration": "" });
      this.omniApplyCallResp({ "urgenterestauration": "" });
      this.renderedCallbackExecuted = true;
    }

  }

  //FT2-1213: [Clients Coupés pour Non-Paiement] Condition d'affichage du bouton d'annulation de prestation
  //Vérifier si le bouton affiché est celui d'annulation
  get checkIfCancel() {
    if (this._listButtons[0].label === "Annuler la demande") return true;
    return false;
  }

  //FT2-1213: [Clients Coupés pour Non-Paiement] Condition d'affichage du bouton d'annulation de prestation
  //Vérifier si la date de prestation est supérieure à la date du jour
  //Des transformations sont appliquées sur le format des dates pour que les formats des deux dates à comparer soient identiques
  get checkDateForCancel() {
    let todayDate = new Date();
    let todayTemp = todayDate.toISOString();
    let today = todayTemp.substring(0, 10) + 'T00:00:00.000Z';

    if (this.datePresta.includes("/")) {
      let tempDatePresta = this.datePresta.split("/");
      this.datePresta = tempDatePresta[2] + '-' + tempDatePresta[1] + '-' + tempDatePresta[0] + 'T00:00:00.000Z';
    }
    if (this.datePresta > today) return true;
    return false;
  }

  //FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
  //Vérifier si les deux boutons "rétablissement et restauration" sont affichés
  get checkIfRetablissementAndRestauration() {
    if (this._listButtons.length === 2) {
      this.omniApplyCallResp({ "showArticle": "Yes" });
      return true;
    }
    return false;
  }

  //FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
  //Vérifier si le bouton affiché est celui de restauration
  get checkIfRestauration() {
    if (this._listButtons[0].label === "Restauration") return true;
    return false;
  }

  //FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
  //Vérifier si le bouton affiché est celui de rétablissement
  get checkIfRetablissement() {
    if (this._listButtons[0].label === "Rétablissement" && this.checkIfRetablissementAndRestauration === false) {
      this.omniApplyCallResp({ "showArticle": "Yes" });
      return true;
    }
    return false;
  }

  //FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
  //Gestion du bouton "Restauration"
  actionRestauration() {
    this.openRestaurationConfirmModal = true;

  }

  //FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
  //Gestion du bouton "Rétablissement"
  actionRetablissement() {
    this.openRetablissementConfirmModal = true;
  }

  //FT2-1209: [Clients Coupés pour Non-Paiement] Annuler la demande de prestation (coupure / réduction de puissance)
  //Comportement du bouton "OUI" en cas d'ANNULATION
  actionAnnulerDemande() {
    this.openAnnulationConfirmModal = true;
  }


  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Comportement du bouton "NON" en cas de RESTAURATION
  noRestauration() {
    this.openRestaurationConfirmModal = false;
  }

  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Comportement du bouton "OUI" en cas de RESTAURATION
  yesRestauration() {
    this.openRestaurationConfirmModal = false;

    //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
    let dateEffet = new Date();
    dateEffet.setDate(dateEffet.getDate() + 1);
    let dateEffetSouhaitee = dateEffet.toLocaleDateString();
    if (dateEffetSouhaitee.includes("/")) {
      let tempDate = dateEffetSouhaitee.split("/");
      dateEffetSouhaitee = tempDate[2] + '-' + tempDate[1] + '-' + tempDate[0] + 'T00:00:00';
    }

    let telephone = "";
    if (!this.isUndefined(this.telephonemobile)) {
      telephone = this.telephonemobile.replace(/\s/g, '');
    } else if (!this.isUndefined(this.telephonefixe)) {
      telephone = this.telephonefixe.replace(/\s/g, '');
    } else {
      telephone = "";
    }

    //TEMP CODE
    console.log("selectedPCEVal: " + "false");
    console.log("selectedPDLVal: " + this.PDL);
    console.log("CaseId: " + this.caseId);
    console.log("ContactId: " + this.contactId);
    console.log("sellingOption: " + "Restauration");
    console.log("isRetablissement: " + "false");
    console.log("codeProduit: " + "300030");
    console.log("dateEffetSouhaitee: " + dateEffetSouhaitee);
    console.log("idContrat: " + this.idContrat);
    console.log("idPDLElectricite: " + this.PDL);
    console.log("idPersonne: " + this.idBP);
    console.log("idPersonneResponsable: " + "0000"+this.idsap);
    console.log("loginUtilisateur: " + this.loginuser);
    console.log("civilitéCode: " + this.civilite);
    console.log("nom: " + this.nom);
    console.log("prenom: " + this.prenom);
    console.log("telephone: " + telephone);
    console.log("typePrestationCode: " + "Z002");
    console.log("urgent: " + "false");
    console.log("isCreate: " + "true");
    console.log("idDossierCoupure: " + this.iddossiercoupure);
    console.log("idStatut: " + "RT");
    console.log("secteurActiviteLibelle: " + "5E");
    console.log("secteurActiviteCode: " + "5E");
    console.log("idPrestation: " + "RESTAUR");
    console.log("idDemandeur: " + "0000" + this.idsap);
    console.log("etatDemandeDistributeurLibelle: " + "TRANSMISINTERV");
    console.log("etatDemandeDistributeurCode: " + "TRANSMISINTERV");
    //TEMP CODE

    //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
    //Appel de l'IP "IP_SM_CreatePrestation_SOAP" (Restauration)
    this.callIPCreerPrestationRestauration({ selectedPCEVal: "false", selectedPDLVal: this.PDL, CaseId: this.caseId, ContactId: this.contactId, sellingOption: "Restauration", isRetablissement: "false", codeProduit: "300150", dateEffetSouhaitee: dateEffetSouhaitee, idContrat: this.idContrat, idPDLElectricite: this.PDL, idPersonne: this.idBP, idPersonneResponsable: "0000" + this.idsap, loginUtilisateur: this.loginuser, civilitéCode: this.civilite, nom: this.nom, prenom: this.prenom, telephone: telephone, typePrestationCode: "Z002", urgent: this.urgent }, "IP_SM_CreatePrestation_SOAP");
  }

  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Comportement du bouton "NON" en cas de RETABLISSEMENT
  noRetablissement() {
    this.openRetablissementConfirmModal = false;
  }

  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Comportement du bouton "OUI" en cas de RETABLISSEMENT
  yesRetablissement() {
    this.openRetablissementConfirmModal = false;

    //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
    let dateEffet = new Date();
    dateEffet.setDate(dateEffet.getDate() + 1);
    let dateEffetSouhaitee = dateEffet.toLocaleDateString();
    if (dateEffetSouhaitee.includes("/")) {
      let tempDate = dateEffetSouhaitee.split("/");
      dateEffetSouhaitee = tempDate[2] + '-' + tempDate[1] + '-' + tempDate[0] + 'T00:00:00';
    }

    let telephone = "";
    if (!this.isUndefined(this.telephonemobile)) {
      telephone = this.telephonemobile.replace(/\s/g, '');
    } else if (!this.isUndefined(this.telephonefixe)) {
      telephone = this.telephonefixe.replace(/\s/g, '');
    } else {
      telephone = "";
    }

    //TEMP CODE
    console.log("selectedPCEVal: " + "false");
    console.log("selectedPDLVal: " + this.PDL);
    console.log("CaseId: " + this.caseId);
    console.log("ContactId: " + this.contactId);
    console.log("sellingOption: " + "Rétablissement");
    console.log("isRetablissement: " + "true");
    console.log("codeProduit: " + "300030");
    console.log("dateEffetSouhaitee: " + dateEffetSouhaitee);
    console.log("idContrat: " + this.idContrat);
    console.log("idPDLElectricite: " + this.PDL);
    console.log("idPersonne: " + this.idBP);
    console.log("idPersonneResponsable: " + "0000"+this.idsap);
    console.log("loginUtilisateur: " + this.loginuser);
    console.log("civilitéCode: " + this.civilite);
    console.log("nom: " + this.nom);
    console.log("prenom: " + this.prenom);
    console.log("telephone: " + telephone);
    console.log("typePrestationCode: " + "Z002");
    console.log("urgent: " + "false");
    console.log("isCreate: " + "true");
    console.log("idDossierCoupure: " + this.iddossiercoupure);
    console.log("idStatut: " + "RT");
    console.log("secteurActiviteLibelle: " + "5E");
    console.log("secteurActiviteCode: " + "5E");
    console.log("idPrestation: " + "RETAB");
    console.log("idDemandeur: " + "0000" + this.idsap);
    console.log("etatDemandeDistributeurLibelle: " + "TRANSMISINTERV");
    console.log("etatDemandeDistributeurCode: " + "TRANSMISINTERV");
    //TEMP CODE

    //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
    //Appel de l'IP "IP_SM_CreatePrestation_SOAP" (Rétablissement)
    this.callIPCreerPrestationRetablissement({ selectedPCEVal: "false", selectedPDLVal: this.PDL, CaseId: this.caseId, ContactId: this.contactId, sellingOption: "Rétablissement", isRetablissement: "true", codeProduit: "300030", dateEffetSouhaitee: dateEffetSouhaitee, idContrat: this.idContrat, idPDLElectricite: this.PDL, idPersonne: this.idBP, idPersonneResponsable: "0000" + this.idsap, loginUtilisateur: this.loginuser, civilitéCode: this.civilite, nom: this.nom, prenom: this.prenom, telephone: telephone, typePrestationCode: "Z002", urgent: this.urgent }, "IP_SM_CreatePrestation_SOAP")
  }

  //FT2-1209: [Clients Coupés pour Non-Paiement] Annuler la demande de prestation (coupure / réduction de puissance)
  //Comportement du bouton "NON" en cas d'ANNULATION
  noAnnulation() {
    this.openAnnulationConfirmModal = false;
  }

  //FT2-1209: [Clients Coupés pour Non-Paiement] Annuler la demande de prestation (coupure / réduction de puissance)
  //Comportement du bouton "OUI" en cas d'ANNULATION
  yesAnnulation() {
    this.openAnnulationConfirmModal = false;

    //FT2-1209 - [Clients Coupés pour Non-Paiement] Annuler la demande de prestation (coupure / réduction de puissance)
    let idD = "";

    if (!this.isUndefined(this.iddistributeur)) idD = this.iddistributeur;

    //Appel de l'IP "IP_SM_AnnulerPrestationElec_SOAP"
    this.callIPAnnulerPrestation({ idD: idD, idDossierCoupure: this.iddossiercoupure, idDemandeur: "0000" + this.idsap, loginuser: this.loginuser }, "IP_SM_CancelPrestation_SOAP");
  }

  //FT2-1584 - [Suivi de coupure] Ajout Checkbox à l'étape client réduit
  //Comportement de la case à cocher
  isUrgentChecked() {
    this.urgent = !this.urgent;
  }

  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Appel de l'IP "IP_SM_Creer_PrestationServiceElectricite" avec passage de paramètres pour le cas de restauration
  callIPCreerPrestationRestauration(parameters, name) {
    this.showSpinnerLoading = true;
    let datasourcedef;
    if (this.vlcStatus == "InProgress") {
      datasourcedef = JSON.stringify({
        "type": "integrationprocedure",
        "value": {
          "ipMethod": name,
          "inputMap": {},
          "optionsMap": '{"vlcStatus": "' + this.vlcStatus + '", "vlcUseQueueableApexRemoting": ' + this.vlcUseQueueableApexRemoting + ', "vlcMessage": ' + this.vlcMessage + ', "vlcIPData": "' + this.vlcIPData + '"}'
        }
      });
    } else {
      datasourcedef = JSON.stringify({
        "type": "integrationprocedure",
        "value": {
          "ipMethod": name,
          "inputMap": parameters,
          "optionsMap": '{"chainable":true}'
        }
      });
    }
    getDataHandler(datasourcedef).then(IPResult => {
      if (IPResult) {
        let result = JSON.parse(IPResult);

        if (result.IPResult) {
          //TEMP CODE
            console.log("result RESTAUR: " + result.IPResult);
            console.log("result RESTAUR JSONSTRINGIFY: " + JSON.stringify(result.IPResult));
          //TEMP CODE

          this.code = result.IPResult.code;
          this.vlcStatus = result.IPResult.vlcStatus;
          this.vlcUseQueueableApexRemoting = result.IPResult.vlcUseQueueableApexRemoting;
          this.vlcMessage = result.IPResult.vlcMessage;
          this.vlcIPData = result.IPResult.vlcIPData;

          if (this.vlcStatus === "InProgress") {
            this.callIPCreerPrestationRestauration({}, "IP_SM_CreatePrestation_SOAP");
          }
          if (this.code === "OCTOPUS_CreerPrestationServiceElectricite_01") {

            this.vlcStatus = "";
            const evt = new ShowToastEvent({
              title: "La demande de prestation de RESTAURATION a bien été créée",
              variant: 'success',
            });
            this.dispatchEvent(evt);
            //FT2-1560: CNP - Pré remplissage détails de l'interaction
            //Pré remplissage des détails de la création de restauration
            this.omniApplyCallResp({ "restaurationcreated": "OK" });
            let dateOPS = new Date();
            dateOPS.setDate(dateOPS.getDate() + 1);
            let dateOPSrestauration = dateOPS.toLocaleDateString();
            this.omniApplyCallResp({ "dateopsrestauration": dateOPSrestauration });

            //FT2-1584 - [Suivi de coupure] Ajout Checkbox à l'étape client réduit
            //Pré-remplissage des détails du traçage d'interaction
            if (this.urgent === false) {
              this.omniApplyCallResp({ "urgenterestauration": "Non" });
            } else {
              this.omniApplyCallResp({ "urgenterestauration": "Oui" });
            }

            this.showSpinnerLoading = false;

            //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
            //Appel de l'IP MAJDossierCoupure
            this.callIPMAJDossierCoupure({ isCreate: "true", idDossierCoupure: this.iddossiercoupure, idStatut: "RS", secteurActiviteLibelle: "5E", secteurActiviteCode: "5E", idPrestation: "RESTAUR", idDemandeur: "0000" + this.idsap, etatDemandeDistributeurLibelle: "TRANSMISINTERV", etatDemandeDistributeurCode: "TRANSMISINTERV" }, "IP_SM_MAJDossierCoupure_SOAP");

            //FT2-1552: CNP - Traçage d'interaction + création de tache
            this.omniNextStep();
          }
          else if (this.code != "OCTOPUS_CreerPrestationServiceElectricite_01" && this.code != "" && this.code != undefined) {
            const evt = new ShowToastEvent({

              title: "Une erreur technique est survenue et la création de la demande de prestation n’a pas été faite",

              variant: 'error',
            });
            this.dispatchEvent(evt);

            this.showSpinnerLoading = false;

            //FT2-1552: CNP - Traçage d'interaction + création de tache
            this.omniNextStep();
          }
        }
      }
    }).catch(error => {
      console.log("failed at getting IP data => " + JSON.stringify(error));
    });

  }

  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Appel de l'IP "IP_SM_Creer_PrestationServiceElectricite" avec passage de paramètres pour le cas de rétablissement
  callIPCreerPrestationRetablissement(parameters, name) {
    this.showSpinnerLoading = true;
    let datasourcedef;
    if (this.vlcStatus == "InProgress") {
      datasourcedef = JSON.stringify({
        "type": "integrationprocedure",
        "value": {
          "ipMethod": name,
          "inputMap": {},
          "optionsMap": '{"vlcStatus": "' + this.vlcStatus + '", "vlcUseQueueableApexRemoting": ' + this.vlcUseQueueableApexRemoting + ', "vlcMessage": ' + this.vlcMessage + ', "vlcIPData": "' + this.vlcIPData + '"}'
        }
      });
    } else {
      datasourcedef = JSON.stringify({
        "type": "integrationprocedure",
        "value": {
          "ipMethod": name,
          "inputMap": parameters,
          "optionsMap": '{"chainable":true}'
        }
      });
    }
    getDataHandler(datasourcedef).then(IPResult => {
      if (IPResult) {
        let result = JSON.parse(IPResult);
        if (result.IPResult) {
         //TEMP CODE
            console.log("result RETAB: " + result.IPResult);
            console.log("result RETAB JSONSTRINGIFY: " + JSON.stringify(result.IPResult));
         //TEMP CODE

          this.code = result.IPResult.code;
          this.vlcStatus = result.IPResult.vlcStatus;
          this.vlcUseQueueableApexRemoting = result.IPResult.vlcUseQueueableApexRemoting;
          this.vlcMessage = result.IPResult.vlcMessage;
          this.vlcIPData = result.IPResult.vlcIPData;

          if (this.vlcStatus === "InProgress") {
            this.callIPCreerPrestationRetablissement({}, "IP_SM_CreatePrestation_SOAP");
          }
          if (this.code === "OCTOPUS_CreerPrestationServiceElectricite_01") {
            this.vlcStatus = "";
            const evt = new ShowToastEvent({
              title: "La demande de prestation de RETABLISSEMENT a bien été créée",
              variant: 'success',
            });
            this.dispatchEvent(evt);

            //FT2-1560: CNP - Pré remplissage détails de l'interaction
            //Pré remplissage des détails de la création de rétablissement
            this.omniApplyCallResp({ "retablissementcreated": "OK" });
            let dateOPS = new Date();
            dateOPS.setDate(dateOPS.getDate() + 1);
            let dateOPSretablissement = dateOPS.toLocaleDateString();
            this.omniApplyCallResp({ "dateopsretab": dateOPSretablissement });

            //FT2-1584 - [Suivi de coupure] Ajout Checkbox à l'étape client réduit
            //Pré-remplissage des détails du traçage d'interaction
            if (this.urgent === false) {
              this.omniApplyCallResp({ "urgenteretab": "Non" });
            } else {
              this.omniApplyCallResp({ "urgenteretab": "Oui" });
            }

            this.showSpinnerLoading = false;

            //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
            //Appel de l'IP MAJDossierCoupure
            this.callIPMAJDossierCoupure({ isCreate: "true", idDossierCoupure: this.iddossiercoupure, idStatut: "RT", secteurActiviteLibelle: "5E", secteurActiviteCode: "5E", idPrestation: "RETAB", idDemandeur: "0000" + this.idsap, etatDemandeDistributeurLibelle: "TRANSMISINTERV", etatDemandeDistributeurCode: "TRANSMISINTERV" }, "IP_SM_MAJDossierCoupure_SOAP");

            //FT2-1552: CNP - Traçage d'interaction + création de tache
            this.omniNextStep();
          }
          else if (this.code != "OCTOPUS_CreerPrestationServiceElectricite_01" && this.code != "" && this.code != undefined) {
            const evt = new ShowToastEvent({

              title: "Une erreur technique est survenue et la création de la demande de prestation n’a pas été faite",

              variant: 'error',
            });
            this.dispatchEvent(evt);

            this.showSpinnerLoading = false;

            //FT2-1552: CNP - Traçage d'interaction + création de tache
            this.omniNextStep();
          }
        }
      }
    }).catch(error => {
      console.log("failed at getting IP data => " + error);
    });

  }

  //FT2-1209 - [Clients Coupés pour Non-Paiement] Annuler la demande de prestation (coupure / réduction de puissance)
  //Appel de l'IP "IP_SM_AnnulerPrestationElec_SOAP"
  callIPAnnulerPrestation(parameters, name) {
    this.showSpinnerLoading = true;
    let datasourcedef = JSON.stringify({
      "type": "integrationprocedure",
      "value": {
        "ipMethod": name,
        "inputMap": parameters,
      }
    });
    getDataHandler(datasourcedef).then(IPResult => {
      if (IPResult) {
        let result = JSON.parse(IPResult);
        if (result.IPResult) {
          this.code = result.IPResult.code_retour;
          this.prisEnCompteDistrib = result.IPResult.prisEnCompteDistrib;

          if ((this.code === "OCTOPUS_AnnulerPrestationServiceElectricite_01" || this.code === "OCTOPUS_AnnulerPrestationServiceElectricite_03") && (this.prisEnCompteDistrib === true)) {

            const evt = new ShowToastEvent({
              title: "Demande de prestation annulée",
              variant: 'success',
            });
            this.dispatchEvent(evt);

            //FT2-1560: CNP - Pré remplissage détails de l'interaction
            //Pré remplissage des détails de l'annulation
            if (this._listButtons[0].action === "annulerCoupure") this.omniApplyCallResp({ "coupurecanceled": "OK" });
            if (this._listButtons[0].action === "annulerReduction") this.omniApplyCallResp({ "reductioncanceled": "OK" });

            this.showSpinnerLoading = false;

            //FT2-1552: CNP - Traçage d'interaction + création de tache
            this.omniNextStep();

          }
          else {
            const evt = new ShowToastEvent({

              title: "La demande d'annulation n'a pas pu être communiquée au gestionnaire de réseau, merci d'annuler l’OPS directement sur le portail SGE",

              variant: 'error',
            });
            this.dispatchEvent(evt);

            this.showSpinnerLoading = false;

            //FT2-1552: CNP - Traçage d'interaction + création de tache
            this.omniNextStep();
          }
        }
      }
    }).catch(error => {
      console.log("failed at getting IP data => " + error);
    });

  }

  //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
  //Appel de l'IP MAJDossierCoupure
  callIPMAJDossierCoupure(parameters, name) {
    let datasourcedef = JSON.stringify({
      "type": "integrationprocedure",
      "value": {
        "ipMethod": name,
        "inputMap": parameters,
      }
    });
    console.log("datasourcedef: " + datasourcedef);
    getDataHandler(datasourcedef).then(IPResult => { console.log(IPResult) }).catch(error => {
      console.log("failed at getting IP data => " + error);
    });

  }

  //Méthode pour vérifier si les valeurs récupérées depuis la FlexCard sont vides
  isUndefined(value) {
    return typeof value == 'undefined' || value.indexOf("{Parent.") === 0;
  }
}