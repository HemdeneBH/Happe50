import { LightningElement, api, track } from 'lwc';
import { NavigationMixin} from 'lightning/navigation';
import loadNoteSatisfaction from "@salesforce/apex/HP_SM045_NoteSatisfaction.loadContactWithNoteSatisfaction";

export default class Hp_noteSatisfaction extends NavigationMixin(LightningElement) {
    @api contactid;
    @track notesSAtisfaction;
    @track filtredData;
    @track showSpinner = true;
    connectedCallback() {
        loadNoteSatisfaction({
            idContact : this.contactid
        }).then(result => {

            this.showSpinner = false;
            this.notesSAtisfaction = JSON.parse(JSON.stringify(result));
            this.notesSAtisfaction.chatStyle = this.getStyle5(this.notesSAtisfaction.HP_Chat_Score__c);
            this.notesSAtisfaction.telStyle = this.getStyle5(this.notesSAtisfaction.HP_Telephone_Score__c);
            this.notesSAtisfaction.emailStyle = this.getStyle5(this.notesSAtisfaction.HP_Email_Score__c);
            this.notesSAtisfaction.csatStyle = this.getStyle5(this.notesSAtisfaction.HP_Souscription_CSAT_Score__c);
            this.notesSAtisfaction.npsStyle = this.getStyle10(this.notesSAtisfaction.HP_Souscription_NPS_Score__c	);
            this.notesSAtisfaction.mktcVDCNps = this.getStyle10(this.notesSAtisfaction.HP_VDS_NPS_Note__c);
            this.notesSAtisfaction.mktcVDCCsat = this.getStyle5(this.notesSAtisfaction.HP_VDS_CSAT_Note__c);
            this.notesSAtisfaction.mktcResilNps = this.getStyle10(this.notesSAtisfaction.HP_Resil_NPS_Note__c);
            this.notesSAtisfaction.mktcResilCsat = this.getStyle5(this.notesSAtisfaction.HP_Resil_CSAT_Note__c);
            this.filtredData = this.notesSAtisfaction.HP_Notes_de_satisfaction__r;
        });
    }

    getStyle10(score) {
        if(score == null) {
            return '';
        }
        if(score <= 6) {
            return 'red';
        }

        if(score <= 8) {
            return 'orange';
        }

        if(score <= 10) {
            return 'green';
        }
    }

    getStyle5(score) {
        if(score == null) {
            return '';
        }
        if(score < 3) {
            return 'red';
        }

        if(score < 4) {
            return 'orange';
        }

        if(score <= 5) {
            return 'green';
        }
    }
    openNoteCase(evt) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:  evt.target.dataset.id,
                actionName: 'view',
            },
        })
    }

    filterData(evt) {
        let val =  evt.target.value;
        if(val == null || val == '') {
            this.filtredData = this.notesSAtisfaction.HP_Notes_de_satisfaction__r;
            return;
        }
        val = val.toLowerCase();
        this.filtredData = [];
        for(let item of this.notesSAtisfaction.HP_Notes_de_satisfaction__r) {
            if((item.HP_Case__r != null && item.HP_Case__r.CaseNumber != null && item.HP_Case__r.CaseNumber.includes(val)) ||
             (item.HP_satisfaction_verbatim__c != null && item.HP_satisfaction_verbatim__c.toLowerCase().includes(val)) ||
            (item.HP_satisfaction_canal__c!= null && item.HP_satisfaction_canal__c.toLowerCase().includes(val)) || 
            (item.HP_satisfaction_OeD__c!= null && item.HP_satisfaction_OeD__c.toLowerCase().includes(val)) ||
             (item.HP_satisfaction_canal__c != null && item.HP_satisfaction_canal__c.toLowerCase().includes(val)) ||
             val == item.HP_satisfaction_score__c) {
                this.filtredData.push(item);
            }

        }
    }
}