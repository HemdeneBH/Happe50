/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 06-18-2021
 * @last modified by  : Hemdene Ben Hammouda
 * Modifications Log 
 * Ver   Date         Author                 Modification
 * 1.0   06-15-2021   Hemdene Ben Hammouda   Initial Version
**/
({
    init : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var hprefclient = myPageRef.state.c__hprefclient;
        var currentPDL = myPageRef.state.c__currentPDL;
        var currentPCE = myPageRef.state.c__currentPCE;
        var idContratGaz = myPageRef.state.c__idContratGaz;
        var idContratElec = myPageRef.state.c__idContratElec;
        var contratLocaux = myPageRef.state.c__contratLocaux;
        component.set("v.hprefclient", hprefclient);
        component.set("v.currentPDL", currentPDL);
        component.set("v.currentPCE", currentPCE);
        component.set("v.idContratGaz", idContratGaz);
        component.set("v.idContratElec", idContratElec);
        component.set("v.contratLocaux", contratLocaux);
    }
})