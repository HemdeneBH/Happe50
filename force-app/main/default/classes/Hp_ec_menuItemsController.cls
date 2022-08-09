/**
 * controller for fetching NavigationMenuItems.
 */
global with sharing class Hp_ec_menuItemsController {
    public Hp_ec_menuItemsController() {}

    /**
     * Perform two SOQL queries to determine all the children NavigationMenuItems
     * belonging to the provided menuName and publishedState. This example uses the
     * NavigationLinkSet.MasterLabel for the menuName. One could also use the
     * NavigationLinkSet.Id to ensure referential integrity if the MasterLabel changes.
     * 
     * NavigationLinkSet contains both Draft and Live versions of the NavigationMenuItems.
     * Use the publishedState enumeration to filter between them.
     * 
     * Cacheable = true allows this function to be wired.
     */
    @AuraEnabled(cacheable=true)
    public static List<NavigationMenuItem> getNavigationMenuItems(String menuName, String publishedState) {
        System.assert(menuName != null);
        System.assert(publishedState != null);
        
        Id currentUserId = UserInfo.getUserId();
        System.debug('User ID : ' + currentUserId);
        // TODO : Name to variabilise
        String networkId = [SELECT networkId FROM NetworkMember WHERE memberId = :currentUserId AND networkId IN (SELECT id FROM Network WHERE name = 'HP Client Portal') LIMIT 1][0].NetworkId;//Network.getNetworkId();
        System.debug('NetworkId : ' + networkId);
        System.assert(networkId != null);

        // find the link set belonging to the navigation menuName and active networkId
        List<NavigationLinkSet> linkSets = [
            SELECT Id 
            FROM NavigationLinkSet
            WHERE MasterLabel = :menuName AND NetworkId = :networkId
        ];

        System.assert(linkSets.size() == 1);
        Id linkSetId = linkSets.get(0).Id;

        // collect all the menu items belonging to the link set
        // published state is either Draft or Live
        return [SELECT toLabel(Label), Target, Type, DefaultListViewId, AccessRestriction,
                ParentId,
                Position,
                Status,
                TargetPrefs
            FROM NavigationMenuItem
            WHERE NavigationLinkSetId = :linkSetId
            AND Status = :publishedState 
            ORDER BY Position
        ];
    }
}