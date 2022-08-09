/**
 * @description  : 
 * @author       : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   25-11-2020   Vincent Albiser   Initial Version
**/
public with sharing class HP_HDL002_Contact {

	private static final Id HP_accountRecordTypeId = HP_UTIL_RecordType.getRecordTypeId('Account','HP_Account');
    private static final Id HP_contactTypeId = HP_UTIL_RecordType.getRecordTypeId('Contact','HP_Contact');

	public static void execute() {
		if(Trigger.isInsert && Trigger.isBefore) {
			List<Account> accountList = new List<Account>();
			List<Contact> contactList = new List<Contact>();
			Map<String, Account> accountMap = new Map<String, Account>();
			for(SObject obj : Trigger.new) {
				Contact cont = (Contact)obj;
				if(!isHappe(cont) || cont.accountId != null) {
					continue;
				}
                cont.HP_IsHappe__c = true;
				contactList.add(cont);
				Account acc = new Account(
					Name 			= cont.firstName + ' ' + cont.LastName,	
					RecordTypeId 	= HP_accountRecordTypeId,			
					HP_XDataExternalId__c = cont.Id_Tiers__c);
					
				accountList.add(acc);
				accountMap.put(cont.firstName + ' ' + cont.LastName, acc);
			}
			if(accountList.size() == 0) {
				return;
			}
			Database.upsert(accountList, Account.Field.HP_XDataExternalId__c);

			for(Contact cont : contactList) {
				cont.AccountId = accountMap.get(cont.firstName + ' ' + cont.LastName).Id;
			}
			
		}
		
		if(Trigger.isUpdate && Trigger.isBefore) {	
			for(SObject obj : Trigger.new) {
				Contact cont = (Contact)obj;
				if(!isHappe(cont)) {
					continue;
				}
				Contact contOld = (Contact)trigger.oldMap.get(cont.id);
				if(cont.HP_IsChanged__c == false && contOld.HP_IsChanged__c == true) {
					continue;
				}
				//champs visibles sur la fiche client Happe
				List<String> fieldsToCompare = new List<String> {
					'Complement_adresse__c',
					'Email', 
					'FirstName',
					'LastName', 
					'MailingCity',
					'MailingPostalCode',
					'MailingStreet', 
					'MobilePhone',					
					'No_Voie__c', 
					'Phone',
					'Salutation'
				};
				if(isChanged(obj, Trigger.oldMap.get(cont.id), fieldsToCompare)){
				cont.HP_IsChanged__c = true;
				}
			}
		}
	}

	private static Boolean isHappe(final Contact aContact) {
		return (aContact.RecordTypeId == HP_contactTypeId);
	}


	private static Boolean isChanged(SObject newObj, SObject oldObj, List<String> fields){
		Boolean changes = false;
		for(String field : fields){
			if(newObj.get(field) != oldObj.get(field)){
				changes = true;
				break;
			}
		}
		System.debug('Contact Handler ' + newObj.get('Id') + ' isChanged ' + changes);
		return changes;
	}

}