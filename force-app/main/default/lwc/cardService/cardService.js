import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import setCache from "@salesforce/apex/SM_AP84_SetCache.setCache";
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import EMAIL_FIELD2 from '@salesforce/schema/Contact.Adresse_Mail_2__c';
import EMAIL_FIELD3 from '@salesforce/schema/Contact.Adresse_Mail_3__c';
import INTST_FIELD from '@salesforce/schema/Contact.Statut_Internaute__c';
import felencours from '@salesforce/resourceUrl/felencours';
import feleactive from '@salesforce/resourceUrl/felactive';
import hasPermissionEnableLwcServicesPayants from '@salesforce/customPermission/SM_EnableLwcAcquisition'
import InfoIcone from '@salesforce/resourceUrl/Icone_Info';
import getServicePrioritaire from "@salesforce/apex/SM_AP97_RecommandationsAPI.getServicePriritaire";
/*import { publish } from 'lightning/messageService';
import { createMessageContext, releaseMessageContext } from 'lightning/messageService';
import felStatusMessageChannel from '@salesforce/messageChannel/sm_felstatus__c';*/
const FIELDS = [EMAIL_FIELD, EMAIL_FIELD2, EMAIL_FIELD3, INTST_FIELD];

export default class CardService extends NavigationMixin(LightningElement) {
    @api contratactifgaz;
    @api contratactifelec;
    @api contratservicegazvert;
    @api contratserviceelecvert;
    @api selecteditem;
    @track selecteditem;
    @track servicePrioritaire;
    @track columns = [
            {key: "services", value: "Services"},
            {key: "dateActivation", value: "Date d'activation"},
            {label: "dateResiliation", value: "Date de résiliation"}];
    @api recordid;
    @wire(getRecord, { recordId: '$recordid', fields: FIELDS }) contact;
    information_Icone  = InfoIcone;
  
    get isMensualisee() {
        return this.selecteditem && this.selecteditem.modePaiement === 'mensualisé';
    }
    get isFelEncours(){
        console.log('### fel '+this.selecteditem.factureEnLigne);
        return this.selecteditem && this.selecteditem.factureEnLigne === '0004';
        //return true;
    }
    imgfelencours = felencours;
    get isFelActive(){
        //return true;
        return this.selecteditem && (this.selecteditem.factureEnLigne === '0001' || this.selecteditem.factureEnLigne === '0002');
    }
    imgfelactive = feleactive;
    get isFelDesactive(){
        return !this.isFelActive && !this.isFelEncours;
        //return this.selecteditem && (!this.selecteditem.factureEnLigne || this.selecteditem.factureEnLigne =='' || this.selecteditem.factureEnLigne === '0003' || this.selecteditem.factureEnLigne === '0005');
    }
 // vérifier si le contact a des services affinitaires 
 //FT3-[VUE 360] Affichage des statuts des services affinitaires
    get hasServices(){
        return (this.selecteditem.listTranquilityServices && this.selecteditem.listTranquilityServices.length > 0)
    }


    get isPrelevee() {
        return this.selecteditem && this.selecteditem.modePaiement === 'Prélevé';
    }
    get showSpinner() {
        return this.selecteditem && ((this.selecteditem.key >=0 && this.selecteditem.loadService) || this.selecteditem.errorContratWs);
    }
    get isServicesClose() {
        return this.selecteditem && this.selecteditem.listServices && this.selecteditem.listServices.length && !this.selecteditem.closeservice;
    }
    get isServicesOpen() {
        return this.selecteditem && this.selecteditem.listServices && this.selecteditem.listServices.length && this.selecteditem.closeservice;
    }
    handleServicePrioritaire() {
        //FT3-1560 [Moteur de recommandation] Service payant
        //+this.selecteditem.IdBusinessPartner
        getServicePrioritaire({ numeroBP: this.selecteditem.IdBusinessPartner }).then(result => {
        console.log('Numero business partner '+this.selecteditem.IdBusinessPartner );
        if(result){
            //+JSON.stringify(result)
            this.servicePrioritaire= 'Service prioritaire à pousser:'+JSON.stringify(result);
        }
        else {
            this.servicePrioritaire= 'Option verte.';
        }
        console.log('result service prioritaire'+JSON.stringify(result));
    });
    }
    handleOpenRecordClick() {
        let eventName = 'popupevent';
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: {type: 'service'} });
        this.dispatchEvent(event);
    }
    handleServicesPayants() {
        console.log("openservicepayant");
        setCache().then(r => {
            const eventName = 'openservicepayant';
           //ADE FT1-4149 check if we have contrat Elec/Gaz Actif
            let isContratActif = false;
            if(
            (this.selecteditem.contratactifelecWS&& (
            this.selecteditem.contratactifelecWS.statutCode === 'E0001' 
            || this.selecteditem.contratactifelecWS.statutCode === 'E0003'
            || this.selecteditem.contratactifelecWS.statutCode === 'E0004'
            || this.selecteditem.contratactifelecWS.statutCode === 'E0005'))||
            (this.selecteditem.contratactifgazWS!== undefined &&(
            this.selecteditem.contratactifgazWS.statutCode === 'E0001'
            || this.selecteditem.contratactifgazWS.statutCode === 'E0003'
            || this.selecteditem.contratactifgazWS.statutCode === 'E0004'
            || this.selecteditem.contratactifgazWS.statutCode === 'E0005'))) {
                isContratActif = true;
            }
            const inputMap = {
                isMensualisee: this.isMensualisee,
                isPrelevee: this.isPrelevee,
                iBAN: this.selecteditem.iBAN,
                nomInstitutBancaire: this.selecteditem.nomInstitutBancaire,
                titulaireCompte: this.selecteditem.titulaireCompte,
                numeroVoie: this.selecteditem.numeroVoie,
                libelleVoie: this.selecteditem.libelleVoie.toString(),
                complementAdresse: this.selecteditem.complementAdresse.toString(),
                codePostal: this.selecteditem.codePostal.toString(),
                NoCompteContrat: this.selecteditem.NoCompteContrat.toString(),
                NoCompteContratMaj: this.selecteditem.NoCompteContratMaj.toString(),
                IdPortefeuilleContrat: this.selecteditem.IdPortefeuilleContrat.toString(),
                ville: this.selecteditem.ville.toString(),
                recordId: this.recordid,
                IdBusinessPartner: this.selecteditem.IdBusinessPartner,
                //c__solde: this.selecteditem.solde ? this.selecteditem.solde.solde : '',
                //c__soldeFormat: this.soldeFormater,
                AccountId: this.selecteditem.AccountId,
                //iBAN: this.selecteditem.iBAN,
                //nomInstitutBancaire: this.selecteditem.nomInstitutBancaire

                numeroLocal: this.selecteditem.numeroLocal,
                isContratActif:isContratActif,
                EnqSat:this.selecteditem.EnqSat,
                enableLwcServicesPayants:hasPermissionEnableLwcServicesPayants
                //numerovoie: 
            }
            const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
            this.dispatchEvent(event);
        })
        .catch(error => {
            console.log("got error cache", error);
        });
    }
    handleOpenFreeServices() {
        console.log("openfreeservices");
        let internaute = getFieldValue(this.contact.data, INTST_FIELD);
        let mail01 = getFieldValue(this.contact.data, EMAIL_FIELD);
        let mail02 = getFieldValue(this.contact.data, EMAIL_FIELD2);
        let mail03 = getFieldValue(this.contact.data, EMAIL_FIELD3);
        setCache().then(r => {
          const eventName = "openfreeservices";
          const inputMap = {
            eDocumentStatus: this.selecteditem.eDocument,
            felStatus: this.isFelDesactive == false ? true : false,
            customerAreaUnavailable : internaute == 'Oui' || internaute == 'En cours' ? false : true,
            noEmail : mail01 != null || mail02 != null || mail03 != null ? false : true,
            recordId : this.recordid,
            accountContract : this.selecteditem.NoCompteContratMaj
          };
          const event = new CustomEvent(eventName, {
            bubbles: true,
            composed: true,
            detail: inputMap
          });
        this.dispatchEvent(event);
        })
        .catch(error => {
            console.log("got error setCache", error);
        });
    }
    handleOpenOptions() {
        console.log("openOption");
        var contratsOptions = [];
        if(this.contratservicegazvert !== undefined){
            if(
                this.contratservicegazvert.statut !== 'Resilié' &&
                this.contratservicegazvert.statut !== 'Annulé' && 
                this.contratservicegazvert.statut !== 'Résilié-A répliquer'
            ){
                contratsOptions.push(JSON.parse(JSON.stringify(this.contratservicegazvert)));
            }
        }
        if(this.contratserviceelecvert !== undefined){
            if(
                this.contratserviceelecvert.statut !== 'Resilié' &&
                this.contratserviceelecvert.statut !== 'Annulé' && 
                this.contratserviceelecvert.statut !== 'Résilié-A répliquer'
            ){
                contratsOptions.push(JSON.parse(JSON.stringify(this.contratserviceelecvert)));
            }
        }
        
        console.log('contratsOptions: '+JSON.stringify(contratsOptions));
        const eventName = "openoptions";
        
        const inputMap = {
            titulaireCompte: this.selecteditem.titulaireCompte,
            numeroVoie: this.selecteditem.numeroVoie,
            idContratGaz: (this.contratactifgaz && (this.contratactifgaz.statutCode === 'E0004' || this.contratactifgaz.statutCode === 'E0005' || this.contratactifgaz.statutCode === 'E0006')) ? this.contratactifgaz.idContrat: "",
            idContratElec: (this.contratactifelec && (this.contratactifelec.statutCode === 'E0004' || this.contratactifelec.statutCode === 'E0005' || this.contratactifelec.statutCode === 'E0006')) ? this.contratactifelec.idContrat: "",
            contratsOptions: window.btoa(unescape(encodeURIComponent(JSON.stringify(contratsOptions)))),
            libelleVoie: this.selecteditem.libelleVoie.toString(),
            complementAdresse: this.selecteditem.complementAdresse.toString(),
            codePostal: this.selecteditem.codePostal.toString(),
            NoCompteContrat: this.selecteditem.NoCompteContrat.toString(),
            NoCompteContratMaj: this.selecteditem.NoCompteContratMaj.toString(),
            IdPortefeuilleContrat: this.selecteditem.IdPortefeuilleContrat.toString(),
            ville: this.selecteditem.ville.toString(),
            recordId: this.recordid,
            IdBusinessPartner: this.selecteditem.IdBusinessPartner,
            AccountId: this.selecteditem.AccountId,
            numeroLocal: this.selecteditem.numeroLocal,
            IdLocal: this.selecteditem.IdLocal,
            rythmeFacturation: this.selecteditem.rythmeFacturation
        }
        const event = new CustomEvent(eventName, {
            bubbles: true,
            composed: true,
            detail: inputMap
          });
        this.dispatchEvent(event);
    }
    //FT3-1749 [VUE 360] Affichage des statuts des services affinitaires et des options Week-end (WE)
    handleNavigate() {
        //var values = JSON.parse(this.selecteditem)//
         console.log('handleNavigate'+JSON.stringify(this.selecteditem) );

      
        this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__MovingToServices"
            },
            state: {
                c__propertyValue: JSON.stringify(this.selecteditem)
                
            }
        });


            }
    

    
    
    
}