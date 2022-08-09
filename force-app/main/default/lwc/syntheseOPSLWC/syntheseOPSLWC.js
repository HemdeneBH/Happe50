import { LightningElement,api,track} from 'lwc';
import { OmniscriptBaseMixin} from 'vlocity_cmt/omniscriptBaseMixin';
export default class SyntheseOPSLWC extends OmniscriptBaseMixin(LightningElement) {
    @api omniJsonData;
    @track titleLink = 'VOIR PLUS';
    @track titleLinkTerminee = 'VOIR PLUS';
    @track opsDetailsEnCoursList = [];
    @track opsDetailsTermineesList = [];
    /*@track opsList = [
        {
            Id: 1,
            nom: 'OPS Gaz Mes non téléopérable',
            prix: '26,23',
            date: '',
            creneau: '',
            presence: 'PRESENCE OBLIGATOIRE',
            contactName:'Raouaa Jmour',
            contactNum: '0658783487',
            commentaire: '',
            idDistrib : "A03727283",
            idFournisseur : "352627",
            moins48h : 1
        },
        {
            Id: 2,
            nom: 'Gaz:MES avec rétab EXPRESS demandé client',
            prix: '26,23',
            date: 'Vendredi 19 Juin 2020',
            creneau: '12h - 13h',
            presence: '',
            contactName:'Raouaa Jmour',
            contactNum: '0658783487',
            commentaire: 'Commentaire Test 2',
            idDistrib : "A03727283",
            idFournisseur : "352627",
            moins48h : 0
        },
        {
            Id: 3,
            nom: 'OPS Gaz Mes non téléopérable 3',
            prix: '26,23',
            date: 'Vendredi 29 Juin 2020',
            creneau: '13h - 14h',
            presence: 'PRESENCE NON OBLIGATOIRE',
            contactName:'Raouaa Jmour',
            contactNum: '0658783487',
            commentaire: 'Commentaire Test 3',
            idDistrib : "A03727283",
            idFournisseur : "352627",
            moins48h : 1
        },
    ];*/
    @track ops;
    @track opsListFull = [];
    @track opsListRestric = [];
    @track isClickedTerminee = false;
    @track isClicked = false;
    @track plus2OPS = false;
    @track opsTermineesExists = false;
    connectedCallback() {
        //console.log('idsPrestationsServiceEnCoursDistribList' + this.omniJsonData.idPrestationDistributeurEnCours);
        console.log('idsPrestationsServiceEnCoursFournisseurList' + this.omniJsonData.idPrestationServiceFournisseurEnCours);
       /* let inputLireOffline= {
            TypeCard : 'GAZ',
            idsPrestationsServiceEnCoursDistribList : this.omniJsonData.idPrestationDistributeur,
            idsPrestationsServiceEnCoursFournisseurList : this.omniJsonData.idPrestationServiceFournisseur
        }
        const params = {
            input: JSON.stringify(inputLireOffline),
            sClassName: 'SM_AP30_PrestationGaz',
            sMethodName: 'lirePrestationGazOfflineList',
            options: '{}',
        };
        this.omniRemoteCall(params, true).then(response => {
            window.console.log(response, 'response');
            console.log(response);
            console.log(response.opsDetailsList);
            console.log(response.result.opsDetailsList);*/
            console.log(this.omniJsonData.opsDetailsEnCoursList);
            //console.log(this.omniJsonData.opsDetailsTermineesList);
            this.opsDetailsEnCoursList = this.omniJsonData.opsDetailsEnCoursList ? JSON.parse(JSON.stringify(this.omniJsonData.opsDetailsEnCoursList)) : [];
            //this.opsDetailsTermineesList = this.omniJsonData.opsDetailsTermineesList ? JSON.parse(JSON.stringify(this.omniJsonData.opsDetailsTermineesList)) : [];
            if(this.omniJsonData.nbreOPSTerminees >0){
                this.opsTermineesExists = true;
            }
            if(this.opsDetailsEnCoursList != null && this.opsDetailsEnCoursList.length >2){
                this.plus2OPS = true;
                this.opsListFull = this.opsDetailsEnCoursList.slice(2,this.opsDetailsEnCoursList.length);
                this.opsListRestric = this.opsDetailsEnCoursList.slice(0,2);         
            }
            else if (this.opsDetailsEnCoursList != null && this.opsDetailsEnCoursList.length ==2){
                this.opsListRestric = this.opsDetailsEnCoursList;
            } else if ( this.opsDetailsEnCoursList != null && this.opsDetailsEnCoursList.length ==1){
                this.opsListRestric = this.opsDetailsEnCoursList;
            }
            for(let ops of this.opsListRestric) {
                console.log(ops.presence);
                 if (ops.presence == 'PRESENCE NON OBLIGATOIRE') {
                    ops.conditionPresence = false;
                }else if (ops.presence == 'PRESENCE OBLIGATOIRE'){
                    ops.conditionPresence = true;
                }
                console.log(ops.moins48h);
                if(ops.moins48h == '1'){
                    ops.fraisInter = true;
                } else{
                    ops.fraisInter = false;
                }
            }
            for(let ops of this.opsListFull) {
                console.log(ops.presence);
                 if (ops.presence == 'PRESENCE NON OBLIGATOIRE') {
                    ops.conditionPresence = false;
                }else if (ops.presence == 'PRESENCE OBLIGATOIRE'){
                    ops.conditionPresence = true;
                }
                console.log(ops.moins48h);
                if(ops.moins48h == '1'){
                    ops.fraisInter = true;
                } else{
                    ops.fraisInter = false;
                }
            }
        /*}).catch(error => {
            window.console.log(error, 'error');
        });*/
        //call List TODO
    }
    get isOPSElec() {
        return this.omniJsonData.TypeCard === 'ELEC';
    }
    get isOPSGaz() {
        return this.omniJsonData.TypeCard === 'GAZ';
    }
    displayMessageRestrictedList(e){
        var indexValue = e.currentTarget.dataset.key;
        this.opsListRestric[indexValue].show = true;
        setTimeout(() => {
            this.opsListRestric[indexValue].show = false;
        }, 2000);
    }
    displayMessageopsListFull(e){
        var indexValue = e.currentTarget.dataset.key;
        this.opsListFull[indexValue].show = true;
        setTimeout(() => {
            this.opsListFull[indexValue].show = false;
        }, 2000);
    }
    handleActionTerminee(e) {
        //console.log(this.omniJsonData.idPrestationDistributeurTerminees);
        console.log(this.omniJsonData.idPrestationServiceFournisseurTerminees);
        console.log('click');
         if(this.titleLinkTerminee == 'VOIR PLUS'){
            this.isClickedTerminee = true;
            this.titleLinkTerminee = 'VOIR MOINS';
        let inputLireOffline= {
            TypeCard : 'GAZ',
            //idPrestationDistributeurEnCours : this.omniJsonData.idPrestationDistributeurTerminees,
            idPrestationServiceFournisseurEnCours : this.omniJsonData.idPrestationServiceFournisseurTerminees
        }
        const params = {
            input: JSON.stringify(inputLireOffline),
            sClassName: 'SM_AP30_PrestationGaz',
            sMethodName: 'lirePrestationGazOfflineList',
            options: '{}',
        };
        this.omniRemoteCall(params, true).then(response => {
            window.console.log(response, 'response');
            console.log(response);
            console.log(response.opsDetailsList);
            console.log(response.result.opsDetailsList);
            this.opsDetailsTermineesList = response.result.opsDetailsEnCoursList;
        }).catch(error => {
            window.console.log(error, 'error');
        });
         }
         else if(this.titleLinkTerminee == 'VOIR MOINS'){
            this.isClickedTerminee = false;
            this.titleLinkTerminee = 'VOIR PLUS';
         }
    }
    handleAction(e) {
        console.log('click');
         if(this.titleLink == 'VOIR PLUS'){
            this.isClicked = true;
            this.titleLink = 'VOIR MOINS';
         }
         else if(this.titleLink == 'VOIR MOINS'){
            this.isClicked = false;
            this.titleLink = 'VOIR PLUS';
         }
    }
    copyRefRestrictedList(e){
        var indexValue = e.currentTarget.dataset.key;
        var indexName= e.currentTarget.dataset.name;
        e.stopPropagation();
        let textToCopy = e.currentTarget.innerText;
        let input = document.createElement('input');
        e.currentTarget.appendChild(input);
        input.value = textToCopy;
        // 2) Select the text
        input.focus();
        input.select();
        // 3) Copy text to clipboard
        let isSuccessful = document.execCommand('copy');
        //remove input
        e.currentTarget.removeChild(input);
        // 4) Catch errors
        if (!isSuccessful) {
            console.error('Failed to copy text.');
        } else {
            this.opsListRestric[indexValue]['numCopied' + e.currentTarget.dataset.name] = true;
            setTimeout(() => {
                this.opsListRestric[indexValue]['numCopied' + indexName] = false;
            }, 2000);
        }
    }
    copyRefFullList(e){
        var indexValue = e.currentTarget.dataset.key;
        var indexName= e.currentTarget.dataset.name;
        e.stopPropagation();
        let textToCopy = e.currentTarget.innerText;
        let input = document.createElement('input');
        e.currentTarget.appendChild(input);
        input.value = textToCopy;
        // 2) Select the text
        input.focus();
        input.select();
        // 3) Copy text to clipboard
        let isSuccessful = document.execCommand('copy');
        //remove input
        e.currentTarget.removeChild(input);
        // 4) Catch errors
        if (!isSuccessful) {
            console.error('Failed to copy text.');
        } else {
            this.opsListFull[indexValue]['numCopied' + e.currentTarget.dataset.name] = true;
            setTimeout(() => {
                this.opsListFull[indexValue]['numCopied' + indexName] = false;
            }, 2000);
        }
    }
        openAnnulationOPSRestric(e){
        var indexValue = e.currentTarget.dataset.key;
        var params = `c__target=c:smContactAnnulationOPSFrench&c__layout=lightning&c__tabLabel=Annulation OPS&c__tabIcon=custom:custom18&c__id={0}&c__ContextId=${this.omniJsonData.ContextId}&c__idF=${this.opsListRestric[indexValue].idFournisseur}&c__idD=${this.opsListRestric[indexValue].idDistrib}&c__num=${this.omniJsonData.num}&c__rue=${this.omniJsonData.rue}&c__cplt=${this.omniJsonData.cplt}&c__cp=${this.omniJsonData.cp}&c__ville=${this.omniJsonData.ville}&c__libelleOPS=${this.opsListRestric[indexValue].nom}&c__datePrevue=${this.opsListRestric[indexValue].datePrevue}&c__commentaires=${this.opsListRestric[indexValue].commentaire}&c__presence=${this.opsListRestric[indexValue].presence}&c__pdl=${this.omniJsonData.numeroPointDeLivraison}&c__nom=${this.omniJsonData.nom}&c__prenom=${this.omniJsonData.prenom}&c__civilite=${this.omniJsonData.ContactSalutation}&c__tel=${this.omniJsonData.mobilePrincipal}&c__TypeCard=${this.omniJsonData.TypeCard}&c__creneauRetenu=${this.opsListRestric[indexValue].creneauRetenuCode}&c__creneau=${this.opsListRestric[indexValue].creneauRetenu}&c__refExterne=${this.opsListRestric[indexValue].idDistrib}&c__ops48h=${this.opsListRestric[indexValue].fraisInter}&c__cplt=${this.omniJsonData.cplt}&c__montant=${this.opsListRestric[indexValue].prix}&c__heureFin=${this.opsListRestric[indexValue].heureFin}&c__heureDebut=${this.opsListRestric[indexValue].heureDebut}&c__creneauHoraire=${this.opsListRestric[indexValue].creneau}&c__idContrat=${this.omniJsonData.idContrat}&c__AccountId=${this.omniJsonData.AccountId}&c__layout=lightning`;
        this.omniApplyCallResp({params : params});
        this.omniNextStep();
        }
        openAnnulationOPSFull(e){
            var indexValue = e.currentTarget.dataset.key;
            var params = `c__target=c:smContactAnnulationOPSFrench&c__layout=lightning&c__tabLabel=Annulation OPS&c__tabIcon=custom:custom18&c__id={0}&c__ContextId=${this.omniJsonData.ContextId}&c__idF=${this.opsListFull[indexValue].idFournisseur}&c__idD=${this.opsListFull[indexValue].idDistrib}&c__num=${this.omniJsonData.num}&c__rue=${this.omniJsonData.rue}&c__cplt=${this.omniJsonData.cplt}&c__cp=${this.omniJsonData.cp}&c__ville=${this.omniJsonData.ville}&c__libelleOPS=${this.opsListFull[indexValue].nom}&c__datePrevue=${this.opsListFull[indexValue].datePrevue}&c__commentaires=${this.opsListFull[indexValue].commentaire}&c__presence=${this.opsListFull[indexValue].presence}&c__pdl=${this.omniJsonData.numeroPointDeLivraison}&c__nom=${this.omniJsonData.nom}&c__prenom=${this.omniJsonData.prenom}&c__civilite=${this.omniJsonData.ContactSalutation}&c__tel=${this.omniJsonData.mobilePrincipal}&c__TypeCard=${this.omniJsonData.TypeCard}&c__creneauRetenu=${this.opsListFull[indexValue].creneauRetenuCode}&c__creneau=${this.opsListFull[indexValue].creneauRetenu}&c__refExterne=${this.opsListFull[indexValue].idDistrib}&c__ops48h=${this.opsListFull[indexValue].fraisInter}&c__cplt=${this.omniJsonData.cplt}&c__montant=${this.opsListFull[indexValue].prix}&c__heureFin=${this.opsListFull[indexValue].heureFin}&c__heureDebut=${this.opsListFull[indexValue].heureDebut}&c__creneauHoraire=${this.opsListRestric[indexValue].creneau}&c__idContrat=${this.omniJsonData.idContrat}&c__AccountId=${this.omniJsonData.AccountId}&c__layout=lightning`;
            this.omniApplyCallResp({params : params});
            this.omniNextStep();
            }
        openModifOPSRestric(e){
            var indexValue = e.currentTarget.dataset.key;
            var params = `c__target=c:smContactModificationOPSFrench&c__layout=lightning&c__tabLabel=Modif OPS&c__tabIcon=custom:custom18&c__id={0}&c__ContextId=${this.omniJsonData.ContextId}&c__idF=${this.opsListRestric[indexValue].idFournisseur}&c__idD=${this.opsListRestric[indexValue].idDistrib}&c__num=${this.omniJsonData.num}&c__rue=${this.omniJsonData.rue}&c__cplt=${this.omniJsonData.cplt}&c__cp=${this.omniJsonData.cp}&c__ville=${this.omniJsonData.ville}&c__nom=${this.omniJsonData.nom}&c__prenom=${this.omniJsonData.prenom}&c__libelleOPS=${this.opsListRestric[indexValue].nom}&c__datePrevue=${this.opsListRestric[indexValue].datePrevue}&c__commentaires=${this.opsListRestric[indexValue].commentaire}&c__presence=${this.opsListRestric[indexValue].presence}&c__pdl=${this.omniJsonData.numeroPointDeLivraison}&c__nom=${this.omniJsonData.ContactName}&c__prenom=${this.omniJsonData.ContactName}&c__civilite=${this.omniJsonData.ContactSalutation}&c__tel=${this.omniJsonData.mobilePrincipal}&c__TypeCard=${this.omniJsonData.TypeCard}&c__creneauRetenu=${this.opsListRestric[indexValue].creneauRetenuCode}&c__refExterne=${this.opsListRestric[indexValue].idDistrib}&c__ops48h=${this.opsListRestric[indexValue].fraisInter}&c__cplt=${this.omniJsonData.cplt}&c__montant=${this.opsListRestric[indexValue].prix}&c__idContrat=${this.omniJsonData.idContrat}&c__layout=lightning`;
            this.omniApplyCallResp({params : params});
            this.omniNextStep();
            }
            openModifOPSFull(e){
                var indexValue = e.currentTarget.dataset.key;
                var params = `c__target=c:smContactModificationOPSFrench&c__layout=lightning&c__tabLabel=Modif OPS&c__tabIcon=custom:custom18&c__id={0}&c__ContextId=${this.omniJsonData.ContextId}&c__idF=${this.opsListFull[indexValue].idFournisseur}&c__idD=${this.opsListFull[indexValue].idDistrib}&c__num=${this.omniJsonData.num}&c__rue=${this.omniJsonData.rue}&c__cplt=${this.omniJsonData.cplt}&c__cp=${this.omniJsonData.cp}&c__ville=${this.omniJsonData.ville}&c__nom=${this.omniJsonData.nom}&c__prenom=${this.omniJsonData.prenom}&c__libelleOPS=${this.opsListFull[indexValue].nom}&c__datePrevue=${this.opsListFull[indexValue].datePrevue}&c__commentaires=${this.opsListFull[indexValue].commentaire}&c__presence=${this.opsListFull[indexValue].presence}&c__pdl=${this.omniJsonData.numeroPointDeLivraison}&c__nom=${this.omniJsonData.ContactName}&c__prenom=${this.omniJsonData.ContactName}&c__civilite=${this.omniJsonData.ContactSalutation}&c__tel=${this.omniJsonData.mobilePrincipal}&c__TypeCard=${this.omniJsonData.TypeCard}&c__creneauRetenu=${this.opsListFull[indexValue].creneauRetenuCode}&c__refExterne=${this.opsListFull[indexValue].idDistrib}&c__ops48h=${this.opsListFull[indexValue].fraisInter}&c__cplt=${this.omniJsonData.cplt}&c__montant=${this.opsListFull[indexValue].prix}&c__idContrat=${this.omniJsonData.idContrat}&c__layout=lightning`;
                this.omniApplyCallResp({params : params});
                this.omniNextStep();
                }    
}