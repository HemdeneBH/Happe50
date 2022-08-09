/**
 * @File Name          : HP_SM018_CaseEmail_TEST.cls
 * @Description        :
 * @Author             : Colince FOTSO
 * @Group              :
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 12-29-2021
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    30/01/2020   Colince FOTSO     Initial Version
**/
@isTest
public class HP_SM018_CaseEmail_TEST {

	@testSetup static void dataSetup(){
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){      
        }
    }

	@isTest
	private static void handleInboundEmailTest(){
		System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
			Messaging.inboundEmail email = new Messaging.InboundEmail();
			email.toAddresses = new List<String>{'req.emailAddress@email.cm'};
			email.plainTextBody ='req.message';
			email.fromAddress = 'req.emailAddress@email.cm';
			email.fromName= 'req.civility'+' '+'req.firstName'+' '+'req.lastName';
			email.subject = 'req.reason';
			email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>();
			Messaging.InboundEmail.BinaryAttachment  binAttacht = new Messaging.InboundEmail.BinaryAttachment();
			binAttacht.fileName = 'attachmt.filename';
			binAttacht.body = Blob.valueOf('attachmt.body');
	
			Messaging.InboundEmailResult result = (new HP_SM018_CaseEmail()).handleInboundEmail(email,null);
			// System.assertEquals(true, result.success);
		}
	}
}