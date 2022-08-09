import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';

import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";


export default class FooterView360 extends NavigationMixin(LightningElement) {
    @api listrecord;
    @api index;
    @api recordid;
    @track dataTransmission;
    @track dataResiliation;
    @api selecteditem;
    get showFooter() {
        return this.index >=0 && this.listrecord && this.listrecord[this.index] && this.listrecord[this.index].solde;
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

    get transformDateEcheance () {
        if(this.selecteditem && this.selecteditem.dateEcheance) {
            return this.selecteditem.dateEcheance.split("-")[2] + '/' + this.selecteditem.dateEcheance.split("-")[1] + '/' + this.selecteditem.dateEcheance.split("-")[0];
        }
        return '';
    }

    get isDateEcheanceMensualiseeAvecRegul () {
        return this.defineColorSolde && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance;
    }

    get dateEcheanceMensualiseeAvecRegul () {
        if (this.defineColorSolde) {
            let tempDate = this.selecteditem.factureRegul.dateEcheance.split('-')
            return tempDate[2] + '/' + tempDate[1] + '/' + tempDate[0];
        }
        return '';
    }

    get dateEcheanceMensualisee() {
        if (this.defineColorSolde && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.dateEcheance) {
            let tempDate = this.selecteditem.dernierPlanMensualisation.dateEcheance.split('/')
            return tempDate[1] + '/' + tempDate[0] + '/' + tempDate[2];
        }
        return '';
    }

    //True Si la couleur du solde est Bleu
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


    renderedCallback() {
        this.dataTransmission = JSON.stringify([{
            idPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
            PCE: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : '',
            PDL: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : '',
            idCompteClient: this.listrecord[this.index].NoCompteContrat,
            DateProchaineFacturation: this.listrecord[this.index].dateProchaineFacture,
            colorSolde: this.isRedSolde ? '#c10e24' : (this.isBlueSolde ? '#1E90FF' : '#000000')
        }]);
        this.dataResiliation = JSON.stringify([{
            StatusCodeElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.statutCode : '', 
            StatusCodeGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.statutCode : '', 
            idContratElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.idContrat : '',
            idContratGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.idContrat : '', 
            NumVoie: this.listrecord[this.index].numeroVoie,
            ComplementAdresse: this.listrecord[this.index].complementAdresse,
            Ville: this.listrecord[this.index].ville,
            Rue: this.listrecord[this.index].libelleVoie,
            PostalCode: this.listrecord[this.index].codePostal,
            DateProchaineFacture: this.listrecord[this.index].dateProchaineFacture,
            SoldeEnCours: this.listrecord[this.index].solde ?  this.listrecord[this.index].solde.soldeEnCours : '0,00',
            colorSolde: this.isRedSolde ? '#c10e24' : (this.isBlueSolde ? '#1E90FF' : '#000000'),
            MontantTotalFacture: this.listrecord[this.index].montantTotal,
            MontantTotal: this.listrecord[this.index].dernierPlanMensualisation ? this.listrecord[this.index].dernierPlanMensualisation.montantCumuleEcheance : '',
            ModeEncaissement: this.listrecord[this.index].modeEncaissement,
            DelaiPaiement: true, // A revoir
            DateLimitePaiement: this.listrecord[this.index].dateEcheance,
            modePaiement: this.listrecord[this.index].uniteReleve,
            PCE: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : '',
            PDL: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : ''
        }]);
    }

    handleAction(e) {
        setCache().then(r => {
            console.log(r);
        })
        .catch(error => {
            console.log("got error getSolde", error);
        });
        let inputMap = null;
        if(e.currentTarget.dataset.key) {
            inputMap = JSON.parse(e.currentTarget.dataset.key)[0];
        }
        const eventName = e.currentTarget.dataset.event;
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
        

    }

    navigateToInoConso(){
        // TODO à remettre après la livraison prod
        console.log("Historique conso")
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__SM_Cont_InfoConso'
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
                c__pce: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.numeroPointDeLivraison : ''),
                c__pdl: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.numeroPointDeLivraison : ''),
                c__uniteReleveGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.uniteReleve : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.uniteReleve : ''),
                c__uniteReleveElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.uniteReleve : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.uniteReleve : ''),
                c__dateTechniqueProchaineFacture: this.listrecord[this.index].dateTechniqueProchaineFacture,
                c__dateReelleProchaineFacture: this.listrecord[this.index].dateReelleProchaineFacture,
                c__IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
                c__IdPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
                c__AccountId: this.selecteditem.AccountId
            }
        });
    }
}