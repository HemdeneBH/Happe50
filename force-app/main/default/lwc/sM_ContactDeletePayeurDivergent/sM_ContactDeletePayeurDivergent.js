/*
  @description       : Suppression d'un payeur divergent
  @author            : FT2-AE
  @group             : Smile
  @last modified on  : 12-16-2021
  @last modified by  : FT2-AE
*/
import { LightningElement, api} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class sM_ContactDeletePayeurDivergent extends OmniscriptBaseMixin(LightningElement) {

    @api showSpinnerLoading;
    @api openConfirmDeleteModal = false;

    @api bppayeur;
    @api facture;
    @api payeur;
    @api relance;
    @api nocomptecontrat;
    @api idbp;


    @api suppressionPayeurRetour;
    // Ouverture de la popup et récupération des valeurs de facture/payeur/relance pour choisir quel trame il faut envoyer au WS
    openDeletePayeurPopup(){
        this.facture = this.omniJsonData.ServicesGestion.Block1.facture;
        this.payeur = this.omniJsonData.ServicesGestion.Block1.payeur;
        this.relance = this.omniJsonData.ServicesGestion.Block1.relance;
        this.openConfirmDeleteModal = true;
    }
    // Fermeture de la popup de suppression de payeur divergent
    noDeletePayeurDivergent(){
        this.openConfirmDeleteModal = false;  
    }
    yesDeletePayeurDivergent(){
        this.showSpinnerLoading=true;
        var MAJCompteClientDataStr;
        /*if(this.payeur){
            MAJCompteClientDataStr = {
                CompteClient: this.nocomptecontrat,
                IsAddDivergent: "true",
                idPersonnePayeur: this.idbp,//bp client
                idPersonne: this.bppayeur,
                codePayeur: this.payeur,
                codeRelance: 'false',
                codeFacture: 'false'
            };
        }else{

        }*/
        MAJCompteClientDataStr = {
            CompteClient: this.nocomptecontrat,
            IsAddDivergent: 'true',
            idPersonne: '',
            codeRelance: 'false',
            codeFacture: 'false'
        };
        const params = {
            input: MAJCompteClientDataStr,
            sClassName: 'vlocity_cmt.IntegrationProcedureService',
            sMethodName: 'IP_SM_MAJCompteClient_SOLI_WS',
            options: '{}',
            };
            this.omniRemoteCall(params, true).then(response => {
                this.showSpinnerLoading=false;
                if(response.result.IPResult.MAJCompteClient.code==='OCTOPUS_MAJCompteClient_01'){
                    this.suppressionPayeurRetour= true;
                    this.omniApplyCallResp({"isdeletedpayeurdivergent" : true}); 
                    this.omniNextStep(); 
                }
                else{
                    this.suppressionPayeurRetour= false;
            const evt = new ShowToastEvent({
            title: 'Problème technique',
            message: 'Un problème technique est survenue et la suppression n’a pas été faite',
            variant: 'error',
            });
            this.dispatchEvent(evt);
        }
                window.console.log(response, 'response IP_SM_MAJCompteClient_SOLI_WS suppression des rôles relance/facture/Payeur ');
            }).catch(error => {
                this.showSpinnerLoading=false;
                this.suppressionPayeurRetour= false;
                window.console.log(error, 'error IP_SM_MAJCompteClient_SOLI_WS suppression des rôles relance/facture/Payeur échoué');
        });
    }

}