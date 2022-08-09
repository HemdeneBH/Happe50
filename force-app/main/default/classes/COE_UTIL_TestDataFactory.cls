/** 

 * @description       : Test Data Factory for SFI configuration objects
 * @author            : Patrick THAI
 * @group             : 
 * @last modified on  : 12-08-2020
 * @last modified by  : Patrick THAI
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   10-02-2020   Patrick THAIb    Initial Version (User, OS, Element)
**/

public class COE_UTIL_TestDataFactory {
    
    public static String CRON_EXP = '0 0 0 3 9 ? 2100';

    public static User newUser(String alias, String profileName){
        Profile profile = [SELECT Id 
                           FROM Profile 
                           WHERE Name = :profileName]; 
        User user = new User();
        user.Alias = alias;
        user.Email = alias + '@email.provider.com'; 
        user.EmailEncodingKey = 'UTF-8';
        user.LastName = alias; 
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US'; 
        user.ProfileId = profile.Id;
        user.TimeZoneSidKey = 'America/Los_Angeles'; 
        user.UserName = alias + '@email.provider.com'; 
        return user;
    }

    public static vlocity_cmt__OmniScript__c newOS(String osType, String osSubtype, String propSet){
        return new vlocity_cmt__OmniScript__c(
            Name = osType + ' ' + osSubtype,
        	vlocity_cmt__Type__c = osType,
        	vlocity_cmt__SubType__c = osSubtype,
            vlocity_cmt__PropertySet__c = propSet
        );
    }
 
    public static vlocity_cmt__OmniScript__c newOS(String osType, String osSubtype, Integer Version, String propSet, Boolean isProcedure, Boolean isActive){
        return new vlocity_cmt__OmniScript__c(
            Name = osType + ' ' + osSubtype,
        	vlocity_cmt__Type__c = osType,
        	vlocity_cmt__SubType__c = osSubtype,
            vlocity_cmt__PropertySet__c = propSet,
        	vlocity_cmt__Version__c = version,
            vlocity_cmt__IsProcedure__c = isProcedure,
            vlocity_cmt__IsActive__c = isActive
        );
    }

    public static  vlocity_cmt__Element__c newOsElement(String name, String elType, Integer OrderNum, String propSet, Id parentOsId){
        return new vlocity_cmt__Element__c(
            Name = name,
        	vlocity_cmt__Type__c = elType,
            vlocity_cmt__Order__c = OrderNum,
            vlocity_cmt__PropertySet__c = propSet,
            vlocity_cmt__OmniScriptId__c = parentOsId
        );
    }

    public static vlocity_cmt__VlocityUILayout__c newLayout(String name, String propSet,  Boolean isActive){
        return new vlocity_cmt__VlocityUILayout__c(
            Name = name,
            vlocity_cmt__Type__c = 'Layout',
            vlocity_cmt__Definition__c = propSet,
            vlocity_cmt__Active__c = isActive
        );
    }

    public static vlocity_cmt__VlocityCard__c newCard(String name, String propSet,  Boolean isActive){
        return new vlocity_cmt__VlocityCard__c(
            Name = name,
            vlocity_cmt__Definition__c = propSet,
            vlocity_cmt__Active__c = isActive
        );
    }

    public static  ReportOmniScript__c newReportOs(String name){
        return new ReportOmniScript__c(
            Name = name
        );
    }

    public static  ReportOSElement__c newReportOsElement(String name, Id parentReportOsId){
        return new ReportOSElement__c(
            Name = name,
            ReportOmniScript__c = parentReportOsId
        );
    }
}