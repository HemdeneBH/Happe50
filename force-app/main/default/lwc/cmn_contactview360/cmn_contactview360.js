/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-28-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import {
    LightningElement,
    api,
    wire,
    track
} from 'lwc';
import {
    getRecord,
    getFieldValue,
    updateRecord
} from 'lightning/uiRecordApi';
import {
    NavigationMixin
} from 'lightning/navigation';
import SALUT_FIELD from '@salesforce/schema/Contact.Salutation';
import RECORDTYPE_FIELD from '@salesforce/schema/Contact.RecordTypeId';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import REFCLI_FIELD from '@salesforce/schema/Contact.Identifiant_Buisness_Partener__c';
import REFCLI_FIELD_HAPPE from '@salesforce/schema/Contact.ID_Tiers__c';
import HP_SHARED_URL from '@salesforce/schema/Contact.HP_Shared_URL__c';
import ISHAPPE_FIELD from '@salesforce/schema/Contact.HP_IsHappe__c';
import EMAILPR_FIELD from '@salesforce/schema/Contact.EmailPrincipalValue__c';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import MOBILE_PHONE_FIELD from '@salesforce/schema/Contact.MobilePhone';
import MOBPR_FIELD from '@salesforce/schema/Contact.MobilePrincipalValue__c';
import FIXPR_FIELD from '@salesforce/schema/Contact.TelFixePrincipalValue__c';
import NUMETRANGER_FIELD from '@salesforce/schema/Contact.HP_Numero_etranger__c';
import INTST_FIELD from '@salesforce/schema/Contact.Statut_Internaute__c';
import REQUALIF_FIELD from '@salesforce/schema/Contact.A_requalifier__c';
import SEGMKT_FIELD from '@salesforce/schema/Contact.Segment_Marketing__c';
import NOVOIE_FIELD from '@salesforce/schema/Contact.No_Voie__c';
import MAILST_FIELD from '@salesforce/schema/Contact.MailingStreet';
import MAILCI_FIELD from '@salesforce/schema/Contact.MailingCity';
import MAILPO_FIELD from '@salesforce/schema/Contact.MailingPostalCode';
import CPLTAD_FIELD from '@salesforce/schema/Contact.Complement_adresse__c';
import AGILABID_FIELD from '@salesforce/schema/Contact.HP_AgilabExternalId__c';

import GLOBAL_MOY_SCORE_FIELD from '@salesforce/schema/Contact.HP_global_moyenne_score__c';
import ADERNIER_SCORE_FIELD from '@salesforce/schema/Contact.HP_Dernier_score__c';

import getIsClientOffline from '@salesforce/apex/HP_SM001_Agilab.getClienOffline';
import getURLImpersonationForContact from '@salesforce/apex/SM_AP21_GestionImpersonation.getURLImpersonationForContact';
import loadContact from "@salesforce/apex/HP_EM020_Contact.loadContact";
import getAgilabEspaceClientURL from "@salesforce/apex/HP_SM003_MetadataManager.getAgilabEspaceClientURL";
import loadReclamationCase from "@salesforce/apex/HP_EM035_Reclamation.loadReclamationCase";
import { refreshApex } from '@salesforce/apex';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


import QUEUESUBLE_FIELD from '@salesforce/schema/Case.HP_QueueCible__c';
import ID_FIELD from '@salesforce/schema/Case.Id';
import UsrId from '@salesforce/user/Id';
import ROLE_DEV_NAME from '@salesforce/schema/User.UserRole.DeveloperName';
import openEditNameClient from "@salesforce/messageChannel/hp_openEditNameClient__c";
import { publish, MessageContext } from 'lightning/messageService';


const FIELDS = [GLOBAL_MOY_SCORE_FIELD,ADERNIER_SCORE_FIELD,AGILABID_FIELD, SALUT_FIELD, FIRSTNAME_FIELD, LASTNAME_FIELD, RECORDTYPE_FIELD, REFCLI_FIELD, REFCLI_FIELD_HAPPE, ISHAPPE_FIELD, EMAILPR_FIELD, EMAIL_FIELD, PHONE_FIELD, MOBPR_FIELD, MOBILE_PHONE_FIELD, FIXPR_FIELD, INTST_FIELD, REQUALIF_FIELD, SEGMKT_FIELD, NOVOIE_FIELD, MAILST_FIELD, MAILCI_FIELD, MAILPO_FIELD, CPLTAD_FIELD,NUMETRANGER_FIELD];
export default class Contactview360 extends NavigationMixin(LightningElement) {
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;
    @track updateClientPopupModal = false;
    @track contact;
    @api recordId;
    @track offline;
    @track idClient;
    @track reclamationStatus = null;
    @track showReclamationCase = false;
    @track reclamationCaseList = [];
    @track showSpinner = false;
    @track showNoteSafisfaction = false;
    @track sharedURL;
    intl = new Intl.DateTimeFormat("en-GB",  
    {
      hour12: false,
      hour: "2-digit",
      minute: "2-digit",
      second:"2-digit",
      day:"2-digit",
      month:"2-digit",
      year:"numeric"
    });
    @wire(getRecord, {
        recordId: '$recordId',
        fields: FIELDS
    }) contact;

    isTicTac;
    @wire(getRecord, {
        recordId: UsrId, 
        fields: [ROLE_DEV_NAME]
    }) user;


    @wire(MessageContext)
    messageContext;

    updateClientPopupModalPopupModal() {
        this.updateClientPopupModal = false;
    }
    connectedCallback() {
        this.loadinfoContact();
    }
    loadinfoContact() {


        loadReclamationCase({
            contactId: this.recordId
        }).then(result => {


            this.reclamationCaseList = JSON.parse(JSON.stringify(result));
            let nbRec = 0;
            let nbMed = 0;
            let nbTic = 0;
            for(let rec of this.reclamationCaseList) {
                rec.CreatedDate = this.intl.format(new Date(rec.CreatedDate));
                if(rec.IsClosed || rec.HP_Type__c == null) {
                    continue;
                }
                if(rec.HP_Type__c.includes('Réclamation')) {
                    nbRec ++;
                } else if(rec.HP_Type__c.includes('Médiation')){
                    nbMed ++;
                } else if(rec.HP_Type__c.includes('TIC')){
                    nbTic ++;
                }
            }
            if(nbTic > 0 && nbMed == 0 && nbRec == 0) {
                this.reclamationStatus = 'TIC TAC en cours';
            } else if(nbRec == 1 && nbMed == 0 && nbTic == 0) {
                this.reclamationStatus = 'En réclamation';
            } else if(nbRec == 0 && nbMed == 1 && nbTic == 0) {
                this.reclamationStatus = 'En médiation';
            } else if(nbRec > 1 && nbMed == 0) {
                this.reclamationStatus = 'Multiples réclamations';
            }else if(nbRec == 1 && nbMed == 0 && nbTic > 0) {
                this.reclamationStatus = 'Multiples réclamations';
            } else if(nbMed > 1 || (nbMed == 1 && (nbTic > 0 || nbRec > 0))) {
                this.reclamationStatus = 'Médiations en cours';
            }else {
                this.reclamationStatus = 'Créer réclamation';
            }
            console.log('@@@ case : ' +nbMed + '  ' + nbRec + '  ' + nbTic);
        }).catch(errorIsclient => {
            console.log('@@@ case***********',errorIsclient);
        });
        loadContact({
            contactId: this.recordId
        }).then(resultContact => {

            console.log('Contact xdataId ' + JSON.stringify(resultContact.ID_Tiers__c));
            this.idClient = resultContact.ID_Tiers__c;
            this.sharedURL = resultContact.HP_Shared_URL__c;

            getIsClientOffline({
                idClient: this.idClient
            }).then(resultIsClientOffline => {
                console.log('resultIsClientOffline', resultIsClientOffline.output.is_offline);
                if (resultIsClientOffline.output.length != 0) {
                    this.offline = resultIsClientOffline.output.is_offline;
                } else {
                    this.offline = resultIsClientOffline.output;
                }
            }).catch(errorIsclient => {
                console.log('errorIsclient', errorIsclient);
            })
        }).catch(errorLoadContact => {
            console.log('error loadContact', errorLoadContact);
        })
    }
    renderedCallback() {
        if (!getFieldValue(this.contact.data, EMAIL_FIELD)) {
            // this.template.querySelector('.emailp').classList.add('display-none');
        }
    }
    /* SMILE Fields */
    get refclient() {
        let refcl1 = getFieldValue(this.contact.data, REFCLI_FIELD);
        if (refcl1 === undefined || refcl1 === null || refcl1 === '') {
            return false;
        } else {
            let refcl2 = String(refcl1);
            if (refcl2.length > 9) {
                return refcl2.substr(-9);
            }
            return refcl2;
        }
    }

    get globalScore() {
        return getFieldValue(this.contact.data, GLOBAL_MOY_SCORE_FIELD);
    }
    get dernierScore() {
        return getFieldValue(this.contact.data, ADERNIER_SCORE_FIELD);
    }


    //get recordtype () {return getFieldValue(this.contact.data,  RECORDTYPE_FIELD);}
    get emailprincipal() {
        return getFieldValue(this.contact.data, EMAILPR_FIELD);
    }
    get userRecordId() {
        return getFieldValue(this.contact.data, RECORDTYPE_FIELD);
    }
    get mobileprincipal() {
        return getFieldValue(this.contact.data, MOBPR_FIELD);
    }
    get telfixeprincipal() {
        return getFieldValue(this.contact.data, FIXPR_FIELD);
    }
    
    get segmentmarketing() {
        return getFieldValue(this.contact.data, SEGMKT_FIELD);
    }
    /* SMILE Fields END */
    /* HAPPE Fields */
    get hprefclient() {
        return getFieldValue(this.contact.data, REFCLI_FIELD_HAPPE);
    }
    get hpisHPClient(){
        return getFieldValue(this.contact.data, ISHAPPE_FIELD);
    }
    get hpemail() {
        return getFieldValue(this.contact.data, EMAIL_FIELD);
    }
    get hpphone() {
        return getFieldValue(this.contact.data, PHONE_FIELD);
    }
    get hpmobilephone() {
        return getFieldValue(this.contact.data, MOBILE_PHONE_FIELD);
    }

    get hpnumeroEtranger() {
        return getFieldValue(this.contact.data, NUMETRANGER_FIELD);
    }
    /* HAPPE Fields END */
    /* COMMON Fields */
    get salutation() {
        return getFieldValue(this.contact.data, SALUT_FIELD);
    }
    get firstname() {
        return getFieldValue(this.contact.data, FIRSTNAME_FIELD)
    }
    get lastname() {
        return getFieldValue(this.contact.data, LASTNAME_FIELD);
    }
    get novoie() {
        return getFieldValue(this.contact.data, NOVOIE_FIELD);
    }
    get mailingstreet() {
        return getFieldValue(this.contact.data, MAILST_FIELD);
    }
    get mailingcity() {
        return getFieldValue(this.contact.data, MAILCI_FIELD);
    }
    get mailingpostalcode() {
        return getFieldValue(this.contact.data, MAILPO_FIELD);
    }
    get complementadresse() {
        return getFieldValue(this.contact.data, CPLTAD_FIELD);
    }
    get statutinternaute() {
        return getFieldValue(this.contact.data, INTST_FIELD);
    }
    get arequalifier() {
        return getFieldValue(this.contact.data, REQUALIF_FIELD);
    }
    /* COMMON Fields END*/
    /* get urlLink() {return "/apex/SM_VFP_ModifInformationPerso?id=" + this.recordId;} */
    get urlLink() {
        return "/apex/vlocity_cmt__OmniScriptUniversalPageConsole?id={0}&OmniScriptType=Contact&OmniScriptSubType=ModifyInformations&OmniScriptLang=English&PrefillDataRaptorBundle=&scriptMode=vertical&layout=lightning&ContextId={0}";
    }
    get ismister() {
        let salutation = getFieldValue(this.contact.data, SALUT_FIELD);
        return (salutation === 'MR') ? true : false;
    }
    get ismadame() {
        let salutation = getFieldValue(this.contact.data, SALUT_FIELD);
        return (salutation === 'MRS' || salutation === 'MME' || salutation === 'MLLE') ? true : false;
    }
    get isother() {
        let salutation = getFieldValue(this.contact.data, SALUT_FIELD);
        return (salutation != 'MR' && salutation != 'MRS' && salutation != 'MME' && salutation != 'MLLE') ? true : false;
    }
    get isinternaute() {
        return getFieldValue(this.contact.data, INTST_FIELD) === 'Oui';
    }
    get becomesinternaute() {
        return getFieldValue(this.contact.data, INTST_FIELD) === 'En cours';
    }
    get notinternaute() {
        return getFieldValue(this.contact.data, INTST_FIELD) === 'Non';
    }
    get numvoierue() {
        let novoie = getFieldValue(this.contact.data, NOVOIE_FIELD);
        let mailingstreet = getFieldValue(this.contact.data, MAILST_FIELD);
        if (novoie === null) {
            return mailingstreet
        } else {
            return novoie + ' ' + mailingstreet
        }
    }

    get displayIcon() {
        return this.reclamationStatus != 'Créer réclamation';
    }
    // updateCoords(){
    //     const eventName = 'opencoordinates';
    //     const event = new CustomEvent(eventName, {
    //         detail: { message: 'open coord tab' }
    //     });
    //     this.dispatchEvent(event);
    // }
    openAgilabSpace() {
        let agilabId = getFieldValue(this.contact.data, AGILABID_FIELD);
        getAgilabEspaceClientURL()
            .then(result => {
                console.log('@@@@ custommetadata ' + result);
                if (agilabId != null) {
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: result + "personnes/public/" + agilabId.toString()
                        }
                    });
                } else {
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: result
                        }
                    });
                }
            });
    }
    updateCoords() {
        this.updateClientPopupModal = true;
    }
    urlec = 'https://page.tobe.found';
    navigateToEC() {
        console.log("navigate to coords, urlec: ", this.urlec);
        getURLImpersonationForContact({
                contactID: this.recordId
            })
            .then(result => {
                console.log('got result ', result);
                this.urlec = result;
                this.error = undefined;
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url: result
                    }
                });
            })
            .catch(error => {
                console.log('got error ', error);
                this.error = error;
                this.urlec = undefined;
            });
    }
    closeUpdateInfo(event) {
        this.updateClientPopupModal = false;
        refreshApex(this.contact);
    }

    closePopupModalReclamationCase() {
        this.showReclamationCase = false;
    }
    openPopupModalReclamationCase() {
        this.showReclamationCase = true;
    }

    handleSubmit(event) {
        this.showSpinner = true;
        event.preventDefault();
        const fields = event.detail.fields;

        fields.RecordTypeId = this.reclamationRT;
        fields.ContactId = this.recordId;
        fields.Status = 'HP_PENDING';
        fields.Reason = fields.HP_Motif__c;
        console.log(JSON.stringify(fields));
        this.isTicTac = fields.HP_Type__c == 'HP_TIC_TAC';
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event) {
        this.showSpinner = false;
        const payload = event.detail;
        //console.log("@@ payload : " + JSON.stringify(event));

        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
        this.showReclamationCase = false;
        eval("$A.get('e.force:refreshView').fire();");

        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Requête créée avec succès',
            variant: 'success'
        }));
        
        if(!this.isTicTac) {
        window.location.reload();
           return;
       }
        let role = getFieldValue(this.user.data, ROLE_DEV_NAME);
        let val = null;
        if(role == 'HP_Conseiller_Niveau_1') {
            val = 'Niveau 2';
        }

        if(role == 'HP_Conseiller_Niveau_2') {
            val = 'Niveau 3';
        }

        if(val == null) {
            window.location.reload();
            return;
        }
        const fields = {};
        fields[ID_FIELD.fieldApiName] = updatedRecord;
        fields[QUEUESUBLE_FIELD.fieldApiName] = val;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                window.location.reload();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erreur',
                        message: "Erreur d'escalade",
                        variant: 'error'
                    })
                );
                window.location.reload();
            });
    }


    get reclamationRT() {
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Médiation / Réclamation');
    }


    openReclamationCase(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  event.target.dataset.id,
                actionName: 'view',
            },
        })
    }

    closePopupNoteSatisfactionCase() {
        this.showNoteSafisfaction = false;
    }
    openNoteSatisfaction() {
        this.showNoteSafisfaction = true;
    }

    openEditNameClient() {
        publish(this.messageContext, openEditNameClient, null);
    }
}