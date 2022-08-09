let definition =
      {"dataSource":{"contextVariables":[],"orderBy":{"isReverse":false,"name":""},"type":"Custom","value":{"body":" [\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Créance transférée\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":true,\n           \"isGrey\":false,\n           \"isFirst\":true,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"ValidatedStep\",\n           \"EtapeNumber\":\"1\",\n\t\t   \"listButtons\" : [\n\t\t\t{\n\t\t\t\"label\" : \"LabelButton\",\n\t\t\t\"action\" : \"actionTest\"\n\t\t\t},\n\t\t\t{\n\t\t\t\"label\" : \"LabelButton2\",\n\t\t\t\"action\" : \"actionTest\"\n\t\t\t}\n\t\t   ]\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Courrier réglementaire #1\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"2\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Courrier réglementaire #2\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"3\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":\"Interruption de la procédure\",\n           \"title\":\"Client éligible à la coupure\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":false,\n           \"isFirst\":false,\n           \"isError\":true,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"ErrorStep\",\n           \"EtapeNumber\":\"4\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Demande de coupure/réduction de puissance\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"5\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Client coupé/en réduction de puissance\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"6\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Client éligible à la résiliation pour non paiement\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"7\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Client résilié pour non paiement\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"8\",\n\t\t   \"listButtons\" : []\n        }\n     ]","resultVar":""}},"enableLwc":true,"isFlex":true,"isRepeatable":true,"lwc":{"DeveloperName":"cfSmFlex_ParcourDossierTitre_1_CRMDMPA","Id":"0Rb3O000000BEbnSAG","ManageableState":"unmanaged","MasterLabel":"cfSmFlex_ParcourDossierTitre_1_CRMDMPA","NamespacePrefix":"c"},"states":[{"actions":[],"childCards":["SM_ParcoursDossierButtons"],"components":{"layer-0":{"children":[{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Block-1-title","key":"element_element_block_0_0_outputField_0_0","name":"title_Dessus","parentElementKey":"element_block_0_0","property":{"card":"{card}","data-conditions":{"group":[{"field":"title","id":"state-new-condition-28","operator":"!=","type":"custom","value":""}],"id":"state-condition-object","isParent":true},"fieldName":"title","label":"","placeholder":"","record":"{record}","styles":{"label":{"textAlign":"center"}},"type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-text-align_center ","container":{"class":""},"elementStyleProperties":{"styles":{"label":{"textAlign":"center"}}},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"center","color":""}},"type":"field","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"Block-0-Text-2","key":"element_element_block_0_0_outputField_1_0","name":"Text","parentElementKey":"element_block_0_0","property":{"card":"{card}","data-conditions":{"group":[{"field":"datePresta","id":"state-new-condition-42","operator":"!=","type":"custom","value":"null"}],"id":"state-condition-object","isParent":true},"mergeField":"%3Cdiv%20class=%22slds-text-align_center%22%3EDate%20de%20prestation%20de%20la%20demande%3C/div%3E%0A%3Cdiv%20class=%22slds-text-align_center%22%3E%7BdatePresta%7D%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"mix-blend-mode: normal;\nborder: 1px solid #C1C0C0;\nbox-sizing: border-box;\nborder-radius: 7px;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #cccccc 1px solid; \n         mix-blend-mode: normal;\nborder: 1px solid #C1C0C0;\nbox-sizing: border-box;\nborder-radius: 7px;","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"#cccccc","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"mix-blend-mode: normal;\nborder: 1px solid #C1C0C0;\nbox-sizing: border-box;\nborder-radius: 7px;","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #cccccc 1px solid; \n         mix-blend-mode: normal;\nborder: 1px solid #C1C0C0;\nbox-sizing: border-box;\nborder-radius: 7px;","text":{"align":"","color":""}}}],"type":"text"},{"class":"slds-col ","element":"childCardPreview","elementLabel":"Block-0-FlexCard-3","key":"element_element_block_0_0_childCardPreview_2_0","name":"FlexCard","parentElementKey":"element_block_0_0","property":{"cardName":"SM_ParcoursDossierButtons","cardNode":"listButtons","data-conditions":{"group":[{"field":"listButtons","id":"state-new-condition-19","operator":"!=","type":"custom","value":""}],"id":"state-condition-object","isParent":true},"isChildCardTrackingEnabled":false,"parentAttribute":{"CaseId":"{Parent.CaseId}","civilite":"{Parent.civilite}","iddistributeur":"{Parent.iddistributeur}","iddossiercoupure":"{Parent.iddossiercoupure}","idfournisseur":"{Parent.idfournisseur}","idsap":"{Parent.idsap}","lButtons":"{listButtons}","loginuser":"{Parent.loginuser}","nom":"{Parent.nom}","prenom":"{Parent.prenom}","telephonefixe":"{Parent.telephonefixe}","telephonemobile":"{Parent.telephonemobile}"},"recordId":"{recordId}","selectedState":"Active"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-m-bottom_xxx-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[{"label":"bottom:xxx-small","size":"xxx-small","type":"bottom"}],"maxHeight":"","padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-m-bottom_xxx-small ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[{"label":"bottom:xxx-small","size":"xxx-small","type":"bottom"}],"maxHeight":"","padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}}}],"type":"element"}],"class":"slds-col ","element":"block","elementLabel":"Block-0","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"type":"block"}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-card flexCard_Class{ width:12.5%; }","container":{"class":"slds-card"},"customClass":"flexCard_Class{ width:12.5%; }","elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}}}],"theme":"slds","title":"smFlex_ParcourDossierTitre","Id":"a3t1v000001uFqQAAU","vlocity_cmt__GlobalKey__c":"smFlex_ParcourDossierTitre/CRMDMPA/1/1626187278156","vlocity_cmt__IsChildCard__c":true};
  export default definition