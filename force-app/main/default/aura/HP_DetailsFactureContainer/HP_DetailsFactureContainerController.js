/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 08-20-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
({
    init : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var currentFacture = myPageRef.state.c__currentFacture;
        var consommationData = myPageRef.state.c__consommationData; 
        component.set("v.currentFacture", currentFacture);
        component.set("v.consommationData", consommationData);
    }
})