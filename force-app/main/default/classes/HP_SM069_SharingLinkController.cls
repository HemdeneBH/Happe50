/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 09-21-2021
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_SM069_SharingLinkController {
    public static final String LOCALE = 'fr';
    public static final String CAMPAIGN_SLUG = 'happe_raf1';
    public static final String MARKET_DOMAIN = 'bp.happ-e.fr';

    public static void setSharingLink(Contact cont){
        System.debug('HP_SM069_SharingLinkController.getSharingLink | Methode Start');
        String body = buildBody(cont);
        try{
            HttpResponse response = HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.HP_BUYAPOWA_API, body);
            System.debug('HP_SM069_SharingLinkController.getSharingLink status code : ' + response.getStatusCode());
            if(response.getStatusCode() == 202){
                cont.HP_Shared_URL__c = getLinkFromResponse(response.getBody());
            }
            System.debug('Link : '+ getLinkFromResponse(response.getBody()));
        }catch (Exception ex){
            System.debug('HP_SM069_SharingLinkController.getSharingLink() | Exception : ' + ex.getMessage());
        }
        System.debug('HP_SM069_SharingLinkController.getSharingLink | Methode Exit');
    }

    private static String getLinkFromResponse(String responseJSON){
        String link ='';
        try {
            Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseJSON);
            link = (String)responseMap.get('share_url');
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return link;
    }

    public static String buildBody(Contact cont){
        String result ='{"campaign_slug" : "'+CAMPAIGN_SLUG+'",'+
            '"send_auto_invite_email": false,'+
            '"signup" : {'+
              '"email" : "'+cont.Email+'",'+
              '"first_name" : "'+cont.FirstName+'",'+
              '"last_name" : "'+cont.LastName+'",'+
              '"custom_field_value" : "",'+
              '"client_data": {'+
              '"client_id": "'+cont.Id_Tiers__c+'"},'+
              '"locale": "'+LOCALE+'"}}';
        return result;
    }
}