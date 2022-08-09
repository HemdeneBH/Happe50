/**
 * @author Sutharsan Pushparajah
 * @date 19/04/2022
 * @description Test class for SM_EM103_User
 */
@isTest
private class SM_EM103_User_TEST {

    /**
     * @author Sutharsan Pushparajah
     * @date 19/04/2022
     * @description Testing creation of user and query it
     */
    @isTest
    private static void testGetByIds(){

        Profile profile = [SELECT Id FROM Profile where Name = 'Standard User' LIMIT 1];

        User user = new User(LastName = 'Test',
                            FirstName='Test',
                            Alias = 'tt',
                            Email = 'test@'+UserInfo.getOrganizationId()+'.com',
                            Username = 'test@'+UserInfo.getOrganizationId()+'.com',
                            ProfileId = profile.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                            );
    
        insert user;

        Test.startTest();

        List<User> users = SM_EM103_User.getByIds('Id, LastName, FirstName, Alias, Email, Username, ProfileId, TimeZoneSidKey, LanguageLocaleKey, EmailEncodingKey, LocaleSidKey', new List<Id>{user.Id});
        System.assertNotEquals(null, users);
        System.assertEquals(1, users.size());

        User testUser = users.get(0);

        System.assertEquals('Test', testUser.LastName);
        System.assertEquals('Test', testUser.FirstName);
        System.assertEquals('tt', testUser.Alias);
        System.assertEquals('test@'+UserInfo.getOrganizationId().toLowerCase()+'.com', testUser.Email);
        System.assertEquals('test@'+UserInfo.getOrganizationId().toLowerCase()+'.com', testUser.Username);
        System.assertEquals(profile.Id, testUser.ProfileId);
        System.assertEquals('GMT', testUser.TimeZoneSidKey);
        System.assertEquals('en_US', testUser.LanguageLocaleKey);
        System.assertEquals('UTF-8', testUser.EmailEncodingKey);
        System.assertEquals('en_US', testUser.LocaleSidKey);

        Test.stopTest();
    }
    
}