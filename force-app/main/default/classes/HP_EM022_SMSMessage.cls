/**
 * @File Name          : HP_EM022_SMSMessage.cls
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Mohamed Aamer
 * @Last Modified On   : 04/02/2020 à 09:00:58
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03/02/2020   Mohamed Aamer     Initial Version
**/
public with sharing class HP_EM022_SMSMessage {
    
    public static void createSMSMessage(Id contactId) {
        Id recordTypeTask = Schema.SobjectType.Task.getRecordTypeInfosByDeveloperName().get('HP_Task').getRecordTypeId();
        try {
            Task smsMessage = new Task();
            smsMessage.WhoId = contactId;
            smsMessage.Subject = HP_Constantes.INFO_CLIENT_SMS_SUBJECT+HP_Constantes.WS_ES_CORRESPONDANCE_OBJET;
            smsMessage.Status = 'Completed';
            smsMessage.Type = 'Appel';
            smsMessage.TaskSubtype = 'Call';
            smsMessage.ActivityDate = Date.today();
            smsMessage.RecordTypeId = recordTypeTask;
            
            insert smsMessage;

        } catch (DmlException dmlException) {
            System.debug('faild to insert SMSMessage : '+ dmlException);
        }
    }
}