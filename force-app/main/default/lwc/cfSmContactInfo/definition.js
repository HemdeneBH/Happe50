let definition =
      {"dataSource":{"contextVariables":[],"orderBy":{"isReverse":false,"name":""},"type":"Custom","value":{"body":" {\n    \"mobile\": \"06 93 02 93 22\",\n    \"email\": \"test2@email.com\",\n    \"address\": {\n      \"Adresse\": \"15 Allée Balthazar\",\n      \"ComplementAdresse\" : \"Batiment B\",\n      \"CodePostal\": \"37100\",\n      \"Pays\": \"France\",\n      \"Ville\": \"Tours\"\n    },\n    \"personal\": {\n      \"Civilite\": \"MLLE\",\n      \"Nom\": \"RJM\",\n      \"Prenom\": \"PREL TEST\"\n    },\n   \"idCompteClient\" : \"000521070939\"\n  }","dsDelay":"","resultVar":""}},"enableLwc":true,"isFlex":true,"lwc":{"DeveloperName":"cfSmContactInfo","Id":"0Rb5q000000oM1BCAU","MasterLabel":"cfSmContactInfo","NamespacePrefix":"c","ManageableState":"unmanaged"},"osSupport":true,"selectableMode":"Multi","states":[{"actions":[],"childCards":[],"components":{"layer-0":{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Name","name":"Field","property":{"card":"{card}","fieldName":"{personal.Civilite} {personal.Nom} {personal.Prenom}","placeholder":"","record":"{record}","type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-m-bottom_xx-large ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"font-weight : 700","margin":[{"label":"bottom:xx-large","size":"xx-large","type":"bottom"}],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         font-weight : 700","text":{"align":"","color":""}},"styleObjects":[{"conditionString":"","conditions":"default","draggable":false,"key":0,"label":"Default","name":"Default","styleObject":{"background":{"color":"","image":"","position":"","repeat":"","size":""},"border":{"color":"","radius":"","style":"","type":"","width":""},"class":"slds-m-bottom_xx-large ","container":{"class":""},"elementStyleProperties":{},"inlineStyle":"font-weight : 700","margin":[{"label":"bottom:xx-large","size":"xx-large","type":"bottom"}],"padding":[],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 ","style":"      \n         font-weight : 700","text":{"align":"","color":""}}}],"type":"element","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"flexIcon","elementLabel":"AddressBlock-Icon","key":"element_element_block_1_0_flexIcon_0_0","name":"Icon","parentElementKey":"element_block_1_0","property":{"card":"{card}","extraclass":"slds-icon_container slds-icon__svg--default ","iconName":"utility:home","iconType":"Salesforce SVG","imgsrc":"","record":"{record}","size":"medium","variant":"default"},"size":{"default":"1","isResponsive":false},"stateIndex":0,"styleObject":{"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 "},"type":"element","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"AddressBlock-Data-Street","key":"element_element_element_block_1_0_block_1_0_outputField_0_0","name":"Field","parentElementKey":"element_element_block_1_0_block_1_0","property":{"card":"{card}","fieldName":"{address.NoVoie} {address.Adresse}","label":"","placeholder":"","record":"{record}","type":"text"},"size":{"default":10,"isResponsive":false},"stateIndex":0,"styleObject":{"size":{"default":10,"isResponsive":false},"sizeClass":"slds-size_10-of-12"},"type":"element","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"AddressBlock-Data-Additional","key":"element_element_element_block_1_0_block_1_0_outputField_1_0","name":"Field","parentElementKey":"element_element_block_1_0_block_1_0","property":{"card":"{card}","data-conditions":{"group":[{"field":"address.ComplementAdresse","hasMergeField":false,"id":"state-new-condition-3","operator":"!=","type":"custom","value":""},{"field":"address.ComplementAdresse","hasMergeField":false,"id":"state-new-condition-8","logicalOperator":"&&","operator":"!=","type":"custom","value":"undefined"},{"field":"address.ComplementAdresse","hasMergeField":false,"id":"state-new-condition-18","logicalOperator":"&&","operator":"!=","type":"custom","value":"null"}],"id":"state-condition-object","isParent":true},"fieldName":"{address.ComplementAdresse}","label":"","placeholder":"","record":"{record}","type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 "},"type":"element","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"AddressBlock-Data-City","key":"element_element_element_block_1_0_block_1_0_outputField_2_0","name":"Field","parentElementKey":"element_element_block_1_0_block_1_0","property":{"card":"{card}","data-conditions":{"group":[],"id":"state-condition-object","isParent":true},"fieldName":"{address.CodePostal} {address.Ville}","label":"","placeholder":"","record":"{record}","type":"text"},"size":{"default":10,"isResponsive":false},"stateIndex":0,"styleObject":{"size":{"default":10,"isResponsive":false},"sizeClass":"slds-size_10-of-12"},"type":"element","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"AddressBlock-Data-IdCompteClient","key":"element_element_element_block_1_0_block_1_0_outputField_3_0","name":"Text","parentElementKey":"element_element_block_1_0_block_1_0","property":{"card":"{card}","data-conditions":{"group":[{"field":"idCompteClient","hasMergeField":false,"id":"state-new-condition-0","operator":"!=","type":"custom","value":""},{"field":"idCompteClient","hasMergeField":false,"id":"state-new-condition-4","logicalOperator":"&&","operator":"!=","type":"custom","value":"null"},{"field":"idCompteClient","hasMergeField":false,"id":"state-new-condition-14","logicalOperator":"&&","operator":"!=","type":"custom","value":"undefined"}],"id":"state-condition-object","isParent":true},"mergeField":"%3Cdiv%3E(%7BidCompteClient%7D)%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"text","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"AddressBlock-Data","key":"element_element_block_1_0_block_1_0","name":"Block","parentElementKey":"element_block_1_0","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"11","isResponsive":false},"stateIndex":0,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"size":{"default":"11","isResponsive":false},"sizeClass":"slds-size_11-of-12 "},"type":"block","userUpdatedElementLabel":true}],"class":"slds-col ","element":"block","elementLabel":"AddressBlock","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"6","isResponsive":false},"stateIndex":0,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"size":{"default":"6","isResponsive":false},"sizeClass":"slds-size_6-of-12 "},"type":"block","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"flexIcon","elementLabel":"PhoneMailBlock-Icon","key":"element_element_block_2_0_flexIcon_0_0","name":"Icon","parentElementKey":"element_block_2_0","property":{"card":"{card}","extraclass":"slds-icon_container slds-icon__svg--default ","iconName":"utility:identity","iconType":"Salesforce SVG","imgsrc":"","record":"{record}","size":"medium","variant":"default"},"size":{"default":"1","isResponsive":false},"stateIndex":0,"styleObject":{"size":{"default":"1","isResponsive":false},"sizeClass":"slds-size_1-of-12 "},"type":"element","userUpdatedElementLabel":true},{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"PhoneMailBlock-Email","key":"element_element_element_block_2_0_block_1_0_outputField_0_0","name":"Field","parentElementKey":"element_element_block_2_0_block_1_0","property":{"card":"{card}","data-conditions":{"group":[{"field":"email","hasMergeField":false,"id":"state-new-condition-0","operator":"!=","type":"custom","value":""},{"field":"email","hasMergeField":false,"id":"state-new-condition-30","logicalOperator":"&&","operator":"!=","type":"custom","value":"undefined"},{"field":"email","hasMergeField":false,"id":"state-new-condition-47","logicalOperator":"&&","operator":"!=","type":"custom","value":"null"}],"id":"state-condition-object","isParent":true},"fieldName":"{email}","placeholder":"","record":"{record}","type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12 "},"type":"element","userUpdatedElementLabel":true},{"class":"slds-col ","element":"outputField","elementLabel":"PhoneMailBlock-Field-3","key":"element_element_element_block_2_0_block_1_0_outputField_1_0","name":"Field","parentElementKey":"element_element_block_2_0_block_1_0","property":{"card":"{card}","data-conditions":{"group":[{"field":"mobile","hasMergeField":false,"id":"state-new-condition-2","operator":"!=","type":"custom","value":""},{"field":"mobile","hasMergeField":false,"id":"state-new-condition-7","logicalOperator":"&&","operator":"!=","type":"custom","value":"undefined"},{"field":"mobile","hasMergeField":false,"id":"state-new-condition-17","logicalOperator":"&&","operator":"!=","type":"custom","value":"null"}],"id":"state-condition-object","isParent":true},"fieldName":"{mobile}","placeholder":"","record":"{record}","type":"text"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element"}],"class":"slds-col ","element":"block","elementLabel":"PhoneMailBlock-Block-4","key":"element_element_block_2_0_block_1_0","name":"Block","parentElementKey":"element_block_2_0","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"11","isResponsive":false},"stateIndex":0,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"size":{"default":"11","isResponsive":false},"sizeClass":"slds-size_11-of-12 "},"type":"block"}],"class":"slds-col ","element":"block","elementLabel":"PhoneMailBlock","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"6","isResponsive":false},"stateIndex":0,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"size":{"default":"6","isResponsive":false},"sizeClass":"slds-size_6-of-12 "},"type":"block","userUpdatedElementLabel":true}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"class":"slds-card slds-p-around_x-small slds-m-bottom_x-small","container":{"class":"slds-card"},"margin":[{"size":"none","type":"around"}],"padding":[{"size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12"}}],"theme":"slds","title":"smContactInfo","Id":"a3t5q000000ocdJAAQ","vlocity_cmt__GlobalKey__c":"smContactInfo/SMILE/2/1649342648973","vlocity_cmt__IsChildCard__c":true};
  export default definition