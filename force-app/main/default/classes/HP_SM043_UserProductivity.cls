/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-19-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-19-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public without sharing class HP_SM043_UserProductivity{




    public static void addUserHistory(List<HP_CaseHistory__c> caseHistories, Integer HP_LIMITE_DUREE_ATTRIBUTION, Date selectedDate){
              

        System.debug('***123***');
        //prepare number of traitement
        Integer numberOfTreatments = caseHistories.size();
        System.debug('caseHistories******:'+caseHistories);
        System.debug('caseHistories size******:'+caseHistories.size());
        if(numberOfTreatments > 0){
           BusinessHours bh = [SELECT Id, SundayStartTime, SundayEndTime, MondayStartTime,MondayEndTime , TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime FROM BusinessHours WHERE name ='HP'];

        System.debug('bh******:'+bh);
        //group the caseHistory by userId
        map<String,List<HP_CaseHistory__c>> mapUserToCaseHistory= new map<String,List<HP_CaseHistory__c>>();

        for(HP_CaseHistory__c caseHistory : caseHistories) {
            
            if(mapUserToCaseHistory.containsKey(caseHistory.User__c)) {
              
                List<HP_CaseHistory__c> listCaseHistory = mapUserToCaseHistory.get(caseHistory.User__c);
                listCaseHistory.add(caseHistory);
                mapUserToCaseHistory.put(caseHistory.User__c, listCaseHistory);
            } else {
                mapUserToCaseHistory.put(caseHistory.User__c, new List<HP_CaseHistory__c> { caseHistory });
               
            }
        }

            List <HP_UserHistory__c> userHistories = new List <HP_UserHistory__c>();
            map<String,List<UserServicePresence>> userPresenceMap= new map<String,List<UserServicePresence>>();
           //group the UserServicePresence by userId
            for(HP_CaseHistory__c caseHistory : caseHistories) {
                userPresenceMap.put(caseHistory.User__c,new List<UserServicePresence>());
            }


            List<UserServicePresence> userServicePresenceList = HP_EM039_UserServicePresence.getUserServicePresenceMap(userPresenceMap.keySet(), selectedDate);

    
            for(UserServicePresence userpres:userServicePresenceList){
              
                if(userPresenceMap.containsKey(userpres.UserId)) {
                    List<UserServicePresence> myList = (userPresenceMap.get(userpres.UserId)!=null) ? userPresenceMap.get(userpres.UserId) : new List<UserServicePresence>();
                    myList.add(userpres);
                    userPresenceMap.put(userpres.UserId, myList);
                } else {
                    userPresenceMap.put(userpres.UserId, new List<UserServicePresence> { userpres });
                }
            }

            for (String userId : mapUserToCaseHistory.keySet()){
                Decimal somme =0;
                Decimal dureeTraitement = 0;
               
                for(HP_CaseHistory__c caseHistory : mapUserToCaseHistory.get(userId) ){

                      if(caseHistory.HP_DureeTraitement__c != null) dureeTraitement = dureeTraitement + caseHistory.HP_DureeTraitement__c;

                       // calculer duree de traitement si le case est sur 2jrs, exp: dateTraitement le 22/09 à 17:30 dateChangementStatus le 23/09 à 9:20.

                       if(caseHistory.HP_DateAttribution__c != null 
                            && selectedDate.isSameDay(caseHistory.HP_DateAttribution__c.date())
                            && caseHistory.HP_DateChangementStatut__c == null){
                        String today = getDayName(selectedDate);

                         // recuperer l'horaire de fin de journee.
                        Time endHour = getDayStartEndTime(today,false,bh);
                       
                        Time caseTime = caseHistory.HP_DateAttribution__c.time();
                        Integer total = getMinutes(caseTime, endHour);
                        if( total < HP_LIMITE_DUREE_ATTRIBUTION) {dureeTraitement = dureeTraitement + total;}
                       

                    } else if(caseHistory.HP_DateAttribution__c != null 
                            && caseHistory.HP_DateAttribution__c <selectedDate 
                            && caseHistory.HP_DateChangementStatut__c != null 
                            && selectedDate.isSameDay(caseHistory.HP_DateChangementStatut__c.date())
                            && caseHistory.HP_DureeTraitement__c != null){
                        
                        String today = getDayName(selectedDate);


                        Time startHour = getDayStartEndTime(today,true,bh);

    
                        Time caseTime = caseHistory.HP_DateChangementStatut__c.time();
                        
                        Integer total = getMinutes(startHour, caseTime);
                        if( total <HP_LIMITE_DUREE_ATTRIBUTION) {dureeTraitement = dureeTraitement + total;}
                    }

                }
                for(UserServicePresence userPresence : userPresenceMap.get(userId)){
            
                    if (bh != null && userPresence.StatusEndDate != null && userPresence.StatusStartDate != null){
                        Decimal result = BusinessHours.diff(bh.Id, userPresence.StatusStartDate,userPresence.StatusEndDate );
                        // milliseconds au minute
                        Decimal resultingHours = result/(60*1000);
                        somme  = somme + resultingHours;
                    }

                }

                HP_UserHistory__c userHistory = HP_EM040_UserHistory.createUserHistory(userId, mapUserToCaseHistory.get(userId).size(), somme, dureeTraitement, selectedDate);

                userHistories.add(userHistory);
            }

            System.debug('userHistories size ******:'+ userHistories.size());
            HP_EM040_UserHistory.saveUserHistoryList(userHistories);
        }
        
}

public static String getDayName(DateTime mydateTime){
    String dayOfWeek = mydateTime.format('E');
    return dayOfWeek;
}

public static Time  getDayStartEndTime(String name, Boolean isStart, BusinessHours bh){
    System.debug('bh.FridayEndTime ******:'+bh.FridayEndTime);
    switch on name {
        when 'Sun' {
            if(isStart) return bh.SundayStartTime;
            return bh.SundayEndTime;
        }
        when 'Mon' {
            if(isStart) return bh.MondayStartTime;
            return bh.MondayEndTime;
        }  
        when 'Tue' {
            if(isStart) return bh.TuesdayStartTime;
            return  bh.TuesdayEndTime; 
        }
        when 'Wed' {
            if(isStart) return bh.WednesdayStartTime;
            return bh.WednesdayEndTime; 
        }
        when 'Thu' {
            if(isStart) return bh.ThursdayStartTime;
            return bh.ThursdayEndTime;
        }
        when 'Fri' {
            if(isStart) return bh.FridayStartTime;
            return bh.FridayEndTime; 
        }
        when 'Sat' {
            if(isStart) return bh.SaturdayStartTime;
            return  bh.SaturdayEndTime;
        }
    }
    return null;

}

public static Integer getMinutes(Time startTime, Time endTime){
   
    if(startTime == null || endTime == null || startTime == endTime){
        return 0;
    }
    else{
        Integer elapsedHours = endTime.hour() - startTime.hour();
        elapsedHours = elapsedHours >0 ? elapsedHours : -elapsedHours ;
        Integer elapsedMinutes = endTime.minute() - startTime.minute();
        elapsedMinutes = elapsedMinutes >0 ? elapsedMinutes : -elapsedMinutes;
        Integer elapsedSeconds = endTime.second() - startTime.second();
        elapsedSeconds = elapsedSeconds> 0 ? elapsedSeconds : -elapsedSeconds ;

        System.debug('elapsedHours  ******:'+elapsedHours);
                    System.debug('elapsedMinutes  ******:'+elapsedMinutes);
                    System.debug('elapsedSeconds  ******:'+elapsedSeconds);
                   
        Integer total = ((elapsedHours * 60 ) +
                         elapsedMinutes  + 
                          (elapsedSeconds/60) );
        
            return total;
    }
}
}