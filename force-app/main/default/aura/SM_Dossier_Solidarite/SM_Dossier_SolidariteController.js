({

    init : function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function(response) {
            //renommer le nom du tab
            //console.log("response facture" + response.subtabs)
            var focusedTabId;
            //FT2-1766 Properties of variables access
            if(response!=null&& response!=undefined){
                if(response.subtabs!=null && response.subtabs!=undefined){
                    if(response.subtabs.length>0){
                        focusedTabId = response.subtabs[response.subtabs.length-1].tabId;
                    }
                    
                }else if(response.tabId!=null&& response.tabId!=undefined){
                    focusedTabId = response.tabId;
                } 
                
            }
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Dossier Solidarite"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:list",
                iconAlt: "Dossier Solidarite",
            });
        })
        .catch(function(error) {
            console.log(error);
        });

        workspaceAPI.getFocusedTabInfo().then(function(response) {
            //FT2-1766 Properties of variables access
            var focusedTabId;
            if(response!=null&& response!=undefined){
                if(response.subtabs.length>0){
                    focusedTabId = response.subtabs[0].tabId;
                }               
            }            
            workspaceAPI.disableTabClose({
                tabId: focusedTabId,
                disabled: true
            })
            .then(function(tabInfo) {
                console.log(tabInfo);
            })
        })
        .catch(function(error) {
            console.log(error);
        });
     
    },

    handleFilterChange: function(component, event) {
        component.set('v.message', 'Close Clicked');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
        //FT2-1766 Properties of variables access 
        var focusedTabId;   
        if(response!=null&& response!=undefined){
            if(response.tabId!=null && response.tabId!=undefined){
                focusedTabId = response.tabId;
            }
        }
        
        if (response.closeable) {
           workspaceAPI.closeTab({tabId: focusedTabId});
        } else {
            workspaceAPI.disableTabClose({
            tabId: focusedTabId,
            disabled: false})
            .then(function(res){
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
    }
 })
       .catch(function(error) {
       console.log(error);
    });
        
},

    openInteraction : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
                          
            var urlOmni = '/apex/SM_VFP_TraceInteractionLWC?id='+component.get("v.recordId")+
            + '&isActivateTracerInteractionOS=' + (event.getParam('isActivateTracerInteractionOS') || '')
            + '&isCasNominal=' + (event.getParam('isCasNominal') || '')
            + '&isPauseInteraction=' + (event.getParam('isPauseInteraction') || '')
            + '&DRId_Case=' + (event.getParam("DRId_Case") || '')
            + '&EnqSat=' + (event.getParam("EnqSat") || '')
            + '&refClientIdBP=' + (event.getParam("refClientIdBP") || '')
            + '&isLWC=' + (event.getParam("isLWC") || '')
            + '&ContextId=' + component.get("v.recordId");
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "TraceInteraction"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    //lancer l'OS SituationCompte à partir historique des factures
    openSituationCompte: function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {   

            var urlOmni = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactSituationCompteFrench&c__layout=lightning&c__tabLabel=Situation de Compte&c__tabIcon=custom:custom18&c__id='+component.get("v.recordId")+ 
            '&c__ContextId=' + component.get("v.recordId") +
            '&c__IdBusinessPartner=' + event.getParam('IdBusinessPartner') +
            '&c__IdPortefeuilleContrat=' + event.getParam('IdPortefeuilleContrat') +
            '&c__numeroVoie=' + event.getParam('numeroVoie')+
            '&c__ville='+ event.getParam('ville') +
            '&c__libelleVoie='+event.getParam('libelleVoie') +
            '&c__complementAdresse='+event.getParam('complementAdresse')+
            '&c__codePostal='+event.getParam('codePostal') +
            '&c__NoCompteContratMaj='+event.getParam('NoCompteContratMaj') +
            '&c__solde='+event.getParam('solde') +
            '&c__DLP='+event.getParam('DLP') +
            '&c__soldeColor='+event.getParam('soldeColor');
            
            console.log("urlOmni"+urlOmni);
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Situation de Compte"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    }
})