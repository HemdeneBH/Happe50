import { NavigationMixin } from 'lightning/navigation';
import { LightningElement,api,track } from 'lwc';
import updateFactureModeEnvoie from '@salesforce/apex/HP_SM006_FactureManager.updateFactureModeEnvoi';
import updateEnergieVert from '@salesforce/apex/HP_SM006_FactureManager.updateEnergieVert';
import loadEnergieVerOption from '@salesforce/apex/HP_SM006_FactureManager.loadEnergieVerOption';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Hp_cardService extends NavigationMixin(LightningElement) {

    @track _masterdata;
    @track _secondarydata;
    @track titre;
    @track serviceList = null;
    @track openclose = false;
    @track gazMode;
    @track elecMode;
    @track gazModeIsPaper;
    @track elecModeIsPaper;
    @track isActiveContrat;

    @track
    optionVertElecLabel;
    @track
    optionVertElecDisplay = true;

    @track
    energieVertPopupModal = false;
    currentPopupContactId;
    typeContratModifierModeEnvoi;
    @track valueOuiNon = 'Oui';
    @track changeModePopupModal = false;
    @track energieVertButtonLabel;

    @track optionsOuiNon = [
        {'label': 'Oui', 'value': 'Oui'},
        {'label': 'Non', 'value': 'Non'},
    ];
    @track
    currentPfc;
    elecContratId;
    gazContratId;
    apiPfcInfo;
    apiContratInfo;
    
    @track 
    numeroPointDeLivraisonVert;

    @track 
    energieVert = null;

    @track
    idContratVert;

    @track
    titreVert;

    @track
    contenuVert;


    @track 

    energieVertActivation = false;


    @track 

    showSpinner = false;
    @api
    set masterdata(value) {
        if(value == null ) {
            return;
        }
        this._masterdata = value;
        this.energieVertActivation = value.globalParam.data.energieVert == "1";
        if(this._selectedpfcid == null) {
            return;
        }
        this.processLabelEnergieVert();
    }
    get masterdata() {
        return null;
    }
    @api
    set pfcdata(value) {
        if(value == null ) {
            return;
        }
        this.elecMode = null;
        this.gazMode = null;
        this.apiPfcInfo = value;
        this.findCurrentPftc();
        this.processData();
        
    }
    get pfcdata() {
        return null;
    }
  
    @api
    set secondarydata(value) {
        if(value == null) {
            return;
        }
        this._secondarydata =JSON.parse(JSON.stringify(value)) ;
        this.findCurrentPftc();
        this.processData();
        
    }
    get secondarydata() {
        return null;
    }

    @api
    set selectedpfcid(value) {
        this.energieVert = null;
        if(value == null) {
            return;
        }
        this._selectedpfcid = value;
        this.findCurrentPftc();
        this.processData();
               
        

        this.processLabelEnergieVert();
    }
    get selectedpfcid() {
        return null;
    }

    processLabelEnergieVert() {
        if(this._masterdata == null || this._selectedpfcid == null 
            || this.currentPfc == null
            || this._masterdata.contratInfoList == null
            || this._masterdata.contratInfoList.energieVert == null
            || this._masterdata.contratInfoList.energieVert.data == null
            || Object.keys(this._masterdata.contratInfoList.energieVert.data).length === 0
            || this._masterdata.contratInfoList.energieVert.data[this._selectedpfcid] == null
            || this._masterdata.contratInfoList.energieVert.data[this._selectedpfcid].status == 'FAILED') {
            return;
        }
        console.log("xxxxx");
        this.energieVert = JSON.parse(JSON.stringify(this._masterdata.contratInfoList.energieVert.data[this._selectedpfcid]));
        for(let item of this.energieVert.output) {
            if(item.option.date_fin_periode != null && item.option.date_debut_periode != null &&
                new Date(item.option.date_debut_periode).getTime() > new Date(item.option.date_fin_periode).getTime()) {
                item.option.date_debut_periode = null;
                item.option.date_fin_periode = null;
            }

            if(item.option.date_activation)
                item.option.date_activation = this.formaterDate(item.option.date_activation.split('T')[0]);
            if(item.option.date_desactivation)
                    item.option.date_desactivation = this.formaterDate(item.option.date_desactivation.split('T')[0]);
            if(item.option.date_debut_periode)
                item.option.date_debut_periode = this.formaterDate(item.option.date_debut_periode);
            if(item.option.date_fin_periode)
                item.option.date_fin_periode = this.formaterDate(item.option.date_fin_periode);
        }
        console.log('@@  this.energieVert ' + JSON.stringify(this.energieVert));
        if(this.energieVert == null) {
            return;
        }
        let aux = (this.energieVert.output.filter(item => (item.option.vert == true && item.option.date_desactivation == null)));
        const isActive =  aux != null && aux.length != 0;
        this.optionVertElecLabel = isActive ? 'Activée' : 'Désactivée';
        this.energieVertButtonLabel = !isActive ? 'Confirmer l’activation' : 'Confirmer la désactivation';
        this.titreVert = isActive ? 'Désactiver l’option' : 'Activer l’option';

        this.contenuVert = isActive ? "La désactivation de l’option Vertelec+ happ-e sera effective à la fin du mois en cours." : "L’option Vertelec+ happ-e d’un montant de 2,99€/mois sera effective le 1ier du mois prochain.";

        this.numeroPointDeLivraisonVert = this.currentPfc.pointsDeLivraison[0].numeroPointDeLivraison;
        this.idContratVert = this.energieVert.id;
    }
    processData() {
        this.processTranquility();
        this.processModeEnvoiFacutre();
    }
    processTranquility() {

        if(this._secondarydata == null 
            || this._secondarydata.agilabPersonne == null
            || this._secondarydata.agilabPersonne.tranquilityContratInfoList == null 
            || this._secondarydata.agilabPersonne.tranquilityContratInfoList.data == null
            || this._secondarydata.agilabPersonne.tranquilityContratInfoList.data.contratList == null || this.currentPfc == null) {
                return;
        }
        let listServiceInactif = [];
        let listServiceActif = [];
        
        let contList =  this._secondarydata.agilabPersonne.tranquilityContratInfoList.data.contratList;
        for(let tranquillityContrat of contList) {
            tranquillityContrat.dateEffetMaj = this.formaterDate(tranquillityContrat.dateEffet);
            let contrat = this.currentPfc;
            
            if (contrat.codePostal === (tranquillityContrat.localAssure.codePostal).toString()) {
                if ( contrat.dateResiliation == null || contrat.dateResiliation > Date.now ) {
                    tranquillityContrat.actif = true;
                    listServiceActif.push(tranquillityContrat);
                } else {
                    listServiceInactif.push(tranquillityContrat);
                    let dateResiliation  = contrat.dateResiliation.split('-');
                    tranquillityContrat.dateResiliationMaj = dateResiliation[2] + '/' + dateResiliation[1] + '/' + dateResiliation[0];
                }
                break;
            }
            
        }
        listServiceActif = listServiceActif.sort((a, b) => new Date(b.dateEffet) - new Date(a.dateEffet));
        listServiceInactif = listServiceInactif.sort((a, b) => new Date(b.dateEffet) - new Date(a.dateEffet));
        this.serviceList =  [...listServiceActif, ...listServiceInactif];
        let servicesActifCount = listServiceActif.length;
        let servicesInactifCount = listServiceInactif.length;
        this.titre = (servicesActifCount > 0 || servicesInactifCount > 0) ? ('SERVICE ('+ servicesActifCount + ' actif' + (servicesActifCount > 1?'s, ':', ') + servicesInactifCount + ' résilié' + (servicesInactifCount > 1?'s)':')')) : 'SERVICES';
    
    }

    formaterDate(dateString) {
        let datesplt = dateString.split('-');
        return datesplt[2] + '/' + datesplt[1] + '/' + datesplt[0];
    }
    processModeEnvoiFacutre() {
        
        let contratInfo = this._masterdata.contratInfoList.data._data;
        this.apiContratInfo = null;
        for(let i = 0; i < contratInfo.length; i ++) {
            if(this._selectedpfcid == contratInfo[i].idPortefeuilleContrat) {
                this.processContrat(contratInfo[i]);
            }
        }
        
    }
    processContrat(contrat) {
        if(contrat == null) {
            return;
        }

        if((contrat.codeStatutCrm == 'H0105' || contrat.codeStatutCrm == 'H0101' 
        || contrat.codeStatutCrm == 'H0102' || 
        contrat.codeStatutCrm == 'E0004' || contrat.codeStatutCrm == 'E0007')) {
            this.isActiveContrat = true;
        } else {
            this.isActiveContrat = false;
            this.gazMode = null;
            this.elecMode = null;
            return;
        }
        if(this.apiPfcInfo == null) {
            return;
        }
        let currentInfo = null;
        try{
            if(this.apiPfcInfo.infoContrat['child-0-infoContrat'].param.contratIdList == contrat.id) {
                currentInfo = this.apiPfcInfo.infoContrat['child-0-infoContrat'].data.output;
            } else if(this.apiPfcInfo.infoContrat['child-1-infoContrat'].param.contratIdList == contrat.id){
                currentInfo = this.apiPfcInfo.infoContrat['child-1-infoContrat'].data.output;
            }
        }catch(e){
            return;
        }
        if(currentInfo == null) {
            return;
        }
        if(contrat.codeOffre == 'GITR2_H') {
            this.gazMode = currentInfo.mode_envoi_facture;
            this.gazModeIsPaper = this.gazMode == 'papier';
            this.gazContratId = contrat.id;
        } else {
            this.elecMode = currentInfo.mode_envoi_facture;
            this.elecModeIsPaper = this.elecMode == 'papier';
            this.elecContratId = contrat.id;
        }
    }
    findCurrentPftc() {
        let locauxContrat = this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data._data;
        for(let i = 0; i < locauxContrat.length; i ++) {
            if(this._selectedpfcid == locauxContrat[i].idPortefeuilleContrat) {
                this.currentPfc = locauxContrat[i].locaux[0];

                console.log('@@@ this.currentPfcthis.currentPfc ' + JSON.stringify(this.currentPfc));
                break;
            }
        }
    } 

    
    openElecchangeModePopupModal(){
        this.currentPopupContactId = this.elecContratId;
        this.changeModePopupModal = true;
        this.typeContratModifierModeEnvoi = 'elec';
        this.valueOuiNon = 'Oui';
    }
    openGazchangeModePopupModal(){
        this.currentPopupContactId = this.gazContratId;
        this.changeModePopupModal = true;
        this.typeContratModifierModeEnvoi = 'gaz';
        this.valueOuiNon = 'Oui';
    }
    closechangeModePopupModal(){
        this.changeModePopupModal = false;
    }
    handleOpenRecordClick() {
        //this.openclose = !this.openclose;
    }
    handleOnChangeOuiNon(event) {
        console.log('@@ event.target.value  ' + event.target.value);
        this.valueOuiNon = event.target.value;
    }
    savechangeModePopupModal(){
        console.log('@@ info ' +  this.currentPopupContactId + '   ' + this.valueOuiNon);
        if(this.valueOuiNon === 'Non') {
            this.changeModePopupModal = false;
            return;
        }

        updateFactureModeEnvoie({
            contractId: this.currentPopupContactId , agilabStatus : 1
        }).then(result => {
            if (result) {
                console.log(' @@ result updateFactureModeEnvoie ' + JSON.stringify(result));
                this.changeModePopupModal = false;
                if(result['200'] == null) {
                   
                    const evt = new ShowToastEvent({
                        title: "Modification de mode d'envoi de la facture",
                        message: 'Echec de la modification du mode d’envoi. Veuillez effectuer la mise à jour dans Agilab',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                    return;
                }
                
                if(this.typeContratModifierModeEnvoi === 'gaz') {
                    this.gazMode = 'électronique';
                    this.gazModeIsPaper = false;
                } else {
                    this.elecMode = 'électronique';
                    this.elecModeIsPaper = false;
                }

                const evt = new ShowToastEvent({
                    title: "Modification de mode d'envoi de la facture",
                    message: 'opération effectué avec succès',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
               
            }
        });
    }
    openEnergieVertPopupModal() {
        this.energieVertPopupModal = true;
    }

    closeEnergieVertPopupModal() {
        this.energieVertPopupModal = false;
    }
    activateDesactivate() {
        this.showSpinner = true;
        let aux = (this.energieVert.output.filter(item => (item.option.vert == true && item.option.date_desactivation == null)));
        const isActive =  aux != null && aux.length != 0;
        console.log('@@@ this.energieVert.id ' + this.energieVert.id);
        updateEnergieVert({
            contractId: this.energieVert.id , energieVert : isActive ? '0' : '1'
        }).then(result => {
            if(result.status == 200) {
                loadEnergieVerOption({
                    contractId: this.energieVert.id 
                }).then(result => {
                    const evt = new ShowToastEvent({
                        message: 'Opération effectué avec succès',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.showSpinner = false;
                    this.dispatchEvent(evt);
                    this.energieVertPopupModal = false; 
                    let resultout = JSON.parse(JSON.stringify(result));
                    resultout.id = this.energieVert.id;
                    const param = {value : resultout, pfcId : this._selectedpfcid};
                    this.dispatchEvent(new CustomEvent('loadoptionvert', { detail: param}));
                });
            } else {
                const evt = new ShowToastEvent({
                    message: 'Erreur au niveau de la mise à jour de l\'énergie verte',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.showSpinner = false;
            }
        });
        
    }
}