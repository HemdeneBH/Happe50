let definition =
      {"dataSource":{"contextVariables":[],"orderBy":{"isReverse":false,"name":""},"type":"Custom","value":{"body":"[\n\n  {\n\n    \"Date\": \"2020-02-19T00:00:00\",\n\n    \"nom\": \"Prest : p�nalit� de retard calcul�e\",\n\n    \"code\": \"INF\"\n\n  },\n\n  {\n\n    \"Date\": \"2020-01-19T00:00:00\",\n\n    \"nom\": \"Prest : p�nalit� de retard calcul�e\",\n\n    \"code\": \"INF\"\n\n  },\n\n  {\n\n    \"Date\": \"2019-09-25T00:00:00\",\n\n    \"nom\": \"Prest : Priorisation de coupure\",\n\n    \"code\": \"INF\"\n\n  },\n\n  {\n\n    \"Date\": \"2019-09-23T00:00:00\",\n\n    \"nom\": \"Prest : Priorisation de coupure\",\n\n    \"code\": \"INF\"\n\n  },\n\n  {\n\n    \"Date\": \"2019-05-23T00:00:00\",\n\n    \"nom\": \"Prest : Priorisation de coupure\",\n\n    \"code\": \"INF\"\n\n  },\n\n  {\n\n    \"Date\": \"2019-01-23T00:00:00\",\n\n    \"nom\": \"Prest : Priorisation de coupure\",\n\n    \"code\": \"INF\"\n\n  }\n\n]","resultVar":""}},"enableLwc":true,"isFlex":true,"isRepeatable":false,"lwc":{"DeveloperName":"cfSM_Recouvrement_ServiceRecouvrement_6_CRMDMPA","Id":"0Rb5E0000001BMQSA2","ManageableState":"unmanaged","MasterLabel":"cfSM_Recouvrement_ServiceRecouvrement_6_CRMDMPA","NamespacePrefix":"c"},"osSupport":true,"states":[{"actions":[],"childCards":[],"components":{"layer-0":{"children":[{"class":"slds-col ","element":"dataTable","elementLabel":"Datatable-0","name":"Datatable","property":{"cellLevelEdit":true,"columns":[{"fieldName":"Date","format":"DD/MM/YYYY","label":"Date","searchable":false,"sortable":true,"type":"date"},{"fieldName":"nom","label":"nom","searchable":false,"sortable":true,"type":"text"}],"groupOrder":"asc","issearchavailable":false,"issortavailable":true,"pagelimit":3,"records":"{records}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element"},{"children":[],"class":"slds-col ","element":"block","elementLabel":"Block-1","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"sizeClass":"slds-size_12-of-12"},"type":"block"},{"class":"slds-col ","element":"customLwc","elementLabel":"Custom LWC-2","name":"Custom LWC","property":{"customlwcname":"sM_Recouvrement_ModifBlocage"},"size":{"default":"12","isResponsive":false},"stateIndex":0,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element"}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"class":"slds-card slds-p-around_x-small slds-m-bottom_x-small","container":{"class":"slds-card"},"margin":[{"size":"none","type":"around"}],"padding":[{"size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12"}},{"actions":[],"blankCardState":true,"childCards":[],"components":{"layer-0":{"children":[{"class":"slds-col ","element":"outputField","elementLabel":"Text-0","name":"Text","property":{"card":"{card}","mergeField":"%3Cdiv%20class=%22slds-text-color_destructive%22%3EPas%20d'information%20disponible%3C/div%3E","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"text"},{"children":[],"class":"slds-col ","element":"block","elementLabel":"Block-1","name":"Block","property":{"card":"{card}","collapsedByDefault":false,"collapsible":false,"label":"Block","record":"{record}"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"class":"slds-p-around_x-small","padding":[{"size":"x-small","type":"around"}],"sizeClass":"slds-size_12-of-12"},"type":"block"},{"class":"slds-col ","element":"customLwc","elementLabel":"Custom LWC-2","name":"Custom LWC","property":{"customlwcname":"sM_Recouvrement_ModifBlocage"},"size":{"default":"12","isResponsive":false},"stateIndex":1,"styleObject":{"sizeClass":"slds-size_12-of-12"},"type":"element"}]}},"conditions":{"group":[],"id":"state-condition-object","isParent":true},"definedActions":{"actions":[]},"documents":[],"fields":[],"isSmartAction":false,"name":"Active","omniscripts":[],"smartAction":{},"styleObject":{"class":"slds-card slds-p-around_x-small slds-m-bottom_x-small","container":{"class":"slds-card"},"margin":[{"size":"none","type":"around"}],"padding":[{"size":"x-small","type":"around"}],"size":{"default":"12","isResponsive":false},"sizeClass":"slds-size_12-of-12"}}],"theme":"slds","title":"SM_Recouvrement_ServiceRecouvrement","xmlJson":[{"@attributes":{"targets":"lightning__AppPage"},"property":[{"@attributes":{"name":"debug","type":"Boolean"}},{"@attributes":{"name":"recordId","type":"String"}}]},{"@attributes":{"targets":"lightning__RecordPage"},"property":[{"@attributes":{"name":"debug","type":"Boolean"}}]}],"xmlObject":{"targetConfigs":"PHRhcmdldENvbmZpZyB0YXJnZXRzPSJsaWdodG5pbmdfX0FwcFBhZ2UiPgogICAgICAgICAgICAgICAgICAgICAgPHByb3BlcnR5IG5hbWU9ImRlYnVnIiB0eXBlPSJCb29sZWFuIi8+CiAgICAgICAgICAgICAgICAgICAgICA8cHJvcGVydHkgbmFtZT0icmVjb3JkSWQiIHR5cGU9IlN0cmluZyIvPgogICAgICAgICAgICAgICAgICA8L3RhcmdldENvbmZpZz4KICAgICAgICAgICAgICAgICAgPHRhcmdldENvbmZpZyB0YXJnZXRzPSJsaWdodG5pbmdfX1JlY29yZFBhZ2UiPgogICAgICAgICAgICAgICAgICAgICAgPHByb3BlcnR5IG5hbWU9ImRlYnVnIiB0eXBlPSJCb29sZWFuIi8+CiAgICAgICAgICAgICAgICAgIDwvdGFyZ2V0Q29uZmlnPg==","targets":{"target":["lightning__RecordPage","lightning__AppPage","lightning__HomePage"]}},"Id":"a3t1v000001uFq2AAE","vlocity_cmt__GlobalKey__c":"SM_Recouvrement_ServiceRecouvrement/CRMDMPA/6/1626103927743","vlocity_cmt__IsChildCard__c":true};
  export default definition