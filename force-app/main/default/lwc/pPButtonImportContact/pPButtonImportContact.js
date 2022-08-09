import { LightningElement, track, api } from 'lwc';
import saveFile from '@salesforce/apex/VI_PPButtonImportContact.saveFile';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const columns = [
 { label: 'RecordTypeId', fieldName: 'RecordTypeId' }, 
    { label: 'Salutation', fieldName: 'Salutation' },
    { label: 'Firstname', fieldName: 'Firstname'}, 
    { label: 'Lastname', fieldName: 'Lastname'}, 
    { label: 'VI_CodeVendeur__c', fieldName: 'VI_CodeVendeur__c'}, 
    { label: 'AccountId', fieldName: 'AccountId'},
    { label: 'VI_Site_Prestataire__c', fieldName: 'VI_Site_Prestataire__c '},
    { label: 'VI_TypeUtilisateurPartnerCommunity__c', fieldName: 'VI_TypeUtilisateurPartnerCommunity__c'}, 
    { label: 'Email', fieldName: 'Email'},
    { label: 'VI_Utilisateur_actif__c', fieldName: 'VI_Utilisateur_actif__c'}

];

export default class LwcCSVUploader extends LightningElement {

    closeImage = EngieCommunityResource + '/EngieAssets/pictures/close-icon.png';

    @api recordid;
    @track columns = columns;
    @track data;
    @track fileName = '';
    @track insertError;
    @track UploadFile = 'Importer des contacts';
    @track showLoadingSpinner = false;
    @track isTrue = false;
    @track showError = false;
    loaded = true;
    selectedRecords;
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 1500000;

    isModalOpenBackgroundBttnImport = false;
    isModalBttnImportOpen = false;

    openModalBttnImport() {
        this.isModalOpenBackgroundBttnImport = true;
        this.isModalBttnImportOpen = true;
    }

    closeModalBttnImport() {
        this.isModalOpenBackgroundBttnImport = false;
        this.isModalBttnImportOpen = false;
    }

   handleFilesChange(event) {
       if(event.target.files.length > 0) {
           this.filesUploaded = event.target.files;
           this.fileName = event.target.files[0].name;
           this.insertError = '';
           
       }
   }

   handleSave() {
       if(this.filesUploaded.length > 0) {
           this.uploadHelper();
       }
       else {
           this.fileName = 'Merci de sélectionner un fichier CSV.';
       }
   }

   uploadHelper() {
       this.loaded = false;
       this.file = this.filesUploaded[0];
        if (this.file.size > this.MAX_FILE_SIZE) {
           window.console.log('La taille du fichier est trop volumineuse.');
           return ;
       }
       this.showLoadingSpinner = true;
       this.fileReader= new FileReader();
       this.fileReader.onloadend = (() => {
           this.fileContents = this.fileReader.result;
           this.saveToFile();
       });
       this.fileReader.readAsText(this.file);
   }

   saveToFile() {
       saveFile({ base64Data: JSON.stringify(this.fileContents), cdbId: this.recordid})
       .then(result => {
           if (result == null) {
                window.console.log('result ====> ');
                window.console.log(result);
                this.data = result;
                this.showError = false;
                this.fileName = this.fileName + ' - Les contacts ont été corretement déployés.';
                this.isTrue = false;
                this.loaded = true;
                this.showLoadingSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!',
                        message: this.file.name + ' - Les contacts ont été corretement déployés.',
                        variant: 'success',
                    }),
                );
                this.closeModalBttnImport();
           }
           else {
               this.loaded = true;
               this.showError = true;
               console.log(result);
               this.insertError =  result;
               this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Le fichier contient des erreurs.',
                       message: result,
                       variant: 'error',
                    }),
                );
           }
       })
       .catch(error => {
           window.console.log(error);
           this.loaded = true;
           this.showError = true;
           this.insertError = error.message;
           this.dispatchEvent(
               new ShowToastEvent({
                   title: 'Error.',
                   message: error.message,
                   variant: 'error',
               }),
           );
       });

   }
}