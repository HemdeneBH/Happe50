import template from "./sm_LWC_createContact_duplicate_contact.html";
import { LightningElement, track, api } from 'lwc';
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { NavigationMixin } from 'lightning/navigation';

export default class Sm_LWC_createContact_duplicate_contact extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @track matchRecordWrappers = [];
    @track contactInfo;
    omniJsonDataCopy;

    moreDetails(event) {
                
        let vlocNavigate = this.template.querySelector('vlocity_cmt-navigate-action');
        vlocNavigate.targetParams = 'c__NavigateId=' + event.target.dataset.id + '&c__ParentUid=' + this.omniJsonData.uid;
        vlocNavigate.replace = false;
        vlocNavigate.navigate();
    }
    

    get mailDoublon() {
        let mailDoublonMail = '';
        if(this.omniJsonDataCopy && this.omniJsonDataCopy.ContactInfo &&  this.omniJsonDataCopy.ContactInfo.Email && this.omniJsonDataCopy.ContactInfo.Email.selectedEmail) {
            let selectedMailValue = this.omniJsonDataCopy.ContactInfo.Email.selectedEmail.split(' ');
            let selected = selectedMailValue[selectedMailValue.length - 1];
            mailDoublonMail = this.omniJsonDataCopy.ContactInfo.Email['NewEmail'+selected];
        }
        return mailDoublonMail;
    }

    get mobileDoublon() {
        let mobileDoublonVal = '';
        if(this.omniJsonDataCopy && this.omniJsonDataCopy.ContactInfo &&  this.omniJsonDataCopy.ContactInfo.TelMobile && this.omniJsonDataCopy.ContactInfo.TelMobile.selectedNumMobile) {
            var selectedMobileValue = this.omniJsonDataCopy.ContactInfo.TelMobile.selectedNumMobile.split(' ');
            var selected = selectedMobileValue[selectedMobileValue.length - 1];
            mobileDoublonVal = this.omniJsonDataCopy.ContactInfo.TelMobile['NewMobile'+selected];
        }    
        return mobileDoublonVal     
    }
    
    get fixeDoublon() {
        let fixeDoublonVal = '';
        if(this.omniJsonDataCopy && this.omniJsonDataCopy.ContactInfo && this.omniJsonDataCopy.ContactInfo.TelFixe && this.omniJsonDataCopy.ContactInfo.TelFixe.selectedNumFixe) {            
            var selectedTelFixeValue = this.omniJsonDataCopy.ContactInfo.TelFixe.selectedNumFixe.split(' ');
            var selected = selectedTelFixeValue[selectedTelFixeValue.length - 1];
            fixeDoublonVal = this.omniJsonDataCopy.ContactInfo.TelFixe['NewTelFixe'+selected];
        }
        return fixeDoublonVal;
    }

    addDataToGenderMatchRecords() {
        if (this.matchRecordWrappers) {
            this.matchRecordWrappers.forEach(mrw => {
                let salutation = mrw.record.Salutation;
                if(salutation === 'MR') {
                    mrw.svg1 = true ;
                    mrw.svg2 = false;
                    mrw.svg3 = false;
                } else if (salutation === 'MRS' || salutation === 'MME' || salutation === 'MLLE') {
                    mrw.svg1 = false;
                    mrw.svg2 = true ;
                    mrw.svg3 = false;
                } else {
                    mrw.svg1 = false;
                    mrw.svg2 = false;
                    mrw.svg3 = true ;
            }})
        }
    }
    @api
    set omniJsonData(omniJsonParam) {
        this.omniJsonDataCopy = omniJsonParam;
        if (this.omniJsonDataCopy && this.omniJsonDataCopy.matchRecord) {
            this.matchRecordWrappers = [];
            this.omniJsonDataCopy.matchRecord.forEach(matchRec => {
                this.matchRecordWrappers.push({ "record" : matchRec})
            });
            this.addDataToGenderMatchRecords();
            this.contactInfo = this.omniJsonDataCopy.ContactInfo;
        }
    }

    get omniJsonData() {
        return this.omniJsonDataCopy;
    }
}