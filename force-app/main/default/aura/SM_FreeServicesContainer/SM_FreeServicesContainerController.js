({
    handleCloseFreeServicesTab: function(component) {
    var workspaceAPI = component.find("workspace");
    workspaceAPI.openTab({
        recordId: component.get("v.recordId"),
        focus: true
    }).then(function(newTabId){
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId =newTabId ;
            if (response.closeable) {
                workspaceAPI.closeTab({tabId: focusedTabId});
                workspaceAPI.focusTab(newTabId);
            } else {
                workspaceAPI.disableTabClose({
                    tabId: focusedTabId,
                    disabled: false})
                .then(function(res){
                    workspaceAPI.closeTab({tabId: focusedTabId});
                    workspaceAPI.focusTab(newTabId);
                })
            }
        })
        .catch(function(error) {
            console.log(error);
            });
        });
    }
})