@IsTest
public with sharing class SM_BAT04_KnowledgeSyncDataCategoryTEST {
    
    @isTest
    static void testKnowldgeSyncDataCategory() {
        //create article 
        Id articleRId = [SELECT Id,Name FROM RecordType WHERE sObjectType='Knowledge__kav' and Name Like '%Article%'].Id;
        Knowledge__kav art = new Knowledge__kav(Title= 'article de test',UrlName='article-de-test',RecordTypeId = articleRId );
        insert art;

        //create data category for article 
        List<Knowledge__DataCategorySelection> dtselectionList = new List<Knowledge__DataCategorySelection>();
        Knowledge__DataCategorySelection kavDC1 = new Knowledge__DataCategorySelection();
        kavDC1.DataCategoryGroupName = 'Smile';
        kavDC1.DataCategoryName = 'Offre_ChF';
        kavDC1.ParentId = art.id;
        dtselectionList.add(kavDC1);

        Knowledge__DataCategorySelection kavDC2 = new Knowledge__DataCategorySelection();
        kavDC2.DataCategoryGroupName = 'Smile';
        kavDC2.DataCategoryName = 'Historique_factures';
        kavDC2.ParentId = art.id;
        dtselectionList.add(kavDC2);

        insert dtselectionList;
        String   knowledgeId = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id =: art.Id].KnowledgeArticleId;
                    System.debug('article id ' + knowledgeId);
        KbManagement.PublishingService.publishArticle(knowledgeId, true);

        Test.startTest();

        SM_BAT04_KnowledgeSyncDataCategory obj = new SM_BAT04_KnowledgeSyncDataCategory();
        DataBase.executeBatch(obj); 
    
        Test.stopTest();

        Knowledge__kav articleAfterBatch  = [SELECT id,Categorie_Consigne__c,Etape_de_l_omniscript__c FROM Knowledge__kav WHERE Title='article de test' limit  1];
        
        System.assertEquals(articleAfterBatch.Categorie_Consigne__c.contains('Historique factures'),true);
        System.assertEquals(articleAfterBatch.Categorie_Consigne__c.contains('Changement d\'offre'),true);
        System.assertEquals(articleAfterBatch.Etape_de_l_omniscript__c,'CHOIX DE L\'OFFRE');

        // Pour couverture de la classe test
        SM_BAT04_KnowledgeSyncDataCategorySch batchSch = new SM_BAT04_KnowledgeSyncDataCategorySch();
        batchSch.execute(null);
    }
}