@isTest
public inherited sharing class COE_UTIL_TestDataFactory_TEST {
    public static User testUser = COE_UTIL_TestDataFactory.newUser('testUser', 'SM_SystemAdmin');

    @isTest public static void newOS() {
        System.runAs(testUser) {
            vlocity_cmt__OmniScript__c testRecord1 = COE_UTIL_TestDataFactory.newOs('osType1',  'osSubtype', '{}');
            System.assertEquals('osType1', testRecord1.vlocity_cmt__Type__c);

            vlocity_cmt__OmniScript__c testRecord2 = COE_UTIL_TestDataFactory.newOs('osType2',  'osSubtype', 1, '{}', false, false);
            System.assertEquals('osType2', testRecord2.vlocity_cmt__Type__c);
        }
    }

    @isTest public static void newOsElement() {

        System.runAs(testUser) {
            vlocity_cmt__Element__c testRecord = COE_UTIL_TestDataFactory.newOsElement('name',  'elType', 1, '{}', null);
            System.assertEquals('name', testRecord.Name);
        }

    }

    @isTest public static void newLayout() {

        System.runAs(testUser) {
            vlocity_cmt__VlocityUILayout__c testRecord = COE_UTIL_TestDataFactory.newLayout('name', '{}', false);
            System.assertEquals('name', testRecord.Name);
        }
    }

    @isTest public static void newCard() {

        System.runAs(testUser) {
            vlocity_cmt__VlocityCard__c testRecord = COE_UTIL_TestDataFactory.newCard('name', '{}', false);
            System.assertEquals('name', testRecord.Name);
        }

    }
    @isTest public static void newReportOs() {
 
        System.runAs(testUser) {
            ReportOmniScript__c testRecord = COE_UTIL_TestDataFactory.newReportOs('name');
            System.assertEquals('name', testRecord.Name);
        }
 
    }

    @isTest public static void newReportOsElement() {

        System.runAs(testUser) {
            ReportOSElement__c testRecord = COE_UTIL_TestDataFactory.newReportOsElement('name', null);
            System.assertEquals('name', testRecord.Name);
        }
    }
}