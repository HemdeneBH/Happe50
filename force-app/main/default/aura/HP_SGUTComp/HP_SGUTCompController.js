({
    doInit  : function(component, event, helper) {
        if(component.get("v.operation") == "creation"){
            helper.showSpinner(component);
            helper.helperMethod(component);   
        }else if (component.get("v.operation") == "deletion"){
            component.set("v.deletion", true);
        }else{
            component.set("v.modification", true);
        }
    },

    submitPassword : function(component, event, helper){
        var regularExpression =  new RegExp('((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9\\r\\n\\t\\f\\v]).{8,})');
        console.log('regex '+regularExpression.test(component.get("v.newPass")));
        if(regularExpression.test(component.get("v.newPass"))){
            helper.showSpinner(component);
            helper.helperMethod(component);
        } 
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Attention",
                "type": "warning",
                "message": "Format du mot de passe non respecté"
            });
            toastEvent.fire();
        }
    },

    submitYes : function(component, event, helper){
        helper.showSpinner(component);
        helper.helperMethod(component);
    },

    submitNo : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})