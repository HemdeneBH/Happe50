@isTest
private class MP_AP03_MailHelperTest {
    @isTest
    private static void getOrgWideEmailIsOk() {
        Id owe = MP_AP03_MailHelper.getOrgWideEmail();
        System.assert(owe != null);
    }
}