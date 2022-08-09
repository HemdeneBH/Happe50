/**
 * @description  : 
 * @author       : Antoine Latour
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   17-11-2020   Antoine Latour   Initial Version
**/
public without sharing class HP_SM047_QSReport{

    /**
    * @description 
    * @author Antoine Latour | 17-11-2020 
    * @param List<EmailMessage> emailMessageList 
    **/
    public static void updateQSResponseTime(List<EmailMessage> emailMessageList) {
        if(emailMessageList == null)
            return;

        Set<Id> emailPrecedentSet = new Set<Id>();
        for(EmailMessage item : emailMessageList) {
            if(item.ReplyToEmailMessageId != null) {
                emailPrecedentSet.add(item.ReplyToEmailMessageId);
            }
        }
        Map<Id, EmailMessage> emailMessagePrecedentMap = HP_EM019_EmailMessage.createEmailMessageMap(emailPrecedentSet);
        HP_EM019_EmailMessage.updateMailResponseTime(emailMessageList, emailMessagePrecedentMap);
    }
}