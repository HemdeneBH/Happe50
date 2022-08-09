/**
@Author <Amar Kaillo>
@name <SM_AP01_EmailMessageHandler>
@CreatedDate <21/11/2019>
@Description <Handler Trigger for EmailMessageTrigger>
@Version <1.0>
@reference <Referenced program names>
@ModifiedBy <Amar Kaillo>
*/
public class SM_AP01_EmailMessageHandler {
/**
* Create the link between task and case after being modified on email message
* @name <updateCaseOnTask>
* @param <listNewEmailMessages> <Newly created EmailMessage>
* @param <mapOldEmailMessage> <Values of old EmailMessage - before update>
* @return <> - <>
* @throws exception-<DML Exception if update of tasks fails>
*/    
    public static void updateCaseOnTask(List<EmailMessage> listNewEmailMessages, Map<Id, EmailMessage> mapOldEmailMessage){
        Map<String, String> mapTaskCase = new Map<String, String>();
        List<String> listTasksToRemoveCase = new list<String>();
        
        for(EmailMessage emailMessage : listNewEmailMessages){
            // Verify that activityId isn't null and Case__c is modified
            if(emailMessage.activityId != null){
                if(mapOldEmailMessage == null
                   && emailMessage.Case__c != null){
                       mapTaskCase.put(emailMessage.activityId, emailMessage.Case__c);
                   }
                else if (mapOldEmailMessage != null
                         && emailMessage.Case__c != mapOldEmailMessage.get(emailMessage.Id).Case__c){
                             if(emailMessage.Case__c == null){
                                 listTasksToRemoveCase.add(emailMessage.activityId);
                             }
                             else{
                                 mapTaskCase.put(emailMessage.activityId, emailMessage.Case__c);
                             }
                         }
            } 
        }  

        // Get list of taks to updte
        List<Task> listTaskstoUpdate = [SELECT Id, WhatId
                                        FROM Task
                                        WHERE Id IN :mapTaskCase.KeySet()
                                        OR Id IN :listTasksToRemoveCase];
       
        
        for(Task task : listTaskstoUpdate){
            // If caseId isn't filled on the EmailMessage level, remove the link to the case from the task
            if(listTasksToRemoveCase.contains(task.Id)){
                task.WhatId = null;
            }
            else{
                task.WhatId = mapTaskCase.get(task.Id);
            }
        }

        try{
             update listTaskstoUpdate;
        }
        catch(DMLException errorMessage){
           System.debug('ErrorMessafe Trigger EmailMessage' +  errorMessage.getDmlMessage(0));
        }
       
    }
}