/**
 * @description       : 
 * @author            : Madicke BALDE
 * @group             : 
 * @last modified on  : 07-11-2022
 * @last modified by  : Hemdene Ben Hammouda
**/

import { api, LightningElement, track, wire } from 'lwc';
import HP_EC_icon_download from '@salesforce/resourceUrl/HP_EC_icon_download';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

import { publishMC, subscribeMC, unsubscribeMC, getCurrentMessageValue } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';


import getContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getContractData';
import getContractDocumentsInfo from '@salesforce/apex/HP_EC_DocumentManager.getContractDocumentsInfo';
import getEcheanceContractData from '@salesforce/apex/HP_EC_LoadCustomerData.getEcheanceContractData';
import getPlansApurement from '@salesforce/apex/HP_EC_LoadCustomerData.getPlansApurement';
import { filterDocumentBytype, groupingArrayObjectByProperty } from 'c/hp_ec_utils';

const MAX_ECHEANCES_SIZE = 15;
export default class Hp_ec_mesEcheances extends LightningElement {
    
    @api title;

    @track documentInfos;
    @track idPortefeuilleContrat;
    @track isLoading = false;
    echeancesList = [];
    iconDownload = HP_EC_icon_download ;
    hasRenderedOnce = false;
    @wire(MessageContext) messageContext;
    libelle = "Mon échéance";
    libellePlanApurement = "Mon plan d'apurement";
    planApurementList = [];
    echancesPlanApurementsList = [];
    echeancePlanExtraiteList = [];

    @wire(getContractDocumentsInfo, {idPortfolio : '$idPortefeuilleContrat'})
    wiredFactures({data, error}){
        if(data){
             this.documentInfos = data; 
        }
        else if (error) {
            console.log('Erreur getContractDocumentsInfo : ', error);
        }
    }
    
    get showEchancierComponent(){
        return this.isLoading && this.echeancePlanExtraiteList.length > 0;
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this,this.messageContext, this.handleLightningMessage);
        }
    } 

    handleLightningMessage(self,subscription, message) {
        if(message.messageType == 'SelectedPortfolio'){
            self.idPortefeuilleContrat = message.messageData.message;
            self.documentInfos = null;
            self.planApurementList = [];
            self.echancesPlanApurementsList = [];
            self.echeancesList = [];
            self.isLoading = false;
            self.populateEcheance();
        }  
    }

    connectedCallback(){
        this.handleSubscription();
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.populateEcheance();
    }

    renderedCallback(){
        if(this.hasRenderedOnce){
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }


    async populateEcheance(){
        if(!this.documentInfos) {
            this.documentInfos = await this.getDocumentInfos();
        }
        if(this?.documentInfos){
               const result = await getPlansApurement({idPorteFueilleContrat: this.idPortefeuilleContrat});
               let documents = this.recuperationDocTypeEcheancePlApurement(this.documentInfos);
               let planList = [];
               documents.forEach(documentType  => {
                 planList = [... documentType.plans];
               });
               this.planApurementList = [...this.mapperLesPlanApurance(planList, JSON.parse(result))];
               const contractDataResult = await this.getContractData();
             
               const resultEcheance =  this.fetchEcheance(documents);
               this.prepareEcheanceData(resultEcheance, JSON.parse( contractDataResult ));
               this.echancesPlanApurementsList = [...this.planApurementList, ...this.echeancesList]
               this.extraireFactures();
    
        }
    }

    async  getDocumentInfos(){
        return new Promise( async (resolve, reject) => {
            var result = await getContractDocumentsInfo({idPortfolio : this.idPortefeuilleContrat})
            .then ( response => {
                return response;
            })
            .catch( error => {
                console.log(error);
                return error;
            });
            resolve(result);
        } )
    }
  
    

    fetchEcheance(documents){
        let echeanceDocument = {};
        documents.forEach ( document =>  {
            if(document.echeances.length > 0){
                let echeanceSortedByIdDocumentAgilab = document.echeances.sort((echeanceUne, echeanceDeux) => {
                    echeanceDeux.id_document_agilab - echeanceUne.id_document_agilab; 
                })
                echeanceDocument[document.id_contrat_xdata] = echeanceSortedByIdDocumentAgilab;
            }
        }) 
      
        return echeanceDocument;

    }
    
    prepareEcheanceData(documentEcheanceObj, contractData){

        if(Object.keys(documentEcheanceObj).length == 0 || contractData._data.length == 0 ) return;
        contractData._data.forEach(item => {
            if(Object.keys(documentEcheanceObj).includes(item.id.toString())){
                   documentEcheanceObj[item.id.toString()].forEach(eachEacheance => {
                    let energie = `Échéancier - ${item.energie} n° ${ eachEacheance.id_document_agilab}`; 
                   this.echeancesList.push({...eachEacheance, reference: eachEacheance.id_document_agilab, libelle :`${energie.substring(0,20)}...`});
                })
            }
        })
    }
    
    recuperationDocTypeEcheancePlApurement(documentInfos){
            return documentInfos.output.map( item => {
                    let echeances = this.filtrerData(item.documents, 2);
                    let planApurements = this.filtrerData(item.documents, 3);
                    return {
                            "id_contrat_xdata" : item.id_contrat_xdata,
                            "echeances" : echeances,
                            "plans" : planApurements
                    }
            })

    }

    filtrerData(documents, type){
        return documents.filter( document => document.type_document == type  )
    }

 
   
  

    mapperLesPlanApurance(documentTypePlanApurement, planApurents){
        if (    documentTypePlanApurement.length == 0 ||
                planApurents.output.plans_apurement == undefined
                || planApurents.output.plans_apurement.length == 0
        ) return [];
        const planApurGrouperParIdPlanMap = groupingArrayObjectByProperty(documentTypePlanApurement,'reference_document');
        return planApurents.output.plans_apurement
        .filter( plan => {
                return Object.keys(planApurGrouperParIdPlanMap)
                .includes (
                    plan.id_plan_apurement
                    .toString() 
                );
        })
        .map (plan => {
                return {
                    ...plan,
                    type_document : 3,
                    reference : plan.id_plan_apurement,
                    date_creation : new Date(plan.date_creation),
                    libelle : `${this.libellePlanApurement.substring(0,15)}...`,
                    url_document : planApurGrouperParIdPlanMap[plan.id_plan_apurement][0]
                    .url_document 
                };
        })
        .sort((plan1, plan2) => {
            plan2.date_creation - plan1.date_creation;
     } );
    }

    async getContractData() {
        return new Promise(async (resolve, reject) => {
            var result = await getContractData()
                .then(data => {
                    return data;
                })
                .catch(error => {
                    console.log('error contract data: ' + JSON.stringify(error));
                });
            resolve(result);
        })
    }

    extraireFactures(){
        if(!this.echancesPlanApurementsList){
            return;
        }
    
        this.echeancePlanExtraiteList = this.echancesPlanApurementsList.slice(0, MAX_ECHEANCES_SIZE);
        this.isLoading = true;
       
    }
 
}