@isTest
public class SM_AP93_ServiceRessourceSklHandlerTEST {
     
    @isTest
    public static void test(){
        
         // user 
        User user = SM_TestDataFactory.createUser( 'alias','testuser000@test.com','last' ,'testuser000@test.com' + System.currentTimeMillis(),'SM_Utilisateur admin métier'  );
        user.Site__c = 'Equipe 1 Fes DSPC DGP';
        Insert  user;
        User user2 = SM_TestDataFactory.createUser( 'alias2','testuser0002@test.com','last2' ,'testuser2000@test.com' + System.currentTimeMillis(),'SM_Utilisateur admin métier'  );
        user.Site__c = 'Equipe 1 Fes DSPC DGP';
        Insert  user2;
        SM_HarmonicaSite__c Hsite = new SM_HarmonicaSite__c (Name = 'Equipe 1 Fes DSPC DGP');
        insert Hsite;
        //create service ressource 
        System.runAs(user2){
            ServiceResource serviceResource = new  ServiceResource(name = 'test',RelatedRecordId = user2.Id,ResourceType = 'A',IsActive = true );
        Insert serviceResource;
        }
        
        //test
        
        List<ServiceResource>  sResources = [Select id from serviceResource where name = 'test'];
        ServiceResource sResource = sResources[0];
        Skill skill = [Select id from Skill where MasterLabel = 'Comdata Poitiers'];
        ServiceResourceSkill serviceResourceSkill = new ServiceResourceSkill(ServiceResourceId = sResource.Id,SkillId = skill.Id,EffectiveStartDate = Date.today());
    	//sUser user2 = [Select id from User where lastName = 'last2' ];
        test.startTest();
        System.runAs(user2){
            try{
                Insert serviceResourceSkill;
            } catch (Exception e){
                
            }
        }
          
        test.stopTest();
        List<ServiceResourceSkill> insertedSrS =  [Select id from ServiceResourceSkill where skillId =:skill.Id];
        System.assertEquals(0, insertedSrS.size());
    }
    
}