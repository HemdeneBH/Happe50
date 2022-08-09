public class SM_AP93_ServiceRessourceSklHandler {

    public static void checkSkillValidForUserSite(List<ServiceResourceSkill> newList){
        // getUser and his Site
            Id userId = UserInfo.getUserId();
            User usr = [ select id , site__c from User where Id =: userId ];
            System.debug('user Site: '+ usr.Site__c);
            String siteName =  usr.Site__c ; 
        if(Test.isRunningTest()){
            siteName = 'Equipe 1 Fes DSPC DGP';
        }
        System.debug('siteName : ' + siteName);
            //get site and skills related to it
             List<Id> skillIds = new List<Id>();
            List<SM_HarmonicaSite__c> harmonicaSite = [select id,Name,(select Name from Competences__r) from SM_HarmonicaSite__c where Name =: siteName limit 1];
        	
            System.debug('list empty:' + harmonicaSite.isEmpty());
            //List<ServiceResourceSkill> ServiceResourceSkills =   [Select id  from ServiceResourceSkill where id in :Trigger.new];
            for(ServiceResourceSkill serviceResourceSkill : newList) {
                skillIds.add(serviceResourceSkill.SkillId);
            }
            List<Skill> skills = [Select id,MasterLabel from Skill where id in :skillIds ];
            for(ServiceResourceSkill srs : newList){ 
                // TODO: get skill name from id (we got list of skills)  
                String SkillName = '';
                for(Skill skill : skills){
                    if(skill.Id == srs.SkillId){
                         SkillName = skill.MasterLabel;
                    }
                }
                // test if skill is eligible for the site
                SM_HarmonicaSite__c Hsite = null; 
              
                   if(!harmonicaSite.isEmpty() &&  skillName != '' ){
                        
                    Hsite = harmonicaSite[0];
                    Set<String> CompetenceEligibles = new Set<String>();
                    for(SM_HarmonicaCompetence__c Hcomp : Hsite.competences__r){
                        CompetenceEligibles.add(Hcomp.Name);
                    } 
                    //String skillName = skillMatrix.get(srs.SKill.MasterLabel);
                    System.debug(' Skill: '+ skillName );
                    if(!CompetenceEligibles.contains( skillName)){
                        System.debug('skill not elligible !!');
                        srs.addError(System.label.Comp_tence_non_ligible);
                    } else {System.debug('skill elligible :)');}
                } else {
                    System.debug('empty !'); 
                } 
                
                
                
            }  
    }
}