({
    openOutilEstimation: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url:'/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactOutilEstimationFrench&c__layout=lightning&c__tabIcon=custom:custom18',
            label : "Outil Estimation",
            focus: true
            
        }).then(function(response) {
            workspaceAPI.focusTab({tabId : response});
            
        }).catch(function(error) {
            console.log(error);
        });
    } ,
    
    
    onRender: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})