/**
 * @description       : Classe à utiliser pour la récupèration des articles Knowlegde dans les parcours LWC
 * @author            : Raouaa JMOUR
 * @group             : 
 * @last modified on  : 18-01-2021
 * @last modified by  : Raouaa JMOUR 
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   18-01-2021   Raouaa JMOUR    Initial Version
**/

public class SM_CTRL004_KnowledgeForLWC {
 

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getArticleByCleMigration(Map < String, Object > inputMap) {
         String cleMigrationArticle = (String) inputMap.get('cleMigration');
        Knowledge__kav article =[SELECT Cle_Migration__c,Id, Consigne__c FROM Knowledge__kav WHERE RecordType.DeveloperName = 'Insert_Omniscript' AND Cle_Migration__c IN (:cleMigrationArticle) LIMIT 1];
        
        Map < String, Object > outMap = new Map < String, Object >();

        outMap.put('article',article.Consigne__c);

        return outMap;
    }

    
}