/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-10-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class HP_EC_ManageContentTest {
    @IsTest(seeAllData = true)
    static void getContentListTest(){
        Test.startTest();
        List<ConnectApi.ManagedContentVersion> contentCollection = HP_EC_ManageContent.getContentList(0,9,'fr','cms_image');
        System.debug('test return in getcontent list '+contentCollection);
        Test.stopTest();
        // System.assert(contentCollection.isEmpty() ,false);
    }
    @IsTest(seeAllData = true)
    static void getContentListTestKo(){
        Test.startTest();
        List<ConnectApi.ManagedContentVersion> contentCollection = HP_EC_ManageContent.getContentList(0,9,'','');
        System.debug('test return in getcontent list '+contentCollection);
        Test.stopTest();
        System.assertEquals(contentCollection.isEmpty() ,true);
    }
}