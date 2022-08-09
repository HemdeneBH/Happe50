public with sharing class HP_EM042_User {    
    
    private static final String HPUsersQuery = 'SELECT ID, FirstName, LastName, Name, Title, ProfileId, Profile.Name, UserRole.Name, Email, Distributor_Login__c From User WHERE ProfileId IN  (SELECT Id FROM Profile WHERE Name like \'HP_%\')' ; 
    
    public static String getQueryLocatorHPUsers(){
        return HPUsersQuery;
    }
    
    public static list<user> getHPUsers(){    
        return database.query(HPUsersQuery);
    }
    
    public static String  getQueryLocatorCurrentUser(){
        return  'SELECT ID From User WHERE Id = \'' + UserInfo.getUserId() + '\'' + ' limit 1 ';
    }
    
}