({
    doInit : function(component, event, helper) {
	},
	openCHO : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");


/*
        var action = component.get("c.getContactId");
        action.setParams({ caseId : component.get("v.recordId") });
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());


		workspaceAPI.openTab({
            url: '/apex/SM_VFP_ChangementOffre?CaseId='+component.get("v.recordId")+'&ContextId='+a.getReturnValue()+'&harmonicaBankDetailsId='+a.getReturnValue().harmonicaBankDetailsId,




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

       
        */
         var action = component.get("c.getDataCHO");
        action.setParams({ caseId : component.get("v.recordId") });
        action.setCallback(this, function(a) {
            console.log(a.getReturnValue());


		workspaceAPI.openTab({
            url: '/apex/SM_VFP_ChangementOffre?CaseId='+component.get("v.recordId")+'&ContextId='+a.getReturnValue().contactId+'&harmonicaBankDetailsId='+a.getReturnValue().harmonicaBankDetailsId+'&IdBusinessPartner='+a.getReturnValue().clientBPId,




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