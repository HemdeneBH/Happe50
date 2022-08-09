({
    init : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        console.log("workspaceAPI" + workspaceAPI);
        workspaceAPI.getAllTabInfo().then(function(response) {
            //renommer le nom du tab
            console.log("response"+response.subtabs);
            if(response!==null && response.subtabs!==undefined){
                console.log("substab"+response);
                var focusedTabId = response.subtabs[response.subtabs.length-1].tabId;
            }else{
                console.log("tabId"+response.tabId);
                var focusedTabId = response.tabId;
            }
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Infos conso"
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "standard:dashboard",
                iconAlt: "Infos conso",
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    handleFilterChange: function(component, event) {
        var CloseClicked = event.getParam('close');
        component.set('v.message', 'Close Clicked');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
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
    openInteraction: function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {             
            var urlOmni = '/apex/SM_VFP_TraceInteractionLWC?id='+component.get("v.recordId")+
            + '&isActivateTracerInteractionOS=' + (event.getParam('isActivateTracerInteractionOS') || '')
            + '&isCasNominal=' + (event.getParam('isCasNominal') || '')
            + '&isPauseInteraction=' + (event.getParam('isPauseInteraction') || '')
            + '&DRId_Case=' + (event.getParam("DRId_Case") || '')
            + '&StepNameOS=' + (event.getParam("StepNameOS") || '')
            + '&refClientIdBP=' + (event.getParam("refClientIdBP") || '')
            + '&isLWC=' + (event.getParam("isLWC") || '')
            + '&ContextId=' + component.get("v.recordId")
            +'&EnqSat='+ component.get('v.EnqSat');
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
    openContestationIndex: function(component, event) {
        console.log("contestation index");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {             

            // var urlOmni = '/apex/SM_VFP_ContestationIndex?id='+component.get("v.recordId")
            var urlOmni = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactContestationIndexFrench&c__layout=lightning&c__tabLabel=Contestation d\'index&c__tabIcon=custom:custom18&c__id='+component.get("v.recordId")
            + '&c__ContextId=' + component.get("v.recordId")
            + '&c__type=' + (event.getParam('type') || '')
            + '&c__contestGaz=' + (event.getParam('contestGaz') || '')
            + '&c__donneesDerniersIndexReelGaz=' + (event.getParam('donneesDerniersIndexReelGaz') || '')
            + '&c__contestElec=' + (event.getParam('contestElec') || '')
            + '&c__nombreRoue=' + event.getParam('nombreRoue')
            + '&c__idBusinessPartner=' + event.getParam('idBusinessPartner')
            + '&c__pce=' + event.getParam('pce')
            + '&c__pdlCommunicantGaz=' + event.getParam('pdlCommunicantGaz')
            + '&c__factureEnLigne=' + event.getParam('factureEnLigne')
            + '&c__isClientMens=' + event.getParam('isClientMens')
            + '&c__idContratGaz=' + event.getParam('idContratGaz')
            + '&c__IdPortefeuilleContrat=' + event.getParam('IdPortefeuilleContrat')
            + '&c__NoCompteContrat=' + event.getParam('NoCompteContrat')
            + '&c__dateBlocage=' + event.getParam('dateBlocage')
            + '&c__ModePrelevement=' + event.getParam('ModePrelevement')



            + '&c__DLP=' + event.getParam('DLP')

            + '&c__numeroVoie=' + event.getParam('numeroVoie')
            + '&c__ville=' + event.getParam('ville')
            + '&c__libelleVoie=' + event.getParam('libelleVoie')
            + '&c__complementAdresse=' + event.getParam('complementAdresse')

            + '&c__codePostal=' + event.getParam('codePostal')

            + '&c__AccountId=' + event.getParam('AccountId')
            +'&EnqSat='+ component.get('v.EnqSat');

            // + '&c__isSoldePositif=' + event.getParam('isSoldePositif');


            // + '&isDual=' + (event.getParam('isDual') || '');
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
                workspaceAPI.disableTabClose({
                    tabId: subtabId, disabled: true
                })
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "contest. index"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    }
})