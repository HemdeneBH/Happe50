public with sharing class VI_CookieConsentService {
    /*
*@Author: Amal Chreiteh
*@Description: Classe pour recupere les cookies et les categories et les afficher dans le composant ViewCookies
*@CreatedDate: 16/03/2021
*@LastModified: 16/03/2021
*/
    @AuraEnabled(Cacheable=true)
    public static List<Map<String, Object>> getCookieData() {
        List<cookiecon__CookieConsentCategory__c> cookieConsentCategories = [ SELECT cookiecon__DefaultValue__c, cookiecon__Description__c, cookiecon__Manditory__c, cookiecon__AdditionalInformation__c, Id, Name
                                                                             FROM cookiecon__CookieConsentCategory__c	
                                                                             ORDER BY Name];
        map<String, List<cookiecon__Cookie__c>> availableCookies = getRelatedCookies();
        List<Map<String, Object>> finalCookieData = new List<Map<String, Object>>();
        for (cookiecon__CookieConsentCategory__c cookieConsentCategory : cookieConsentCategories) {
            //List<cookiecon__Cookie__c> relatedCookies = getRelatedCookies(cookieConsentCategory.Id);
            Map<String, Object> sectionItem = new Map<String, Object>();
            sectionItem.put('SectionName', cookieConsentCategory.Name);
            sectionItem.put('SectionDescription', cookieConsentCategory.cookiecon__Description__c);
            sectionItem.put('RelatedAuthorizationFormId', cookieConsentCategory.Id);
            sectionItem.put('Mandatory', cookieConsentCategory.cookiecon__Manditory__c);
            sectionItem.put('DefaultValue', cookieConsentCategory.cookiecon__DefaultValue__c);
            sectionItem.put('AdditionalInformation', cookieConsentCategory.cookiecon__AdditionalInformation__c);
            sectionItem.put('SectionCookies', availableCookies.get(cookieConsentCategory.Id));
            if (finalCookieData.isEmpty()) {
                sectionItem.put('ShowSection', true);
                sectionItem.put('SectionIcon', 'utility:chevrondown');
            } else {
                sectionItem.put('ShowSection', false);
                sectionItem.put('SectionIcon', 'utility:chevronright');
            }
            finalCookieData.add(sectionItem);
        }
        return finalCookieData;
    }
    
    public static map<String, List<cookiecon__Cookie__c>> getRelatedCookies() {
        map<String, List<cookiecon__Cookie__c>> cookiesMapPerCat = new map<String, List<cookiecon__Cookie__c>>();
        List<cookiecon__Cookie__c> relatedCookies = [SELECT cookiecon__Description__c, Id, Name, cookiecon__CookieConsentCategory__c 
                                                     FROM cookiecon__Cookie__c ];
        for(cookiecon__Cookie__c cookie :relatedCookies){
            if(!cookiesMapPerCat.containsKey(cookie.cookiecon__CookieConsentCategory__c)){
                cookiesMapPerCat.put(cookie.cookiecon__CookieConsentCategory__c, new List<cookiecon__Cookie__c>());
            }
            List<cookiecon__Cookie__c> cookiesRelated = cookiesMapPerCat.get(cookie.cookiecon__CookieConsentCategory__c);
            cookiesRelated.add(cookie);
            cookiesMapPerCat.put(cookie.cookiecon__CookieConsentCategory__c,cookiesRelated);
            
        }
        return cookiesMapPerCat;
    }
    
    
}