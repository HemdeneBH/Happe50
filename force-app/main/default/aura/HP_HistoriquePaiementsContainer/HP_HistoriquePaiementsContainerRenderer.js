({
    render : function(cmp, helper) {
        var ret = this.superRender();
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Historique paiements"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:payment_gateway",
                iconAlt: "Historique paiements"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
        return ret;
    }

})