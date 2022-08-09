@isTest
public with sharing class SM_AP67_SmileHeader_Test {
    @TestSetup
    private static void initData(){

        List<Account> accList;
        List<Contact> conList;
        Id accountConsumerRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Id contactSmileRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Smile').getRecordTypeId();
        Account acc = new Account(Name = 'AcctestSmileHeader', recordTypeId = accountConsumerRTId, ID_Local__c = 12345);
        Account accWithoutIdLocal = new Account(Name = 'AcctestSmileHeader2', recordTypeId = accountConsumerRTId);
        accList = new List<Account> {acc, accWithoutIdLocal};
        insert accList;
        Contact con = new Contact(LastName = 'ContestSmileHeader', recordTypeId = contactSmileRTId, SM_isArchive__c = true, Identifiant_Buisness_Partener__c = 'testSmileHeader', AccountId = acc.Id);
        Contact conWithAcc = new Contact(LastName = 'ContestSmileHeader2', recordTypeId = contactSmileRTId, Identifiant_Buisness_Partener__c = 'testSmileHeader2', AccountId = accWithoutIdLocal.Id); 
        conList = new List<Contact> {con, conWithAcc};
        insert conList;

    }

    @isTest
    public static void invokeMethodTest(){
        Contact contactInst = [Select id from contact where Identifiant_Buisness_Partener__c = 'testSmileHeader2'].get(0);
        SM_AP67_SmileHeader smileHeaderCon = new SM_AP67_SmileHeader();
        Map<String, Object> output = new Map<String, Object>();
        Test.startTest();

        Boolean resultTrue = smileHeaderCon.invokeMethod('callSmileHeader', new Map<String, Object> { 'Id' => contactInst.Id}, output, null);
        Boolean resultFalse = smileHeaderCon.invokeMethod('', new Map<String, Object> { 'Id' => contactInst.Id}, output, null);
 
        Test.stopTest();

        System.assert(resultTrue);
        System.assert(!resultFalse);


    }
    @isTest
    public static void callSmileHeaderTest(){
        Contact contactInst = [Select id from contact where Identifiant_Buisness_Partener__c = 'testSmileHeader'].get(0);

        SM_AP67_SmileHeader smileHeaderCon = new SM_AP67_SmileHeader();
        Map<String, Object> output = new Map<String, Object>();
        Test.startTest();

        smileHeaderCon.callSmileHeader(new Map<String, Object> {'Id' => contactInst.Id}, output, null);

        Test.stopTest();

        system.assert(output.get('Result') != null);

    }
    
    @isTest
    public static void callSmileHeaderLightningTest(){
        Contact contactInst = [Select id from contact where Identifiant_Buisness_Partener__c = 'testSmileHeader'].get(0);
        Map<String, Object> output = new Map<String, Object>();
        Test.startTest();

        output = SM_AP67_SmileHeader.callSmileHeaderLigthning(new Map<String, Object> {'Id' => contactInst.Id});

        Test.stopTest();

        system.assert(output.get('Result') != null);
		system.assert(output.get('IsArchiveCNIL') != null);

    }

}