import { LightningElement, api, track, wire} from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { CurrentPageReference } from 'lightning/navigation';

export default class DemandeClientOS extends OmniscriptBaseMixin(LightningElement) {
    
    @track showModal = false;
    mode;
    message;
    @wire(CurrentPageReference)
    pageRef;

    
    handleSave(evt){
        this.omniNextStep();
        this.closeModal();
    }


    handleClose(evt){
        //navigate Handler will refresh the console and close this tab
        let vlocNavigate = this.template.querySelector('vlocity_cmt-navigate-action');
        vlocNavigate.targetParams = `c__NavigateId=${this.omniJsonData.ContextId}`;

        vlocNavigate.navigate();
    }

    openModal() {
        this.mode = "save";
        this.message = "Etes-vous sûr d’avoir répondu à la demande du client ?";
        this.showModal = true;
        this.template.querySelector('vlocity_cmt-modal').openModal();

      }

      closeModal() {
        this.showModal = false;
        this.template.querySelector('vlocity_cmt-modal').closeModal();

      }

    
    }