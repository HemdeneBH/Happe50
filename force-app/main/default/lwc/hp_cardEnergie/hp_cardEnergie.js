import { NavigationMixin } from 'lightning/navigation';
import { wire, LightningElement,api,track } from 'lwc';
import getFlyoutEnergieGrille from '@salesforce/apex/HP_SM001_Agilab.getGrilleTarifaire';
import soucriptionWithSamePdlPce from '@salesforce/apex/HP_EM005_Souscription.soucriptionWithSamePdlPce';
import getURLPortailAdmin from '@salesforce/apex/HP_SM003_MetadataManager.getURLPortailAdmin';

export default class Hp_cardEnergie extends NavigationMixin(LightningElement) {
    @wire(getURLPortailAdmin, { keyPortailAdmin: 'HP_URL_PORTAIL_ADMIN' })
    urlPortailAdmin;
    @api type;
    @track _masterdata;
    @track _selectedpfc;
    @track contratinfo = null;
    @track currentContrat;
    @track iconEnergie;
    @track _pfcdata;
    @track prestationDistributeur;
    @track prestationEnCours = false;
    @track showHideFlyout = false;
    @track dataIsLoaded = false;
    @track possedeCocontractant = false;
    @track flyoutData;
    @track apiActiveContratInfo;
    @track cocontractant;
    @track isError;
    @track apiDesactiveContratInfo;
    @track desableContractStatus = 'OFFRE RESILIEE';
    @track souscriptionId = null;
    @track souscriptionMigrationLabel = null;
    @track souscriptionMigrationId = null;
    currentOpen = false;
    _secondarydata;
    _selectedpfcid;
    currentPfc;
    currentPfcId;
    pfcInfoAPI = null;
    @api
    set pfcdata(value) {
        if(value == null) {
            return;
        }
        this._pfcdata = value;
        this.findCurrentInfoContrat();
       // this.processContratInfo();
        this.loadIconEnergie();
       this.findCocontractant();
       this.souscriptionId = null;
       if(this.apiActiveContratInfo != null && (this.apiActiveContratInfo.codeStatutCrm == 'H0105' || this.apiActiveContratInfo.codeStatutCrm == 'H0102') 
       && value.souscription != null && value.souscription.data != null && value.souscription.data[0] != null && value.souscription.data[0].Id != null) {
            this.souscriptionId = value.souscription.data[0].Id;
       } else {
        this.souscriptionId = null;
       }
    }
    get pfcdata() {
        return null;
    }
    @api
    set popupstate(value) {
        if( this.currentOpen) {
            this.currentOpen = false;
            return;
        }
        this.showHideFlyout = false;
    }
    get popupstate() {
        return null;
    }
    @api
    set masterdata(value) {
        if(value == null ) {
            return;
        }
        this._masterdata = value;
        if(this._selectedpfcid == null) {
            return;
        }
        this.findCurrentPftAndContrat();
        this.happeSouscriptionMigration();
    }
    get masterdata() {
        return null;
    }
    @api
    set secondarydata(value) {
        if(value == null) {
            return;
        }
        this._secondarydata =JSON.parse(JSON.stringify(value)) ;
        this.findCocontractant();
    }
    get secondarydata() {
        return null;
    }
    @api 
    set selectedpfcid(value) {
        this.currentContrat = null;
        if(value == null) {
            return;
        }
        this._selectedpfcid = value;
        if(this._masterdata == null) {
            return;
        }
        this.findCurrentPftAndContrat();
        this.findCocontractant();
        this.happeSouscriptionMigration();
    }
    get selectedpfcid() {
        return null;
    }
    get iselec() {
        return this.type == 'elec';
    }
    get isgaz() {
        return this.type == 'gaz';
    }
    get statutProposition() {
        if(this.contratinfo.propositionCommecrial.codeStatutPropositionCommercialePoste){
            if(this.contratinfo.propositionCommecrial.codeStatutPropositionCommercialePoste === '' || this.contratinfo.propositionCommecrial.codeStatutPropositionCommercialePoste==='-') {
                return this.contratinfo.propositionCommecrial.libelleStatutPropositionCommercialeHeader;
            } else return  this.contratinfo.propositionCommecrial.libelleStatutPropositionCommercialePoste;
        }
        return this.contratinfo.propositionCommecrial.libelleStatutPropositionCommercialeHeader;
    }
    isActiveContrat(cont) {
        return (cont.codeStatutCrm == 'H0105' || cont.codeStatutCrm == 'H0101' ||
        cont.codeStatutCrm == 'H0102' || 
        cont.codeStatutCrm == 'E0004' || cont.codeStatutCrm == 'E0007');
    }
    findCurrentPftAndContrat() {
        try {
            if(this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data._data == null) {
                return;
            }
        } catch(e){return;}
        let locauxContrat = this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data._data;
        for(let i = 0; i < locauxContrat.length; i ++) {
            if(this._selectedpfcid == locauxContrat[i].idPortefeuilleContrat) {
                this.currentPfc = locauxContrat[i];
                if(locauxContrat[i].locaux.length > 0) {
                    for(let j = 0; j < locauxContrat[i].locaux[0].pointsDeLivraison.length; j ++) {
                        let cont = locauxContrat[i].locaux[0].pointsDeLivraison[j];
                        if( cont.secteurActivite == 'gaz' &&   this.type == 'gaz') {
                            this.currentContrat = cont;
                            break;
                        }
                        if( cont.secteurActivite == 'elec' &&  this.type == 'elec') {
                            this.currentContrat = cont;
                            break;
                        }
                    }
                    break;
                }
                
            }
        }
        let contratInfo = this._masterdata.contratInfoList.data._data;
        this.apiActiveContratInfo = null;
        this.apiDesactiveContratInfo = null;
        this.desableContractStatus = 'OFFRE RESILIEE';
        for(let i = 0; i < contratInfo.length; i ++) {
            if(this._selectedpfcid == contratInfo[i].idPortefeuilleContrat && 
                ((this.type == 'gaz' && contratInfo[i].energie.includes('Gaz')) || (this.type == 'elec' && contratInfo[i].energie.includes('Elec')))) {
                if(this.isActiveContrat(contratInfo[i]))
                    this.apiActiveContratInfo = contratInfo[i];
                else {
                    let prop = null;
                    this.apiDesactiveContratInfo = contratInfo[i];
                    try {
                        prop = this._masterdata.contratInfoList.propositionCommecrial.data[contratInfo[i].id];
                    }catch(e) {

                    }

                    if(prop != null && 
                        prop.codeStatutPropositionCommercialeHeader == 'H0002') {
                        this.desableContractStatus = 'OFFRE RETRACTEE';
                    }
                }
            }
        }
        this.prestationEnCours = null;
        this.prestationDistributeur = null;
        if(this.apiActiveContratInfo == null) {
            return;
        } 
        if(this.apiActiveContratInfo == null || this.apiActiveContratInfo.id == null) {
            this.prestationEnCours = null;
            return;
        }
        if(this.currentContrat != null) {
            let prestations = this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.prestationDestributeur.data;
            this.prestationDistributeur = prestations[this.currentContrat.numeroPointDeLivraison];
            if(this.prestationDistributeur != null) {
                if(this.prestationDistributeur.Statut__c == 'En cours'){
                    this.prestationEnCours = true;
                } else {
                    this.prestationEnCours = null;
                }
            }
        }
    }
    findCocontractant() {
        this.pfcInfoAPI = null;
        if(this._secondarydata == null || this._secondarydata.portefeuilleContratInfoList == null
            || this._secondarydata.portefeuilleContratInfoList.data == null
            || this._secondarydata.portefeuilleContratInfoList.data._data == null) {
            return;
        }
        let pfcList = this._secondarydata.portefeuilleContratInfoList.data._data;
        for(let pfc of pfcList) {
            if(pfc.id == this._selectedpfcid) {
                this.pfcInfoAPI = pfc;
                break;
            }
        }
        if(this.pfcInfoAPI == null || this._secondarydata.portefeuilleContratInfoList.xdataCoPersonne == null
            ||  this._secondarydata.portefeuilleContratInfoList.xdataCoPersonne.data == null) {
            return null;
        }
        this.cocontractant = this._secondarydata.portefeuilleContratInfoList.xdataCoPersonne.data[this.pfcInfoAPI.id.toString()];
    }
    findCurrentInfoContrat() {
        this.contratinfo = null;
        console.log('this._pfcdata = ' + JSON.stringify(this._pfcdata));
        if(this._pfcdata.infoContrat == null) {
            return;
        }
        let keyList = Object.keys(this._pfcdata.infoContrat);
        for(let i = 0; i < keyList.length; i ++) {
            if(!this._pfcdata.infoContrat[keyList[i]]?.data?.output) {
                continue;
            }
            if(Object.keys(this._pfcdata.infoContrat[keyList[i]].data.output).length == 0) {
                continue;
            }
            if((this.type == 'gaz' && Object.keys(this._pfcdata.infoContrat[keyList[i]].data.output.gaz).length > 0) || 
            this.type == 'elec' && Object.keys(this._pfcdata.infoContrat[keyList[i]].data.output.electricite).length > 0) {
               this.contratinfo = this._pfcdata.infoContrat[keyList[i]];
               break;
            }
        }
    }
    loadIconEnergie(){
        this.iconEnergie = null;
        if(this.apiActiveContratInfo == null) {
            return; 
        }

        if(this.type === 'gaz') {
            if(this.apiActiveContratInfo && this.isHapp()){
                this.iconEnergie = '/resource/HP_CustomResources/images/gaz.svg';
            }else{
                this.iconEnergie = '/resource/EngieCustomResources/images/contrat_GAZ.svg';
            }
        }else if(this.type === 'elec'){
            if(this.apiActiveContratInfo && this.isHapp()){
                this.iconEnergie = '/resource/HP_CustomResources/images/elec.svg';
            }else{
                this.iconEnergie = '/resource/EngieCustomResources/images/contrat_ELEC.svg'
            }
        }
    }
    isHapp() {
       
        try{
           return (this._masterdata.globalParam.data.codeOffre[this.apiActiveContratInfo.codeOffre] != null);
        }catch(e){
            return false;
        }
    }
        
    
    handleOpenRecordClick() {
        if(this.apiActiveContratInfo == null || this.apiActiveContratInfo.id == null) {
            return;
        }
        this.isError = true;
        this.dataIsLoaded = false;
        this.showHideFlyout = !this.showHideFlyout;
        if(!this.showHideFlyout) {
            return; 
        }
        this.currentOpen = true;
        const event = new CustomEvent('popupevent', { open: true});
        this.dispatchEvent(event);
        let idContratApi = String(this.apiActiveContratInfo.id);
            let dateDebutValiditeUs = new Date(this.apiActiveContratInfo.dateDebutValidite);
            let dateDebutValiditeFr = ("0" + dateDebutValiditeUs.getDate()).slice(-2) + "/" + ("0" + (dateDebutValiditeUs.getMonth() + 1)).slice(-2) + "/" + dateDebutValiditeUs.getFullYear();
            if(this.contratinfo == null) {
                this.flyoutData = {error: 'Informations (Contrat Agilab) indisponibles pour le moment.'};
                this.isError = true;
                this.dataIsLoaded = true;
                return;
            }
            getFlyoutEnergieGrille({idContrat: idContratApi, dateContrat: dateDebutValiditeFr}).then(result => {
                if(result) {
                    if(result.error) {
                        this.flyoutData = {error: 'Informations indisponibles pour le moment.'};
                        this.isError = true;
                        this.dataIsLoaded = true;
                        this.dispatchEvent( new CustomEvent('newidtransaction', { detail: result.transactionId}));
                    } else {
                        this.dispatchEvent(new CustomEvent('newidtransaction', { detail: result.transactionId}));
                        let tempData = Object.assign({}, result); //de-proxyfication
                        let dateReconductiontUs = new Date(this.contratinfo.data.output.date_reconduction); //2021-12-01
                        tempData.dateReconduction = ("0" + dateReconductiontUs.getDate()).slice(-2) + "/" + ("0" + (dateReconductiontUs.getMonth() + 1)).slice(-2) + "/" + dateReconductiontUs.getFullYear();
                        if(this.type === 'gaz'){
                            tempData.consoEstimee = this.contratinfo.data.output.gaz.conso_annuelle_reference;
                            tempData.gazPlageConso = this.contratinfo.data.output.gaz.plage_conso;
                        }
                        else if(this.type === 'elec'){
                            tempData.consoEstimee = this.contratinfo.data.output.electricite.conso_annuelle_estimee;
                            tempData.elecPuissance = this.contratinfo.data.output.electricite.puissance;
                        }
                        
                        // prendre en compte la positivité ou negativité du % de réduction!!
                        let redEncoursFloat = Number(tempData.reductionEnCours);
                        let redEncoursabs = Math.abs(redEncoursFloat);
                        if(redEncoursFloat>0){
                            tempData.reductionEnCours = '-'+ String(redEncoursabs);
                        }else if (redEncoursFloat<0){
                            tempData.reductionEnCours = '+'+ String(redEncoursabs);
                        }else{
                            tempData.reductionEnCours = String(redEncoursabs);
                        }

                        //success getFlyoutEnergieGrille + getFlyoutEnergieContrat
                        this.flyoutData = tempData;
                        this.dataIsLoaded = true;
                        this.isError = false;
                    }
                }
            })
            .catch(error => {
                console.log('erreur ouverture flyout '+ this.type, error);
                this.flyoutData = {error: 'Informations indisponibles pour le moment.'};
                this.isError = true;
                this.dataIsLoaded = true;
            });
    }
    redirectSouscription() {
        if(this.souscriptionId == null) {
            return;
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  this.souscriptionId,
                actionName: 'view',
            },
        })
    }

    redirectSouscriptionMigration() {
        if(this.souscriptionMigrationId == null) {
            return;
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  this.souscriptionMigrationId,
                actionName: 'view',
            },
        })
    }
    happeSouscriptionMigration() {
        if(this.currentContrat == null || this.currentContrat.numeroPointDeLivraison == null) {
            return;
        }

        this.souscriptionMigrationLabel = null;
        if(this.isHapp()) {
            return;
        }
        soucriptionWithSamePdlPce({idContractant: this._masterdata.data[0].Id,
         value: this.currentContrat.numeroPointDeLivraison,
          fieldName: (this.type == 'elec' ? 'HP_NumPDL__c' : 'HP_NumberPCE__c')}).then(result => {
            console.log(JSON.stringify(result));
            if(result.length > 0) {
                this.souscriptionMigrationId = result[0].Id;
            }
            if(result.length == 1) {
                this.souscriptionMigrationLabel = 'Souscription happ-e initiée';
            } else if(result.length > 1) {
                this.souscriptionMigrationLabel = 'Souscriptions happ-e initiées';
            }
        });
    }
    openOPS() {
        this.prestationDistributeur = JSON.parse(JSON.stringify(this.prestationDistributeur));
        this.prestationDistributeur.type = this.type;
        const event = new CustomEvent('openops', { detail: this.prestationDistributeur});
        this.dispatchEvent(event);
    }
    openPortailAdmin() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: this.urlPortailAdmin.data
            }
        });
    }
}