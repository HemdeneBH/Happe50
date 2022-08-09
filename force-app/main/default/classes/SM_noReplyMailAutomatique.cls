/*
* @Author: Ibrahim Merabti
* @Date: 05/06/2020
* @Description: Envoi d'un mail de noreply automatique 
*/

public class SM_noReplyMailAutomatique {
    @InvocableMethod
    public static void sendNoReplyMail(List<EmailMessage> EmailMessage) {

        // create a test contact whose Id is passed to the template. 
        // If a contact already exists, retrieve it, otherwise create a new one. 
        Contact[] testContact = [select id, Email from Contact where FirstName ='DefaultFirstName' and LastName='DefaultLastName' limit 1];
        if(testContact.isEmpty()){
       		 Contact cnt = new Contact(FirstName='DefaultFirstName', LastName='DefaultLastName');
       		 cnt.email = EmailMessage[0].fromAddress; 
        	 insert cnt; 
             testContact.add(cnt);
        }else{
           testContact[0].Email = EmailMessage[0].fromAddress;
           update testContact;
        }

        // récuèrer l'adresse mail Noreply pour envoyer le mail automatique
        OrgWideEmailAddress[] owea = null;
        owea = [select Id from OrgWideEmailAddress where displayname='ENGIE-PARTICULIERS'];
        
        system.debug(LoggingLevel.INFO, '## >> INFO [SM_noReplyMailAutomatique][sendNoReplyMail][Message]: ID OrgWideEmailAddress : '+owea );
        
        //Exit execution if reply adress is empty
        if(owea.isEmpty()){
            return;
        }

        // simuler l'envoi d'un mail 
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setTemplateId( [select id from EmailTemplate where DeveloperName='noReply'].id );

        msg.setTargetObjectId(testContact[0].Id);
        msg.setWhatId(testContact[0].Id);
        msg.setSaveAsActivity(false);

        msg.setToAddresses(new List<String>{EmailMessage[0].fromAddress});
        msgList.add(msg);
        
        // Roll back la transaction
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(msgList); // l'envoi du mail bidon est initié, mais il ne sera jamais envoyé 
        Database.rollback(sp); // Le roll back empèche l'envoi de  mail. 
        
        // Envoyer le vrai mail automatique
        List<Messaging.SingleEmailMessage> msgListToBeSend = new
            List<Messaging.SingleEmailMessage>();
        for (Messaging.SingleEmailMessage email : msgList) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(email.getToAddresses());
            emailToSend.setPlainTextBody(email.getPlainTextBody());
            emailToSend.setHTMLBody(email.getHTMLBody());
            emailToSend.setSubject(email.getSubject());
            emailToSend.setOrgWideEmailAddressId(owea[0].Id);
            msgListToBeSend .add(emailToSend);
        }
        Messaging.sendEmail(msgListToBeSend);
    }
}