/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 06-10-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
public with sharing class HP_SM076_ShareGroopController {

    public static final String SHAREGROOP = 'EC_Sharegroop';

    public static String createOrderPaiementAPlusieurs(String echeance_reference, String montant_restant_du, String email, String prenom, String nom) {
        System.debug('HP_SM076_ShareGroopController.createOrderPaiementAPlusieurs() | Methode Start');

        HP_EC_Sharegroop_Setting__mdt sahregroopSetting = [ SELECT DeveloperName, ux__c, locale__c, currency__c, secure3D__c, notifyUrl__c, name__c, quantity__c
                                                            FROM HP_EC_Sharegroop_Setting__mdt WHERE DeveloperName = :SHAREGROOP LIMIT 1];

        String body = buildBody(sahregroopSetting,echeance_reference,montant_restant_du,email,prenom,nom);

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.sandbox.sharegroop.com/v1/orders');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Authorization', 'sk_test_dd84dad5-d73c-48aa-bbee-eb1dab5a8499');
        req.setBody(body);
        HttpResponse response = http.send(req);

        System.debug('HP_SM076_ShareGroopController.createOrderPaiementAPlusieurs() status code : ' + response.getStatusCode());
        System.debug('@@Response : '+response);
        System.debug('@@Response Body : '+response.getBody());

        System.debug('HP_SM076_ShareGroopController.createOrderPaiementAPlusieurs() | Methode Exit');
        return response.getBody();
    }

    public static String buildBody(HP_EC_Sharegroop_Setting__mdt sahregroopSetting, String echeance_reference, String montant_restant_du, String email, String prenom, String nom) {
        
        Integer montant     = (Decimal.valueOf(montant_restant_du) * 100).intValue();
        String UX           = sahregroopSetting.ux__c;
        String LOCALE       = sahregroopSetting.locale__c;
        String CURRENCYY    = sahregroopSetting.currency__c;
        String SECURE3D     = String.valueOf(sahregroopSetting.secure3D__c);
        String NOTIFY_URL   = sahregroopSetting.notifyUrl__c + echeance_reference;
        String NAME         = sahregroopSetting.name__c;
        String QUANTITY     = String.valueOf(sahregroopSetting.quantity__c);

        String result =
                '{'+
                    '"amount": "'+montant+'",'+
                    '"ux": "'+UX+'",'+
                    '"locale": "'+LOCALE+'",'+
                    '"currency": "'+CURRENCYY+'",'+
                    '"secure3D": '+SECURE3D+','+
                    '"email": "'+email+'",'+
                    '"firstName": "'+prenom+'",'+
                    '"lastName": "'+nom+'",'+
                    '"trackId": "'+echeance_reference+'",'+
                    '"notifyUrl": "'+NOTIFY_URL+'",'+
                    '"items": ['+
                    '        {'+
                    '        "trackId": "'+echeance_reference+'",'+
                    '        "name": "'+NAME+'",'+
                    '        "description": "Echeance REF: '+echeance_reference+'",'+
                    '        "amount": "'+montant+'",'+
                    '        "quantity": '+QUANTITY+''+
                    '        }'+
                    '    ]'+
                    '}';

        System.debug('@@buildBody result : '+result);
        return result;
    }
    
}