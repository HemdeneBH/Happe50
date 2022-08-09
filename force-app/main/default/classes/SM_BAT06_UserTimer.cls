/**
* @author        :  Nourelimane SMOUNI
* @date          :  01/04/2022
* @description   :  [Habilitation] - Désactivation des users automatisée
* @us            :  SMILE PI#04 , FT3-1622
**/

public without sharing class SM_BAT06_UserTimer implements Database.Batchable<SObject> , Database.Stateful {
    list <user> disabledUsers = new list <user> ();
    String disabledProfiles=System.Label.SM_CL93_User_Profile_Setting;
    Integer timer= Integer.valueOf(System.Label.SM_CL94_Timer_Disable_user);
    //récupèrer tous les users actifs sur Smile dont les profil SM_Utilisateur métier restriction moyenne,SM_Utilisateur métier restriction maximale,SM_Utilisateur métier restriction faible et SM_Utilisateur admin métieret LastloginDatesupérieur ou égal à 60
    public String query = 'select  Id,isActive,LastLoginDate, Name,Gaia__c from User '+
        'where Profile.Name IN (' + disabledProfiles +') and IsActive = true and  LastLoginDate!=LAST_N_DAYS:'+timer+'';
    
    //Start method of the batch    
    public Database.querylocator start(Database.BatchableContext bc){
     if(Test.isRunningTest()){
        query = query + ' limit 1' ; 
    }
        return Database.getQueryLocator(query);
    } 
    //Execute method of the batch
    public void execute( Database.BatchableContext bc, List<User> listUsers){
        try{
            for(user u : listUsers){
                u.IsActive = false;
                disabledUsers.add(u);
                
            }
           System.debug('### disabledUsers:' + disabledUsers);
            update disabledUsers;
        } catch (DMLException e){
            System.debug('Erreur technique :' + e.getMessage());
        }
    }                                                       
    //Finish method of the batch
    public void finish(Database.BatchableContext bc){
        
        System.debug(' users désactivés:'+ disabledUsers.size());
        system.debug('id du user :'+ disabledUsers);
        
    }
}