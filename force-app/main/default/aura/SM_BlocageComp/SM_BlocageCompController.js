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
                label: "Info blocage"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "standard:dashboard",
                iconAlt: "Info blocage",
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    handlecloseBlocage: function(component, event) {
        console.log('start close');
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
    }
})