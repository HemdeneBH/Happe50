({
    init: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: 'Infos Perso'
            });
            workspaceAPI.setTabIcon({
                icon: "action:record",
                iconAlt: "Modification"
            });
        })
     },
    
    handleFilterChange: function(component, event) {
        var CloseClicked = event.getParam('close');
        component.set('v.message', 'Close Clicked');
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    closeModel : function(component, event, helper) {
        let a= document.getElementById('modal-content-id-1')
        window.history.back();


    },


    
})