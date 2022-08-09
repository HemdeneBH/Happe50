@isTest
public class SM_Batch_lireIdentiteUtilisateur_Test {
    
     @istest
    static void makeData(){
        List<User> listUsers = new List<User>();
        User user = SM_TestDataFactory.createUser('tseBT1', 'emailBT1@email.com', 'lastNameBT1', 'usernameBT1@username.com', 'SM_Utilisateur admin métier');
        user.Gaia__c = '23432';
        listUsers.add(user);
        
        User user2 = SM_TestDataFactory.createUser('tseBT2', 'emailBT2@email.com', 'lastNameBT2', 'usernameBT2@username.com', 'SM_Utilisateur métier restriction faible');
        user2.Gaia__c = '2334432';
        listUsers.add(user2);
        insert listUsers;
        
         
    }
    
    @isTest static void callWS(){
        Test.startTest();
        Database.executeBatch(new SM_Batch_lireIdentiteUtilisateur());
        Test.stopTest();
    }
}