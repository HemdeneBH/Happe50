import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api} from 'lwc';
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
    @api isMensualisation;
    @api solde;
    @api pce;
    @api pdl;
    @api idContratElec;
    @api idContratGaz;
    @api codeINSEE;
    @api numeroMandat;
    @api codeStatutMandat;
    @api idDemandeMens;
    @api codeRetourRecherchMens;
    @api idContratRecherche;
    @api idLocal;
    @api isNoDemandeMens;

    connectedCallback() {
        this.callRechercheDemandeMens();
    }

    parcoursPrelevement() {
    }
    parcoursPaiementPonc() {
    }
    parcoursMensualisation(){
    }

    get idContratRecherche(){
        if(this.idContratElec) {
            return this.idContratElec;
        }
        else if(this.idContratGaz) {
            return this.idContratGaz;
        }
    }


    get isNoDemandeMens() {
        return !this.idDemandeMens && (this.codeRetourRecherchMens === "OCTOPUS_rechercherDemandeMensualisation_06" || this.codeRetourRecherchMens === "OCTOPUS_rechercherDemandeMensualisation_01");
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

    callRechercheDemandeMens() {
        let inputRechercheDemandeMap = {
            idContratRecherche: this.idContratRecherche,
            idPersonne: this.bp,
            idCompteClient: this.NoCompteContrat
        };
        console.log(inputRechercheDemandeMap);
        callIP({ inputMap: inputRechercheDemandeMap, NameIntergation: 'IP_SM_RechercherDemandeMensualisation_Smile' }).then(result => {
            if(result) {
                this.codeRetourRecherchMens = result.codeRetour;
                this.idDemandeMens = result.idDemandeMensualisation;
                this.statutDemandeMens = result.statutDemande;
                console.log("idDemandeMens :",this.idDemandeMens);
                console.log("codeRetourRecherchMens :",this.codeRetourRecherchMens);
                console.log("isNoDemandeMens :",this.isNoDemandeMens);
                console.log("statutDemandeMens :",this.statutDemandeMens);

            }
        }).catch(error => {
            console.log("got error IP_SM_RechercherDemandeMensualisation", error);
        });

    }


    parcoursModificationCOOB(){
    }
    parcoursAjoutCOOB(){
    }
    parcoursAjoutDRP (){
    }
    NavigationPrel() {
        const eventName = 'openprel';
        const inputMap = {
            bp : this.bp,
            numeroVoie : this.numeroVoie,
            libelleVoie : this.libelleVoie,
            complementAdresse : this.complementAdresse,
            ville : this.ville,
            codePostal : this.codePostal,
            listAddress : this.listAddress,
            numCompteClientActuel : this.NoCompteContrat,
            pce : this.pce,
            pdl : this.pdl,
            idContratGaz : this.idContratGaz,
            idContratElec : this.idContratElec,
            codeINSEE: this.codeINSEE,
            idLocal: this.idLocal
           
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    NavigationMens() {
        const eventName = 'openMens';
        const inputMap = {
            bp : this.bp,
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
            idLocal: this.idLocal
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
}