/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 04-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_Util_EmailMessageHandler {

    public static final String ACTIVATION_EMAIL = 'Activation_Email';
    public static final String RESET_PASSWORD_EMAIL = 'Reset_Password_Email';
    public static final String LOGIN_SUFFIX = '/s/Login';
    
    @AuraEnabled(cacheable = true)
    public static Map<String,Object> sendWelcomeEmail(String contactEmail){
        Map<String,Object> resultObject = new Map<String,Object>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        try {
            Contact myContact = [SELECT Id, Email, LastName, FirstName, ID_Tiers__c, Salutation, Name FROM Contact WHERE Email = :contactEmail LIMIT 1];
            HP_Community_User__c myCommunityUser = [SELECT Id, Activation_Key__c FROM HP_Community_User__c WHERE Id_Tiers__c = :String.valueOf(myContact.ID_Tiers__c) LIMIT 1];
            HP_Community_Email_Setting__mdt emailSetting = [SELECT Email_Template__c, Page_URL__c, Reply_To__c, Sender_Name__c, URL_Prefix__c, From_Address__c FROM HP_Community_Email_Setting__mdt WHERE DeveloperName = :ACTIVATION_EMAIL LIMIT 1];
            Site site = [SELECT Id FROM Site WHERE UrlPathPrefix = :emailSetting.URL_Prefix__c LIMIT 1];
            String communityUrl = [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;
            String activationKey = myCommunityUser.Activation_Key__c;
            String welcomePageURL = communityUrl + emailSetting.Page_URL__c + activationKey;
            String loginPage = communityUrl + LOGIN_SUFFIX;
            String contactDisplayName = myContact.Salutation == 'MR' ? 'Monsieur ' + myContact.LastName : myContact.Salutation == 'MME' ? 'Madame ' + myContact.LastName  : myContact.Salutation + ' ' + myContact.LastName ;
            Id orgWideAddressId = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = :emailSetting.From_Address__c LIMIT 1].Id;
            EmailTemplate et = [SELECT Id, HtmlValue, Body, Subject FROM EmailTemplate WHERE DeveloperName = :emailSetting.Email_Template__c LIMIT 1];

            String htmlBody = et.HtmlValue;
            htmlBody = htmlBody.replace('{!Contact.LastName}', contactDisplayName);
            htmlBody = htmlBody.replace('{!MyPageURL}', welcomePageURL);
            htmlBody = htmlBody.replace('{!LoginPage}', loginPage);
            htmlBody = htmlBody.replace('{!Contact.ID_Tiers__c}', String.valueOf(myContact.ID_Tiers__c));
            htmlBody = htmlBody.replace('{!currentDate}', getCurrentDateFormatted());
            htmlBody = htmlBody.replace('{!friseBottom}', getDocumentRelativeLink('HP_frise_bottom'));
            htmlBody = htmlBody.replace('{!friseTop}', getDocumentRelativeLink('HP_frise_top'));
            htmlBody = htmlBody.replace('{!logoHappe}', getDocumentRelativeLink('HP_logoHappe'));
            htmlBody = htmlBody.replace('{!iconEC}', getDocumentRelativeLink('HP_iconEC'));

            String plainBody = et.Body;
            plainBody = plainBody.replace('{!Contact.LastName}', contactDisplayName);
            plainBody = plainBody.replace('{!MyPageURL}', welcomePageURL);
            plainBody = plainBody.replace('{!LoginPage}', loginPage);
            plainBody = plainBody.replace('{!Contact.ID_Tiers__c}', String.valueOf(myContact.ID_Tiers__c));
            plainBody = plainBody.replace('{!currentDate}', getCurrentDateFormatted());
            plainBody = plainBody.replace('{!friseBottom}', getDocumentRelativeLink('HP_frise_bottom'));
            plainBody = plainBody.replace('{!friseTop}', getDocumentRelativeLink('HP_frise_top'));
            plainBody = plainBody.replace('{!logoHappe}', getDocumentRelativeLink('HP_logoHappe'));
            plainBody = plainBody.replace('{!iconEC}', getDocumentRelativeLink('HP_iconEC'));

            List<string> toAddress = new List<string>();
            toAddress.add(myContact.Email);
            mail.setSubject(et.Subject);
            mail.setHtmlBody(htmlBody);
            mail.setPlainTextBody(plainBody);
            mail.setToAddresses(toAddress);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
            mail.setWhatId(myContact.Id);
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
            mail.setReplyTo(emailSetting.Reply_To__c);
            mail.setOrgWideEmailAddressId(orgWideAddressId);
            System.debug('mail : '+mail);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            resultObject.put('success',true);
            resultObject.put('error',null);
        } catch (Exception ex) {
            System.debug(' HP_EC_Util_EmailMessageHandler.sendWelcomeEmail() | Exception : ' + ex.getMessage() + ' Line Number : '+ex.getLineNumber());
            resultObject.put('success',false);
            resultObject.put('error',ex.getMessage());
        }
        return resultObject;
    } 

    @AuraEnabled(Cacheable = true)
    public static Map<String,Object> sendResetPasswordEmail(String contactEmail){
        Map<String,Object> resultObject = new Map<String,Object>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        try {
            Contact myContact = [SELECT Id, Email, LastName, FirstName, ID_Tiers__c, Salutation, Name FROM Contact WHERE Email = :contactEmail LIMIT 1];
            HP_Community_User__c myCommunityUser = [SELECT Id, Reset_Password_Key__c FROM HP_Community_User__c WHERE Id_Tiers__c = :String.valueOf(myContact.ID_Tiers__c) LIMIT 1];
            HP_Community_Email_Setting__mdt emailSetting = [SELECT Email_Template__c, Page_URL__c, Reply_To__c, Sender_Name__c, URL_Prefix__c, From_Address__c FROM HP_Community_Email_Setting__mdt WHERE DeveloperName = :RESET_PASSWORD_EMAIL LIMIT 1];
            Site site = [SELECT Id FROM Site WHERE UrlPathPrefix = :emailSetting.URL_Prefix__c LIMIT 1];
            String communityUrl = [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;
            String resetPasswordKey = myCommunityUser.Reset_Password_Key__c;
            String welcomePageURL = communityUrl + emailSetting.Page_URL__c + resetPasswordKey;
            String loginPage = communityUrl + LOGIN_SUFFIX;
            String contactDisplayName = myContact.Salutation == 'MR' ? 'Monsieur ' + myContact.LastName : myContact.Salutation == 'MME' ? 'Madame ' + myContact.LastName  : 'Monsieur et Madame ' + myContact.LastName ;
            Id orgWideAddressId = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = :emailSetting.From_Address__c LIMIT 1].Id;
            EmailTemplate et = [SELECT Id, HtmlValue, Body, Subject FROM EmailTemplate WHERE DeveloperName = :emailSetting.Email_Template__c LIMIT 1];

            String htmlBody = et.HtmlValue;
            htmlBody = htmlBody.replace('{!Contact.LastName}', contactDisplayName);
            htmlBody = htmlBody.replace('{!MyPageURL}', welcomePageURL);
            htmlBody = htmlBody.replace('{!LoginPage}', loginPage);
            htmlBody = htmlBody.replace('{!Contact.ID_Tiers__c}', String.valueOf(myContact.ID_Tiers__c));
            htmlBody = htmlBody.replace('{!currentDate}', getCurrentDateFormatted());
            htmlBody = htmlBody.replace('{!friseBottom}', getDocumentRelativeLink('HP_frise_bottom'));
            htmlBody = htmlBody.replace('{!friseTop}', getDocumentRelativeLink('HP_frise_top'));
            htmlBody = htmlBody.replace('{!logoHappe}', getDocumentRelativeLink('HP_logoHappe'));
            htmlBody = htmlBody.replace('{!iconEC}', getDocumentRelativeLink('HP_iconEC'));

            String plainBody = et.Body;
            plainBody = plainBody.replace('{!Contact.LastName}', contactDisplayName);
            plainBody = plainBody.replace('{!MyPageURL}', welcomePageURL);
            plainBody = plainBody.replace('{!LoginPage}', loginPage);
            plainBody = plainBody.replace('{!Contact.ID_Tiers__c}', String.valueOf(myContact.ID_Tiers__c));
            plainBody = plainBody.replace('{!currentDate}', getCurrentDateFormatted());
            plainBody = plainBody.replace('{!friseBottom}', getDocumentRelativeLink('HP_frise_bottom'));
            plainBody = plainBody.replace('{!friseTop}', getDocumentRelativeLink('HP_frise_top'));
            plainBody = plainBody.replace('{!logoHappe}', getDocumentRelativeLink('HP_logoHappe'));
            plainBody = plainBody.replace('{!iconEC}', getDocumentRelativeLink('HP_iconEC'));

            List<string> toAddress = new List<string>();
            toAddress.add(myContact.Email);
            mail.setSubject(et.Subject);
            mail.setHtmlBody(htmlBody);
            mail.setPlainTextBody(plainBody);
            mail.setToAddresses(toAddress);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
            mail.setWhatId(myContact.Id);
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
            mail.setReplyTo(emailSetting.Reply_To__c);
            mail.setOrgWideEmailAddressId(orgWideAddressId);
            System.debug('mail : '+mail);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            resultObject.put('success',true);
            resultObject.put('error',null);
        } catch (Exception ex) {
            System.debug(' HP_EC_Util_EmailMessageHandler.sendResetPasswordEmail() | Exception : ' + ex.getMessage() + ' Line Number : '+ex.getLineNumber());
            resultObject.put('success',false);
            resultObject.put('error',ex.getMessage());
        }
        return resultObject;
    } 

    public static String getCurrentDateFormatted(){
        return String.valueOf(Date.today().day()) + '/' + String.valueOf(Date.today().month()) + '/' + String.valueOf(Date.today().year());
    }

    public static String getDocumentRelativeLink(String documentName){
        String documentURL= '';
        try{
            list<Document> doc = [Select id,Name,SystemModStamp From Document Where Name  = :documentName];
            ID docIds = doc[0].id;
            documentURL = URL.getSalesforceBaseUrl().getProtocol()+'://'+System.URL.getSalesforceBaseUrl().getHost().remove('-api' )+'/servlet/servlet.ImageServer?id='+docIds+'&oid='+userinfo.getorganizationid();
        }catch(Exception ex){
            System.debug(ex.getMessage());
        }
        return documentURL ;
    }

}