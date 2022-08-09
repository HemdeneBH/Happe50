/**
 * @description       : LWC Controller for free services screen - Unit tests
 * @author            : David Attali
 * @group             : 
 * @last modified on  : 10-26-2020
 * @last modified by  : David ATTALI
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   10-26-2020   David ATTALI    Initial Version
**/
@isTest
private class SM_CTRL001_FreeServices_TEST {
    
    @testSetup
    static void setup(){
        
        // Récupération de 2 profils
        Map<String, Id> MapProfileNameToProfileId = new Map<String, Id>();
        for(Profile profile : [SELECT Id, Name FROM Profile WHERE Name IN ('SM_SystemAdmin','SM_Utilisateur métier restriction faible')]){
            MapProfileNameToProfileId.put(profile.Name, profile.Id);
        }
        
        // Préparation d'un utilisateur admin et d'un utilisateur métier restriction faible
        Map<String, Object> specificSimpleValueMap = new Map<String, Object>();
        specificSimpleValueMap.put('Alias', 'Test');
        specificSimpleValueMap.put('CommunityNickname', 'smadmin');
        specificSimpleValueMap.put('IsActive', true);
        specificSimpleValueMap.put('ProfileId', MapProfileNameToProfileId.get('SM_SystemAdmin'));
        specificSimpleValueMap.put('Username', 'smadmin@engie.com');
        specificSimpleValueMap.put('UserPermissionsKnowledgeUser', true);
        
        List<User> users = (List<User>)SM_UTIL_SmartFactory.createSObjects('User', null, specificSimpleValueMap, 2);
        
        users.get(0).CommunityNickname = 'smlow';
        users.get(0).ProfileId = MapProfileNameToProfileId.get('SM_Utilisateur métier restriction faible');
        users.get(0).Username = 'smlow@engie.com';

        // Insertion des utilisateurs
        insert users;
    }
    
    @isTest
    static void testSetEdocumentStatus_Activate() {
        
        // Récupération de l'utilisateur métier
        User smLowUser = [SELECT Id, Username FROM User WHERE Username = 'smlow@engie.com' LIMIT 1];
        
        // Test en tant qu'utilisateur métier
        System.runAs(smLowUser){
            
            Map<String, Object> inputMap = new Map<String, Object> ();
            
            inputMap.put('eDocumentChoices', true);
            inputMap.put('refClientIdBP', '0312376423');
            
            Test.startTest();
            Map<String, Object> outputMap = SM_CTRL001_FreeServices.setEdocumentStatus(inputMap);
            Test.stopTest();
            
            System.assertEquals('OCTOPUS_MAJPersonne_01', outputMap.get('code'));
        }
    }
    
    @isTest
    static void testSetEdocumentStatus_Desactivate() {
        
        // Récupération de l'utilisateur métier
        User smLowUser = [SELECT Id, Username FROM User WHERE Username = 'smlow@engie.com' LIMIT 1];
        
        // Test en tant qu'utilisateur métier
        System.runAs(smLowUser){
            
            Map<String, Object> inputMap = new Map<String, Object> ();
            
            inputMap.put('eDocumentChoices', false);
            inputMap.put('refClientIdBP', '0312376423');
            
            Test.startTest();
            Map<String, Object> outputMap = SM_CTRL001_FreeServices.setEdocumentStatus(inputMap);
            Test.stopTest();
            
            System.assertEquals('OCTOPUS_MAJPersonne_01', outputMap.get('code'));
        }
    }
    
    @isTest
    static void testGetKnowledge_KnowledgeFound() {
        
        // Récupération de l'utilisateur admin et du métier
        Map<String, User> mapUsernameToUser = new Map<String, User>();
        for(User user : [SELECT Id, Username FROM User WHERE Username IN ('smadmin@engie.com', 'smlow@engie.com')]){
            mapUsernameToUser.put(user.Username, user);
        }
        
        // Préparation des articles en tant qu'admin
        System.runAs(mapUsernameToUser.get('smadmin@engie.com')){
            
            List<Knowledge__kav> knowledges = (List<Knowledge__kav>)SM_UTIL_SmartFactory.createSObjects('Knowledge__kav', 'Insert_Omniscript', null, 2);
            
            knowledges.get(0).Cle_Migration__c = '000001045';
            knowledges.get(0).Consigne__c = 'Consignes facture en ligne';
            knowledges.get(0).Title = 'Discours et consignes pour la Facture En Ligne (FEL)';
            knowledges.get(0).UrlName = 'Facture-En-Ligne-TEST';
            
            knowledges.get(1).Cle_Migration__c = '000001405';
            knowledges.get(1).Consigne__c = 'Consignes e-documents';
            knowledges.get(1).Title = 'Discours et Consignes E-Documents';
            knowledges.get(1).UrlName = 'Discours-et-consignes-pour-les-E-documents-TEST';
            
            insert knowledges;
            
            List<Knowledge__kav> knowledgesFilled = [SELECT Id, KnowledgeArticleId FROM Knowledge__kav
                                                     WHERE Id IN (:knowledges.get(0).Id, :knowledges.get(1).Id)];
            
            KbManagement.PublishingService.publishArticle(knowledgesFilled.get(0).KnowledgeArticleId, true);
            KbManagement.PublishingService.publishArticle(knowledgesFilled.get(1).KnowledgeArticleId, true);
        }

        // Test en tant qu'utilisateur métier
        System.runAs(mapUsernameToUser.get('smlow@engie.com')){
            
            Map<String, Object> inputMap = new Map<String, Object> ();
            
            inputMap.put('felMigrationKey', '000001045');
            inputMap.put('eDocumentMigrationKey', '000001405');
            
            Test.startTest();
            Map<String, Object> outputMap = SM_CTRL001_FreeServices.getKnowledge(inputMap);
            Test.stopTest();
            
            System.assertEquals('Consignes facture en ligne', outputMap.get('felInstruction'));
            System.assertEquals('Consignes e-documents', outputMap.get('eDocumentInstruction'));
        }
    }
    
    @isTest
    static void testGetKnowledge_KnowledgeNotFound() {
        
        // Récupération de l'utilisateur métier
        User smLowUser = [SELECT Id, Username FROM User WHERE Username = 'smlow@engie.com' LIMIT 1];
        
        // Test en tant qu'utilisateur métier
        System.runAs(smLowUser){
            
            Map<String, Object> inputMap = new Map<String, Object> ();
            
            inputMap.put('felMigrationKey', '000001045');
            inputMap.put('eDocumentMigrationKey', '000001405');
            
            Test.startTest();
            Map<String, Object> outputMap = SM_CTRL001_FreeServices.getKnowledge(inputMap);
            Test.stopTest();
            
            System.assertEquals(null, outputMap.get('felInstruction'));
            System.assertEquals(null, outputMap.get('eDocumentInstruction'));
        }
    }
}