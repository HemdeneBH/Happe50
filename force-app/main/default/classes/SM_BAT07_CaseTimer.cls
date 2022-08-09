/**
* @author        :  Walid MOUMEN
* @date          :  08/02/2022
* @description   :  [Cycle de vie du case] - (Evol)Problème de limit de Time-Base-Workflow mise en place d'un batch
* @us            :  SMILE PI#03 , FT3-1524
**/

public without sharing class SM_BAT07_CaseTimer implements Database.Batchable<SObject> , Database.Stateful {

    // Pour capter l'exception s'il y en a
    Exception[] errors     = new Exception[0];
    
    public Database.querylocator start(Database.BatchableContext bc){
        return SM_SM07_CaseTimerAction.startMethod();
    } 

    public void execute( Database.BatchableContext bc, List<Case> listCases){
   
        //traitement des cases récupèrer
        if (listCases.size() > 0) {
            try {

                // splitter les case en différents collections selon l'action
                Map<String, List<Case>> splitedListCase= SM_SM07_CaseTimerAction.splitCase(listCases);
               
                // exécuter les actions spécifiques pour les cases
                Map<String, List<Case>> listCaseActionsToExecute= SM_SM07_CaseTimerAction.executeCaseAction(splitedListCase);
               
                // m-à-j des cases
                SM_SM07_CaseTimerAction.updateCase(listCases);

            } catch(Exception e) {
                errors.add(e);
            }
        }

   }

    public void finish(Database.BatchableContext bc){
        // Logger les erreurs d'exception
        SM_SM07_CaseTimerAction.checkForErrors(errors);
    }


}