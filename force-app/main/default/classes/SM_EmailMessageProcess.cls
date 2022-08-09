/**
 * @Author <Omar Mohamad>
 * @name <SM_EmailMessageProcess>
 * @CreatedDate <27/03/2020>
 * @Description <Process Trigger for EmailMessageTrigger>
 * @Version <1.0>
 * @reference <Referenced program names>
 *
 * @Modified by : Omar Mohamad
 * @Date : 27/03/2020
 * @Description:Optimisation trigger avec le pattern 0'hara.
 */
public with sharing class SM_EmailMessageProcess {
	
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
                if(mapOldEmailMessage == null && emailMessage.Case__c != null){
                    mapTaskCase.put(emailMessage.activityId, emailMessage.Case__c);
                } else if (mapOldEmailMessage != null && emailMessage.Case__c != mapOldEmailMessage.get(emailMessage.Id).Case__c){
                    if(emailMessage.Case__c == null){
                        listTasksToRemoveCase.add(emailMessage.activityId);
                    } else {
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
            } else {
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

    public static void checkEmailsHeaders(List<EmailMessage> listNewEmailMessages){
        // if the headers contains 'In-Reply-To' , empty the header. 
        for(EmailMessage em:listNewEmailMessages){            
            if(!String.isBlank(em.headers)){ 
                String headears = em.headers;             
                if(em.Incoming = true && (em.ToAddress == 'ibrahimplayground@gmail.com' || em.ToAddress == 'contact-uat@clients-particuliers.engie.fr' || 
                                          em.ToAddress == 'contact-pprod@clients-particuliers.engie.fr' || em.ToAddress == 'contact@clients-particuliers.engie.fr')){
                    if(!headears.startsWith('In-Reply-To'))
                        em.headers = null;


                }
            } 
        }
    }



}