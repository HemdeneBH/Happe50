/*
* @Author: Riadh Dallel
* @Date: 28/06/2021
* @Description: Test Class for SM_Purecloud_RoutingDeleteInvocable
*/
@isTest
public with sharing class SM_Purecloud_RoutingDeleteInvocable_Test {

    @isTest
    public static void sM_Purecloud_RoutingDeleteInvocable_Test(){
        SM_Purecloud_RoutingDeleteInvocable.Request request = new SM_Purecloud_RoutingDeleteInvocable.Request();
        request.conversationId='test';
        Test.setMock(HttpCalloutMock.class, new SM_Purecloud_RoutingDeleteInvocable_Mock());
        Test.startTest();
        SM_Purecloud_RoutingDeleteInvocable.execute(new List<SM_Purecloud_RoutingDeleteInvocable.Request>{request});
        Test.stopTest();
        List<SyncEventLog__c> listSyncEventLog = [Select id From SyncEventLog__c limit 1];
        System.assertEquals(0, listSyncEventLog.size());
    }
}