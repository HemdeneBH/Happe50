({
    openCoords : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/vlocity_cmt__OmniScriptUniversalPage?id='+component.get("v.recordId")+'&OmniScriptType=Contact&OmniScriptSubType=ModifyInformations&OmniScriptLang=English&PrefillDataRaptorBundle=&scriptMode=vertical&layout=lightning&ContextId=' + component.get("v.recordId"),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Infos perso"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openEditTitulaire : function(component, event) {
        console.log('ouvertureTitulaireCompteEdit')
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_TitulaireCompte?id='+component.get("v.recordId")

                +'&ContextId=' + component.get("v.recordId")

                +'&test=' + event.getParam('test'),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Modif Titulaire Contrat"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });


    },
        // Services gratuits
        openFreeServices : function(component, event) {
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getEnclosingTabId().then(function(tabId) {
                workspaceAPI.openSubtab({
                    parentTabId: tabId,
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__SM_FreeServicesContainer"
                        },
                            "state": {
                            uid:"1",  
                            c__edocumentstatus: event.getParam('eDocumentStatus'),
                            c__felstatus: event.getParam('felStatus'),
                            c__customerareaunavailable: event.getParam('customerAreaUnavailable'),

                            c__noemail: event.getParam('noEmail'),
                            c__recordid: event.getParam('recordId'),
                            c__accountcontract: event.getParam('accountContract')

                        }
                    }, 
                    focus: true
                }).then(function(subtabId) {
                    workspaceAPI.setTabLabel({
                        tabId:subtabId,
                        label: "Services Gratuits"});
                }).catch(function(error) {
                            console.log(error);
                });
            }).catch(function(error) {
                console.log(error);
            });


    }
})