export const OMNIDEF = {"userTimeZone":120,"userProfile":"SM_SystemAdmin","userName":"khalil.oukil@engie.com","userId":"0051v00000A82pNAAR","userCurrencyCode":"EUR","timeStamp":"2022-07-11T22:30:03.460Z","sOmniScriptId":"a2F5q000001Q7AJEA0","sobjPL":{},"RPBundle":"","rMap":{},"response":null,"propSetMap":{"wpm":false,"visualforcePagesAvailableInPreview":{},"trackingCustomData":{},"timeTracking":true,"stylesheet":{"newportRtl":"","newport":"","lightningRtl":"","lightning":""},"stepChartPlacement":"right","ssm":false,"showInputWidth":false,"seedDataJSON":{},"scrollBehavior":"auto","saveURLPatterns":{},"saveObjectId":"%ContextId%","saveNameTemplate":null,"saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveForLaterRedirectPageName":"sflRedirect","saveExpireInDays":null,"saveContentEncoded":false,"rtpSeed":false,"pubsub":false,"persistentComponent":[{"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"vlcProductConfig.html","modalController":"ModalProductCtrl"},"label":"","itemsKey":"cartItems","id":"vlcCart"},{"render":true,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"","modalController":""},"label":"Articles Suggérés","itemsKey":"knowledgeItems","id":"vlcKnowledge","dispOutsideOmni":false}],"message":{},"mergeSavedData":false,"lkObjName":"Knowledge__kav","knowledgeArticleTypeQueryFieldsMap":{"Article_Sugg_r":"Title,Consigne__c,SM_Projet__c"},"hideStepChart":false,"errorMessage":{"custom":[]},"enableKnowledge":true,"elementTypeToHTMLTemplateMapping":{},"disableUnloadWarn":true,"currentLanguage":"fr","currencyCode":"","consoleTabTitle":null,"consoleTabLabel":"New","consoleTabIcon":"custom:custom18","cancelType":"SObject","cancelSource":"%ContextId%","cancelRedirectTemplateUrl":"vlcCancelled.html","cancelRedirectPageName":"OmniScriptCancelled","bLK":true,"autoSaveOnStepNext":false,"autoFocus":false,"allowSaveForLater":true,"allowCancel":true},"prefillJSON":"{}","lwcId":"c54bf48d-ad44-db51-cf4e-147fc0c3ceb5","labelMap":{"PauseOrderValidation":"OrderValidation:PauseOrderValidation","CpvRefusedOptions":"OrderValidation:CpvRefusedOptions","CpvAcceptedOptions":"OrderValidation:CpvAcceptedOptions","CpvCheckButtons":"OrderValidation:CpvCheckButtons","CpvAddress":"OrderValidation:CpvAddress","CpvEmail":"OrderValidation:CpvEmail","CpvChannel":"OrderValidation:CpvChannel","CpvInfosclient":"OrderValidation:CpvInfosclient","OrderValidation":"OrderValidation","SV_OrderValidationFlexCardOptions":"SV_OrderValidationFlexCardOptions"},"labelKeyMap":{},"errorMsg":"","error":"OK","dMap":{},"depSOPL":{},"depCusPL":{},"cusPL":{},"children":[{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[true,false],"show":null,"pubsub":false,"message":{},"label":"SV_OrderValidationFlexCardOptions","elementValueMap":{"optionsCardsParents":{"refuseForCpv":{"layoutState":"refuse","detailsState":"cpv"},"acceptForCpv":{"orderStatus":"Draft","layoutState":"accept","idLocal":"%NumeroLocal%","idCompteClient":"%IdCompteClient%","idBpConseiller":"%idConseiller%","idBpClient":"%contactInfos:refClientIdBP%","detailsState":"cpv","contractInfo":{"typeComptage":"%typeComptageCode%","rythmeFacturation":"%RythmeFacturation%","puissance":"%puissance%","plageConsommation":"%plageConsommation%"},"caseId":"%DRId_Case%","actionLabel":"Créer CPV","accountId":"%contactInfos:FirstConsumerAccount%"}},"flexcardContactInfo":{"personal":"%contactInfos:ChoixElements:ContactInfo%","mobile":"%contactInfos:ChoixElements:TelMobile:principalMobileValue%","idCompteClient":"%IdCompteClient%","email":"%contactInfos:emailPrincipalValue%","address":{"Ville":"%City%","ComplementAdresse":"%ComplementAdresse%","CodePostal":"%CP%","Adresse":"=%NumeroVoie% + \" \" + %LibelleVoie%"}}},"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SV_OrderValidationFlexCardOptions","level":0,"indexInParent":0,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SV_OrderValidationFlexCardOptions","lwcId":"lwc0"},{"type":"Step","propSetMap":{"wpm":false,"validationRequired":true,"ssm":false,"showPersistentComponent":[true,false],"show":{"group":{"rules":[{"field":"pauseIndex","data":null,"condition":"="}],"operator":"AND"}},"saveMessage":"Are you sure you want to save it for later?","saveLabel":"Save for later","remoteTimeout":30000,"remoteOptions":{},"remoteMethod":"","remoteClass":"","pubsub":false,"previousWidth":3,"previousLabel":"Précédent","nextWidth":3,"nextLabel":"Suivant","message":{},"label":"Validation CPV","knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"publishStatus":"Online","language":"English","keyword":"","dataCategoryCriteria":""},"instructionKey":"","instruction":"","errorMessage":{"default":null,"custom":[]},"conditionType":"Hide if False","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","chartLabel":null,"cancelMessage":"Are you sure?","cancelLabel":"Cancel","businessEvent":"","businessCategory":"","allowSaveForLater":false,"HTMLTemplateId":"","uiElements":{"OrderValidation":"","CpvChannel":"","CpvEmail":"","CpvAddress":""},"aggElements":{"CpvInfosclient":"","CpvAcceptedOptions":"","CpvRefusedOptions":"","PauseOrderValidation":""}},"offSet":0,"name":"OrderValidation","level":0,"indexInParent":1,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":1,"response":null,"propSetMap":{"show":null,"lwcName":"cfSmContactInfo","label":"CPV Infos Client","hide":false,"customAttributes":[{"source":"true","name":"parent-data"},{"source":"%flexcardContactInfo%","name":"records"}],"controlWidth":12,"conditionType":"Hide if False","bStandalone":false},"name":"CpvInfosclient","level":1,"JSONPath":"OrderValidation:CpvInfosclient","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent1":true,"lwcId":"lwc10-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":1,"eleArray":[{"type":"Select","rootIndex":1,"response":null,"propSetMap":{"showInputWidth":true,"show":{"group":{"rules":[{"field":"pauseIndex","data":null,"condition":"="}],"operator":"AND"}},"required":false,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"options":[{"value":"Email","name":"Email"},{"value":"Courrier","name":"Courrier"}],"optionSource":{"type":"","source":""},"lwcInput":{"updateField":"OrderValidation_CpvChannel"},"lwcComponentOverride":"smOsSelectCloneValue","label":"Canal d'envoi des CPV","inputWidth":12,"hide":false,"helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"controllingField":{"type":"","source":"","element":""},"controlWidth":6,"conditionType":"Optional if False","accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"CpvChannel","level":1,"JSONPath":"OrderValidation:CpvChannel","indexInParent":1,"index":0,"children":[],"bHasAttachment":false,"bSmOsSelectCloneValue":true,"lwcId":"lwc11-0","ns":"c"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":2,"eleArray":[{"type":"Select","rootIndex":1,"response":null,"propSetMap":{"showInputWidth":false,"show":{"group":{"rules":[{"field":"CpvChannel","data":"Email","condition":"="}],"operator":"AND"}},"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"options":[{"value":"dummy","name":"dummy"}],"optionSource":{"type":"","source":""},"lwcInput":{"optionsPath":"contactInfos:PicklistOptions:Email","defaultValuePath":"contactInfos:emailPrincipalValue"},"lwcComponentOverride":"os_dynamicSelectableItems","label":"Choisissez l'Email :","inputWidth":12,"hide":false,"helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"controllingField":{"type":"","source":"","element":""},"controlWidth":12,"conditionType":"Hide if False","accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"CpvEmail","level":1,"JSONPath":"OrderValidation:CpvEmail","indexInParent":2,"index":0,"children":[],"bHasAttachment":false,"bOs_dynamicSelectableItems":true,"lwcId":"lwc12-0","ns":"c"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":3,"eleArray":[{"type":"Select","rootIndex":1,"response":null,"propSetMap":{"showInputWidth":false,"show":{"group":{"rules":[{"field":"CpvChannel","data":"Courrier","condition":"="}],"operator":"AND"}},"required":true,"repeatLimit":null,"repeatClone":false,"repeat":false,"readOnly":false,"options":[{"value":"dummy","name":"dummy"}],"optionSource":{"type":"","source":""},"lwcInput":{"optionsPath":"contactInfos:PicklistOptions:Address","defaultValuePath":"contactInfos:fullAddress"},"lwcComponentOverride":"os_dynamicSelectableItems","label":"Choisissez l'Adresse :","inputWidth":12,"hide":false,"helpText":"","help":false,"disOnTplt":false,"defaultValue":null,"controllingField":{"type":"","source":"","element":""},"controlWidth":12,"conditionType":"Hide if False","accessibleInFutureSteps":false,"HTMLTemplateId":""},"name":"CpvAddress","level":1,"JSONPath":"OrderValidation:CpvAddress","indexInParent":3,"index":0,"children":[],"bHasAttachment":false,"bOs_dynamicSelectableItems":true,"lwcId":"lwc13-0","ns":"c"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":4,"eleArray":[{"type":"Validation","rootIndex":1,"response":null,"propSetMap":{"validateExpression":{"group":{"rules":[{"field":"CpvAcceptedOptions:isValid","data":"true","condition":"="}],"operator":"AND"}},"show":null,"messages":[{"value":true,"type":"Success","text":"Toutes les options ont bien été traitées","active":false},{"value":false,"type":"Requirement","text":"Veuillez créer les CPV pour les options ci-dessous","active":true}],"label":"Messaging1","hideLabel":true,"controlWidth":12,"HTMLTemplateId":""},"name":"CpvCheckButtons","level":1,"JSONPath":"OrderValidation:CpvCheckButtons","indexInParent":4,"index":0,"children":[],"bHasAttachment":false,"bMessaging":true,"lwcId":"lwc14-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":5,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":1,"response":null,"propSetMap":{"show":null,"lwcName":"smOptionsOrderCreationHandler","label":"CpvAcceptedOptions","hide":false,"customAttributes":[{"source":"%optionsList%","name":"options"},{"source":"optionsList","name":"options-node-name"},{"source":"%optionsCardsParents:acceptForCpv%","name":"flexcard-parent-attribute"},{"source":"%OrderValidation_CpvChannel%","name":"channel"}],"controlWidth":6,"conditionType":"Hide if False","bStandalone":false},"name":"CpvAcceptedOptions","level":1,"JSONPath":"OrderValidation:CpvAcceptedOptions","indexInParent":5,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent2":true,"lwcId":"lwc15-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":6,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":1,"response":null,"propSetMap":{"show":null,"lwcName":"cfSmOptionsSummaryContainer","label":"CpvRefusedOptions","hide":false,"customAttributes":[{"source":"true","name":"parent-data"},{"source":"%optionsList%","name":"records"},{"source":"%optionsCardsParents:refuseForCpv%","name":"parent-attribute"}],"controlWidth":6,"conditionType":"Hide if False","bStandalone":false},"name":"CpvRefusedOptions","level":1,"JSONPath":"OrderValidation:CpvRefusedOptions","indexInParent":6,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent3":true,"lwcId":"lwc16-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":7,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":1,"response":null,"propSetMap":{"show":null,"lwcName":"tracerInteraction","label":"Pause Order Creation Validation","hide":false,"customAttributes":[{"source":"Validation CPV","name":"steplabel"},{"source":"true","name":"hastrace"},{"source":"true","name":"hascancel"}],"controlWidth":12,"conditionType":"Hide if False","bStandalone":false},"name":"PauseOrderValidation","level":1,"JSONPath":"OrderValidation:PauseOrderValidation","indexInParent":7,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent4":true,"lwcId":"lwc17-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"OrderValidation","lwcId":"lwc1"}],"bReusable":true,"bpVersion":1,"bpType":"smContact","bpSubType":"OptionsOrderValidation","bpLang":"French","bHasAttachment":false,"lwcVarMap":{"flexcardContactInfo":null,"optionsList":null,"optionsCardsParents":{"acceptForCpv":null,"refuseForCpv":null},"OrderValidation_CpvChannel":null}};