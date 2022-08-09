({

    render : function(cmp, helper) {
        var ret = this.superRender();
        var workspaceAPI = cmp.find("workspace");
        var myPageRef = cmp.get("v.pageReference");
        var currentFacture = myPageRef.state.c__currentFacture;
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: currentFacture.ref_facture
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:work_order_type",
                iconAlt: "Détails Facture"
            });
        })
        .catch(function(error) {
            console.log(error);
        });
        return ret;
    }

})