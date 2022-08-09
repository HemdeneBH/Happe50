@isTest
public class HP_SM052_PlanificationOPS_TEST {
    @isTest
    public static void lireOPSElecTest() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_lireOPSElec',
                new Map<String, String> ()
            )
                };
                    
                    Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM052_PlanificationOPS.lireOPS('xx', 'elec');
        Test.stopTest(); 
    }
    
    @isTest
    public static void modifierOPSElecTest() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PrestationServiceElec_v3' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ModiferOPSElec',
                new Map<String, String> ()
            )
                };
                    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM052_PlanificationOPS.modifierOPS('xx', 'elec', 'elec', 'elec', 'elec', '2021-01-01', 'elec', 'elec', 'elec', 'elec');
        Test.stopTest(); 
    }
    
    @isTest
    public static void lireOPSGazTest() {
          SM_OCTOPUS__c CS_Setting = new SM_OCTOPUS__c();
        CS_Setting.appName__c = 'Smile';
        CS_Setting.certName__c = 'smile_noprod';
        CS_Setting.endpoint__c = 'https://octopus-rec-api.clip-noprod.engie.com:56130/ws/';        
        insert CS_Setting;
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PrestationServiceGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_lireOPSGaz',
                new Map<String, String> ()
            )
                };
                    
                    Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM052_PlanificationOPS.lireOPS('xx', 'gaz');
        Test.stopTest(); 
    }
    
    @isTest
    public static void modifierOPSGazTest() {
        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-PrestationServiceGaz_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_ModifierOPSGaz',
                new Map<String, String> ()
            )
                };
                    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM052_PlanificationOPS.modifierOPS('xx', 'gaz', 'gaz', 'gaz', 'gaz', '2021-01-01', 'gaz', 'gaz', 'gaz', 'ACCEPTER');
        Test.stopTest(); 
    }
  
     @isTest
    public static void sendNotificationTest() {
         Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
            'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
                200,
                'HP_NotificationOPS',
                new Map<String, String> ()
            )
                };
                Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', null, new Map<String, Object> {
				'LastName' => 'Contact Test',
				'Email' => 'test@gmail.com',
                    'mobilePhone' => '0121212',
				'Id_Tiers__c' => 1313
			}, null, null,null);
			insert contact;    
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
        HP_SM052_PlanificationOPS.sendNotification(contact.Id, 'xx', 'xx', 'xx', 'x', true, true);
        Test.stopTest();
    }
}