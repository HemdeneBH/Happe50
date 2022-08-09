/** 
 * @description       : Batch class that triggers an update so that the urls using org ids are automatically fixed. This fixes the image display in a newly cloned environment
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 22-06-2021
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   22-06-2021   Patrick THAI     Initial Version
**/

public without sharing class COE_BAT004_OsFixImageUrl implements Database.Batchable<SObject>  {
    
    public String  originalOrgId;                                                                   // Org Id from which the url was cloned
    public Boolean updateNotes;                                                                     // if true the batch will add a comment to the internal notes
    public String internalNotes { get { return System.now().format('YYYY-MM-dd')  + ': BAT004'; }}  // format of the additional text to be added to the internal notes
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Constructors
    //    

    public COE_BAT004_OsFixImageUrl(String oi, Boolean ud) {
        this.originalOrgId = oi;
        this.updateNotes   = ud;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////
    // Batchable methods
    //
    public Iterable<SObject>start(Database.BatchableContext batchableContext){
        
        // Find the Elements referring to Image such as in the url "../servlet/servlet.ImageServer". T
        // The original intent was to use the org Id to fix, but SOSL won't find record based on an Id (probably because of the digits in the string text)
        // SOQL was not an option because vlocity_cmt__PropertySet__c is a long text area
        return (Iterable<SObject>) [ FIND 'ImageServer'
                                    RETURNING vlocity_cmt__Element__c (
                                        Id, Name, vlocity_cmt__PropertySet__c, vlocity_cmt__InternalNotes__c,
                                        vlocity_cmt__OmniScriptId__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__Type__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__SubType__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__Language__c, vlocity_cmt__OmniScriptVersion__c
                                        WHERE vlocity_cmt__OmniScriptId__r.vlocity_cmt__IsActive__c = false
                                        //AND vlocity_cmt__OmniScriptId__r.vlocity_cmt__Type__c = 'Contact'
                                        //AND vlocity_cmt__OmniScriptId__r.vlocity_cmt__SubType__c = 'MoveIn'
                                        //AND vlocity_cmt__OmniScriptVersion__c = 8
                                    )
                                ][0];
    }


    public void execute(Database.BatchableContext batchableContext, List<vlocity_cmt__Element__c > osElements ){
		List<vlocity_cmt__Element__c> osElementsToUpdate = new List<vlocity_cmt__Element__c>();

        System.debug('Number of batch elements : ' + osElements.size());
        for(vlocity_cmt__Element__c osEl : osElements) {
                
            // confirm the original Org Id is in the Property Set field
            if(osEl.vlocity_cmt__PropertySet__c.contains(this.originalOrgId)) {
                System.debug(osEl.Name + ' in ' + (new foundOsWrapper(osEl)).fullName() + ' v' + osEl.vlocity_cmt__OmniScriptVersion__c);
                //Add a comment in the internal notes fields if the batch was set for it
                if(this.updateNotes)
                    osEl.vlocity_cmt__InternalNotes__c = (osEl.vlocity_cmt__InternalNotes__c == null ? '' : osEl.vlocity_cmt__InternalNotes__c + '\n') + this.internalNotes;
                //add the element to trigger an update. The org Id will be automatically fixed in the property set (probably thanks to some trigger in the managed package)
                osElementsToUpdate.add(osEl); 
            }
        }

        //update elements with updated JSON Property Map
        if(!osElementsToUpdate.isEmpty()) {
            System.debug('Updating ' + osElementsToUpdate.size() +  ' elements');
            update osElementsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {

    }

    ////////////////////////////////////////////////////////////////////////////////////////////
    // Additional utilities to help developer to prepare the batch
    //
    //

    //////////////////////////////////////////////////////////////////////////////////////////// 
    // @author Patrick THAI
    // @date 11-06-2020
    // @description Wrapper class to store an OS and the detected elements in one Map
    public class foundOsWrapper {

        public vlocity_cmt__OmniScript__c os;           //instance of the found OmniScript
        public vlocity_cmt__Element__c[] foundReason;   //list of OS element for which the OS has been detected
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        // Constructor 
        // @param e OmniScript element for which fields from the parent OS are retrieved
        public foundOsWrapper(vlocity_cmt__Element__c e) {

            this.os = new vlocity_cmt__OmniScript__c(
                Id                       = e.vlocity_cmt__OmniScriptId__c,
                vlocity_cmt__Type__c     = e.vlocity_cmt__OmniScriptId__r.vlocity_cmt__Type__c,
                vlocity_cmt__SubType__c  = e.vlocity_cmt__OmniScriptId__r.vlocity_cmt__SubType__c,
                vlocity_cmt__Language__c = e.vlocity_cmt__OmniScriptId__r.vlocity_cmt__Language__c,
                vlocity_cmt__Version__c  = e.vlocity_cmt__OmniScriptVersion__c
            );
            foundReason = new List<vlocity_cmt__Element__c>(); // did not initiate the list with the element passed as a parameter for easier looping in searchInActiveOS()
        }

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Populate this.foundReason with a new element 
        // @param e OmniScript element 
        public void addFoundReason(vlocity_cmt__Element__c e) {
            this.foundReason.add(e);
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        // Formatted unique name of the OmniScript based on Type, SubType and Language. 
        // To display in the debug logs
        public String fullName() {
            return   this.os.vlocity_cmt__Type__c    + '/'
                   + this.os.vlocity_cmt__SubType__c + ' ('
                   + this.os.vlocity_cmt__Language__c + ')';
        }
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        // Formatted text for this.foundReason
        // To display in the debug logs       
        public String elementNames() {
            String retString = '';
            String separator = ', ';
            for(vlocity_cmt__Element__c e : this.foundReason)
                retString += e.Name + separator;
            retString = retString.removeEnd(separator);
            return retString;
        }
    }


    //////////////////////////////////////////////////////////////////////////////////////////// 
    // @author Patrick THAI
    // @date 2020-12-08
    // @description Utility method that searches "ImageServer" and returns the OS elements of active 
    //              OmniScripts, as they will be skipped by the batch class because they are Read-Only
    // @param properties Set of keys for which the values are copied
    // @param sourcePropSet Map from which the values are copied
    // @param targetRecord Salesforce record where the values are copied
    public Map<String, COE_BAT004_OsFixImageUrl.foundOsWrapper> searchInActiveOS() {
        
        //find the search text with OS elements only in active elements 
        sObject[][] searchRes = [  FIND 'ImageServer'
                                    RETURNING vlocity_cmt__Element__c (
                                        Id, Name, vlocity_cmt__Active__c, vlocity_cmt__Type__c, vlocity_cmt__Order__c, vlocity_cmt__PropertySet__c,
                                        vlocity_cmt__OmniScriptId__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__Type__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__SubType__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__Language__c, vlocity_cmt__OmniScriptVersion__c
                                        WHERE vlocity_cmt__OmniScriptId__r.vlocity_cmt__IsActive__c = true
                                        ORDER BY vlocity_cmt__OmniScriptId__r.vlocity_cmt__Type__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__SubType__c, vlocity_cmt__OmniScriptVersion__c, vlocity_cmt__Order__c
                                    )
                                ];

        //process the results
        Map<String, COE_BAT004_OsFixImageUrl.foundOsWrapper> foundOsMap = new Map<String, COE_BAT004_OsFixImageUrl.foundOsWrapper>();
        if(searchRes[0].isEmpty()) {
            System.debug('No active omniscript found');
        } else {
            for(vlocity_cmt__Element__c osEl : (List<vlocity_cmt__Element__c>) searchRes[0]) {
                
                // confirm the search text is in the Property set field
                if(osEl.vlocity_cmt__PropertySet__c.contains(this.originalOrgId)) {
                    foundOsWrapper foundOS = new foundOsWrapper(osEl);
                    String osKey = foundOS.fullName();
                    //System.debug(' Found for OS ' + osKey + ' : ' + osEl.Name + ' ('+ osEl.vlocity_cmt__Type__c + ')');
                    //initiate foundOS in Map (not optimized, but easier for class testing)
                    if(!foundOsMap.containsKey(osKey))
                        foundOS = foundOsMap.put(osKey, foundOS);
                    foundOS = foundOsMap.get(osKey);
                    //add found element to map
                    foundOS.addFoundReason(osEl);
                    foundOsMap.put(osKey, foundOS);
                }
            }
        }

        if(!foundOsMap.isEmpty()) {
            System.debug('**** Search and replace won\'t work for active versions of the following OmniScripts. Please disable them first or create a new version.');
            for(COE_BAT004_OsFixImageUrl.foundOsWrapper w : foundOsMap.values()){
                //System.debug( w.fullName());
                System.debug( w.fullName() + ' v' + Math.round(w.os.vlocity_cmt__Version__c) + ' - ' + String.valueOf(w.elementNames()));
            }
        }

        return foundOsMap;

    }
}