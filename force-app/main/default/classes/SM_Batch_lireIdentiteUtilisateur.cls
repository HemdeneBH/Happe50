global class SM_Batch_lireIdentiteUtilisateur implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts, Schedulable  {

    global List<User> listUsersUpdate = new List<User>();
    global  SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
    
    global List<User> start(Database.BatchableContext bc) {
        List<User> listUsers  = new List<User>();
        if(Test.isRunningTest()){
            listUsers = [SELECT ID, Gaia__c, SM_Identifiant_Organisation__c,SAP_Identifier__c
                         FROM User
                         WHERE Gaia__c != '' AND Profile.Name Like 'SM%' AND IsActive = true
                          LIMIT 3];
        }
        else{
            listUsers = [SELECT ID, Gaia__c, SM_Identifiant_Organisation__c,SAP_Identifier__c
                         FROM User
                         WHERE Gaia__c != '' AND Profile.Name Like 'SM%' AND IsActive = true];
        }
        
        return listUsers;
    }
    
    global void execute(Database.BatchableContext bc, List<User> listUsers){
        for(User user : listUsers){
           listUsersUpdate = SM_AP82_lireIdnentiteUtilisateur.callWSUpdateUser(user, octopusCS, listUsersUpdate);
        } 
    }    
    
    global void finish(Database.BatchableContext bc){
        if(listUsersUpdate.size() > 0)
            Database.update(listUsersUpdate, false);
    }
    
    
    global void execute(SchedulableContext sc)
    {
        SM_Batch_lireIdentiteUtilisateur batch = new SM_Batch_lireIdentiteUtilisateur(); //ur batch class
        database.executebatch(batch, 9);
    }
}