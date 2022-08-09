public without sharing class SM_AP95_SkillBasedRouting {
    @InvocableMethod
    public static void routingCasesToAgents(List<String> caseIds){
        
        // - Récupération des Omnichannel rules
        List<Omnichannel_Rule__c> omniRules = [SELECT id,Objet__c,Champ__c,Valeur__c,Competence__c,Date_de_debut__c,Date_de_fin__c
                                               from Omnichannel_Rule__c];
        // - Récupération des skills
        List<Skill> matchingSkills = [SELECT id,MasterLabel,DeveloperName from Skill];
        
        List<SkillRequirement> listSkillReqsToInsert = new List<SkillRequirement>();
        List<PendingServiceRouting> listPsrToBeInserted= new  List<PendingServiceRouting> ();
        List<PendingServiceRouting> psrReadyForRouting  = new  List<PendingServiceRouting> ();
        
        if(omniRules != null && !omniRules.isEmpty())
        {
            // - Récupération des champs
            Map<String,String> champs = GetCaseDVFields(omniRules);
            
            // - Récupération de l'objet case avec les valeurs des champs
            Case[] casesInserted = GetCaseData(caseIds,champs.get('champsCase'));
            
            // - Récupération de l'objet données vente avec les valeurs des champs
            System.debug('caseIds 18' + caseIds);
            Map<String,Donnees_Vente__c[]> dVRecords = GetDVData(caseIds,champs.get('champsDV'));
            
            // - Insertion du PendingServiceRouting
            List<ServiceChannel> serviceChannel = [SELECT id from ServiceChannel where DeveloperName = 'Case'];
            
            // -  check des pendingServiceRoutings éxistants pour éviter les doublons
            
            
            // [FT3-1805] correction des doublons de PSR avec le meme WorkItemId. 
            Set<String> setWorkItem  = new Set<String>() ; 
            List<PendingServiceRouting> listPendingSR = new List<PendingServiceRouting>() ; 
            listPendingSR = [Select  workItemId from PendingServiceRouting where workItemId in : caseIds] ; 
            
            for( PendingServiceRouting pendingSR : listPendingSR){ 
                setWorkItem.add(String.valueOf(pendingSR.workItemId)) ; 
            }          
            
            map<id,set<string>> mapCaseAllComp = new map<id,set<string>>();
            
            for(Case caseRec : casesInserted){
                PendingServiceRouting psr;
                
                if(serviceChannel != null && setWorkItem.contains(caseRec.Id) == false ){
                    psr = InsertPendingServiceRouting(caseRec.Id,'SkillsBased',1,1,serviceChannel[0].Id,System.Label.SM_Case_Routing_Model,FALSE);
                    listPsrToBeInserted.add(psr);
                    
                    // - Filtrer les compétences en vérifiant les valeurs des champs Avec les règles définies sur l'objet omnichannelRule
                    set<string> allComp = new set<string>();
                    allComp = GetRequiredSkills(omniRules,caseRec,dVRecords.get(caseRec.Id));
                    mapCaseAllComp.put(caseRec.Id, allComp);
                } 
            }
            
            if(listPsrToBeInserted.size() > 0){
                Insert listPsrToBeInserted;
            }
            
            for(PendingServiceRouting psr : listPsrToBeInserted){
                // - Préparation des SkillsRequirements à inserer
                listSkillReqsToInsert.addall(InsertSkillRequirements(mapCaseAllComp.get(psr.WorkItemId), psr, matchingSkills));
            }
            
            if(listSkillReqsToInsert.size() > 0){
                // - Insertion des SkillsRequirements
                Insert listSkillReqsToInsert;
            }
            
            for(PendingServiceRouting psr : listPsrToBeInserted){
                // - PUSH de la PSR dans la queue
                psr.IsReadyForRouting = TRUE;
                psrReadyForRouting.add(psr);
            }
            
            if(psrReadyForRouting.size() > 0){
                Update psrReadyForRouting;
            }
        }
    }
    
    public static PendingServiceRouting InsertPendingServiceRouting (String caseId,String routingType,Integer routingPriority, Integer capacityWeight, String serviceChannelId, String routingModel, Boolean isReadyForRouting ){
        PendingServiceRouting psr= new PendingServiceRouting();
        psr.workItemId = caseId;
        psr.RoutingType = routingType;
        psr.RoutingPriority = routingPriority;
        psr.CapacityWeight = capacityWeight;
        psr.ServiceChannelId = serviceChannelId;
        psr.RoutingModel = routingModel;
        psr.IsReadyForRouting = isReadyForRouting;
        return psr;
    }
    
    public static Map<String,String> GetCaseDVFields(List<Omnichannel_Rule__c> omniRules){
        Date myDate = System.today();
        String champsCase='',champsDV='';
        Map<String,String> champs = new Map<String,String>();
        for(Omnichannel_Rule__c omniRule : omniRules){
            if( (myDate >= omniRule.Date_de_debut__c && (myDate <= omniRule.Date_de_fin__c || omniRule.Date_de_fin__c == null)) || (omniRule.Date_de_debut__c == null && (myDate <= omniRule.Date_de_fin__c || omniRule.Date_de_fin__c == null)))
            {
                if(omniRule.Objet__c=='Case' && !champsCase.contains(omniRule.Champ__c)){
                    champsCase +=omniRule.Champ__c+',';
                }
                else if(omniRule.Objet__c=='Donnees_Vente__c' && !champsDV.contains(omniRule.Champ__c)){
                    champsDV +=omniRule.Champ__c+',';
                }
            }
        }
        champs.put('champsCase', champsCase);
        champs.put('champsDV', champsDV);
        return champs;
    }
    
    public static Case[] GetCaseData(List<String> caseIds,String champsCase){
        Case[] caseRec;
        if(champsCase != '') {
            champsCase=champsCase.substring(0, champsCase.length() - 1);
            String queryCase = 'SELECT ' +  champsCase + ' FROM Case WHERE Id IN:caseIds';
            caseRec = Database.query(queryCase);
        }
        return caseRec;
    }
    
    public static Map<String,Donnees_Vente__c[]> GetDVData(List<String> caseIds,String champDV){
        Donnees_Vente__c[] DVRecords;
        Map<String,Donnees_Vente__c[]> DVRecordsMap = new Map<String,Donnees_Vente__c[]>();
        if(champDV != '') {
            champDV=champDV.substring(0, champDV.length() - 1);
            String queryDV = 'SELECT CaseId__c,' +  champDV + ' FROM Donnees_Vente__c WHERE CaseId__c IN:caseIds';
            DVRecords = Database.query(queryDV);
            System.debug('DVRecords 92' + DVRecords);
            for(String caseId : caseIds){
                Donnees_Vente__c[] dVRecs = new List<Donnees_Vente__c>();
                for(Donnees_Vente__c dv : DVRecords){
                    if(caseId == dv.CaseId__c) {
                        System.debug('caseId 97' + caseId);
                        dVRecs.add(dv);
                    }
                }
                System.debug('dVRecs' + dVRecs);
                DVRecordsMap.put(caseId,dVRecs);
            }
        }
        System.debug('DVRecordsMap' + DVRecordsMap);
        return DVRecordsMap;
    }
    
    public static set<string> GetRequiredSkills(List<Omnichannel_Rule__c> omniChannelRules, Case caseRec, Donnees_Vente__c[] DonneesVente) {
        set<string> allComp = new set<string>();
        Date myDate = System.today();
        for(Omnichannel_Rule__c omniRule : omniChannelRules){
            if( (myDate >= omniRule.Date_de_debut__c && (myDate <= omniRule.Date_de_fin__c || omniRule.Date_de_fin__c == null)) || (omniRule.Date_de_debut__c == null && (myDate <= omniRule.Date_de_fin__c || omniRule.Date_de_fin__c == null)))
            {
                if(omniRule.Objet__c=='Case') {
                    if(omniRule.Valeur__c == string.valueOf(caseRec.get(omniRule.Champ__c))) {
                        allComp.Add(omniRule.Competence__c);
                    }
                }
                if(omniRule.Objet__c=='Donnees_Vente__c' && DonneesVente != null) {
                    for(Donnees_Vente__c DVRec : DonneesVente) {
                        if(omniRule.Valeur__c == string.valueOf(DVRec.get(omniRule.Champ__c))) {
                            allComp.Add(omniRule.Competence__c);
                        }
                    }
                }
            }
        }
        return allComp;
    }
    
    public static List<SkillRequirement> InsertSkillRequirements(set<string> allComp, PendingServiceRouting psr, List<Skill> matchingSkills) {
        List<SkillRequirement> skillReqsToInsert = new List<SkillRequirement>();
        
        //Association des skills avec PSR request
        for (Skill matchingSkill : matchingSkills){
            for (String  Comp : allComp){
                if(matchingSkill.MasterLabel == Comp || matchingSkill.DeveloperName == Comp){
                    SkillRequirement skillRequ = new SkillRequirement();
                    skillRequ.SkillId = matchingSkill.Id;
                    skillRequ.RelatedRecordId = psr.id;
                    skillRequ.SkillLevel = 1;
                    skillReqsToInsert.add(skillRequ);
                }
            }
        }
        return skillReqsToInsert;
    }
}