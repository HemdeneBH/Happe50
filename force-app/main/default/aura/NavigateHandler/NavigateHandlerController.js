({
    doInit : function(component, event, helper) {

        console.log('in Init Navigate Handler Controller');
        var workspaceAPI = component.find("workspace");
        var urlParams = component.get("v.pageReference").state;
        console.log('URL Params ',JSON.stringify(urlParams));
        workspaceAPI.getFocusedTabInfo().then(function(tabInfo) {
            if(urlParams.c__NavigateId){

                workspaceAPI.openTab({
                    url: `#/sObject/${urlParams.c__NavigateId}/view`,
                    focus: true
                });
                let dataMessage_RefreshView = {
                    "OmniScript-Messaging" : {
                        ContextId : urlParams.c__NavigateId
                    }
                };
        
                window.parent.postMessage(dataMessage_RefreshView, "*");
            }
            else{

                console.log('You need to specify Redirect Id');

            }

            if(tabInfo.closeable){

                workspaceAPI.closeTab({tabId: tabInfo.tabId});

            }
            else{

                workspaceAPI.disableTabClose({
                    tabId: tabInfo.tabId,
                    disabled: false})
                .then(function(res){

                    workspaceAPI.closeTab({tabId: tabInfo.tabId});

                })

            }

        })



    }
})