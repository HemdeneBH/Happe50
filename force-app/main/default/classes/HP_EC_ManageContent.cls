/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-10-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class HP_EC_ManageContent {
    
    @AuraEnabled(cacheable=true)
    public static List<ConnectApi.ManagedContentVersion> getContentList(Integer page,Integer pageSize,String language,String filterby) {
        System.debug('HP_EC_ManageContente.getContentList | Methode Start');
        List<ConnectApi.ManagedContentVersion> contentManagement = new List<ConnectApi.ManagedContentVersion>();
        try {
            String networkId = [select id, name from Network where name = 'HP Client portal' LIMIT 1].id;
            ConnectApi.ManagedContentVersionCollection contentCollection  = ConnectApi.ManagedContent.getAllManagedContent(networkId,page, pageSize,language,filterby);
            contentManagement = contentCollection.items;
        } catch (Exception e) {
            System.debug('Error Message : ' + e);
        }
        System.debug('HP_EC_ManageContente.getContentList | Methode Exit');     
        return contentManagement;
    }
}