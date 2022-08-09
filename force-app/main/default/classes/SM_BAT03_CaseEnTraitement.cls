public class SM_BAT03_CaseEnTraitement implements Database.Batchable<sObject>, Database.Stateful{
    
    Exception[] errors = new Exception[0];

   public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([SELECT Id,Status,OwnerId,Last_Modified_By_Custom__c From Case 
                                       where (Status = 'En Traitement' AND 
                                              (RecordType.DeveloperName like 'Acquisition' OR 
                                               (RecordType.DeveloperName like 'Service' AND (Origin = 'Phone' or Origin = 'Téléphone')
                                              ) ))]);
   }
   
   public void execute( Database.BatchableContext BC, List<Case> listCases){
      if (listCases.size() > 0) {
            try {
                updateCase(listCases);


            } catch(Exception e) {
                errors.add(e);
            }
        }
   }
    public void finish(Database.BatchableContext BC){
        if(!errors.isEmpty()) {
            System.debug('### Errors occured during batch process ###');
            for (Exception e : errors) {
                System.debug(e.getStackTraceString()+'\n');
            }
        }
   }
    
    private void updateCase(List<Case> listCases) {
        for (Case caseToUpdate : listCases) {
             caseToUpdate.Status = 'Préclôturé';
             caseToUpdate.Sous_statut__c = 'Abandon';
            caseToUpdate.OwnerId =(!String.isblank(caseToUpdate.Last_Modified_By_Custom__c))? caseToUpdate.Last_Modified_By_Custom__c:caseToUpdate.OwnerId;
        }
        Database.SaveResult[] resultOfUpdate = Database.update(listCases, false);
    }
}