import { LightningElement,api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class Hp_cardSolde  extends NavigationMixin(LightningElement) {
    _selectedpfcid;
    @track _masterdata;
    @track currentPfc;
    @track hpSoldeFormater;
    @track soldeType;
    factures;
    remboursements;
    @track isCollect;
    @track dateLimite;
    @track isDLP = false;
    @track colorClass;
    @track remboursement;
    @api
    set masterdata(value) {
        if(value == null ) {
            return;
        }
        this._masterdata = value;
        if(this._selectedpfcid == null) {
            return;
        }
    }
    get masterdata() {
        return null;
    }
    @api
    set pfcdata(value) {
        if(value == null ) {
            return;
        }
        if(value.factureInfo != null && value.factureInfo.data != null && value.factureInfo.data.output != null) {
            this.factures = value.factureInfo.data.output.factures;
        }
        if(value.remboursements != null && value.remboursements != null) {
            this.remboursements =  value.remboursements.data;
        }
        this.processFactureSolde();
        this.findCurrentPftc();
        this.remboursement = null;
        if(value.remboursements != null &&value.remboursements.data != null && value.remboursements.data.output != null
            && value.remboursements.data.output.remboursements != null) {
            this.remboursement = this.getRemboursementPlusRecent(value.remboursements.data.output.remboursements);
            
        }
        
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
        this.findCurrentSolde();
        this.processFactureSolde();
    }
    get secondarydata() {
        return null;
    }

    @api
    set selectedpfcid(value) {
       
        if(value == null) {
            return;
        }
        this._selectedpfcid = value;
        this.findCurrentPftc();
        this.findCurrentSolde();
    }
    get selectedpfcid() {
        return null;
    }

    findCurrentPftc() {
        if(this._masterdata == null) {
            return;
        }
        let locauxContrat = this._masterdata.contratInfoList.pfcInfoList.locauxContratInfoList.data._data;
        for(let i = 0; i < locauxContrat.length; i ++) {
            if(this._selectedpfcid == locauxContrat[i].idPortefeuilleContrat) {
                this.currentPfc = locauxContrat[i];
                break;
            }
        }
    } 

    findCurrentSolde() {
        this.hpSoldeFormater = 0;
        if(this._secondarydata == null || this._secondarydata.soldePersonne == null
            || this._secondarydata.soldePersonne.data == null 
            || this._secondarydata.soldePersonne.data.output == null
            || this._secondarydata.soldePersonne.data.output.soldes == null || this._selectedpfcid == null) {
            return;
        }
        
        for(let sld of this._secondarydata.soldePersonne.data.output.soldes) {
            let keys = Object.keys(sld);
            if(keys.length == 0) {
                continue;
            }
            if(keys[0] == this._selectedpfcid) {
                this.hpSoldeFormater = sld[keys[0]];
                this.hpSoldeFormater = this.formatDecimalTwoDigits(this.hpSoldeFormater);
                break;
            }
        }
        this.soldeType = (this.hpSoldeFormater == 0 ? '':(this.hpSoldeFormater >= 0 ? 'CREDITEUR':'DEBITEUR'));
    }


    processFactureSolde() {
        let dlpList;
        this.dateLimite = null;
        if(this.factures != null && this.factures.length > 0) {
             dlpList = this.getDlpList(this.factures);
             this.isDLP = false;
             if (dlpList.length > 0) {
                let recentDate = new Date(Math.max.apply(null,dlpList)); //La date la plus récente
                let day = ("0" + recentDate.getDate()).slice(-2);
                let monthIndex =("0" + (recentDate.getMonth() + 1)).slice(-2);
                let year = recentDate.getFullYear();
                this.dateLimite = day +'/'+monthIndex+'/'+year; //Formater la date la plus récente
                this.isDLP = true;
            }
        }
        
        if(this.hpSoldeFormater == 0) {
            this.colorClass = 'null-solde';
        }
        if (this.factures) {
             if(this.hpSoldeFormater > 0) {
                this.colorClass =  'negatif-solde';
            } else if (this.hpSoldeFormater < 0) { 
                let toDay = new Date();
                for( let dlp of dlpList) {
                    console.log('date-Black', dlp);
                    if (dlp > toDay) {
                        this.colorClass =  'null-solde';
                        return;
                    } 
                }
               
                this. colorClass =  'positif-solde';
            }
        }
       
    }

    getDlpList(factures) {
        console.log('FACTURES'+ JSON.stringify(factures))
        let dlpList = [];
        let collecting = false;
        if(factures.length >=1){
        factures.forEach(function (facture) {
            if (facture.recouvrement !="") {
                collecting = true;
            }
            if (['1','2','3','4','5','7','8','10','11','1é','13'].indexOf(facture.type_facture) >= 0
                 && (facture.statut === '1' || facture.statut === '2')
            ) {
                let dlp = new Date(facture.date_limite_de_paiement);
                dlpList.push(dlp);
            }
        });
    }
		this.isCollect = collecting;
        return dlpList;
    }

    getRemboursementPlusRecent(remboursements) {
        if(remboursements == null || remboursements.length == 0) {
          return null;
        }
        let maxRemboursement = remboursements[0];
        for(let i = 1; i < remboursements.length; i ++) {
          if(new Date(remboursements[i].date_creation) > new Date(maxRemboursement.date_creation)) {
            maxRemboursement = remboursements[i];
          }
        }
        return maxRemboursement;
    }

    openAgilabSpaceCB() {
		if (this._masterdata.data[0].HP_AgilabExternalId__c != null) {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this._masterdata.globalParam.data.urlAgilab + "personnes/show/" + this._masterdata.data[0].HP_AgilabExternalId__c.toString()+"#donnees_de_paiement_cont"
                    
                }
            });
        } else {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this._masterdata.globalParam.data.urlAgilab
                }
            });
        }
    }
    openAgilabSpaceDP() {
		if (this._masterdata.data[0].HP_AgilabExternalId__c != null) {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this._masterdata.globalParam.data.urlAgilab + "personnes/show/" + this._masterdata.data[0].HP_AgilabExternalId__c.toString()+"#client_solidarite_cont"
                    
                }
            });
        } else {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this._masterdata.globalParam.data.urlAgilab
                }
            });
        }
    }

    formatDecimalTwoDigits(montant) {
        return (Math.round(montant * 100) / 100).toFixed(2);
    }
}