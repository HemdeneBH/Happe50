import { LightningElement, api } from 'lwc';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';

export default class ParcoursPpIdentBesoin extends LightningElement {
    GazImage = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--energie-group-3.png';
    GazImageInBlue = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--situation-group-3-blue.png';
    ElecImage = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--energie-group-3-433FD42E-F852-4018-945F-EC12D1BEB415@2x.png';
    ElecImageInBlue = EngieCommunityResource + '/EngieAssets/pictures/1-besoins-client--situation--appel-group-6-99881D46-814F-4E1B-B51C-3E3462D45265@2x.png';

    
    @api record;
    handleButtonClick(event) {
        let detail = {
            value: event.target.dataset.id
        }
        const dispatchEvent = new CustomEvent("besoinchange", {
            detail: {
                detail
            }
        });
        this.dispatchEvent(dispatchEvent);
    }

    get isGazActive() {
        return typeof this.record !== "undefined" && this.record.VI_ChoixEnergie__c === "Gaz";
    }
    get isElectriciteActive() {        
        return typeof this.record !== "undefined" && this.record.VI_ChoixEnergie__c === "Electricité";
    }
    get isElectriciteGazActive() {
        return typeof this.record !== "undefined" && this.record.VI_ChoixEnergie__c === "Electricité + Gaz";
    }

    handlePrecedent(event) {
        console.log("### Suivant : ");
        const dispatchEventSearch = new CustomEvent('precedent');
        this.dispatchEvent(dispatchEventSearch);
        console.log("### Suivant FIN : ");
    }

    handleSuivant(event) {
        console.log("### Suivant : ");
        const dispatchEventSearch = new CustomEvent('suivant');
        this.dispatchEvent(dispatchEventSearch);
        console.log("### Suivant FIN : ");
    }
}