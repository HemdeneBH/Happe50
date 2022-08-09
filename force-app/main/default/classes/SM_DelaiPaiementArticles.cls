public with sharing class SM_DelaiPaiementArticles {
    
    @AuraEnabled(cacheable=true)
    public static String getRecapArticle(String idBp){
        String consignekb = 'Erreur aucun article défini à cette étape.';
        system.System.debug('## idbp '+idBp);
        list<Contact> listContact = [select Adresse_Mail_2__c,Adresse_Mail_3__c,Email,EmailPrincipalValue__c from contact where Identifiant_Buisness_Partener__c =:idBp];
        String cleMigration;
        if(listContact[0] != null && listContact[0].Adresse_Mail_2__c == null && listContact[0].Adresse_Mail_3__c == null && listContact[0].Email == null){
            cleMigration = '000001378';
        }else {
            cleMigration = '000001377';
        }
        Knowledge__kav[] article = [select Consigne__c from Knowledge__kav where Cle_Migration__c =:cleMigration];
        if (article.size() > 0 && article[0].Consigne__c != null) {
            consignekb = article[0].Consigne__c;
            System.debug('## article[0].Consigne '+article[0].Consigne__c);
        }
        system.System.debug('## consignekb '+consignekb);
        
        return consignekb;
    }
}