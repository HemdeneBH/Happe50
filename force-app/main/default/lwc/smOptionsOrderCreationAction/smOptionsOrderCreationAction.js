/** 
 * @description       : Custom LWC for FlexCard. Adds a button on the flexcard to the triggers order/cpv creation on SAP side. Designed for a single Option to be selected and created
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 03-01-2022 
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-01-2022   Patrick THAI     Initial Version (FT1-4738 + FT1-4740)
 */
 import { api, LightningElement } from 'lwc';
 import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin'; // to access methods such as this.omniRemoteCall (note: not all variables/methods will be passed like this.omniJsonData)
 
 export default class SmOptionsOrderCreationAction extends OmniscriptBaseMixin(LightningElement) {
 
     // messaging configuration (copied from omniscriptMessaging) 
     messageConfigs = {
         slds: {
             Success: {
                 iconName: "utility:success",
                 iconVariant: "success",
                 wrapperClassDynamic: "slds-scoped-notification--success"
             },
             Comment: {
                 iconName: "utility:comments",
                 iconVariant: "default"
             },
             Warning: {
                 iconName: "utility:warning",
                 iconVariant: "warning",
                 wrapperClassDynamic: "slds-scoped-notification--warning"
             },
             Requirement: {
                 iconName: "utility:error",
                 iconVariant: "error",
                 ariaRole: "alert",
                 wrapperClassDynamic: "slds-scoped-notification--error"
             },
             empty: {
                 iconName: null,
                 iconVariant: null
             }
         },
         nds: {
             Success: {
                 iconName: "utility:check",
                 iconVariant: "success"
             },
             Comment: {
                 iconName: "utility:chat",
                 iconVariant: "default"
             },
             Warning: {
                 iconName: "utility:warning",
                 iconVariant: "warning"
             },
             Requirement: {
                 iconName: "utility:close",
                 iconVariant: "error",
                 textClass: "nds-text-color--error",
                 ariaRole: "alert",
                 wrapperClassDynamic: "nds-scoped-notification--error"
             },
             empty: {
                 iconName: null,
                 iconVariant: null
             }
         }
     }
     
     //public vars
     @api option       =  {};
     @api theme        = 'slds';
     @api label        = 'no label passed';
     @api ipName       = 'pass_an_ip_name_as_a_parameter';

     //publics vars to be passed from the Flexcard
     @api idCompteClient;
     @api idBpConseiller;
     @api idBpClient;
     @api idLocal;
     @api channel;
     @api accountId;
     @api caseId;
     @api orderStatus;
     @api contractInfo = {};

     //private vars
     buttonClass   = '';
     ariaRole      = 'status';
     eventName     = 'smOptionCpv';      // event to be listened by the parent FlexCard
     debug         = '';
     isPageLoading = false;
 
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Getter/Setter for offers passed as an input of the LWC
    // 
    get messagingIcon()    { return this.messageConfigs[this.theme][this.status].iconName;    }
    get messagingVariant() { return this.messageConfigs[this.theme][this.status].iconVariant; }
    get messagingClass()   { return `slds-scoped-notification slds-scoped-notification_form slds-media slds-media_center slds-scoped-notification_light ${this.messageConfigs[this.theme][this.status].wrapperClassDynamic}`; }
    get isRefused()        { return this.option.isSelected === false || this.option.isSelected === 'false' || this.option.isSelected === undefined || false; }
    get isCpvCreated()     { return (this.option.idPropositionCommerciale !=  null && this.option.idPropositionCommerciale != undefined) || false; }
    get isOrderCreated()   { return (this.option.orderId != null && this.option.orderId !== undefined) || false; }
    get status()           { return (this.isCpvCreated || this.isRefused) && this.isOrderCreated ? 'Success' : 'Requirement'; }
    get messageText()      { return this.option.creationRetMsg || '' }
    get showMessage()      { return this.messageText != ''; }


    ////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Logic when user clicks on the button 
    //
    execute() {

         //set inputs for 
         let inputMap = {
             "option"         : {
                 ...this.option
             },
             "idCompteClient"    : this.idCompteClient,
             "idBpConseiller"    : this.idBpConseiller,
             "idBpClient"        : this.idBpClient,
             "idLocal"           : this.idLocal,
             "channel"           : this.channel,
             "accountId"         : this.accountId,
             "caseId"            : this.caseId,
             "orderStatus"       : this.orderStatus,
             "contractInfo"      : JSON.parse(JSON.stringify(this.contractInfo))
             //"doSuccess"      : this.option.doSuccess  === true || this.option.doSuccess === 'true' || false,
             //"pipoCommercial" : Math.round(Math.random()*1000000000) //"7035246197"
         };
         let ipParams = {
             sClassName  : 'vlocity_cmt.IntegrationProcedureService',
             sMethodName : this.ipName,
             input       : JSON.stringify(inputMap),
             options     : '{}'
          };
         
         //show spinner
         this.isPageLoading = true;
         //call IP
         this.omniRemoteCall(ipParams, true)
             .then((resp => {
 
                 //hide spinner
                 this.isPageLoading = false;
 
                 //shortcut for result data
                 let res = Array.isArray(resp.result.IPResult) ? resp.result.IPResult[0] : resp.result.IPResult;
 
                 //inform the handler about the result of the callout
                this.sendOptionToHandler(
                    res.codeRetourPropositionCommerciale == 'OCTOPUS_creerPropositionCommerciale_01',
                    res
                 );
             }).bind(this))
             .catch((error => {
                 //hide spinner
                 this.isPageLoading = false;
                 //inform the handler about an error during the callout
                 this.sendOptionToHandler(
                     false,
                     true
                  );
             }).bind(this));
     }

    ////////////////////////////////////////////////////////////////////////////////////////////
    // Helper method to send an event the OS based on the IP response
    // @param isCreated true if the WS called in the IP created a CPV in SAP
    // @param result JSON Data returned by the IP
    sendOptionToHandler(isCreated, result) {
        
        // retrieve the handler
        let optionCopy = JSON.parse(JSON.stringify(this.option));
        optionCopy.orderId                                = result.orderId;
        optionCopy.creationRetCode                        = result.codeRetourPropositionCommerciale;
        optionCopy.creationRetMsg                         = (result.messageRetourPropositionCommerciale ? result.messageRetourPropositionCommerciale : result.error);
        if(isCreated) optionCopy.idPropositionCommerciale = result.idPropositionCommerciale;
        
        //inform the handler about the result of the callout
        let eventDetail = { 
            "option" : optionCopy
        };
        
        this.dispatchEvent(new CustomEvent(
            this.eventName, 
            { 
                bubbles  : true, 
                composed : true, 
                detail   : eventDetail 
            }
        ));
    }

    ////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Behavior methods
    //
    //
    connectedCallback() {
        this.isPageLoading = false;
        this.buttonClass   = (this.label ? '' : ' ' + this.theme + '-box');
    }

    isValid() {
       return this.status == 'Sucess';
    }
 }