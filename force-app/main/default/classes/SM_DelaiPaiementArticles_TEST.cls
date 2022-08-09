@isTest
public with sharing class SM_DelaiPaiementArticles_TEST {
    
    static testmethod void getRecapArticle_test(){
        contact acontact = new contact();
        acontact.Identifiant_Buisness_Partener__c = '1234';
        acontact.LastName = 'test';
        insert acontact;
        System.assertNotEquals(SM_DelaiPaiementArticles.getRecapArticle('1234'),null);
    }
    
}