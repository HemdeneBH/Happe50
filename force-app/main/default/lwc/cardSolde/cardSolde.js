import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";

export default class CardSolde extends NavigationMixin(LightningElement) {
    @api listrecord;
    @api index;Json
    @api selecteditem;
    @track selecteditem;
    @api recordid;
    @api conditionPaiement;

    //FT2-1445 : on a ajouter isBlocageRelance pour gérer l'affichage des boutons de création ou de modification des blocages relance dans le parcours recouvrement 

    @api isBlocageRelance=false;

    formatNumber (value) {
        let input = value;
        let decimal = "00"
        let entier = "";
        input = input.toString();
        let decArr=input.split(".");
        if(decArr.length>1){
            let dec = decArr[1].length;
            if(dec === 1) {
                decimal = decArr[1] + "0";
            } else if (dec === 2) {
                decimal = decArr[1];
            } else if (dec > 2) {
                if (parseInt(decArr[1].substring(2, 3)) >=5){
                    let digit = parseInt(decArr[1].substring(1, 2))+1;
                    decimal = decArr[1].substring(0, 1)+digit;
                } else {
                    decimal = decArr[1].substring(0, 2);
                }
            }
        }
        if(decArr[0].length > 3) {
            let j = 0
            for ( let i = decArr[0].length - 1; i >= 0; i-- ) {
                if ( j > 0 && j % 3 === 0) {
                    entier= decArr[0][i] + " " + entier;
                } else {
                    entier= decArr[0][i] + entier;
                }
                j++;
            }
        } else {
            entier= decArr[0];
        }
        return entier.concat(',', decimal);
    }
    //Visibilité du Loader sur la card
    get showSpinner() {
        return this.selecteditem.key >=0 && this.listrecord[this.index] && this.listrecord[this.index].solde !== undefined;
    }

    //FT2-1839 - [PROD][VUE 360] - Données financières incorrectes - FI01204764
    //Vérifier si le client est résilié
    get isResilie(){
        let isResilieTrue = (!this.listrecord[this.index].contratactifelecWS && !this.listrecord[this.index].contratactifgazWS && (this.listrecord[this.index].contratinactifelecWS || this.listrecord[this.index].contratinactifgazWS)) ? true : false
        return isResilieTrue;
    }

    get getDateSolde() {
        let tempDate;
        if (this.selecteditem.modePaiement === "mensualisé" && this.isDateEcheanceMensualisee) {
            tempDate = new Date(this.dateEcheanceMensualisee.split('/')[2], this.dateEcheanceMensualisee.split('/')[1] - 1, this.dateEcheanceMensualisee.split('/')[0]);
        } else if (this.selecteditem.modePaiement === "mensualisé" && this.isDateEcheanceMensualiseeAvecRegul) {
            tempDate = new Date(this.selecteditem.factureRegul.dateEcheance);
        } else {
            tempDate = new Date(this.transformDateEcheance.split('/')[2], this.transformDateEcheance.split('/')[1] - 1, this.transformDateEcheance.split('/')[0]);
        }
        return tempDate;
    }
    //True Si la couleur du solde est noire
    //TODO mettre à jour dès qu'on récupèrer l'api Facture
    get isBlackSolde() {
        let toDay = new Date();
        if ( (!this.selecteditem.solde 
                ||(this.selecteditem.solde && !this.selecteditem.solde.solde)
                || (this.selecteditem.solde.solde > 0 && (!this.getDateSolde || this.getDateSolde > toDay)) 
                || this.selecteditem.solde.solde === 0) 
                && this.isResilie === false) { //FT2-1839 - [PROD][VUE 360] - Données financières incorrectes - FI01204764 - Ajout de la vérification (Le client ne doit pas être résilié)
            return true;
        }
        return false;
    }
    //True Si la couleur du solde est Bleu
    get isBlueSolde() {
        if ( this.selecteditem.solde && this.selecteditem.solde.solde < 0) {
            return true;
        }
        return false;
    }
    //True Si la couleur du solde est rouge
    get isRedSolde() {
        let toDay = new Date();
        if((this.selecteditem.solde && this.selecteditem.solde.solde > 0 && this.getDateSolde < toDay) 
        || this.isResilie === true){  //FT2-1839 - [PROD][VUE 360] - Données financières incorrectes - FI01204764 - Ajout de la vérification (Affichage en rouge si le client est résilié)
            return true;
        }
        return false;
    }
    get isNoColorSolde () {
        return !this.isRedSolde && !this.isBlueSolde && !this.isBlackSolde;
    }
    //si c'est un dossier de recouvrement
    get isRecouvrement() {
        return this.selecteditem 
            && this.selecteditem.LireCompteClientReturn 
            && this.selecteditem.LireCompteClientReturn.DossierRecouvrement === 'true';
    }
    //ft3-646 22-04-2022
    get isNotRecouvrement() {
        return this.selecteditem 
        &&this.selecteditem.irrecouvrable;
    }
    //Filtre pour la valeur solde
    get montantTotalFormater() {
        if(this.selecteditem 
            && this.selecteditem.LireCompteClientReturn 
            && this.selecteditem.LireCompteClientReturn.montantTotal) {
            return (this.formatNumber (this.selecteditem.LireCompteClientReturn.montantTotal));
                }
        return "";
            }
    //Filtre pour la valeur solde
    get soldeFormater() {
        if(this.selecteditem && this.selecteditem.solde && this.selecteditem.solde.solde) {
            return (this.formatNumber (this.selecteditem.solde.solde));
        } else if( this.selecteditem && (this.selecteditem.solde === {} || (this.selecteditem.solde && this.selecteditem.solde.solde === 0)) ){
            return "0,00";
        }
        return "";
    }
    //Solde supérieur à 0
    get positifSolde () {
        if(this.selecteditem && this.selecteditem.solde && this.selecteditem.solde.solde > 0) {
            return true;
        }
        return false
    }
    get isDateEcheanceMensualisee () {
        return this.selecteditem && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.dateEcheance
    }
    get showDelai () {
        return !(this.selecteditem.modePaiement === 'mensualisé' && !this.selecteditem.isRegul)
    }
    get isDateEcheanceMensualiseeAvecRegul () {
        return this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance ;
    }
    
    // FT2-1775 [PROD et PPROD] [DP] Lien "Délai de paiement" non cliquable.
    get dateEcheanceMensualiseeAvecRegul () {
        if(this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance){
            return this.selecteditem.factureRegul.dateEcheance.split("-")[2] + '/' +this.selecteditem.factureRegul.dateEcheance.split("-")[1] + '/' + this.selecteditem.factureRegul.dateEcheance.split("-")[0];
        }
        return '';
    }
    get dateEcheanceMensualisee() {
        let tempDate = this.selecteditem.dernierPlanMensualisation.dateEcheance.split('/')
        return tempDate[1] + '/' + tempDate[0] + '/' + tempDate[2];
    }
    get transformDateEcheance () {
        if(this.selecteditem && this.selecteditem.dateEcheance) {
            return this.selecteditem.dateEcheance.split("-")[2] + '/' + this.selecteditem.dateEcheance.split("-")[1] + '/' + this.selecteditem.dateEcheance.split("-")[0];
        }
        return '';
    }

    //FT2-1445 : Conditionner l'affichage des boutons Créer et Modifier/Supprimer un Blocage dans le parcours recouvrement

    get checkBlocageRelance(){

        let today = new Date();
        console.log(this.selecteditem.firstBlocage.dateDebutBlocage);
        console.log(this.selecteditem.firstBlocage.dateFinBlocage);
        if(this.selecteditem.firstBlocage && this.selecteditem.firstBlocage.dateDebutBlocage && this.selecteditem.firstBlocage.dateFinBlocage
         ){
             
              let tempToday = today.toISOString().split("T")[0].split('-');
            tempToday = new Date(tempToday[0] + '-' + tempToday[1] + '-' + tempToday[2] + 'T00:00:00.0');
        
             if(tempToday >= new Date(this.selecteditem.firstBlocage.dateDebutBlocage) && tempToday <= new Date(this.selecteditem.firstBlocage.dateFinBlocage) ){
                 return true;
             }
         }
         return false;
    }

    // FT2-1303 - [Suivi de coupure] Affichage infos client & demande sur facturation

    get checkDRP(){
        if (this.listrecord[this.index].conditionPaiement && this.listrecord[this.index].conditionPaiement!=='+14B') {
            return "Oui";
        } 
        return "Non";
    }

    ///FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
    get PDLnumber(){
        if (this.listrecord[this.index].contratactifelecWS){
            return this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison;
        }
        return "";
    }

    //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
    get contratId(){
        if (this.listrecord[this.index].contratactifelecWS){
            return this.listrecord[this.index].contratactifelecWS.idContrat;
        }
        return "";
    }

    /*navigateToContSynDP(){
        console.log("ouverture délai paiement");
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_Cont_SynDP'
            },
            state: {
                c__numeroVoie: this.selecteditem.numeroVoie.toString(),
                c__libelleVoie: this.selecteditem.libelleVoie.toString(),
                c__complementAdresse: this.selecteditem.complementAdresse.toString(),
                c__codePostal: this.selecteditem.codePostal.toString(),
                c__NoCompteContrat: this.selecteditem.NoCompteContrat.toString(),
                c__NoCompteContratMaj: this.selecteditem.NoCompteContratMaj.toString(),
                c__ville: this.selecteditem.ville.toString(),
                c__recordId: this.recordid,
                c__IdBusinessPartner: this.selecteditem.IdBusinessPartner,
                c__solde: this.selecteditem.solde ? this.selecteditem.solde.solde : '',
                c__soldeFormat: this.soldeFormater,
                c__AccountId: this.selecteditem.AccountId,
                c__iBAN: this.selecteditem.iBAN,
                c__nomInstitutBancaire: this.selecteditem.nomInstitutBancaire
            }
        }); 
    }
    */
   delaiPaiement() {
    setCache().then(r => {
      const eventName = "opendelaipaiement";
      const inputMap = {
        callType: "New",
        numeroVoie : this.selecteditem.numeroVoie.toString(),
        libelleVoie: this.selecteditem.libelleVoie.toString(),
        complementAdresse: this.selecteditem.complementAdresse.toString(),
        codePostal: this.selecteditem.codePostal.toString(),
        NoCompteContrat: this.selecteditem.NoCompteContrat.toString(),
        NoCompteContratMaj: this.selecteditem.NoCompteContratMaj.toString(),
        ville: this.selecteditem.ville.toString(),
        recordId: this.recordid,
        IdBusinessPartner: this.selecteditem.IdBusinessPartner,
        solde: this.selecteditem.solde ? this.selecteditem.solde.solde : '',
        soldeFormat: this.soldeFormater,
        AccountId: this.selecteditem.AccountId,
        iBAN: this.selecteditem.iBAN,
        nomInstitutBancaire: this.selecteditem.nomInstitutBancaire,
        EnqSat:this.selecteditem.EnqSat,
        transformDateEcheance: this.transformDateEcheance ? this.transformDateEcheance : this.dateEcheanceMensualiseeAvecRegul// US-0166633 HotFix DLP à ajouter sur le Case // FT2-1687 RECOMMIT Délai de paiement - sauvegarde des infos nécessaires à la validation du superviseur (Envoi de la DLP vers l'écran délai de paiement)
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

  navigateToRecouvrement(){
	// navigation vers Recouvrement
    //FT2-1445 : Envoyer le parametre isBlocageRelance pour Conditionner l'affichage des boutons Créer et Modifier/Supprimer un Blocage dans le parcours recouvrement
   
	const eventName = 'openRecouvrement';
	const inputMap = {
            recordId: this.recordid,
            IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
            IdPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
            NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj,
            NoCompteContrat: this.listrecord[this.index].NoCompteContrat,
            IdDossierRecouvrement: this.selecteditem.LireCompteClientReturn.idDossierRecouvrement,
            AccountId: this.selecteditem.AccountId,
            isBlocageRelance: this.checkBlocageRelance,


            // FT2-1303 - [Suivi de coupure] Affichage infos client & demande sur facturation
            libelleVoie: this.selecteditem.libelleVoie,
            Nvoie: this.selecteditem.numeroVoie,
            complementAdresse: this.selecteditem.complementAdresse,
            CP: this.selecteditem.codePostal,
            ville: this.selecteditem.ville,
            idcompteclient: this.listrecord[this.index].LireCompteClientReturn.idDossierRecouvrement,
            solde:this.listrecord[this.index].solde.soldeActuel,
            modePaiement: this.listrecord[this.index].modePaiement,
            drp:  this.checkDRP,

            ///FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
            PDL: this.PDLnumber,

            //FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
            idContrat: this.contratId,
            EnqSat:this.selecteditem.EnqSat

     };
	 const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
     this.dispatchEvent(event);	
  }

}