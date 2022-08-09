export const OMNIDEF = {"userTimeZone":120,"userProfile":"System Administrator","userName":"alex.khamphet@engie.com","userId":"0051v00000A8bHuAAJ","userCurrencyCode":"EUR","timeStamp":"2022-07-11T20:48:24.277Z","sOmniScriptId":"a2F5q000001Q7BCEA0","sobjPL":{},"RPBundle":"","rMap":{},"response":null,"propSetMap":{"wpm":false,"visualforcePagesAvailableInPreview":{},"trackingCustomData":{"CaseId":"%CaseId%"},"timeTracking":true,"stylesheet":{"newportRtl":"","newport":"","lightningRtl":"","lightning":""},"stepChartPlacement":"right","ssm":false,"showInputWidth":true,"seedDataJSON":{"confirmerSign_ok":"Init"},"scrollBehavior":"auto","saveURLPatterns":{},"saveObjectId":"%ContextId%","saveNameTemplate":null,"saveForLaterRedirectTemplateUrl":"vlcSaveForLaterAcknowledge.html","saveForLaterRedirectPageName":"sflRedirect","saveExpireInDays":null,"saveContentEncoded":false,"rtpSeed":false,"pubsub":false,"persistentComponent":[{"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"vlcProductConfig.html","modalController":"ModalProductCtrl"},"label":"","itemsKey":"cartItems","id":"vlcCart"},{"render":false,"remoteTimeout":30000,"remoteOptions":{"preTransformBundle":"","postTransformBundle":""},"remoteMethod":"","remoteClass":"","preTransformBundle":"","postTransformBundle":"","modalConfigurationSetting":{"modalSize":"lg","modalHTMLTemplateId":"","modalController":""},"label":"","itemsKey":"knowledgeItems","id":"vlcKnowledge","dispOutsideOmni":false}],"message":{"GasOptionPrice":"%optionsList|0:GasOptionPrice%"},"mergeSavedData":false,"lkObjName":null,"knowledgeArticleTypeQueryFieldsMap":{},"hideStepChart":false,"errorMessage":{"custom":[]},"enableKnowledge":false,"elementTypeToHTMLTemplateMapping":{},"disableUnloadWarn":true,"currentLanguage":"en_US","currencyCode":"","consoleTabTitle":"EM-CHF Ref","consoleTabLabel":"New","consoleTabIcon":"custom:custom18","cancelType":"SObject","cancelSource":"%ContextId%","cancelRedirectTemplateUrl":"vlcCancelled.html","cancelRedirectPageName":"OmniScriptCancelled","bLK":false,"autoSaveOnStepNext":false,"autoFocus":false,"allowSaveForLater":true,"allowCancel":true},"prefillJSON":"{}","lwcId":"1f622572-b325-7c51-4dbb-8e48c40b9183","labelMap":{"OptionsPause":"StepOptions:OptionsPause","LineBreak_PauseFlagOptions":"StepOptions:LineBreak_PauseFlagOptions","TextBlock3":"StepOptions:TextBlock3","TextBlock2":"StepOptions:TextBlock2","TextBlock1":"StepOptions:TextBlock1","MSG_AvailableOptions":"StepOptions:MSG_AvailableOptions","ServiceOptionsContainer":"StepOptions:ServiceOptionsContainer","Headline_Options":"StepOptions:Headline_Options","StepOptions":"StepOptions","IP_SM_TR_DataOptions":"IP_SM_TR_DataOptions","setValuesHarmonicaOPV":"setValuesHarmonicaOPV","SetValues_StepOptions":"SetValues_StepOptions","DRE_GetTauxOptionGazVertMDT":"DRE_GetTauxOptionGazVertMDT","SetValues_GetTauxOptionGazVertMDT":"SetValues_GetTauxOptionGazVertMDT","IP_SM_GetPrixServices":"IP_SM_GetPrixServices","SetValues_GetPrixServices":"SetValues_GetPrixServices"},"labelKeyMap":{},"errorMsg":"","error":"OK","dMap":{},"depSOPL":{},"depCusPL":{},"cusPL":{},"children":[{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"pauseIndex","data":"","condition":"="},{"field":"enableExistingContract","data":"on","condition":"<>"}],"operator":"AND"}},"pubsub":false,"message":{},"label":"SetValues_GetPrixServices","elementValueMap":{"GetPrixServices_typeDeComptage":"=IF(%SelectOffer:Elec:ElecEstimate:TypeComptage% == 'Simple', 'SIMPLE', IF(%SelectOffer:Elec:ElecEstimate:TypeComptage% == 'Double', 'HPHC', IF(%SelectOffer:Elec:ElecEstimate:TypeComptage% == 'Triple', '3CADRANS')))","GetPrixServices_tauxGazVert":"%moveinData:pourcentage_gaz_vert_plus__c%","GetPrixServices_puissance":"%SelectOffer:Elec:ElecEstimate:Puissance%","GetPrixServices_plageDeConsommation":"=IF(%SelectOffer:Gaz:GazEstimate:libellePlageConso% == 'de 0 à 5 999 kWh/an', 6000, IF(%SelectOffer:Gaz:GazEstimate:libellePlageConso% == 'de 6 000 à 29 999 kWh/an', 30000, IF(%SelectOffer:Gaz:GazEstimate:libellePlageConso% == 'Supérieur à 30 000 kWh/an', 300000)))","GetPrixServices_idPack":"%OffreChoisis:idPack%","GetPrixServices_errorMessage":"Option indisponible à la souscription. Vous pouvez continuer la souscription de l'offre énergie en cliquant sur suivant.","GetPrixServices_energyType":"%EnergyType%"},"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SetValues_GetPrixServices","level":0,"indexInParent":0,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SetValues_GetPrixServices","lwcId":"lwc0"},{"type":"Integration Procedure Action","propSetMap":{"wpm":false,"validationRequired":"Step","useContinuation":false,"svgSprite":"","svgIcon":"","ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"pauseIndex","data":"","condition":"="}],"operator":"AND"}},"sendJSONPath":"DummyJSON","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"remoteOptions":{"useFuture":false,"preTransformBundle":"","postTransformBundle":"","chainable":false},"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"preTransformBundle":"","postTransformBundle":"","postMessage":"Done","message":{},"label":"IP_SM_GetPrixServices","integrationProcedureKey":"IP_SM_GetPrixServices","inProgressMessage":"In Progress","failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","extraPayload":{"typeDeComptage":"%GetPrixServices_typeDeComptage%","tauxGazVert":"%GetPrixServices_tauxGazVert%","puissance":"%GetPrixServices_puissance%","plageDeConsommation":"%GetPrixServices_plageDeConsommation%","optionsToExclude":"%GetPrixServices_optionsToExclude%","idPack":"%GetPrixServices_idPack%","energyType":"%GetPrixServices_energyType%"},"errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"IP_SM_GetPrixServices","level":0,"indexInParent":1,"bHasAttachment":false,"bEmbed":false,"bIntegrationProcedureAction":true,"JSONPath":"IP_SM_GetPrixServices","lwcId":"lwc1"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"pauseIndex","data":"","condition":"="}],"operator":"AND"}},"pubsub":false,"message":{},"label":"SetValues_GetTauxOptionGazVertMDT","elementValueMap":{"TauxOptionGazVert_DeveloperName":"DefaultValue"},"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SetValues_GetTauxOptionGazVertMDT","level":0,"indexInParent":2,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SetValues_GetTauxOptionGazVertMDT","lwcId":"lwc2"},{"type":"DataRaptor Extract Action","propSetMap":{"wpm":false,"validationRequired":"Step","ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"pauseIndex","data":"","condition":"="}],"operator":"AND"}},"responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"postMessage":"Done","message":{},"label":"DRE_GetTauxOptionGazVertMDT","inProgressMessage":"In Progress","ignoreCache":false,"failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"disOnTplt":false,"dataRaptor Input Parameters":[{"inputParam":"TauxOptionGazVert_DeveloperName","element":"TauxOptionGazVert_DeveloperName"}],"controlWidth":12,"bundle":"DR_SM_GetCustomMetadata","HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"DRE_GetTauxOptionGazVertMDT","level":0,"indexInParent":3,"bHasAttachment":false,"bEmbed":false,"bDataRaptorExtractAction":true,"JSONPath":"DRE_GetTauxOptionGazVertMDT","lwcId":"lwc3"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"pauseIndex","data":"","condition":"="}],"operator":"AND"}},"pubsub":false,"message":{},"label":"SetValues4","elementValueMap":{"Range_GasOption":"=INTEGER(%TauxOptionGazVertMDTRate%)","GasOptionPrice":"=%Remote_GetPrixServices_GOPT_VERT:prixMensuelTTC_GOPT_VERT%","ElecOptionPrice":"=%Remote_GetPrixServices_EFOPT_VERT:prixMensuelTTC_EFOPT_VERT%"},"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"SetValues_StepOptions","level":0,"indexInParent":4,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"SetValues_StepOptions","lwcId":"lwc4"},{"type":"Set Values","propSetMap":{"wpm":false,"ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"moveinContext","data":"harmonica","condition":"="},{"field":"pauseIndex","data":"","condition":"="}],"operator":"AND"}},"pubsub":false,"message":{},"label":"setValuesHarmonicaOPV","elementValueMap":{"RadioGasOptionChoice":"=IF(%moveinData:gaz_vert_plus__c%=='true','Y',IF(%moveinData:gaz_vert_plus__c%=='false','N',null))","RadioElecOptionChoice":"=IF(%moveinData:elec_vert_plus__c%=='true','Y',IF(%moveinData:elec_vert_plus__c%=='false','N',null))","OptionRate":"=%moveinData:pourcentage_gaz_vert_plus__c%"},"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"setValuesHarmonicaOPV","level":0,"indexInParent":5,"bHasAttachment":false,"bEmbed":false,"bSetValues":true,"JSONPath":"setValuesHarmonicaOPV","lwcId":"lwc5"},{"type":"Integration Procedure Action","propSetMap":{"wpm":false,"validationRequired":"Step","useContinuation":false,"svgSprite":"","svgIcon":"","ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"pauseIndex","data":"","condition":"="}],"operator":"AND"}},"sendOnlyExtraPayload":true,"sendJSONPath":"","sendJSONNode":"","responseJSONPath":"","responseJSONNode":"","remoteTimeout":30000,"remoteOptions":{"useFuture":false,"preTransformBundle":"","postTransformBundle":"","chainable":false},"redirectTemplateUrl":"vlcAcknowledge.html","redirectPreviousWidth":3,"redirectPreviousLabel":"Previous","redirectPageName":"","redirectNextWidth":3,"redirectNextLabel":"Next","pubsub":false,"preTransformBundle":"","postTransformBundle":"","postMessage":"Done","message":{},"label":"IntegrationProcedureAction2","integrationProcedureKey":"IP_SM_TR_DataOptions","inProgressMessage":"In Progress","failureNextLabel":"Continue","failureGoBackLabel":"Go Back","failureAbortMessage":"Are you sure?","failureAbortLabel":"Abort","extraPayload":{"Remote_GetPrixServices_GOPT_VERT":"%Remote_GetPrixServices_GOPT_VERT%","Remote_GetPrixServices_EFOPT_VERT":"%Remote_GetPrixServices_EFOPT_VERT%","GasOptionPriceAvailable":"%GasOptionPriceAvailable%","GasOptionPrice":"%GasOptionPrice%","EnergyType":"%EnergyType%","ElecOptionPriceAvailable":"%ElecOptionPriceAvailable%","ElecOptionPrice":"%ElecOptionPrice%"},"errorMessage":{"default":null,"custom":[]},"enableDefaultAbort":false,"enableActionMessage":false,"disOnTplt":false,"controlWidth":12,"HTMLTemplateId":"","aggElements":{}},"offSet":0,"name":"IP_SM_TR_DataOptions","level":0,"indexInParent":6,"bHasAttachment":false,"bEmbed":false,"bIntegrationProcedureAction":true,"JSONPath":"IP_SM_TR_DataOptions","lwcId":"lwc6"},{"type":"Step","propSetMap":{"wpm":false,"validationRequired":true,"ssm":false,"showPersistentComponent":[false,false],"show":{"group":{"rules":[{"field":"pauseIndex","data":"","condition":"="}],"operator":"AND"}},"saveMessage":"","saveLabel":"","remoteTimeout":30000,"remoteOptions":{},"remoteMethod":"","remoteClass":"","pubsub":false,"previousWidth":3,"previousLabel":"Précédent","nextWidth":3,"nextLabel":"Suivant","message":{},"label":"Options","knowledgeOptions":{"typeFilter":"","remoteTimeout":30000,"publishStatus":"Online","language":"English","keyword":"","dataCategoryCriteria":""},"instructionKey":"","instruction":"","errorMessage":{"default":null,"custom":[]},"disOnTplt":false,"conditionType":"Hide if False","completeMessage":"Are you sure you want to complete the script?","completeLabel":"Complete","chartLabel":null,"cancelMessage":"Are you sure?","cancelLabel":"Cancel","allowSaveForLater":true,"HTMLTemplateId":"","uiElements":{"StepOptions":""},"aggElements":{"ServiceOptionsContainer":"","OptionsPause":""}},"offSet":0,"name":"StepOptions","level":0,"indexInParent":7,"bHasAttachment":false,"bEmbed":false,"response":null,"inheritShowProp":null,"children":[{"response":null,"level":1,"indexInParent":0,"eleArray":[{"type":"Text Block","rootIndex":7,"response":null,"propSetMap":{"textKey":"","text":"<p>Option(s) Vert+</p>","show":null,"sanitize":false,"label":"TextBlock15","disOnTplt":false,"dataJSON":false,"controlWidth":12,"HTMLTemplateId":""},"name":"Headline_Options","level":1,"JSONPath":"StepOptions:Headline_Options","indexInParent":0,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc70-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":1,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":7,"response":null,"propSetMap":{"show":null,"lwcName":"sm_ServiceOptionsContainer","label":"CustomLWC1","hide":false,"customAttributes":[{"source":"%optionsList%","name":"options"}],"controlWidth":12,"conditionType":"Hide if False","bStandalone":false},"name":"ServiceOptionsContainer","level":1,"JSONPath":"StepOptions:ServiceOptionsContainer","indexInParent":1,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent1":true,"lwcId":"lwc71-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":2,"eleArray":[{"type":"Validation","rootIndex":7,"response":null,"propSetMap":{"validateExpression":{"group":{"rules":[{"field":"enableExistingContract","data":"on","condition":"<>"},{"field":"optionsListSize","data":"0","condition":">"}],"operator":"OR"}},"show":null,"messages":[{"value":true,"type":"Success","text":"","active":false},{"value":false,"type":"Requirement","text":"Pas d'option elligible.","active":true}],"label":"MSG_AvailableOptions","hideLabel":true,"controlWidth":12,"HTMLTemplateId":""},"name":"MSG_AvailableOptions","level":1,"JSONPath":"StepOptions:MSG_AvailableOptions","indexInParent":2,"index":0,"children":[],"bHasAttachment":false,"bMessaging":true,"lwcId":"lwc72-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":3,"eleArray":[{"type":"Text Block","rootIndex":7,"response":null,"propSetMap":{"textKey":"","text":"<p><strong><span style=\"color: #ff0000;\">%GetPrixServices_errorMessage%</span></strong></p>","show":{"group":{"rules":[{"group":{"rules":[{"group":{"rules":[{"field":"EnergyType","data":"Elec","condition":"="},{"field":"EnergyType","data":"Duo","condition":"="}],"operator":"OR"}},{"group":{"rules":[{"field":"ElecOptionPriceAvailable","data":"true","condition":"="},{"field":"Remote_GetPrixServices_EFOPT_VERT:code","data":"OCTOPUS_RechercherPrixService_01","condition":"<>"}],"operator":"AND"}}],"operator":"AND"}},{"group":{"rules":[{"group":{"rules":[{"field":"EnergyType","data":"Gaz","condition":"="},{"field":"EnergyType","data":"Duo","condition":"="}],"operator":"OR"}},{"group":{"rules":[{"field":"GasOptionPriceAvailable","data":"true","condition":"="},{"field":"Remote_GetPrixServices_GOPT_VERT:code","data":"OCTOPUS_RechercherPrixService_01","condition":"<>"}],"operator":"AND"}}],"operator":"AND"}}],"operator":"OR"}},"sanitize":false,"label":"TextBlock_GetPrixServicesKO","dataJSON":false,"controlWidth":12,"HTMLTemplateId":""},"name":"TextBlock1","level":1,"JSONPath":"StepOptions:TextBlock1","indexInParent":3,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc73-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":4,"eleArray":[{"type":"Text Block","rootIndex":7,"response":null,"propSetMap":{"textKey":"","text":"<p><strong><span style=\"color: #ff0000;\">Option Gaz Vert+ : %Remote_GetPrixServices_GOPT_VERT:libelle%</span></strong></p>","show":{"group":{"rules":[{"group":{"rules":[{"field":"EnergyType","data":"Gaz","condition":"="},{"field":"EnergyType","data":"Duo","condition":"="}],"operator":"OR"}},{"group":{"rules":[{"field":"GasOptionPriceAvailable","data":"true","condition":"="},{"field":"Remote_GetPrixServices_GOPT_VERT:code","data":"OCTOPUS_RechercherPrixService_01","condition":"<>"}],"operator":"AND"}}],"operator":"AND"}},"sanitize":false,"label":"TextBlock_GetPrixServicesKOGaz","dataJSON":false,"controlWidth":12,"HTMLTemplateId":""},"name":"TextBlock2","level":1,"JSONPath":"StepOptions:TextBlock2","indexInParent":4,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc74-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":5,"eleArray":[{"type":"Text Block","rootIndex":7,"response":null,"propSetMap":{"textKey":"","text":"<p><strong><span style=\"color: #ff0000;\">Option Elec Vert+ : %Remote_GetPrixServices_EFOPT_VERT:libelle%</span></strong></p>","show":{"group":{"rules":[{"group":{"rules":[{"field":"EnergyType","data":"Elec","condition":"="},{"field":"EnergyType","data":"Duo","condition":"="}],"operator":"OR"}},{"group":{"rules":[{"field":"ElecOptionPriceAvailable","data":"true","condition":"="},{"field":"Remote_GetPrixServices_EFOPT_VERT:code","data":"OCTOPUS_RechercherPrixService_01","condition":"<>"}],"operator":"AND"}}],"operator":"AND"}},"sanitize":false,"label":"TextBlock_GetPrixServicesKOElec","dataJSON":false,"controlWidth":12,"HTMLTemplateId":""},"name":"TextBlock3","level":1,"JSONPath":"StepOptions:TextBlock3","indexInParent":5,"index":0,"children":[],"bHasAttachment":false,"bTextBlock":true,"lwcId":"lwc75-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":6,"eleArray":[{"type":"Line Break","rootIndex":7,"response":null,"propSetMap":{"show":null,"padding":50,"label":"LineBreak4","disOnTplt":false,"HTMLTemplateId":""},"name":"LineBreak_PauseFlagOptions","level":1,"JSONPath":"StepOptions:LineBreak_PauseFlagOptions","indexInParent":6,"index":0,"children":[],"bHasAttachment":false,"bLineBreak":true,"lwcId":"lwc76-0"}],"bHasAttachment":false},{"response":null,"level":1,"indexInParent":7,"eleArray":[{"type":"Custom Lightning Web Component","rootIndex":7,"response":null,"propSetMap":{"show":null,"lwcName":"tracerInteraction","label":"CustomLWC2","hide":false,"disOnTplt":false,"customAttributes":[{"source":"Options","name":"steplabel"},{"source":"true","name":"hascancel"},{"source":"true","name":"hastrace"}],"controlWidth":12,"conditionType":"Hide if False","bStandalone":false},"name":"OptionsPause","level":1,"JSONPath":"StepOptions:OptionsPause","indexInParent":7,"index":0,"children":[],"bHasAttachment":false,"bcustomlightningwebcomponent2":true,"lwcId":"lwc77-0"}],"bHasAttachment":false}],"bAccordionOpen":false,"bAccordionActive":false,"bStep":true,"isStep":true,"JSONPath":"StepOptions","lwcId":"lwc7"}],"bReusable":true,"bpVersion":2,"bpType":"smContact","bpSubType":"Options","bpLang":"French","bHasAttachment":false,"lwcVarMap":{"optionsList":null}};