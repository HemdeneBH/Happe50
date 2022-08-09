({
	openTabWithSubtab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        console.log('openTab');
        
        workspaceAPI.openTab({
            pageReference: {
                'type': 'standard__component',
                'attributes': {
                    'componentName': 'c__HP_CreationFicheClientComp',
                },
                'state': {}
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.focusTab({tabId : response});
       })
        .catch(function(error) {
            console.log(error);
        });
        $A.get("e.force:closeQuickAction").fire();
    }
})