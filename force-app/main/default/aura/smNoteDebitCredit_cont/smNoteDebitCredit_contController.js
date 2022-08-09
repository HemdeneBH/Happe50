({
	/*myAction : function(component, event, helper) {


	}*/
    init : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            //renommer le nom du tab
            if(response!==null&&response.subtabs!==undefined){
                var focusedTabId = response.subtabs[response.subtabs.length-1].tabId;
            }else{
                var focusedTabId = response.tabId;
            }
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Notes débit/crédit"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "standard:dashboard",
                iconAlt: "Notes débit/crédit",
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    handlecloseTabEvent: function(component, event) {


        var CloseClicked = event.getParam('close');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            if (response.closeable) {
                workspaceAPI.closeTab({tabId: focusedTabId});
            } else {
                workspaceAPI.disableTabClose({
                    tabId: focusedTabId,
                    disabled: false})
                .then(function(res){
                    workspaceAPI.closeTab({tabId: focusedTabId});
                })
            }
        })
        .catch(function(error) {
            console.log(error);
        });


    },
    openInteraction : function(component, event) {
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
            + '&ineligibiliteDP=' + (event.getParam("ineligibiliteDP") || '')
            + '&descriptionTraceInteraction='+(event.getParam("descriptionTraceInteraction") || '')
            + '&ContextId=' + component.get("v.recordId")
            +'&EnqSat='+ component.get('v.EnqSat');
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
    }
})