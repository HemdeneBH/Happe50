import { LightningElement, track, api, wire } from 'lwc';
import editNameClient from '@salesforce/apex/HP_SM058_EditNameClient.editName';
import sendJustificatifClient from '@salesforce/apex/HP_SM058_EditNameClient.sendJustificatif';
import notificationClient from '@salesforce/apex/HP_SM058_EditNameClient.notificationClient';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import { getRecord, getFieldValue} from 'lightning/uiRecordApi';

const FIELDS = [EMAIL_FIELD];
export default class Hp_editNameClient extends LightningElement {
    contactId;
    @track
    currentSalutation;
    @track
    currentLastName;
    @track
    currentFirstName;
  
    @track 
    showSpinner = false;

    @track
    salutation;
    @track
    lastName;
    @track
    firstName;

    @track
    motifValue = 'C';
    
    @track

    actionValue = 'I';


    @track 
    actionButtonLabel = 'Sauvegarder';
    action;
    idTier;

    @track
    showNotification = false;

    @track
    notifyGaz;
    @track
    notifyElec;

    contratList;
    email;
    sms;
    numVoie;
    voie;
    codePostal;
    ville;
    omega;
    sge;

    caseId;

    @track
    emailClient;
    
    @wire(getRecord, {
        recordId: '$contactId',
        fields: FIELDS
    })  wiredRecord({ error, data }) {
        console.log('@@@@@@@@@@@@ dd');
        if (data) {
            this.emailClient = getFieldValue(data, EMAIL_FIELD);
        }
      };

    get motifOptions() {
        return [
            { label: 'Changement de civilité / correction du nom ou du prénom du titulaire', value: 'C' },
            { label: 'Mariage / Concubinage / Divorce', value: 'M' },
            { label: 'Décès du titulaire / Succession', value: 'D' }
        ];
    }

    get civititeOptions() {
        return [
            { label: 'MR', value: 'MR' },
            { label: 'MME', value: 'MME' }
        ];
    }

    get actionOptions() {
        return [

           
            { label: 'Transmettre les instructions', value: 'I' },
            { label: 'Traiter les justificatifs', value: 'J' }

        ];
    }
    @api
    set masterdata(value) {
        if(value == null ) {
            return;
        }

        this.contratList = value?.contratInfoList?.data?._data;
        console.log('this.contratList  ' + JSON.stringify( this.contratList));
        let personneData = value.data[0];
        
        this.currentSalutation = this.salutation = personneData.Salutation;
        this.currentLastName = this.lastName = personneData.LastName;
        this.currentFirstName = this.firstName = personneData.FirstName;
        this.numVoie = personneData.No_Voie__c;
        this.voie = personneData.MailingStreet;
        this.codePostal = personneData.MailingPostalCode;
        this.ville = personneData.MailingCity;
        this.contactId = personneData.Id;
        this.idTier = personneData.ID_Tiers__c;
        console.log('@@@   ' + JSON.stringify(personneData));
    }
    get masterdata() {
        return null;
    }

    motifChange(event) {
        this.motifValue = event.target.value;
        this.actionButtonLabel = 'Sauvegarder';

        this.actionValue = 'I';

    }

    actionChange(event) {
        this.actionValue = event.target.value;
        this.actionButtonLabel = (this.actionValue === 'J' ? 'Sauvegarder' : 'Envoyer les instructions par email');
    }
    get isCorrection() {
        return this.motifValue == 'C' && this.showNotification == false;
    }

    get isNotCorrection() {
        return this.motifValue != 'C' && this.showNotification == false;
    }

    get isInstruction() {
        return this.actionValue == 'J';
    }

    handleChangeData(event) {
        if( event.target.name == 'lastName'){
            this.lastName = event.target.value;
        } else if( event.target.name == 'firstName'){
            this.firstName = event.target.value;
        } else if( event.target.name == 'salutation'){
            this.salutation = event.target.value;
        } else if(event.target.name === 'sms'){
            this.sms = event.target.checked;
        } else if(event.target.name === 'email'){
            this.email = event.target.checked;
        } else if(event.target.name === 'sge'){
            this.sge = event.target.checked;
        } else if(event.target.name === 'omega'){
            this.omega = event.target.checked;
        } else if(event.target.name === 'emailClient'){
            this.emailClient = event.target.value;
        }
    }
    closeEdit() {
        this.dispatchEvent(new CustomEvent('activateresiliation', { detail: false}));
    }

    saveClient() {
        this.showNotification ? this.sendNotification() :((this.motifValue === 'C' || this.actionValue === 'J') ? this.updateName(this.actionValue === 'J' && this.motifValue != 'C') : this.sendEmail());
    }
    updateName(isJ) {
        this.processContract();
        this.showSpinner = true;
        let contrats = (this.notifyElec ? 'E' :'') + (this.notifyGaz ? 'G' :'');
        editNameClient({contactId : this.contactId, xdataId: this.idTier, salutation :this.salutation,
            firstName : this.firstName, lastName : this.lastName,
            numVoie : this.numVoie, voie : this.voie,
            codePostal : this.codePostal, ville : this.ville, motif : this.motifValue, contrats: contrats, isJust : isJ }).then(result => {
                this.caseId = result.caseId;
                if(result.success == false) {
                const evt = new ShowToastEvent({
                    title: "Erreur",
                    message: 'Error, un case à été créé',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.showSpinner = false;
                this.dispatchEvent(evt);
                return;
            }
            console.log('ok1');
            this.showSpinner = false;
            this.showNotification = true;
            this.processContract();
        }).catch(error => {
            console.log('error',JSON.stringify(error));
            this.showSpinner = false;
        });
    }
    sendEmail(){
        this.showSpinner = true;
        this.processContract();
        let contrats = (this.notifyElec ? 'E' :'') + (this.notifyGaz ? 'G' :'');
        sendJustificatifClient({contactId: this.contactId, contrats : contrats, motif : this.motifValue,
            emailClient : this.emailClient}).then(result => {
            console.log('ok');
            this.showSpinner = false;

            this.closeEdit();

            const evt = new ShowToastEvent({
                title: "Succès",
                message: 'Insctructions envoyés au client',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        });
    }

    processContract() {
        if(this.contratList == null) {
            return;
        }
        this.notifyGaz = (this.contratList.filter(e => (['E0004','H0101','H0102','E0007'].includes(e.codeStatutCrm))
        && e.offre.includes('Gaz')).length > 0);
        this.notifyElec = (this.contratList.filter(e => (['E0004','H0101','H0102','E0007'].includes(e.codeStatutCrm) 
        && e.offre.includes('Electricité'))).length > 0);
    }

    get notifyElecOrGaz() {
        return this.notifyElec || this.notifyGaz;
    }
    sendNotification() {

        if((this.notifyGaz == true && this.omega != true) || (this.notifyElec == true && this.sge != true)) {
            const evt = new ShowToastEvent({
                title: "Erreur",
                message: 'Merci de valider la modification de titulaire dans le portail Enedis(SGE) ou/et le portail GrDF(OMEGA)',
                variant: 'error',
                mode: 'dismissable'
            });
            
            this.dispatchEvent(evt);
            return;
        }
        this.showSpinner = true;
        notificationClient({contactId: this.contactId, sms: this.sms, email : this.email, sge : this.sge, omega : this.omega, caseId : this.caseId}).then(result => {
            this.closeEdit();
            this.showSpinner = false;

            const evt = new ShowToastEvent({
                title: "Succès",
                message: 'Notification envoyée vers le client avec succès',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        });
    }
}