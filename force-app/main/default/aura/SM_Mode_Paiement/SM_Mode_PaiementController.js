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
    openCoob : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactModificationCOOBFrench&c__layout=lightning&c__tabLabel=ModifCOOB&c__tabIcon=custom:custom18'
                +'&c__ContextId=' + component.get("v.recordId")
                +'&c__bp=' + event.getParam('bp')

                +'&c__AccountId='+event.getParam('AccountId')

            +'&c__numeroVoie=' + event.getParam('numeroVoie')
             +'&c__libelleVoie=' + event.getParam('libelleVoie')
             +'&c__complementAdresse=' + event.getParam('complementAdresse')
             +'&c__ville=' + event.getParam('ville')
             +'&c__codePostal=' + event.getParam('codePostal')
             +'&c__listAdressesPrel=' + event.getParam('listAdressesPrel')
             +'&c__numCompteClientActuel=' + event.getParam('numCompteClientActuel')
             +'&c__pce=' + event.getParam('pce')
             +'&c__pdl=' + event.getParam('pdl')
             +'&c__idContratGaz=' + event.getParam('idContratGaz')
             +'&c__idContratElec=' + event.getParam('idContratElec')
             +'&c__iBAN=' + event.getParam('iBAN')
             +'&c__numeroLocal=' + event.getParam('numeroLocal')
             +'&c__dateTheoriqueReleve=' + event.getParam('dateTheoriqueReleve')
             +'&c__dateReelleProchaineFacture=' + event.getParam('dateReelleProchaineFacture')
             +'&c__dateTechniqueProchaineFacture=' + event.getParam('dateTechniqueProchaineFacture')
             +'&c__codeINSEE=' + event.getParam('codeINSEE'),
           
                focus: true
                
            }).then(function(subtabId) {
                workspaceAPI.disableTabClose({
                    tabId: subtabId, disabled: true
                })
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "ModifCOOB"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openPrelevement : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactPrelevementFrench&c__layout=lightning&c__tabLabel=Prélèvement&c__tabIcon=custom:custom18'
                +'&c__ContextId=' + component.get("v.recordId")
                +'&c__bp=' + event.getParam('bp')

                +'&c__AccountId='+event.getParam('AccountId')

            +'&c__numeroVoie=' + event.getParam('numeroVoie')
             +'&c__libelleVoie=' + event.getParam('libelleVoie')
             +'&c__complementAdresse=' + event.getParam('complementAdresse')
             +'&c__ville=' + event.getParam('ville')
             +'&c__codePostal=' + event.getParam('codePostal')
             +'&c__listAddress=' + event.getParam('listAddress')
             +'&c__numCompteClientActuel=' + event.getParam('numCompteClientActuel')
             +'&c__pce=' + event.getParam('pce')
             +'&c__pdl=' + event.getParam('pdl')
             +'&c__idContratGaz=' + event.getParam('idContratGaz')
             +'&c__idContratElec=' + event.getParam('idContratElec')
             +'&c__iBAN=' + event.getParam('iBAN')
             +'&c__eDocument=' + event.getParam('eDocument')
             +'&c__libelleFactureEnLigne=' + event.getParam('libelleFactureEnLigne')
             +'&c__factureEnLigne=' + event.getParam('factureEnLigne')

             +'&c__numeroLocal=' + event.getParam('numeroLocal')
             +'&c__dateTheoriqueReleve=' + event.getParam('dateTheoriqueReleve')
             +'&c__dateReelleProchaineFacture=' + event.getParam('dateReelleProchaineFacture')
             +'&c__dateTechniqueProchaineFacture=' + event.getParam('dateTechniqueProchaineFacture')
			 +'&c__EnqSat='+ event.getParam('EnqSat')
             +'&c__codeINSEE=' + event.getParam('codeINSEE'),
              
                focus: true
            }).then(function(subtabId) {
                workspaceAPI.disableTabClose({
                    tabId: subtabId, disabled: true
                })
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    handleCloseClick: function(component, event) {        
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
	openInteraction : function(component, event) {
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
            + '&EnqSat=' + event.getParam('EnqSat');
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
     //FT2-1280 Lancement du parcours ajustement de mensualisation
	openAjustementMens : function(component, event) {
	    var workspaceAPI = component.find("workspace");
	    workspaceAPI.getEnclosingTabId().then(function(tabId) {   
            //FT2-1732 BEGINS HERE : Ajustement de mens V2 : Récupération du dernier montantCumuleEcheance depuis tableDataMens
            var tableMens = JSON.parse(event.getParam('tableDataMens'));
            var montantCumuleEcheance = tableMens[tableMens.length-1].montantCumuleEcheance;
            //FT2-1732 ENDS HERE : Ajustement de mens V2 : Récupération du dernier montantCumuleEcheance depuis tableDataMens      
	        var urlOmni = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactAjustementMensFrench&c__layout=lightning&c__tabLabel=Ajustement Mensualité&c__tabIcon=custom:custom18&c__id='+component.get("v.recordId")+
	        '&c__ContextId=' + component.get("v.recordId")+
	        '&c__bp='+event.getParam('bp')+
	        '&c__AccountId='+event.getParam('AccountId')+
            '&c__tableDataMens='+event.getParam('tableDataMens')+
            '&c__showCumule='+event.getParam('showCumule')+
	        '&c__isGaz='+event.getParam('isGaz')+
	        '&c__isElec='+event.getParam('isElec')+
	        '&c__isService1='+event.getParam('isService1')+
	        '&c__isService2='+event.getParam('isService2')+
	        '&c__numeroVoie='+event.getParam('numeroVoie')+
	        '&c__libelleVoie='+event.getParam('libelleVoie')+
	        '&c__complementAdresse='+event.getParam('complementAdresse')+
	        '&c__ville='+event.getParam('ville')+
	        '&c__codePostal='+event.getParam('codePostal')+
	        '&c__numCompteClientActuel='+event.getParam('numCompteClientActuel')+
	        '&c__montantPaye='+event.getParam('montantPaye')+
            '&c__idPlanDePaiement='+event.getParam('idPlanDePaiement')+ //FT2-1604: Ajustement mensualité update 0.2 : Intégration au clic sur le bouton NON dans le parcours
	        '&c__categorie='+event.getParam('categorie')+ //FT2-1298: Ajustement mensualité 1.3 : Etape 1 - intégration
            '&c__montantGlobalOriginal='+event.getParam('montantGlobalOriginal')+ //FT2-1298: Ajustement mensualité 1.3 : Etape 1 - intégration
	        '&c__montantGlobal='+event.getParam('montantGlobal')+
            '&c__montantCumuleEcheance='+parseFloat(montantCumuleEcheance).toFixed(2)+ //FT2-1732 Récupérer le montant de la derniere mensualité depuis tableDataMens
'&c__listOrderedAdresses='+event.getParam('listOrderedAdresses')+ // //FT2-1765 Ajustement mensualité V2 : Récupération des adresses (écran Localisation du logement (1/2))
            '&c__idPackElec='+event.getParam('idPackElec')+ // // //FT2-1724 Ajustement mensualité V2 : Récupération du montant estimée depuis l’Outil d’estimation
            '&c__idPackGaz='+event.getParam('idPackGaz')+ // FT2-1724
            '&c__idOfferElec='+event.getParam('idOfferElec')+ // FT2-1724
            '&c__idOfferGaz='+event.getParam('idOfferGaz')+ // FT2-1724
            '&c__effectiveDateElec='+event.getParam('effectiveDateElec')+ // FT2-1724
            '&c__effectiveDateGaz='+event.getParam('effectiveDateGaz')+ // FT2-1724
            '&c__enqSat='+event.getParam('enqSat')+
            '&c__isPlanMensValid='+event.getParam('isPlanMensValid'); //FT2-1855 check si le plan de paiement est valide
            console.log("urlOmni"+urlOmni);
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Ajustement Mensualité"});
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
                url: '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactMensualisationOSFrench&c__layout=lightning&c__tabLabel=Mensualisation&c__tabIcon=custom:custom18'
                +'&c__ContextId=' + component.get("v.recordId")
                +'&c__bp=' + event.getParam('bp')

                +'&c__AccountId='+event.getParam('AccountId')

            +'&c__numeroVoie=' + event.getParam('numeroVoie')
             +'&c__libelleVoie=' + event.getParam('libelleVoie')
             +'&c__complementAdresse=' + event.getParam('complementAdresse')
             +'&c__ville=' + event.getParam('ville')
             +'&c__codePostal=' + event.getParam('codePostal')
             +'&c__listAddress=' + event.getParam('listAddress')
             +'&c__numCompteClientActuel=' + event.getParam('numCompteClientActuel')
             +'&c__solde=' + event.getParam('solde')
             +'&c__pce=' + event.getParam('pce')
             +'&c__pdl=' + event.getParam('pdl')
             +'&c__idContratGaz=' + event.getParam('idContratGaz')
             +'&c__idContratElec=' + event.getParam('idContratElec')
             +'&c__iBAN=' + event.getParam('iBAN')
             +'&c__codeINSEE=' + event.getParam('codeINSEE')
             +'&c__numeroMandat=' + event.getParam('numeroMandat')             

             +'&c__numeroLocal=' + event.getParam('numeroLocal')
             +'&c__isPrelevee=' + event.getParam('isPrelevee')
             +'&c__dateTheoriqueReleve=' + event.getParam('dateTheoriqueReleve')
             +'&c__EnqSat=' + event.getParam('EnqSat')
             +'&c__dateReelleProchaineFacture=' + event.getParam('dateReelleProchaineFacture')
             +'&c__dateTechniqueProchaineFacture=' + event.getParam('dateTechniqueProchaineFacture'),

                focus: true
            }).then(function(subtabId) {
                workspaceAPI.disableTabClose({
                    tabId: subtabId, disabled: true
                })
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    }
})