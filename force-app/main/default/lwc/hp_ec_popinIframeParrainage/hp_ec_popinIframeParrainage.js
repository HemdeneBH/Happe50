/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-10-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track,wire } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';
import { loadScript } from 'lightning/platformResourceLoader';
import getContactData from '@salesforce/apex/HP_EC_LoadCustomerData.getContactData';
import getSecretKey from '@salesforce/apex/HP_UTIL_MetadataManager.getConfigByKey';
import getSha256 from '@salesforce/apex/HP_EC_UTIL_CryptoUtils.getSha256';
import BuyapowaScriptParrainage from '@salesforce/resourceUrl/HP_BuyapowaParrainage';
import getBuyapowaIframe from '@salesforce/apex/HP_SM069_SharingLinkController.getBuyapowaIframe';



const HP_buyapowaSecretKey ="HP_buyapowaSecretKey";
// var buyapowa = new Buyapowa("https://happ-e.co-buying.com", "bp_div", "bp_error");
// buyapowa.embedReferAFriend({parameterMap});


export default class Hp_ec_popinIframeParrainage extends LightningElement {
    
    @api titleText;

    // @track buyapowa;
    @track contact;
    @track keyBeforeHash;
    @track idClient;
    @track name;
    @track optInMarketing;
    @track email;
    @track secretkey;
    @track OptInMarketing;
    @track signatureHashed;
    @track signature;
    @track parameter=null;
    @track buyapowaIframeLink;
    @track error;

    @wire (getContactData) 
    wiredContact({ error, data }) {
        if (data) {
            console.log('wired contact : '+JSON.stringify(data));
            this.contact = JSON.parse(data);
            console.log('Id Tiers : '+ this.contact.ID_Tiers__c);
            getBuyapowaIframe({idTiers : this.contact.ID_Tiers__c}).then(response => {
                console.log('my Response : '+response);
                this.buyapowaIframeLink = response;
            }).catch(error => {
                console.log('Erreur '+JSON.stringify(error));
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contact = undefined;
        }
    }

    async getData (){
        this.parameters={'campaign': 'happe_raf1','auto': true,'signed_keys': 'name, email'};
        await getContactData()
            .then (data=> {
                this.contact = JSON.parse(data);
                console.log('data: ' + this.contact);

                this.email = this.contact.Email;
                this.parameters['email']=this.email;
                console.log('email: ' + this.email);
     
                this.name =this.contact.Name;
                this.parameters['name']= this.name;
                console.log('Name: ' + this.name);
     
                this.optInMarketing = this.contact.HP_OptinMarketing__c;
                this.parameters['marketing_opt_in']=this.optInMarketing;
                console.log('optInMarketing: ' + this.optInMarketing);
                console.log('getContactData parameters: ' + JSON.stringify(this.parameters));

            }).catch(error=>{
                console.log('getContactdata error=> : '+ JSON.stringify(error));
            });

        await getSecretKey({key:HP_buyapowaSecretKey})
                            .then(data=>{
                                this.secretkey = data;
                                console.log('getSecretkey: ' + this.secretkey);

                            })
                            .catch(error => {
                                console.log('error getSecretkey: ' + error);
                            });

        this.keyBeforeHash ={'email':this.email,'name':this.name,'secret':this.secretkey};
        console.log('keyBeforeHash: ' + JSON.stringify(this.keyBeforeHash));
        await getSha256({ input: JSON.stringify(this.keyBeforeHash) })
                            .then(data => {
                                if (data) {
                                    this.signatureHashed = data;
                                    console.log('signatureHashed: ' + this.signatureHashed);

                                }
                                })
                            .catch(error => {
                                this.signatureHashed = null;
                                console.log('Error getSha256(): ' + JSON.stringify(error));
                            });
        this.parameters['signature']=this.signatureHashed;
        return this.parameters;
    };

    async callBuyapowa(){
        if(this.parameters==null){
            console.log('parameters before getdata: ' + JSON.stringify(this.parameters));
            this.parameters = await this.getData();
            console.log('parameters after getdata: ' + JSON.stringify(this.parameters));

        }
        if(this?.parameters!=null){
            console.log('parameters inside callBuyapowa: ' + JSON.stringify(this.parameters));
            var buyapowa = new Buyapowa("https://happ-e.co-buying.com", "bp_div", "bp_error");
            buyapowa.embedReferAFriend(this.parameters);
        }
        console.log('parameters inside callBuyapowa: ' + JSON.stringify(this.parameters));
        var buyapowa = new Buyapowa("https://happ-e.co-buying.com", "bp_div", "bp_error");
        buyapowa.embedReferAFriend(this.parameters);
    }

    renderedCallback() {
        // this.getContactInfo();
        // console.log('parameters before loadScript: ' + JSON.stringify(this.parameters));
        // loadScript(this, BuyapowaScriptParrainage + '/popinIframeParrainage.js')
        //     .then(() => {
        //         this.callBuyapowa();
        //         // this.getData();
        //         // console.log('parameters inside callBuyapowa: ' + JSON.stringify(this.parameters));
        //         // var buyapowa = new Buyapowa("https://happ-e.co-buying.com", "bp_div", "bp_error");
	    //         // buyapowa.embedReferAFriend(this.parameters);
        //         // this.buyapowa.embedReferAFriend(this.getData());
                
        //     })
        //     .catch(error => {
        //         console.log('laod BuyapowaScriptParrainage error' + error);
        //     });
        
    }

    closePopin(event){
        this.dispatchEvent(new CustomEvent('closepopiniframeparrainage', { detail: true}));
    }
}