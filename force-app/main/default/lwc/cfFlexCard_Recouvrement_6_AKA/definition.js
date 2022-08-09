let definition =
      {"dataSource":{"contextVariables":[],"orderBy":{"isReverse":false,"name":""},"type":"Custom","value":{"body":"{\n   \"IdBusinessPartner\": \"1234353\",\n    \"civilite\": \"civilite\",\n    \"nom\": \"nom\",\n    \"prenom\": \"prenom\",\n    \"idcompteclient\": \"idcompteclient\",\n    \"solde\": \"solde\",\n    \"modePaiement\": \"modePaiement\",\n    \"drp\": \"drp\",\n    \"libelleVoie\": \"libelleVoie\",\n    \"Nvoie\": \"Nvoie\",\n    \"complementAdresse\": \"complementAdresse\",\n    \"CP\": \"CP\",\n    \"ville\": \"ville\",\n  \"ListSyntheseRecouvrement\": [\n    {\n      \"montantTransfere\": 281.88,\n      \"prestataireRecouvrement\": {\n        \"nom\": \"Service Recouvrement ENGIE\",\n        \"telephone\": \"0977 404 404\"\n      },\n      \"jalon\": [\n        {\n          \"date\": \"06/04/2021\",\n          \"dateSR\": \"2021-06-04T00:00:00\",\n          \"numeroFacture\": \"513761395280\",\n          \"montant\": \"281.88\",\n          \"typeJalon\": {\n            \"idValeur\": \"COURRIER\",\n            \"code\": \"COU\",\n            \"nom\": \"Courrier relance L1\"\n          }\n        },\n        {\n          \"date\": \"06/23/2021\",\n          \"dateSR\": \"2021-06-23T00:00:00\",\n          \"numeroFacture\": \"513761395280\",\n          \"montant\": \"281.88\",\n          \"typeJalon\": {\n            \"idValeur\": \"COURRIER\",\n            \"code\": \"COU\",\n            \"nom\": \"Courrier relance L2\"\n          }\n        },\n        {\n          \"date\": \"03/23/2021\",\n          \"dateSR\": \"2021-03-23T00:00:00\",\n          \"montant\": \"-164.64\",\n          \"typeJalon\": {\n            \"idValeur\": \"REJET\",\n            \"code\": \"REJ\",\n            \"nom\": \"Impaye\"\n          }\n        },\n        {\n          \"date\": \"05/27/2021\",\n          \"dateSR\": \"2021-05-27T00:00:00\",\n          \"montant\": \"0.00\",\n          \"typeJalon\": {\n            \"idValeur\": \"SOCIETE RECOUVREMENT\",\n            \"code\": \"REC\",\n            \"nom\": \"Transmission societe recouvrement\"\n          }\n        },\n        {\n          \"date\": \"06/16/2021\",\n          \"dateSR\": \"2021-06-16T00:00:00\",\n          \"montant\": \"0.00\",\n          \"typeJalon\": {\n            \"idValeur\": \"INFORMATION\",\n            \"code\": \"INF\",\n            \"nom\": \"Prest : pénalité de retard calculée\"\n          }\n        },\n        {\n          \"date\": \"06/16/2021\",\n          \"dateSR\": \"2021-06-16T00:00:00\",\n          \"montant\": \"0.00\",\n          \"typeJalon\": {\n            \"idValeur\": \"INFORMATION\",\n            \"code\": \"INF\",\n            \"nom\": \"Prest : pénalité de retard calculée\"\n          }\n        }\n      ],\n      \"libelle\": \"Traitement effectué sans erreur\",\n      \"code\": \"OCTOPUS_LireSyntheseDossierRecouvrement_01\",\n      \"montantBlueBox\": \"281€88\",\n      \"noCourrier\": false,\n      \"matchingL1\": true,\n      \"jalonCourrierReg\": [\n        {\n          \"numeroFacture\": \"513761395280\",\n          \"montant\": \"281.88\",\n          \"Date\": \"06/23/2021\",\n          \"nom\": \"Courrier relance L2\"\n        },\n        {\n          \"numeroFacture\": \"513761395280\",\n          \"montant\": \"281.88\",\n          \"Date\": \"04/06/2021\",\n          \"nom\": \"Courrier relance L1\"\n        }\n      ],\n      \"jalonCourrierL1seul\": false,\n      \"JalonInfoServiceRec\": null\n    }\n  ],\n  \"jalonCourrierL1seul\": \"false\",\n  \"jalonCourrierReg\": [\n    {\n      \"numeroFacture\": \"513761395280\",\n      \"montant\": \"281.88\",\n      \"Date\": \"06/23/2021\",\n      \"nom\": \"Courrier relance L2\"\n    },\n    {\n      \"numeroFacture\": \"513761395280\",\n      \"montant\": \"281.88\",\n      \"Date\": \"04/06/2021\",\n      \"nom\": \"Courrier relance L1\"\n    }\n  ],\n  \"matchingL1\": \"true\",\n  \"noCourrier\": \"false\"\n}","resultVar":""}},"enableLwc":true,"isFlex":true,"isRepeatable":true,"lwc":{"DeveloperName":"cfFlexCard_Recouvrement_4_AKA","Id":"0Rb1v000000Xg3cCAC","MasterLabel":"cfFlexCard_Recouvrement_4_AKA","NamespacePrefix":"c","ManageableState":"unmanaged"},"multilanguageSupport":false,"osSupport":true,"states":[{"actions":[],"childCards":["SM_DossierRecouvrement_BlueBox","SM_DossierRecouvrement_DonneClient","SM_DossierRecouvrement_Facturation","SM_Recouvrement_ServiceRecouvrement","SM_Recouvrement_CourriersReglementaires","SM_ParcoursDossier"],"components":{"layer-0":{"children":[{"children":[{"class":"slds-col ","element":"childCardPreview","elementLabel":"BlueBox_FlexCard","key":"element_element_block_0_0_childCardPreview_0_0","name":"FlexCard","parentElementKey":"element_block_0_0","property":{"cardName":"SM_DossierRecouvrement_BlueBox","cardNode":"{record.ListSyntheseRecouvrement}","isChildCardTrackingEnabled":false,"recordId":"{recordId}","selectedState":"Active"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#2baded","radius":"","style":"","type":["border_top","border_right","border_bottom","border_left"],"width":"3"},"class":"slds-border_top slds-border_right slds-border_bottom slds-border_left ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     border-top: #2baded 3px solid;border-right: #2baded 3px solid;border-bottom: #2baded 3px solid;border-left: #2baded 3px solid; \n         ","text":{"align":"","color":""}},"type":"element","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"BlueBox_Block","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":12,"isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-p-bottom_medium ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"bottom:medium","size":"medium","type":"bottom"}],"size":{"default":12,"isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"type":"block","userUpdatedElementLabel":true},{"children":[{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"DonnéesClient_Title","key":"element_element_element_block_1_0_block_0_0_outputField_0_0","name":"Text","parentElementKey":"element_element_block_1_0_block_0_0","property":{"card":"{card}","mergeField":"%3Cdiv%3E%3Cstrong%3E%3Cspan%20style=%22font-size:%2012pt;%22%3E&nbsp;%20&nbsp;Donn&eacute;es%20client%3C/span%3E%3C/strong%3E%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"#e5e5e5","image":"","position":"","repeat":"","size":""},"border":{"color":"#e5e5e5","radius":"","style":"","type":"","width":""},"class":"slds-p-bottom_x-small slds-p-top_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"bottom:x-small","size":"x-small","type":"bottom"},{"label":"top:x-small","size":"x-small","type":"top"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#e5e5e5;     : #e5e5e5 1px solid; \n         ","text":{"align":"","color":""}},"type":"text","userUpdatedElementLabel":true},{"class":"slds-col ","element":"childCardPreview","elementLabel":"DonnéesClient_FlexCard","key":"element_element_element_block_1_0_block_0_0_childCardPreview_1_0","name":"FlexCard","parentElementKey":"element_element_block_1_0_block_0_0","property":{"cardName":"SM_DossierRecouvrement_DonneClient","cardNode":"{record}","isChildCardTrackingEnabled":false,"recordId":"{recordId}","selectedState":"Active"},"size":{"default":"12","isResponsive":false,"large":"12","medium":"12","small":"12"},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false,"large":"12","medium":"12","small":"12"},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"type":"element","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"DonnéesClient_Block","key":"element_element_block_1_0_block_0_0","name":"Block","parentElementKey":"element_block_1_0","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"4","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"","style":"solid","type":[],"width":""},"class":" ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"4","isResponsive":false},"sizeClass":"slds-size_4-of-12 ","style":"      \n         ","text":{"align":"","color":""}},"type":"block","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Facturation_Title","key":"element_element_element_block_1_0_block_1_0_outputField_0_0","name":"Text","parentElementKey":"element_element_block_1_0_block_1_0","property":{"card":"{card}","mergeField":"%3Cdiv%3E%3Cstrong%3E%3Cspan%20style=%22font-size:%2012pt;%22%3E&nbsp;%20&nbsp;Demande%20sur%20facturation%3C/span%3E%3C/strong%3E%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"#e5e5e5","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-p-top_x-small slds-p-bottom_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"top:x-small","size":"x-small","type":"top"},{"label":"bottom:x-small","size":"x-small","type":"bottom"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#e5e5e5;     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"type":"text","userUpdatedElementLabel":true},{"class":"slds-col ","element":"childCardPreview","elementLabel":"Facturation_FlexCard","key":"element_element_element_block_1_0_block_1_0_childCardPreview_1_0","name":"FlexCard","parentElementKey":"element_element_block_1_0_block_1_0","property":{"cardName":"SM_DossierRecouvrement_Facturation","cardNode":"{record}","isChildCardTrackingEnabled":false,"recordId":"{recordId}","selectedState":"Active"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Facturation_Block","key":"element_element_block_1_0_block_1_0","name":"Block","parentElementKey":"element_block_1_0","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"8","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"","style":"","type":[],"width":""},"class":" slds-p-left_medium ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"left:medium","size":"medium","type":"left"}],"size":{"default":"8","isResponsive":false},"sizeClass":"slds-size_8-of-12 ","style":"      \n         ","text":{"align":"","color":""}},"type":"block","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"ServiceRecouvrement_Title","key":"element_element_element_block_1_0_block_2_0_outputField_0_0","name":"Text","parentElementKey":"element_element_block_1_0_block_2_0","property":{"card":"{card}","mergeField":"%3Cdiv%3E%3Cstrong%3E%3Cspan%20style=%22font-size:%2012pt;%22%3E&nbsp;%20&nbsp;Infos%20du%20service%20de%20recouvrement%3C/span%3E%3C/strong%3E%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"#e5e5e5","image":"","position":"","repeat":"","size":""},"border":{"color":"#e5e5e5","radius":"","style":"","type":"","width":""},"class":"slds-p-bottom_x-small slds-p-top_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"bottom:x-small","size":"x-small","type":"bottom"},{"label":"top:x-small","size":"x-small","type":"top"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#e5e5e5;     : #e5e5e5 1px solid; \n         ","text":{"align":"","color":""}},"type":"text","userUpdatedElementLabel":true},{"class":"slds-col ","element":"childCardPreview","elementLabel":"ServiceRecouvrement_Block-FlexCard-1","key":"element_element_element_block_1_0_block_2_0_childCardPreview_1_0","name":"FlexCard","parentElementKey":"element_element_block_1_0_block_2_0","property":{"cardName":"SM_Recouvrement_ServiceRecouvrement","cardNode":"{record.ListSyntheseRecouvrement[0].JalonInfoServiceRec}","isChildCardTrackingEnabled":false,"recordId":"{recordId}","selectedState":"Active"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element"}],"class":"slds-col ","element":"block","elementLabel":"ServiceRecouvrement_Block","key":"element_element_block_1_0_block_2_0","name":"Block","parentElementKey":"element_block_1_0","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-m-top_medium ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[{"label":"top:medium","size":"medium","type":"top"}],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"type":"block","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Block-Left","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"7","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-p-right_medium ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"right:medium","size":"medium","type":"right"}],"size":{"default":"7","isResponsive":false},"sizeClass":"slds-size_7-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"type":"block","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Courrier_Title","key":"element_element_block_2_0_outputField_0_0","name":"Text","parentElementKey":"element_block_2_0","property":{"card":"{card}","mergeField":"%3Cdiv%3E%3Cstrong%3E%3Cspan%20style=%22font-size:%2012pt;%22%3E&nbsp;%20&nbsp;Courriers%20r&eacute;glementaires%3C/span%3E%3C/strong%3E%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"#e5e5e5","image":"","position":"","repeat":"","size":""},"border":{"color":"#e5e5e5","radius":"","style":"","type":"","width":""},"class":"slds-p-bottom_x-small slds-p-top_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"bottom:x-small","size":"x-small","type":"bottom"},{"label":"top:x-small","size":"x-small","type":"top"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#e5e5e5;     : #e5e5e5 1px solid; \n         ","text":{"align":"","color":""}},"type":"text","userUpdatedElementLabel":true},{"class":"slds-col ","element":"childCardPreview","elementLabel":"Courrier_FlexCard","key":"element_element_block_2_0_childCardPreview_1_0","name":"FlexCard","parentElementKey":"element_block_2_0","property":{"cardName":"SM_Recouvrement_CourriersReglementaires","cardNode":"","isChildCardTrackingEnabled":false,"parentAttribute":{"listCourriers":"{jalonCourrierReg}"},"recordId":"{recordId}","selectedState":"Active"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Block-Right","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"5","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"5","isResponsive":false},"sizeClass":"slds-size_5-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"type":"block","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"ParcoursDossier_Title","key":"element_element_block_3_0_outputField_0_0","name":"Text","parentElementKey":"element_block_3_0","property":{"card":"{card}","mergeField":"%3Cdiv%3E%3Cstrong%3E%3Cspan%20style=%22font-size:%2012pt;%22%3E&nbsp;%20&nbsp;Parcours%20du%20dossier%3C/span%3E%3C/strong%3E%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"#e5e5e5","image":"","position":"","repeat":"","size":""},"border":{"color":"#e5e5e5","radius":"","style":"","type":"","width":""},"class":"slds-p-bottom_x-small slds-p-top_x-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"bottom:x-small","size":"x-small","type":"bottom"},{"label":"top:x-small","size":"x-small","type":"top"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"background-color:#e5e5e5;     : #e5e5e5 1px solid; \n         ","text":{"align":"","color":""}},"type":"text","userUpdatedElementLabel":true},{"class":"slds-col ","element":"childCardPreview","elementLabel":"ParcoursDossier_FlexCard","key":"element_element_block_3_0_childCardPreview_1_0","name":"FlexCard","parentElementKey":"element_block_3_0","property":{"cardName":"SM_ParcoursDossier","cardNode":"","isChildCardTrackingEnabled":false,"parentAttribute":{"etatDemandeur":"{etatdemandedistributeur}","idPresta":"{idPrestation}","idStatut":"{idStatut}","jalonCourrierL1seul":"{jalonCourrierL1seul}","matchingL1":"{matchingL1}","noCourrier":"{noCourrier}"},"recordId":"{recordId}","selectedState":"Active"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Block-Parcours","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#e5e5e5","radius":"","style":"solid","type":"","width":"3"},"class":"slds-p-top_medium ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[{"label":"top:medium","size":"medium","type":"top"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #e5e5e5 3px solid; \n         ","text":{"align":"","color":""}},"type":"block","userUpdatedElementLabel":true}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#e5e5e5","radius":"","style":"bold","type":"","width":"3"},"class":"slds-card slds-p-around_x-small slds-m-bottom_x-small ","container":{"class":"slds-card"},"elementStyleProperties":{},"inlineStyle":"","margin":[{"label":"bottom:x-small","size":"x-small","type":"bottom"}],"padding":[{"label":"around:x-small","size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #e5e5e5 3px bold; \n         ","text":{"align":"","color":""}}}],"theme":"slds","title":"FlexCard_Recouvrement","xmlObject":{"apiVersion":48,"isExplicitImport":false,"masterLabel":"FlexCard_Recouvrement","runtimeNamespace":"vlocity_cmt","targetConfigs":"PHRhcmdldENvbmZpZyB0YXJnZXRzPSJsaWdodG5pbmdfX0FwcFBhZ2UiPg0KICAgICAgPHByb3BlcnR5IG5hbWU9ImRlYnVnIiB0eXBlPSJCb29sZWFuIi8+DQogICAgICA8cHJvcGVydHkgbmFtZT0icmVjb3JkSWQiIHR5cGU9IlN0cmluZyIvPg0KICAgIDwvdGFyZ2V0Q29uZmlnPg0KICAgIDx0YXJnZXRDb25maWcgdGFyZ2V0cz0ibGlnaHRuaW5nX19SZWNvcmRQYWdlIj4NCiAgICAgIDxwcm9wZXJ0eSBuYW1lPSJkZWJ1ZyIgdHlwZT0iQm9vbGVhbiIvPg0KICAgIDwvdGFyZ2V0Q29uZmlnPg0KICAgIDx0YXJnZXRDb25maWcgeG1sbnM9IiIgdGFyZ2V0cz0ibGlnaHRuaW5nQ29tbXVuaXR5X19EZWZhdWx0Ij4NCiAgICAgIDxwcm9wZXJ0eSBuYW1lPSJyZWNvcmRJZCIgdHlwZT0iU3RyaW5nIi8+DQogICAgPC90YXJnZXRDb25maWc+","targets":{"target":["lightning__RecordPage","lightning__AppPage","lightning__HomePage","lightningCommunity__Page","lightningCommunity__Default"]}},"Id":"a3t1v000001uG5qAAE","vlocity_cmt__GlobalKey__c":"FlexCard_Recouvrement/AKA/6/1631540396118","vlocity_cmt__IsChildCard__c":false};
  export default definition