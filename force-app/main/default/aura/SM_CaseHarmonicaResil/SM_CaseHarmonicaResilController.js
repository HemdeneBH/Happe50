({
    doInit : function(component, event, helper) {
	},
	openResil : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var action = component.get("c.getContactId");
        action.setParams({ caseId : component.get("v.recordId") });
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());
		workspaceAPI.openTab({
            url: '/apex/SM_VFP_Resiliation?CaseId='+component.get("v.recordId")+'&ContextId='+a.getReturnValue(),
			focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(tabInfo) {
            console.log("The recordId for this tab is: " + tabInfo.recordId);
            });
        }).catch(function(error) {
                console.log(error);
        });
        });
        $A.enqueueAction(action);
	}
})