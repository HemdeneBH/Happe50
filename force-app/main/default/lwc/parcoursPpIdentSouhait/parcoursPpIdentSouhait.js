import { LightningElement, track, api } from 'lwc';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';

export default class ParcoursPpIdentBesoin extends LightningElement {
    GazImage = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--energie-group-3.png';
    GazImageInBlue = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--situation-group-3-blue.png';
    trucImage = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--situation-group-3-FB2B6729-A9F7-4898-9E4D-BE443CF34643@2x.png';
    trucImageInBlue = EngieCommunityResource + '/EngieAssets/pictures/1-identification-besoin--situationbase-fill-1-0EE71839-EF45-4FE6-915E-0118DFBD5E8D@2x.png';
    ElecImage = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--energie-group-3-433FD42E-F852-4018-945F-EC12D1BEB415@2x.png';
    ElecImageInBlue = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--situation--appel-group-6-99881D46-814F-4E1B-B51C-3E3462D45265@2x.png';

    @api record;
    handleButtonClick(event) {
        let detail = {
            value: event.target.dataset.id
        }
        const dispatchEvent = new CustomEvent("souhaitchange", {
            detail: {
                detail
            }
        });
        this.dispatchEvent(dispatchEvent);
    }

    get isLogementActive() {
        console.log(this.record.VI_ChoixParcours__c);
        return typeof this.record !== "undefined" && this.record.VI_ChoixParcours__c === "EM";
    }
    get isChangementActive() {
        console.log(this.record.VI_ChoixParcours__c);
        return typeof this.record !== "undefined" && this.record.VI_ChoixParcours__c === "CHF";
    }

    handleSuivant(event) {
        console.log("### Suivant : ");
        const dispatchEventSearch = new CustomEvent('suivant');
        this.dispatchEvent(dispatchEventSearch);
        console.log("### Suivant FIN : ");
    }
}