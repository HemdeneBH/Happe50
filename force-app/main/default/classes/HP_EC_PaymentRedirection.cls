/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-24-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EC_PaymentRedirection {

    public PageReference urlRedirection() {
        final String urlPrefix = HP_UTIL_MetadataManager.getConfigByKey('HP_EC_PREFIX');
        Site site = [SELECT Id FROM Site WHERE UrlPathPrefix = :urlPrefix LIMIT 1];
        String communityUrl = [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;

        string url = communityUrl + HP_UTIL_MetadataManager.getConfigByKey('HP_PAGE_FACTURES');

        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
  }

}