({
    init : function(component, event, helper) {
       
        var action1 = component.get("c.diabolocomViewAdminFieldPermission");
        
	    
	    action1.setCallback(this, function(response) {
	        var state = response.getState();
	        if (state === "SUCCESS") {
                component.set('v.hasDiabPermission', response.getReturnValue());
                var action = component.get("c.getLastTaskFromCaseId");
                action.setParams({ 
                    "caseId": component.get('v.recordId')
                });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();

                    if (state === "SUCCESS" && response.getReturnValue() != null) {
                        component.set('v.taskDisplay', true);

                        component.set('v.lastTask', response.getReturnValue());
                        
                    }
                });
                $A.enqueueAction(action);
	        }
	    });
	    $A.enqueueAction(action1);
    },
    editTask: function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get('v.lastTask').Id
        });
        editRecordEvent.fire();
    }
})