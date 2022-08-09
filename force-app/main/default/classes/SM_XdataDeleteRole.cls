@RestResource(urlMapping='/delrole/*')

global with sharing class SM_XdataDeleteRole {

	static final Schema.SObjectField acExtNo = Account.Fields.No_Compte_contrat__c;
	static final Schema.SObjectField ctExtNo = Contact.Fields.Identifiant_Buisness_Partener__c;
	static final Schema.SObjectField rolExtNo = AccountContactRelation.Fields.rolekey__c;

    static SM_AP45_XdataImportUtils xiu = new SM_AP45_XdataImportUtils('xdataDel', 'AccountContactRelation');

	@HttpPost
	global static string deleteRoles(List<Map<String,String>> roles) {
		// TODO: lire le numéro de version de l'url – adapter le traitement à la version de code, la table de correspondance

		// la liste des rolekeys  
		List<String> allKeysNos = new List<String>();

		// les ACR a detruire, ceux qui doivent d'abord ne plus etre direct et les accounts techniques a creer
		List<AccountContactRelation> todeleteACRs = new List<AccountContactRelation>(); 
		Map<String,AccountContactRelation> directACRs = new Map<String,AccountContactRelation>(); 
		Map<String,Account> newAccs = new Map<String,Account>();

		List<String> directCtNos = new List<String>();


		// 1- Lire les identifiants d'account et contact recu
		for(Map<String,String> rl : roles){
			// reconstituer la unique id du role: rolekey
			String noac = rl.get('accountNo');
			String noct = rl.get('contactNo');
			// Erreur si on n'a pas d'id account ou contact ou pas de role
			if(noac == null || noac == '' || noct == null || noct == ''){
				xiu.logImportError('Pas accountno ou contactno',null, JSON.serialize(rl));
				continue;
			}
			String rolek = 'C_' + noac + '_B_' + noct;
			allKeysNos.add(rolek);
		}
		if(allKeysNos.size()==0) return endDel();

		// 2 - verifier que les ACR existent, et separer ceux qui sont directs et ceux non directs
		/*
		Un AccountContactRelation est direct si il fait le meme lien que: contact.accountid 
		Pour un AccountContactRelation non direct, on delete le ACR et ca suffit
		Pour un ACR direct,  il faut d'abord modifier le contact pour changer le ACR direct
		avec un lien direct vers un autre account existant ou s'il n'y en a pas un account technique
		*/


		AccountContactRelation[] rs = [select Id,AccountId,ContactId,IsDirect,rolekey__c from AccountContactRelation where rolekey__c in :allKeysNos ];
		if(allKeysNos.size()!=rs.size()) xiu.logImportError('ACRs inconnus dans la liste:',null, String.join(allKeysNos,','));
		if((rs.size())==0) return endDel();

		for(AccountContactRelation ri : rs){
			if(ri.IsDirect == true){
				directACRs.put(ri.rolekey__c, ri);
				directCtNos.add(ri.contactid);
			}
			todeleteACRs.add(ri);
            xiu.logImportOk(ri.rolekey__c);
		}

		// record type des accounts smile, pour creer des accounts techniques
		Id acRectid = SM_AP45_XdataImportUtils.getRecTypeId(Account.sObjectType, 'Consumer');

		// 3 - recuperer les contacts et les ACR associés pour les ACR directs
		Contact[] ctToUpdt = new List<Contact>();
		Contact[] ctToNewAcTech = new List<Contact>();
		Account[] accTechs = new List<Account>();
		Contact[] cts = [select id, accountid,Identifiant_Buisness_Partener__c, (select id, rolekey__c, accountid, IsDirect from accountcontactrelations) from Contact where id in :directCtNos];
		for(Contact cti : cts){
			ctToUpdt.add(cti);
			// on cherche un ACR qui ne va pas etre detruit
			boolean foundSubstitute = false;
			for(AccountContactRelation acri: cti.accountcontactrelations){
				if(allKeysNos.contains(acri.rolekey__c )){
					continue;
				}
				foundSubstitute = true;
				cti.accountid = acri.accountid;
			}
			if(foundSubstitute == false){
				// si le contact pointe aucun autre account, 
				// - creer un account technique
				// - pointer dessus, il se cree un nouveau ACR
				Account anewac = new Account(Name='AC_TECHNIQUE', recordtypeid=acRectid);
				accTechs.add(anewac);
				ctToNewAcTech.add(cti);
			}
		}
		insert accTechs;
        integer nloop = ctToNewAcTech.size();
		for(integer ni =0;ni<nloop;ni++){
            Contact ctloop = ctToNewAcTech.get(ni);
			ctloop.accountid = accTechs.get(ni).id;
		}

		update ctToUpdt;

		delete todeleteACRs;
        return endDel();
		}
	

	global static String endDel(){
			xiu.saveLogs();
			return 'ok';
	}

}