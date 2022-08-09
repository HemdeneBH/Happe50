import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
import getFlayoutPCEData from '@salesforce/apex/SM_FlayoutPCE.getFlayoutPCEData'
import getFlayoutPDLData from '@salesforce/apex/SM_FlayoutPDL.lirePdl'
import getOffresEtPrix from '@salesforce/apex/SM_AP83_OffresEtPrixVue360.getOffresEtPrix'
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";
export default class CardEnergie extends NavigationMixin(LightningElement) {
    @api contratserviceelecvert;
    @api contratservicegazvert;
    @api contratservicegazvertpourcent
    @api contratactif;
    @api contratactifsecondaire;
    @api title;
    @api contratinactif;
    @api type;
    @api listrecord;
    @api index;
    @api selecteditem;
    @track selecteditem;
    @track flayoutData;
    @track lireContratData = null;
    @track lirePDL = null;
    @track error = false;

    get PuissanceContrat() {
        let puissance = '-'
        if(this.lireContratData && this.lireContratData.puissance) {
            puissance =  typeof(this.lireContratData.puissance) === 'object' ? parseInt(this.lireContratData.puissance[0]) : parseInt(this.lireContratData.puissance)
        }
        return puissance;
    }
    get TypeComptageContrat() {
        let typeComptage = '-'
        if(this.lireContratData && this.lireContratData.typeComptage) {
            typeComptage =  this.lireContratData.typeComptage;
            if (typeComptage.indexOf('Heures pleines / Heures Creuses') > -1 || typeComptage.indexOf('HPHC') > -1) {
                typeComptage = 'Double';
            }
        }
        return typeComptage;
    }

    get getTitle() {
        if( this.title !== undefined ) {
            return this.title.toUpperCase();
        }
        return '';
    }
    //Visibilité du Loader sur la card
    get showSpinner() {
        return (this.selecteditem.key >=0 && (this.listrecord[this.selecteditem.key].loadcontratWS) || (this.listrecord[this.index] && this.listrecord[this.index].errorContratWs));
    }
    // visibilité spinner flyout
    get showSpinnerFlyout() {
        return this.flayoutData || this.error;
    }
    //La couleur du contrat Actif (vert/Oranger)
    get condition() {
        if( this.contratactif && this.contratactif.statutCode === 'E0004') {
            return true;
        }
        return false;
    }

    //Colorisation du statut du contrat service Gaz Vert+
    get getContratServiceGazVertInfo() {
        if(this.contratservicegazvert.statutCode === 'E0004') {
            return true;
        }
        return false;
    }

    //Colorisation du statut du contrat service Elec Vert+
    get getContratServiceElecVertInfo() {
        if(this.contratserviceelecvert.statutCode === 'E0004') {
            return true;
        }
        return false;
    }

    get isResilie() {
        return this.contratactif.statutCode === 'E0007';
    }
    get datePrestationElec() {
        let date = ''
        if(this.selecteditem && this.selecteditem.itemPrestelec && this.selecteditem.itemPrestelec.LirePrestationElecResult && this.selecteditem.itemPrestelec.LirePrestationElecResult.datePrevueIntervention) {
            if(this.selecteditem.itemPrestelec.LirePrestationElecResult.datePrevueIntervention.indexOf('-') !== -1) {
                date = this.selecteditem.itemPrestelec.LirePrestationElecResult.datePrevueIntervention.split('-');
                date = date[2] + '/' + date[1] + '/' + date[0];
            } else {
                date = this.selecteditem.itemPrestelec.LirePrestationElecResult.datePrevueIntervention;
            }
        }
        return date;
    }
    get datePrestationGaz() {
        let date = ''
        if(this.selecteditem && this.selecteditem.itemPrestgaz && this.selecteditem.itemPrestgaz.LirePrestationGAZResult && this.selecteditem.itemPrestgaz.LirePrestationGAZResult.datePrevueIntervention) {
            if(this.selecteditem.itemPrestgaz.LirePrestationGAZResult.datePrevueIntervention.indexOf('-') !== -1) {
                date = this.selecteditem.itemPrestgaz.LirePrestationGAZResult.datePrevueIntervention.split('-');
                date = date[2] + '/' + date[1] + '/' + date[0];
            } else {
                date = this.selecteditem.itemPrestgaz.LirePrestationGAZResult.datePrevueIntervention;
            }
        }
        return date;
    }
    get getDateDebutContrat() {
        let date = '';
        console.log("getDateDebutContrat1");
        if (this.contratactif) {
            console.log("getDateDebutContrat2");
            date = this.contratactif.dateDebutContrat.split('-');
            date = date[2] + '/' + date[1] + '/' + date [0]
        }
        return date;
    }
    get isHCHPORANDWE() {
        return this.flayoutData 
                && this.flayoutData.mapConsoByTypeComptage 
                && (this.flayoutData.mapConsoByTypeComptage.Base 
                    || this.flayoutData.mapConsoByTypeComptage.HC 
                    || this.flayoutData.mapConsoByTypeComptage.HP 
                    || this.flayoutData.mapConsoByTypeComptage.WE
                    || this.flayoutData.mapConsoByTypeComptage.HPH
                    || this.flayoutData.mapConsoByTypeComptage.HCH
                    || this.flayoutData.mapConsoByTypeComptage.HPB
                    || this.flayoutData.mapConsoByTypeComptage.HCB);
    }
    get isHCHPORANDWE_() {
        return this.flayoutData && this.flayoutData.mapConsoByTypeComptage && (this.flayoutData.mapConsoByTypeComptage.Base_ || this.flayoutData.mapConsoByTypeComptage.HP_ || this.flayoutData.mapConsoByTypeComptage.HC_ || this.flayoutData.mapConsoByTypeComptage.WE_)
    }
    get Base_() {
        // let temp = '';
        // if (this.flayoutData && this.flayoutData.mapConsoByTypeComptage && this.flayoutData.mapConsoByTypeComptage.Base_) {
        return this.flayoutData.mapConsoByTypeComptage.Base_.replace('_', '').replace(/\./g, ',');
        // }
        // return temp;
    }
    get HP_() {
        // let temp = '';
        // if (this.flayoutData && this.flayoutData.mapConsoByTypeComptage && this.flayoutData.mapConsoByTypeComptage.HP_) {
        return this.flayoutData.mapConsoByTypeComptage.HP_.replace('_', '').replace(/\./g, ',');
        // }
        // return temp;
    }
    get HC_() {
        // let temp = '';
        // if (this.flayoutData && this.flayoutData.mapConsoByTypeComptage && this.flayoutData.mapConsoByTypeComptage.HC_) {
        return this.flayoutData.mapConsoByTypeComptage.HC_.replace('_', '').replace(/\./g, ',');
        // }
        // return temp;
    }
    get WE_() {
        // let temp = '';
        // if (this.flayoutData && this.flayoutData.mapConsoByTypeComptage && this.flayoutData.mapConsoByTypeComptage.WE_) {
        return this.flayoutData.mapConsoByTypeComptage.WE_.replace('_', '').replace(/\./g, ',');
        // }
        // return temp;
    }
    get OBLIGATIONSFormat() {
        return this.flayoutData.mapConsoByTypeComptage.OBLIGATIONS.replace(/\./g, ',');
    }
    get isOffreTradeOFF(){
        return this.flayoutData && this.flayoutData.typeOffre ===  'TradeOFF';
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
    get statut() {
        let status;
        switch (this.contratactif.statutCode) {
            case 'E0001':
                status = 'MES En cours';
                break;
            case 'E0003':
                status = 'Activé - A répliquer';
                break;
            case 'E0005':
                status = 'Modif. en cours';
                break;
            case 'E0006':
                status = 'Modif. en cours Inter';
                break;
            case 'E0007':
                status = 'Resil. en cours';
                break;
            case 'E0008':
                status = 'Résilié- A répliquer';
                break;
            default:
                status = '';
        }
        return status;   
    }
    get statutPC() {
        let statusPC;
        //Mettre le champs de la PC
        switch (this.contratactif.StatutPropositionCommerciale) {
            case 'E0001':
                statusPC = 'Proposée';
                break;
            case 'E0003':
                statusPC = 'En attente';
                break;
            case 'E0005':
                statusPC = 'CPV envoyées';
                break;
            case 'E0011':
                statusPC = 'Acceptée avec signature';
                break;
            case 'E0013':
                statusPC = 'Acceptée sans signature';
                break;
            case 'E0014':
                statusPC = '1ère relance';
                break;
            case 'E0015':
                statusPC = '2ème relance';
                break;
            case 'E0016':
                statusPC = '3ème relance';
                break;
            default:
                statusPC = '';
        }
        return statusPC;   
    }
    //True Si la card est pour l'energie GAZ
    //Pour afficher le flyout Gaz
    get isGazFlyout() {
        return  this.flayoutData && this.type === 'gaz';
    }
    //True Si la card est pour l'energie GAZ
    //Pour Faire le traitement propre à la prestation gaz
    get isPrestGaz() {
        return  this.type === 'gaz' && this.selecteditem.loadPrestgaz && this.selecteditem.itemPrestgaz && this.selecteditem.itemPrestgaz.LirePrestationGAZResult;
    }
    //True Si la card est pour l'energie ELEC
    //Pour afficher le flyout ELEC
    get isElecFlyout() {
        return this.flayoutData && this.type === 'elec' && !this.error;
    }
    //True Si la card est pour l'energie ELEC
    //Pour Faire le traitement propre à la prestation ELEC
    get isPrestElec() {
        return this.type === 'elec' && this.selecteditem.loadPrestelec && this.selecteditem.itemPrestelec && this.selecteditem.itemPrestelec.LirePrestationElecResult;
    }
    //Visibilité Flyout
    get showHideFlyout () {
        return this.selecteditem['close'+this.type];
    }
    //True s'il y a une OPS ELEC en cours
    get isActionOPSElec () {
        return this.type === 'elec' 
        && this.selecteditem
        && this.selecteditem.loadPrestelec
        && this.selecteditem.itemPrestelec.RecherchePrestationElecResult
        && this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService;
    }
    get libelleOPSElec () {
        let libelle = 'OPS';
        if(this.isActionOPSElec) {
            libelle = 'OPS (' + this.selecteditem.itemPrestelec.RecherchePrestationElecResult.nombreOPS + ' en cours)';
        }
        return libelle;
    }
    //True s'il y a une OPS GAZ en cours
    get isActionOPSGaz () {
        return this.type === 'gaz' 
        && this.selecteditem.loadPrestgaz
        && this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult
        && this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService;
    }
    get libelleOPSGaz () {
        let libelle = 'OPS';
        if(this.isActionOPSGaz) {
            libelle = 'OPS (' + this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.nombreOPS + ' en cours)';
        }
        return libelle;
    }
    //Génerer l'icon pour la card gaz ou elec
    get iconCard(){
        if(this.type === 'gaz') {
            return '/resource/EngieCustomResources/images/contrat_GAZ.svg'
        }
        return '/resource/EngieCustomResources/images/contrat_ELEC.svg';
    }
    get BaseFormatElec() {
        return this.flayoutData.mapConsoByTypeComptage.Base.replace(/\./g, ',');
    }
    get HCBFormatElec() {
        return this.flayoutData.mapConsoByTypeComptage.HCB.replace(/\./g, ',');
    }
    get HPBFormatElec() {
        return this.flayoutData.mapConsoByTypeComptage.HPB.replace(/\./g, ',');
    }
    get HCHFormatElec() {
        return this.flayoutData.mapConsoByTypeComptage.HCH.replace(/\./g, ',');
    }
    get HPHFormatElec() {
        return this.flayoutData.mapConsoByTypeComptage.HPH.replace(/\./g, ',');
    }
    get HPFormatElec() {
        return this.flayoutData.mapConsoByTypeComptage.HP.replace(/\./g, ',');
    }
    get HCFormatElec() {
        return this.flayoutData.mapConsoByTypeComptage.HC.replace(/\./g, ',');
    }
    get WEFormatElec() {
        return this.flayoutData.mapConsoByTypeComptage.WE.replace(/\./g, ',');
    }
    get isConsoGaz() {
        return this.flayoutData && this.flayoutData.mapConsoGazByTypeComptage && this.flayoutData.mapConsoGazByTypeComptage.consoGaz
    }
    get isBase() {
        return this.flayoutData && this.flayoutData.mapConsoByTypeComptage && this.flayoutData.mapConsoByTypeComptage.Base;
    }
    get isHC() {
        return this.flayoutData && this.flayoutData.mapConsoByTypeComptage && this.flayoutData.mapConsoByTypeComptage.HC;
    }
    get isHP() {
        return this.flayoutData && this.flayoutData.mapConsoByTypeComptage && this.flayoutData.mapConsoByTypeComptage.HP;
    }
    get isWE() {
        return this.flayoutData && this.flayoutData.mapConsoByTypeComptage && this.flayoutData.mapConsoByTypeComptage.WE;
    }
    get isNotPrixRemiseElec() {
        return this.flayoutData && !this.flayoutData.mapConsoByTypeComptage;
    }
    get FTALib () {
        if(this.flayoutData.FTALibelle && typeof(this.flayoutData.FTALibelle) === 'object') {
            return this.flayoutData.FTALibelle[0].replace('TARIF BT<=36KVA ', '').replace('BT<=36KVA ', '');
        } else if(this.flayoutData.FTALibelle && typeof(this.lireContratData.FTALibelle) === 'string') {
            return this.flayoutData.FTALibelle.replace('TARIF BT<=36KVA ', '').replace('BT<=36KVA ', '');
        }
        return '';
    }
    get OPSGazLibelle() {
        let temp = '';
        if( this.selecteditem && this.selecteditem.itemPrestgaz && this.selecteditem.itemPrestgaz.LirePrestationGAZResult && this.selecteditem.itemPrestgaz.LirePrestationGAZResult.libelleOPS) {
            temp = this.selecteditem.itemPrestgaz.LirePrestationGAZResult.libelleOPS;
        } else if( this.selecteditem && this.selecteditem.itemPrestgaz && this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult ) {
            temp = this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.libellePrestation;
        }
        return temp;
    }
    get OPSElecLibelle() {
        let temp = '';
        if( this.selecteditem && this.selecteditem.itemPrestelec && this.selecteditem.itemPrestelec.LirePrestationElecResult && this.selecteditem.itemPrestelec.LirePrestationElecResult.libelleOPS) {
            temp = this.selecteditem.itemPrestelec.LirePrestationElecResult.libelleOPS;
        } else if( this.selecteditem && this.selecteditem.itemPrestelec && this.selecteditem.itemPrestelec.RecherchePrestationElecResult ) {
            temp = this.selecteditem.itemPrestelec.RecherchePrestationElecResult.libellePrestation;
        }
        return temp;
    }

    //Added by RJM (FT2-998) 
    get ancienneOffre(){

        return this.contratinactif.statutCode === 'E0005' || this.contratinactif.statutCode === 'E0006';

    }
    //Open MoveIn Omniscript
    //Déclanche un évenement vers le composant aura (composant parent)
    NavigationSouscrire() {
        setCache().then(r => {
            console.log(r);
        })
        .catch(error => {
            console.log("got error cache", error);
        });
        const eventName = 'openmovein';
        const inputMap = {
            MoveInPortefeuilCtr: this.selecteditem.IdPortefeuilleContrat,
            TypeEnergie: this.title,
            CompteClientId: this.selecteditem.NoCompteContrat,
            IdConsumerAccount: this.selecteditem.AccountId,
            PostalCode: this.selecteditem.codePostal,
            NomRue: this.selecteditem.libelleVoie,
            NumVoie: this.selecteditem.numeroVoie,
            ComplementAdresseOS: this.selecteditem.complementAdresse,
            VilleOS: this.selecteditem.ville,
            IdLocal: this.selecteditem.IdLocal,
            eDocument: this.selecteditem.eDocument ? true : false,
            fel: this.selecteditem.factureEnLigne,
            EnqSat:this.selecteditem.EnqSat
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    NavigationSouscrireNew() {
        console.log("new movein");
        const eventName = 'openmoveinnew';
        const inputMap = {
            MoveInPortefeuilCtr: this.selecteditem.IdPortefeuilleContrat,
            TypeEnergie: this.title,
            CompteClientId: this.selecteditem.NoCompteContrat,
            IdConsumerAccount: this.selecteditem.AccountId,
            PostalCode: this.selecteditem.codePostal,
            NomRue: this.selecteditem.libelleVoie,
            NumVoie: this.selecteditem.numeroVoie,
            ComplementAdresseOS: this.selecteditem.complementAdresse,
            VilleOS: this.selecteditem.ville,
            IdLocal: this.selecteditem.IdLocal,
            EnqSat:this.selecteditem.EnqSat
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    handleNeedChange() {
        console.log("envie de changer");
        setCache().then(r => {
            let assurenceFactureActif = this.selecteditem.listServices.filter(service => (service.libOffreMaj && service.libOffreMaj.indexOf("ASSURANCE FACTURE") > -1 &&  service.actif ===  true)).length > 0;
            const eventName = 'openenviechanger';
            const inputMap = {
                pce: (this.type === 'gaz' && this.contratactif && this.contratactif.statutCode === 'E0004') ? this.contratactif.numeroPointDeLivraison: ((this.type === 'elec' && this.contratactifsecondaire && this.contratactifsecondaire.statutCode === 'E0004') ? this.contratactifsecondaire.numeroPointDeLivraison : ""),
                pdl: (this.type === 'elec' && this.contratactif && this.contratactif.statutCode === 'E0004') ? this.contratactif.numeroPointDeLivraison: ((this.type === 'gaz' && this.contratactifsecondaire && this.contratactifsecondaire.statutCode === 'E0004') ? this.contratactifsecondaire.numeroPointDeLivraison : ""),
                idContratGaz: (this.type === 'gaz' && this.contratactif && this.contratactif.statutCode === 'E0004') ? this.contratactif.idContrat: ((this.type === 'elec' && this.contratactifsecondaire && this.contratactifsecondaire.statutCode === 'E0004') ? this.contratactifsecondaire.idContrat : ""),
                idContratElec: (this.type === 'elec' && this.contratactif && this.contratactif.statutCode === 'E0004') ? this.contratactif.idContrat: ((this.type === 'gaz' && this.contratactifsecondaire && this.contratactifsecondaire.statutCode === 'E0004') ? this.contratactifsecondaire.idContrat : ""),
                libelleOffreGaz: (this.type === 'gaz' && this.contratactif && this.contratactif.statutCode === 'E0004') ? this.contratactif.libelleOffre: ((this.type === 'elec' && this.contratactifsecondaire && this.contratactifsecondaire.statutCode === 'E0004') ? this.contratactifsecondaire.libelleOffre : ""),
                libelleOffreElec: (this.type === 'elec' && this.contratactif && this.contratactif.statutCode === 'E0004') ? this.contratactif.libelleOffre: ((this.type === 'gaz' && this.contratactifsecondaire && this.contratactifsecondaire.statutCode === 'E0004') ? this.contratactifsecondaire.libelleOffre : ""),
                codeINSEE: this.selecteditem.codeINSEE,
                codePostal: this.selecteditem.codePostal,
                type: this.type,
                isPrelevee: this.isPrelevee,
                isNonPrelevee: this.isNonPrelevee,
                isMensualisee: this.isMensualisee,
                iBAN: this.selecteditem.iBAN,
                titulaireCompte: this.selecteditem.titulaireCompte,
                nomInstitutBancaire: this.selecteditem.nomInstitutBancaire,
                idCoordonneeBancaire: this.selecteditem.idCoordonneeBancaire,
                codeBIC: this.selecteditem.codeBIC,
                idBusinessPartner: this.selecteditem.IdBusinessPartner,
                rue: this.selecteditem.libelleVoie,
                num: this.selecteditem.numeroVoie,
                ville: this.selecteditem.ville,
                cp: this.selecteditem.codePostal,
                cplt: this.selecteditem.complementAdresse.trim(),
                assurenceFactureActif: assurenceFactureActif,
                IdLocal: this.selecteditem.numeroLocal,
                CompteClientId: this.selecteditem.NoCompteContrat,
                AccountId: this.selecteditem.AccountId,
                EnqSat:this.selecteditem.EnqSat
            }
            const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
            this.dispatchEvent(event);
        })
        .catch(error => {
            console.log("got error cache", error);
        });
    }
    //Open OPS en cours Omniscript
    //Déclanche un évenement vers le composant aura (composant parent)
    NavigationOPS() {
        console.log(this.type);
        const eventName = 'openops';
        let inputMap
        if (this.type === 'gaz') {
            console.log('je suis gaz');
            inputMap = {
                TypeCard: 'GAZ',
                //idPrestationDistributeurEnCours: this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.idsPrestationsServiceEnCoursDistribList,
                //idPrestationDistributeurTerminees: this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.idsPrestationsServiceTermineeDistribList,
                libelleOPS: this.selecteditem.itemPrestgaz.LirePrestationGAZResult.libelleOPS,
                fraisPrestation: this.selecteditem.itemPrestgaz.LirePrestationGAZResult.fraisPrestation,
                soldeDu: this.selecteditem.itemPrestgaz.LirePrestationGAZResult.soldeDu,
                idPrestationServiceFournisseurEnCours: this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.idsPrestationsServiceEnCoursFournisseurList,
                idPrestationServiceFournisseurTerminees: this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.idsPrestationsServiceTermineeFournisseurList,
                rue: this.selecteditem.libelleVoie,
                num: this.selecteditem.numeroVoie,
                ville: this.selecteditem.ville,
                cp: this.selecteditem.codePostal,
                cplt: this.selecteditem.complementAdresse.trim(),
                commentaires: this.selecteditem.itemPrestgaz.LirePrestationGAZResult.commentaireIntervention,
                idContrat: this.contratactif.idContrat,
                nombreOPS: this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.nombreOPS,
                numeroPointDeLivraison : this.contratactif.numeroPointDeLivraison,
                nbreOPSTerminees : this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.nbreOPSTerminees,
                AccountId: this.selecteditem.AccountId,
                EnqSat:this.selecteditem.EnqSat
            }
        } else if (this.type === 'elec') {
            console.log('je suis elec');
            inputMap = {
                TypeCard: 'ELEC',
                //idPrestationDistributeurEnCours: this.selecteditem.itemPrestelec.RecherchePrestationElecResult.idsPrestationsServiceDistribList,
                //idPrestationDistributeurTerminees
                libelleOPS: this.selecteditem.itemPrestelec.LirePrestationElecResult.libelleOPS,
                fraisPrestation: this.selecteditem.itemPrestelec.LirePrestationElecResult.fraisPrestation,
                soldeDu: this.selecteditem.itemPrestelec.LirePrestationElecResult.soldeDu,
                idPrestationServiceFournisseurEnCours: this.selecteditem.itemPrestelec.RecherchePrestationElecResult.idsPrestationsServiceEnCoursFournisseurList,
                idPrestationServiceFournisseurTerminees: this.selecteditem.itemPrestelec.RecherchePrestationElecResult.idsPrestationsServiceTermineeFournisseurList,
                rue: this.selecteditem.libelleVoie,
                num: this.selecteditem.numeroVoie,
                ville: this.selecteditem.ville,
                cp: this.selecteditem.codePostal,
                cplt: this.selecteditem.complementAdresse.trim(),
                commentaires: this.selecteditem.itemPrestelec.LirePrestationElecResult.commentaireIntervention,
                montantPrevisionnel: this.selecteditem.itemPrestelec.LirePrestationElecResult.montantPrevisionnelPrestation,
                idContrat: this.contratactif.idContrat,
                nombreOPS: this.selecteditem.itemPrestelec.RecherchePrestationElecResult.nombreOPS,
                numeroPointDeLivraison : this.contratactif.numeroPointDeLivraison,
                nbreOPSTerminees : this.selecteditem.itemPrestelec.RecherchePrestationElecResult.nbreOPSTerminees,
                AccountId: this.selecteditem.AccountId,
                EnqSat:this.selecteditem.EnqSat
            }
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }
    callPrixRemises(typeEnergy) {
        let idContratActif = this.contratactif ? this.contratactif.idContrat: "";
        let idContratActifSecondaire =  this.contratactifsecondaire ? this.contratactifsecondaire.idContrat : "";
        let inputPrixRemiseMap = null;
        let sommeConso = 0;
        if (typeEnergy === 'Elec' && idContratActif !== idContratActifSecondaire) {
            if (this.lireContratData && this.lireContratData.consommationAnnuelleCadrans && this.lireContratData.consommationAnnuelleCadrans.length > 0 && this.lireContratData.consommationAnnuelleCadrans[0]) {
                let lengthCadrans = this.lireContratData.consommationAnnuelleCadrans.length;
                for (let i = 0 ; i < lengthCadrans ; i++ ) {
                    sommeConso+= parseInt(this.lireContratData.consommationAnnuelleCadrans[i]);
                }
                this.lireContratData.consommationAnnuelleEstimeeElec = sommeConso;
            }
            inputPrixRemiseMap = {
                EnergyTypeOptions: typeEnergy,
                idOffre: this.contratactif.codeOffre ? this.contratactif.codeOffre : '',
                idPack: this.contratactif.idPack ? this.contratactif.idPack : '',

                typeComptageDifferencie: this.lireContratData.typeComptageCode ? this.lireContratData.typeComptageCode : '',

                ftaCode:  this.lireContratData.FTACode ? this.lireContratData.FTACode : '',
                CAEElec: this.lireContratData.consommationAnnuelleEstimeeElec ?  this.lireContratData.consommationAnnuelleEstimeeElec : '',
                // CAE_HC: HC ? parseInt(HC) : '',
                // CAE_HP: HP ? parseInt(HP) : '',
                // CAE_WE: WE ? parseInt(WE) : '',
                Puissance: this.lireContratData.puissance ? (typeof(this.lireContratData.puissance) === 'object' ? parseInt(this.lireContratData.puissance[0]) : parseInt(this.lireContratData.puissance)) : '',
                dateDerniereModificationFormuleTarifaireAcheminement:  new Date(Date.now()).toISOString().slice(0,10)+'T00:00:00',
                niveauOuvertureServices: this.lirePDL.niveauServices ? this.lirePDL.niveauServices.split(' ')[1] : '',
                datePropositionCommerciale: this.lireContratData.dateProposition ? (typeof(this.lireContratData.dateProposition) === 'object' ? this.lireContratData.dateProposition[0] : this.lireContratData.dateProposition)  : '',
                dateEffetContrat: this.lireContratData.dateEffetContractuelle ? (typeof(this.lireContratData.dateEffetContractuelle) === 'object' ? this.lireContratData.dateEffetContractuelle[0] : this.lireContratData.dateEffetContractuelle) : '',
                codeCommune: this.selecteditem.codeINSEE ? this.selecteditem.codeINSEE : '',
                codePostal: this.selecteditem.codePostal ? this.selecteditem.codePostal : '',
                contexteSouscription:'CHGT_FOURN'
            };
        } else if (typeEnergy === 'Gaz' && idContratActif !== idContratActifSecondaire) {
            // Calcul de la plage conso en fontion de la consoAnnuEstimeeGaz
            let codePlageConso_calcul = '';
            if (this.lireContratData && this.lireContratData.consoAnnuEstimeeGaz) {
                if (parseInt(this.lireContratData.consoAnnuEstimeeGaz) <= 5999 ) {
                    codePlageConso_calcul = 6000;
                    this.lireContratData.codePlageConsoLabel = 'de 0 à 6 000 kWh';
                } else if (parseInt(this.lireContratData.consoAnnuEstimeeGaz) <= 29999 ) {
                    codePlageConso_calcul = 30000;
                    this.lireContratData.codePlageConsoLabel = 'de 6 000 à 30 000 kWh';
                } else if (parseInt(this.lireContratData.consoAnnuEstimeeGaz) >= 30000 ) {
                    codePlageConso_calcul = 300000;
                    this.lireContratData.codePlageConsoLabel = 'plus de 30 000 kWh';
                }
            }
            inputPrixRemiseMap = {
                //dateDerniereModificationFormuleTarifaireAcheminement: this.lirePDL.dateDerniereModificationFormuleTarifaireAcheminement ? this.lirePDL.dateDerniereModificationFormuleTarifaireAcheminement : '',
                //niveauOuvertureServices: this.lirePDL.niveauServices ? this.lirePDL.niveauServices.split(' ')[1] : '',
                datePropositionCommerciale: this.lireContratData.dateProposition ? (typeof(this.lireContratData.dateProposition) === 'object' ? this.lireContratData.dateProposition[0] : this.lireContratData.dateProposition)  : '',
                dateEffetContrat: this.lireContratData.dateEffetContractuelle ? (typeof(this.lireContratData.dateEffetContractuelle) === 'object' ? this.lireContratData.dateEffetContractuelle[0] : this.lireContratData.dateEffetContractuelle) : '',
                codePlageConso: codePlageConso_calcul,
                EnergyTypeOptions: typeEnergy,
                idOffre: this.contratactif.codeOffre ? this.contratactif.codeOffre : '',
                idPack: this.contratactif.idPack ? this.contratactif.idPack : '',
                codeCommune: this.selecteditem.codeINSEE ? this.selecteditem.codeINSEE : '',
                codePostal: this.selecteditem.codePostal ? this.selecteditem.codePostal : ''
            };
        } else if (idContratActif === idContratActifSecondaire && typeEnergy === 'Dual') {
            if (this.lireContratData && this.lireContratData.consommationAnnuelleCadrans && this.lireContratData.consommationAnnuelleCadrans.length > 0 && this.lireContratData.consommationAnnuelleCadrans[0]) {
                let lengthCadrans = this.lireContratData.consommationAnnuelleCadrans.length;
                for (let i = 0 ; i < lengthCadrans ; i++ ) {
                    sommeConso+= parseInt(this.lireContratData.consommationAnnuelleCadrans[i]);
                }
                this.lireContratData.consommationAnnuelleEstimeeElec = sommeConso;
            }
            let codePlageConso_calcul = '';
            if (this.lireContratData && this.lireContratData.consoAnnuEstimeeGaz) {
                if (parseInt(this.lireContratData.consoAnnuEstimeeGaz) <= 5999 ) {
                    codePlageConso_calcul = 6000;
                    this.lireContratData.codePlageConsoLabel = 'de 0 à 6 000 kWh';
                } else if (parseInt(this.lireContratData.consoAnnuEstimeeGaz) <= 29999 ) {
                    codePlageConso_calcul = 30000;
                    this.lireContratData.codePlageConsoLabel = 'de 6 000 à 30 000 kWh';
                } else if (parseInt(this.lireContratData.consoAnnuEstimeeGaz) >= 30000 ) {
                    codePlageConso_calcul = 300000;
                    this.lireContratData.codePlageConsoLabel = 'plus de 30 000 kWh';
                }
            }
            inputPrixRemiseMap = {
                EnergyTypeOptions: typeEnergy,
                idOffre1: this.type === 'elec' ? this.contratactif.codeOffre : this.contratactifsecondaire.codeOffre,
                idOffre2: this.type === 'gaz' ? this.contratactif.codeOffre : this.contratactifsecondaire.codeOffre,
                idPack: this.contratactif.idPack ? this.contratactif.idPack : '',

                typeComptageDifferencie: this.lireContratData.typeComptageCode ? this.lireContratData.typeComptageCode : '',
                ftaCode: this.lireContratData.ftaElecCode ? this.lireContratData.ftaElecCode : '',

                CAEElec: this.lireContratData.consommationAnnuelleEstimeeElec ?  this.lireContratData.consommationAnnuelleEstimeeElec : '',
                // CAE_HC: HC ? parseInt(HC) : '',
                // CAE_HP: HP ? parseInt(HP) : '',
                // CAE_WE: WE ? parseInt(WE) : '',
                Puissance: this.lireContratData.puissance ? (typeof(this.lireContratData.puissance) === 'object' ? parseInt(this.lireContratData.puissance[0]) : parseInt(this.lireContratData.puissance)) : '', //OK
                dateDerniereModificationFormuleTarifaireAcheminement: new Date(Date.now()).toISOString().slice(0,10)+'T00:00:00',
                niveauOuvertureServices: this.lirePDL.niveauServices ? this.lirePDL.niveauServices.split(' ')[1] : '',
                datePropositionCommerciale: this.lireContratData.dateProposition ? (typeof(this.lireContratData.dateProposition) === 'object' ? this.lireContratData.dateProposition[0] : this.lireContratData.dateProposition)  : '',
                dateEffetContrat: this.lireContratData.dateEffetContractuelle ? (typeof(this.lireContratData.dateEffetContractuelle) === 'object' ? this.lireContratData.dateEffetContractuelle[0] : this.lireContratData.dateEffetContractuelle) : '',
                codeCommune: this.selecteditem.codeINSEE ? this.selecteditem.codeINSEE : '',
                codePostal: this.selecteditem.codePostal ? this.selecteditem.codePostal : '',
                codePlageConso: codePlageConso_calcul,
                contexteSouscription:'CHGT_FOURN'
            };
        }
        console.log('inputPrixRemiseMap' + typeEnergy);
        console.log(inputPrixRemiseMap);
        // if (typeEnergy == 'Elec') {
        //     inputPrixRemiseMap = inputPrixRemiseMap_Elec;
        // } else {
        //     inputPrixRemiseMap = inputPrixRemiseMap_Gaz;
        // }
        getOffresEtPrix({inputMap: inputPrixRemiseMap}).then(result => {
            if(result && result.OffreCatalogue && result.OffreCatalogue.length) {
                this.flayoutData = {...result.OffreCatalogue[0], ...this.lireContratData};
                // this.flayoutData = result.OffreCatalogue[0];
                this.flayoutData.mens = this.flayoutData.mens ? parseInt(this.flayoutData.mens.split(' ')[0]) : ''; 
                this.flayoutData.mensTotal = this.flayoutData.mensTotal ? parseInt(this.flayoutData.mensTotal.split(' ')) : ''; 
                //traitement Elec
                if(this.flayoutData.aboElec){
                    let index = this.flayoutData.aboElec.indexOf(":"); 
                    let rawValue = this.flayoutData.aboElec.substring(index+1);
                    var firstValue = rawValue.substring(0,rawValue.indexOf("TTC")+3);
                    this.flayoutData.aboElec1 = firstValue.replace(/\./g, ',');
                    let secondValue = rawValue.substring(rawValue.indexOf("TTC")+3);
                    this.flayoutData.aboElec2 = secondValue.replace(/\./g, ',');
                    this.flayoutData.aboElec = this.flayoutData.aboElec.replace(/\./g, ',');
                    // if (this.flayoutData.typeOffre  !==  'TradeOFF') {
                    //     let temp = this.flayoutData.aboElec.split(' ');
                    //     this.flayoutData.aboTTCElec = temp[0].replace(/\./g, ',') + ' €';
                    //     this.flayoutData.aboHTElec = temp[3].substring(1, temp[3].length).replace(/\./g, ',') + ' €';
                    // }
                }
                if(this.flayoutData.consoElec) {
                    this.flayoutData.consoElec = this.flayoutData.consoElec.replace(/\./g, ',');
                }
                if (this.flayoutData.mapConsoByTypeComptage) {
                    this.flayoutData.mapConsoByTypeComptage = {...this.flayoutData.mapConsoByTypeComptage, ...{}};
                }
                if(this.flayoutData.mapConsoByTypeComptage.Fourniture) {
                    this.flayoutData.mapConsoByTypeComptage.Fourniture = this.flayoutData.mapConsoByTypeComptage.Fourniture.replace(/\./g, ',');
                }
                if(this.flayoutData.mapConsoByTypeComptage.Acheminement) {
                    this.flayoutData.mapConsoByTypeComptage.Acheminement = this.flayoutData.mapConsoByTypeComptage.Acheminement.replace(/\./g, ',');
                }
                //traitement Gaz
                if(this.flayoutData.mapConsoGazByTypeComptage) {
                    this.flayoutData.mapConsoGazByTypeComptage = {...this.flayoutData.mapConsoGazByTypeComptage, ...{}};
                }
                if(this.flayoutData.mapConsoGazByTypeComptage.Fourniture_abo) {
                    this.flayoutData.mapConsoGazByTypeComptage.Fourniture_abo = this.flayoutData.mapConsoGazByTypeComptage.Fourniture_abo.replace(/\./g, ',');
                }
                if(this.flayoutData.mapConsoGazByTypeComptage.Acheminement_abo) {
                    this.flayoutData.mapConsoGazByTypeComptage.Acheminement_abo = this.flayoutData.mapConsoGazByTypeComptage.Acheminement_abo.replace(/\./g, ',');
                }
                if(this.flayoutData.mapConsoGazByTypeComptage.Fourniture_conso) {
                    this.flayoutData.mapConsoGazByTypeComptage.Fourniture_conso = this.flayoutData.mapConsoGazByTypeComptage.Fourniture_conso.replace(/\./g, ',');
                }
                if(this.flayoutData.mapConsoGazByTypeComptage.Acheminement_conso) {
                    this.flayoutData.mapConsoGazByTypeComptage.Acheminement_conso = this.flayoutData.mapConsoGazByTypeComptage.Acheminement_conso.replace(/\./g, ',');
                }
                if(this.flayoutData.mapConsoGazByTypeComptage.OBLIGATIONS) {
                    this.flayoutData.mapConsoGazByTypeComptage.OBLIGATIONS = this.flayoutData.mapConsoGazByTypeComptage.OBLIGATIONS.replace(/\./g, ',');
                }
                if (this.flayoutData.aboGaz) {
                    this.flayoutData.aboGaz = this.flayoutData.aboGaz.replace(/\./g, ',');
                }
                if (this.flayoutData.consoGaz) {
                    this.flayoutData.consoGaz = this.flayoutData.consoGaz.replace(/\./g, ',');
                } else if (this.flayoutData.mapConsoGazByTypeComptage.consoGaz) {
                    this.flayoutData.mapConsoGazByTypeComptage.consoGaz = this.flayoutData.mapConsoGazByTypeComptage.consoGaz.replace(/\./g, ',');
                }
            } else {
                this.flayoutData = this.lireContratData;
            }
            console.log(this.flayoutData);
        })
        .catch(error => {
            this.error = true;
            console.log('erreur ouverture flyout '+ this.type, error);
        });
    }
    //Ouvrir ou fermer détail energie flyout
    handleOpenRecordClick() {
        console.log('openflyout');
        let eventName = 'popupevent';
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: {type:this.type} });
        this.dispatchEvent(event);
        this.flayoutData = null;
        this.error = false;
        if(this.selecteditem['close'+this.type]) {
            let nameIP;
            this.lireContratData = null;
            this.lirePDL = null;
            this.lirePCE = null;
            // let lireNameIP;
            let idContratActif = this.contratactif ? this.contratactif.idContrat: "";
            let idContratActifSecondaire =  this.contratactifsecondaire ? this.contratactifsecondaire.idContrat : "";
            if (this.type === 'elec' && idContratActif !== idContratActifSecondaire) {
                nameIP = 'IP_SM_FlyoutElecData_Elec';
                callIP({ inputMap: {idContrat: this.contratactif.idContrat}, NameIntergation: 'IP_SM_LireContrat_ELEc_SOAP' }).then(result => {
                    if(result) {
                        this.lireContratData = result;
                        if(this.lirePDL) {
                            this.callPrixRemises('Elec');
                        }
                    }
                }).catch(error => {
                    console.log("got error IP_SM_FlyoutElecData_Elec", error);
                });
                let inputMap = {
                    pdlElc: this.contratactif ? this.contratactif.numeroPointDeLivraison : ''
                }
                getFlayoutPDLData(inputMap).then(result => {
                    if(result) {
                        this.lirePDL = result;
                        if(this.lireContratData) {
                            this.callPrixRemises('Elec');
                        }
                    }
                })
                .catch(error => {
                    this.error = true;
                    console.log('erreur ouverture flyout '+ this.type, error);
                });
            } else if (this.type === 'gaz' && idContratActif !== idContratActifSecondaire) {
                callIP({ inputMap: {idContrat: this.contratactif.idContrat}, NameIntergation: 'IP_SM_LireContrat_Gaz_SOAP' }).then(result => {
                    if(result) {
                        this.lireContratData = result;
                        this.callPrixRemises('Gaz');
                    }
                }).catch(error => {
                    console.log("got error IP_SM_LireContrat_Gaz_SOAP", error);
                });

                // Récupération du pourcentage du gaz du contrat de service gaz vert (FT1-4463)
                if(this.contratservicegazvert){
                    this.getContratServiceGazVertPourcent();
                }

            } else if(idContratActif === idContratActifSecondaire) {
                let pdlElec;
                if(this.type === 'gaz') {
                    pdlElec = this.contratactifsecondaire ? this.contratactifsecondaire.numeroPointDeLivraison : '';
                    // pdlGaz = this.contratactif ? this.contratactif.numeroPointDeLivraison : '';
                } else {
                    // pdlGaz = this.contratactifsecondaire ? this.contratactifsecondaire.numeroPointDeLivraison : '';
                    pdlElec = this.contratactif ? this.contratactif.numeroPointDeLivraison : '';
                }
                //Call lireContrat Elec + Gaz
                callIP({ inputMap: {idContrat: this.contratactif.idContrat}, NameIntergation: 'IP_SM_LireContrat_SOAP' }).then(result => {
                    if(result) {
                        this.lireContratData = result;
                        if(this.lirePDL) {
                            this.callPrixRemises('Dual');
                        }
                    }
                }).catch(error => {
                    console.log("got error IP_SM_LireContrat_SOAP", error);
                });
                //Call lirePDLELEC
                let inputMapElec = {
                    pdlElc: pdlElec
                }
                getFlayoutPDLData(inputMapElec).then(result => {
                    if(result) {
                        this.lirePDL = result;
                        if(this.lireContratData) {
                            this.callPrixRemises('Dual');
                        }
                    }
                })
                .catch(error => {
                    this.error = true;
                    console.log('erreur ouverture flyout PDL '+ this.type, error);
                });

                // Récupération du pourcentage du gaz du contrat de service gaz vert (FT1-4463)
                if(this.contratservicegazvert){
                    this.getContratServiceGazVertPourcent();
                }
            }else {
                this.error = true;
            }

            
        }
    }

    // Récupération du pourcentage du gaz du contrat de service gaz vert (FT1-4463)
    getContratServiceGazVertPourcent(){

        callIP({ inputMap: {idContrat: this.contratservicegazvert.idContrat}, NameIntergation: 'IP_SM_LireContrat_Gaz_SOAP' }).then(result => {
            if(result) {
                this.contratservicegazvertpourcent = result.pourcent_vert;
            }
        }).catch(error => {
            console.log("got error IP_SM_LireContrat_Gaz_SOAP Contrat service option verte", error);
        });
    }

    toggle(e){
        console.log(e.currentTarget);
        var displayDetails = e.currentTarget.nextElementSibling.style.display;
        if(e.currentTarget.nextElementSibling && e.currentTarget.childNodes && e.currentTarget.childNodes[1] && e.currentTarget.childNodes[2]) {
            if (displayDetails !== "none") {
                e.currentTarget.nextElementSibling.style.display = "none";
                e.currentTarget.childNodes[1].style.display = "block"
                e.currentTarget.childNodes[2].style.display = "none"
            } else {
                e.currentTarget.nextElementSibling.style.display = "block";
                e.currentTarget.childNodes[2].style.display = "block"
                e.currentTarget.childNodes[1].style.display = "none"
            }
        }
    };
}