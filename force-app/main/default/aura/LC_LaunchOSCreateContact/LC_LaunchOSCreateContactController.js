({
	openTabWithSubtab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            //url: '/apex/SM_VFP_CreateContact',
            url: '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactCreerContactFrench&c__layout=lightning&c__tabLabel=Création de la fiche contact&c__tabIcon=custom:custom18',
            label: 'Création de la fiche contact'
        }).then(function(response) {
            workspaceAPI.focusTab({tabId : response});
        })
        .catch(function(error) {
            console.log(error);
        });
        // FT4-36
        // $A.get("e.force:closeQuickAction").fire();
        setTimeout(()=>{
            let quickActionClose = $A.get("e.force:closeQuickAction");
            quickActionClose.fire();
        },1000);
        //FT4-36
    }
})