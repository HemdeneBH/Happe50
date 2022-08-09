import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';
export default class CardPaiementFacturation extends NavigationMixin(LightningElement) {
    @api listrecord;
    @api index;
    @api selecteditem;
    @track selecteditem;
    @api recordid;
    @api notesdebitscredits;
    dataFlyout = null;
    initData = true;
    isGaz;
    isElec;
    iservice1;
    isService2;
    numberPas = 0;
    get noteDebitCreditWarning() {
        let iswarning = false;
        if(this.notesdebitscredits != null && this.notesdebitscredits.x_data != null){
            for(let i=0; i<this.notesdebitscredits.x_data.length; i++){


                if(this.notesdebitscredits.x_data[i].statut === 'A valider' || this.notesdebitscredits.x_data[i].statut === 'Refusé' || this.notesdebitscredits.x_data[i].statut === 'Erreur' || this.notesdebitscredits.x_data[i].statut === 'Erreur auto'){
                     iswarning = true;
                }
            }
        }
        return iswarning;
    }
    get showSpinner() {
        return this.selecteditem && (this.selecteditem.loadFacture || this.selecteditem.errorContratWs);
    }
    get isMensualisee() {
        return this.selecteditem && this.selecteditem.modePaiement === 'mensualisé';
    }
    get isClientAide() {
        return this.selecteditem.solde && this.selecteditem.solde.clientAide === true ;
    }
    get isPrelevee() {
        return this.selecteditem && this.selecteditem.modePaiement === 'Prélevé';
    }
    get noDataPlanMesualisee () {
        return this.selecteditem && (!this.selecteditem.lirePlanMensualisationResponse || !this.selecteditem.dernierPlanMensualisation) && this.selecteditem.loadMensualisee;
    }
    get isNonPrelevee() {
        return this.selecteditem && this.selecteditem.modePaiement === 'Non prélevé';
    }
    get isNotNothing() {
        return this.selecteditem && this.selecteditem.modePaiement !== 'Non prélevé' && this.selecteditem.modePaiement !== 'Prélevé' && this.selecteditem.modePaiement !== 'mensualisé';
    }
    get isDRPIndisponible(){
        return this.selecteditem && this.selecteditem.conditionPaiementMaj === 'Information DRP indisponible'
    }
    get isStatutMondatColture() {
        return this.selecteditem && this.selecteditem.codeStatutMandat === '6' && this.selecteditem.libelleStatutMandat === 'Clôturé';
    }
    get isStatutMondatConfirmer() {
        return this.selecteditem && this.selecteditem.codeStatutMandat === '2' && this.selecteditem.libelleStatutMandat === 'A Confirmer';
    }
    get isStatutMondatError() {
        return this.selecteditem && this.selecteditem.libelleStatutMandat === 'error';
    }
    get transformDateComptable () {
        return this.selecteditem.dateComptable.split("-")[2] + '/' + this.selecteditem.dateComptable.split("-")[1] + '/' + this.selecteditem.dateComptable.split("-")[0]
    }
    get transformDateEcheance () {
        if(this.selecteditem && this.selecteditem.dateEcheance) {
            return this.selecteditem.dateEcheance.split("-")[2] + '/' + this.selecteditem.dateEcheance.split("-")[1] + '/' + this.selecteditem.dateEcheance.split("-")[0];
        }
        return '';
    }

    get dossierSolidariteIconName() {
        if(this.selecteditem.solde && this.selecteditem.solde.clientAide === true)
        return 'utility:warning';
        return 'utility:info';
    }

    get dossierSolidariteVariant(){
        if(this.selecteditem.solde && this.selecteditem.solde.clientAide === true)
        return 'warning';
        return 'info';
    }
    get defineColorSolde() {
        return this.selecteditem  && this.listrecord[this.index] && this.listrecord[this.index].solde !== undefined;
    }
    get getDateSolde() {
        let tempDate;
        if (this.defineColorSolde) {
            if (this.selecteditem.modePaiement === "mensualisé" && this.isDateEcheanceMensualisee) {
                tempDate = new Date(this.dateEcheanceMensualisee.split('/')[2], this.dateEcheanceMensualisee.split('/')[1], this.dateEcheanceMensualisee.split('/')[0]);
            } else if (this.selecteditem.modePaiement === "mensualisé" && this.isDateEcheanceMensualiseeAvecRegul) {
                tempDate = new Date(this.selecteditem.factureRegul.dateEcheance);
            } else {
                tempDate = new Date(this.transformDateEcheance.split('/')[2], this.transformDateEcheance.split('/')[1], this.transformDateEcheance.split('/')[0]);
            }
        }
        return tempDate;
    }
    get isDateEcheanceMensualiseeAvecRegul () {
        return this.defineColorSolde && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance;
    }
    get dateEcheanceMensualiseeAvecRegul () {
        if (this.defineColorSolde) {
            let tempDate = this.selecteditem.factureRegul.dateEcheance.split('-');
            return tempDate[2] + '/' + tempDate[1] + '/' + tempDate[0];
        }
        return '';
    }


    get isDateEcheanceMensualisee () {
        return this.selecteditem && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.dateEcheance
    }
    get dateEcheanceMensualisee() {
        let tempDate = this.selecteditem.dernierPlanMensualisation.dateEcheance.split('/')
        return tempDate[1] + '/' + tempDate[0] + '/' + tempDate[2];
    }
    get isMensualisationClose() {
        return this.selecteditem && !this.selecteditem.closemensualisation;
    }
    get isMensualisationOpen() {
        return this.selecteditem && this.selecteditem.closemensualisation;
    }
    get montantGlobal() {
        let montantGlobal = "0,00 €";
        if(this.selecteditem && this.selecteditem.mensualisations && this.selecteditem.mensualisations.length ) {
            montantGlobal = parseFloat(this.selecteditem.mensualisations[0].montantGlobal).toFixed(2).replace('.', ',') + " €";
        }
        return montantGlobal;
    }
    get montantPaye() {
        let montantPaye = "0,00 €";
        if(this.selecteditem && this.selecteditem.mensualisations && this.selecteditem.mensualisations.length ) {
            montantPaye = 0;
            for (let i = 0; i < this.selecteditem.mensualisations.length ; i++) {
                if(this.selecteditem.mensualisations[i].code === "9") {
                    montantPaye += parseFloat(this.selecteditem.mensualisations[i].montantEcheance);
                }
            }
            montantPaye = montantPaye.toFixed(2).replace('.', ',') + " €";
        }
        return montantPaye;
    }
    get getMontantTotal() {
        if (this.selecteditem && this.selecteditem.montantTotal) {
            return this.selecteditem.montantTotal.toFixed(2).replace('.', ',') + '€';
        }
        return '';
    }
    get showCumule() {
        return this.numberPas === 1;
    }
    get getDateComptablePrelevee() {
        if( this.selecteditem && this.selecteditem.dateComptable ) {
            let tempDate = this.selecteditem.dateComptable.split('-');
            return tempDate[2]  + '/' + tempDate[1] + '/' + tempDate[0];
        }
        return '';
    }
    get getDateComptable() {
        if( this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateComptable ) {
            let tempDate = this.selecteditem.factureRegul.dateComptable.split('-');
            return tempDate[2]  + '/' + tempDate[1] + '/' + tempDate[0];
        }
        return '';
    }
    get getDateEcheance() {
        if( this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance ) {
            let tempDate = this.selecteditem.factureRegul.dateEcheance.split('-');
            return tempDate[2]  + '/' + tempDate[1] + '/' + tempDate[0];
        }
        return '';
    }


    //True Si la couleur du solde est bleu
    get isBlueSolde() {
        if ( this.defineColorSolde && this.selecteditem.solde && this.selecteditem.solde.solde < 0) {
            return true;
        }
        return false;
    }
    //True Si la couleur du solde est rouge
    get isRedSolde() {
        let toDay = new Date();
        if(this.defineColorSolde && this.selecteditem.solde && this.selecteditem.solde.solde > 0 && this.getDateSolde < toDay){
            return true;
        }
        return false;
    }


    get getiBAN() {
        if(this.selecteditem && this.selecteditem.iBAN) {
            return this.selecteditem.iBAN.substring(0, 4) + '...' +this.selecteditem.iBAN.substring(this.selecteditem.iBAN.length - 4 ,this.selecteditem.iBAN.length);
        }
        return '';
    }
    get getMontantCumuleEcheance (){
        if(this.selecteditem && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.montantCumuleEcheance) {
            return parseFloat(this.selecteditem.dernierPlanMensualisation.montantCumuleEcheance).toFixed(2).replace(".", ",") + ' €';
        }
        return '';
    }
    get soldeFormater() {
        if(this.selecteditem && this.selecteditem.solde && this.selecteditem.solde.solde) {
            let input = this.selecteditem.solde.solde;
            let decimal = "00"
            let entier = "";
            input = input.toString();
            let decArr=input.split(".");
            if(decArr.length>1){
                let dec = decArr[1].length;
                if(dec === 1) {
                    decimal = decArr[1] + "0";
                } else {
                  decimal = decArr[1];
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
        } else if( this.selecteditem && (this.selecteditem.solde === {} || (this.selecteditem.solde && this.selecteditem.solde.solde === 0)) ){
            return "0,00";
        }
        return "";
    }

    get isblocage(){
        return this.listrecord[this.index].blocageRelance || this.listrecord[this.index].blocageFacturation || this.listrecord[this.index].blocageDecaissement || this.listrecord[this.index].blocagePrevelement;
    }

    navigateToBlocage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_BlocageComp'
            },
            state: {
                c__numeroVoie: this.listrecord[this.index].numeroVoie,
                c__libelleVoie: this.listrecord[this.index].libelleVoie,
                c__complementAdresse: this.listrecord[this.index].complementAdresse,
                c__codePostal: this.listrecord[this.index].codePostal,
                c__ville: this.listrecord[this.index].ville,
                c__recordId: this.recordid,
                c__blocageRelance: this.listrecord[this.index].blocageRelance,
                c__libelleMotifBlocageRelance: this.listrecord[this.index].libelleMotifBlocageRelance,
                c__dateDebutBlocageRelance: this.listrecord[this.index].dateDebutBlocageRelance,
                c__dateFinBlocageRelance: this.listrecord[this.index].dateFinBlocageRelance,
                c__blocageFacturation: this.listrecord[this.index].blocageFacturation,
                c__libelleMotifBlocageFacturation: this.listrecord[this.index].libelleMotifBlocageFacturation,
                c__dateDebutBlocageFacturation: this.listrecord[this.index].dateDebutBlocageFacturation,
                c__dateFinBlocageFacturation: this.listrecord[this.index].dateFinBlocageFacturation,
                c__blocageDecaissement: this.listrecord[this.index].blocageDecaissement,
                c__libelleMotifBlocageDecaissement: this.listrecord[this.index].libelleMotifBlocageDecaissement,
                c__dateDebutBlocageDecaissement: this.listrecord[this.index].dateDebutBlocageDecaissement,
                c__dateFinBlocageDecaissement: this.listrecord[this.index].dateFinBlocageDecaissement,
                c__blocagePrevelement: this.listrecord[this.index].blocagePrevelement,
                c__libelleMotifBlocagePrevelement: this.listrecord[this.index].libelleMotifBlocagePrevelement,
                c__dateDebutBlocagePrevelement: this.listrecord[this.index].dateDebutBlocagePrevelement,
                c__dateFinBlocagePrevelement: this.listrecord[this.index].dateFinBlocagePrevelement
            }
        });
    }
    navigateToModePaiement(){
        let isResilie = (!this.listrecord[this.index].contratactifelecWS && !this.listrecord[this.index].contratactifgazWS && (this.listrecord[this.index].contratinactifelecWS || this.listrecord[this.index].contratinactifgazWS)) ? true : false
        let isMensualisation = true;
        if(!this.listrecord[this.index].contratactifelecWS && !this.listrecord[this.index].contratactifgazWS) {
            isMensualisation = false;
        } else if(this.listrecord[this.index].contratactifelecWS && 
            ( this.listrecord[this.index].contratactifelecWS.statutCode === 'E0009' ||
              this.listrecord[this.index].contratactifelecWS.statutCode === 'E0007' ||
              this.listrecord[this.index].contratactifelecWS.statutCode === 'E0008')) {
            isMensualisation = false;
        } else if (this.listrecord[this.index].contratactifgazWS && 
            ( this.listrecord[this.index].contratactifgazWS.statutCode === 'E0009' ||
              this.listrecord[this.index].contratactifgazWS.statutCode === 'E0007' ||
              this.listrecord[this.index].contratactifgazWS.statutCode === 'E0008')) {
            isMensualisation = false;
        }
        let listAdresses = [];
        for( const adresse of this.listrecord ) {
            if(adresse.NoCompteContrat !== this.listrecord[this.index].NoCompteContrat){
            let adresseTemp = {};
            adresseTemp.IdPortefeuilleContrat = adresse.IdPortefeuilleContrat;
            adresseTemp.NoCompteContrat = adresse.NoCompteContrat;
            adresseTemp.libelleVoie = adresse.libelleVoie;
            adresseTemp.numeroVoie = adresse.numeroVoie;
            adresseTemp.complementAdresse = adresse.complementAdresse;
            adresseTemp.codePostal = adresse.codePostal;
            adresseTemp.ville = adresse.ville;
            listAdresses.push(adresseTemp);
            }
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_Mode_Paiement'
            },
            state: {
                c__numeroVoie: this.listrecord[this.index].numeroVoie,
                c__libelleVoie: this.listrecord[this.index].libelleVoie,
                c__complementAdresse: this.listrecord[this.index].complementAdresse,
                c__codePostal: this.listrecord[this.index].codePostal,
                c__NoCompteContrat: this.listrecord[this.index].NoCompteContrat,
                c__NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj,
                c__ville: this.listrecord[this.index].ville,
                c__recordId: this.recordid,
                c__isPrelevee: this.isPrelevee,
                c__isNonPrelevee: this.isNonPrelevee,
                c__isMensualisee: this.isMensualisee,
                c__conditionPaiement: this.listrecord[this.index].conditionPaiement,
                c__idCoordonneeBancaire: this.listrecord[this.index].idCoordonneeBancaire,
                c__iBAN: this.listrecord[this.index].iBAN,
                c__nomInstitutBancaire: this.listrecord[this.index].nomInstitutBancaire,
                c__titulaireCompte: this.listrecord[this.index].titulaireCompte,
                c__codeStatutMandat: this.listrecord[this.index].codeStatutMandat,
                c__libelleStatutMandat: this.listrecord[this.index].libelleStatutMandat,
                c__numeroMandat: this.listrecord[this.index].numeroMandat,
                c__codeINSEE: this.listrecord[this.index].codeINSEE,
                c__IdBusinessPartner: this.selecteditem.IdBusinessPartner,
                c__isResilie: isResilie,
                c__listAdresses: JSON.stringify(listAdresses),
                c__isMensualisation: isMensualisation,
                c__solde: this.soldeFormater,
                c__dateImpression: this.listrecord[this.index].dateImpression,
                c__conditionPaiementMaj: this.listrecord[this.index].conditionPaiementMaj,
                c__conditionPaiement: this.listrecord[this.index].conditionPaiement,
                c__factureEnLigne: this.listrecord[this.index].factureEnLigne,
                c__libelleFactureEnLigne: this.listrecord[this.index].libelleFactureEnLigne,
                c__dateProchaineFacture: this.listrecord[this.index].dateProchaineFacture,
                c__numeroLocal: this.listrecord[this.index].numeroLocal,
                c__uniteReleveGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.uniteReleve : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.uniteReleve : ''),
                c__uniteReleveElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.uniteReleve : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.uniteReleve : ''),
                c__pce: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.numeroPointDeLivraison : ''),
                c__pdl: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.numeroPointDeLivraison : ''),
                c__idContratGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.idContrat : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.idContrat : ''),
                c__idContratElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.idContrat : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.idContrat : ''),
                c__dateTechniqueProchaineFacture: this.listrecord[this.index].dateTechniqueProchaineFacture,
                c__dateReelleProchaineFacture: this.listrecord[this.index].dateReelleProchaineFacture,
                c__dateTheoriqueReleve: this.listrecord[this.index].dateTheoriqueReleve
                
            }
        });
    }
    navigateToHistoriqueFacture(){
        let listAdresses = [];
        for( const adresse of this.listrecord ) {
            let adresseTemp = {};
            adresseTemp.IdPortefeuilleContrat = adresse.IdPortefeuilleContrat;
            adresseTemp.NoCompteContrat = adresse.NoCompteContrat;
            adresseTemp.libelleVoie = adresse.libelleVoie;
            adresseTemp.numeroVoie = adresse.numeroVoie;
            adresseTemp.complementAdresse = adresse.complementAdresse;
            adresseTemp.codePostal = adresse.codePostal;
            adresseTemp.ville = adresse.ville;
            listAdresses.push(adresseTemp);
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_Historique_Factures'
            },
            state: {
                c__numeroVoie: this.listrecord[this.index].numeroVoie.toString(),
                c__libelleVoie: this.listrecord[this.index].libelleVoie.toString(),
                c__complementAdresse: this.listrecord[this.index].complementAdresse.toString(),
                c__codePostal: this.listrecord[this.index].codePostal.toString(),
                c__NoCompteContrat: this.listrecord[this.index].NoCompteContrat.toString(),
                c__NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj.toString(),
                c__ville: this.listrecord[this.index].ville.toString(),
                c__IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
                c__IdPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
                c__recordId: this.recordid,
                c__pce: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.numeroPointDeLivraison : ''),
                c__pdl: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.numeroPointDeLivraison : ''),
                c__uniteReleveGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.uniteReleve : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.uniteReleve : ''),
                c__uniteReleveElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.uniteReleve : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.uniteReleve : ''),
                c__dateTechniqueProchaineFacture: this.listrecord[this.index].dateTechniqueProchaineFacture,
                c__dateReelleProchaineFacture: this.listrecord[this.index].dateReelleProchaineFacture,
                c__AccountId: this.selecteditem.AccountId,
                c__listAdresses: JSON.stringify(listAdresses),
                c__solde: this.soldeFormater,
                c__DLP: (this.transformDateEcheance)?this.transformDateEcheance:(this.isDateEcheanceMensualiseeAvecRegul)?this.dateEcheanceMensualiseeAvecRegul:'',
                c__soldeColor: this.isRedSolde ? '%23c10e24' : ((this.isBlueSolde) ? '%231E90FF' : '%23000000')


            }
        });
    }
    navigateToNoteDebitCredit(){
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__smNoteDebitCredit_cont'
            },
            state: {
                c__listnotedebitcredit: JSON.stringify(this.notesdebitscredits),
                c__recordId: this.recordid,
                c__AccountId: this.selecteditem.AccountId,
                c__IdBusinessPartner: this.selecteditem.IdBusinessPartner
                //c__idtier: JSON.stringify(listAdresses)
            }
        });
    }
    navigateToDossierSolidarite(){
        let listAdresses = [];
        for( const adresse of this.listrecord ) {
            let adresseTemp = {};
            adresseTemp.IdPortefeuilleContrat = adresse.IdPortefeuilleContrat;
            adresseTemp.NoCompteContrat = adresse.NoCompteContrat;
            adresseTemp.libelleVoie = adresse.libelleVoie;
            adresseTemp.numeroVoie = adresse.numeroVoie;
            adresseTemp.complementAdresse = adresse.complementAdresse;
            adresseTemp.codePostal = adresse.codePostal;
            adresseTemp.ville = adresse.ville;
            listAdresses.push(adresseTemp);
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_Dossier_Solidarite'
            },
            state: {
                c__numeroVoie: this.listrecord[this.index].numeroVoie.toString(),
                c__libelleVoie: this.listrecord[this.index].libelleVoie.toString(),
                c__complementAdresse: this.listrecord[this.index].complementAdresse.toString(),
                c__codePostal: this.listrecord[this.index].codePostal.toString(),
                c__NoCompteContrat: this.listrecord[this.index].NoCompteContrat.toString(),
                c__NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj.toString(),
                c__ville: this.listrecord[this.index].ville.toString(),
                c__IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
                c__IdPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
                c__recordId: this.recordid,
                c__pce: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.numeroPointDeLivraison : ''),
                c__pdl: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.numeroPointDeLivraison : ''),
                c__uniteReleveGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.uniteReleve : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.uniteReleve : ''),
                c__uniteReleveElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.uniteReleve : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.uniteReleve : ''),
                c__dateTechniqueProchaineFacture: this.listrecord[this.index].dateTechniqueProchaineFacture,
                c__dateReelleProchaineFacture: this.listrecord[this.index].dateReelleProchaineFacture,
                c__AccountId: this.selecteditem.AccountId,
                c__listAdresses: JSON.stringify(listAdresses),
                c__solde: this.soldeFormater,
                c__DLP: (this.transformDateEcheance)?this.transformDateEcheance:(this.isDateEcheanceMensualiseeAvecRegul)?this.dateEcheanceMensualiseeAvecRegul:'',
                c__soldeColor: this.isRedSolde ? '%23c10e24' : ((this.isBlueSolde) ? '%231E90FF' : '%23000000')


            }
        });
    }
    transformData() {
        this.initData = false;
        if(this.selecteditem && this.selecteditem.mensualisations && this.selecteditem.mensualisations.length ) {
            this.dataFlyout = [];
            let tempData = JSON.parse(JSON.stringify(this.selecteditem.mensualisations));
            let pas = 1;
            if(tempData.length > 0) {
                if((tempData[1] && tempData[0].dateEcheance !== tempData[1].dateEcheance) || !tempData[1]) {
                    if (tempData[0].secteurActivite === "5G") {
                        this.isGaz = true;
                    } else if (tempData[0].secteurActivite === "5E") {
                        this.isElec = true;
                    } 
                }
                if(tempData[1] && tempData[0].dateEcheance === tempData[1].dateEcheance) {
                    pas++;
                    if (tempData[0].secteurActivite === "5G") {
                        this.isGaz = true;
                    } else if (tempData[0].secteurActivite === "5E") {
                        this.isElec = true;
                    }
                    if (tempData[1].secteurActivite === "5G") {
                        this.isGaz = true;
                    } else if (tempData[1].secteurActivite === "5E") {
                        this.isElec = true;
                    } else if (tempData[1].secteurActivite === "5S") {
                        this.isService1 = true;
                    }
                } 
                if(tempData[2] && tempData[0].dateEcheance === tempData[2].dateEcheance) {
                    pas++;
                    if (tempData[2].secteurActivite === "5S" && this.isService1) {
                        this.isService2 = true;
                    } else {
                        this.isService1 = true;
                    }
                }
                if(tempData[3] && tempData[0].dateEcheance === tempData[3].dateEcheance) {
                    pas++;
                    this.isService2 = true;
                }
                this.numberPas = pas;
            }
            let i = 0
            while(i < tempData.length) {
                let tempObj = {};
                tempObj.key = i;
                tempObj.montantCumuleEcheance = tempData[i].montantCumuleEcheance;
                tempObj.montantGlobal = tempData[i].montantGlobal;
                let date = tempData[i].dateEcheance.split('/')
                tempObj.dateEcheance = date[1] + '/' + date[0] + '/' + date[2];
                // this.dataFlyout.push({key: i});
                switch (tempData[i].code) {
                    case 'OCT_01':
                        tempObj.codeTranscode = 'rejeté';
                        tempObj.colorClass = 'red-reject';
                        tempObj.colorBoldClass = 'red-reject-bold';
                        tempObj.isRejected = true;
                        break;
                    case 'OCT_02':
                        tempObj.codeTranscode = 'prevu';
                        tempObj.colorClass = 'disabled-color';
                        tempObj.colorBoldClass = 'disabled-color';
                        tempObj.isToApprouved = true;
                        break;
                    case '9':
                        tempObj.codeTranscode = 'prélevé';
                        tempObj.colorClass = 'normal-color';
                        tempObj.colorBoldClass = 'normal-color';
                        tempObj.isApprouved = true;
                        break;
                    default:
                        tempObj.codeTranscode = '';
                        tempObj.colorClass = 'normal-color';
                        tempObj.colorBoldClass = 'normal-color';
                }
                for(let j=0; j< pas; j++) {
                    let k = i+j;
                    if(j === (pas-1) && this.isService2) {
                        tempObj.S2 = tempData[k];
                    } else {
                        tempObj[tempData[k].secteurActivite[1]] = tempData[k];
                    }
                }
                this.dataFlyout.push(tempObj);
                i = i + pas ;
            }
        }
    }
    handleOpenRecordClick(){
        if(this.initData) {
            this.transformData();
        }
        let eventName = 'popupevent';
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: {type: 'mensualisation'} });
        this.dispatchEvent(event);
    }
}