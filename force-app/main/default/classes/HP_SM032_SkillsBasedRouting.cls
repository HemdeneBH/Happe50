/**
 * @File Name          : HP_SM032_SkillsBasedRouting.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 10-06-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03/06/2020   Vincent Albiser     Initial Version
**/
global class HP_SM032_SkillsBasedRouting {

    @InvocableMethod
    public static void routeUsingSkills(List<String> casesId) {
        
        Id channelId = [Select Id From ServiceChannel Where DeveloperName = 'Case' Limit 1].Id;
        Map<Id, Case> caseList = new Map<Id, Case>( [SELECT Id,
                                Priority,
                                Origin,
                                RecordType.DeveloperName
                                FROM Case WHERE Id in :casesId]); 
        Map<String, Id> skillIdBySkillName = new Map<String, Id>();
        for(Skill s : [Select Id, DeveloperName From Skill]){
            skillIdBySkillName.put(s.DeveloperName, s.Id);
        }

        // Add SkillsBased PendingServiceRouting
        List<PendingServiceRouting> pendingServiceList = new List<PendingServiceRouting>();
        for (Case c : caseList.values()) {
            
            PendingServiceRouting psrObj = new PendingServiceRouting(
                CapacityWeight = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_OMNI_CaseWeight')),
                IsReadyForRouting = FALSE,
                RoutingModel  = 'MostAvailable',
                RoutingPriority = 1,
                RoutingType = 'SkillsBased',
                pushTimeout = 30,
                ServiceChannelId = channelId,
                WorkItemId = c.Id
                );
            pendingServiceList.add(psrObj);
        }
        insert pendingServiceList;

        // Now add SkillRequirement(s)
        for(PendingServiceRouting psr : pendingServiceList){
            
            List<SkillRequirement> skReqs = new List<SkillRequirement>{};
            for(String skillName : getSkills(caseList.get(psr.WorkItemId))){
                SkillRequirement srObj = new SkillRequirement(
                    RelatedRecordId = psr.id,
                    SkillId = skillIdBySkillName.get(skillName)
                );
                skReqs.add(srObj);
            }
            if(!skReqs.isEmpty()){
                insert skReqs;
            }  

        }

        // Update PendingServiceRouting as IsReadyForRouting
        for(PendingServiceRouting psr : pendingServiceList){            
            psr.IsReadyForRouting = true;
        }             
        update pendingServiceList;        
    }

    public static List<String> getSkills(Case c) {

        List<String> skills = new List<String>{};

        switch on c.Origin {
            when 'HP_Em2Case_ContactDistributeur' {
                skills.add('HP_FO_Email_Contact_distributeur');
            }
            when 'HP_Em2Case_Retablissement' {
                skills.add('HP_FO_Email_R_tablissement');   
            }  
            when 'HP_Em2Case_Televente' {
                skills.add('HP_FO_Email_T_l_vente_COMDATA');   
            }
            when 'HP_Em2Case_CMTO' {
                skills.add('HP_FO_Email_CMTO_ch_que_ch_que_nergie');   
            }
            when 'HP_Em2Case_Recouvrement' {
                skills.add('HP_FO_Email_Recouvrement');   
            }            
            when 'HP_Em2Case_OperationPonctuelle' {
                //skills.add('');   
            }
            when 'HP_Em2Case_ContactClient' {
                //skills.add('');   
            }
            when 'HP_Em2Case_Numeriseur' {
                skills.add('HP_FO_Email_Ediiscan');   
            }
            when 'HP_Em2Case_Satisfaction' {
                //skills.add('');   
            }
            when 'HP_Em2Case_TransfertCelluleCeltic' {
                //skills.add('');   
            }
        }
        
        return skills;
    }
}