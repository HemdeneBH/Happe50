/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 04-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_CommunityUserManagerAsync implements Queueable{
    public Decimal idTiers;
    public HP_EC_CommunityUserManagerAsync(Decimal idTiers) {
        this.idTiers = idTiers;
    }

    public void execute(QueueableContext context) {
        HP_EC_Util_CommunityUsersManager.createCommunityUser(idTiers);
    }
}