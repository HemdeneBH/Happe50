@isTest//(SeeAllData=true)
private class Hp_ec_menuItemsController_TEST {
    public static string menuName = 'HP Client Portal Menu';
    public static string publishedState = 'Draft';

    @TestSetup
    static void setup(){

        Account ac = new Account(name = 'HP Portal Account');
        insert ac;

        Contact con = new Contact(LastName = 'Portal Account', AccountId = ac.Id);
        insert con;

    }

    @isTest
    static void testMenuController() {

        Id p = [SELECT id FROM profile where name = 'HP_Community_User'].id;
        Contact con = [SELECT id FROM Contact WHERE lastname = 'Portal Account' LIMIT 1];
        User portalUser = new User(alias = 'hpPortal', email = 'portaluser@noemail.com', EmailEncodingKey = 'UTF-8', lastname = 'Portal', 
        LanguageLocaleKey = 'en_US', LocaleSidKey ='en_US', ProfileId = p, country = 'United States', IsActive = true, contactId = con.Id, TimeZoneSidKey = 'Europe/Paris', UserName = 'portaluser@noemail.com');
        insert portalUser;
        //User portalUser = [SELECT id FROM User WHERE username = 'portaluser@noemail.com' LIMIT 1];
        system.runAs(portalUser) { 
            List<NavigationMenuItem> menuItems = Hp_ec_menuItemsController.getNavigationMenuItems(menuName, publishedState);
            System.assert(menuItems.size() > 0, 'No menu entries could be found for the client portal');
        }
   }
}