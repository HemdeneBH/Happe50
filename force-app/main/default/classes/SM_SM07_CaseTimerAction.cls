/**
 * @author Walid MOUMEN
 * @date 09/02/2022
 * @description SM_SM07_CaseTimerAction - ui permet d'exécuter des actions enfonction du type d'action du case
 */

public without sharing class SM_SM07_CaseTimerAction { 

    /**
     * @author Walid MOUMEN
     * @date 09/02/2022
     * @param cases List of cases 
     * @description  spliter la liste des case selon les actions 
     * @return 
     */
    public static Map<String, List<Case>>  splitCase(List<Case> cases) {

        Map<String, List<Case>> caseMap = new Map<String, List<Case>>();

        For(Case req : cases){
            String keyPattern = req.SM_TECH_TimerTypeAction__c ;
            if(caseMap.keySet().contains(keyPattern)){
                caseMap.get(keyPattern).add(req);
            }else {
                caseMap.put(keyPattern, new List<Case>{req});
        }
        }
        return caseMap ;
    }
    
    /**
     * @author Walid MOUMEN
     * @date 09/02/2022
     * @param caseSplitedList  Map<String, List<Case>>
     * @description  les actions spécifiques a executer pour les cases
     * @return 
     * @last modified on  : 28-03-2022
	 * @last modified by  : Ayoub EL FARISSI
	 * Modifications Log
     * Ver   Date         Author          Modification
     * 1.0   09-02-2022   Walid MOUMEN    Initial Version
     * 1.1   28-03-2022   Ayoub EL FARISSI    change sub-status "Abandon" to "Expire"
     */    

    public static Map<String, List<Case>>  executeCaseAction(Map<String, List<Case>> caseSplitedList) {

        //get custom  Labels 
        String actionPreClotureExpire = String.valueOf(System.Label.SM_CL60_Action_Pre_Cloture_Expire);
        String actionATraiter = String.valueOf(System.Label.SM_CL61_Action_A_Traiter);
        String actionCloture = String.valueOf(System.Label.SM_CL62_Action_Cloture);
        String actionATraiterAbsenceRetourPartenaire = String.valueOf(System.Label.SM_CL63_Action_A_Traiter_Absence_Retour_Partenaire);
        String actionATraiterAbsenceRetourDistributeur = String.valueOf(System.Label.SM_CL64_Action_A_Traiter_Absence_Retour_Distributeur);
        String actionATraiterAbsenceRetourClient = String.valueOf(System.Label.SM_CL65_Action_A_Traiter_Absence_Retour_Client);
        String actionATraiterRetourCDS = String.valueOf(System.Label.SM_CL66_Action_A_Traiter_Retour_CDS);
        String actionATraiterRetourTresorerieComplexe = String.valueOf(System.Label.SM_CL67_Action_A_Traiter_Retour_Tresorerie_Complexe);
        String actionCaseNotClosed = String.valueOf(System.Label.SM_CL94_Case_not_closed);
        String hRCaseQueueATraiterId = String.valueOf(System.Label.HR_Case_Queue_A_Traiter_Id);
        String SMCaseQueueDPATraiter = String.valueOf(System.Label.SM_Case_Queue_Detection_Projet_A_Traiter_Id);

        String statusEnAttente = String.valueOf(System.Label.SM_CL68_Status_En_Attente);
        String statusPreCloture = String.valueOf(System.Label.SM_CL69_Status_Pre_Cloture);
        String statusDiffere = String.valueOf(System.Label.SM_CL70_Status_Differe);
        String statusCloture = String.valueOf(System.Label.SM_CL71_Status_Cloture);
        String statusAtraiter = String.valueOf(System.Label.SM_CL72_Status_A_traiter);
        String statusNouveau = String.valueOf(System.Label.SM_CL95_Status_Nouveau);        

        String sousStatutRetourSignature = String.valueOf(System.Label.SM_CL73_Sous_Statut_Retour_Signature);
        String sousStatutRetourClient = String.valueOf(System.Label.SM_CL74_Sous_Statut_Retour_Client);
        String sousStatutRetourCDS = String.valueOf(System.Label.SM_CL75_Sous_Statut_Retour_CDS);
        String sousStatutRetourTresorerieComplexe = String.valueOf(System.Label.SM_CL76_Sous_Statut_Retour_Tresorerie_Complexe);
        String sousStatutRetourPartenaire = String.valueOf(System.Label.SM_CL77_Sous_Statut_Retour_Partenaire);
        String sousStatutAbsencRetourPartenaire = String.valueOf(System.Label.SM_CL78_Sous_Statut_Absence_Retour_Partenaire);
        String sousStatutAbsenceRetourDistributeur = String.valueOf(System.Label.SM_CL79_Sous_Statut_Absence_Retour_Distributeur);
        String sousStatutAbsenceRetourClient = String.valueOf(System.Label.SM_CL80_Sous_Statut_Absence_Retour_Client);
        String sousStatutExpire = String.valueOf(System.Label.SM_CL81_Sous_Statut_Expire);
        String sousStatusRetourDistributeur = String.valueOf(System.Label.SM_CL89_Sous_Statut_Retour_Distributeur);

        String recordTypeDNAcqHR = String.valueOf(System.Label.SM_CL82_RecordType_DN_AcqHR);
        String recordTypeDNService = String.valueOf(System.Label.SM_CL83_RecordType_DN_Service);
        String recordTypeDNAcq = String.valueOf(System.Label.SM_CL84_RecordType_DN_Acq);
        String recordTypeDNDP = String.valueOf(System.Label.SM_CL85_RecordType_DN_DP);

        String priorityHigh = String.valueOf(System.Label.SM_CL86_Priority_High);
        String techTypeOfficeBO = String.valueOf(System.Label.SM_CL87_TECH_Type_Office_BO);
        String originPC = String.valueOf(System.Label.SM_CL88_Origin_PC);
        String originTL = String.valueOf(System.Label.SM_CL96_Origin_TL);

        

        For(String key : caseSplitedList.keySet()){
            
            IF(key == actionPreClotureExpire){
                System.debug(actionPreClotureExpire);
                List<Case> casePreClotureExpire = caseSplitedList.get(actionPreClotureExpire);                
                For(Case c: casePreClotureExpire){
                    if( ( (c.status== statusEnAttente && c.Sous_statut__c == sousStatutRetourSignature) || (c.status== statusEnAttente && c.Sous_statut__c == sousStatutRetourClient && c.TECH_dernier_niveau_escalade__c ==null ) )  && (c.RecordType.DeveloperName == recordTypeDNAcqHR || c.RecordType.DeveloperName == recordTypeDNService || c.RecordType.DeveloperName == recordTypeDNAcq) ){
                        c.Status = statusPreCloture;
                        c.Sous_statut__c=sousStatutExpire;
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                } 
            }
            else if(key == actionATraiter){
                System.debug(actionATraiter);
                List<Case> caseATraiter = caseSplitedList.get(actionATraiter);
                For(Case c: caseATraiter){
                    if( c.status== statusDiffere && (c.RecordType.DeveloperName == recordTypeDNAcqHR || (c.RecordType.DeveloperName == recordTypeDNService && c.Origin == originTL))){
                        c.Status = statusAtraiter;
                        c.Priority = priorityHigh;
                        c.OwnerId = hRCaseQueueATraiterId ; 
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                }
            }
            else if(key == actionCloture){
    
                System.debug(actionCloture);
                List<Case> caseCloture = caseSplitedList.get(actionCloture);
                For(Case c: caseCloture){
                    if( ( c.status== statusPreCloture && c.SM_TECH_Type_Office__c <> techTypeOfficeBO )  && (c.RecordType.DeveloperName == recordTypeDNAcqHR || c.RecordType.DeveloperName == recordTypeDNService || c.RecordType.DeveloperName == recordTypeDNAcq || c.RecordType.DeveloperName == recordTypeDNDP) ){
                        c.Status = statusCloture ;
                        c.Tech_CanCloseCase__c=true;
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                }
            }else if(key == actionATraiterAbsenceRetourPartenaire){
    
                System.debug(actionATraiterAbsenceRetourPartenaire);
                List<Case> caseATraiterAbsenceRetourPartenaire = caseSplitedList.get(actionATraiterAbsenceRetourPartenaire);
                For(Case c: caseATraiterAbsenceRetourPartenaire){
                    if( ( c.status== statusEnAttente && c.Sous_statut__c == sousStatutRetourPartenaire && c.Origin ==originPC )  && (c.RecordType.DeveloperName == recordTypeDNAcqHR || c.RecordType.DeveloperName == recordTypeDNService || c.RecordType.DeveloperName == recordTypeDNAcq) ){
                        c.Status = statusAtraiter;
                        c.Sous_statut__c=sousStatutAbsencRetourPartenaire;
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                }
            }
            else if(key == actionATraiterAbsenceRetourDistributeur){
    
                System.debug(actionATraiterAbsenceRetourDistributeur);
                List<Case> caseATraiterAbsenceRetourDistributeur = caseSplitedList.get(actionATraiterAbsenceRetourDistributeur);
                For(Case c: caseATraiterAbsenceRetourDistributeur){
                    if( ( ( c.status== statusEnAttente && c.Sous_statut__c == sousStatusRetourDistributeur && c.TECH_has_OPS__c == false ) || ( c.status == statusEnAttente && c.Sous_statut__c == sousStatusRetourDistributeur &&   c.TECH_dernier_niveau_escalade__c <> null   )) && (c.RecordType.DeveloperName == recordTypeDNAcqHR || c.RecordType.DeveloperName == recordTypeDNService || c.RecordType.DeveloperName == recordTypeDNAcq) ){
                        c.Status = statusAtraiter;
                        c.Sous_statut__c=sousStatutAbsenceRetourDistributeur;
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                }                
            }
            else if(key == actionATraiterAbsenceRetourClient){
    
                System.debug(actionATraiterAbsenceRetourClient);
                List<Case> caseATraiterAbsenceRetourClient = caseSplitedList.get(actionATraiterAbsenceRetourClient);
                For(Case c: caseATraiterAbsenceRetourClient){
                    if( ( c.status== statusEnAttente && c.Sous_statut__c == sousStatutRetourClient && c.TECH_dernier_niveau_escalade__c <> null )  && (c.RecordType.DeveloperName == recordTypeDNAcqHR || c.RecordType.DeveloperName == recordTypeDNService || c.RecordType.DeveloperName == recordTypeDNAcq) ){
                        c.Status = statusAtraiter;
                        c.Sous_statut__c = sousStatutAbsenceRetourClient;
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                }                
            }
            else if(key == actionATraiterRetourCDS){
    
                System.debug(actionATraiterRetourCDS);
                List<Case> caseATraiterRetourCDS = caseSplitedList.get(actionATraiterRetourCDS);
                For(Case c: caseATraiterRetourCDS){
                    if( ( c.status== statusEnAttente && c.Sous_statut__c == sousStatutRetourCDS && c.TECH_dernier_niveau_escalade__c <> null )  && ( c.RecordType.DeveloperName == recordTypeDNService || c.RecordType.DeveloperName == recordTypeDNAcq) ){
                        c.Status = statusAtraiter;
                        c.Sous_statut__c = sousStatutRetourCDS;
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                }                
            }
            else if(key == actionATraiterRetourTresorerieComplexe){
    
                System.debug(actionATraiterRetourTresorerieComplexe);
                List<Case> caseATraiterRetourTresorerieComplexe = caseSplitedList.get(actionATraiterRetourTresorerieComplexe);
                For(Case c: caseATraiterRetourTresorerieComplexe){
                    if( ( c.status== statusEnAttente && c.Sous_statut__c == sousStatutRetourTresorerieComplexe && c.TECH_dernier_niveau_escalade__c <> null )  && ( c.RecordType.DeveloperName == recordTypeDNDP || c.RecordType.DeveloperName == recordTypeDNAcqHR || c.RecordType.DeveloperName == recordTypeDNService || c.RecordType.DeveloperName == recordTypeDNAcq) ){
                        c.Status = statusAtraiter;
                        c.Sous_statut__c = sousStatutRetourTresorerieComplexe;
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                }
            }
            else if (key == actionCaseNotClosed){
                System.debug(actionCaseNotClosed);
                List<Case> caseActionNotClosed = caseSplitedList.get(actionCaseNotClosed);
                For(Case c : caseActionNotClosed){
                    if(c.Status == statusNouveau){
                        c.Status = statusAtraiter;
                        c.OwnerId = SMCaseQueueDPATraiter;
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }else{
                        c.SM_TECH_TimerTargetDate__c =null ;
                        c.SM_TECH_TimerTypeAction__c = '';
                    }
                }
            }
    }
    return caseSplitedList ; 
    }

    /**
     * @author Walid MOUMEN
     * @date 09/02/2022
     * @param Errors list of exceptions
     * @description  check for errors
     */
    public static void checkForErrors(Exception[] errors ) {
        // Logger les erreurs d'exception
        if(!errors.isEmpty()) {
            System.debug('### Errors occured during batch process ###');
            for (Exception e : errors) {
                System.debug(e.getStackTraceString()+'\n');
            }
        } 
    }
    /**
     * @author Walid MOUMEN
     * @date 09/02/2022
     * @description implement start method of the batch
     */
    public static Database.querylocator  startMethod() {
        // Get RecordType Developer Name
        String recordTypeDNAcqHR = String.valueOf(System.Label.SM_CL82_RecordType_DN_AcqHR);
        String recordTypeDNService = String.valueOf(System.Label.SM_CL83_RecordType_DN_Service);
        String recordTypeDNAcq = String.valueOf(System.Label.SM_CL84_RecordType_DN_Acq);
        String recordTypeDNDP = String.valueOf(System.Label.SM_CL85_RecordType_DN_DP);

        //now DateTime
        DateTime nowDateTime = System.now(); 
        //date pour limiter le nombre de case qui sont modifié depuis une période de 2 mois
        DateTime dateTimeFromSysMstamp = System.now().addDays(-60);

        if(!Test.isRunningTest()) {
            //récupèrer tous les cases dont TimerTargetDate est inférieur ou égal la date d'aujourd'hui
            return Database.getQueryLocator([SELECT Id,Status,Sous_statut__c,RecordType.DeveloperName,TECH_dernier_niveau_escalade__c, SM_TECH_TimerTargetDate__c , SM_TECH_TimerTypeAction__c , Origin , SM_TECH_Type_Office__c , Tech_CanCloseCase__c , TECH_has_OPS__c , TECH_Intervention_Date_OPS__c , Priority , OwnerId, SystemModstamp
                                         From Case 
                                         where SM_TECH_TimerTargetDate__c  <= :nowDateTime AND 
                                         SystemModstamp >= :dateTimeFromSysMstamp AND
                                         (RecordType.DeveloperName = :recordTypeDNAcqHR OR RecordType.DeveloperName = :recordTypeDNService OR RecordType.DeveloperName = :recordTypeDNAcq OR RecordType.DeveloperName = :recordTypeDNDP)
                                          ]);
        }else{
            //récupèrer tous les cases dont TimerTargetDate n'est pas vide c'est le cas des test 
            return Database.getQueryLocator([SELECT Id,Status,Sous_statut__c,RecordType.DeveloperName,TECH_dernier_niveau_escalade__c, SM_TECH_TimerTargetDate__c , SM_TECH_TimerTypeAction__c , Origin , SM_TECH_Type_Office__c , Tech_CanCloseCase__c , TECH_has_OPS__c , TECH_Intervention_Date_OPS__c , Priority , OwnerId , SystemModstamp
                                         From Case 
                                         where SM_TECH_TimerTargetDate__c  <> null AND
                                         SystemModstamp >= :dateTimeFromSysMstamp AND
                                         (RecordType.DeveloperName = :recordTypeDNAcqHR OR RecordType.DeveloperName = :recordTypeDNService OR RecordType.DeveloperName = :recordTypeDNAcq OR RecordType.DeveloperName = :recordTypeDNDP)
                                           ]);
        }
    }

    /**
     * @author Walid MOUMEN
     * @date 09/02/2022
     * @param listCases list of cases
     * @description methode de m-à-j des cases
     */
    public static void updateCase(List<Case> listCases) {

        Database.SaveResult[] resultOfUpdate = Database.update(listCases, false);

    }   
    
}