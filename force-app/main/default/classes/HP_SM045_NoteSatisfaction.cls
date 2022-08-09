/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-28-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class HP_SM045_NoteSatisfaction {
    
    @AuraEnabled(cacheable=true)
    public static Contact loadContactWithNoteSatisfaction(String idContact) {
        return HP_EM041_NoteSatisfaction.loadContactWithNoteSatisfaction(idContact);
    }
}