let definition =
      {"dataSource":{"contextVariables":[],"orderBy":{"isReverse":false,"name":""},"type":"Custom","value":{"body":" [\n    {\n\"isSelected\" : true,\n      \"Id\": \"REC0\",\n      \"lienMentionsLegales\": \"../lightning/articles/Knowledge/Mentions-l&eacute;gales-Option-Gaz-Vert\",\n      \"lienPlusInfos\": \"../lightning/articles/Knowledge/Descriptif-Offre-Gaz-Vert\",\n      \"libelleOption\": \"Option Gaz Vert+\",\n      \"idOption\": \"GOPT_VERT\",\n      \"active\": \"init\",\n      \"selectedNodeName\": \"RadioGasOptionChoice\",\n      \"EnergyType\": \"Gaz\",\n      \"Remote_GetPrixServices\": {\n        \"additionalPrices\": {\n          \"ZZTAUX_100\": \"15,00\",\n          \"ZZTAUX_95\": \"14,26\",\n          \"ZZTAUX_90\": \"13,50\",\n          \"ZZTAUX_85\": \"12,76\",\n          \"ZZTAUX_80\": \"12,00\",\n          \"ZZTAUX_75\": \"11,26\",\n          \"ZZTAUX_70\": \"10,50\",\n          \"ZZTAUX_65\": \"9,76\",\n          \"ZZTAUX_60\": \"9,00\",\n          \"ZZTAUX_55\": \"8,26\",\n          \"ZZTAUX_50\": \"7,50\",\n          \"ZZTAUX_45\": \"6,76\",\n          \"ZZTAUX_40\": \"6,00\",\n          \"ZZTAUX_35\": \"5,26\",\n          \"ZZTAUX_30\": \"4,50\",\n          \"ZZTAUX_25\": \"3,76\",\n          \"ZZTAUX_20\": \"3,00\",\n          \"ZZTAUX_15\": \"2,26\",\n          \"ZZTAUX_10\": \"1,50\",\n          \"ZZTAUX_5\": \"0,76\"\n        },\n        \"code\": \"OCTOPUS_RechercherPrixService_01\",\n        \"exception\": \"\",\n        \"libelle\": \"Traitement effectuee sans erreur\",\n        \"prixMensuelTTC_GOPT_VERT\": \"3,00\"\n      },\n      \"OptionPriceAvailable\": true,\n      \"OptionPrice\": \"6,00\",\n      \"uniqueKey\": \"REC0\",\n      \"_flex\": {\n        \"uniqueKey\": \"REC0\"\n      },\n      \"selectedRate\": \"40\"\n    },\n    {\n      \"isSelected\" : true,\n      \"isCreated\" : true,\n      \"Id\": \"REC1\",\n      \"libelleOption\": \"Option Elec Vert+\",\n      \"idOption\": \"EFOPT_VERT\",\n      \"lienMentionsLegales\": \"../lightning/articles/Knowledge/Mentions-l&eacute;gales-Option-Elec-Vert\",\n      \"active\": false,\n      \"lienPlusInfos\": \"../lightning/articles/Knowledge/Descriptif-Offre-Elec-Vert\",\n      \"selectedNodeName\": \"RadioElecOptionChoice\",\n      \"EnergyType\": \"Elec\",\n      \"Remote_GetPrixServices\": {\n        \"code\": \"OCTOPUS_RechercherPrixService_01\",\n        \"exception\": \"\",\n        \"libelle\": \"Traitement effectuee sans erreur\",\n        \"prixMensuelTTC_EFOPT_VERT\": \"3,00\"\n      },\n      \"OptionPriceAvailable\": true,\n      \"OptionPrice\": \"3,00\",\n      \"uniqueKey\": \"REC1\",\n      \"_flex\": {\n        \"uniqueKey\": \"REC1\"\n      }\n    }\n  ]","dsDelay":"","resultVar":""}},"enableLwc":true,"isFlex":true,"isRepeatable":false,"lwc":{"DeveloperName":"cfSmOptionsSummaryContainer_2_SMILE","Id":"0Rb1X000000reXGSAY","ManageableState":"unmanaged","MasterLabel":"cfSmOptionsSummaryContainer_2_SMILE","NamespacePrefix":"c"},"osSupport":true,"selectableMode":"Multi","states":[{"actions":[],"childCards":["smOptionsSummaryDetails"],"components":{"layer-0":{"children":[{"children":[{"children":[{"class":"slds-col ","element":"flexIcon","elementLabel":"Accept-Icon","key":"element_element_element_block_0_0_block_0_0_flexIcon_0_0","name":"Icon","parentElementKey":"element_element_block_0_0_block_0_0","property":{"card":"{card}","color":"#4bca81","extraclass":"slds-icon_container slds-icon__svg--default ","iconName":"utility:like","iconType":"Salesforce SVG","imgsrc":"","record":"{record}","size":"medium","variant":"inverse"},"size":{"default":"1","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{"color":"#4bca81"},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{"color":"#4bca81"},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}}}],"type":"element","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Accept-Title","key":"element_element_element_element_block_0_0_block_0_0_block_1_0_outputField_0_0","name":"Text","parentElementKey":"element_element_element_block_0_0_block_0_0_block_1_0","property":{"card":"{card}","mergeField":"%3Cdiv%3E%3Cspan%20style=%22font-size:%2014pt;%22%3E%3Cstrong%3EOptions%20souscrites%3C/strong%3E%3C/span%3E%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n        color:#4bca81; ","text":{"align":"","color":"#4bca81"}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n        color:#4bca81; ","text":{"align":"","color":"#4bca81"}}}],"type":"text","userUpdatedElementLabel":true},{"class":"slds-col ","element":"childCardPreview","elementLabel":"Accept-Options","key":"element_element_element_element_block_0_0_block_0_0_block_1_0_childCardPreview_1_0","name":"FlexCard","parentElementKey":"element_element_element_block_0_0_block_0_0_block_1_0","property":{"cardName":"smOptionsSummaryDetails","cardNode":"{records}","data-conditions":{"group":[],"id":"state-condition-object","isParent":true},"isChildCardTrackingEnabled":false,"parentAttribute":{"channel":"{Parent.channel}","containerParentAttr":"{Parent}","containerState":"{Parent.layoutState}","detailsState":"{Parent.detailsState}"},"recordId":"{recordId}","selectedState":"Opv"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         ","text":{"align":"","color":""}}}],"type":"element","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Accept-Block-Content","key":"element_element_element_block_0_0_block_0_0_block_1_0","name":"Block","parentElementKey":"element_element_block_0_0_block_0_0","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"11","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"11","isResponsive":false},"sizeClass":"slds-size_11-of-12 ","style":"      \n         ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"11","isResponsive":false},"sizeClass":"slds-size_11-of-12 ","style":"      \n         ","text":{"align":"","color":""}}}],"type":"block","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Accept-Block2","key":"element_element_block_0_0_block_0_0","name":"Block","parentElementKey":"element_block_0_0","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"data-conditions":{"group":[],"id":"state-condition-object","isParent":true},"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-p-around_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"around:x-small","size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-p-around_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"around:x-small","size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         ","text":{"align":"","color":""}}}],"type":"block","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Accept-Block1","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"#F3F2F2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"25px","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"padding : 2% 5% 2% 5%;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F3F2F2;      \n    border-radius:25px;     padding : 2% 5% 2% 5%;","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"#F3F2F2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"25px","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"padding : 2% 5% 2% 5%;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F3F2F2;      \n    border-radius:25px;     padding : 2% 5% 2% 5%;","text":{"align":"","color":""}}}],"type":"block","userUpdatedElementLabel":true}]}},"conditions":{"group":[{"field":"Parent.layoutState","hasMergeField":false,"id":"state-new-condition-0","operator":"==","type":"custom","value":"accept"}],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Accept","omniscripts":[],"smartAction":{},"styleObject":{"class":"slds-card slds-p-around_x-small slds-m-bottom_x-small","container":{"class":"slds-card"},"margin":[{"size":"none","type":"around"}],"padding":[{"size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12"}},{"actions":[],"childCards":["smOptionsSummaryDetails"],"components":{"layer-0":{"children":[{"children":[{"children":[{"class":"slds-col ","element":"flexIcon","elementLabel":"Refuse-Icon","key":"element_element_element_block_0_1_block_0_1_flexIcon_0_1","name":"Icon","parentElementKey":"element_element_block_0_1_block_0_1","property":{"card":"{card}","color":"red","extraclass":"slds-icon_container slds-icon__svg--default ","iconName":"utility:dislike","iconType":"Salesforce SVG","imgsrc":"","record":"{record}","size":"medium","variant":"inverse"},"size":{"default":"1","isResponsive":false},"stateIndex":1,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{"color":"red"},"inlineStyle":"\n","margin":[],"padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"      \n         \n","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{"color":"red"},"inlineStyle":"\n","margin":[],"padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"      \n         \n","text":{"align":"","color":""}}}],"type":"element","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Refuse-Title","key":"element_element_element_element_block_0_1_block_0_1_block_1_1_outputField_0_1","name":"Text","parentElementKey":"element_element_element_block_0_1_block_0_1_block_1_1","property":{"card":"{card}","mergeField":"%3Cdiv%3E%3Cstrong%3E%3Cspan%20style=%22font-size:%2014pt;%22%3EOptions%20refus&eacute;es%3C/span%3E%3C/strong%3E%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n        color:red; ","text":{"align":"","color":"red"}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n        color:red; ","text":{"align":"","color":"red"}}}],"type":"text","userUpdatedElementLabel":true},{"class":"slds-col ","element":"childCardPreview","elementLabel":"Refuse-Options","key":"element_element_element_element_block_0_1_block_0_1_block_1_1_childCardPreview_1_1","name":"FlexCard","parentElementKey":"element_element_element_block_0_1_block_0_1_block_1_1","property":{"cardName":"smOptionsSummaryDetails","cardNode":"{records}","isChildCardTrackingEnabled":false,"parentAttribute":{"channel":"{Parent.channel}","containerParentAttr":"{Parent}","containerState":"{Parent.layoutState}","detailsState":"{Parent.detailsState}"},"recordId":"{recordId}","selectedState":"Opv"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Refuse-Block-Content","key":"element_element_element_block_0_1_block_0_1_block_1_1","name":"Block","parentElementKey":"element_element_block_0_1_block_0_1","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":11,"isResponsive":false},"stateIndex":1,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":11,"isResponsive":false},"sizeClass":"slds-size_11-of-12 ","style":"      \n         ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":11,"isResponsive":false},"sizeClass":"slds-size_11-of-12 ","style":"      \n         ","text":{"align":"","color":""}}}],"type":"block","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Refuse-Block2","key":"element_element_block_0_1_block_0_1","name":"Block","parentElementKey":"element_block_0_1","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"data-conditions":{"group":[],"id":"state-condition-object","isParent":true},"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"sizeClass":"slds-size_12-of-12"},"type":"block","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Refuse-Block1","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"background":{"color":"#F3F2F2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"25px","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"padding : 2% 5% 2% 5%;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F3F2F2;     : #cccccc 1px solid; \n    border-radius:25px;     padding : 2% 5% 2% 5%;","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"#F3F2F2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"25px","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"padding : 2% 5% 2% 5%;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F3F2F2;     : #cccccc 1px solid; \n    border-radius:25px;     padding : 2% 5% 2% 5%;","text":{"align":"","color":""}}}],"type":"block","userUpdatedElementLabel":true}]}},"conditions":{"group":[{"field":"Parent.layoutState","hasMergeField":false,"id":"state-new-condition-7","operator":"==","type":"custom","value":"refuse"}],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Refuse","omniscripts":[],"smartAction":{},"styleObject":{"class":"slds-card slds-p-around_x-small slds-m-bottom_x-small","container":{"class":"slds-card"},"margin":[{"size":"none","type":"around"}],"padding":[{"size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12"}},{"actions":[],"childCards":[],"components":{"layer-0":{"children":[{"children":[{"children":[{"class":"slds-col ","element":"flexIcon","elementLabel":"Standby-Icon","key":"element_element_element_block_0_2_block_0_2_flexIcon_0_2","name":"Icon","parentElementKey":"element_element_block_0_2_block_0_2","property":{"card":"{card}","color":"orange","extraclass":"slds-icon_container slds-icon__svg--default ","iconName":"utility:chat","iconType":"Salesforce SVG","imgsrc":"","record":"{record}","size":"medium","variant":"inverse"},"size":{"default":"1","isResponsive":false},"stateIndex":2,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{"color":"orange"},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"      \n         ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{"color":"orange"},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"      \n         ","text":{"align":"","color":""}}}],"type":"element","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"Standby-Title","key":"element_element_element_block_0_2_block_0_2_outputField_1_2","name":"Text","parentElementKey":"element_element_block_0_2_block_0_2","property":{"card":"{card}","mergeField":"%3Cdiv%3E%3Cspan%20style=%22font-size:%2014pt;%22%3E%3Cstrong%3EOptions%20&laquo;%20en%20r&eacute;flexion%20&raquo;%3C/strong%3E%3C/span%3E%3C/div%3E","record":"{record}"},"size":{"default":"6","isResponsive":false},"stateIndex":2,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"6","isResponsive":false},"sizeClass":"slds-size_6-of-12 ","style":"     : #ccc 1px solid; \n        color:orange; ","text":{"align":"","color":"orange"}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"6","isResponsive":false},"sizeClass":"slds-size_6-of-12 ","style":"     : #ccc 1px solid; \n        color:orange; ","text":{"align":"","color":"orange"}}}],"type":"text","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Block-0-clone-0-Block-2","key":"element_element_block_0_2_block_0_2","name":"Block","parentElementKey":"element_block_0_2","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"data-conditions":{"group":[],"id":"state-condition-object","isParent":true},"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":2,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"sizeClass":"slds-size_12-of-12"},"type":"block"}],"class":"slds-col ","element":"block","elementLabel":"Standby-Block","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":2,"styleObject":{"background":{"color":"#F3F2F2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"25px","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"padding : 2% 5% 2% 5%;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F3F2F2;     : #cccccc 1px solid; \n    border-radius:25px;     padding : 2% 5% 2% 5%;","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"#F3F2F2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"25px","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"padding : 2% 5% 2% 5%;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F3F2F2;     : #cccccc 1px solid; \n    border-radius:25px;     padding : 2% 5% 2% 5%;","text":{"align":"","color":""}}}],"type":"block","userUpdatedElementLabel":true}]}},"conditions":{"group":[{"field":"Parent.layoutState","hasMergeField":false,"id":"state-new-condition-14","operator":"==","type":"custom","value":"standby"}],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Standby","omniscripts":[],"smartAction":{},"styleObject":{"class":"slds-card slds-p-around_x-small slds-m-bottom_x-small","container":{"class":"slds-card"},"margin":[{"size":"none","type":"around"}],"padding":[{"size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12"}},{"actions":[],"blankCardState":true,"childCards":[],"components":{"layer-0":{"children":[{"children":[],"class":"slds-col ","element":"block","elementLabel":"Block-0-clone-0","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"#F3F2F2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"25px","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"padding : 2% 5% 2% 5%;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F3F2F2;     : #cccccc 1px solid; \n    border-radius:25px;     padding : 2% 5% 2% 5%;","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"#F3F2F2","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"25px","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"padding : 2% 5% 2% 5%;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#F3F2F2;     : #cccccc 1px solid; \n    border-radius:25px;     padding : 2% 5% 2% 5%;","text":{"align":"","color":""}}}],"type":"block"}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"class":"slds-card slds-p-around_x-small slds-m-bottom_x-small","container":{"class":"slds-card"},"margin":[{"size":"none","type":"around"}],"padding":[{"size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12"}}],"theme":"slds","title":"smOptionsSummaryContainer","Id":"a3t5q000000ocdKAAQ","vlocity_cmt__GlobalKey__c":"smOptionsSummaryContainer/SMILE/2/1648453743993","vlocity_cmt__IsChildCard__c":true};
  export default definition