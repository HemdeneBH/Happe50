/*@Author: Eloi Dereeper
*@Description: Classe test de VI_ParcoursPpRoundButton_Controller
*@CreatedDate: 15/12/2020
*@LastModified: 22/12/2020
*/
@IsTest
public class VI_ParcoursPpRoundButton_Controller_Test { 
    
    @IsTest
    public static void transfererParcours_Test(){
        
        VI_Parcours__c parcours = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        insert parcours;
        
        VI_ParcoursPpRoundButton_Controller.transfererParcours(parcours, 'Test commentaire transfert');
        
        VI_Parcours__c parcoursCtrl = [SELECT Id, VI_CommentairesTransfertAppel__c FROM VI_Parcours__c WHERE Id = :parcours.Id];
        
        System.assertEquals('Test commentaire transfert', parcoursCtrl.VI_CommentairesTransfertAppel__c);
        
        
    }
        @IsTest
    public static void reprendrePlutardSansTache_Test(){
        
        VI_Parcours__c parcours = new VI_Parcours__c();
        parcours.VI_StatutParcours__c='Vente en cours';
        parcours.VI_TypeParcours__c ='PURE PLAYERS';
        insert parcours;
        
        VI_ParcoursPpRoundButton_Controller.reprendrePlutardSansTache(parcours, 'Test reprendre Plutard');
        VI_Parcours__c parcoursCtrl = [SELECT Id, VI_CommentairesReprendreParcours__c
                                       FROM VI_Parcours__c 
                                       WHERE Id = :parcours.Id];
        System.assertEquals('Test reprendre Plutard', parcoursCtrl.VI_CommentairesReprendreParcours__c);
    }
    
    @IsTest
    public static void writeComment_Test(){
        
        VI_Parcours__c parcours = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        parcours.VI_StatutParcours__c='Vente en cours';
        insert parcours;
        
		
        
        VI_ParcoursPpRoundButton_Controller.writeComment(parcours, 'Test Commentaire Energy','energy');
        VI_ParcoursPpRoundButton_Controller.writeComment(parcours, 'Test Commentaire Client','client_energy');
        VI_ParcoursPpRoundButton_Controller.writeComment(parcours, 'Test Commentaire Local','identification_local');
        VI_ParcoursPpRoundButton_Controller.writeComment(parcours, 'Test Commentaire Conso','EstimationConsommation');
        VI_ParcoursPpRoundButton_Controller.writeComment(parcours, 'Test Commentaire Panier','ConstitutionPanier');
        VI_ParcoursPpRoundButton_Controller.writeComment(parcours, 'Test Commentaire Info','DateEffetContrat');
        VI_ParcoursPpRoundButton_Controller.writeComment(parcours, 'Test Commentaire Payement','Saisie_moyen_de_paiement');
        VI_ParcoursPpRoundButton_Controller.writeComment(parcours, 'Test Commentaire Recap','Recapitulatif');
        VI_Parcours__c parcoursCtrl = [SELECT Id,  VI_CommentaireGeneral_idbesoin__c,VI_CommentaireGeneral_idlocal__c, VI_CommentaireGeneral_idclient__c,
VI_CommentaireGeneral_EstimationConso__c, VI_CommentaireGeneral_Constitutionpanier__c, VI_CommentaireGeneral_InfosCompl__c, VI_CommentaireGeneral_MoyensPaiement__c, VI_CommentairesParcours__c
                                       FROM VI_Parcours__c 
                                       WHERE Id = :parcours.Id];
        System.assertEquals('Test Commentaire Energy', parcoursCtrl.VI_CommentaireGeneral_idbesoin__c);
        System.assertEquals('Test Commentaire Client', parcoursCtrl.VI_CommentaireGeneral_idclient__c);
        System.assertEquals('Test Commentaire Local', parcoursCtrl.VI_CommentaireGeneral_idlocal__c);
        System.assertEquals('Test Commentaire Conso', parcoursCtrl.VI_CommentaireGeneral_EstimationConso__c);
        System.assertEquals('Test Commentaire Panier', parcoursCtrl.VI_CommentaireGeneral_Constitutionpanier__c);
        System.assertEquals('Test Commentaire Info', parcoursCtrl.VI_CommentaireGeneral_InfosCompl__c);
        System.assertEquals('Test Commentaire Payement', parcoursCtrl.VI_CommentaireGeneral_MoyensPaiement__c);
        System.assertEquals('Test Commentaire Recap', parcoursCtrl.VI_CommentairesParcours__c);
    }
    
    @IsTest
    public static void createTask_Test(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];

        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.VI_TypeParcours__c ='PURE PLAYERS';
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        insert u;
        
        System.runAs(u){
            VI_Parcours__c parcours = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            insert parcours;
            Date d = System.now().date();
            String tString = '21:30';
            Time t = Time.newInstance( Integer.valueOf(tString.substringBefore(':')), Integer.valueOf(tString.substringAfter(':')), 0, 0);
            VI_Parcours__c parcoursCtrl = [SELECT Id,Name, CreatedDate, VI_CommentairesReprendreParcours__c, VI_DateEcheanceTache__c, VI_HeureEcheanceTache__c, VI_DescriptionTache__c,
                                           VI_PlanifierTache__c, VI_TECH_SitePrestatairePartenaire__c, VI_TECH_TypeDuSitePrestataire__c, VI_TECH_NomDuClient__c,
                                           VI_TECH_TelephonePrincipal__c, VI_StatutCasePartnerCommunity__c, VI_StatutParcours__c,VI_Contact__c,VI_TypeParcours__c
                                           FROM VI_Parcours__c 
                                           WHERE Id = :parcours.Id];
            VI_ParcoursPpRoundButton_Controller.createTask(parcoursCtrl, d, tString, 'Test de Description', 'Test commentaire createTask', true) ; 
            
            
            
            System.assertEquals('Test commentaire createTask', parcoursCtrl.VI_CommentairesReprendreParcours__c);
            System.assertEquals(d, parcoursCtrl.VI_DateEcheanceTache__c);
            System.assertEquals(t, parcoursCtrl.VI_HeureEcheanceTache__c);
            System.assertEquals('Test de Description', parcoursCtrl.VI_DescriptionTache__c);
            System.assertEquals(true, parcoursCtrl.VI_PlanifierTache__c);
        }
        Task ctrlTask2 = [SELECT Id, OwnerId, ActivityDate, Subject, VI_Site_prestataire__c, VI_TypeDuSitePrestataire__c, VI_NomClient__c,
                          VI_TelephonePrincipal__c, VI_DateDeCreationDuParcours__c, VI_StatutDuCase__c, VI_StatutDuParcours__c
                          FROM Task];
        system.debug('ctrlTask2 '+ctrlTask2);
        
    }
    
    @IsTest
    public static void annulerParcours_Test(){
        Case caseToInsert = new Case();
        insert caseToInsert;
        VI_Parcours__c parcours = VI_TestDataFactory.createParcours('CHF',caseToInsert.Id, 'PURE PLAYERS');
        insert parcours;
		VI_ParcoursPpRoundButton_Controller.annulerParcours(parcours, 'Client injoignable', false, false, 'Commentaire Annulation') ;
        
        VI_Parcours__c parcoursCtrl = [SELECT Id, VI_MotifAnnulationParcours__c, VI_StatutParcours__c, VI_CommentairesAnnulerParcours__c FROM VI_Parcours__c WHERE Id = :parcours.Id];
        System.assertEquals('Client injoignable', parcoursCtrl.VI_MotifAnnulationParcours__c);
        System.assertEquals('Annulé', parcoursCtrl.VI_StatutParcours__c);
        System.assertEquals('Commentaire Annulation', parcoursCtrl.VI_CommentairesAnnulerParcours__c);
    }
    
}