({
    doInit: function(component) {
        console.log("doInit");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function(tabs) {
            console.log(tabs);
        });
        window.addEventListener("message", $A.getCallback(function(event) {
            try {
                if (event.data !== undefined && event.data["OmniScript-Messaging"] !== undefined && event.data["OmniScript-Messaging"].ContextId !== undefined && event.data["OmniScript-Messaging"].ContextId === component.get("v.recordId")) {
                    window.setTimeout(
                            $A.getCallback(function() {
                                if ($A) {
                                    $A.enqueueAction(component.get('c.refreshTab'))
                                    console.log('Refresh de la vue 360');
                                } else {
                                    console.error('Erreur lors du refresh de la vue 360: var $A is undefined');
                                }
                            }), 1
                    );
                }
            } catch (error) {
                console.error(error);
                console.log('error Refresh');
            }
        }), false);
    },
    openMovein : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_MoveInRef?id='+component.get("v.recordId")
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
                 +'&eDocument=' + (event.getParam('eDocument'))
                 +'&fel=' + (event.getParam('fel'))
                // +'&numeroLocal=' + (event.getParam('numeroLocal') || '')
                +'&ContextId=' + component.get("v.recordId")
                + '&AccountId=' + (event.getParam('AccountId') || '')
                +'&EnqSat='+ JSON.stringify(event.getParam('EnqSat')),
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

    openOptions : function (component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {   
            var urlOmni = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactStandaloneOptionsFrench&c__layout=lightning&c__tabLabel=Option&c__tabIcon=custom:custom18&c__id='+component.get("v.recordId")+
            '&c__ContextId=' + (component.get("v.recordId")|| '')+
            '&c__IdCompteClient=' + (event.getParam('NoCompteContrat')|| '')+
            '&c__IdLocal=' + (event.getParam('IdLocal')|| '')+
            '&c__IdBusinessPartner=' + (event.getParam('IdBusinessPartner')|| '')+
            '&c__NumeroVoie=' + (event.getParam('numeroVoie')|| '')+
            '&c__LibelleVoie=' + (event.getParam('libelleVoie')|| '')+
            '&c__ComplementAdresse=' + (event.getParam('complementAdresse')|| '')+
            '&c__CP=' + (event.getParam('codePostal')|| '')+
            '&c__City=' + (event.getParam('ville')|| '')+
            '&c__IdContratGaz=' + (event.getParam('idContratGaz')|| '')+
            '&c__IdContratElec=' + (event.getParam('idContratElec')|| '')+
            '&c__ContratsOptions=' + (event.getParam('contratsOptions')|| '')+
            '&c__RythmeFacturation=' + (event.getParam('rythmeFacturation')|| '')+
            '&c__NumeroLocal='+ event.getParam('numeroLocal')

             console.log("urlOmni"+urlOmni);
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
                workspaceAPI.disableTabClose({
                    tabId: subtabId, disabled: true
                }); 
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Option"});
            }).catch(function(error) {
           		console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });  
    },

    //aquisition 
    openMoveinEmmenagement : function(component, event) {
        let handleLwcAcquisition = event.getParam('enableLwcAcquisition');
        let url;
        if(handleLwcAcquisition){
            url = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactAcquisitionFrench&c__layout=lightning&c__tabLabel=Acquisition&c__tabIcon=custom:custom18'
                + '&c__id='+component.get("v.recordId")
                + '&c__callType=' + (event.getParam('callType') || '')
                + '&c__fullSize=' + (event.getParam('fullSize') || '')
                + '&c__eDocument=' + (event.getParam('eDocument'))
                + '&c__ContextId=' + component.get("v.recordId")
                + '&c__AccountId=' + (event.getParam('AccountId') || '')
                + '&c__EnqSat='+ JSON.stringify(event.getParam('EnqSat'));            
        } else{
            url = '/apex/SM_VFP_MoveInRef?id='+component.get("v.recordId")
                + '&callType=' + (event.getParam('callType') || '')
                + '&fullSize=' + (event.getParam('fullSize') || '')
                + '&eDocument=' + (event.getParam('eDocument'))
                + '&ContextId=' + component.get("v.recordId")
                + '&AccountId=' + (event.getParam('AccountId') || '')
                + '&EnqSat='+ JSON.stringify(event.getParam('EnqSat')); 
            }
        console.log('### url ' + url);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                /*url: '/apex/SM_VFP_MoveInRef?id='+component.get("v.recordId")
                    + '&callType=' + (event.getParam('callType') || '')
                    + '&fullSize=' + (event.getParam('fullSize') || '')
                +'&eDocument=' + (event.getParam('eDocument'))

                    + '&ContextId=' + component.get("v.recordId")
                    + '&AccountId=' + (event.getParam('AccountId') || '')
                    +'&EnqSat='+ JSON.stringify(event.getParam('EnqSat')),*/
                url: url,
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
    // delai de paiment
    openDelaiPaiement : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__SM_Cont_SynDP"
     //second aura component
                    },
                      "state": {
                        uid:"1",  
                        c__numeroVoie: event.getParam('numeroVoie'),
                        c__libelleVoie: event.getParam('libelleVoie'),
                        c__complementAdresse: event.getParam('complementAdresse'),
                        c__codePostal: event.getParam('codePostal'),
                        c__NoCompteContrat: event.getParam('NoCompteContrat'),
                        c__NoCompteContratMaj: event.getParam('NoCompteContratMaj'),
                        c__ville: event.getParam('ville'),
                        c__recordId: event.getParam('recordId'),
                        c__IdBusinessPartner: event.getParam('IdBusinessPartner'),
                        c__solde: event.getParam('solde'),
                        c__soldeFormat: event.getParam('soldeFormat'),
                        c__AccountId: event.getParam('AccountId'),
                        c__iBAN: event.getParam('iBAN'),
                        c__nomInstitutBancaire: event.getParam('nomInstitutBancaire'),
                        c__EnqSat: JSON.stringify(event.getParam('EnqSat')),
                        c__transformDateEcheance: event.getParam('transformDateEcheance') //FT2-1687 Délai de paiement - sauvegarde des infos nécessaires à la validation du superviseur (Envoi de la DLP vers l'écran délai de paiement)
                    }
                }, 
              /* url:'/lightning/cmp/c__SM_Cont_SynDP?c__numeroVoie='
               + event.getParam('numeroVoie') +'&c__libelleVoie='
               + event.getParam('libelleVoie') +'&c__complementAdresse='
               + event.getParam('complementAdresse') + '&c__codePostal='
               + event.getParam('codePostal')  + '&c__NoCompteContrat='
               + event.getParam('NoCompteContrat') + '&c__NoCompteContratMaj='
               + event.getParam('NoCompteContratMaj') +'&c__ville='
               + event.getParam('ville') +'&c__recordId='
               + event.getParam('recordId') +'&c__IdBusinessPartner='
               + event.getParam('IdBusinessPartner') + '&c__solde='
               + event.getParam('sold') + '&c__soldeFormat='
               + event.getParam('soldeFormat') + '&c__AccountId='+
               + event.getParam('AccountId')+ '&c__iBAN='+
               + event.getParam('iBAN') + '&c__nomInstitutBancaire='
               + event.getParam('nomInstitutBancaire') + '&uid=1', */
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId:subtabId,
                	label: "SYNTHESE DES DELAIS DE PAIEMENT"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openDetectionProject : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactDetectionDeProjetsFrench&c__layout=lightning&c__tabLabel=DetectionDeProjets&c__tabIcon=DetectionDeProjets&c__id='+component.get("v.recordId")

            	 + '&c__ContextId=' + component.get("v.recordId")
                 + '&c__HashTabId='+tabId
                 + '&c__NoCompteContratMaj=' + (event.getParam('NoCompteContratMaj') || '')
                 + '&c__NoCompteContrat=' + (event.getParam('NoCompteContrat') || '')


                 + '&c__NumVoie=' + (event.getParam('NumVoie') || '')
                 + '&c__ComplementAdresse=' + (event.getParam('ComplementAdresse') || '')
                 + '&c__Ville=' + (event.getParam('Ville') || '')
                 + '&c__Rue=' + (event.getParam('Rue') || '')

                 + '&c__IdBusinessPartner='+ (event.getParam('IdBusinessPartner')|| '')
                 + '&c__PostalCode=' + (event.getParam('PostalCode') || '')
                 + '&c__AccountId=' + (event.getParam('AccountId') || '')
                 +'&c__EnqSat='+ event.getParam('EnqSat'),

                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Detection Projet"});
            }).catch(function(error) {
           			 console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openTransmissionIndexLWC : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url:'/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactSubmitMRFrench&c__layout=lightning&c__tabLabel=Index&c__tabIcon=custom:custom18'
                  + '&c__ContextId='+component.get("v.recordId")
                  + '&c__idPortefeuilleContrat=' + (event.getParam('idPortefeuilleContrat') || '')
                  + '&c__PCE=' + (event.getParam('PCE') || '')
                  + '&c__PDL=' + (event.getParam('PDL') || '')
                  + '&c__codeINSEE=' +(event.getParam('codeINSEE') || '')
                  + '&c__idCompteClient=' + (event.getParam('idCompteClient') || '')
                  + '&c__DateProchaineFacturation=' + (event.getParam('DateProchaineFacturation') || '')
                  + '&c__isThereActiveContracts=' + (event.getParam('isThereActiveContracts') || '')
                  + '&c__EnqSat='+ JSON.stringify(event.getParam('EnqSat'))
                  + '&c__AccountId=' + (event.getParam('AccountId') || ''),
                focus: true
            }).then(function(subtabId) {
       
                       workspaceAPI.disableTabClose({
       
                           tabId: subtabId, disabled: true
       
                       })
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
    openTransmissionIndex : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_SubmitMeterR?id='+component.get("v.recordId")
                  + '&ContextId='+component.get("v.recordId")
                    + '&idPortefeuilleContrat=' + (event.getParam('idPortefeuilleContrat') || '')
                    + '&PCE=' + (event.getParam('PCE') || '')
                    + '&PDL=' + (event.getParam('PDL') || '')
                    + '&codeINSEE=' +(event.getParam('codeINSEE') || '')
                    + '&idCompteClient=' + (event.getParam('idCompteClient') || '')
                    + '&DateProchaineFacturation=' + (event.getParam('DateProchaineFacturation') || '')
                    + '&isThereActiveContracts=' + (event.getParam('isThereActiveContracts') || '')
                    + '&AccountId=' + (event.getParam('AccountId') || '')
                    +'&EnqSat='+ event.getParam('EnqSat'),
                focus: true
            }).then(function(subtabId) {
       
                       workspaceAPI.disableTabClose({
       
                           tabId: subtabId, disabled: true
       
                       })
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
    openDuplicataDocument : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/apex/SM_VFP_RequestForDuplicate?id='+component.get("v.recordId")
                    +'&ContextId=' + component.get("v.recordId")
                    +'&EnqSat='+ JSON.stringify(event.getParam('EnqSat')),

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
    openDuplicataDocumentLWC : function(component,event) {
        var workspaceAPI = component.find("workspace");
        console.log('IdPortefeuilleContrat');
        console.log(event.getParam('IdPortefeuilleContrat'));
        // AE FT2-1530 ajout de l'IDPorteFeuilleContrat comme paramètre envoyé a l'omniscript pour filtrer la liste des factures
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            console.log('[Bug Onglet/Sous-Onglet]: tabId ==>' + tabId);
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactRequestForDuplicateEnglish&c__layout=lightning&c__tabLabel=Duplicata&c__tabIcon=custom:custom18'
                    +'&c__IdPortefeuilleContrat=' + (event.getParam('IdPortefeuilleContrat') || '')
                    +'&c__AccountId=' + (event.getParam('AccountId') || '')
                    +'&c__ContextId=' + component.get("v.recordId")
                    +'&c__HashTabId='+tabId//generatedTabI,
                    +'&c__EnqSat='+ event.getParam('EnqSat'),
                focus: true
            }).then(function(subtabId) {
                console.log('[Bug Onglet/Sous-Onglet]: subtabId ==>' + subtabId);
                workspaceAPI.disableTabClose({
                    tabId: subtabId, disabled: true
                })
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
    openServicePayant : function(component, event) {
        let handleLwcServicesPayants = event.getParam('enableLwcServicesPayants');
        let url;
        if(handleLwcServicesPayants){
            url= '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:sMServicesPayantsParcoursEnglish&c__layout=lightning&c__tabLabel=Services&c__tabIcon=custom:custom18'
                    +'&c__id='+component.get("v.recordId")
                    +'&c__isMensualisee=' + event.getParam('isMensualisee')
                    +'&c__isPrelevee=' + event.getParam('isPrelevee')
                    +'&c__iBAN=' + event.getParam('iBAN')
                    +'&c__nomInstitutBancaire=' + event.getParam('nomInstitutBancaire')
                    +'&c__titulaireCompte=' + event.getParam('titulaireCompte')
                    +'&c__numeroVoie='+ event.getParam('numeroVoie')
                    +'&c__libelleVoie='+ event.getParam('libelleVoie')
                    +'&c__complementAdresse='+ event.getParam('complementAdresse')
                    +'&c__codePostal='+ event.getParam('codePostal')
                    +'&c__ville='+ event.getParam('ville')
                    +'&c__IdBusinessPartner='+ event.getParam('IdBusinessPartner')
                    +'&c__numeroLocal='+ event.getParam('numeroLocal')
                    +'&c__isContratActif='+ event.getParam('isContratActif')
                    +'&c__compteContratId='+ event.getParam('NoCompteContrat')
                    +'&c__portefeuilleContratId='+ event.getParam('IdPortefeuilleContrat')
                    +'&c__ContextId=' + component.get("v.recordId")
                   +'&c__EnqSat='+ event.getParam('EnqSat')
                +'&c__AccountId=' + (event.getParam('AccountId') || '');           
        } else{
            url= '/apex/SM_VFP_ServicesPayants?id='+component.get("v.recordId")
                +'&isMensualisee=' + event.getParam('isMensualisee')
                +'&isPrelevee=' + event.getParam('isPrelevee')
                +'&iBAN=' + event.getParam('iBAN')
                +'&nomInstitutBancaire=' + event.getParam('nomInstitutBancaire')
                +'&titulaireCompte=' + event.getParam('titulaireCompte')
                +'&numeroVoie='+ event.getParam('numeroVoie')
                +'&libelleVoie='+ event.getParam('libelleVoie')
                +'&complementAdresse='+ event.getParam('complementAdresse')
                +'&codePostal='+ event.getParam('codePostal')
                +'&ville='+ event.getParam('ville')
                +'&IdBusinessPartner='+ event.getParam('IdBusinessPartner')
                +'&numeroLocal='+ event.getParam('numeroLocal')
                +'&isContratActif='+ event.getParam('isContratActif')
                +'&compteContratId='+ event.getParam('NoCompteContrat')
                +'&portefeuilleContratId='+ event.getParam('IdPortefeuilleContrat')
                +'&EnqSat='+ JSON.stringify(event.getParam('EnqSat'))
                +'&ContextId=' + component.get("v.recordId")
                +'&AccountId=' + (event.getParam('AccountId') || ''); 
            }
        console.log('### url ' + url);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: url,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Services"
                });
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
                    + '&datePrelevRegul=' + event.getParam('datePrelevRegul')
                    + '&datePrelevementPrel=' + event.getParam('datePrelevementPrel')

                    + '&montantTotalRegul=' + event.getParam('montantTotalRegul')
                    + '&offreElec=' + event.getParam('c__offreElec')
                    + '&offreGaz=' + event.getParam('c__offreGaz')
                    +'&EnqSat='+ event.getParam('EnqSat')
                    + '&AccountId=' + (event.getParam('AccountId') || ''),

                focus: true
            }).then(function(subtabId) {
                workspaceAPI.disableTabClose({
                    tabId: subtabId, disabled: true
                });            	
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
    openResiliationLWC : function(component, event) {
        var workspaceAPI = component.find("workspace");
        console.log(event.getParam('colorSoldeLWC'));

        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactResilisationFrench&c__layout=lightning&c__tabLabel=Résiliation&c__tabIcon=custom:custom18' + '&c__ContextId=' + component.get("v.recordId")
                    + '&c__StatusCodeElec=' + (event.getParam('StatusCodeElec') || '')
                    + '&c__StatusCodeGaz=' + (event.getParam('StatusCodeGaz') || '')
                    + '&c__colorSolde=' + (event.getParam('colorSoldeLWC') || '')
                    + '&c__idContratGaz=' + (event.getParam('idContratGaz') || '')
                    + '&c__idContratElec=' + (event.getParam('idContratElec') || '')
                    + '&c__NumVoie=' + (event.getParam('NumVoie') || '')
                    + '&c__ComplementAdresse=' + (event.getParam('ComplementAdresse') || '')
                    + '&c__Ville=' + (event.getParam('Ville') || '')
                    + '&c__Rue=' + (event.getParam('Rue') || '')
                    + '&c__PostalCode=' + (event.getParam('PostalCode') || '')
                    + '&c__DateProchaineFacture=' + (event.getParam('DateProchaineFacture') || '')
                    + '&c__SoldeEnCours=' + (event.getParam('SoldeEnCours') || '')
                    + '&c__MontantTotalFacture=' + (event.getParam('MontantTotalFacture') || '')
                    + '&c__ModeEncaissement=' + (event.getParam('ModeEncaissement') || '')
                    + '&c__DelaiPaiement=' + (event.getParam('DelaiPaiement') || '')
                    + '&c__DateLimitePaiement=' + (event.getParam('DateLimitePaiement') || '')
                    + '&c__modePaiement=' + (event.getParam('modePaiement') || '')
                    + '&c__PCE=' + (event.getParam('PCE') || '')
                    + '&c__PDL=' + (event.getParam('PDL') || '')
                    + '&c__colorSolde=' + (event.getParam('colorSoldeLWC') || '')

                    + '&c__ContextId=' + component.get("v.recordId")
                    + '&c__isPrelevee=' + event.getParam('isPrelevee')
                    + '&c__isNonPrelevee=' + event.getParam('isNonPrelevee')
                    + '&c__isMensualisee=' + event.getParam('isMensualisee')
                    + '&c__isRegul=' + event.getParam('isRegul')
                    + '&c__dateEcheanceMensualisee=' + event.getParam('dateEcheanceMensualisee')
                    + '&c__montantCumuleEcheance=' + event.getParam('montantCumuleEcheance')
                    + '&c__dateComptablePreNonPre=' + event.getParam('dateComptablePreNonPre')
                    + '&c__montantTotal=' + event.getParam('montantTotal')
                    + '&c__dateComptable=' + event.getParam('dateComptable')
                    + '&c__datePrelevRegul=' + event.getParam('datePrelevRegul')
                    + '&c__datePrelevementPrel=' + event.getParam('datePrelevementPrel')
                    + '&c__montantTotalRegul=' + event.getParam('montantTotalRegul')
                    + '&c__offreElec=' + event.getParam('c__offreElec')
                    + '&c__offreGaz=' + event.getParam('c__offreGaz')
                    + '&c__EnqSat='+ JSON.stringify(event.getParam('EnqSat'))
                    + '&c__AccountId=' + (event.getParam('AccountId') || ''),
                focus: true
            }).then(function(subtabId) {
                workspaceAPI.disableTabClose({
                    tabId: subtabId, disabled: true
                });
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
        console.log('ouverture Synthèse OPS')
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smileContactSyntheseOPSLWCEnglish&c__layout=lightning&c__tabLabel=Synthèse des OPS&c__tabIcon=custom:custom18'
                +'&c__ContextId=' + component.get("v.recordId")
                +'&c__TypeCard=' + (event.getParam('TypeCard') || '')
                //+'&c__idPrestationDistributeurEnCours=' + (event.getParam('idPrestationDistributeurEnCours') || '')
                +'&c__idPrestationServiceFournisseurEnCours='+ (event.getParam('idPrestationServiceFournisseurEnCours') || '')
                //+'&c__idPrestationDistributeurTerminees=' + (event.getParam('idPrestationDistributeurTerminees') || '')
                +'&c__idPrestationServiceFournisseurTerminees='+ (event.getParam('idPrestationServiceFournisseurTerminees') || '')
                +'&c__rue='+ (event.getParam('rue') || '')
                +'&c__num='+ (event.getParam('num') || '')
                +'&c__ville='+ (event.getParam('ville') || '')
                +'&c__cp='+ (event.getParam('cp') || '')
                +'&c__cplt='+ (event.getParam('cplt') || '')
                +'&c__numeroPointDeLivraison='+(event.getParam('numeroPointDeLivraison') || '')
                +'&c__nbreOPSTerminees='+(event.getParam('nbreOPSTerminees') || '0')
                +'&c__idContrat='+(event.getParam('idContrat') || '')
                +'&c__AccountId='+(event.getParam('AccountId') || '')
                +'&c__EnqSat='+ event.getParam('EnqSat'),
                focus: true
            }).then(function(subtabId) {
                workspaceAPI.setTabLabel({
                    tabId: subtabId,
                    label: "Synthèse des OPS"})
                    ;
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
                    +'&idCoordonneeBancaire=' + (event.getParam('idCoordonneeBancaire') || '')
                    +'&codeBIC=' + (event.getParam('codeBIC') || '')
                    +'&idBusinessPartner=' + (event.getParam('idBusinessPartner') || '')
                    + '&rue=' + (event.getParam('rue') || '')
                    + '&num=' + (event.getParam('num') || '')
                    + '&ville=' + (event.getParam('ville') || '')
                    + '&cp=' + (event.getParam('cp') || '')
                    + '&cplt=' + (event.getParam('cplt') || '')
                    + '&assurenceFactureActif=' + event.getParam('assurenceFactureActif')
                    +'&IdLocal=' + (event.getParam('IdLocal') || '')
                    + '&CompteClientId=' + (event.getParam('CompteClientId') || '')
                    + '&AccountId=' + (event.getParam('AccountId') || '')
                    +'&EnqSat='+ JSON.stringify(event.getParam('EnqSat')),
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
            '&c__NoCompteContrat='+event.getParam('NoCompteContrat') +
            '&c__solde='+event.getParam('solde') +
            '&c__DLP='+event.getParam('DLP') +
            '&c__EnqSat='+ event.getParam('EnqSat')+
            '&c__soldeColor='+event.getParam('soldeColor')
            ;
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
    },
/*KDI FT2-1403: Affichage de l'écran payeur divergent au clic sur crayon
    Payeur divergent*/
    openPayeurDivergent : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {   
            var urlOmni = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactPayeurDivergentFrench&c__layout=lightning&c__tabLabel=Payeur Divergent&c__tabIcon=custom:custom18&c__id='+component.get("v.recordId")+
            '&c__ContextId=' + component.get("v.recordId")+
            '&c__NoCompteContrat=' + event.getParam('NoCompteContrat')+
            '&c__IdBusinessPartner=' + event.getParam('IdBusinessPartner') +
            '&c__idPersonneDivergentPayeur=' + event.getParam('idPersonneDivergentPayeur')+
            '&c__idPersonneDivergentRelance=' + event.getParam('idPersonneDivergentRelance')+
            '&c__idPersonneDivergentFacture=' + event.getParam('idPersonneDivergentFacture')+
            '&c__isPayeurDivergent=' + event.getParam('isPayeurDivergent')+
            '&c__numeroVoie=' + event.getParam('numeroVoie')+
            '&c__libelleVoie=' + event.getParam('libelleVoie')+
            '&c__complementAdresse=' + event.getParam('complementAdresse')+
            '&c__CP=' + event.getParam('CP')+
            '&c__city=' + event.getParam('city')+
            '&c__AccountId='+event.getParam('AccountId')+	
            '&c__AccountId='+event.getParam('AccountId')+	
            '&c__isMensualisee='+event.getParam('isMensualisee')+	
            '&c__factureEnLigne='+event.getParam('factureEnLigne');

             console.log("urlOmni"+urlOmni);
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Payeur Divergent"});
            }).catch(function(error) {
           		console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });  
    },
    //KDI FT2-1616: Migration Vlocity de la Synthèse des Blocages
   openSyntheseBlocage  : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {   
            var urlOmni = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactSyntheseBlocageFrench&c__layout=lightning&c__tabLabel=Info blocage&c__tabIcon=standard:dashboard&c__id='+component.get("v.recordId")+
            '&c__ContextId=' + component.get("v.recordId")+
            '&c__numeroVoie=' + event.getParam('numeroVoie')+
            '&c__libelleVoie=' + event.getParam('libelleVoie')+
            '&c__complementAdresse=' + event.getParam('complementAdresse')+
            '&c__codePostal=' + event.getParam('codePostal')+
            '&c__ville=' + event.getParam('ville')+
            '&c__blocageRelance=' + event.getParam('blocageRelance')+
            '&c__libelleMotifBlocageRelance=' + event.getParam('libelleMotifBlocageRelance')+
            '&c__dateDebutBlocageRelance=' + event.getParam('dateDebutBlocageRelance')+
            '&c__dateFinBlocageRelance=' + event.getParam('dateFinBlocageRelance')+
            '&c__blocageFacturation=' + event.getParam('blocageFacturation')+
            '&c__libelleMotifBlocageFacturation=' + event.getParam('libelleMotifBlocageFacturation')+
            '&c__dateDebutBlocageFacturation=' + event.getParam('dateDebutBlocageFacturation')+
            '&c__dateFinBlocageFacturation=' + event.getParam('dateFinBlocageFacturation')+
            '&c__blocageDecaissement=' + event.getParam('blocageDecaissement')+
            '&c__libelleMotifBlocageDecaissement=' + event.getParam('libelleMotifBlocageDecaissement')+
            '&c__dateDebutBlocageDecaissement=' + event.getParam('dateDebutBlocageDecaissement')+
            '&c__dateFinBlocageDecaissement=' + event.getParam('dateFinBlocageDecaissement')+
            '&c__blocagePrevelement=' + event.getParam('blocagePrevelement')+
            '&c__libelleMotifBlocagePrevelement=' + event.getParam('libelleMotifBlocagePrevelement')+
            '&c__dateDebutBlocagePrevelement=' + event.getParam('dateDebutBlocagePrevelement')+
            '&c__NoBlocage=' + event.getParam('NoBlocage')+
            '&c__listSyntheseBlocage=' + event.getParam('listSyntheseBlocage')+
            '&c__NoCompteContrat='+event.getParam('NoCompteContrat');


             console.log("urlOmni"+urlOmni);
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Info blocage"});
            }).catch(function(error) {
           		console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });  
    },
    // Dossier Recouvrement
	openRecouvrement : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {   
            var urlOmni = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactRecouvrementFrench&c__layout=lightning&c__tabLabel=Recouvrement&c__tabIcon=custom:custom18&c__id='+component.get("v.recordId")+
            '&c__ContextId=' + component.get("v.recordId") +
            '&c__IdBusinessPartner=' + event.getParam('IdBusinessPartner') +
            '&c__IdPortefeuilleContrat=' + event.getParam('IdPortefeuilleContrat') +
            '&c__NoCompteContratMaj='+event.getParam('NoCompteContratMaj') +
            '&c__NoCompteContrat='+event.getParam('NoCompteContrat') +
            '&c__IdDossierRecouvrement='+event.getParam('IdDossierRecouvrement')+
            '&c__libelleVoie='+event.getParam('libelleVoie')+
            '&c__isBlocageRelance='+event.getParam('isBlocageRelance')+
            // FT2-1303 - [Suivi de coupure] Affichage infos client & demande sur facturation
            '&c__Nvoie='+event.getParam('Nvoie')+
            '&c__complementAdresse='+event.getParam('complementAdresse')+
            '&c__CP='+event.getParam('CP')+
            '&c__ville='+event.getParam('ville')+
            '&c__solde='+event.getParam('solde')+
            '&c__modePaiement='+event.getParam('modePaiement')+
            '&c__drp='+event.getParam('drp')+
            '&c__idcompteclient='+event.getParam('idcompteclient')+
             //FT2-1208: [Suivi de coupure] Création Objet prestation distrib (objet OPS)
            '&c__PDL='+event.getParam('PDL') +
            '&c__AccountId='+event.getParam('AccountId') + //FT2-1553 Création du case
            ////FT2-1503: [Clients Coupés Pour Non-Paiement] Créer une demande de prestation (Client coupé / Client en réduction de puissance)
            '&c__idContrat='+event.getParam('idContrat')
            +'&c__EnqSat='+ JSON.stringify(event.getParam('EnqSat'));           
             console.log("urlOmni"+urlOmni);
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                url: urlOmni,
                focus: true
            }).then(function(subtabId) {
            	workspaceAPI.setTabLabel({
                	tabId: subtabId,
                	label: "Recouvrement"});
            }).catch(function(error) {
           		console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },



    // Services gratuits
    openFreeServices : function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__SM_FreeServicesContainer"
                    },
                        "state": {
                        uid:"1",  
                        c__edocumentstatus: event.getParam('eDocumentStatus'),
                        c__felstatus: event.getParam('felStatus'),
                        c__customerareaunavailable: event.getParam('customerAreaUnavailable'),
                        c__noemail: event.getParam('noEmail'),
                        c__recordid: event.getParam('recordId'),
                        c__accountcontract: event.getParam('accountContract')
                    }
                }, 
                focus: true
            }).then(function(subtabId) {
                workspaceAPI.setTabLabel({
                    tabId:subtabId,
                    label: "Services Gratuits"});
            }).catch(function(error) {
                        console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    openOutilEstimation: function(component, event) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {   
            var urlOmni = '/lightning/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c:smContactOutilEstimationFrench&c__layout=lightning&c__tabIcon=custom:custom18' +
            '&c__ContextId=' + component.get("v.recordId") +
            '&c__refClientIdBP=' + (event.getParam('IdBusinessPartner') || '')+
            '&c__AccountId=' + (event.getParam('AccountId') || '')+
            '&c__listOrderedAdresses=' + JSON.stringify (event.getParam('listOrderedAdresses') || '')+
            '&c__IdLocal=' +  event.getParam('IdLocal')+
            '&c__idPortefeuilleContrat=' +  event.getParam('idPortefeuilleContrat') +
            '&c__IdBusinessPartner=' + (event.getParam('IdBusinessPartner') || '')+
            '&c__numeroLocal='+ event.getParam('numeroLocal')+
            '&c__EnqSat='+ event.getParam('EnqSat');
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
             label: "Outil d'estimation"});
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
    },

    /* Méthode permettant d'ouvrir un sous onglet pour l'historique des demandes symphonie */
    openHistoriqueSymphonie: function(component, event) {
        var workspaceAPI = component.find("workspace");
        console.log('idPersonneMovin: '+event.getParam('IdPersonne'));
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            workspaceAPI.openSubtab({
                parentTabId: tabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__SM_HistoriqueSymphonie"
                    },
                        "state": {
                        uid:"1",  
                        c__idPersonne: event.getParam('IdPersonne')
                    }
                }, 
                focus: true
            }).then(function(subtabId) {
                workspaceAPI.setTabLabel({
                    tabId:subtabId,
                    label: "Historique des contacts Symphonie"});
            }).catch(function(error) {
                        console.log(error);
            });
        }).catch(function(error) {
            console.log(error);
        });
    }

})