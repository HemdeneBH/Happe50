/* eslint-disable eqeqeq */
/* eslint-disable no-alert */
/* eslint-disable no-console */
/* eslint-disable guard-for-in */
import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getfileIds from '@salesforce/apex/MP_LWC02_Download.getfileIds';
import fileWrapper from './file';

const colFiles = [
    { label: 'Nom', fieldName: 'Title'},
    { label: 'Type de Fichier', fieldName: 'FileExtension'}
];
 
export default class Mp_download extends NavigationMixin(LightningElement) {
    @api recordId;
    @track AllFiles;
    @track fileIds = '';
    @track error = '';
    @track bShowModal = false;
    @track files = [];
    @track colFiles = colFiles;
    @track filesToDownload;


    @wire(getfileIds, { recordId: '$recordId' })
    filesData({data, error}) {
        if(data) {
            let f_list = [];
            for(let c of Object.values(data)){
                f_list.push(new fileWrapper(c.Id, 
                    c.Title, 
                    c.FileExtension, 
                    c.ContentDocumentId));
            }
            this.files = f_list;
        }
        else if(error) {
            this.showToast('Erreur de chargement des Fichiers', JSON.stringify(error), 'error');
        }
    }
    
    showToast(titre, texte, type){
		this.dispatchEvent(new ShowToastEvent({
			title: titre, 
			message: texte, 
			variant: type
		}),);
    }
    
    getDownloaLink() {
        if(this.filesToDownload != ''){
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: '/sfc/servlet.shepherd/version/download/'+this.filesToDownload
                }
            },
            false);
        }else{
            this.showToast('Erreur Téléchargement', 'Pas de fichier séléctionné', 'error');
        }
        
    }

    getSelected(event) {
        this.filesToDownload = '';
        const selectedRows = event.detail.selectedRows;
        for (let i = 0; i < selectedRows.length; i++){
            this.filesToDownload += selectedRows[i].Id+'/';
        }
        if(this.filesToDownload.length > 0) {
            this.filesToDownload =this.filesToDownload.replace(/.$/,"?");
        }
	}

    closeModal() {
        this.bShowModal = false;
    }

    openModal() {
        this.bShowModal = true;
    }
}