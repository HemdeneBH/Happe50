({
	invoke : function(component, event, helper) {
		console.log('on est dans l action');
		var workspaceAPI = component.find("workspace");
		workspaceAPI.getFocusedTabInfo().then(function(response) {
			var focusedTabId = response.tabId;
			workspaceAPI.closeTab({tabId: focusedTabId});
		})
		.catch(function(error) {
			console.log(error);
		});
	}
})