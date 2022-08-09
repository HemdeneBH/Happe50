/** 
 * @description       : Custom LWC for Omniscript. Handles the events triggered by clicking on the creation button to pass to the OS
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 02-23-2022 
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   02-23-2022   Patrick THAI     Initial Version (FT1-4738)
 */
import { api, LightningElement } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class SmOptionsOrderCreationHandler extends OmniscriptBaseMixin(LightningElement) {

    //@api options;                      //array with the options the options to be displayed
    @api optionsNodeName;              //name of the node in the JSON Data
    @api flexcardParentAttribute = {}; //the parent attribute to be passed down to the Flexcard
    parentAttribute              = {}; //the parent attribute that will be passed down to the Flexcard
    eventName = 'smOptionCpv';         //name of the custom event to be sent from the Child Flexcard

     ////////////////////////////////////////////////////////////////////////////////////////////
     // Getter/Setter for offers passed as an input of the LWC
     // 
     _options = [];
     @api get options() {
         return this._options;
     } 
     set options(value) {
         //clear dirty data
         value = JSON.parse(JSON.stringify(value)) || [] ;
         // actual set
         this._options = value;
         //trigger component validation
         this.omniValidate();
     }

    ////////////////////////////////////////////////////////////////////////////////////////////
    // Getter/Setter for the channel selected on the same step as the component
    // 
    _channel = '';
    @api get channel() {
        return this._channel;
    } 
    set channel(value) {
        //clear dirty data
        value = value || '' ;
        // actual set
        this._channel = value;
        // send the updated value to the flexcard
        this.parentAttribute.channel = value;
        this.parentAttribute         = JSON.parse(JSON.stringify(this.parentAttribute)); // force attribute refresh
    }
 
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Event handler for when an order creation is done
    // 
    handleCreateOrder(event) {
  
        //array passed down by OS is not an actual array, so we fix it first
       let _options    = JSON.parse(JSON.stringify(this.options));  
       let eventOption = JSON.parse(JSON.stringify(event.detail.option));
        //merge call result to 
        _options.forEach(o => {
            if(o.idOption && (o.idOption == eventOption.idOption)) {
                o.idPropositionCommerciale = eventOption.idPropositionCommerciale;
                o.creationRetCode          = eventOption.creationRetCode;
                o.creationRetMsg           = eventOption.creationRetMsg;
                o.orderId                  = eventOption.orderId;
            }
        });
        //update OmniScript JSON Data to JSON 
        this.updateJsonDataOptions(_options);
    }

    updateJsonDataOptions(options) {

        if(this.optionsNodeName) {
            //update nodes of the JSON Data if specified by the Custom LWC element inputs
            let resp = {};
            resp[this.optionsNodeName] = options;
            this.omniApplyCallResp(resp);
            //triggers parent and component reportValidity
        }
    }

    checkValidity() {
        let retVal = true;
        //component will not be valid if any option is selected but not created yet
        this._options.forEach(o => {
            retVal = (o.isSelected && (!o.idPropositionCommerciale || !o.orderId)) ? false : retVal;
        });
        this.omniUpdateDataJson({ "isValid" : retVal});
        return retVal;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Behavior methods
    //
    //

    connectedCallback() {

        // Register to event sent by the FlexCard
        // This will also catch events from another OS Element if the LWC is added to the same step
        this.addEventListener(this.eventName, this.handleCreateOrder.bind(this) );

        // Pass the energy type attribute to change the FlexCard display and the element name for it to be sent back as an info through event
        this.parentAttribute = {
            ...this.flexcardParentAttribute,
            "channel"   : this.channel,
            "eventName" : this.eventName
        }

        //init validation omniscriptBaseMixin validation flag
        this.omniValidate();
    }
}