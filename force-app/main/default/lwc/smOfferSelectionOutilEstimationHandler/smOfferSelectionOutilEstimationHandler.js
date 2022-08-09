/** 
 * @description       : Custom LWC for OmniScript. Filters the product passed as input and handles user selection (Outil Estimation)
 * @author            : Riadh DALLEL
 * @group             : 
 * @last modified on  : 12-16-2021
 * @last modified by  : Riadh DALLEL
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   09-28-2021   Riadh DALLEL     Initial Version
 */

 import { LightningElement, api } from 'lwc';
 import pubsub from 'vlocity_cmt/pubsub';
 import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
 
 export default class smOfferSelectionOutilEstimationHandler extends OmniscriptBaseMixin(LightningElement) {
   
     ////////////////////////////////////////////////////////////////////////////////////////////
     ////////////////////////////////////////////////////////////////////////////////////////////
     // Simple constructor variables
     //
     // 
     isConnected = false;                   //to be set to true in connectedCallback. Needed in this.showOffer because LWC the function is called in an setter that is called for the first time when @api parameters are not all defined
     parentAttribute = {};                  //init of the Parent object of the FlexCard
     separatedSelection = false;            //if true, events sent by another element custom element using the same LWC will be ignored
     nodesToClear = [
        'mapConsoGazByTypeComptage:consoGazTTC',
        'mapConsoGazByTypeComptage:consoGazHT',
        'aboGazTTC',
        'aboGazHT',
        'mensGazDisplay',
        'mensElecDisplay',
        'aboElecTTC',
        'aboElecHT',
        'mensTotalDisplay',
        'mapConsoByTypeComptage:S_TTC',
        'mapConsoByTypeComptage:S_HT',
        'mapConsoByTypeComptage:HP_TTC',
        'mapConsoByTypeComptage:HP_HT',
        'mapConsoByTypeComptage:HC_TTC',
        'mapConsoByTypeComptage:HC_HT',
        'mapConsoByTypeComptage:WE_TTC',
        'mapConsoByTypeComptage:WE_HT',
        'mapConsoByTypeComptage:hasTradeOffAcheminement',
        'mapConsoByTypeComptage:hasTradeOffFourniture',
        "Id",
        "isSelected",
        "uniqueKey",
        "_flex"
    ];   
     @api energyType = 'gaz';                   //'gaz', 'elec' or 'Duo' to be passed to the FlexCards for display changes
     @api nodeToUpdateForEmail;                     // node of the JSON Data where the selected offer will be sent
     @api nodeToUpdateForDisplay;                     // node of the JSON Data where the selected offer will be sent
     @api filterSuggestedOffers = false;    // displays the suggested offer if true, excludes the suggested offers if false
     @api context;                          //'harmonica' 
 
     ////////////////////////////////////////////////////////////////////////////////////////////
     // Getter/Setter for offers passed as an input of the LWC
     // 
     _offers = [];
     @api get offers() {
         return this._offers;
     } 
     set offers(value) {
         //clear dirty data
         value = JSON.parse(JSON.stringify(value)) || [] ;
         if(this.isConnected)
            value = value.filter(this.showOffer, this);
        if(value.length > 0)
        {
         // actual set
         this._offers = value;
         //clear selected offer in JSON Data on input refresh
         var isAllUndefined = value.filter(o => {
             return typeof o.isSelected == 'undefined';
         });
         if(isAllUndefined.length == value.length)
             this.sendSelectedToJsonData();
        }
     }
 
     ////////////////////////////////////////////////////////////////////////////////////////////
     ////////////////////////////////////////////////////////////////////////////////////////////
     // Check whether an offer is an "Offre Poussee"
     // Calls LWC input context
     // Called by showOffer()
     // @param offer JSON object representing an offer
     // 
     isSuggested(offer) {
         return    (this.context != 'harmonica' && (offer.isOffrePoussee || offer.isOffreRepli))
                || (this.context == 'harmonica' &&  offer.isOffrePousseeHarmonica);
     }
 
     ////////////////////////////////////////////////////////////////////////////////////////////
     // Check whether an offer is an "Offre Poussee"
     // Calls LWC input filterSuggestedOffers
     // Called by connectedCallback() and  offers setter
     // @param offer JSON object representing an offer
     // 
     showOffer(offer) {
         let bFilterSuggestedOffers = (this.filterSuggestedOffers === 'true') || (this.filterSuggestedOffers === true);
         return (offer != null && this.isSuggested(offer) == bFilterSuggestedOffers);
     }
 
     ////////////////////////////////////////////////////////////////////////////////////////////
     // Updates the JSON Data on the node of the Custom LWC element or a specified node
     // Calls LWC input this.nodeToUpdate
     // Called by handleSelectOffer()
     // @param offer JSON object representing an offer
     // 
     sendSelectedToJsonData(offer) {

        //make a copy of the and remove the nodes that were only added for display
        let clearedOffer = JSON.parse(JSON.stringify(offer || {}));
        this.nodesToClear.forEach(node => {
            let splittedNode = node.split(':');
            if(splittedNode.length > 1 && clearedOffer[splittedNode[0]])
                 delete clearedOffer[splittedNode[0]][splittedNode[1]];
            else 
                delete clearedOffer[node];
       });

         if(this.nodeToUpdateForEmail && this.nodeToUpdateForDisplay) {
             //update nodes of the JSON Data if specified by the Custom LWC element inputs
             let resp = {};
             resp[this.nodeToUpdateForEmail]   = clearedOffer;
             resp[this.nodeToUpdateForDisplay] = offer;
             this.omniApplyCallResp(resp);
         } else {
             //by default, update the nodes of the Custom LWC element
             this.omniUpdateDataJson({ 
                "selectedOffer"    : clearedOffer,
                "selectedRawOffer" : offer 
            });
         }
     }
 
     ////////////////////////////////////////////////////////////////////////////////////////////
     // Handler of the event sent by the child FlexCard when the user clicks on an offer
     // @param data data passed from a pubsub event
     //
     handleSelectOffer(data) {
         var selected = data.offer;
         //make sure which component triggered the event
         if(!this.separatedSelection || data.nodeName == this.omniJsonDef.name) {
             //array passed down by OS is not an actual array, so we fix it first
             this.offers = JSON.parse(JSON.stringify(this.offers));  
             //select offer locally
             this.offers.forEach(o => {
                 o.isSelected = (o.codeOffre && (o.codeOffre == selected.codeOffre));
             });
             //send selected offer to JSON 
             this.sendSelectedToJsonData(selected);
         }
     }
 
     ////////////////////////////////////////////////////////////////////////////////////////////
     // Set a default selected offer or restores selected offer when navigating 
     //   back and forth to this step
     //
     initSelectedOffer() {
 
         //check if an offer has already been selected in the JSON Data
         let nodeToRetrieve = (this.nodeToUpdate ? this.nodeToUpdate : `${this.omniJsonDef.name}:selectedOffer`);
         let retrieved = this.omniGetMergeField( `%${nodeToRetrieve}%`);
         
         //check for the retrieved offer among the list of the filtered offers (result can be null) or the Offre Poussee
         let selected;
         if(retrieved) {
             retrieved = JSON.parse(retrieved);
             selected = this._offers.find(o => o.codeOffre == retrieved.codeOffre);
         } else
             selected = this._offers.find(o => o.isOffrePoussee);
 
         //if we found an offer to select, trigger the selection handler with this offer
         if(selected) {
             let data = {
                 "offer" : selected,
                 "nodeName" : this.omniJsonDef.name
             }
             this.handleSelectOffer(data);
         }
 
     }
 
     ////////////////////////////////////////////////////////////////////////////////////////////
     ////////////////////////////////////////////////////////////////////////////////////////////
     // Behavior methods
     //
     //
 
     connectedCallback() {
         
         //filter the input offers on suggested offers or other offers based on this.filterSuggestedOffers parameter
         this.isConnected = true;

         if(this._offers.length > 0){
            this._offers = this._offers.filter(this.showOffer, this);
            this.initSelectedOffer();
         }
         
         // Register to event sent by the FlexCard
         // This will also catch events from another OS Element if the LWC is added to the same step
         pubsub.register('smOffer', {
             select: this.handleSelectOffer.bind(this)
         });
 
         // Pass the energy type attribute to change the FlexCard display and the element name for it to be sent back as an info through event
         
        this.parentAttribute = {
            "energyType" : this.energyType,
            "nodeName" : this.omniJsonDef.name
        }
         
     }
 }