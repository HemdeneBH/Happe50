({
    init : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            //renommer le nom du tab
            if(response!==null&&response.subtabs!==undefined){
                var focusedTabId = response.subtabs[response.subtabs.length-1].tabId;
            }else{
                var focusedTabId = response.tabId;
            }
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Mode Paiement"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:magicwand",
                iconAlt: "Mode Paiement",
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    openPrelevement : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_Prelevement?id='+component.get("v.recordId")
                +'&ContextId=' + component.get("v.recordId")
                +'&bp=' + event.getParam('bp')
            +'&numeroVoie=' + event.getParam('numeroVoie')
             +'&libelleVoie=' + event.getParam('libelleVoie')
             +'&complementAdresse=' + event.getParam('complementAdresse')
             +'&ville=' + event.getParam('ville')
             +'&codePostal=' + event.getParam('codePostal')
             +'&listAddress=' + event.getParam('listAddress')
             +'&numCompteClientActuel=' + event.getParam('numCompteClientActuel')
             +'&pce=' + event.getParam('pce')
             +'&pdl=' + event.getParam('pdl')
             +'&idContratGaz=' + event.getParam('idContratGaz')
             +'&idContratElec=' + event.getParam('idContratElec')
             +'&iBAN=' + event.getParam('iBAN')
             +'&idLocal=' + event.getParam('idLocal')
             +'&codeINSEE=' + event.getParam('codeINSEE'),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Prelevement"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openMensualisation : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_Mensualisation?id='+component.get("v.recordId")
                +'&ContextId=' + component.get("v.recordId")
                +'&bp=' + event.getParam('bp')
            +'&numeroVoie=' + event.getParam('numeroVoie')
             +'&libelleVoie=' + event.getParam('libelleVoie')
             +'&complementAdresse=' + event.getParam('complementAdresse')
             +'&ville=' + event.getParam('ville')
             +'&codePostal=' + event.getParam('codePostal')
             +'&listAddress=' + event.getParam('listAddress')
             +'&numCompteClientActuel=' + event.getParam('numCompteClientActuel')
             +'&solde=' + event.getParam('solde')
             +'&pce=' + event.getParam('pce')
             +'&pdl=' + event.getParam('pdl')
             +'&idContratGaz=' + event.getParam('idContratGaz')
             +'&idContratElec=' + event.getParam('idContratElec')
             +'&iBAN=' + event.getParam('iBAN')
             +'&codeINSEE=' + event.getParam('codeINSEE')
             +'&numeroMandat=' + event.getParam('numeroMandat') 
             +'&idLocal=' + event.getParam('idLocal')            
             +'&isPrelevee=' + event.getParam('isPrelevee'),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Mensualisation"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    }
})