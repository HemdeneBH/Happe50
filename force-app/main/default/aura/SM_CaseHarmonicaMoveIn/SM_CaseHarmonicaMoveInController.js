({
    
    doInit: function(component) {
    },
    
    openMovein : function(component, event) {
        
        var workspaceAPI = component.find("workspace");
        
        var action2 = component.get("c.updateCaseStatus");
        action2.setParams({ caseId : component.get("v.recordId") });
        
        var action = component.get("c.getData");
        action.setParams({ caseId : component.get("v.recordId") });
        
        action.setCallback(this, function(a) {
            
            component.set("v.moveinData", a.getReturnValue());
            console.log(a.getReturnValue());
            var moveindata = JSON.stringify(a.getReturnValue().data);
            workspaceAPI.openTab({
                url: '/apex/SM_VFP_MoveInRef?harmonicaCaseid='+component.get("v.recordId")+'&moveinContext=harmonica&callType=New&ContextId='+a.getReturnValue().data.CaseId__r.ContactId+'&moveinData='+moveindata+'&harmonicaBankDetailsId='+a.getReturnValue().harmonicaBankDetailsId,
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
        $A.enqueueAction(action2);
    }
})