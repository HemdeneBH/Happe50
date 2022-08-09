/*@Author: Eloi Dereeper
*@Description: Controlleur Apex du LWC ParcoursPpRoundButton
*@CreatedDate: 15/12/2020
*@LastModified: 22/12/2020
*/
public without sharing class VI_ParcoursPpRoundButton_Controller { 
    /*@Author: Eloi Dereeper
*@Description: ajouter un commentaire sur le parours--> n'est plus utilisé
*@CreatedDate: 15/12/2020
*@LastModified: 22/12/2020
*/
    @AuraEnabled
    public static void transfererParcours(VI_Parcours__c  parcours, String comments){
        parcours.VI_CommentairesTransfertAppel__c = comments;
        update parcours;
    }
        /*@Author: Eloi Dereeper
*@Description: ajouter un commentaire sur le parours dans une etape
*@CreatedDate: 15/12/2020
*@LastModified: 22/12/2020
*/
    
    @AuraEnabled
    public static void writeComment(VI_Parcours__c  parcours, String comments,String step){
        System.debug('EDE Debug; parcours : ' + parcours);
        if(!(parcours.VI_StatutParcours__c.equals('CPV Envoyées: PDL/PCE connu') || parcours.VI_StatutParcours__c.equals('CPV Envoyées: PDL/PCE non connu'))){
            if(step.equals('situation')    || step.equals('energy')){
                parcours.VI_CommentaireGeneral_idbesoin__c=comments;
            }
            else if(step.equals('client_energy')){
                parcours.VI_CommentaireGeneral_idclient__c=comments;
            }
            else if(step.equals('identification_local')){
                parcours.VI_CommentaireGeneral_idlocal__c=comments;
            }
            else if(step.equals('EstimationConsommation')){
                parcours.VI_CommentaireGeneral_EstimationConso__c=comments;
            }
            else if(step.equals('ConstitutionPanier')){
                parcours.VI_CommentaireGeneral_Constitutionpanier__c=comments;
            }
            if(step.equals('DateEffetContrat')    || step.equals('RelevesCompteur')){
                parcours.VI_CommentaireGeneral_InfosCompl__c=comments;
            }
            else if(step.equals('Saisie_moyen_de_paiement')){
                parcours.VI_CommentaireGeneral_MoyensPaiement__c=comments;
            }
            else if(step.equals('Recapitulatif')){
                parcours.VI_CommentairesParcours__c=comments;
            }
            update parcours;
        }
    }
    /*@Author: Eloi Dereeper
*@Description: reprendre le parours plus tard sans tache --> Ajout d'un commentaire sur le parcours 
*@CreatedDate: 15/12/2020
*@LastModified: 22/12/2020
*/
    @AuraEnabled
    public static void reprendrePlutardSansTache(VI_Parcours__c  parcours,String comments){
        parcours.VI_CommentairesReprendreParcours__c = comments;
        try{
            update parcours;
        }
        catch(Exception e){
            System.debug('L\'update du parcours a échoué');
            throw e;
        }
    }
    /*@Author: Eloi Dereeper
*@Description: reprendre le parours plus tard avec tache --> Ajout d'un commentaire sur le parcours + une tâche est crée
*@CreatedDate: 15/12/2020
*@LastModified: 22/12/2020
*/    
    @AuraEnabled
    public static void createTask(VI_Parcours__c  parcours, Date dateEcheance, String heureEcheance, String description, String comments, Boolean planTask){
        
        System.debug('EDE Debug; create Task for parcours : ' + parcours);
        System.debug('heureEcheance ' + heureEcheance);
        String currentUserId=Userinfo.getUserId();
        String currentParcoursContactLastName;
        String currentParcoursContactPhone;
        User currentUser=[SELECT Id, AccountId,account.name, Account.VI_TypeParcours__c, Account.VI_Groupe_Fonctionnel__c
                          FROM User  
                          WHERE Id =:currentUserId
                          LIMIT 1];
        String queueName='VI_'+currentUser.account.name;
        parcours.VI_CommentairesReprendreParcours__c = comments;
        system.debug('queueName '+queueName);
        if(planTask){
            
            // Task creation
            Datetime datetimeEcheance= Datetime.newInstance(dateEcheance.year(), dateEcheance.month(), dateEcheance.day(),
                                                            Integer.valueOf(heureEcheance.substringBefore(':')), Integer.valueOf(heureEcheance.substringAfter(':')), 0);
            
            system.debug('description '+description);
            system.debug('comments '+comments);
            parcours.VI_DescriptionTache__c = description;
            parcours.VI_DateEcheanceTache__c = dateEcheance;
            parcours.VI_HeureEcheanceTache__c = Time.newInstance( Integer.valueOf(heureEcheance.substringBefore(':')), Integer.valueOf(heureEcheance.substringAfter(':')), 0, 0);
            parcours.VI_PlanifierTache__c = true;
            parcours.VI_StatutParcours__c = 'Vente à compléter';

            Task tache = new Task();
            tache.WhatId = parcours.Id;
            tache.OwnerId =Userinfo.getUserId();
            tache.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('PurePlayerTask').getRecordTypeId();
            tache.ActivityDate = dateEcheance;
            tache.IsReminderSet=true;
            tache.ReminderDateTime=datetimeEcheance.addMinutes(-30);
            tache.Description=description;
            tache.Type='Appel';
            //tache.VI_DateEtHeureEcheance__c=datetimeEcheance;
            tache.Subject = 'Rappel parcours '+parcours.name;
            tache.VI_Site_prestataire__c = parcours.VI_TECH_SitePrestatairePartenaire__c;
            tache.VI_TypeDuSitePrestataire__c = parcours.VI_TECH_TypeDuSitePrestataire__c;
            system.debug('¤ VI_TECH_NomDuClient__c : ' + parcours.VI_TECH_NomDuClient__c);
            system.debug('¤ VI_TelephonePrincipal__c : ' + parcours.VI_TECH_TelephonePrincipal__c);
            if(parcours.VI_Contact__c!=null && (parcours.VI_TECH_NomDuClient__c==null || parcours.VI_TECH_TelephonePrincipal__c==null)){
                System.debug('dans if contact');
                System.debug('1');
                List<Contact> listCurrentParcoursContact = [SELECT Id, LastName,TechMobilePrincipale__c ,TechFixePrincipale__c
                          FROM Contact 
                          WHERE Id =:parcours.VI_Contact__c];
                          System.debug('2');
                          System.debug('Select');
                          System.debug(listCurrentParcoursContact);
                if(listCurrentParcoursContact!=null && listCurrentParcoursContact.size()>0){
                    if(listCurrentParcoursContact[0].LastName!=null){
                        currentParcoursContactLastName=listCurrentParcoursContact[0].LastName;
                    }
                    if(listCurrentParcoursContact[0].TechMobilePrincipale__c!=null){
                        currentParcoursContactPhone=listCurrentParcoursContact[0].TechMobilePrincipale__c;
                    }
                    else if (listCurrentParcoursContact[0].TechFixePrincipale__c!=null)
                    {
                        currentParcoursContactPhone=listCurrentParcoursContact[0].TechFixePrincipale__c;
                    }
                }
            }
            System.debug('3');
            System.debug('VI_TECH_NomDuClient__c : ' + parcours.VI_TECH_NomDuClient__c);
            System.debug('currentParcoursContactLastName : ' + currentParcoursContactLastName);
            if(parcours.VI_TECH_NomDuClient__c!=null){
                tache.VI_NomClient__c=parcours.VI_TECH_NomDuClient__c;
            }
            else{
                tache.VI_NomClient__c=currentParcoursContactLastName;
            }
            System.debug('5');
            if(parcours.VI_TECH_TelephonePrincipal__c!=null){
                tache.VI_TelephonePrincipal__c=parcours.VI_TECH_TelephonePrincipal__c;
            }
            else{
                tache.VI_TelephonePrincipal__c=currentParcoursContactPhone;
            }
            System.debug('après le if contact');
            tache.VI_DateDeCreationDuParcours__c = parcours.CreatedDate;
            tache.VI_StatutDuCase__c = parcours.VI_StatutCasePartnerCommunity__c;
            tache.VI_StatutDuParcours__c = parcours.VI_StatutParcours__c;
            tache.VI_WhatName__c=parcours.name;
            if (comments.length() > 254) {
                tache.VI_ApercuDuCommentaire__c = comments.substring(0, 254);
            }
            else {
                tache.VI_ApercuDuCommentaire__c = comments;
            }
            // try{
            insert tache;
            //   }
            //   catch(Exception e){
            //       System.debug('La création de la tâche a échoué');
            //       throw e;
            //   }
        }
        try{
            update parcours;
            system.debug('¤ parcours updaté');
        }
        catch(Exception e){
            System.debug('L\'update du parcours a échoué');
            throw e;
        }
    }
    
    /*@Author: Eloi Dereeper
*@Description: Annulé le parcours --> saisir un motif, commentaire et changement de statut
*@CreatedDate: 15/12/2020
*@LastModified: 22/12/2020
*/     
    
    @AuraEnabled
    public static void annulerParcours(VI_Parcours__c  parcours, String motif, Boolean regie, Boolean tempo, String commentaire){
        
        parcours.VI_MotifAnnulationParcours__c = motif;
        parcours.VI_StatutParcours__c = 'Annulé';
        parcours.VI_CommentairesAnnulerParcours__c = commentaire;
        system.debug('parcours.VI_Case__c'+ parcours.VI_Case__c);
        /* TODO : 
* Implémenter le traitement de Régie/tempo
* Voir le délai de 1h 2 h avant annulation défintive
*/
        
        try{
            update parcours;
            case caseToUpdate = new Case(Id = parcours.VI_Case__c, Status = 'Annulé');
            update caseToUpdate;
        }
        catch (Exception e){
            System.debug('L\'annulation du parcours a échoué');
            throw e;
        }
    }
}