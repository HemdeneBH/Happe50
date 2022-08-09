({
    doInit : function(component, event, helper) {

        var workspaceAPI = component.find("workspace");
        var pageRef = component.get("v.pageReference");
        var stringParams, uid, openingTabRex;
        var urlParams = pageRef.state;
        let redirectUrl = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?';
        for(let urlParam in urlParams){

            if(urlParam != 'uid' && urlParam != 'ws')
                redirectUrl += `${urlParam}=${urlParams[urlParam]}&`;
            else if(urlParam == 'uid')
                uid = urlParams[urlParam];
        
        }
        
        redirectUrl = redirectUrl.substring(0, redirectUrl.length - 1);


            workspaceAPI.getEnclosingTabId().then(function(tabId) {

                workspaceAPI.getTabInfo( {tabId : tabId} ).then(function (tabInfos){
                    
                workspaceAPI.openSubtab({
                    focus : true,
                    parentTabId: tabInfos.parentTabId,
                    url : redirectUrl
                }).then(function(subtabId) {
                    workspaceAPI.closeTab({tabId: tabId});

                    workspaceAPI.disableTabClose({
                        tabId: subtabId,
                        disabled: true});
                }).catch(function(error) {
                    console.log(JSON.stringify(error));
                });

            }).catch(function(error) {
                console.log(JSON.stringify(error));
            });
        });
    }
})