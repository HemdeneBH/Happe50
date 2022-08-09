/*@Author: Clement Bouquin
*@Description: lorsque le satut des cpv et/ou du mandat passent à "Signed", cette classe envoie un Email
*@param Case[] newList et Map<Id, Case> oldMap
*@return void ( called from a trigger) 
*@CreatedDate: 09/09/2021
*@LastModified: 15/09/2021
*/

public class VI_SM044_EmailDeConfirmation {
    
    public static Boolean emailAlreadySent=false;

    public static void sendEmailConfirmation(List<Case> newList,Map<Id, Case> oldMap) {

        Set<id> setCaseIdsMandatSigned = new Set<Id>();
        Set<id> setCaseIdsCPVSigned = new Set<Id>();
        List<VI_Parcours__c> listParcoursMandat;
        List<VI_Parcours__c> listParcoursCPV;

        //Looking for every cases where VI_StatutMandat__c or VI_StatutEnveloppe__c have just passed to 'signed'
        system.debug('¤ trigger email de confirmation');
        for(case cas:newList){
            if(cas.VI_StatutMandat__c == 'Signed'
               && oldMap.containsKey(cas.Id)
               && cas.VI_StatutMandat__c != oldMap.get(cas.Id).VI_StatutMandat__c){
                   system.debug('un mandat a été signé voici son id: '+ cas.Id);
                   setCaseIdsMandatSigned.add(cas.Id);
               }
            if(cas.VI_StatutEnveloppe__c == 'Signed'
               && oldMap.containsKey(cas.Id)
               && cas.VI_StatutEnveloppe__c != oldMap.get(cas.Id).VI_StatutEnveloppe__c){
                   system.debug('une envelope a été signé voici son id: '+ cas.Id);
                   setCaseIdsCPVSigned.add(cas.Id);
               }
        }
        
        String myAttachmentTitle = '';

        //Filling caseIds in set to query parcours for required fields
        Map<Id, String> attachmentMandatToParcoursMap  = new Map<Id, String>();
        
        listParcoursMandat=[Select id, VI_Contact__c, VI_Case__c, VI_Email_CPV__c, VI_ID_Mandat__c, VI_IDReferenceClient__c 
                            From VI_Parcours__c 
                            Where VI_Case__c in :setCaseIdsMandatSigned];
        if(listParcoursMandat!= null & listParcoursMandat.size()>0){
            for(VI_parcours__c p : listParcoursMandat){
                myAttachmentTitle = 'ZMDT' + p.VI_ID_Mandat__c + '0' + p.VI_IDReferenceClient__c + '.pdf';
                system.debug('¤ Attachment title to send :' + myAttachmentTitle);
                attachmentMandatToParcoursMap.put(p.Id, myAttachmentTitle);
            }
            system.debug('¤ attachmentMandatToParcoursMap :' + attachmentMandatToParcoursMap);
            system.debug('¤ Email Template to send : Email n°4 - Mandat Sepa Signé');
            myEmailSender(listParcoursMandat, '\'Email4MandatSepaSigne\'', attachmentMandatToParcoursMap);
        }

        Map<Id, String> attachmentCPVToParcoursMap  = new Map<Id, String>();
        
        listParcoursCPV=[Select id, VI_Contact__c, VI_Case__c, VI_Email_CPV__c From VI_Parcours__c where VI_Case__c in :setCaseIdsCPVSigned];
        if(listParcoursCPV!= null & listParcoursCPV.size()>0){
            for(VI_parcours__c p : listParcoursCPV){
                myAttachmentTitle = 'ZCPV' + p.VI_Case__c + '.pdf';
                system.debug('¤ Attachment title to send :' + myAttachmentTitle);
                attachmentCPVToParcoursMap.put(p.Id, myAttachmentTitle); 
            }
            system.debug('¤ attachmentCPVToParcoursMap :' + attachmentCPVToParcoursMap);
            system.debug('¤ Email Template to send : Email n°3 - CPV Signées Généralisation');
            myEmailSender(listParcoursCPV, '\'Email3CpvSigneesGeneralisation\'', attachmentCPVToParcoursMap);
        }
    }
    
    public static void myEmailSender(List<VI_Parcours__c> parcoursEmailToSend, String emailTemplateToSend, Map<Id, String> myAttachmentTitle) {
        
        String emailTemplateQuery='Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =';
        
        List<Attachment> attachments = [Select Name, Body, BodyLength, parentId
                                        From Attachment 
                                        Where ParentId=:parcoursEmailToSend And name=:myAttachmentTitle.values()];
        Map<Id, Attachment> attachmentToIdMap = new Map<Id, Attachment>();
        for(Attachment a: attachments){
            if(myAttachmentTitle.get(a.parentId) == a.Name){ //to double check that we are getting the correct couple attachment / parcours
                attachmentToIdMap.put(a.parentId, a);
            }
        }

        for(VI_Parcours__c parcours:parcoursEmailToSend){
            
            emailTemplateQuery += emailTemplateToSend;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            EmailTemplate emailTemplate = Database.query(emailTemplateQuery);
            mail.setTemplateID(emailTemplate.Id);
            mail.setWhatId(parcours.Id);
            mail.setTargetObjectId(parcours.VI_Contact__c);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setSaveAsActivity(false);
            mail.setTreatBodiesAsTemplate(true);
            
            // Strings to hold the email addresses to which you are sending the email.
            String[] toAddresses = new String[] {parcours.VI_Email_CPV__c};
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            
            // Specify the address used when the recipients reply to the email.
            // mail.setReplyTo(parcours.VI_Email_CPV__c);
            
            OrgWideEmailAddress emailSender=[select Id, Address, DisplayName from OrgWideEmailAddress where Address='noreply@clients-particuliers.engie.fr'];
            // Specify the name used as the display name.
            // mail.setSenderDisplayName(emailSender.DisplayName);
            mail.setOrgWideEmailAddressId(emailSender.id);
            
            // Specify the subject line for your email address.
            mail.setSubject(emailTemplate.subject);
            String emailBody=emailTemplate.HtmlValue;
            //system.debug('emailBody '+emailBody);
            mail.setHtmlBody(emailBody);
            
            // Set to True if you want to BCC yourself on the email.
            mail.setBccSender(false);
            
            // Add attachement contents to the email.
            if (!attachmentToIdMap.isEmpty()) {
                Attachment a = attachmentToIdMap.get(parcours.Id);
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Name);
                efa.setBody(a.Body);
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa}); 
            }
        
            
            system.debug('¤ before send email');
            // Send the email you have created.cversion
            if(!test.isRunningTest() && !emailAlreadySent){
                system.debug('¤ envoie d un email');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                emailAlreadySent=true;
            }
            system.debug('¤ after send email');
        }
    }
}