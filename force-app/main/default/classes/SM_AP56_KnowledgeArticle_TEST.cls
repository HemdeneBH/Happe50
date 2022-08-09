@isTest
public with sharing class SM_AP56_KnowledgeArticle_TEST {
    @IsTest(SeeAllData = false)
    static void getArticle_TEST(){
        // Insert les articles   Categorie_Consigne__c ='Acquisition',
        List<Knowledge__kav> articles = new List<Knowledge__kav>();

        for(Integer i = 0 ; i < 10 ; i++){
            Knowledge__kav a = new Knowledge__kav(
                Title = 'Title ' + i,
                Summary = 'Summary ' + i,
                URLName = 'engie'+i,
                Cle_Migration__c = String.valueOf(i),
                RecordTypeId = SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Insert_Omniscript').getRecordTypeId()
            );
            articles.add(a); 
        }

        insert articles;

        articles = [SELECT Id, KnowledgeArticleId FROM Knowledge__kav WHERE Id IN: articles];

        for(Knowledge__kav anArticle : articles){
            String articleId = anArticle.KnowledgeArticleId;
            System.debug('*** article : ' + anArticle);
            KbManagement.PublishingService.publishArticle(articleId, true);
        }

        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('CategorieKnowledge','Acquisition');
        SM_AP56_KnowledgeArticle knowledgeCtrl = new SM_AP56_KnowledgeArticle();
        knowledgeCtrl.invokeMethod('getArticle', null, outputMap, null);
        knowledgeCtrl.invokeMethod('getArticleByCategorie', inputMap, outputMap, null);
        knowledgeCtrl.invokeMethod('getArticleByOffre', null, outputMap, null);

        outputMap = (Map<String, Object>) outputMap.get('articles');

        //System.assertEquals(articles.size(), outputMap.size());
                         
    }
}