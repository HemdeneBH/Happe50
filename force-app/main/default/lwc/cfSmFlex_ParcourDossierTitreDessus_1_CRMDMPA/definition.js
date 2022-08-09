let definition =
      {"dataSource":{"contextVariables":[],"orderBy":{"isReverse":false,"name":""},"type":"Custom","value":{"body":" [\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Créance transférée\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":true,\n           \"isGrey\":false,\n           \"isFirst\":true,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"ValidatedStep\",\n           \"EtapeNumber\":\"1\",\n\t\t   \"listButtons\" : [\n\t\t\t{\n\t\t\t\"label\" : \"LabelButton\",\n\t\t\t\"action\" : \"actionTest\"\n\t\t\t},\n\t\t\t{\n\t\t\t\"label\" : \"LabelButton2\",\n\t\t\t\"action\" : \"actionTest\"\n\t\t\t}\n\t\t   ]\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Courrier réglementaire #1\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"2\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Courrier réglementaire #2\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"3\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":\"Interruption de la procédure\",\n           \"title\":\"Client éligible à la coupure\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":false,\n           \"isFirst\":false,\n           \"isError\":true,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"ErrorStep\",\n           \"EtapeNumber\":\"4\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Demande de coupure/réduction de puissance\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"5\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Client coupé/en réduction de puissance\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"6\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Client éligible à la résiliation pour non paiement\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"7\",\n\t\t   \"listButtons\" : []\n        },\n        {\n           \"title_Dessus\":null,\n           \"title\":\"Client résilié pour non paiement\",\n           \"stepNumber\":null,\n           \"listButtons\":null,\n           \"isSuccess\":false,\n           \"isGrey\":true,\n           \"isFirst\":false,\n           \"isError\":false,\n           \"isCurrent\":false,\n           \"EtapeStatus\":\"GreyStep\",\n           \"EtapeNumber\":\"8\",\n\t\t   \"listButtons\" : []\n        }\n     ]","resultVar":""}},"enableLwc":true,"isFlex":true,"lwc":{"DeveloperName":"cfSmFlex_ParcourDossierTitreDessus_1_CRMDMPA","Id":"0Rb8E000000HeuTSAS","ManageableState":"unmanaged","MasterLabel":"cfSmFlex_ParcourDossierTitreDessus_1_CRMDMPA","NamespacePrefix":"c"},"states":[{"actions":[],"childCards":[],"components":{"layer-0":{"children":[{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Block-0-title_Dessus-0","key":"element_element_block_1_0_outputField_0_0","name":"title_Dessus","property":{"card":"{card}","data-conditions":{"group":[{"field":"title_Dessus","id":"state-new-condition-35","operator":"!=","type":"custom","value":""}],"id":"state-condition-object","isParent":true},"fieldName":"title_Dessus","label":"","placeholder":"","record":"{record}","type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-text-align_center ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"center","color":""}},"type":"field","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"Block-1","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}},"type":"block"}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-card ","container":{"class":"slds-card"},"elementStyleProperties":{},"inlineStyle":"","margin":[],"padding":[],"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 ","style":"     : #ccc 1px solid; \n         ","text":{"align":"","color":""}}}],"theme":"slds","title":"smFlex_ParcourDossierTitreDessus","Id":"a3t1v000001uFqVAAU","vlocity_cmt__GlobalKey__c":"smFlex_ParcourDossierTitreDessus/CRMDMPA/1/1626362079526","vlocity_cmt__IsChildCard__c":true};
  export default definition