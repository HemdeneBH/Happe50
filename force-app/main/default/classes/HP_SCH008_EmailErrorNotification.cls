/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-03-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-22-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global class HP_SCH008_EmailErrorNotification implements Schedulable, HP_UTIL_BatchInterface {
   global void execute(SchedulableContext SC) {
        
       EmailTemplate et=[Select id from EmailTemplate where name = 'HP_Email_ErrorNotification' limit 1];
	   Messaging.SingleEmailMessage message =  Messaging.renderStoredEmailTemplate(et.id, null, null);
       message.setSaveAsActivity(false); 
       message.toAddresses = HP_UTIL_MetadataManager.getConfigByKey('HP_Notification_Email_Error_List').split(';');
	   Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
      String envName = HP_UTIL_MetadataManager.getConfigByKey('HP_ENV_NAME');
      String subject = message.getSubject();
      message.setSubject('[' + envName + '] ' + subject);
  	   Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

   }

   global static void launchNewScheduler(String schedule, String jobName){
		System.schedule(jobName, schedule, new HP_SCH008_EmailErrorNotification());
	}
}