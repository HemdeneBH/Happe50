import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";


export default class CardEnergie extends NavigationMixin(LightningElement) {
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

    get getTitle() {
        if( this.title !== undefined ) {
            return this.title.toUpperCase();
        }
        return '';
    }
    //Visibilité du Loader sur la card
    get showSpinner() {
        return (this.selecteditem.key >=0 && this.listrecord[this.selecteditem.key].loadcontratWS);
    }
    //La couleur du contrat Actif (vert/Oranger)
    get condition() {
        if( this.contratactif && this.contratactif.statutCode === 'E0004') {
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
        && this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService
        && ( this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService === 'E0001'
            || this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService === 'E0004'
            || this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService === 'E0005'
            || this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService === 'E0006'
            || this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService === 'E0007'
            || this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService === 'E0008'
            || this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService === 'E0009'
            || this.selecteditem.itemPrestelec.RecherchePrestationElecResult.codePrestationService === 'E0018')


    }

    //True s'il y a une OPS GAZ en cours
    get isActionOPSGaz () {
        return this.type === 'gaz' 
        && this.selecteditem.loadPrestgaz
        && this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult
        && this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService
        && ( this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService === 'E0001'
            || this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService === 'E0004'
            || this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService === 'E0005'
            || this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService === 'E0006'
            || this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService === 'E0007'
            || this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService === 'E0008'
            || this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService === 'E0009'
            || this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.codePrestationService === 'E0018')


    }

    //Génerer l'icon pour la card gaz ou elec
    get iconCard(){
        if(this.type === 'gaz') {
            return '/resource/EngieCustomResources/images/contrat_GAZ.svg'
        }
        return '/resource/EngieCustomResources/images/contrat_ELEC.svg';
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
            IdLocal: this.selecteditem.IdLocal
        }
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
        this.dispatchEvent(event);
    }

    handleNeedChange() {
        console.log("envie de changer");
        setCache().then(r => {
            console.log(r);
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
                codeBIC: this.selecteditem.codeBIC,
                idBusinessPartner: this.selecteditem.IdBusinessPartner,
                rue: this.selecteditem.libelleVoie,
                num: this.selecteditem.numeroVoie,
                ville: this.selecteditem.ville,
                cp: this.selecteditem.codePostal,
                cplt: this.selecteditem.complementAdresse.trim()
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
        setCache().then(r => {
            console.log(r);
            const eventName = 'openops';
            let inputMap
            if (this.type === 'gaz') {
                inputMap = {
                    TypeCard: 'GAZ',
                    idPrestationDistributeur: this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.idPrestationServiceDistrib,
                    libelleOPS: this.selecteditem.itemPrestgaz.LirePrestationGAZResult.libelleOPS,
                    fraisPrestation: this.selecteditem.itemPrestgaz.LirePrestationGAZResult.fraisPrestation,
                    soldeDu: this.selecteditem.itemPrestgaz.LirePrestationGAZResult.soldeDu,
                    idPrestationServiceFournisseur: this.selecteditem.itemPrestgaz.RecherchePrestationGAZResult.idPrestationServiceFournisseur,
                    rue: this.selecteditem.libelleVoie,
                    num: this.selecteditem.numeroVoie,
                    ville: this.selecteditem.ville,
                    cp: this.selecteditem.codePostal,
                    cplt: this.selecteditem.complementAdresse.trim(),
                    commentaires: this.selecteditem.itemPrestgaz.LirePrestationGAZResult.commentaireIntervention,
                    idContrat: this.contratactif.idContrat
                }
            } else if (this.type === 'elec') {
                inputMap = {
                    TypeCard: 'ELEC',
                    idPrestationDistributeur: this.selecteditem.itemPrestelec.RecherchePrestationElecResult.idPrestationServiceDistrib,
                    libelleOPS: this.selecteditem.itemPrestelec.LirePrestationElecResult.libelleOPS,
                    fraisPrestation: this.selecteditem.itemPrestelec.LirePrestationElecResult.fraisPrestation,
                    soldeDu: this.selecteditem.itemPrestelec.LirePrestationElecResult.soldeDu,
                    idPrestationServiceFournisseur: this.selecteditem.itemPrestelec.RecherchePrestationElecResult.idPrestationServiceFournisseur,
                    rue: this.selecteditem.libelleVoie,
                    num: this.selecteditem.numeroVoie,
                    ville: this.selecteditem.ville,
                    cp: this.selecteditem.codePostal,
                    cplt: this.selecteditem.complementAdresse.trim(),
                    commentaires: this.selecteditem.itemPrestelec.LirePrestationElecResult.commentaireIntervention,
                    montantPrevisionnel: this.selecteditem.itemPrestelec.LirePrestationElecResult.montantPrevisionnelPrestation,
                    idContrat: this.contratactif.idContrat
                }
            }
            const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
            this.dispatchEvent(event);


        })
        .catch(error => {
            console.log("got error cache", error);
        }); 
    }

    //Ouvrir ou fermer détail energie flyout
    handleOpenRecordClick() {
        let eventName = 'popupevent';
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: {type:this.type} });
        this.dispatchEvent(event);
        if(this.selecteditem['close'+this.type] && !this.selecteditem['flayoutDataDetail'+this.type]) {
            let nameIP;
            if (this.type === 'elec') {
                nameIP = 'IP_SM_FlyoutElecData_Elec'
            } else {
                nameIP = 'IP_SM_FlyoutGazData_Gaz';
            }
            callIP({ inputMap: {numeroPointDeLivraison: this.contratactif.numeroPointDeLivraison}, NameIntergation: nameIP }).then(result => {
                if(result) {
                    this.flayoutData = result;
                    // this.selecteditem['flayoutDataDetail'+this.type] = result;
                }
            })
            .catch(error => {
                console.log('erreur ouverture flyout '+ this.type, error);
            });
            
        } else if (this.selecteditem['close'+this.type]) {
            this.flayoutData = this.selecteditem['flayoutDataDetail'+this.type];
        }
    }

    //Rénitiliser les flyouts de toutes les adresses à fermer
    resetFlyout() {
        let listFlyout = ['closepce', 'closepdl', 'closegaz', 'closeelec'];
        for (const flyout of listFlyout) {
            if(('close' + this.type) !== flyout && this.selecteditem[flyout]) {
                this.selecteditem[flyout] = false;
            }
        }
    }
}