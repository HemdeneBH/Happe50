import { LightningElement, api, track } from 'lwc';
import fetchLookUpValues from '@salesforce/apex/HP_SM057_CustomLookUpOwner.fetchLookUpValues';

export default class Hp_ownerLookup extends LightningElement {
    @track recordsList;  
    @track searchKey = "";  
    @api selectedValue;  
    @api selectedRecordId;  
    @track objectApiName = 'User';  
    @track iconName;  
    @api lookupLabel = 'Propriétaire de la requête';  
    @track message;  
      
    get ownerOptions() {
        return [
            { label: 'Utilisateur', value: 'User' },
            { label: 'Queue', value: 'Group' }
        ];
    }
    onLeave(event) {  
     setTimeout(() => {  
      this.searchKey = "";  
      this.recordsList = null;  
      
     }, 300);  
    }  
      
    onRecordSelection(event) {  
     this.selectedRecordId = event.target.dataset.key;  
     this.selectedValue = event.target.dataset.name;  
     this.searchKey = "";  
     this.onSeletedRecordUpdate();  
    }  
     
    handleKeyChange(event) {  
     const searchKey = event.target.value;  
     this.searchKey = searchKey;  
     this.getLookupResult();  
    }  
     
    removeRecordOnLookup(event) {  
     this.searchKey = "";  
     this.selectedValue = null;  
     this.selectedRecordId = null;  
     this.recordsList = null;  
     this.onSeletedRecordUpdate();  
   }  
   getLookupResult() {  
    fetchLookUpValues({ searchKeyWord: this.searchKey, ObjectName : this.objectApiName })  
     .then((result) => {  
      if (result.length===0) {  
        this.recordsList = [];  
        this.message = "No Records Found";  
       } else {  
        this.recordsList = result;  
        this.message = "";  
       }  
       this.error = undefined;  
     })  
     .catch((error) => {  
      this.error = error;  
      this.recordsList = undefined;  
     });  
   }  
    
   onSeletedRecordUpdate(){  
    const passEventr = new CustomEvent('recordselection', {  
      detail: { selectedRecordId: this.selectedRecordId, selectedValue: this.selectedValue }  
     });  
     this.dispatchEvent(passEventr);  
   }  

    changeObject(event) {
        this.objectApiName = event.target.value;
        this.selectedValue = null;
        this.selectedRecordId = null;
        if(this.objectApiName == 'User') {
            this.iconName = 'standard:user';
            //this.lookupLabel = 'Utilisateur';
        } else {
            this.iconName = 'standard:queue';
            //this.lookupLabel = 'Queue';
        }
    }
  }