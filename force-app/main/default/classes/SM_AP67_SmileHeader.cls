global with sharing class SM_AP67_SmileHeader implements vlocity_cmt.VlocityOpenInterface {
	
	//private final static Map<String, String> neededFieldsMap = new Map<String, String> {'AccountId' => 'AccountId', '' => '' , 'ID_Batiment__c' =>, '' => , '' => '', '' => ''}

	global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {
		if (methodName.equals('callSmileHeader')) {

			callSmileHeader(inputMap, outputMap, options);
			return true;

		}
		return false;
	}

	global void callSmileHeader(Map<String,Object> inputMap, Map<String,Object> outputMap, Map<String,Object> options) {

		List<Object> resultList = new List<Object>();
		String IdBusinessPartner;
		Map<String, Object> resultTemp; 
		String contactId;

		if(inputMap != null && (contactId = (String)inputMap.get('Id'))!= null){

			List<AccountContactRelation> accountContactList = [Select AccountId, Account.ID_Batiment__c, Account.ID_Local__c, Account.ID_Porte_feuille_contrat__c, Account.No_Compte_contrat__c, Contact.Identifiant_Buisness_Partener__c, Account.RecordType.DeveloperName, Contact.RecordType.DeveloperName  from AccountContactRelation where ContactId=:contactId and Account.RecordType.DeveloperName = 'Consumer' and Account.ID_Local__c != NULL ];
			List<Contact> contactList = [Select Id, Identifiant_Buisness_Partener__c, Contact.RecordType.DeveloperName from Contact where Id=:contactId and Identifiant_Buisness_Partener__c != '' and RecordType.DeveloperName = 'Contact_Smile'];
			//List<Contact> contactList = [Select Id, Identifiant_Buisness_Partener__c, Contact.RecordType.DeveloperName from Contact where Id=:contactId and Identifiant_Buisness_Partener__c != ''];
			if(contactList.size() == 1){

				IdBusinessPartner = (String)contactList.get(0).Identifiant_Buisness_Partener__c;
			
			}            
			for(AccountContactRelation accConRel : accountContactList){

				resultTemp = new Map<String, Object>();
				//if(accConRel.Account.Id_Local__c != null && accConRel.Account.RecordType.Name == 'Consumer'){
				if(accConRel != null && accConRel.AccountId != null){

					addValue(resultTemp, 'AccountId', accConRel.AccountId);
					addValue(resultTemp, 'IdBatiment', accConRel.Account.ID_Batiment__c);
					addValue(resultTemp, 'IdLocal', accConRel.Account.ID_Local__c);
					addValue(resultTemp, 'IdPortefeuilleContrat', accConRel.Account.ID_Porte_feuille_contrat__c);
					addValue(resultTemp, 'NoCompteContrat', accConRel.Account.No_Compte_contrat__c);
				
				}

				addValue(resultTemp, 'IdBusinessPartner', IdBusinessPartner);
				
				if(resultTemp.size()>0){

					resultList.add(resultTemp);

				}

			}

			if(resultList.size() == 0 && String.isNotBlank(IdBusinessPartner)){

				resultList.add(new Map<String, Object> {'IdBusinessPartner' => IdBusinessPartner});

			}

		}

		if(resultList.size() > 1){

			outputMap.put('Result', resultList);

		}
		else if(resultList.size() == 1){
		
			outputMap.put('Result', resultList.get(0));

		}

	}
	
	@AuraEnabled(cacheable=false)
	public static Map < String, Object > callSmileHeaderLigthning(Map<String,Object> inputMap) {
		// System.debug('callSmileHeaderLigthning');
		Map < String, Object > outputMap  = new Map<String, Object>();
		List<Object> resultList = new List<Object>();
		String IdBusinessPartner;
		Map<String, Object> resultTemp; 
		String contactId;

		if(inputMap != null && (contactId = (String)inputMap.get('Id'))!= null){

			List<AccountContactRelation> accountContactList = [Select AccountId, Account.ID_Batiment__c, Account.ID_Local__c, Account.ID_Porte_feuille_contrat__c, Account.No_Compte_contrat__c, Contact.Identifiant_Buisness_Partener__c, Account.RecordType.DeveloperName, Contact.RecordType.DeveloperName  from AccountContactRelation where ContactId=:contactId and Account.RecordType.DeveloperName = 'Consumer' and Account.ID_Local__c != NULL ];
			List<Contact> contactList = [Select Id, Identifiant_Buisness_Partener__c, Contact.RecordType.DeveloperName from Contact where Id=:contactId and Identifiant_Buisness_Partener__c != '' and RecordType.DeveloperName = 'Contact_Smile'];
			//List<Contact> contactList = [Select Id, Identifiant_Buisness_Partener__c, Contact.RecordType.DeveloperName from Contact where Id=:contactId and Identifiant_Buisness_Partener__c != ''];
			if(contactList.size() == 1){

				IdBusinessPartner = (String)contactList.get(0).Identifiant_Buisness_Partener__c;
			
			}            
			for(AccountContactRelation accConRel : accountContactList){

				resultTemp = new Map<String, Object>();
				//if(accConRel.Account.Id_Local__c != null && accConRel.Account.RecordType.Name == 'Consumer'){
				if(accConRel != null && accConRel.AccountId != null){

					addValue(resultTemp, 'AccountId', accConRel.AccountId);
					addValue(resultTemp, 'IdBatiment', accConRel.Account.ID_Batiment__c);
					addValue(resultTemp, 'IdLocal', accConRel.Account.ID_Local__c);
					addValue(resultTemp, 'IdPortefeuilleContrat', accConRel.Account.ID_Porte_feuille_contrat__c);
					addValue(resultTemp, 'NoCompteContrat', accConRel.Account.No_Compte_contrat__c);
				
				}

				addValue(resultTemp, 'IdBusinessPartner', IdBusinessPartner);
				
				if(resultTemp.size()>0){

					resultList.add(resultTemp);

				}

			}

			if(resultList.size() == 0 && String.isNotBlank(IdBusinessPartner)){

				resultList.add(new Map<String, Object> {'IdBusinessPartner' => IdBusinessPartner});

			}

		}

		if(resultList.size() > 1){

			outputMap.put('Result', resultList);

		}
		else if(resultList.size() == 1){
		
			outputMap.put('Result', resultList.get(0));

		}
		return outputMap;
	}

	private static void addValue(Map<String, Object> resultMap, String mapKey,object value){

		if(value != null){

			resultMap.put(mapKey, value);

		}

	}
}