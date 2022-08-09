@isTest
public class MP_LWC02_Download_Test {

    @TestSetup
    static void makeData(){
        Account acc = new Account(
            Name = 'AccTest@test.com');
        insert acc;

        ContentVersion cv = new ContentVersion(
            Title = 'mypower',
            PathOnClient = 'mypower.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true);
        insert cv;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = acc.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

    }

    @isTest
    public static void testFunc() {
        List<ContentVersion> rvalue = new List<ContentVersion>();
        Account a = [SELECT Id FROM Account LIMIT 1];
        rvalue = MP_LWC02_Download.getfileIds(a.Id);
        System.assertEquals(rvalue.size(), 1);
    }
}