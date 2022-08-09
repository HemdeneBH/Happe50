@isTest
public class COE_BAT004_OsFixImageUrl_TEST {
    
    public static User testUser = COE_UTIL_TestDataFactory.newUser('cb003', 'SM_SystemAdmin');

    @testSetup static void setup() {
        
        Document img = new Document();
        img.Body = Blob.valueOf('This is supposed to be an image');
        img.ContentType = 'image';
        img.DeveloperName = 'testImage';
        img.IsPublic = true;
        img.Name = 'testImage';
        img.FolderId = [select id from folder where name = 'Vlocity Document Uploads'].id;
        insert img;

        //actual Property Set from a basic OmniScript
        String osPropSet = '{"persistentComponent":[{"render":false,"label":"","remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"preTransformBundle":"","postTransformBundle":"","sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","id":"vlcCart","itemsKey":"cartItems","modalConfigurationSetting":{"modalHTMLTemplateId":"vlcProductConfig.html","modalController":"ModalProductCtrl","modalSize":"lg"}},{"render":false,"label":"","remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"preTransformBundle":"","postTransformBundle":"","id":"vlcKnowledge","itemsKey":"knowledgeItems","modalConfigurationSetting":{"modalHTMLTemplateId":"","modalController":"","modalSize":"lg"}}],"allowSaveForLater":true,"saveNameTemplate":null,"saveExpireInDays":null,"saveForLaterRedirectPageName":"sflRedirect","saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveContentEncoded":false,"saveObjectId":"%ContextId%","saveURLPatterns":{},"autoSaveOnStepNext":false,"elementTypeToHTMLTemplateMapping":{},"seedDataJSON":{},"trackingCustomData":{},"enableKnowledge":false,"bLK":false,"lkObjName":null,"knowledgeArticleTypeQueryFieldsMap":{},"timeTracking":false,"hideStepChart":false,"visualforcePagesAvailableInPreview":{},"cancelType":"SObject","allowCancel":true,"cancelSource":"%ContextId%","cancelRedirectPageName":"OmniScriptCancelled","cancelRedirectTemplateUrl":"vlcCancelled.html","consoleTabLabel":"New","wpm":false,"ssm":false,"message":{},"pubsub":false,"autoFocus":false,"currencyCode":"","showInputWidth":false,"rtpSeed":false,"consoleTabTitle":null,"consoleTabIcon":"custom:custom18","errorMessage":{"custom":[]},"disableUnloadWarn":true,"stepChartPlacement":"right","elementTypeToLwcTemplateMapping":{"StepChart":"cardEnergie"}}';
        vlocity_cmt__OmniScript__c omniscript = COE_UTIL_TestDataFactory.newOS('test', 'omniscript',  osPropSet); 
        insert omniscript;
       
        //OmniScript elements
        //// empty step
        String step1PropSet = '{"validationRequired":true,"previousLabel":"Previous","previousWidth":3,"nextLabel":"Next","nextWidth":3,"cancelLabel":"Cancel","cancelMessage":"Are you sure?","saveLabel":"Save for later","saveMessage":"Are you sure you want to save it for later?","completeLabel":"Complete","completeMessage":"Are you sure you want to complete the script?","instruction":"","showPersistentComponent":[false,false],"remoteClass":"","remoteMethod":"","remoteTimeout":30000,"remoteOptions":{},"knowledgeOptions":{"language":"English","publishStatus":"Online","keyword":"","dataCategoryCriteria":"","remoteTimeout":30000,"typeFilter":""},"show":null,"conditionType":"Hide if False","HTMLTemplateId":"","instructionKey":"","chartLabel":null,"label":"Step1","allowSaveForLater":true,"errorMessage":{"custom":[],"default":null},"disOnTplt":false,"lwcComponentOverride":""}';
        vlocity_cmt__Element__c step1 = COE_UTIL_TestDataFactory.newOsElement('Step1', 'Step',     1, step1PropSet, omniscript.Id); 
        insert step1;
        //// radio with images elements
        String radioPropSet = '{"documentNames":["CABIBCCGA33792ca69a2440e884a73a1631564f40"],"label":"Radio1","disOnTplt":false,"enableCaption":true,"imageCountInRow":null,"optionHeight":100,"optionWidth":100,"hide":false,"HTMLTemplateId":"","accessibleInFutureSteps":false,"conditionType":"Hide if False","show":null,"controllingField":{"source":"","type":"","element":""},"optionSource":{"source":"","type":"image"},"options":[{"autoAdv":null,"value":"val1","developerName":"CABIBCCGA33792ca69a2440e884a73a1631564f40","name":"val 1","imgId":"../servlet/servlet.ImageServer?id='+ img.Id + '&&docName=CABIBCCGA33792ca69a2440e884a73a1631564f40&&oid=' + UserInfo.getOrganizationId() + '"},{"name":"val3","value":"val3","imgId":"../servlet/servlet.ImageServer?id=' + img.Id + '&&docName=CABIBCCGA33792ca69a2440e884a73a1631564f40&&oid=' + UserInfo.getOrganizationId() + '"}],"helpText":"","help":false,"defaultValue":null,"horizontalMode":"image","readOnly":false,"repeatLimit":null,"repeatClone":false,"repeat":false,"required":false,"controlWidth":12}';
        vlocity_cmt__Element__c radio = COE_UTIL_TestDataFactory.newOsElement('Radio1', 'Radio',  2, radioPropSet, omniscript.Id);
        radio.vlocity_cmt__ParentElementId__c = step1.Id;
        insert radio;


    }
    
    @isTest static void executeBatchable(){

        System.runAs(testUser){
 

            //Set the SOSL query result to be the radio element
            vlocity_cmt__Element__c soslResult = [SELECT Id, LastModifiedDate, CreatedDate 
                                                        FROM vlocity_cmt__Element__c 
                                                        WHERE vlocity_cmt__Type__c = 'Radio'
                                                ];
            List<Id> fixedSearchResults= new List<Id>{soslResult.Id};
            System.assert(soslResult.LastModifiedDate == soslResult.CreatedDate, 'Radio element has been updated after creation');

            //run batch that will trigger an update on the radio element (automatically fix the org Id in links and) and adds a internal note (second param in constructor)
            Test.startTest();
            Test.setFixedSearchResults(fixedSearchResults);
            Database.executeBatch(new COE_BAT004_OsFixImageUrl(UserInfo.getOrganizationId(), true)); // first parameter is supposed to be the org Id set after cloning, but test class won't work otherwise
            Test.stopTest();

            //check batch result
            vlocity_cmt__Element__c checkOsEl = [SELECT Id, LastModifiedDate, CreatedDate, vlocity_cmt__InternalNotes__c
                FROM vlocity_cmt__Element__c 
                WHERE Id = :soslResult.Id
            ];
            System.assert(checkOsEl.LastModifiedDate > checkOsEl.CreatedDate, 'Radio element has not been updated by batch process');
            System.assertNotEquals(null, checkOsEl.vlocity_cmt__InternalNotes__c, 'Radio Internal notes has not been set');
        }
    }

    // covers both of the searchInActiveOS() and the foundOsWrapper inner class
    @isTest static void searchInActiveOS(){

        System.runAs(testUser){
 
            //set omniscript as active (not a true activation, but enough for our tests)
            vlocity_cmt__OmniScript__c os = [SELECT Id, vlocity_cmt__Type__c, vlocity_cmt__SubType__c, vlocity_cmt__Language__c FROM vlocity_cmt__OmniScript__c  LIMIT 1]; 
            String osFullName =  os.vlocity_cmt__Type__c    + '/'
                                + os.vlocity_cmt__SubType__c + ' ('
                                + os.vlocity_cmt__Language__c + ')';
            os.vlocity_cmt__IsActive__c = true;
            update os;
             
            //Set the SOSL query result to be the radio element
            vlocity_cmt__Element__c soslResult = [SELECT Id, LastModifiedDate, CreatedDate 
                                                        FROM vlocity_cmt__Element__c 
                                                        WHERE vlocity_cmt__Type__c = 'Radio'
                                                ];
            List<Id> fixedSearchResults= new List<Id>{soslResult.Id};
            Map<String, COE_BAT004_OsFixImageUrl.foundOsWrapper> searchResult; 

            //run batch that will trigger an update on the radio element (automatically fix the org Id in links and) and adds a internal note (second param in constructor)
            Test.startTest();
            Test.setFixedSearchResults(fixedSearchResults);
            COE_BAT004_OsFixImageUrl bat004 = new COE_BAT004_OsFixImageUrl(UserInfo.getOrganizationId(), true); // first parameter is supposed to be the org Id set after cloning, but test class won't work otherwise
            searchResult = bat004.searchInActiveOS();
            Test.stopTest();

            //check search result
            System.assertEquals(1, searchResult.size());
            System.assert(searchResult.containsKey(osFullName), 'OmniScript was not found');
            System.assertEquals(1, searchResult.get(osFullName).foundReason.size(), 'OmniScript was not found');
        }
    }
}