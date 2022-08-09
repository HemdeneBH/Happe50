import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";
export default class FooterView360 extends NavigationMixin(LightningElement) {
    @api listrecord;
    @api index;
    @api recordid;
    @track dataTransmission;
    @track dataTransmissionLWC;
    @track dataResiliation;
    @api selecteditem;
    @api listorderedadresses;
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
    // get dateEcheanceMensualisee() {
    //     if (this.defineColorSolde && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.dateEcheance) {
    //         let tempDate = this.selecteditem.dernierPlanMensualisation.dateEcheance.split('/')
    //         return tempDate[1] + '/' + tempDate[0] + '/' + tempDate[2];
    //     }
    //     return '';
    // }
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
    get isMensualisee() {
        return this.selecteditem && this.selecteditem.modePaiement === 'mensualisé';
    }
    get isPrelevee() {
        return this.selecteditem && this.selecteditem.modePaiement === 'Prélevé';
    }
    get isNonPrelevee() {
        return this.selecteditem && this.selecteditem.modePaiement === 'Non prélevé';
    }
    get isDateEcheanceMensualisee () {
        return this.selecteditem && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.dateEcheance
    }
    get dateEcheanceMensualisee() {
        let tempDate = '';
        if (this.isDateEcheanceMensualisee) {
            tempDate = this.selecteditem.dernierPlanMensualisation.dateEcheance.split('/');
            tempDate = tempDate[1] + '/' + tempDate[0] + '/' + tempDate[2];
        }
        return tempDate;
    }
    get montantCumuleEcheance (){
        if(this.selecteditem && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.montantCumuleEcheance) {
            return parseFloat(this.selecteditem.dernierPlanMensualisation.montantCumuleEcheance).toFixed(2).replace(".", ",") + ' €';
        }
        return '';
    }
    get dateComptablePrelevee() {
        if( this.selecteditem && this.selecteditem.dateComptable ) {
            let tempDate = this.selecteditem.dateComptable.split('-');
            return tempDate[2]  + '/' + tempDate[1] + '/' + tempDate[0];
        }
        return '';
    }
    get montantTotal() {
        if (this.selecteditem && this.selecteditem.montantTotal) {
            return this.selecteditem.montantTotal.toFixed(2).replace('.', ',') + ' €';
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
    //Date Régul Mesu & regul
    get getDateEcheance() {
        if( this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance ) {
            let tempDate = this.selecteditem.factureRegul.dateEcheance.split('-');
            return tempDate[2]  + '/' + tempDate[1] + '/' + tempDate[0];
        }
        return '';
    }
    get transformDateEcheance () {
        if(this.selecteditem && this.selecteditem.dateEcheance) {
            return this.selecteditem.dateEcheance.split("-")[2] + '/' + this.selecteditem.dateEcheance.split("-")[1] + '/' + this.selecteditem.dateEcheance.split("-")[0];
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

    renderedCallback() {
        let isActif = false;
        if (( this.listrecord[this.index].contratactifgazWS && (this.listrecord[this.index].contratactifgazWS.statutCode === 'E0004' || this.listrecord[this.index].contratactifgazWS.statutCode === 'E0003') )
            || ( this.listrecord[this.index].contratactifelecWS && (this.listrecord[this.index].contratactifelecWS.statutCode === 'E0004' || this.listrecord[this.index].contratactifelecWS.statutCode === 'E0003') )) {
                isActif = true;
        }
        this.dataTransmission = JSON.stringify([{
            idPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
            PCE: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : '',
            PDL: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : '',
            codeINSEE: this.listrecord[this.index].codeINSEE,
            idCompteClient: this.listrecord[this.index].NoCompteContrat,
            isThereActiveContracts: isActif,
            DateProchaineFacturation: this.listrecord[this.index].dateProchaineFacture,
            colorSolde: this.isRedSolde ? '#c10e24' : (this.isBlueSolde ? '#1E90FF' : '#000000')
        }]);
        this.dataTransmissionLWC = JSON.stringify([{
            idPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
            PCE: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : '',
            PDL: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : '',
            codeINSEE: this.listrecord[this.index].codeINSEE,
            idCompteClient: this.listrecord[this.index].NoCompteContrat,
            isThereActiveContracts: isActif,
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
            PDL: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : '',
            isPrelevee: this.isPrelevee,
            isNonPrelevee: this.isNonPrelevee,
            isMensualisee: this.isMensualisee,
            isRegul: this.selecteditem.isRegul ? this.selecteditem.isRegul : false, //si régul
            dateEcheanceMensualisee: this.dateEcheanceMensualisee, //si Mesualisée
            montantCumuleEcheance: this.montantCumuleEcheance, //Si c'est mensualisée
            dateComptablePreNonPre: this.dateComptablePrelevee, //Si le client est prélevé ou non preleve
            montantTotal: this.montantTotal, //Si preleve ou non preleve
            dateComptable: this.getDateComptable, //date si régul
            datePrelevRegul: this.getDateEcheance, //date Prelevement Regul
            datePrelevementPrel: this.transformDateEcheance, //date Prelevement client Prélevé
            montantTotalRegul: (this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.montantTotal) ? this.selecteditem.factureRegul.montantTotal : '', // Montant Total mensualisé avec régul
            c__offreElec : this.selecteditem.titleElecWS,
            c__offreGaz : this.selecteditem.titleWS,
            AccountId: this.selecteditem.AccountId,
            colorSoldeLWC: this.isRedSolde ? 'red' : (this.isBlueSolde ? 'blue' : 'black') 
        }]);
        this.dataDetectionProject = JSON.stringify([{
            NumVoie: this.listrecord[this.index].numeroVoie,
            ComplementAdresse: this.listrecord[this.index].complementAdresse,
            Ville: this.listrecord[this.index].ville,
            Rue: this.listrecord[this.index].libelleVoie,
            PostalCode: this.listrecord[this.index].codePostal,
            DateProchaineFacture: this.listrecord[this.index].dateProchaineFacture,


            isEngie:isActif,


            IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
            NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj,
            NoCompteContrat: this.listrecord[this.index].NoCompteContrat,


            AccountId: this.selecteditem.AccountId

        }]);
        // AE FT2-1530 ajout de dataDuplicataDocument avec l'IDPorteFeuilleContrat
        this.dataDuplicataDocument = JSON.stringify([{
            AccountId: this.selecteditem.AccountId,
            IdPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat
        }]);        
        this.dataOutilEstimation = JSON.stringify([{
            IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
            AccountId: this.selecteditem.AccountId,
            listOrderedAdresses : this.listorderedadresses
        }]);
    }
    handleAction(e) {
        setCache().then(r => {
            console.log(r);
        })
        .catch(error => {
            console.log("got error cache", error);
        });
        let inputMap = null;
        if(e.currentTarget.dataset.key) {
            inputMap = JSON.parse(e.currentTarget.dataset.key)[0];
        }
        inputMap.EnqSat=JSON.stringify(this.selecteditem.EnqSat);
        console.log(inputMap);
        const eventName = e.currentTarget.dataset.event;
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }

    handleActionHistorique(e) {
        setCache().then(r => {
            console.log(r);
        })
        .catch(error => {
            console.log("got error cache", error);
        });
        let inputMap = {
            IdPersonne: this.listrecord[0].IdBusinessPartner
        };
        console.log('inputMap',inputMap);
        const eventName = e.currentTarget.dataset.event;
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }

    navigateToSituationCompte(){
        // navigation vers Situation de compte
        const eventName = 'openSituationCompte';
        const inputMap = {
            IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
            IdPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
            numeroVoie: this.listrecord[this.index].numeroVoie,
            ville: this.listrecord[this.index].ville,
            libelleVoie: this.listrecord[this.index].libelleVoie,
            complementAdresse:this.listrecord[this.index].complementAdresse,
            codePostal: this.listrecord[this.index].codePostal,
            NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj,
            NoCompteContrat: this.listrecord[this.index].NoCompteContrat,
            solde: this.soldeFormater,
            DLP: (this.transformDateEcheance)?this.transformDateEcheance:(this.isDateEcheanceMensualiseeAvecRegul)?this.dateEcheanceMensualiseeAvecRegul:'',
            soldeColor: this.isRedSolde ? '%23c10e24' : ((this.isBlueSolde) ? '%231E90FF' : '%23000000'),
            EnqSat:JSON.stringify(this.selecteditem.EnqSat)
        };
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }

    navigateToInoConso(){
        // TODO à remettre après la livraison prod
        console.log("Historique conso");
        setCache().then(r => {
            console.log(r);
            let soldeEnCours = this.listrecord[this.index].solde ?  this.listrecord[this.index].solde.soldeEnCours : '0,00';
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
                    c__AccountId: this.selecteditem.AccountId,
                    c__idContratElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.idContrat : '',
                    c__idContratGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.idContrat : '', 
                    c__factureEnLigne: this.listrecord[this.index].factureEnLigne,
                    c__SoldeEnCours: soldeEnCours,
                    c__ModePrelevement: this.isMensualisee ? "mensualisé" : (this.isPrelevee ? "prélevé" : "non prélevé"),
                    c__DLP: (this.transformDateEcheance)?this.transformDateEcheance:(this.isDateEcheanceMensualiseeAvecRegul)?this.dateEcheanceMensualiseeAvecRegul:'',
                    c__offreElec : this.selecteditem.titleElecWS,
                    c__offreGaz : this.selecteditem.titleWS,
                    c__EnqSat:JSON.stringify(this.selecteditem.EnqSat)
                    // c__isSoldePositif: parseFloat(soldeEnCours) > 0
                }
            });
        })
        .catch(error => {
            console.log("got error cache", error);
        });
    }
}