@isTest
public with sharing class COE_UTIL_Map_TEST {
    
    public static User testUser = COE_UTIL_TestDataFactory.newUser('testUser', 'SM_SystemAdmin');

    @isTest public static void copyFields() {

        System.runAs(testUser){
 
            String osPropSet = '{"persistentComponent":[{"render":false,"label":"","remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"preTransformBundle":"","postTransformBundle":"","sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","id":"vlcCart","itemsKey":"cartItems","modalConfigurationSetting":{"modalHTMLTemplateId":"vlcProductConfig.html","modalController":"ModalProductCtrl","modalSize":"lg"}},{"render":false,"label":"","remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"preTransformBundle":"","postTransformBundle":"","id":"vlcKnowledge","itemsKey":"knowledgeItems","modalConfigurationSetting":{"modalHTMLTemplateId":"","modalController":"","modalSize":"lg"}}],"allowSaveForLater":true,"saveNameTemplate":null,"saveExpireInDays":null,"saveForLaterRedirectPageName":"sflRedirect","saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveContentEncoded":false,"saveObjectId":"%ContextId%","saveURLPatterns":{},"autoSaveOnStepNext":false,"elementTypeToHTMLTemplateMapping":{},"seedDataJSON":{},"trackingCustomData":{},"enableKnowledge":false,"bLK":false,"lkObjName":null,"knowledgeArticleTypeQueryFieldsMap":{},"timeTracking":false,"hideStepChart":false,"visualforcePagesAvailableInPreview":{},"cancelType":"SObject","allowCancel":true,"cancelSource":"%ContextId%","cancelRedirectPageName":"OmniScriptCancelled","cancelRedirectTemplateUrl":"vlcCancelled.html","consoleTabLabel":"New","wpm":false,"ssm":false,"message":{},"pubsub":false,"autoFocus":false,"currencyCode":"","showInputWidth":false,"rtpSeed":false,"consoleTabTitle":null,"consoleTabIcon":"custom:custom18","errorMessage":{"custom":[]},"disableUnloadWarn":true,"stepChartPlacement":"right","elementTypeToLwcTemplateMapping":{"StepChart":"cardEnergie"}}';
            vlocity_cmt__OmniScript__c srcOmniscript = COE_UTIL_TestDataFactory.newOS('test', 'omniscript',  osPropSet); 

            vlocity_cmt__OmniScript__c tgtOmniscript = new vlocity_cmt__OmniScript__c();
            Set<String>  fieldNames = new Set<String>{ 'Name' };
            COE_UTIL_Map.copyFields(fieldNames, srcOmniscript, tgtOmniscript, null);
            
            System.assertEquals(srcOmniscript.Name, tgtOmniscript.Name);
        }
    }


    @isTest public static void copyProperties() {

        System.runAs(testUser){

            Set<String> properties         = new Set<String>{ 'Type', 'SubType'};
            Map<String, Object> srcPropSet = new Map<String, Object> { 'Type' => 'testType', 'SubType' => 'testSubType'};
            ReportOmniScript__c tgtOmniscript = new ReportOmniScript__c();
            
            COE_UTIL_Map.copyProperties(properties, srcPropSet, tgtOmniscript);
            
            System.assertEquals(tgtOmniscript.Type__c,    srcPropSet.get('Type'));
            System.assertEquals(tgtOmniscript.SubType__c, srcPropSet.get('SubType'));
        }
    }

    @isTest public static void check() {

        System.runAs(testUser){

            Set<String> properties         = new Set<String>{ 'ElementTypeToHTMLTemplateMapping', 'ElementTypeToLwcTemplateMapping'};
            Map<String, Object> srcPropSet = new Map<String, Object> { 'ElementTypeToHTMLTemplateMapping' => 'testTemplate', 'ElementTypeToLwcTemplateMapping' => null};
            ReportOmniScript__c tgtOmniscript = new ReportOmniScript__c();
            
            COE_UTIL_Map.checkProperties(properties, srcPropSet, tgtOmniscript);
            
            System.assert(tgtOmniscript.HasElementTypeToHTMLTemplateMapping__c, 'Record should have HTML Template Mapping defined');
            System.assert(!tgtOmniscript.HasElementTypeToLwcTemplateMapping__c, 'Record should not have LWC Template Mapping defined');
        }
    }
}