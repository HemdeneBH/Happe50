/**
* @author        :  Walid MOUMEN
* @date          :  18/02/2022
* @description   :  Classe test pour la classe  SM_SM07_CaseTimerAction 
* @us            :  SMILE PI#03 , FT3-1524
**/

@isTest
public without sharing class SM_SM07_CaseTimerAction_Test {
 
    @testSetup 
    static void dataSetup() {

        //get custom  Labels 
        String recordTypeDNAcqHR = String.valueOf(System.Label.SM_CL82_RecordType_DN_AcqHR);
        String recordTypeDNService = String.valueOf(System.Label.SM_CL83_RecordType_DN_Service);
        String recordTypeDNAcq = String.valueOf(System.Label.SM_CL84_RecordType_DN_Acq);
        String recordTypeDNDP = String.valueOf(System.Label.SM_CL85_RecordType_DN_DP);

        String statusEnAttente = String.valueOf(System.Label.SM_CL68_Status_En_Attente);
        String statusPreCloture = String.valueOf(System.Label.SM_CL69_Status_Pre_Cloture);
        String statusDiffere = String.valueOf(System.Label.SM_CL70_Status_Differe);
        String statusEnTraitement = String.valueOf(System.Label.SM_CL90_Status_En_Traitement);
  
        String sousStatutRetourSignature = String.valueOf(System.Label.SM_CL73_Sous_Statut_Retour_Signature);
        String sousStatutRetourClient = String.valueOf(System.Label.SM_CL74_Sous_Statut_Retour_Client);
        String sousStatutRetourCDS = String.valueOf(System.Label.SM_CL75_Sous_Statut_Retour_CDS);
        String sousStatutRetourTresorerieComplexe = String.valueOf(System.Label.SM_CL76_Sous_Statut_Retour_Tresorerie_Complexe);
        String sousStatutRetourPartenaire = String.valueOf(System.Label.SM_CL77_Sous_Statut_Retour_Partenaire);
        String sousStatusRetourDistributeur = String.valueOf(System.Label.SM_CL89_Sous_Statut_Retour_Distributeur);
        String sousStatusConforme = String.valueOf(System.Label.SM_CL92_Sous_Statut_Conforme);
        
 
        String techTypeOfficeBO = String.valueOf(System.Label.SM_CL87_TECH_Type_Office_BO);
        String techTypeOfficeFO = String.valueOf(System.Label.SM_CL91_TECH_Type_Office_FO);
        String originPC = String.valueOf(System.Label.SM_CL88_Origin_PC);

        //get RecordTypes
        Id acquisitionRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeDNAcq).getRecordTypeId();
        Id acquisitionHRRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeDNAcqHR).getRecordTypeId();
        Id serviceRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeDNService).getRecordTypeId();
        Id dtProjetRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeDNDP).getRecordTypeId();

        // create Account
        Account acc = SM_TestDataFactory.createAccount('Smile_Account');
        Insert acc;
       
        // create Contact
        Contact testContact = SM_TestDataFactory.createContact('testContact', acc.Id);
        Insert testContact;

        // Create Cases Action Pre_Cloture_Expire : 
        List<Case> listOfcases = new List<Case>();
        Case testCase1 = SM_TestDataFactory.createCase('TEST1', acc.Id);
        testCase1.RecordTypeId = serviceRT;
        testCase1.status= statusEnAttente  ;
        testCase1.Sous_statut__c = sousStatutRetourSignature  ; 
        testCase1.SM_TECH_Type_Office__c = techTypeOfficeBO ; 
        listOfcases.add(testCase1);

        Case testCase2 = SM_TestDataFactory.createCase('TEST2', acc.Id);
        testCase2.RecordTypeId = serviceRT;
        testCase2.status= statusEnAttente  ;
        testCase2.Sous_statut__c = sousStatutRetourClient  ; 
        testCase2.SM_TECH_Type_Office__c = techTypeOfficeBO ; 
        listOfcases.add(testCase2);

        // Create Cases Action A_Traiter : 
        Case testCase3 = SM_TestDataFactory.createCase('TEST3', acc.Id);
        testCase3.RecordTypeId = acquisitionHRRT;
        testCase3.status=statusDiffere  ;
        listOfcases.add(testCase3);

        // Create Cases Action Clôturé : 

        Case testCase4 = SM_TestDataFactory.createCase('TEST4', acc.Id);
        testCase4.RecordTypeId = serviceRT;
        testCase4.status=statusPreCloture  ;
        testCase4.Sous_statut__c= sousStatusConforme ; 
        testCase4.SM_TECH_Type_Office__c = techTypeOfficeFO ; 
        listOfcases.add(testCase4);
        
        // Create Cases A_Traiter_Absence_Retour_Partenaire : 
        Case testCase5 = SM_TestDataFactory.createCase('TEST5', acc.Id);
        testCase5.RecordTypeId = acquisitionHRRT;
        testCase5.status= statusEnAttente  ;
        testCase5.Sous_statut__c = sousStatutRetourPartenaire  ; 
        testCase5.Origin = originPC;
        listOfcases.add(testCase5);

        // Create Cases A_Traiter_Absence_Retour_Distributeur :         
        Case testCase6 = SM_TestDataFactory.createCase('TEST6', acc.Id);
        testCase6.RecordTypeId = acquisitionHRRT;
        testCase6.status= statusEnAttente  ;
        testCase6.Sous_statut__c = sousStatusRetourDistributeur ; 
        testCase6.TECH_has_OPS__c = false ;
        listOfcases.add(testCase6);

        Case testCase7 = SM_TestDataFactory.createCase('TEST7', acc.Id);
        testCase7.RecordTypeId = serviceRT;
        testCase7.status= statusEnAttente ;
        testCase7.Sous_statut__c = sousStatusRetourDistributeur ; 
        testCase7.TECH_dernier_niveau_escalade__c =  'escaladeTest' ;
        testCase7.TECH_has_OPS__c = true ;
        testCase7.TECH_Intervention_Date_OPS__c = null ;
        listOfcases.add(testCase7);

        Case testCase8 = SM_TestDataFactory.createCase('TEST7', acc.Id);
        testCase8.RecordTypeId = serviceRT;
        testCase8.status= statusEnAttente ;
        testCase8.Sous_statut__c = sousStatusRetourDistributeur ; 
        testCase8.TECH_has_OPS__c = true ;
        testCase8.TECH_dernier_niveau_escalade__c =  'escaladeTest' ;
        testCase8.TECH_Intervention_Date_OPS__c = Date.today();
        listOfcases.add(testCase8);

        // Create Cases A_Traiter_Absence_Retour_Client :         
        Case testCase9 = SM_TestDataFactory.createCase('TEST8', acc.Id);
        testCase9.RecordTypeId = acquisitionHRRT;
        testCase9.status= statusEnAttente  ;
        testCase9.Sous_statut__c = sousStatutRetourClient  ; 
        testCase9.TECH_dernier_niveau_escalade__c =  'escaladeTest' ;
        listOfcases.add(testCase9);

        // Create Cases Action A_Traiter_Retour_CDS : 
        Case testCase10 = SM_TestDataFactory.createCase('TEST9', acc.Id);
        testCase10.RecordTypeId = acquisitionRT;
        testCase10.status=statusEnAttente ;
        testCase10.Sous_statut__c = sousStatutRetourCDS ; 
        testCase10.TECH_dernier_niveau_escalade__c =  'escaladeTest' ;
        listOfcases.add(testCase10);         

        Case testCase11 = SM_TestDataFactory.createCase('TEST10', acc.Id);
        testCase11.RecordTypeId = acquisitionRT;
        testCase11.status=statusEnAttente ;
        testCase11.Sous_statut__c = sousStatutRetourCDS ; 
        testCase11.TECH_dernier_niveau_escalade__c =  'escaladeTest' ;
        listOfcases.add(testCase11);         

        // Create Cases A_Traiter_Retour_Tresorerie_Complexe :         
        Case testCase12 = SM_TestDataFactory.createCase('TEST11', acc.Id);
        testCase12.RecordTypeId = acquisitionHRRT;
        testCase12.status=statusEnAttente ;
        testCase12.Sous_statut__c = sousStatutRetourTresorerieComplexe  ; 
        testCase12.TECH_dernier_niveau_escalade__c =  'escaladeTest' ;
        listOfcases.add(testCase12);

        // Create Cases not in conditions :         
        Case testCase13 = SM_TestDataFactory.createCase('TEST12', acc.Id);
        testCase13.RecordTypeId = acquisitionHRRT;
        testCase13.status=statusEnTraitement ;
        listOfcases.add(testCase13);        

        // inset cases
        insert listOfcases ; 
    }

    @isTest 
    static  void  smSM07CaseTimerActionTest() {

        //Get list of case inserted
        List<Case> caseListes =  [SELECT Id,Status,Sous_statut__c,RecordType.DeveloperName,TECH_dernier_niveau_escalade__c, SM_TECH_TimerTargetDate__c , SM_TECH_TimerTypeAction__c , Origin , SM_TECH_Type_Office__c , Tech_CanCloseCase__c , TECH_has_OPS__c , TECH_Intervention_Date_OPS__c , Priority , OwnerId
                                         From Case 
                                         where SM_TECH_TimerTypeAction__c  <> null ] ; 
        // Clone the list without references 
        List<Case> caseListesDup =  caseListes.deepClone();
        //change the status
        for(Case c : caseListesDup ){
            c.status = 'En Traitement' ;
        }

        //Create Exception 
        List<Exception> listOfExceptions = new List<Exception>();
        CalloutException exc1 = new CalloutException();
        exc1.setMessage('This is a constructed exception!');
        listOfExceptions.add(exc1);          

        Test.startTest();

        // splitter les case en différents collections selon l'action
        Map<String, List<Case>> splitedListCase= SM_SM07_CaseTimerAction.splitCase(caseListes);
        Map<String, List<Case>> splitedListCase2= SM_SM07_CaseTimerAction.splitCase(caseListesDup);
        ////Test update method
        SM_SM07_CaseTimerAction.updateCase(caseListes);
        // exécuter les actions spécifiques pour les cases
        Map<String, List<Case>> listCaseActionsToExecute = SM_SM07_CaseTimerAction.executeCaseAction(splitedListCase);
        Map<String, List<Case>> listCaseActionsToExecute2 = SM_SM07_CaseTimerAction.executeCaseAction(splitedListCase2);
        //Test checkForErrors method
        SM_SM07_CaseTimerAction.checkForErrors(listOfExceptions) ; 
        //Test startMethod method
        SM_SM07_CaseTimerAction.startMethod() ; 

        Test.stopTest();

        System.assertEquals(caseListes.size(),11,'We should have 11 cases');
        System.assertEquals(listCaseActionsToExecute.size(),8,'Map should contain 8 elements');
        System.assertEquals(listCaseActionsToExecute2.size(),8,'Map should contain 8 elements');        

    }
}