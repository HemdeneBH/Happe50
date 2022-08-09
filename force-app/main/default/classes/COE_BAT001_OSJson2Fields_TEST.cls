@isTest
public class COE_BAT001_OSJson2Fields_TEST {
    
    public static User testUser = COE_UTIL_TestDataFactory.newUser('cb001', 'SM_SystemAdmin');

    @testSetup static void setup() {

        //actual Property Set from a basic OmniScript
        String osPropSet = '{"persistentComponent":[{"render":false,"label":"","remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"preTransformBundle":"","postTransformBundle":"","sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","id":"vlcCart","itemsKey":"cartItems","modalConfigurationSetting":{"modalHTMLTemplateId":"vlcProductConfig.html","modalController":"ModalProductCtrl","modalSize":"lg"}},{"render":false,"label":"","remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"preTransformBundle":"","postTransformBundle":"","id":"vlcKnowledge","itemsKey":"knowledgeItems","modalConfigurationSetting":{"modalHTMLTemplateId":"","modalController":"","modalSize":"lg"}}],"allowSaveForLater":true,"saveNameTemplate":null,"saveExpireInDays":null,"saveForLaterRedirectPageName":"sflRedirect","saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveContentEncoded":false,"saveObjectId":"%ContextId%","saveURLPatterns":{},"autoSaveOnStepNext":false,"elementTypeToHTMLTemplateMapping":{},"seedDataJSON":{},"trackingCustomData":{},"enableKnowledge":false,"bLK":false,"lkObjName":null,"knowledgeArticleTypeQueryFieldsMap":{},"timeTracking":false,"hideStepChart":false,"visualforcePagesAvailableInPreview":{},"cancelType":"SObject","allowCancel":true,"cancelSource":"%ContextId%","cancelRedirectPageName":"OmniScriptCancelled","cancelRedirectTemplateUrl":"vlcCancelled.html","consoleTabLabel":"New","wpm":false,"ssm":false,"message":{},"pubsub":false,"autoFocus":false,"currencyCode":"","showInputWidth":false,"rtpSeed":false,"consoleTabTitle":null,"consoleTabIcon":"custom:custom18","errorMessage":{"custom":[]},"disableUnloadWarn":true,"stepChartPlacement":"right","elementTypeToLwcTemplateMapping":{"StepChart":"cardEnergie"}}';
        vlocity_cmt__OmniScript__c omniscript = COE_UTIL_TestDataFactory.newOS('test', 'omniscript',  osPropSet); 
        insert omniscript;
       
        //OmniScript elements
        String step1PropSet = '{"validationRequired":true,"previousLabel":"Previous","previousWidth":3,"nextLabel":"Next","nextWidth":3,"cancelLabel":"Cancel","cancelMessage":"Are you sure?","saveLabel":"Save for later","saveMessage":"Are you sure you want to save it for later?","completeLabel":"Complete","completeMessage":"Are you sure you want to complete the script?","instruction":"","showPersistentComponent":[false,false],"remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{},"knowledgeOptions":{"language":"English","publishStatus":"Online","keyword":"","dataCategoryCriteria":"","remoteTimeout":30000,"typeFilter":""},"show":null,"conditionType":"Hide if False","HTMLTemplateId":"","instructionKey":"","chartLabel":null,"label":"Step1","allowSaveForLater":true,"errorMessage":{"custom":[],"default":null},"disOnTplt":false,"lwcComponentOverride":""}';
        String step2PropSet = '{"validationRequired":true,"previousLabel":"Previous","previousWidth":3,"nextLabel":"Next","nextWidth":3,"cancelLabel":"Cancel","cancelMessage":"Are you sure?","saveLabel":"Save for later","saveMessage":"Are you sure you want to save it for later?","completeLabel":"Complete","completeMessage":"Are you sure you want to complete the script?","instruction":"","showPersistentComponent":[false,false],"remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{},"knowledgeOptions":{"language":"English","publishStatus":"Online","keyword":"","dataCategoryCriteria":"","remoteTimeout":30000,"typeFilter":""},"show":null,"conditionType":"Hide if False","HTMLTemplateId":"","instructionKey":"","chartLabel":null,"label":"Step2","allowSaveForLater":true,"errorMessage":{"custom":[],"default":null},"disOnTplt":false,"lwcComponentOverride":""}';
        vlocity_cmt__Element__c step1 = COE_UTIL_TestDataFactory.newOsElement('Step1', 'Step',  1, step1PropSet, omniscript.Id); 
        vlocity_cmt__Element__c step2 = COE_UTIL_TestDataFactory.newOsElement('Step2', 'Step',  2, step2PropSet, omniscript.Id);
        insert (new  vlocity_cmt__Element__c[]{step1, step2});

        //set omniscript as active (not a true activation, but enough for our tests)
        omniscript.vlocity_cmt__IsActive__c = true;
        update omniscript;
    }
    
    @isTest static void executeBatchable(){

        System.runAs(testUser){
            
            //run batch with default OmniScript Data
            Test.startTest();
            Database.executeBatch(new COE_BAT001_OSJson2Fields());
            Test.stopTest();

            //check batch result
            List<ReportOmniScript__c> checkReportOS = [SELECT Id FROM ReportOmniScript__c];
            System.assertEquals(1, checkReportOS.size());
            List<ReportOSElement__c> checkReportOSE = [SELECT Id FROM ReportOSElement__c WHERE ReportOmniScript__c = :checkReportOS[0].Id];
            System.assertEquals(2, checkReportOSE.size());
        }
    }
}