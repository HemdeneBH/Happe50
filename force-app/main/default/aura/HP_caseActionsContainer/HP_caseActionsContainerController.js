/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-27-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
({
    doInit: function(component, event, helper) {
        let action = component.get("c.loadButtons");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.buttons", response.getReturnValue().filter(element => element.HP_Is_Active__c == true));
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    handleClick : function(component, event, helper) {
        component.set("v.showSpinner",true);
        const componentName = event.getSource().get("v.value");
        let buttonOrder = event.getSource().get("v.name");
        let buttonsDisplayed = component.get("v.buttons");
        let currentButton = buttonsDisplayed.filter(element => element.HP_Order__c == buttonOrder);
        const recordId = component.get('v.recordId');
        if(currentButton[0].HP_Type__c ==="LWC"){
            if(currentButton[0].HP_Has_Paramater__c === true){
                console.log("record ID : "+recordId);
                $A.createComponent(
                    "c:" + componentName,
                    {
                        oncloseupdate : component.getReference("c.closeModel"),
                        recordId : recordId
                    },
                    function(creationComponent, status, errorMessage){
                        if (status === "SUCCESS") {
                            component.set("v.creationComponent", creationComponent);
                            component.set("v.showSpinner",false);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.");
                        }
                            else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                            }
                    }
                );
            }else {
                $A.createComponent(
                    "c:" + componentName,
                    {
                        oncloseupdate : component.getReference("c.closeModel")
                    },
                    function(creationComponent, status, errorMessage){
                        if (status === "SUCCESS") {
                            component.set("v.creationComponent", creationComponent);
                            component.set("v.showSpinner",false);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.");
                        }
                            else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                            }
                    }
                );
            }
            component.set("v.isLWC",true);
            component.set("v.isFlow",false);
            component.set("v.isModalOpen",true);
        }else if(currentButton[0].HP_Type__c ==="Flow"){
            component.set("v.isFlow",true);
            component.set("v.isLWC",false);
            component.set("v.isModalOpen",true);
            const flow = component.find("flowData");
            console.log("flow : "+flow);
            console.log("record id  : "+component.get("v.recordId"));
            var inputVariables = [
                { name : "recordId", 
                  type : "String", 
                  value: component.get("v.recordId")
                }       
              ]
            flow.startFlow(componentName,inputVariables);
            component.set("v.showSpinner",false);
        }
    },
    closeModel : function(component, event, helper) {
        component.set("v.isModalOpen",false);
        component.set("v.isFlow",false);
        component.set("v.isLWC",false);
        component.set("v.creationComponent", null);
        component.set("v.showSpinner",false);
    }
})