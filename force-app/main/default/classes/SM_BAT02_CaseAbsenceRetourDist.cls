/**
 * @File Name          : SM_BAT02_CaseAbsenceRetourDist
 * @Description        : Batch pour mettre à jour le(s) Case(s) 
 * @Author             : Geetha SENTHILNATHAN
 * @Group              : 

 * @Last Modified By   : Hayfa GARBOUT

 * @Last Modified On   : 14/01/2022

 * Ver       Date            Author      		    Modification
 * 1.0    11/09/2020      Equipe Dev SMILE-FT3     Initial Version
 * 2.0    08/10/2020      Equipe Dev SMILE-FT3     Initial Version
**/
public without sharing class SM_BAT02_CaseAbsenceRetourDist implements Database.Batchable<SObject>, Database.Stateful {


    // nombre de CASE traités et le nbr de jours du timer
    Integer nbCaseTraite , SM_CL45_TimerEnAttenteRetourDistributeur;

    // Pour capter l'exception s'il y en a
    Exception[] errors = new Exception[0];
    
    // Constructeur pour initer le variable à 0
    public SM_BAT02_CaseAbsenceRetourDist() {
        nbCaseTraite=0;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {

        // Récupérer les OPS 

        // qui ont la date de prestation passée plus de XX jours
        SM_CL45_TimerEnAttenteRetourDistributeur = Integer.valueOf(System.Label.SM_CL45_TimerEnAttenteRetourDistributeur);
        Date myDate = System.today().addDays(-SM_CL45_TimerEnAttenteRetourDistributeur);


        return Database.getQueryLocator([SELECT Id, Date_de_prestation__c, Statut__c, 
                                         Case__r.Id, Case__r.Sous_statut__c 
                                         FROM Prestation_distributeur__c 
                                         WHERE Statut__c IN ('A initier','En cours') 
                                         AND Case__r.TECH_dernier_niveau_escalade__c = null
                                         AND Case__r.Status = 'En attente'
                                         AND Case__r.Sous_statut__c = 'Retour distributeur' 
                                         AND Date_de_prestation__c <= :myDate
                                         AND RecordType.DeveloperName = 'SM_PrestationDistributeur']);
    }
    
    public static void execute(){
        // Instanciation de batch
		SM_BAT02_CaseAbsenceRetourDist absenceRetourDistBatch = new SM_BAT02_CaseAbsenceRetourDist();
		Database.executeBatch(absenceRetourDistBatch);
	}
    
    public void execute(Database.BatchableContext bc, List<Prestation_distributeur__c> listOPS){

        // Si il y a des OPS qui sont en attente de distributeur pour plus de 6 jours, 

        // on met à jour les Case concernés avec un sous statut 'Absence retour distributeur' et la priorité haute
        System.debug('OPS size : '+listOPS.size());
        if (listOPS.size() > 0) {
            try {
                updateCaseWithAbsenceRetourDistributeur(listOPS);


            } catch(Exception e) {
                errors.add(e);
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        // Logger les erreurs d'exception
        if(!errors.isEmpty()) {
            System.debug('### Errors occured during batch process ###');
            for (Exception e : errors) {
                System.debug(e.getStackTraceString()+'\n');
            }
        }
        System.debug('### Number of Cases treated : '+ nbCaseTraite);
	}
    
    // Méthode qui reouvert les cases
    private void updateCaseWithAbsenceRetourDistributeur(List<Prestation_distributeur__c> listPrestationDist) {
        List<Id> idsCase = new List<Id>();
        for (Prestation_distributeur__c ops : listPrestationDist) {
            idsCase.add(ops.Case__r.Id);
        }
        List<Case> casesToUpdate = [SELECT Id,recordType.developername,Origin FROM Case WHERE Id IN:idsCase];
        nbCaseTraite = casesToUpdate.size();
        System.debug('Case trouvé : '+casesToUpdate.size());
        for (Case c : casesToUpdate) {
            if (
                ((c.recordType.developername == 'Service') || (c.recordType.developername == 'Acquisition') || (c.recordType.developername == 'Detection_de_projet_C'))
                && ((c.Origin == 'Téléphone')||(c.Origin == 'Phone'))
                ) {
                    c.OwnerId = System.Label.SM_Case_Queue_A_Traiter_Genesys_Id	;
                    c.Priority = 'High';
                    c.Status = 'A traiter';
                    c.Sous_statut__c = 'Absence retour distributeur';
                }
        }
        Database.SaveResult[] resultOfUpdate = Database.update(casesToUpdate, false);
        //catchError(resultOfUpdate);
    }
    
    // méthode pour logger les erreurs pendant les enregistrements 
    /*private static void catchError(Database.SaveResult[] listUpdate){
		for (Database.SaveResult sr : listUpdate) {
			if (!sr.isSuccess()) {
				// Operation failed, so get all errors                
				for(Database.Error err : sr.getErrors()) {
					System.debug('The following error has occurred.');                    
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('Fields that affected this error: ' + err.getFields());
				}
			}
		}
	}*/
}