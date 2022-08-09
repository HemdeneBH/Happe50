/**
 * @description       : Service Manager spécifique à EmailService 
 * @author            : Vincent Albiser
 * @group             : 
 * @last modified on  : 08-18-2020
 * @last modified by  : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   07-15-2020   Sara El-Hannaoui   Initial Version
**/
public without sharing class HP_SM036_EmailService implements Messaging.InboundEmailHandler {
    
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {
    
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		for (String str : email.toAddresses){

			//email pour log des exceptions
			if (str.contains('happe_crm_technique.esa')){
				HP_TECH_LOG__c log = HP_EM031_HPLogTech.buildHPLogTechFromEmailService(email);
				Database.DMLOptions dml = new Database.DMLOptions(); 
				dml.allowFieldTruncation  = true;
				Database.insert(log, dml);
				break;
			}

		}
		result.success = true;
        return result;
    }
}