@isTest
private class SM_CTRL004_KnowledgeForLWC_TEST{

	@testSetup static void setup(){

		  List<Knowledge__kav> knowledges = (List<Knowledge__kav>)SM_UTIL_SmartFactory.createSObjects('Knowledge__kav', 'Insert_Omniscript', null, 2);
            
            knowledges.get(0).Cle_Migration__c = '000001538';
            knowledges.get(0).Consigne__c = 'Dossier Solidarité - Consignes et Discours';
            knowledges.get(0).Title = 'Dossier Solidarité - Discours Conseiller';
            knowledges.get(0).UrlName = 'Dossier-Solidarité-Discours-ConseillerTest';

            knowledges.get(1).Cle_Migration__c = '000001539';
            knowledges.get(1).Consigne__c = 'Dossier Solidarité - Consignes et Discours - 2';
            knowledges.get(1).Title = 'Dossier Solidarité - Discours Conseiller - 2';
            knowledges.get(1).UrlName = 'Dossier-Solidarité-Discours-Conseillerr';
            
            
            insert knowledges;
            
            List<Knowledge__kav> knowledgesFilled = [SELECT Id, KnowledgeArticleId FROM Knowledge__kav
                                                     WHERE Id =:knowledges.get(0).Id];
            
            KbManagement.PublishingService.publishArticle(knowledgesFilled.get(0).KnowledgeArticleId, true);
        }

    

	@isTest static void testMethod1() {

            
            Map<String, Object> inputMap = new Map<String, Object> ();
            
            inputMap.put('cleMigration', '000001538');
            
            Test.startTest();
            Map<String, Object> outputMap = SM_CTRL004_KnowledgeForLWC.getArticleByCleMigration(inputMap);
            Test.stopTest();
            
            System.assertEquals('Dossier Solidarité - Consignes et Discours', outputMap.get('article'));
        }
	}