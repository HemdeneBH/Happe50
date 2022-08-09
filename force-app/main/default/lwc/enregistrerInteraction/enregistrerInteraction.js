/**
 * ModifiedBy : Ayoub B
 * ModifiedDate : 23/03/22
 * Description : add field isAppelTiers,NomTiers and RelationTiersClient to be required
 * ModifiedBy : Amine El Haddad
 * ModifiedDate : 17/05/22
 * Description : please find comments followed by [AEH]  
 */
 import template from "./enregistrerInteraction.html";

 import {
     LightningElement,
     track,
     api
 } from "lwc";
 
 import {
     OmniscriptBaseMixin
 } from "vlocity_cmt/omniscriptBaseMixin";
 //import SystemModstamp from "@salesforce/schema/Account.SystemModstamp";
 //import {registerListener, fireEvent} from 'c/pubsubkb';
 export default class enregistrerInteraction extends OmniscriptBaseMixin(LightningElement) {
     @track showSpinner = false;
 
     @api islaststep;
 
     render() {
         return template;
     }
     connectedCallback() {
         // Réaffectation du case à la reprise du parcours
         if (this.omniResume) {
             const inputMap = {
                 CaseAssignation: this.omniJsonData
             }
             const params = {
                 input: JSON.stringify(inputMap),
                 sClassName: 'vlocity_cmt.IntegrationProcedureService',
                 sMethodName: 'IP_SM_AssignerRepriseCase_Trace',
                 options: '{}'
             };
             this.omniRemoteCall(params)
                 .then(res => {
                     console.log("IP_SM_AssignerRepriseCase --> ", JSON.stringify(res));
                 })
         }
     }
     /** check if there is a next step
      *   "Mise en pause" && InterruptionRaison= Escalade du case &&  parcours (CHF/EM/RES)
      *
      *   islaststep = true (if current step is the the last step before save)
      * */
     get hasNextStep() {
         let jsonData = JSON.parse(JSON.stringify(this.omniJsonData));
 
         if (this.islaststep == "false" && jsonData.pauseIndex && jsonData.Step1 && jsonData.Step1.Section2
 
             &&
             jsonData.Step1.Section2.InterruptionRaison &&
             jsonData.Step1.Section2.InterruptionRaison == "Escalade du case" &&
             (
                 (jsonData.CaseType == "Acquisition" && jsonData.CaseSubType == "Changement de fournisseur") ||
                 (jsonData.CaseType == "Acquisition" && jsonData.CaseSubType == "Emménagement") ||
                 jsonData.CaseType == "Résiliation"
             )
         )
             return true;
         else
             return false
     }
     handleNext(evt) {
         // navigate to the next step of the Omniscript
         this.omniNextStep();
     }
     handleClick(evt) {
         this.showSpinner = true;
         let jsonData = JSON.parse(JSON.stringify(this.omniJsonData));
         //console.log("JSONINPUT" , jsonData);
         if  (jsonData.pauseIndex && jsonData.Step1.Section2.CheckEligibleMotifEscaladeCase == true) {
             this.showSpinner = false;
             alert('motif d’escalade sélectionné est propre à Harmonica. Merci de sélectionner un motif d’escalade propre à SMILE');
         }
            else  if  (jsonData.pauseIndex && jsonData.Step1.Section2.CheckEligibleMotifEscaladeCase1 == true) {
                this.showSpinner = false;
                alert('Ce motif d’escalade est réservé aux conseillers Back Office, merci de modifier votre choix de motif et sous-motif d’escalade');
           
          } else if (jsonData.isCasNominal) {
             console.log("##aka casNominal");
             this.handlePassCase(jsonData);
 
         } else {
             console.log("##aka else");
             this.handleClickSaveInteraction(jsonData);
         }
     }
     //[31/03/2022 Rajaa] modification of handlePassCase for infinite loading in the page
     handlePassCase(jsonData) {
         this.tracerInteraction(jsonData)
             .then(res => {
                 if (!this.omniScriptHeaderDef.hasInvalidElements) {
                     this.omniApplyCallResp({
                         "pauseIndex": null
                     });
                     this.omniApplyCallResp({
                         "pauseStepName": ""
                     });
                     this.omniApplyCallResp({
                         "pauseStepLabel": ""
                     });
                     this.omniApplyCallResp({
                         "isPauseInteraction": ""
                     });
                     this.omniApplyCallResp({
                         "SetStepCase": ""
                     });
                     this.omniApplyCallResp({
                         "errorProcess": ""
                     });
                     this.omniNextStep();
                 } else {
                     this.showSpinner = false;
                     alert('Merci de renseigner les champs obligatoires.');
                     throw this.getBreackChainError('Champs obligatoires non renseignés');
                 }
             })
             .then(() => {
 
                 // met a jour le statut du parcours a - completed (terminé)
                 this.updateOmniscriptInstance();
 
             }).catch(exception => {
                 console.log('Caught Exception ', exception);
             })
 
     }
     handleClickSaveInteraction(jsonData) {
         this.tracerInteraction(jsonData)
             .then(res => {
                 console.log('here is tracerInteraction res ');
                 //check required fields
 
                 if (!this.omniScriptHeaderDef.hasInvalidElements) {
 
                     console.log('before cal clean interaction');
                     // clean interaction fields  
                     this.cleanInteraction();
                     // move back to OS step before saving for later
                     this.omniNavigateTo(this.omniJsonData.pauseIndex);
                     //}
                 } else {
                     this.showSpinner = false;
                     alert('Merci de renseigner les champs obligatoires.');
                     throw this.getBreackChainError('Champs obligatoires non renseignés');
                 }
             }, res => {
                 this.showSpinner = false;
                 console.log('Error in tracerInteraction  : ' + JSON.stringify(res));
             })
             .then(resNav => {
                 //save for later
                 console.log('before reset to ');
                 this.omniSaveForLater();
             })
             .then(resSave => {
                 //navigate Handler will refresh the console and close this tab
                 let vlocNavigate = this.template.querySelector('vlocity_cmt-navigate-action');
                 vlocNavigate.targetParams = `c__NavigateId=${this.omniJsonData.ContextId}`;
                 vlocNavigate.navigate();
             })
             .catch(rej => {
                 this.showSpinner = false;
                 console.log('exception ', rej);
             })
     }
     cleanInteraction = function() {
         let section1 = {
             ...this.omniJsonData.Step1.Section1
         };
         for (let key in section1) {
             section1[key] = "";
         }
         //OS options
         this.omniApplyCallResp({
             "pauseIndex": null
         });
         this.omniApplyCallResp({
             "pauseStepName": ""
         });
         this.omniApplyCallResp({
             "pauseStepLabel": ""
         });
         this.omniApplyCallResp({
             "isPauseInteraction": ""
         });
         this.omniApplyCallResp({
             "SetStepCase": ""
         });
         this.omniApplyCallResp({
             "errorProcess": ""
         });
         //Section 1
         //this.omniApplyCallResp({ "InteractionTitle": ""});
         this.omniApplyCallResp({
             "InteractionDetails": ""
         });
         //Section 2
         //this.omniApplyCallResp({ "InterruptionRaison": null});
 
 
 
 
         this.omniApplyCallResp({
             "SousMotifEscalade": null
         });
 
 
 
 
         this.omniApplyCallResp({
             "MotifEscalade": null
         });
         this.omniApplyCallResp({
             "RaisonDetailleeEscalade": ""
         });
         //Section 4
         this.omniApplyCallResp({
             "TaskCreation": false
         });
         this.omniApplyCallResp({
             "TaskSubject": ""
         });
         this.omniApplyCallResp({
             "TaskDate": ""
         });
         this.omniApplyCallResp({
             "TaskComments": ""
         });
         //note : required picklist cannot be emptied (vlocity behavior). this will empty the picklists that are overridden by os_resettingRequiredSelect
         //i.e. : InteractionTitle, InterruptionRaison, sousMotif
         this.omniApplyCallResp({
             "loadedResetSelect": null
         });
    }

        tracerInteraction(jsonData) {
                let motifEscalade;
                let niveauEscalade;
                let inputMap;
                let params;
                //ensure nominal case or required fields are populated
                //[23/03/2022 Ayoub B] add field isAppelTiers,NomTiers and RelationTiersClient  
                //[31/03/2022 Rajaa] add a condition for a InteractionTitle
 
                if ((jsonData.Step1.Section1.InteractionTitle && jsonData.isCasNominal) ||
                    (jsonData.Step1.Section1.InteractionTitle &&
                        jsonData.Step1.Section1.OriginCall &&
                        jsonData.Step1.Section1.InteractionDetails &&
                        jsonData.Step1.Section2.InterruptionRaison &&
                        ((jsonData.Step1.Section1.isAppelTiers == true && jsonData.Step1.Section1.NomTiers && jsonData.Step1.Section1.RelationTiersClient) || jsonData.Step1.Section1.isAppelTiers == false)
                    ))
                    {
                                console.log("### aka ####");
                                //Set SubStatus_NiveauEscalade in jsonData
                                if (jsonData.Step1.Section2 && jsonData.Step1.Section2.InterruptionRaison === "Escalade du case") {
                                    console.log("### aka First Block ####");
                                    motifEscalade = jsonData.Step1.Section2.MotifEscalade;
                   
                                    if (motifEscalade === "MO18") {
                                        niveauEscalade = "Niveau 2";
                                    }
                                    else if(motifEscalade === "MO13"  && motifEscalade === "MO14"  ) {
                                        niveauEscalade = "";

                                     } else {
                                        niveauEscalade = "Escaladé Genesys";
                                     }
                   
                                       





                                    jsonData.SubStatus_NiveauEscalade = niveauEscalade;
                                    this.omniApplyCallResp({
                                        SubStatus_NiveauEscalade: niveauEscalade
                                    });
                                }









                                    //if nominal and required field populated or calculated (SubStatus_NiveauEscalade)
                        if (jsonData.isCasNominal || jsonData.Step1.Section2.InterruptionRaison !== "Escalade du case" ||
                            (jsonData.Step1.Section2.InterruptionRaison === "Escalade du case" && jsonData.SubStatus_NiveauEscalade)) {
                                console.log("### aka Seconde Block ####");
                                                //if  SubStatus_NiveauEscalade calculated prepare to update the case status as esacalated with a related intervention
                                if (jsonData.Step1.Section2 && jsonData.SubStatus_NiveauEscalade) {
                                        jsonData.Step1.Section1.CaseStatus = "Escaladé";
                                        var formDetail = null;
                               
                                        if (jsonData.Step2_traceIntr) {
                                            formDetail = this.getFormDetails(jsonData);
                                        } else if (jsonData.Step3_traceIntr) {
                               
                                            formDetail = this.getFormResiliationDetails(jsonData);
                                        }
                                        inputMap = {
                                                        CaseInfo: jsonData,
                                                        SubStatus_NiveauEscalade: jsonData.SubStatus_NiveauEscalade,
                                                        Formulaire: (formDetail !== null) ? formDetail : "",
                                                        CreateIntervention: true
                                        };
                                                //... else just update the case
                                }else {
                                        inputMap = {
                                                    CaseInfo: jsonData,
                                                    CreateIntervention: false
                                                };
                                        }                
           
                                    //HM FT4-119 call mediatech
                                        if (jsonData.Step1.Section1.InteractionTitle !== 'Traitement Conseiller' || jsonData.CaseOrigin !== 'Téléphone' && jsonData.CaseOrigin !== 'Phone') {
                                                   /* [AEH] 17/05/2022 commented, reason : not needed.    
                                                        var enqSatVar = jsonData.EnqSat;
                                                        if (!enqSatVar || enqSatVar === 'undefined') {
                                                            enqSatVar = null;
                                                        }
                                                    */        
                                                        var sousStatut;
                                                        if (jsonData.Step1.Section2 === null) {
                                                            sousStatut = null;
                                                        } else {
                                                            if (jsonData.Step1.Section2.InterruptionRaison === "Escalade du case" && jsonData.SubStatus_NiveauEscalade) {
                                                                sousStatut = jsonData.SubStatus_NiveauEscalade;
                                                            } else if (!jsonData.Step1.Section2.CaseSubStatus || jsonData.Step1.Section2.CaseSubStatus === 'undefined') {
                                                                sousStatut = null;
                                                            } else {
                                                                sousStatut = jsonData.Step1.Section2.CaseSubStatus;
                                                            }
                                                        }
                                   
                                                        if (!jsonData.CaseParent || jsonData.CaseParent === 'undefined') {
                                                            jsonData.CaseParent = null;
                                                        }
                                                        console.log("#JSONDATA", JSON.stringify(jsonData));
                                                     /* [AEH] 17/05/2022 corrections to the following :
                                                      * Interruption can take place before first step 1 is completed by the user. In that case Step1 node willl not exist. => new check is added before fetching step 1 node,
                                                      * Bad value for retricted picklist in REC Env => Case was not created because of missing value "Estimation Consomation"for "Sous-type" field in RT "Service (Managed)"
                                                      * jsonData.EnqSat do not neet to be parsed => replaced by ternary operator
                                                      * Section 3 can be empty depnding on OS type =>  CaseType and CaseSubType are retrieved at first node level.
                                                      * Bad value for retricted picklist in REC Env => Case was not correctly updated because of missing value "Payeur Divergent" for "Sous-type" field in RT "Service (Managed)"
                                                      * Getting CaseStatus at first node level.
                                                      */  
                                                        //if(jsonData.hasOwnProperty('Step1')){
                                                            var inputMapMT = {
                                                                CaseId: jsonData.DRId_Case,
                                                                /*CaseSubType: jsonData.Step1.Section3.CaseSubType,
                                                                CaseType: jsonData.Step1.Section3.CaseType,*/
                                                                CaseSubType: jsonData.CaseSousType,
                                                                CaseType: jsonData.CaseType,
                                                                ContactId: jsonData.ContextId,
                                                                SousStatutSmile: sousStatut,
                                                                /*StatutSmile: jsonData.Step1.Section1.CaseStatus,*/
                                                                StatutSmile: jsonData.CaseStatus,
                                                                userId: jsonData.userId,
                                                                CaseParent: jsonData.CaseParent,
                                                                CaseLastModifiedDate: jsonData.CaseLastModifiedDate,
                                                                CaseOrigin: jsonData.CaseOrigin ,
                                                                EnqSat:  jsonData.EnqSat === undefined ?  null :  jsonData.EnqSat 
                                                                /*EnqSat: JSON.parse(enqSatVar)*/
                                                            };
                                                            console.log("inputMap Before IP Mediatech", JSON.stringify(inputMapMT));
                                                           
                                                            let paramsMediatech = {
                                                                input: JSON.stringify(inputMapMT),
                                                                sClassName: 'vlocity_cmt.IntegrationProcedureService',
                                                                sMethodName: 'Mediatech_API',
                                                                options: '{}'
                                                            };
                                       
                                                            this.omniRemoteCall(paramsMediatech).then(res => {
                                                                    console.log("Mediatech_API --> ",JSON.stringify(res));
                                                            }).catch(function(err) {
                                                                    console.info('************ Erreur IP Mediatech ************');
                                                                    console.error(err);
                                                            });
                                                       // }
                                                   
                                        }
       
       
                                    console.log("inputMap Before IP Case", JSON.stringify(inputMap));
                                    //update case
                                   
                                    params = {
                                        input: JSON.stringify(inputMap),
                                        sClassName: 'vlocity_cmt.IntegrationProcedureService',
                                        sMethodName: 'IP_SM_TraceInteractionCase_Trace',
                                        options: '{}'
                                    };
                                    return this.omniRemoteCall(params);
                                   
                            }
                 }
               return Promise.resolve();
            }
       
     updateOmniscriptInstance() {
         const inputMap = {
             CaseId: this.omniJsonData.CaseId,
 
             OmniSavedStatus: 'Completed'
 
         };
         const options = {
             useFuture: true,
         };
         const params = {
 
             input: JSON.stringify(inputMap),
             sClassName: 'vlocity_cmt.IntegrationProcedureService',
             sMethodName: 'IP_SM_UpdateProcessusStatusCase_Trace',
 
             options: JSON.stringify(options),
         };
         this.omniRemoteCall(params);
 
     }
 
     saveInteraction() {
         const params = {
             input: this.omniJsonDataStr,
             sClassName: 'vlocity_cmt.IntegrationProcedureService',
             sMethodName: 'IP_SM_TraceInteractionCase_Trace',
             options: '{}'
         };
         this.omniRemoteCall(params)
             .then(res => {
                 this.omniApplyCallResp({
                     "pauseIndex": null
                 });
                 this.omniApplyCallResp({
                     "pauseStepName": ""
                 });
                 this.omniApplyCallResp({
                     "pauseStepLabel": ""
                 });
                 this.omniApplyCallResp({
                     "isPauseInteraction": false
                 });
                 this.omniNavigateTo(this.omniJsonData.pauseIndex);
             })
             .then(navRes => {
                 this.omniSaveForLater();
             })
             .then(svRes => {
                 let vlocNavigate = this.template.querySelector('vlocity_cmt-navigate-action');
                 vlocNavigate.targetId = this.omniJsonData.ContextId;
                 vlocNavigate.navigate();
             });
     }
     getBreackChainError(name) {
         let err = new Error();
         err.name = name;
         return err;
     }
     /**
      * Concaténation des champs remplis dans l'étape Formule d'escalade du Case
      * afin de renseigner le champs "Formulaire" de l'intervention
      */
     getFormDetails(jsonData) {
         var formDetailString =
 
             (jsonData.Step2_traceIntr.concernedOffer_ACQ_TI ? ("Offre concernée : " + jsonData.Step2_traceIntr.concernedOffer_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.customer_Number_ACQ_TI ? ("N° compte client : " + jsonData.Step2_traceIntr.customer_Number_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.offerDate_ACQ_TI ? ("Date proposition offre : " + this.dateConvert(jsonData.Step2_traceIntr.offerDate_ACQ_TI) + "<br>") : "") +
             (jsonData.Step2_traceIntr.EffectiveDate_S2_ACQ_TI ? ("Date d’effet souhaitée : " + this.dateConvert(jsonData.Step2_traceIntr.EffectiveDate_S2_ACQ_TI) + "<br>") : "") +
             (jsonData.Step2_traceIntr.address_ACQ_TI ? ("Adresse complète du lieu de consommation: " + jsonData.Step2_traceIntr.address_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.predecessorName_ACQ_TI ? ("Nom du prédécesseur: " + jsonData.Step2_traceIntr.predecessorName_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.CanalEnvoiCPV_S2_ACQ_TI ? ("Canal d’envoi CPV : " + jsonData.Step2_traceIntr.CanalEnvoiCPV_S2_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.PCE_Number_ACQ_TI ? ("N° PCE : " + jsonData.Step2_traceIntr.PCE_Number_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.CAR_S2_ACQ_TI ? ("CAE/CAR (GAZ) : " + jsonData.Step2_traceIntr.CAR_S2_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.PDL_Number_ACQ_TI ? ("N° PDL : " + jsonData.Step2_traceIntr.PDL_Number_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.CAE_S2_ACQ_TI ? ("CAE/CAR (Elec) : " + jsonData.Step2_traceIntr.CAE_S2_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.EnseigneHarmonica_S2_ACQ_TI ? ("Enseigne: " + jsonData.Step2_traceIntr.EnseigneHarmonica_S2_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.CodeEnseigne_ACQ_TI ? ("Code enseigne: " + jsonData.Step2_traceIntr.CodeEnseigne_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.CodeCampagne_S2_ACQ_TI ? ("Code campagne: " + jsonData.Step2_traceIntr.CodeCampagne_S2_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.pommard_Number_ACQ_TI ? ("N° Demande pommard: " + jsonData.Step2_traceIntr.pommard_Number_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.omega_Number_ACQ_TI ? ("N° Omega: " + jsonData.Step2_traceIntr.omega_Number_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.SGE_Number_ACQ_TI ? ("N° SGE : " + jsonData.Step2_traceIntr.SGE_Number_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.montantMensualisation_ACQ_TI ? ("Montant mensualisation : " + jsonData.Step2_traceIntr.montantMensualisation_ACQ_TI + " €<br>") : "") +
             (jsonData.Step2_traceIntr.OpsGaz_Number_ACQ_TI ? ("N° OPS gaz effectuée sur le portail : " + jsonData.Step2_traceIntr.OpsGaz_Number_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.indexGaz_ACQ_TI ? ("Index Gaz: " + jsonData.Step2_traceIntr.indexGaz_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.OpsElec_Number_ACQ_TI ? ("N° OPS elec effectuée sur le portail : " + jsonData.Step2_traceIntr.OpsElec_Number_ACQ_TI + "<br>") : "") +
             (jsonData.Step2_traceIntr.indexElec_ACQ_TI ? ("Index Elec: " + jsonData.Step2_traceIntr.indexElec_ACQ_TI + "<br>") : "");
 
         return formDetailString;
     };
     /**
      * Concaténation des champs remplis dans l'étape Formule d'escalade du Case dans le cas d'une <<Résiliation>>
      * afin de renseigner le champs "Formulaire" de l'intervention
      */
     getFormResiliationDetails(jsonData) {
         var formDetailString =
 
             (jsonData.Step3_traceIntr.motif_Resil_TI ? ("Motif résiliation : " + this.getSelectLabel('motifResiliation', jsonData.Step3_traceIntr.motif_Resil_TI) + "<br>") : "") +
             (jsonData.Step3_traceIntr.energieConcernee_Resil_TI ? ("Energie concernée : " + this.getSelectLabel('energieConcernee', jsonData.Step3_traceIntr.energieConcernee_Resil_TI) + "<br>") : "") +
             (jsonData.Step3_traceIntr.Date_Resil_TI ? ("Date de la résiliation : " + this.dateConvert(jsonData.Step3_traceIntr.Date_Resil_TI) + "<br>") : "") +
             (jsonData.Step3_traceIntr.Adresse_Resil_TI ? ("Adresse complète du lieu de consommation : " + jsonData.Step3_traceIntr.Adresse_Resil_TI + "<br>") : "") +
             (jsonData.Step3_traceIntr.N_PCE_Resil_TI ? ("N° PCE : " + jsonData.Step3_traceIntr.N_PCE_Resil_TI + "<br>") : "") +
             (jsonData.Step3_traceIntr.N_PDL_Resil_TI ? ("N° PDL : " + jsonData.Step3_traceIntr.N_PDL_Resil_TI + "<br>") : "") +
             (jsonData.Step3_traceIntr.N_OPS_MHS_Gaz_Resil_TI ? ("N° OPS MHS gaz effectuée sur le portail : " + jsonData.Step3_traceIntr.N_OPS_MHS_Gaz_Resil_TI + "<br>") : "") +
             (jsonData.Step3_traceIntr.N_OPS_MHS_Elec_Resil_TI ? ("N° OPS MHS élec effectuée sur le portail : " + jsonData.Step3_traceIntr.N_OPS_MHS_Elec_Resil_TI + "<br>") : "") +
             (jsonData.Step3_traceIntr.indexGaz_Resil_TI ? ("Index Gaz : " + jsonData.Step3_traceIntr.indexGaz_Resil_TI + "<br>") : "") +
             (jsonData.Step3_traceIntr.indexElec_Resil_TI ? ("Index Elec : " + jsonData.Step3_traceIntr.indexElec_Resil_TI + "<br>") : "") +
             (jsonData.Step3_traceIntr.Dispo_RDV_Dist1_Resil_TI ? ("Disponibilité client 1 pour RDV distributeur : " + jsonData.Step3_traceIntr.Dispo_RDV_Dist1_Resil_TI + "<br>") : "") +
             (jsonData.Step3_traceIntr.Dispo_RDV_Dist2_Resil_TI ? ("Disponibilité client 2 pour RDV distributeur : " + jsonData.Step3_traceIntr.Dispo_RDV_Dist2_Resil_TI + "<br>") : "");
 
         return formDetailString;
     };
     /**
      * Fonction de transcodification:
      * Récuperer les labels pour les champs de type Select  
      **/
     getSelectLabel(field, value) {
         var response;
         if (field == 'motifResiliation') {
             switch (value) {
                 case 'Demenagement':
                     response = 'Déménagement';
                     break;
                 case 'ArretUsageGaz':
                     response = 'Arrêt usage gaz';
                     break;
                 case 'Deces':
                     response = 'Décès';
                     break;
                 case 'SiteDetruit':
                     response = 'Site détruit';
                     break;
                 case 'Resil':
                     response = 'Résil. service suite à demande client';
                     break;
                 case 'Autre':
                     response = 'Autre cas';
                     break;
                 default:
                     response = '';
                     break;
             }
         } else if (field == 'energieConcernee') {
             switch (value) {
                 case 'Gaz':
                     response = 'Gaz';
                     break;
                 case 'Elec':
                     response = 'Élec';
                     break;
                 case 'Dual':
                     response = 'Gaz + Élec';
                     break;
                 default:
                     response = '';
                     break;
             }
         } else
             response = '';
         return response;
     }
 
 
     /**
      *  fonction permet la conversion d'une date vers le format suivant "dd/MM/yyyy"
      */
     dateConvert(mydate) {
         var dateToConvert = new Date(mydate);
         var dd = String(dateToConvert.getDate()).padStart(2, '0');
         var mm = String(dateToConvert.getMonth() + 1).padStart(2, '0');
         var yyyy = dateToConvert.getFullYear();
         return dd + '/' + mm + '/' + yyyy;
     }
 
 
 }