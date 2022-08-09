/**
 * @File Name          : HP_BAT007_NotifyAgilabContact_TEST.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-02-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@IsTest
public with sharing class HP_BAT007_NotifyAgilabContact_TEST {

    @IsTest
    public static void batchTest() {
        Contact cont = new Contact(LastName='test', firstName = 'test', Id_Tiers__c = 1235, HP_IsChanged__c = true);
        insert cont;
        HP_Souscription__c enrolment = (HP_Souscription__c) HP_UTIL_SmartFactory.createSObject('HP_Souscription__c', new Map<String, Object> {
            'HP_Souscription_Digital_Id__c'  => '123456',
            'HP_Date_de_Contractualisation__c' => System.today().addDays(1),
            'HP_Statut__c' =>'SAVE_3',
            'HP_Contact__c'=> cont.Id
        }, null);
        insert enrolment;
        cont.lastName= 'test1';
        update cont;

        Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
			'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												   'HP_APIHourAccessTokenResponse_MOCK',
												   new Map<String, String> {'Content-Type' => 'application/json'}),

			'/personnes/notify_xdata_update' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
												  null,
												  new Map<String, String> { 'Content-Type' => 'application/json'})
        };
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
        	HP_BAT007_NotifyAgilabContact.execute();
            Integer callouts =Limits.getAsyncCalls();
        Test.stopTest();
        System.System.assertEquals(1, callouts, 'A callout should be made');
    }
}