/**
 * @File Name          : HP_CreationFicheClientCompController.js
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Mohamed Aamer
 * @Last Modified On   : 20/12/2019 à 15:53:01
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/12/2019   Mohamed Aamer     Initial Version
**/
({
    init: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: 'Création fiche contact'
            });
            workspaceAPI.setTabIcon({
                icon: "action:record",
                iconAlt: "Création"
            });
        })
     },
    handleFilterChange: function(component, event) {
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})