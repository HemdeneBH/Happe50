/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 04-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_CommunityUserLoginManagerAsync implements Queueable{
    public Id myContactId;
    public HP_EC_CommunityUserLoginManagerAsync(Id myContactId) {
        this.myContactId = myContactId;
    }
    public void execute(QueueableContext context) {
        HP_EC_Util_CommunityUsersManager.insertLoginAndSendEmail(myContactId);
    }
}