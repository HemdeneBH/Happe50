/**
 * @File Name          : HP_SM015_ContactModifNotification.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 03-02-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/03/2020   Vincent Albiser     Initial Version
**/
public with sharing class HP_SM015_ContactModifNotification {

    public class NotificationException extends Exception {}

    @AuraEnabled
    public static void sendSMS(String prenom, Integer idClient, String numMobile){
        EmailTemplate smsTemplate = HP_EM018_EmailTemplate.getEmailTemplateByName(HP_Constantes.INFO_CLIENT_SMS_TEMPLATE_NAME);

        if (smsTemplate != null) {
            String htmlBody = smsTemplate.HtmlValue.replace('[Prenom]', prenom);

            System.debug('htmlBody: '+htmlBody);
            Map<String, String> smsParametres = new Map<String, String>();
            if(numMobile.length() < 10) {
                numMobile = '0' + numMobile;
            }
            smsParametres.put('numMobile', numMobile); 
            smsParametres.put('idClient', String.valueOf(idClient));           
            smsParametres.put('contenu', htmlBody);
            smsParametres.put('canalCommunicationCode', 'SMS');
            smsParametres.put('idFormulaireCode', 'SMS1');
            smsParametres.put('idFormulaireLibCourt', 'SMS Happ-e');
            Contact currentContact = HP_EM020_Contact.getContactByXdataId(Integer.valueOf(smsParametres.get('idClient')));
            HP_UTIL_MailSmsEnvoi.envoiAsync(smsParametres);
            
        } else {
            throw new NotificationException('cannot found email template in salesforce');
        }
    }

    @AuraEnabled
    public static void sendEmail(String prenom, String email, Integer idClient, Object infosEmailToSend){
        
        EmailTemplate emailTemplate = HP_EM018_EmailTemplate.getEmailTemplateByName(HP_Constantes.INFO_CLIENT_EMAIL_TEMPLATE_NAME);

        if (emailTemplate != null) {
            System.debug('*******infosEmailToSend*****: '+infosEmailToSend);
            System.debug('*******prenom*****: '+prenom);
            System.debug('*******email*****: '+email);
            System.debug('*******idClient*****: '+idClient);
         

            string informationsModifiees = '';
            Map<String, Object> infosMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(infosEmailToSend));
            final String clientId = String.valueOf(idClient);
            System.debug('*******infosMap*****: '+infosMap.size());
            for (String info : infosMap.keySet()) {
                if (info == 'numMobile') informationsModifiees = informationsModifiees + '<li> Votre Téléphone portable  ' + infosMap.get(info)+'</li>' ;
                else if (info == 'numFixe') informationsModifiees = informationsModifiees + '<li> Votre Téléphone fixe  ' + infosMap.get(info)+'</li>';
                else if(info == 'numeroEtranger') informationsModifiees = informationsModifiees +'<li> Votre numéro étranger ' + infosMap.get(info)+'</li>';
                else if (info == 'email') informationsModifiees = informationsModifiees + '<li> Votre Email  ' + infosMap.get(info)+'</li>';
                else if (info == 'adresse') informationsModifiees = informationsModifiees + '<li> Votre Adresse  ' + infosMap.get(info)+'</li>';
                else if (info == 'consentements') informationsModifiees = informationsModifiees + '<li> Vos consentements</li>';
            }

            String htmlBody = emailTemplate.HtmlValue
                    .replace('[InformationsModifiees]', informationsModifiees)
                    .replace('[Prenom]', prenom);

            System.debug('htmlBody: '+htmlBody);
            Map<String, String> mailParametres = new Map<String, String>();
            mailParametres.put('email', email);
            mailParametres.put('idClient', String.valueOf(idClient));
            mailParametres.put('contenu', htmlBody);
            mailParametres.put('idFormulaireCode', 'SF52');
            mailParametres.put('idFormulaireLibCourt', 'Mail happe');
            mailParametres.put('canalCommunicationCode', 'EMAIL');
            mailParametres.put('canalCommunicationLibCourt', 'Email');
            System.debug('*******mailParametres*****: '+mailParametres);
            HP_UTIL_MailSmsEnvoi.envoiAsync(mailParametres);            
        } else {
            throw new NotificationException('cannot found email template in salesforce');
        }
    }
}