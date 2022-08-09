import { NavigationMixin } from 'lightning/navigation';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';


import { LightningElement, api, track} from 'lwc';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
export default class SM_ModePaiement extends NavigationMixin(LightningElement) {
    @api recordId;
    @api numeroVoie;
    @api ville;
    @api libelleVoie;
    @api complementAdresse;
    @api codePostal;
    @api NoCompteContrat;
    @api NoCompteContratMaj;
    @api isPrelevee;
    @api isMensualisee;
    @api isNonPrelevee;
    @api hasContratActif;
    @api bp;
    @api iBAN;
    @api nomInstitutBancaire;
    @api titulaireCompte;
    @api libelleStatutMandat;
    @api conditionPaiement;
    @api isResilie;
    @api listAddress;
    @api listAdressesPrel;
    @api isMensualisation;
    @api solde;
    @api montantEcheance;
    @api montantCumuleEcheance;
    @api pce;
    @api pdl;
    @api idContratElec;
    @api idContratGaz;
    @api codeINSEE;
    @api numeroMandat;
    @api codeStatutMandat;
    @api idDemandeMens;
    @api codeRetourRecherchMens;
    @api codeRetourMajMens;
    @api statutRetourMajMens;
    @api idContratRecherche;
    @api numeroLocal;
    @api isNoDemandeMens;
    @api returnedWSmessage;

    @api dateTechniqueProchaineFacture;
    @api dateReelleProchaineFacture;
    @api dateTheoriqueReleve;
    @api AccountId;

    @api IdBusinessPartner; 
    @api eDocument;
    @api libelleFactureEnLigne;
    @api factureEnLigne;
    //FT2-1765 Ajustement mensualité V2 : Récupération des adresses (écran Localisation du logement (1/2))
    @api listOrderedAdresses;

    @api Id_Case;
    noDataCase = false;



    @track isOpenModal = false;
    @track isSentCancelled = false;
    @track isLoading = true;

    @track showSuivant=true;  


    @track isError = false;

    // FT2-1280 paramètres utilisés pour remplir la flexcard SM_AjustementMensualite_Echeancier
    @api tableDataMens;
    @api showCumule;
    @api isGaz;
    @api isElec;
    @api isService1;
    @api isService2;
    @api montantPaye;
    @api montantGlobal;
    
    @track isErrorInitierAjustMens = false;	
    @track isEligibleAjustementAjustement = false;	
    @track libelleRetourAjustMens ='';
    @api idPlanDePaiement;

    @api categorie;
    @api montantGlobalOriginal;
    
    @api EnqSat;
    @api isPlanMensValid;

    //FT2-1724 Ajustement mensualité V2 : Récupération du montant estimée depuis l’Outil d’estimation
    @api idPackElec;
    @api idPackGaz;
    @api idOfferElec; 
    @api idOfferGaz;
    @api effectiveDateElec;
    @api effectiveDateGaz;
    
    get showSpinner() {
        return this.libelleRetourAjustMens && (this.libelleRetourAjustMens !== '');
    }

    
    connectedCallback() {
        this.callRechercheDemandeMens();
        //FT2-1278 INTEGRATION - InitierAjustement
        if(this.isMensualisee === true){
        //this.callIPAjustementMens({idPersonne: this.bp,idCompteClient: this.NoCompteContrat,idPlanPaiement: this.idPlanDePaiement}, 'IP_SM_InitierAjustement_SOAP' );
        }
    }
    parcoursPrelevement() {}
    parcoursPaiementPonc() {}
    parcoursMensualisation() {}
    get idContratRecherche() {
        if (this.idContratElec) {
            return this.idContratElec;
        }
        else if (this.idContratGaz) {
            return this.idContratGaz;
        }
    }
    get isNoDemandeMens() {
        return !this.idDemandeMens && (this.codeRetourRecherchMens === 'OCTOPUS_rechercherDemandeMensualisation_06' || this.codeRetourRecherchMens === 'OCTOPUS_rechercherDemandeMensualisation_01');
    }
   get isNonMensualisee() {
        return !this.isMensualisee;
    }
    get isPreleve(){
        return this.isMensualisee || this.isPrelevee;
    }
    get iBANExists(){
        return this.iBAN;
    }
    get mandatActif(){
        return this.libelleStatutMandat === 'Actif' && this.codeStatutMandat === '1';
    }
    get mandatAConfirmer(){
        return this.libelleStatutMandat === 'A Confirmer' && this.codeStatutMandat === '2';
    }
    get mandatCloture(){
        return this.libelleStatutMandat === 'Clôturé' && this.codeStatutMandat === '6';
    }
    get mensSansDRP(){
        return this.isMensualisee && this.conditionPaiement && 
        (this.conditionPaiement === 'F14B' || this.conditionPaiement === '+14B');
    }
    get hasDRP(){
        return this.isMensualisee && this.conditionPaiement && this.conditionPaiement !== 'F14B' && this.conditionPaiement !== '+14B';
    }
    get jourDRP(){ 
        return this.conditionPaiement.substring(1,3);
    }
    get isResilier(){
        return this.isResilie;
    }
    get isNonResilier(){
        return !this.isResilie;
    }
    get isOkMensualisation(){
        return this.isMensualisation;
    }
    get isNonMensualisation(){
        return !this.isMensualisation;
    }

    get getiBAN() {
    if(this.iBAN){
        return this.iBAN.substring(0, 4) + '...' +this.iBAN.substring(this.iBAN.length - 4 ,this.iBAN.length);
    
    }else{
        return '';
    }
        
    }

    handleOpenAnnulMens() {
        
        this.isOpenModal = true;
    }
    handleCloseAnnulMens(){
        this.isOpenModal = false;
    }

    handleAnnulMensConfirmed(){
        this.isSentCancelled = true; 
        this.callMajDemandeMens();
    }
    handleSuivant(){
        let CreateCase ={
            AccountId: this.AccountId,
            ContextId:this.recordId,
            DeveloperName: "Service",
            SobjectType: "Case" ,
            CaseType: "Paiement", 
            CaseSousType: "Annulation demande de mensualisation",
            CaseStatus: "Pré-clôturé",
            CaseSousStatut : "",
          }
        if(this.codeRetourMajMens==='OCTOPUS_majDemandeMensualisation_01'){
            CreateCase.CaseSousStatut = 'Conforme';
            // création de case retour WS Ok
        }else{
            CreateCase.CaseSousStatut = 'Abandon';
            // création de case retour WS KO
        }

        this.isLoading= true;
        this.showSuivant = false;

        callIP({ inputMap: CreateCase, NameIntergation: 'IP_CreateCaseLWC_Case' })
          .then(result => {
            if( result ) {
                this.noDataCase = result.length > 0 ? false : true;
                this.Id_Case = result.Case;
                this.idBusinessPartner = result.idBusinessPartner;
                console.log("IP_CreateCaseLWC result :");
                console.log(result);
                if(this.Id_Case && this.idBusinessPartner){

                  // direction traçage d'interaction
				  this.isOpenModal = false;
                  this.closeTab();
                  this.navigateToInteraction();
                }
                else{
                  console.log("Un problème est survenue lors de la création du Case");
				  this.isLoading= false;
                  const evt = new ShowToastEvent({
                    title: 'Erreur',
                    message: 'Un problème est survenue lors de la création du Case, veuillez contacter votre administrateur Salesforce.',
                    variant: 'error',
                    mode: 'dismissable'
                  });
                  this.dispatchEvent(evt);
                  this.showSuivant = true;
                  this.isOpenModal = false;

                }
            } else {
              this.noDataCase = true;
            }
          })
          .catch(error => {
            console.log("got error callIP: IP_CreateCaseLWC" , error);

            const evt = new ShowToastEvent({
                title: 'Erreur',
                message: 'Un problème est survenue lors de la création du Case, veuillez contacter votre administrateur Salesforce.',
                variant: 'error',
                mode: 'dismissable'
              });
              this.dispatchEvent(evt);
              this.showSuivant = true;
              this.isOpenModal = false;
          });
    }

    navigateToInteraction(){
        const eventName = 'openInteraction';
        let inputMap = {
                isActivateTracerInteractionOS: true,
                isCasNominal:true,
                isPauseInteraction: false,
                DRId_Case:this.Id_Case,
                StepNameOS:'Annulation demande de mensualisation',
                refClientIdBP:this.idBusinessPartner,
                isLWC:true,
                EnqSat:this.EnqSat
            }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }

    //FT2-1280 Lancement du parcours ajustement de mensualisation
    navigateToModifierMontant(){
        const eventName = 'openAjustementMens';
        const inputMap = {
                ContextId: this.recordid,
                bp : this.bp,
                AccountId : this.AccountId,    
                tableDataMens : this.tableDataMens,
                showCumule : this.showCumule,
                isGaz : this.isGaz,
                isElec : this.isElec,
                isService1 : this.isService1,
                isService2 : this.isService2,
                numeroVoie : this.numeroVoie,
                libelleVoie : this.libelleVoie,
                complementAdresse : this.complementAdresse,
                ville : this.ville,
                codePostal : this.codePostal,
                numCompteClientActuel : this.NoCompteContratMaj,
                montantPaye : this.montantPaye,
                montantGlobal : this.montantGlobal,
                idPlanDePaiement : this.idPlanDePaiement, //FT2-1604: Ajustement mensualité update 0.2 : Intégration au clic sur le bouton NON dans le parcours
                listOrderedAdresses: this.listOrderedAdresses, //FT2-1765 Ajustement mensualité V2 : Récupération des adresses (écran Localisation du logement (1/2))
                //FT2-1298: Ajustement mensualité 1.3 : Etape 1 - intégration
                categorie: this.categorie,
                montantGlobalOriginal: this.montantGlobalOriginal,
                //FT2-1724 Ajustement mensualité V2 : Récupération du montant estimée depuis l’Outil d’estimation: Ajout des paramètres utilisé par l'IP PrixEtRemises
                idPackElec: this.idPackElec,
                idPackGaz: this.idPackGaz,
                idOfferElec: this.idOfferElec, 
                idOfferGaz: this.idOfferGaz,
                effectiveDateElec: this.effectiveDateElec!= undefined && this.effectiveDateElec!= null && this.effectiveDateElec!= '' ? this.effectiveDateElec: '',
                effectiveDateGaz: this.effectiveDateGaz!= undefined && this.effectiveDateGaz!= null && this.effectiveDateGaz!= '' ? this.effectiveDateGaz : '',
                EnqSat:this.EnqSat,
                isPlanMensValid : this.isPlanMensValid //FT2-1855 check si le plan de mens a plus d'une mensualité prévue
        };
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);	

    }

    //FT2-1278 INTEGRATION - InitierAjustement
    callIPAjustementMens(params, name) {
        if( this.idPlanDePaiement){
            callIP({inputMap: params, NameIntergation: name })
            .then(result => {
                if(result.InitierAjustementMensResponse){
                if(result.InitierAjustementMensResponse.codeRetour =='OCTOPUS_InitierAjustementMensualite_00' ) {
                    
                    this.isEligibleAjustement = true; 
                    this.isErrorInitierAjustMens = false;
                    this.libelleRetourAjustMens = result.InitierAjustementMensResponse.libelleRetour;
                    
                
                }else {
    
                    this.isEligibleAjustement = false;
                    this.isErrorInitierAjustMens = false;
                    this.libelleRetourAjustMens = result.InitierAjustementMensResponse.libelleRetour;
                    
                }
    
            }   
    
            }).catch(error => {
                console.log("got error IP_SM_InitierAjustement_SOAP", error);
                this.isEligibleAjustement = false;
                this.isErrorInitierAjustMens = true;
                this.libelleRetourAjustMens = 'Une erreur est survenue. Veuillez contacter votre administrateur.';
    
            }
    
            );
        }else{
            this.isEligibleAjustement = false;
            this.isErrorInitierAjustMens = false;
            this.libelleRetourAjustMens = 'Une erreur est survenue. Contactez votre administrateur. Données erronées';
        }
    
    
        
    }
    //Annulation de la demande de mensualisation
    callMajDemandeMens() {
        let inputMajDemandeMap = {
            idDemandeMens: this.idDemandeMens,
            idPersonne: this.bp,
            idCompteClient: this.NoCompteContrat,
            statutDemande :"Z0007",
            montantCumule: "0"
        };
        console.log(inputMajDemandeMap);
        callIP({ inputMap: inputMajDemandeMap, NameIntergation: 'IP_SM_MAJDemandeMens_WS' }).then(result => {
            if (result && result.retourMajDemandeMens) {

                this.isLoading= false;

                console.log("result :", result);
                this.codeRetourMajMens = result.retourMajDemandeMens.codeRetour;
                this.statutRetourMajMens = result.retourMajDemandeMens.codeStatut;
                console.log("codeRetourMajMens :", this.codeRetourMajMens);
                console.log("statutRetourMajMens :", this.statutRetourMajMens);

                if(this.codeRetourMajMens === 'OCTOPUS_majDemandeMensualisation_01'){

                    this.isError = false;
                    this.returnedWSmessage='La demande a bien été prise en compte';
                }else{
                    this.isError = true;

                    this.returnedWSmessage='La demande n\'a pu aboutir, veuillez réessayer ultérieurement';
                }
            }else{
                this.isLoading= false;

                this.isError = true;

                this.returnedWSmessage='La demande n\'a pu aboutir, veuillez réessayer ultérieurement';
            }
        }).catch(error => {
            this.isLoading= false;

            this.isError = true;

            this.returnedWSmessage='La demande n\'a pu aboutir, veuillez réessayer ultérieurement';
            console.log("got error IP_SM_MAJDemandeMens", error);
        });
    }
    closeTab() {
        console.log("closeTab");
        const closeclickedevt = new CustomEvent('closeclicked', {
            detail: {  },
        });
        // Fire the custom event
        this.dispatchEvent(closeclickedevt);
      }


    callRechercheDemandeMens() {
        let inputRechercheDemandeMap = {
            idContratRecherche: this.idContratRecherche,
            idPersonne: this.bp,
            idCompteClient: this.NoCompteContrat
        };
        console.log(inputRechercheDemandeMap);
        callIP({ inputMap: inputRechercheDemandeMap, NameIntergation: 'IP_SM_RechercherDemandeMensualisation_Smile' }).then(result => {
            if (result) {
                this.codeRetourRecherchMens = result.codeRetour;
                this.idDemandeMens = result.idDemandeMensualisation;
                this.statutDemandeMens = result.statutDemande;
                if(!this.idDemandeMens && (this.codeRetourRecherchMens === 'OCTOPUS_rechercherDemandeMensualisation_06' || this.codeRetourRecherchMens === 'OCTOPUS_rechercherDemandeMensualisation_01')){
                    this.isNoDemandeMens = true;
                }else{
                    this.isNoDemandeMens = false;
                }
                console.log("idDemandeMens :", this.idDemandeMens);
                console.log("codeRetourRecherchMens :", this.codeRetourRecherchMens);
                console.log("isNoDemandeMens :", this.isNoDemandeMens);
                console.log("statutDemandeMens :", this.statutDemandeMens);
            }
        }).catch(error => {
            console.log("got error IP_SM_RechercherDemandeMensualisation", error);
        });
    }
    parcoursModificationCOOB() {}
    parcoursAjoutCOOB() {
        const eventName = 'opencoob';
        const inputMap = {
            bp : this.bp,
            AccountId : this.AccountId,
            numeroVoie : this.numeroVoie,
            libelleVoie : this.libelleVoie,
            complementAdresse : this.complementAdresse,
            ville : this.ville,
            codePostal : this.codePostal,
            listAdressesPrel : this.listAdressesPrel,
            numCompteClientActuel : this.NoCompteContrat,
            pce : this.pce,
            pdl : this.pdl,
            idContratGaz : this.idContratGaz,
            idContratElec : this.idContratElec,
            codeINSEE: this.codeINSEE,
            numeroLocal: this.numeroLocal
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    parcoursAjoutDRP() {}
    NavigationPrel() {
        const eventName = 'openprel';
        const inputMap = {
            bp : this.bp,
            AccountId : this.AccountId,
            numeroVoie : this.numeroVoie,
            libelleVoie : this.libelleVoie,
            complementAdresse : this.complementAdresse,
            ville : this.ville,
            //FT2-1124 : Passage des paramettres Documents et facture en ligne au parcours prelevement à travers le parcours mode de paiement
            eDocument : this.eDocument,
            libelleFactureEnLigne : this.libelleFactureEnLigne,
            factureEnLigne : this.factureEnLigne,
            codePostal : this.codePostal,
            listAddress : this.listAddress,
            numCompteClientActuel : this.NoCompteContrat,
            pce : this.pce,
            pdl : this.pdl,
            idContratGaz : this.idContratGaz,
            idContratElec : this.idContratElec,
            codeINSEE: this.codeINSEE,
            numeroLocal: this.numeroLocal
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }


    NavigationMens() {
        const eventName = 'openMens';
        const inputMap = {
            bp : this.bp,
            AccountId : this.AccountId,
            numeroVoie : this.numeroVoie,
            libelleVoie : this.libelleVoie,
            complementAdresse : this.complementAdresse,
            ville : this.ville,
            codePostal : this.codePostal,
            listAddress : this.listAddress,
            numCompteClientActuel : this.NoCompteContrat,
            solde : this.solde,
            pce : this.pce,
            pdl : this.pdl,
            idContratGaz : this.idContratGaz,
            idContratElec : this.idContratElec,
            iBAN: this.iBAN,
            codeINSEE: this.codeINSEE,
            numeroMandat: this.numeroMandat,
            isPrelevee: this.isPrelevee,
            numeroLocal: this.numeroLocal,
            dateTheoriqueReleve: this.dateTheoriqueReleve,
            dateReelleProchaineFacture: this.dateReelleProchaineFacture,
            dateTechniqueProchaineFacture: this.dateTechniqueProchaineFacture,
            montantEcheance: this.montantEcheance,
            montantCumuleEcheance: this.montantCumuleEcheance,
            EnqSat: this.EnqSat

        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
}