/*
*@Auhtor: Paul Ghoussoub
*@Description: Batch qui relance les mandats chaque jour
*@CreatedDate: 30/03/2021
*@LastModified: 20/10/2021
*/

global class VI_BAT02_RelanceCPV implements Database.Batchable<sObject>{
    global final String Query = 'SELECT Id, VI_DateRelanceCPV1__c, VI_DateRelanceCPV2__c, VI_DateRelanceCPV3__c, VI_DateRelanceCPV4__c, VI_DateRelanceCPV5__c, VI_TechRelanceCpvParametrablemetier__c, VI_Email_Relance_CPV__c, VI_PartenaireRelieAuParcours__c, VI_Contact__c, VI_Email_CPV__c, VI_Date_envoi_email__c FROM VI_Parcours__c WHERE VI_Date_envoi_email__c!=NULL AND VI_Email_CPV__c!=NULL AND VI_TechRelanceCpvParametrablemetier__c=false AND VI_ChoixParcours__c=\'CHF\'';
    global final String emailTemplateQuery='Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName =\'Email5Relancecpv\''; 
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('VI_BAT02_RelanceCPV starting...');
        return Database.getQueryLocator(Query);
    }
    
    public static void execute(){
        VI_BAT02_RelanceCPV relanceBacth = new VI_BAT02_RelanceCPV();
        Database.executeBatch(relanceBacth,50); 
    }
    
    global void execute(Database.BatchableContext bc, List<VI_Parcours__c> scope){
        List<Messaging.Email> emailsToSend=new List<Messaging.Email>();
        EmailTemplate emailTemplate = Database.query(emailTemplateQuery);
        Date todaysDate = Date.today();
        system.debug('Dans le batch');
        for(VI_Parcours__c parcours:scope){
            List<VI_DonneesParcours__c> donneeParcours;
            donneeParcours=[Select Id, VI_EmailRelanceCPV1__c, VI_EmailRelanceCPV2__c, VI_EmailRelanceCPV3__c, VI_EmailRelanceCPV4__c, VI_EmailRelanceCPV5__c, VI_NomPartenaire__r.Name From VI_DonneesParcours__c Where VI_NomPartenaire__r.Name=:parcours.VI_PartenaireRelieAuParcours__c];
            
            if (donneeParcours.size() > 0) {
                if (parcours.VI_DateRelanceCPV1__c == todaysDate) {
                	parcours.VI_Email_Relance_CPV__c = donneeParcours[0].VI_EmailRelanceCPV1__c;
                }
                else if(parcours.VI_DateRelanceCPV2__c == todaysDate) {
                    parcours.VI_Email_Relance_CPV__c = donneeParcours[0].VI_EmailRelanceCPV2__c;
                }
                else if(parcours.VI_DateRelanceCPV3__c == todaysDate) {
                    parcours.VI_Email_Relance_CPV__c = donneeParcours[0].VI_EmailRelanceCPV3__c;
                } 
                else if(parcours.VI_DateRelanceCPV4__c == todaysDate) {
                    parcours.VI_Email_Relance_CPV__c = donneeParcours[0].VI_EmailRelanceCPV4__c;
                } 
                else if(parcours.VI_DateRelanceCPV5__c == todaysDate) {
                    parcours.VI_Email_Relance_CPV__c = donneeParcours[0].VI_EmailRelanceCPV5__c;
                } 
            }
            
            if (!String.isBlank(parcours.VI_Email_Relance_CPV__c)){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
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
                //mail.setReplyTo(parcours.VI_Email_CPV__c);
                
                OrgWideEmailAddress emailSender=[select Id, Address, DisplayName from OrgWideEmailAddress where Address='noreply@clients-particuliers.engie.fr'];
                // Specify the name used as the display name.
               	// mail.setSenderDisplayName(emailSender.DisplayName);
               	// mail.setSenderDisplayName('Engie EITECH');
                mail.setOrgWideEmailAddressId(emailSender.id);

                
                // Specify the subject line for your email address.
                mail.setSubject(emailTemplate.subject);
                String emailBody=emailTemplate.HtmlValue;
                //system.debug('emailBody '+emailBody);
                if(parcours.VI_Email_Relance_CPV__c != null && emailBody.contains('{!VI_Parcours__c.VI_URL_IBAN_en_selfcare__c}')){
            		system.debug('contains VI_Email_Relance_CPV__c');
            		emailBody= emailBody.replace('{!VI_Parcours__c.VI_Email_Relance_CPV__c}', parcours.VI_Email_Relance_CPV__c);
        		}
                //system.debug('emailBody '+emailBody);
                mail.setHtmlBody(emailBody);
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                system.debug('before send email');
                // Send the email you have created.
                emailsToSend.add(mail);
                //if(!test.isRunningTest()){
                //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                //}
                parcours.VI_Tech_relance_CPV__c=true;
                system.debug('after send email');
            }
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(emailsToSend);
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('VI_BAT02_RelanceCPV ending...');
    }
}