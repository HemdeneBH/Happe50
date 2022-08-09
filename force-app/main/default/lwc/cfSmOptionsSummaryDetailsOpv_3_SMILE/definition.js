let definition =
      {"dataSource":{"contextVariables":[],"orderBy":{"isReverse":false,"name":""},"type":"Custom","value":{"body":"[\n    {\n\"isSelected\" : true,\n      \"Id\": \"REC0\",\n      \"lienMentionsLegales\": \"../lightning/articles/Knowledge/Mentions-l&eacute;gales-Option-Gaz-Vert\",\n      \"lienPlusInfos\": \"../lightning/articles/Knowledge/Descriptif-Offre-Gaz-Vert\",\n      \"libelleOption\": \"Option Gaz Vert+\",\n      \"idOption\": \"GOPT_VERT\",\n      \"active\": \"init\",\n      \"selectedNodeName\": \"RadioGasOptionChoice\",\n      \"EnergyType\": \"Gaz\",\n      \"Remote_GetPrixServices\": {\n        \"additionalPrices\": {\n          \"ZZTAUX_100\": \"15,00\",\n          \"ZZTAUX_95\": \"14,26\",\n          \"ZZTAUX_90\": \"13,50\",\n          \"ZZTAUX_85\": \"12,76\",\n          \"ZZTAUX_80\": \"12,00\",\n          \"ZZTAUX_75\": \"11,26\",\n          \"ZZTAUX_70\": \"10,50\",\n          \"ZZTAUX_65\": \"9,76\",\n          \"ZZTAUX_60\": \"9,00\",\n          \"ZZTAUX_55\": \"8,26\",\n          \"ZZTAUX_50\": \"7,50\",\n          \"ZZTAUX_45\": \"6,76\",\n          \"ZZTAUX_40\": \"6,00\",\n          \"ZZTAUX_35\": \"5,26\",\n          \"ZZTAUX_30\": \"4,50\",\n          \"ZZTAUX_25\": \"3,76\",\n          \"ZZTAUX_20\": \"3,00\",\n          \"ZZTAUX_15\": \"2,26\",\n          \"ZZTAUX_10\": \"1,50\",\n          \"ZZTAUX_5\": \"0,76\"\n        },\n        \"code\": \"OCTOPUS_RechercherPrixService_01\",\n        \"exception\": \"\",\n        \"libelle\": \"Traitement effectuee sans erreur\",\n        \"prixMensuelTTC_GOPT_VERT\": \"3,00\"\n      },\n      \"OptionPriceAvailable\": true,\n      \"OptionPrice\": \"6,00\",\n      \"uniqueKey\": \"REC0\",\n      \"_flex\": {\n        \"uniqueKey\": \"REC0\"\n      },\n      \"selectedRate\": \"40\"\n    },\n    {\n\"isSelected\" : true,\n      \"Id\": \"REC1\",\n      \"libelleOption\": \"Option Elec Vert+\",\n      \"idOption\": \"EFOPT_VERT\",\n      \"lienMentionsLegales\": \"../lightning/articles/Knowledge/Mentions-l&eacute;gales-Option-Elec-Vert\",\n      \"active\": false,\n      \"lienPlusInfos\": \"../lightning/articles/Knowledge/Descriptif-Offre-Elec-Vert\",\n      \"selectedNodeName\": \"RadioElecOptionChoice\",\n      \"EnergyType\": \"Elec\",\n      \"Remote_GetPrixServices\": {\n        \"code\": \"OCTOPUS_RechercherPrixService_01\",\n        \"exception\": \"\",\n        \"libelle\": \"Traitement effectuee sans erreur\",\n        \"prixMensuelTTC_EFOPT_VERT\": \"3,00\"\n      },\n      \"OptionPriceAvailable\": true,\n      \"OptionPrice\": \"3,00\",\n      \"uniqueKey\": \"REC1\",\n      \"_flex\": {\n        \"uniqueKey\": \"REC1\"\n      }\n    }\n  ]\n","dsDelay":"","resultVar":""}},"enableLwc":true,"isFlex":true,"lwc":{"DeveloperName":"cfSmOptionsSummaryDetailsOpv_3_SMILE","Id":"0Rb1X000000sEjJSAU","ManageableState":"unmanaged","MasterLabel":"cfSmOptionsSummaryDetailsOpv_3_SMILE","NamespacePrefix":"c"},"selectableMode":"Multi","states":[{"actions":[],"childCards":[],"components":{"layer-0":{"children":[{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"CPV-Data-OptionLabel","key":"element_element_block_0_0_outputField_0_0","name":"label","parentElementKey":"element_block_0_0","property":{"card":"{card}","fieldName":"libelleOption","label":"","labelclass":"","placeholder":"output","record":"{record}","type":"text","valueclass":""},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{"labelclass":"","valueclass":""},"inlineStyle":"font-weight : 600","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         font-weight : 600","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{"labelclass":"","valueclass":""},"inlineStyle":"font-weight : 600","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         font-weight : 600","text":{"align":"","color":""}}}],"type":"field","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"CPV-Data-Rate","key":"element_element_block_0_0_outputField_1_0","name":"percent","parentElementKey":"element_block_0_0","property":{"card":"{card}","data-conditions":{"group":[{"field":"selectedRate","hasMergeField":false,"id":"state-new-condition-5","operator":"!=","type":"custom","value":""},{"field":"selectedRate","hasMergeField":false,"id":"state-new-condition-10","logicalOperator":"&&","operator":"!=","type":"custom","value":"undefined"},{"field":"isSelected","hasMergeField":false,"id":"state-new-condition-0","logicalOperator":"&&","operator":"==","type":"custom","value":"true"}],"id":"state-condition-object","isParent":true},"fieldName":"selectedRate","label":"","mask":"## %","placeholder":"","record":"{record}","type":"number"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"field","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"CPV-Data-Amount","key":"element_element_block_0_0_outputField_2_0","name":"amount","parentElementKey":"element_block_0_0","property":{"card":"{card}","currency":"EUR","data-conditions":{"group":[{"field":"isSelected","hasMergeField":false,"id":"state-new-condition-13","operator":"==","type":"custom","value":"true"}],"id":"state-condition-object","isParent":true},"fieldName":"{OptionPrice} {Session.priceSuffix}","format":"DD/MM/YYYY","label":"","locale":"fr-FR","mask":"#,##0.###","placeholder":"output","record":"{record}","type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"field","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"CPV-Data","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"5","isResponsive":false},"stateIndex":0,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"size":{"default":"5","isResponsive":false},"sizeClass":"slds-size_5-of-12 "},"type":"block","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"customLwc","elementLabel":"CPV-CreateOrder-Action","key":"element_element_block_1_0_customLwc_0_0","name":"Custom LWC","parentElementKey":"element_block_1_0","property":{"accountId":"{Parent.containerParentAttr.accountId}","caseId":"{Parent.containerParentAttr.caseId}","channel":"{Parent.channel}","contractInfo":"{Parent.containerParentAttr.contractInfo}","customlwcname":"smOptionsOrderCreationAction","data-conditions":{"group":[{"field":"Parent.containerState","hasMergeField":false,"id":"state-new-condition-2","operator":"==","type":"custom","value":"accept"}],"id":"state-condition-object","isParent":true},"idBpClient":"{Parent.containerParentAttr.idBpClient}","idBpConseiller":"{Parent.containerParentAttr.idBpConseiller}","idCompteClient":"{Parent.containerParentAttr.idCompteClient}","idLocal":"{Parent.containerParentAttr.idLocal}","ip-name":"IP_SM_OrderCreation_Options_XML","label":"{Parent.containerParentAttr.actionLabel}","option":"{record}","orderStatus":"{Parent.containerParentAttr.orderStatus}","theme":"slds"},"size":{"default":12,"isResponsive":false},"stateIndex":0,"styleObject":{"size":{"default":12,"isResponsive":false},"sizeClass":"slds-size_12-of-12"},"type":"element","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"CPV-CreateOrder","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"data-conditions":{"group":[],"id":"state-condition-object","isParent":true},"label":"Block","record":"{record}"},"size":{"default":"7","isResponsive":false},"stateIndex":0,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"size":{"default":"7","isResponsive":false},"sizeClass":"slds-size_7-of-12 "},"type":"block","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"Creation message","name":"Text","property":{"card":"{card}","data-conditions":{"group":[{"field":"idPropositionCommerciale","hasMergeField":false,"id":"state-new-condition-0","operator":"!=","type":"custom","value":""},{"field":"idPropositionCommerciale","hasMergeField":false,"id":"state-new-condition-12","logicalOperator":"&&","operator":"!=","type":"custom","value":"undefined"}],"id":"state-condition-object","isParent":true},"mergeField":"%3Cdiv%3EEnvoi%20d&rsquo;un%20contrat%20au%20client%20qui%20devra%20renvoyer%20un%20exemplaire%20sign&eacute;%20pour%20validation%3C/div%3E","record":"{record}"},"size":{"default":12,"isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-text-align_center ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":12,"isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         ","text":{"align":"center","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-text-align_center ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":12,"isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         ","text":{"align":"center","color":""}}}],"type":"text","userUpdatedElementLabel":true},{"class":"slds-col ","element":"baseInputElement","elementLabel":"CPV-Data-MockSuccess","name":"Checkbox","property":{"card":"{card}","data-conditions":{"group":[{"field":"isSelected","hasMergeField":false,"id":"state-new-condition-0","operator":"==","type":"custom","value":"tru"}],"id":"state-condition-object","isParent":true},"propertyObj":{"checked":false,"fieldBinding":"{doSuccess}","label":"doSuccess"},"record":"{record}","type":"checkbox"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"class":"slds-p-right_x-small","margin":[{"size":"xx-small","type":"bottom"}],"padding":[{"size":"small","type":"right"}],"sizeClass":"slds-size_12-of-12"},"type":"element","userUpdatedElementLabel":true}]}},"conditions":{"group":[{"field":"Parent.layoutState","hasMergeField":false,"id":"state-new-condition-27","operator":"==","type":"custom","value":"cpv"}],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"CPV","omniscripts":[],"smartAction":{},"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#000000","radius":"","style":"","type":[],"width":""},"class":" ","container":{"class":""},"customClass":"","elementStyleProperties":{},"inlineStyle":"align-items : stretch","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         align-items : stretch","text":{"align":"","color":""}}},{"actions":[],"childCards":[],"components":{"layer-0":{"children":[{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Summary-Data-OptionLabel","key":"element_element_block_0_1_outputField_0_1","name":"label","parentElementKey":"element_block_0_1","property":{"card":"{card}","fieldName":"libelleOption","label":"","placeholder":"output","record":"{record}","type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"font-weight : 600","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         font-weight : 600","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"font-weight : 600","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         font-weight : 600","text":{"align":"","color":""}}}],"type":"field","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Summary-Left","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"9","isResponsive":false},"stateIndex":1,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"size":{"default":"9","isResponsive":false},"sizeClass":"slds-size_9-of-12 "},"type":"block","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Summary-Data-Rate","key":"element_element_block_1_1_outputField_0_1","name":"percent","parentElementKey":"element_block_1_1","property":{"card":"{card}","data-conditions":{"group":[{"field":"selectedRate","hasMergeField":false,"id":"state-new-condition-5","operator":"!=","type":"custom","value":""},{"field":"selectedRate","hasMergeField":false,"id":"state-new-condition-10","logicalOperator":"&&","operator":"!=","type":"custom","value":"undefined"}],"id":"state-condition-object","isParent":true},"fieldName":"selectedRate","label":"","mask":"## %","placeholder":"","record":"{record}","styles":{"value":{"textAlign":"right"}},"type":"number"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"container":{"class":""},"elementStyleProperties":{"styles":{"value":{"textAlign":"right"}}},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"container":{"class":""},"elementStyleProperties":{"styles":{"value":{"textAlign":"right"}}},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12","text":{"align":"","color":""}}}],"type":"field","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"Summary-Data-Amount","key":"element_element_block_1_1_outputField_1_1","name":"amount","parentElementKey":"element_block_1_1","property":{"card":"{card}","currency":"EUR","fieldName":"{OptionPrice} {Session.priceSuffix}","format":"DD/MM/YYYY","label":"","locale":"fr-FR","mask":"#,##0.###","placeholder":"output","record":"{record}","styles":{"label":{"textAlign":""},"value":{"textAlign":"right"}},"type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"container":{"class":""},"elementStyleProperties":{"styles":{"label":{"textAlign":""},"value":{"textAlign":"right"}}},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"container":{"class":""},"elementStyleProperties":{"styles":{"label":{"textAlign":""},"value":{"textAlign":"right"}}},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","text":{"align":"","color":""}}}],"type":"field","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Summary-Right","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"3","isResponsive":false},"stateIndex":1,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"size":{"default":"3","isResponsive":false},"sizeClass":"slds-size_3-of-12 "},"type":"block","userUpdatedElementLabel":true}]}},"conditions":{"group":[{"field":"Parent.layoutState","hasMergeField":false,"id":"state-new-condition-38","operator":"==","type":"custom","value":"summary"}],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Summary","omniscripts":[],"smartAction":{},"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#000000","radius":"","style":"dashed","type":[],"width":""},"class":" ","container":{"class":""},"customClass":"","elementStyleProperties":{},"inlineStyle":"align-items : stretch","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         align-items : stretch","text":{"align":"","color":""}}},{"actions":[],"blankCardState":true,"childCards":[],"components":{"layer-0":{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Text-0","name":"Text","property":{"card":"{card}","mergeField":"%3Cdiv%3ENo%20state%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":2,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"text"}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Blank","omniscripts":[],"smartAction":{},"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"","style":"","type":[],"width":""},"class":" slds-p-around_x-small slds-m-around_none ","container":{"class":""},"customClass":"","elementStyleProperties":{},"inlineStyle":"align-items : stretch","margin":[{"label":"around:none","size":"none","type":"around"}],"padding":[{"label":"around:x-small","size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         align-items : stretch","text":{"align":"","color":""}}}],"theme":"slds","title":"smOptionsSummaryDetailsOpv","Id":"a3t5q000000ocdMAAQ","vlocity_cmt__GlobalKey__c":"smOptionsSummaryDetailsOpv/SMILE/3/1649696044877","vlocity_cmt__IsChildCard__c":true};
  export default definition