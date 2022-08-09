({
    doInit : function(component, event, helper) {
        var action = component.get("c.getListCases");
        action.setParams({ 
            emailMessageId : component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.listCaseWrappers", response.getReturnValue());
                console.log(response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    handleClick : function(component, event, helper) {
        if(component.find("caseIdSelect").get("v.value") == ''){
            component.set("v.error", "Merci de choisir un case");
        }
        else{
            var action = component.get("c.updateEmailMessage");
            action.setParams({ 
                emailMessageId : component.get("v.recordId"),
                caseId : component.find("caseIdSelect").get("v.value")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var errorMessage = response.getReturnValue();
                    if(errorMessage != ''){
                        component.set("v.error", errorMessage);
                    }
                    else{
                        var workspaceAPI = component.find("workspace");
                        workspaceAPI.getFocusedTabInfo().then(function(response) {
                            var focusedTabId = response.tabId;
                            workspaceAPI.refreshTab({
                                tabId: focusedTabId,
                                includeAllSubtabs: true
                            });
                             $A.get("e.force:closeQuickAction").fire();
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                       
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            component.set("v.error", errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
    }
})