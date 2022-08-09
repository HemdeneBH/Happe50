/** 
 * @description       : Batch class that copies JSON properties of an OS/IP to a report object
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 12-08-2020
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-02-2020   Patrick THAI     Initial Version
**/

public without sharing  class COE_BAT001_OSJson2Fields implements Database.Batchable<SObject>  {
    
    private final String sfiNS = 'vlocity_cmt';
    private final Set<String> osCopiedFieldNames  = new Set<String> { 'Type__c', 'SubType__c'};
    private final Set<String> osCopiedProperties  = new Set<String> {};
    private final Set<String> osCheckedProperties = new Set<String> {'elementTypeToHTMLTemplateMapping', 'elementTypeToLwcTemplateMapping'};
    private final Set<String> elCopiedProperties  = new Set<String> {'sendJSONPath', 'lwcComponentOverride', 'HTMLTemplateId', 'invokeMode'};
    private final Set<String> elCheckedProperties = new Set<String> {'extraPayload'};

        
    public Database.QueryLocator start(Database.BatchableContext batchableContext){
        return DataBase.getQueryLocator([SELECT Id, Name,vlocity_cmt__Type__c, vlocity_cmt__SubType__c, vlocity_cmt__Language__c, 
                                            vlocity_cmt__PropertySet__c, vlocity_cmt__IsActive__c,
                                            (SELECT Id, Name, vlocity_cmt__PropertySet__c, vlocity_cmt__Active__c
                                            FROM vlocity_cmt__Elements__r)
                                            FROM vlocity_cmt__OmniScript__c 
                                            WHERE vlocity_cmt__IsActive__c  = true
                                        ]);	
    }



    public void execute(Database.BatchableContext batchableContext, List<vlocity_cmt__OmniScript__c > omniscripts ){
        
        String uniqueName;
        List<ReportOmniScript__c> reportOmniscripts = new List<ReportOmniScript__c>();
        List<ReportOSElement__c>  reportOSElements  = new List<ReportOSElement__c>();
        
        // Copy the OmniScript properties
        for(vlocity_cmt__OmniScript__c os : [SELECT Id, Name,vlocity_cmt__Type__c, vlocity_cmt__SubType__c, vlocity_cmt__Language__c, 
                                                vlocity_cmt__PropertySet__c, vlocity_cmt__IsActive__c
                                                FROM vlocity_cmt__OmniScript__c 
                                                WHERE vlocity_cmt__IsActive__c  = true
                                            ]) {

            uniqueName = os.vlocity_cmt__Type__c + '_' + os.vlocity_cmt__SubType__c + '_' + os.vlocity_cmt__Language__c;
            // Report OmniScript that will be saved
            ReportOmniScript__c repOs = new ReportOmniScript__c(
                Name = os.Name,
                UniqueName__c = uniqueName,
                VlocityOmniScript__c = os.Id
            );


            //Bring Property Set info from the OS to the Report OS
            Map<String, Object> osPropertySet = (Map<String, Object>) JSON.deserializeUntyped(os.vlocity_cmt__PropertySet__c);
            COE_UTIL_Map.copyFields     (osCopiedFieldNames , os, repOs, sfiNS);
            COE_UTIL_Map.copyProperties (osCopiedProperties , osPropertySet, repOs);
            COE_UTIL_Map.checkProperties(osCheckedProperties, osPropertySet, repOs);
            
            //add to the list of OS Elements to upsert
            reportOmniscripts.add(repOs);
        }

        // Copy the Element properties
        if(!omniscripts.isEmpty()) {

            Set<Id> osIds = (new Map<Id, vlocity_cmt__OmniScript__c>(omniscripts)).keySet();  
            for(vlocity_cmt__Element__c  el : [SELECT Id, Name, vlocity_cmt__PropertySet__c, vlocity_cmt__Active__c,
                                                vlocity_cmt__OmniScriptId__r.vlocity_cmt__Type__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__SubType__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__Language__c
                                               FROM vlocity_cmt__Element__c
                                               WHERE vlocity_cmt__OmniScriptId__c IN :osIds]) {
                
                 // Report OmniScript that will only be used as a foreign key reference
                uniqueName = el.vlocity_cmt__OmniScriptId__r.vlocity_cmt__Type__c + '_' + el.vlocity_cmt__OmniScriptId__r.vlocity_cmt__SubType__c + '_' + el.vlocity_cmt__OmniScriptId__r.vlocity_cmt__Language__c;
                ReportOmniScript__c refOs = new ReportOmniScript__c(
                    UniqueName__c = uniqueName
                );

                // Report OmniScript Element that will be saved
                ReportOSElement__c repOsEl = new ReportOSElement__c(
                    Name = el.Name,
                    ReportOmniScript__r  = refOs,
                    VlocityElement__c  = el.Id
                );
                
                //Bring Property Set info from the OS Element to the Report Element
                Map<String, Object> elPropertySet = (Map<String, Object>) JSON.deserializeUntyped(el.vlocity_cmt__PropertySet__c);
                COE_UTIL_Map.copyProperties (elCopiedProperties , elPropertySet, repOsEl);
                COE_UTIL_Map.checkProperties(elCheckedProperties, elPropertySet, repOsEl);
                
                //add to the list of OS Elements to insert
            	reportOSElements.add(repOsEl);
            }
        }
        
        if(!reportOmniScripts.isEmpty()){
            upsert reportOmniScripts UniqueName__c;
            if(!reportOSElements.isEmpty()){
                insert reportOSElements;
            }
        }
    }
    

    public void finish(Database.BatchableContext bc) {
	}
}