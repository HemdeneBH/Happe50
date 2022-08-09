({

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
                label: "SYNTHESE DES DELAIS DE PAIEMENT"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "standard:dashboard",
                iconAlt: "SYNTHESE DES DELAIS DE PAIEMENT",
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    handlecloseDPTabEvent: function(component, event) {


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
        console.log('hello Event !');
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
            + '&ContextId=' + component.get("v.recordId")
            +'&EnqSat='+ component.get('v.EnqSat');

            if (event.getParam("descriptionTraceInteraction") && event.getParam("descriptionTraceInteraction").length > 0) {
                urlOmni = urlOmni + '&descriptionTraceInteraction=' + event.getParam("descriptionTraceInteraction");
            }
            if (event.getParam("ineligibiliteDP") && event.getParam("ineligibiliteDP").length > 0) {
                urlOmni = urlOmni + '&ineligibiliteDP=' + event.getParam("ineligibiliteDP");
            }
            if (event.getParam("updateStatusTask") && event.getParam("updateStatusTask")==true) {
                console.log('updateStatus'+event.getParam("updateStatusTask"));
                urlOmni = urlOmni + '&updateStatusTask=' + event.getParam("updateStatusTask");
            }
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
    handleFilterChange: function(component, event) {
        var CloseClicked = event.getParam('close');
        //component.set('v.message', 'Close Clicked');
        
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
})