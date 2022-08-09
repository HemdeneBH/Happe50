/**
 * @File Name          : HP_SM032_OmnichannelSkillsRoutage.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 10-06-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/06/2020   Vincent Albiser     Initial Version
**/
global class HP_SM032_OmnichannelSkillsRoutage {

    @InvocableMethod
    public static void routeUsingSkills(List<String> casesId) {

        System.debug('HP_SM032_SkillsBasedRouting');
        System.debug('casesId = ' + casesId);
        
        Id channelId = [Select Id From ServiceChannel Where DeveloperName = 'Case' Limit 1].Id;
        Map<Id, Case> caseMap = new Map<Id, Case>( [SELECT Id,
                                Priority,
                                Subject,
                                Origin,
                                RecordType.DeveloperName,
                                HP_Type__c,
                                HP_Sous_Type__c,
                                HP_Canal__c,
                                OwnerId,
                                CreatedDate
                                FROM Case WHERE Id IN :casesId]); 
        Map<String, Id> skillIdBySkillName = new Map<String, Id>();
        List<HP_TECH_LOG__c> listErrorTech = new List<HP_TECH_LOG__c>();
        
        for(Skill s : [Select Id, DeveloperName From Skill]){
            skillIdBySkillName.put(s.DeveloperName, s.Id);
        }

        // Vérification pour ne pas créer de doublons
        List<PendingServiceRouting> existingPsrList = [SELECT Id, WorkItemId FROM PendingServiceRouting WHERE WorkItemId IN :casesId];
        for (PendingServiceRouting existingPsr : existingPsrList){
            if(caseMap.containsKey(existingPsr.WorkItemId)){ // Psr existe déjà
                caseMap.remove(existingPsr.WorkItemId);
            }
        }

        Integer pushTimeout = Integer.valueOf(HP_SM003_MetadataManager.getConfigurationGenerique('HP_OmniChannelTimeout'));
        Map<Id, String> caseOwnerDeveloperName = HP_EM010_Case.getCaseOwnerDeveloperName(caseMap);
        Map<String, Map<String, List<String>>> routingMap = getRoutingPriorityAndSkills(caseMap, caseOwnerDeveloperName);

        // Add SkillsBased PendingServiceRouting
        List<PendingServiceRouting> pendingServiceList = new List<PendingServiceRouting>();
        List<Case> caseWithPriorityToUpdate = new List<Case>();
        for (Case c : caseMap.values()) {
            
            if(c.Origin == 'Erreur souscription') {
                continue;
            }
            
            if(routingMap.get(c.Id).get('skills') != null 
                && routingMap.get(c.Id).get('skills').size() == 1
                && routingMap.get(c.Id).get('skills').get(0) == 'HP_Happe') {
                continue;
            }

            Integer routingPriority = getRoutingPriority(c, routingMap);
            
            if(c.Priority == null || convertPriority(c.Priority) != routingPriority) {
                c.Priority = convertPriorityIntegerToString(routingPriority);
                caseWithPriorityToUpdate.add(c);
            }

            PendingServiceRouting psrObj = new PendingServiceRouting(
                CapacityWeight = Integer.valueOf(HP_UTIL_MetadataManager.getConfigByKey('HP_OMNI_CaseWeight')),
                IsReadyForRouting = FALSE,
                RoutingModel  = 'MostAvailable',
                RoutingPriority = routingPriority,
                RoutingType = 'SkillsBased',
                pushTimeout = pushTimeout,
                ServiceChannelId = channelId,
                WorkItemId = c.Id,
                CustomRequestedDatetime = c.CreatedDate
                );
            pendingServiceList.add(psrObj);
        }
        insert pendingServiceList;

        // Now add SkillRequirement(s)
        for(PendingServiceRouting psr : pendingServiceList){
            
            List<SkillRequirement> skReqs = new List<SkillRequirement>{};
            
            if(routingMap.get(psr.WorkItemId) != null && routingMap.get(psr.WorkItemId).get('skills') != null) {
                List<String> skillList = routingMap.get(psr.WorkItemId).get('skills'); 
                System.debug('Skill List Size : ' + skillList.size());

                for(String skillName : skillList){
                    System.debug('Skill Name : ' + skillName);
                    if(skillIdBySkillName.get(skillName) != null) {
                        SkillRequirement srObj = new SkillRequirement(
                            RelatedRecordId = psr.id,
                            SkillId = skillIdBySkillName.get(skillName)
                        );
                        skReqs.add(srObj);
                        System.debug('caseId / skill = ' + psr.WorkItemId + ' / ' + skillName);
                    }
                    else {
                        HP_TECH_LOG__c hpLogTech = HP_EM031_HPLogTech.buildHPLogTechFromGenericApexError('Happe', 'Nouveau',
                        'HP_SM032_OmnichannelSkillsRoutage', 'Routage Omnichannel', 'Impossible de retrouver le skill : ' + skillName);
                        listErrorTech.add(hpLogTech);
                        System.debug('Skill non existant : ' + skillName);
                    }
                }
            }
            
            if(!skReqs.isEmpty()){
                insert skReqs;
            }  

        }

        // Update PendingServiceRouting as IsReadyForRouting
        for(PendingServiceRouting psr : pendingServiceList){                        
            psr.IsReadyForRouting = true;
        }    
        System.debug('pendingServiceList = ' + pendingServiceList);         
        update pendingServiceList;
        
        if(caseWithPriorityToUpdate.size() > 0) update caseWithPriorityToUpdate;
        if(listErrorTech.size() > 0) insert listErrorTech;
    }


    /**
     * Renvoi la priorité de routing d'un case.
     * Si pas de priorité définie : par défaut on met 2 (medium)
     */
    public static Integer getRoutingPriority(Case c,  Map<String, Map<String, List<String>>> mapCases) {
        if(mapCases.get(c.Id) != null && mapCases.get(c.Id).get('priority') != null) {
            List<String> priorities = mapCases.get(c.Id).get('priority');
            if(priorities.isEmpty()) {
                return 2;

            }
            else if(priorities.size() == 1) {
                return convertPriority(priorities.get(0));
            }
            else {
                Integer min = 3;
                for(String priority : priorities) {
                    if(priority == '1') {
                        return 1;
                    }
                    else if(min > convertPriority(priority)) {
                        min = convertPriority(priority);
                    }
                }
                return min;
            }
        }
        else {
            return 2;




        }
    }

    /**
     * Entrée : 
     *  - Une liste de case
     *  - Une map : case.ID/owner.DeveloperName
     * 
     * 
     * Sortie :
     * Méthode qui renvoi une Map contenant les informations de skills et priorité de routing d'un case.
     * 
     * Map principale :
     * clé : ID Case
     * valeur : Map Secondaire
     * 
     * Map Secondaire : 
     * clés (2 seulement possibles): 
     *  - "skills"
     *  - "priority"
     * valeurs possibles:
     *  - liste de skills
     *  - liste de priorités
     */
    public static Map<String, Map<String, List<String>>> getRoutingPriorityAndSkills(Map<Id, Case> caseMap, Map<Id, String> caseOwnerDeveloperName) {
        List<HP_OmniChannelRouting__mdt> routingParams = HP_UTIL_MetadataManager.getOmniChannelRoutingMtd();
        Map<String,Map<String, List<String>>> result = new Map<String,Map<String, List<String>>>();

        for(Case acase : caseMap.values()) {
            Map<String, List<String>> casePropertiesMap = new Map<String, List<String>>();
            List<String> skillList = new List<String>();
            List<String> prioritiesList = new List<String>();

            boolean isUrgenceCase = acase.HP_Type__c == 'HP_Form_Site' && acase.Subject.containsIgnoreCase('urgence');

            for(HP_OmniChannelRouting__mdt routingParam : routingParams) {
                boolean isSameOrigin = String.isBlank(routingParam.HP_CritCaseOrigin__c) || routingParam.HP_CritCaseOrigin__c == acase.Origin;
                boolean isSameSubType = String.isBlank(routingParam.HP_CritCaseSubType__c) || routingParam.HP_CritCaseSubType__c == acase.HP_Sous_type__c;
                boolean isSameType = String.isBlank(routingParam.HP_CritCaseType__c) || routingParam.HP_CritCaseType__c == acase.HP_Type__c;
                boolean isSameQueue = String.isBlank(routingParam.HP_CritQueue__c) || routingParam.HP_CritQueue__c == caseOwnerDeveloperName.get(acase.Id);
                boolean isSameRecordType = String.isBlank(routingParam.HP_CritRecordType__c) || routingParam.HP_CritRecordType__c == acase.RecordType.DeveloperName;
                boolean isSameCanal = String.isBlank(routingParam.HP_CritSkillType__c) || routingParam.HP_CritSkillType__c == acase.HP_Canal__c;
                
                boolean isSkillSet = !String.isBlank(routingParam.HP_ValueSkill__c);

                if(isSameOrigin && isSameSubType && isSameType && isSameQueue && isSameRecordType && isSkillSet && isSameCanal) {

                    
                    if(isUrgenceCase) {
                        skillList.add(routingParam.HP_ValueSkill__c);
                        prioritiesList.add(routingParam.HP_ValuePriority__c);
                    }
                    else if(!(routingParam.HP_ValueSkill__c == 'HP_FO_Email_Urgence_coupure')) {
                        skillList.add(routingParam.HP_ValueSkill__c);
                        prioritiesList.add(routingParam.HP_ValuePriority__c);
                    }


                }
                

            }




            casePropertiesMap.put('skills', skillList);
            casePropertiesMap.put('priority', prioritiesList);
            result.put(acase.Id, casePropertiesMap);

        }

        return result;
    }


    public static Integer convertPriority(String priority) {
        switch on priority {
            when 'High' {
                return 1;
            }
            when 'Medium' {
                return 2;
            }

            when 'Low' {
                return 3;
            }
        }

        return 2;
    }

    public static String convertPriorityIntegerToString(Integer priority) {
        switch on priority {
            when 1 {
                return 'High' ;
            }
            when 2 {
                return 'Medium';
            }
            when 3 {
                return 'Low';
            }
        }
        return 'Medium';
    }

}