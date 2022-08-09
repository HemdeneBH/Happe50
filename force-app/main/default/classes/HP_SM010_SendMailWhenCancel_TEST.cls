/**
 * @File Name          : HP_SM0010_SendMailWhenCancelOk_TEST.cls
 * @Description        :
 * @Author             : fotso.colince@external.engie.com
 * @Group              :
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 19/06/2020 à 15:25:00
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    16/01/2020   fotso.colince@external.engie.com     Initial Version
**/

@isTest
private class HP_SM010_SendMailWhenCancel_TEST {

	private enum StaticResource {
		HP_APIHourAccessTokenResponse_MOCK,
        HP_SendEmail_Mock
	}

	@isTest
	private static void sendMailCancellationAsyncTEST(){

			User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
			Account acc =(Account) HP_UTIL_SmartFactory.createSObject('Account',new Map<String, Object>{
				'RecordtypeId' => (String) HP_UTIL_RecordType.getRecordTypeId('Account','HP_Account')
			},null);
			insert acc;
	
			Contact contct = (Contact) HP_UTIL_SmartFactory.createSObject('Contact', new Map<String, Object>{
				'Email'=>'test@email.com',
				'firstname'=>'FNTtest',
				'lastname'=>'LNTest',
				'title'=>'Mr',
				'Id_Tiers__c' => 195464,
				'AccountId'=>acc.id
			},null);
			insert contct;
			Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
				'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
					200,
					StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
					new Map<String, String> {'Content-Type' => 'application/json'}
				),
				'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
					200,
					null,
					new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
				),
				'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
					200,
					StaticResource.HP_SendEmail_Mock.name(),
					new Map<String, String> {'Content-Type' => 'application/json'}
				)
			};
			System.runAs(thisUser) {
				Test.startTest();
				RestContext.response= new RestResponse();
				Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
				HP_SM010_SendMailWhenCancellation.sendMailViaCabestanAsync(
						contct.email,
						String.valueOf(contct.Id_Tiers__c),
						contct.title,
						contct.lastname,
						contct.firstname,
						'Gaz',
						'SF21',
						'Confirmation demande résiliation',
						'indexresil',
						'true'
						);
				Test.stopTest();
	
			}
			System.assertEquals(1, [SELECT ID, email FROM contact WHERE email = 'test@email.com'].size());
	}

	@isTest
	private static void sendMailCancellationSyncTEST(){
			User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
			Account acc =(Account) HP_UTIL_SmartFactory.createSObject('Account',new Map<String, Object>{
				'RecordtypeId' => (String) HP_UTIL_RecordType.getRecordTypeId('Account','HP_Account')
			},null);
			insert acc;
	
			Contact contct = (Contact) HP_UTIL_SmartFactory.createSObject('Contact', new Map<String, Object>{
				'Email'=>'test@email.com',
				'firstname'=>'FNTtest',
				'lastname'=>'LNTest',
				'title'=>'Mr',
				'Id_Tiers__c' => 195464,
				'AccountId'=>acc.id
			},null);
			insert contct;
			Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
				'token' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
					200,
					StaticResource.HP_APIHourAccessTokenResponse_MOCK.name(),
					new Map<String, String> {'Content-Type' => 'application/json'}
				),
				'contrats' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
					200,
					null,
					new Map<String, String> {'Location' => 'http/1222', 'Content-Type' => 'application/json'}
				),
				'ES-Correspondance_v2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(
					200,
					StaticResource.HP_SendEmail_Mock.name(),
					new Map<String, String> {'Content-Type' => 'application/json'}
				)
			};
			System.runAs(thisUser) {
				Test.startTest();
				RestContext.response= new RestResponse();
				Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap)); 
				HP_SM010_SendMailWhenCancellation.sendMailViaCabestanSync(
						contct.email,
						String.valueOf(contct.Id_Tiers__c),
						contct.title,
						contct.lastname,
						contct.firstname,
						'Gaz',
						'SF21',
						'Confirmation demande résiliation',
						'indexresil',
						'true'
						);
				Test.stopTest();
	
			}
			System.assertEquals(1, [SELECT ID, email FROM contact WHERE email = 'test@email.com'].size());
	}

}