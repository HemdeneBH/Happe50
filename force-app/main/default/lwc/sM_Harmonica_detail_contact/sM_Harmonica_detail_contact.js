import { LightningElement,wire,api} from 'lwc';
import getDataClient from '@salesforce/apex/SM_HarmonicaDisplayContactInfos.getDataClient';
export default class SM_Harmonica_detail_contact extends LightningElement {
    @api recordId;
    infosClient;
    error;
    contactBP;
    caseOriginPP;
    demandeService;
    caseType;
    flagStatutIban;
    dynamicClass = "";

    @wire(getDataClient, { caseId: '$recordId' })
    wiredDataClient({data, error}){
        if(data){
            this.infosClient = JSON.parse(data);
            console.log('### infosClient ' + JSON.stringify(this.infosClient));
            this.error = undefined;
            // vérifier si le case est rattachée à un contact, on supprime le leading 0 dans le BP 
            if(this.infosClient.CaseId__r.Contact && this.infosClient.CaseId__r.Contact.reference_client_f__c){
                this.contactBP  =  this.infosClient.CaseId__r.Contact.reference_client_f__c;
            }
            // vérifier le case origin pour afficher Mes Urgente dans le cas du partner community
            if(this.infosClient.CaseId__r.Origin == 'Partner Community'){
                this.caseOriginPP = true;
            } 

            if(this.infosClient.CaseId__r.Type == 'Résiliation' || this.infosClient.CaseId__r.Origin == 'Partner Community'){
                this.caseType = true;
            }

            // vérifier Si au moins l’un des champs case à cocher  
            // Depex__c,  Degex__c, Depexplus__c Degexplus__c et Garantie_Electromenager Depex et Degex et Assurancz Facture pour afficher demande de Service à "Oui"
            if(this.infosClient.CaseId__r.Degex__c == true || this.infosClient.CaseId__r.Depex__c == true 
            || this.infosClient.CaseId__r.Depexplus__c == true  || this.infosClient.CaseId__r.Degexplus__c == true 
            || this.infosClient.CaseId__r.Garantie_Electromenager__c == true || this.infosClient.CaseId__r.Assurance_Facture__c == true  ){
                this.demandeService = true;
            }

            this.flagStatutIban = (!this.caseOriginPP && this.infosClient.Statut_Iban__c != null && this.infosClient.Statut_Iban__c != '') ? true : false;
            if(this.infosClient.EmailRisque__c) this.dynamicClass = "slds-text-color_error";
            
        }
        else if (error) {
            this.error = error;
            this.infosClient = undefined;
            console.log('### error '+ error);
        }
    }
}