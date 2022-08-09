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


import getContractDocumentsInfo from '@salesforce/apex/HP_EC_DocumentManager.getContractDocumentsInfo';
import getFactureAgilabData from '@salesforce/apex/HP_EC_LoadCustomerData.getFactureAgilabData';

import { filterDocumentBytype } from 'c/hp_ec_utils';


const MAX_FACTURE_SIZE = 15;
export default class Hp_ec_mesFactures extends LightningElement {

    @api title;

    @track documentInfos;
    @track facturesList = [];
    @track idPortefeuilleContrat;
    @track isLoading = false;

  
    factureExtraiteList = [];
    iconDownload = HP_EC_icon_download ;
    hasRenderedOnce = false;

    @wire(MessageContext) messageContext;
    
    @wire(getContractDocumentsInfo, {idPortfolio : '$idPortefeuilleContrat'})
    wiredFactures({data, error}){
        if(data){
             this.documentInfos = data; 
                
        }
        else if (error) {
            console.log('Erreur getContractDocumentsInfo : ', error);
            
        }
    }
   

    get showFactureComponent(){
        return (this.isLoading && this.factureExtraiteList)?true:false;
    }

    get showVoirplusBtn(){
        return this.facturesList.length > MAX_FACTURE_SIZE;
    }
   
    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }
    
    handleSubscription() {

        if (!this.subscription) {
            subscribeMC(this,this.messageContext, this.handleLightningMessage);
        }
    } 

    connectedCallback(){
        this.handleSubscription();
        this.idPortefeuilleContrat = getCurrentMessageValue('SelectedPortfolio');
        this.populateFactureData();
    }

    renderedCallback(){
        if(this.hasRenderedOnce){
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    handleLightningMessage(self,subscription, message) {
        if(message.messageType == 'SelectedPortfolio'){
            self.idPortefeuilleContrat = message.messageData.message;
            self.documentInfos = null;
            self.factureExtraiteList = [];
            self.facturesList = [];
            self.isLoading = false;
            self.populateFactureData();
        }  
    }

    async populateFactureData(){
          if(!this.documentInfos) {
              this.documentInfos = await this.getDocumentInfos();

          }
          if(this?.documentInfos){
               
                const result = await getFactureAgilabData({id_portefeuille_contrat_xdata : this.idPortefeuilleContrat})
                .then(result => {
                    let test = JSON.parse(result);
                    this.facturesList = this.prepareFactureData(test.output.factures);
                    this.facturesList[0].libelle ='Ma Dernière Facture';
                    this.extraireFactures();
                    
                })
                .catch( error => {
                    console.error('facture data error ', JSON.stringify(error));
                });
          }
        
    }


    async getDocumentInfos(){
        return new Promise( async (resolve, reject) => {
            var result = await getContractDocumentsInfo({idPortfolio : this.idPortefeuilleContrat})
            .then (response  => {
                  return response;
            })
            .catch (error  => {
                console.log('error getDocumentInfos ', error);
                return error;
            });
            resolve(result);

        })

    }

    groupeDocumentFacturesParReference(data){
      
        const  facturesData = filterDocumentBytype(data, 1);
        return facturesData.reduce( (acc, document) => {
           const key = document['reference_document'];
            
            if(!acc[key]){
                acc[key] = [];
            }

            acc[key].push(document);
            return acc;

        }, {} );
    }
    
    prepareFactureData(facturesAgilab){
        if(!facturesAgilab) return;
         const facturesMap = this.groupeDocumentFacturesParReference(this.documentInfos.output);
        return  facturesAgilab.filter( facture =>{
            return Object.keys(facturesMap).includes(facture.ref_facture);
        })
        .map(item  => {
                 return {
                     "reference": item.ref_facture,
                     "date": new Date(item.date_creation),
                     "libelle" : ` Ma Facture du ${item.date_creation}`,
                     'url' : facturesMap[item.ref_facture][0].url_document
                 };
        })
        .sort( (factureUne, factureDeux) => {
            return factureDeux.date - factureUne.date;
        });
    }

    extraireFactures(){
        if(!this.facturesList){
            return;
        }
    
        this.factureExtraiteList = this.facturesList.slice(0, MAX_FACTURE_SIZE);
        this.isLoading = true;
       
    }
}