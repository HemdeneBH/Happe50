/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 01-06-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
({
    helperMethod : function(component) {
        var recID = component.get("v.recordId");
        console.log('recID '+recID); 
        var action;
        if (component.get("v.operation") == "deletion"){
            action = component.get("c.suppressionUtilisateur");
            action.setParams({
                "utilisateurId":recID
            })
        }else if(component.get("v.operation") == "creation"){
            component.set("v.creation", true);
            action = component.get("c.creationUtilisateur"); 
            action.setParams({
                "utilisateurId":recID
            }) 
        }else{
            var action = component.get("c.modificationMDP");
            var newPassword = component.get("v.newPass");
            console.log("newPassword"+newPassword);
            action.setParams({
               "utilisateurId":recID,
               "newPassword":newPassword
           })
        }
        action.setCallback(this, function(response) {
            console.log("response" +JSON.stringify(response));
            console.log("state "+response.getState());  
            var state = response.getState();
            if(state === "SUCCESS"){
                var res = response.getReturnValue();
                console.log("successfully res "+ JSON.stringify(res));
                console.log("successfully callout "+ JSON.stringify(res.HP_Okta_Status__c));
                console.log("successfully callout "+ JSON.stringify(res.HP_Okta_Erreur__c)); 
                if(res.HP_Okta_Status__c === 'OK'){
                  
                    if(component.get("v.operation") == "deletion"){
                        component.find("recordHandler").deleteRecord($A.getCallback(function(deleteResult) {
                        if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                            console.log("Record is deleted.");
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                mode:'dismissible',
                                message: 'Succès.',
                                type :'success',
                                duration:'250'
                            });
                            resultsToast.fire();  
                        } else if (deleteResult.state === "INCOMPLETE") {
                            console.log("User is offline, device doesn't support drafts.");
                        } else if (deleteResult.state === "ERROR") {
                            console.log('Problem deleting record, error: ' + JSON.stringify(deleteResult.error));
                        } else {
                            console.log('Unknown problem, state: ' + deleteResult.state + ', error: ' + JSON.stringify(deleteResult.error));
                        }
                    }));
                   } else{
                    var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                mode:'dismissible',
                                message: 'Succès.',
                                type :'success',
                                duration:'250'
                            });
                            resultsToast.fire(); 
                   }
                   $A.get("e.force:closeQuickAction").fire();
                } 
                else{
                    console.log("Erreur : "+res.HP_Okta_Erreur__c);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        mode:'dismissible',
                        message: 'Une Erreur s\'est produite, Veuillez réessayer ultérieurement.',
                        type :'Warning',
                        duration:'250'
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire(); 
                }
            }else{
                console.log("Error callout");
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        mode:'dismissible',
                        message: 'Erreur Callout. Veuillez réessayer ultérieurement.',
                        type :'Error',
                        duration:'250'
                    });
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire(); 
            }
        });
        $A.enqueueAction(action);
    },

    showSpinner: function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},

	hideSpinner : function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
	},
   
})