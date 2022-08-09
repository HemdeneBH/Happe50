({
    init : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var pfcdata = myPageRef.state.c__pfcdata;
        var contratLocaux = myPageRef.state.c__contratLocaux;
        var idContratGaz = myPageRef.state.c__idContratGaz;
        var idContratElec = myPageRef.state.c__idContratElec;
        var consommationData = myPageRef.state.c__consommationData; 
        component.set("v.pfcdata", pfcdata);
        component.set("v.contratLocaux", contratLocaux);
        component.set("v.idContratGaz", idContratGaz);
        component.set("v.idContratElec", idContratElec);
        component.set("v.consommationData", consommationData);
    }
})