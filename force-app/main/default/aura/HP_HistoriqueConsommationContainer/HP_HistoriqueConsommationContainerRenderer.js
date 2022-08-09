({

    render : function(cmp, helper) {
        var ret = this.superRender();
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Historique consommation"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:work_order_type",
                iconAlt: "Historique consommation"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
        return ret;
    }

})