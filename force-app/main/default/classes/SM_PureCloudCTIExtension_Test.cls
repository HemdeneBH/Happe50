/*
* @Auhtor: Riadh Dallel ~ riadh.dallel@external.engie.com
* @Date: 25/06/2021
* @Description: Test class for class SM_PureCloudCTIExtension
*/
@isTest
global class SM_PureCloudCTIExtension_Test {

 

    @testSetup 
    static void dataSetup() {
        Id serviceRT = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Service').getRecordTypeId();
        // create Account
        Account acc = SM_TestDataFactory.createAccount('Smile_Account');
        Insert acc;
        // create Contact
        Contact testContact = SM_TestDataFactory.createContact('testContact', acc.Id);
        Insert testContact;
        // Create Cases

        Case testCase1 = SM_TestDataFactory.createCase('TEST', acc.Id);
        Case testCase2 = SM_TestDataFactory.createCase('TESTmajAffectation', acc.Id); 
        testCase1.RecordTypeId = serviceRT;
        testCase2.RecordTypeId = serviceRT;
        List<Case> casesToInsert = new List<Case>{testCase1,testCase2}; 
        Insert casesToInsert;
        // Create Task
        Task task = new Task(WhatId=casesToInsert[0].id,Subject='test_Genesys',Status='A traiter');
        insert task;
    }
    
    static String setData(String caseId,Task task)  {

        // préparation de l'input de méthode onSaveLog
        Map<String, Object> attributes = new Map<String, Object> ();
        attributes.put('sf_urlpop',caseId);
        Map<String, Object> interaction = new Map<String, Object> ();
        interaction.put('isConnected',true);
        Map<String, Object> saveLogData = new Map<String, Object> ();
        interaction.put('attributes',attributes);
        saveLogData.put('interaction',interaction);
        saveLogData.put('callLog',(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(task)));
        String data = JSON.serialize(saveLogData);


        return data;
    }
    static String setData(String caseId){

        return setData(caseId,[select id from Task limit 1]);
    }

    @isTest
    global static void onSaveLog_Test() {
        String caseId='';
        Task task= new task();
        for(Case caseObj: [select id from Case limit 1])
            caseId=caseObj.id;
        
        for(Task taskObj: [select id from Task limit 1])
            task=taskObj;    

        String data =  setData(caseId,task);


        Test.startTest();
        SM_PureCloudCTIExtension pureCloudExtension = new SM_PureCloudCTIExtension();
        pureCloudExtension.onSaveLog(data);
        Test.stopTest();
	
        // vérifier la MAJ du champ PureCloud_acceptedGenesys__c
        for(Case caseObj: [select id,PureCloud_acceptedGenesys__c,ownerId from Case limit 1])
            System.assertEquals(true, caseObj.PureCloud_acceptedGenesys__c);


    }


    @isTest
    public static void majAffectation_Test(){

        //setup status of case to escaladé
        Case caseObj = [select Id,status,Subject,ownerId,Motif_escalade__c,Sous_motif_escalade__c,Raison_detaillee_escalade__c from case where Subject = 'TESTmajAffectation' limit 1 ];
        
        String caseId = caseObj.Id;
        caseObj.Type = 'Paiement';
        caseObj.Sous_type__c = 'Information détail facture';
        caseObj.Motif_escalade__c = 'MO04' ;
        caseObj.Sous_motif_escalade__c = 'SM06' ;
        caseObj.Raison_detaillee_escalade__c = 'test'; 
        caseObj.status = 'Escaladé';
        update caseObj;
        
        //setup intervention (one created 1 day before the other )
        Contact cnt = [Select id from Contact limit 1];
        Intervention__c interv = new Intervention__c(case__c = caseObj.Id,Statut__c = 'Nouveau',Type__c ='MO11',Contact__c = cnt.Id  ); 
        insert interv;
        Datetime yesterday = Datetime.now().addDays(-1);
        Test.setCreatedDate(interv.Id, yesterday);
        String OldInterventionId = interv.Id;


        Intervention__c NewInterv = new Intervention__c(case__c = caseObj.Id,Statut__c = 'Nouveau',Type__c ='MO11',Contact__c = cnt.Id  ); 
        insert NewInterv;
        Datetime today = Datetime.now();
        Test.setCreatedDate(NewInterv.Id, today);

        String data =  setData(caseId);
        
        Test.startTest();
        SM_PureCloudCTIExtension pureCloudExtension = new SM_PureCloudCTIExtension();
        pureCloudExtension.onSaveLog(data);
        Test.stopTest();

        List<Intervention__c> listCaseInterventions = [Select Id,Statut__c,OwnerId ,CreatedDate
                                                       From Intervention__c 
                                                       Where Case__c=:caseId
                                                       Order By CreatedDate Desc];
        
       
        // test if the last 'new' intervention owner is the same as the case owner
        System.assertEquals(listCaseInterventions[0].OwnerId,caseObj.OwnerId); 
        System.assertEquals(listCaseInterventions[0].statut__c,'En cours');
        System.assertNotEquals(listCaseInterventions[0].id,OldInterventionId);                                                  
    }

}