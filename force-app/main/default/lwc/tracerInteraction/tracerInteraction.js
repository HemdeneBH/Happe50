import tmpl from "./tracerInteraction.html";
import { LightningElement, api, track, wire} from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import { CurrentPageReference } from 'lightning/navigation';
export default class TracerInteraction extends OmniscriptBaseMixin(LightningElement) {
    @api steplabel;
    @api hascancel;
    @api hastrace;
    @api hasresponse;
    @api hasclose;
    @api resumestep;
    @api hascancelpayeur;
    @api hascancelmodif;
    @track showSpinner = false;
    @track showModal = false;

    mode;
    message;

    @wire(CurrentPageReference)
    pageRef;

    render() {
        return tmpl;
    }

    handleSave(evt){
        this.showSpinner = true;
        this.closeModal();
        //start bypass validation on required field in sections (issue with Winter '20) - ends in tracerInteraction
        this.omniApplyCallResp({ "hideRequired": true});
        this.omniApplyCallResp({ "pauseIndex": (this.resumestep ? this.resumestep : this.omniScriptHeaderDef.asIndex)});
        this.omniApplyCallResp({ "pauseStepName": this.omniScriptHeaderDef.asName});
        this.omniApplyCallResp({ "StepLabelOS": this.omniJsonDef.propSetMap.customAttributes[0].source});
        this.omniNextStep();
    }

    handleCancel(evt){
        this.showSpinner = true;
        this.closeModal();
        if(this.omniJsonData.DRId_Case){
            let params = {
                input: JSON.stringify({DRId_Case: this.omniJsonData.DRId_Case}),
                sClassName: 'vlocity_cmt.IntegrationProcedureService',
                sMethodName: 'IP_SM_CloseCase_CancelBtn_Smile',
                options: '{}'
                };
            this.omniRemoteCall(params).then(callRes => {
                this.callCloseCase();
            });
        }
        else{
            this.callCloseCase();
        }
    }

    handleClose(evt){
        this.callCloseCase();
    }

    callCloseCase(){
        //navigate Handler will refresh the console and close this tab
        let vlocNavigate = this.template.querySelector('vlocity_cmt-navigate-action');
        vlocNavigate.targetParams = `c__NavigateId=${this.omniJsonData.ContextId}`;
        vlocNavigate.navigate();
    }

    openCancelModal() {
        this.mode = "cancel";
        this.message = "Confirmez-vous l'annulation de la demande ?";
        this.template.querySelector('vlocity_cmt-modal').openModal();
    }

    //FT2-1464 : Ajout Payeur Divergent: écran d’attribution des rôles
     previousPayeur(){
        this.omniApplyCallResp({"isPayeurDivergent" : false});
        this.omniApplyCallResp({"isPayeurDiv" : false});//FT2-1484 : Ajout Payeur Divergent: écran d’attribution des rôles (Création d'un nouveau payeur)
        this.omniApplyCallResp({"payeur" : false});
        this.omniApplyCallResp({"relance" : false});
        this.omniApplyCallResp({"facture" : false});
        this.omniPrevStep();
    

    }
   //FT2-1404 Payeur Divergent - Modification du rôle du payeur divergent (Relance - Facture)
    cancelModifPayeur(){
        this.omniApplyCallResp({"ServicesGestion":{"InfosContactPayeur":{"modifroles":{"ismodify" : "false"}}}});
    
    } 
    openSaveModal() {
        //FT2-1729 Ajustement mensualité V2 : RG4 Alimentation du champ Refus - Ajustement
        if(this.steplabel=="Modifier les mensualités estimées"){
            this.omniApplyCallResp({"isAjustementRefus" : true});
        }
        this.mode = "save";
        this.message = "Etes-vous sûr de vouloir interrompre votre parcours ?";
        this.showModal = true;
        this.template.querySelector('vlocity_cmt-modal').openModal();
    }
    
    openTraceNominalPayeur() {
        this.omniApplyCallResp({"isResponseClientServiceGestion" : true});
        this.omniApplyCallResp({"StepLabelOS" : "Payeur Divergent"});
        this.omniNextStep();
    }
    closeModal() {
        this.showModal = false;
        this.template.querySelector('vlocity_cmt-modal').closeModal();
    }
      
    submit() {
        if (this.mode === "cancel") {
            this.handleCancel();
        } else if (this.mode === "save") {
            this.handleSave();
        }
    }

}