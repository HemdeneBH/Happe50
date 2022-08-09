import { api, LightningElement, track, wire } from 'lwc';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import createOrderPaiementAPlusieurs from '@salesforce/apex/HP_EC_LoadCustomerData.createOrderPaiementAPlusieurs';
import ShareGroopScript from '@salesforce/resourceUrl/HP_ShareGroopWidget';

import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';


export default class Hp_ec_popinPaiementAPlusieurs extends LightningElement {
    iconClose = HP_EC_close_icon_light;
    @api titleText = 'Paiement à plusieurs';

    @api echeanceid;
    @api amount;

    context = this.template;
    @track initializedCaptain = false;
    @track initializedLink = false;    
    @track paymentResult;

    PUBLIC_KEY = 'pk_test_f5529da9-9467-4b41-bdc1-d0f622fa9c02';

    @track idClient;
    @track contact;

    get isLoading() {
        if((!this.initializedCaptain && !this.paymentResult) || (this.initializedCaptain && !this.initializedLink && this.paymentResult))
            return true;
        return false;
    }

    @wire(getContactData)
    wiredContact({ error, data }) {
        if (data) {
             this.contact = JSON.parse(data);
             this.idClient = this.contact.ID_Tiers__c;
        }else if(error){
            console.log('*** Error getContactData : '+JSON.stringify(error));
        }
    }

    async renderedCallback() {
        if (this.initializedCaptain) {
            return;
        }

        var that = this;
        const CreatedOrderResult = await this.createOrder(this.echeanceid,this.amount,this.contact.Email,this.contact.FirstName,this.contact.LastName);
        console.log('CreatedOrderResult : '+CreatedOrderResult);

        this.loadScript(ShareGroopScript).then(() => {
            window.sgWidgetCaptain = ShareGroop.initCaptain({
            "context": this.context,
            "selector": '.sharegroop-widget',
            "publicKey": this.PUBLIC_KEY,
            "orderId": JSON.parse(CreatedOrderResult).data.id,
            // "order": { // if no orderId, you can pass order data from front-end, demo purpose. Recommandation : create order from back-end and pass orderId.
            //     "amount": 20000
            // },
            "locale": "fr",    
            "events": {
                "onReady": function () {
                console.log('[captain] ready');
                that.initializedCaptain = true;
                },
                "onValidated": function (data) {
                console.log('[captain] validated', data);
                that.paymentResult = data;
                console.log('paymentResult : '+JSON.stringify(that.paymentResult));
                that.loadLink();
                }
            }
            }).mount();
        }).catch((error) => {
            console.log('Error loadScript :' +error);
        });
    }

    loadLink() {
        if (this.initializedLink || !this.paymentResult) {
            return;
        }    

        var that = this;
        window.sgWidgetLink = ShareGroop.initLink({
          "context": this.context,
          "selector": '.sharegroop-widget',
          "publicKey": this.PUBLIC_KEY,
          "orderId": this.paymentResult.order,
          "locale": "fr",    
          "events": {
            "onReady": function () {          
              that.initializedLink = true;
              console.log('[link] ready', this.initializedLink);
            }
          }
        });
    }

    get results() {
        return JSON.stringify(this.paymentResult, undefined, 2);
    }

    async createOrder(echeance_reference, montant_restant_du, email, prenom, nom) {
        return new Promise(async (resolve, reject) => {
            var result = await createOrderPaiementAPlusieurs({
                    echeance_reference : echeance_reference, 
                    montant_restant_du : montant_restant_du, 
                    email : email, 
                    prenom : prenom, 
                    nom : nom 
                })
                .then(response => {
                    return response;
                }).catch(error => {
                    console.log('***Error createOrderPaiementAPlusieurs : ' + JSON.stringify(error));
                    return error;
                });
            resolve(result);
        })
    }

    loadScript(url){
        return new Promise((resolve, reject) => {
            const script = document.createElement('script');
            script.src = url + '/sharegroopWidgetLwc-sandbox.js';
            script.charset = 'utf-8';
            script.type = 'text/javascript';
            document.head.appendChild(script);
            script.addEventListener('load', resolve);
            script.addEventListener('error', reject);
        });
    }

    closePopinPaiementAPlusieurs(event){
        this.dispatchEvent(new CustomEvent('closepopin', { detail: false}));
    }
    
}