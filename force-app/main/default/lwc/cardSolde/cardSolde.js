import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';

export default class CardSolde extends NavigationMixin(LightningElement) {
    @api listrecord;
    @api index;
    @api selecteditem;
    @track selecteditem;
    @api recordid;

    //Visibilité du Loader sur la card
    get showSpinner() {
        return this.selecteditem.key >=0 && this.listrecord[this.index] && this.listrecord[this.index].solde !== undefined;
    }

    get getDateSolde() {
        let tempDate;
        if (this.selecteditem.modePaiement === "mensualisé" && this.isDateEcheanceMensualisee) {
            tempDate = new Date(this.dateEcheanceMensualisee.split('/')[2], this.dateEcheanceMensualisee.split('/')[1], this.dateEcheanceMensualisee.split('/')[0]);
        } else if (this.selecteditem.modePaiement === "mensualisé" && this.isDateEcheanceMensualiseeAvecRegul) {
            tempDate = new Date(this.selecteditem.factureRegul.dateEcheance);
        } else {
            tempDate = new Date(this.transformDateEcheance.split('/')[2], this.transformDateEcheance.split('/')[1], this.transformDateEcheance.split('/')[0]);
        }
        return tempDate;
    }

    //True Si la couleur du solde est noire
    //TODO mettre à jour dès qu'on récupèrer l'api Facture
    get isBlackSolde() {
        let toDay = new Date();
        if ( !this.selecteditem.solde 
                ||(this.selecteditem.solde && !this.selecteditem.solde.solde)
                || (this.selecteditem.solde.solde > 0 && (!this.getDateSolde || this.getDateSolde > toDay)) 
                || this.selecteditem.solde.solde === 0) {
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
        if(this.selecteditem.solde && this.selecteditem.solde.solde > 0 && this.getDateSolde < toDay){
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

    //Filtre pour la valeur solde
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
        return this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance;
    }

    get dateEcheanceMensualiseeAvecRegul () {
        let tempDate = this.selecteditem.factureRegul.dateEcheance.split('-')
        return tempDate[2] + '/' + tempDate[1] + '/' + tempDate[0];
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


    navigateToContSynDP(){
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
                c__NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj.toString(),
                c__ville: this.selecteditem.ville.toString(),
                c__recordId: this.recordid,
                c__IdBusinessPartner: this.selecteditem.IdBusinessPartner,
                c__solde: this.selecteditem.solde ? this.selecteditem.solde.solde : '',
                c__soldeFormat: this.soldeFormater,
                c__AccountId: this.selecteditem.AccountId
            }
        }); 
    }
}