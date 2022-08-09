({
    doInit: function(component) {
        // console.log("doInit");
        var workspaceAPI = component.find("workspace");
        // workspaceAPI.getAllTabInfo().then(function(tabs) {
        //     console.log(tabs);
        // });
        window.addEventListener("message", $A.getCallback(function(event) {
            if (event.data !== undefined && event.data["OmniScript-Messaging"] !== undefined && event.data["OmniScript-Messaging"].ContextId !== undefined && event.data["OmniScript-Messaging"].ContextId === component.get("v.recordId")) {
                window.setTimeout(
                    $A.getCallback(function() {
                        $A.enqueueAction(component.get('c.refreshTab'))
                    }), 3000
                );
            }
        }), false);
    },
    openMovein : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_MoveIn?id='+component.get("v.recordId")
                +'&MoveInPortefeuilCtr=' + (event.getParam('MoveInPortefeuilCtr') || '')
                +'&TypeEnergie=' + (event.getParam('TypeEnergie') || '')
                +'&CompteClientId=' + (event.getParam('CompteClientId') || '')
                +'&IdConsumerAccount=' + (event.getParam('IdConsumerAccount') || '')
                +'&PostalCode=' + (event.getParam('PostalCode') || '')
                +'&NomRue=' + (event.getParam('NomRue') || '')
                +'&NumVoie=' + (event.getParam('NumVoie') || '')
                +'&ComplementAdresseOS=' + (event.getParam('ComplementAdresseOS') || '')
                +'&VilleOS=' + (event.getParam('VilleOS') || '')
                +'&IdLocal=' + (event.getParam('IdLocal') || '')
                // +'&numeroLocal=' + (event.getParam('numeroLocal') || '')
                +'&ContextId=' + component.get("v.recordId"),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Souscrire"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openMoveinEmmenagement : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_MoveIn?id='+component.get("v.recordId")
                    + '&callType=' + (event.getParam('callType') || '')
                    + '&fullSize=' + (event.getParam('fullSize') || '')
                    + '&ContextId=' + component.get("v.recordId"),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Emmenagement"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openTransmissionIndex : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_SubmitMeterR?id='+component.get("v.recordId")
                    + '&idPortefeuilleContrat=' + (event.getParam('idPortefeuilleContrat') || '')
                    + '&PCE=' + (event.getParam('PCE') || '')
                    + '&PDL=' + (event.getParam('PDL') || '')
                    + '&idCompteClient=' + (event.getParam('idCompteClient') || '')
                    + '&DateProchaineFacturation=' + (event.getParam('DateProchaineFacturation') || '')
                    + '&ContextId=' + component.get("v.recordId"),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Index"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openDuplicataDocument : function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_RequestForDuplicate?id='+component.get("v.recordId")
                    +'&ContextId=' + component.get("v.recordId"),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Duplicata"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openResiliation : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_Resiliation?id='+component.get("v.recordId")
                    + '&StatusCodeElec=' + (event.getParam('StatusCodeElec') || '')
                    + '&StatusCodeGaz=' + (event.getParam('StatusCodeGaz') || '')
                    + '&idContratGaz=' + (event.getParam('idContratGaz') || '')
                    + '&idContratElec=' + (event.getParam('idContratElec') || '')
                    + '&NumVoie=' + (event.getParam('NumVoie') || '')
                    + '&ComplementAdresse=' + (event.getParam('ComplementAdresse') || '')
                    + '&Ville=' + (event.getParam('Ville') || '')
                    + '&Rue=' + (event.getParam('Rue') || '')
                    + '&PostalCode=' + (event.getParam('PostalCode') || '')
                    + '&DateProchaineFacture=' + (event.getParam('DateProchaineFacture') || '')
                    + '&SoldeEnCours=' + (event.getParam('SoldeEnCours') || '')
                    + '&MontantTotalFacture=' + (event.getParam('MontantTotalFacture') || '')
                    + '&ModeEncaissement=' + (event.getParam('ModeEncaissement') || '')
                    + '&DelaiPaiement=' + (event.getParam('DelaiPaiement') || '')
                    + '&DateLimitePaiement=' + (event.getParam('DateLimitePaiement') || '')
                    + '&modePaiement=' + (event.getParam('modePaiement') || '')
                    + '&PCE=' + (event.getParam('PCE') || '')
                    + '&PDL=' + (event.getParam('PDL') || '')
                    + '&colorSolde=' + (event.getParam('colorSolde') || '')
                    + '&ContextId=' + component.get("v.recordId")
                    + '&isPrelevee=' + event.getParam('isPrelevee')
                    + '&isNonPrelevee=' + event.getParam('isNonPrelevee')
                    + '&isMensualisee=' + event.getParam('isMensualisee')
                    + '&isRegul=' + event.getParam('isRegul')
                    + '&dateEcheanceMensualisee=' + event.getParam('dateEcheanceMensualisee')
                    + '&montantCumuleEcheance=' + event.getParam('montantCumuleEcheance')
                    + '&dateComptablePreNonPre=' + event.getParam('dateComptablePreNonPre')
                    + '&montantTotal=' + event.getParam('montantTotal')
                    + '&dateComptable=' + event.getParam('dateComptable')
                    + '&montantTotalRegul=' + event.getParam('montantTotalRegul'),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Résiliation"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openOPS : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            var urlOmni = '/apex/SM_VFP_SyntheseOPS?id='+component.get("v.recordId")
            + '&TypeCard=' + (event.getParam('TypeCard') || '')
            + '&idPrestationDistributeur=' + (event.getParam('idPrestationDistributeur') || '')
            + '&libelleOPS=' + (event.getParam('libelleOPS') || '')
            + '&fraisPrestation=' + (event.getParam('fraisPrestation') || '')
            + '&soldeDu=' + (event.getParam('soldeDu') || '')
            + '&idPrestationServiceFournisseur=' + (event.getParam('idPrestationServiceFournisseur') || '')
            + '&rue=' + (event.getParam('rue') || '')
            + '&num=' + (event.getParam('num') || '')
            + '&ville=' + (event.getParam('ville') || '')
            + '&cp=' + (event.getParam('cp') || '')
            + '&cplt=' + (event.getParam('cplt') || '')
            + '&commentaires=' + (event.getParam('commentaires') || '')
            + '&idContrat=' + (event.getParam('idContrat') || '')
            + '&ContextId=' + component.get("v.recordId");
            if (event.getParam('commentaires')) {
                urlOmni += '&montantPrevisionnel=' + (event.getParam('montantPrevisionnel') || '')
            }
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Infos OPS"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openEnvieChanger : function(component, event) {
        console.log("need change")
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_changementOffre?id='+component.get("v.recordId")
                    +'&ContextId=' + component.get("v.recordId")
                    +'&IdBusinessPartner=' + event.getParam('IdBusinessPartner')
                    +'&pce=' + event.getParam('pce')
                    +'&pdl=' + event.getParam('pdl')
                    +'&idContratGaz=' + event.getParam('idContratGaz')
                    +'&idContratElec=' + event.getParam('idContratElec')
                    +'&libelleOffreGaz=' + event.getParam('libelleOffreGaz')
                    +'&libelleOffreElec=' + event.getParam('libelleOffreElec')
                    +'&codeINSEE=' + event.getParam('codeINSEE')
                    +'&codePostal=' + (event.getParam('codePostal') || '')
                    +'&type=' + (event.getParam('type') || '')
                    +'&isPrelevee=' + (event.getParam('isPrelevee') || '')
                    +'&isNonPrelevee=' + (event.getParam('isNonPrelevee') || '')
                    +'&isMensualisee=' + (event.getParam('isMensualisee') || '')
                    +'&iBAN=' + (event.getParam('iBAN') || '')
                    +'&titulaireCompte=' + (event.getParam('titulaireCompte') || '')
                    +'&nomInstitutBancaire=' + (event.getParam('nomInstitutBancaire') || '')
                    +'&idBusinessPartner=' + (event.getParam('idBusinessPartner') || '')
                    + '&rue=' + (event.getParam('rue') || '')
                    + '&num=' + (event.getParam('num') || '')
                    + '&ville=' + (event.getParam('ville') || '')
                    + '&cp=' + (event.getParam('cp') || '')
                    + '&cplt=' + (event.getParam('cplt') || ''),
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Envie de changer"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    refreshTab : function(component) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: false
             });
        })
        .catch(function(error) {
            console.log(error);
        })
    }
       
})