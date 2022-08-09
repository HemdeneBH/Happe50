import { LightningElement , api} from 'lwc';
import template from "./sM_DossierRecouvrement_ParcoursDossier.html";
export default class sM_DossierRecouvrement_ParcoursDossier extends LightningElement {
   
     _listEtapesWrapper;
     @api set listEtapesWrapper(value) {
    this._listEtapesWrapper = value || {};
    
    }

    get listEtapesWrapper() {
    return this._listEtapesWrapper;
    }
    
}