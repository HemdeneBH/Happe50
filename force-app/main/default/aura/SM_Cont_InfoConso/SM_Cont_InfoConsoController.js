({
    init : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        console.log("workspaceAPI" + workspaceAPI);
        workspaceAPI.getAllTabInfo().then(function(response) {
            //renommer le nom du tab
            console.log("response"+response.subtabs);
            if(response!==null && response.subtabs!==undefined){
                console.log("substab"+response);
                var focusedTabId = response.subtabs[response.subtabs.length-1].tabId;
            }else{
                console.log("tabId"+response.tabId);
                var focusedTabId = response.tabId;
            }
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Infos conso"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "standard:dashboard",
                iconAlt: "Infos conso",
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    handleFilterChange: function(component, event) {
        var CloseClicked = event.getParam('close');
        component.set('v.message', 'Close Clicked');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.disableTabClose({
                tabId: focusedTabId,
                disabled: false
            })
            .catch(function(error) {
                console.log(error);
            });
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    openInteraction: function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {             
            var urlOmni = '/apex/SM_VFP_TraceInteractionLWC?id='+component.get("v.recordId")+
            + '&isActivateTracerInteractionOS=' + (event.getParam('isActivateTracerInteractionOS') || '')
            + '&isCasNominal=' + (event.getParam('isCasNominal') || '')
            + '&isPauseInteraction=' + (event.getParam('isPauseInteraction') || '')
            + '&DRId_Case=' + (event.getParam("DRId_Case") || '')
            + '&StepNameOS=' + (event.getParam("StepNameOS") || '')
            + '&refClientIdBP=' + (event.getParam("refClientIdBP") || '')
            + '&isLWC=' + (event.getParam("isLWC") || '')
            + '&ContextId=' + component.get("v.recordId");
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "TraceInteraction"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openContestationIndex: function(component, event) {
        console.log("contestation index");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {             
            var urlOmni = '/apex/SM_VFP_ContestationIndex?id='+component.get("v.recordId")
            + '&ContextId=' + component.get("v.recordId")
            + '&type=' + (event.getParam('type') || '')
            + '&contestGaz=' + (event.getParam('contestGaz') || '')
            + '&donneesDerniersIndexReelGaz=' + (event.getParam('donneesDerniersIndexReelGaz') || '')
            + '&contestElec=' + (event.getParam('contestElec') || '')
            + '&nombreRoue=' + event.getParam('nombreRoue')
            + '&idBusinessPartner=' + event.getParam('idBusinessPartner')
            + '&pce=' + event.getParam('pce')
            + '&pdlCommunicantGaz=' + event.getParam('pdlCommunicantGaz')
            + '&factureEnLigne=' + event.getParam('factureEnLigne')
            + '&uniteReleveGaz=' + event.getParam('uniteReleveGaz');
            // + '&isDual=' + (event.getParam('isDual') || '');
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "contest. index"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    }
})