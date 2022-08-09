({
    handleCloseSubTab: function(component) {
        component.set('v.message', 'Close Clicked');
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