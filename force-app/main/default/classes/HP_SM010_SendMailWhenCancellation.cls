/**
 * @File Name          : HP_SM010_SendMailWhenCancellation.cls
 * @Description        : Envoi d'un courriel pour notifier que la résiliation est faite sur la base d'index estimés
 * @Author             : fotso.colince@external.engie.com
 * @Group              :
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 18/06/2020 à 14:37:33
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    16/01/2020   fotso.colince@external.engie.com     Initial Version
**/

public class HP_SM010_SendMailWhenCancellation {

	public static final String EMAIL = 'EMAIL';
	public static final String ID_CLIENT = 'idclient';
	public static final String NAME = 'NOM';
	public static final String SURNAME = 'PRENOM';
	public static final String CIVILITEHAPPE = 'CIVILITEHAPPE';
	public static final String ENERGYTYPE = 'energytype';

	/**
	* @description: Envoi des mails de resiliation en mode asynchrone via Octopus
	* @author Colince FOTSO | 17/01/2020
	* @param String emailContact
	* @param String idClient
	* @param String title
	* @param String nameContact
	* @param String firstNameContact
	* @param String energy
	* @param String sf
	* @param String idForm
	* @param String indexResilKey
	* @param String indexResilValue
	* @return void
	**/

	@future(Callout=true)
	public static void sendMailViaCabestanAsync(String emailContact, String idClient, String title, String nameContact, String firstNameContact, String energy,String sf, String idForm, String indexResilKey, String indexResilValue ){
		Map<String, String> mailParametres = new Map<String, String>();
		mailParametres.put('idFormulaireCode', sf);
		mailParametres.put('idFormulaireLibCourt', idForm);
		mailParametres.put('canalCommunicationLibCourt', 'Email');
		mailParametres.put('canalCommunicationCode', 'EMAIL');
		mailParametres.put('email', emailContact);
		mailParametres.put('idClient',idClient);
		mailParametres.put('NOM', nameContact);
		mailParametres.put('PRENOM', firstNameContact);
		mailParametres.put('CIVILITEHAPPE', title);
		mailParametres.put('energie', energy);
		if(indexResilKey != null){
			mailParametres.put(indexResilKey, indexResilValue);
		}
   
		HP_UTIL_MailSmsEnvoi.envoiAsync(mailParametres);  
		if (!Test.isRunningTest()) HP_EM019_EmailMessage.createEmailMessage(emailContact, Integer.valueOf(idClient),sf,null);
	}

	public static void sendMailViaCabestanSync(String emailContact, String idClient, String title, String nameContact, String firstNameContact, String energy,String sf, String idForm, String indexResilKey, String indexResilValue ){
		Map<String, String> mailParametres = new Map<String, String>();
		mailParametres.put('idFormulaireCode', sf);
		mailParametres.put('idFormulaireLibCourt', idForm);
		mailParametres.put('canalCommunicationLibCourt', 'Email');
		mailParametres.put('canalCommunicationCode', 'EMAIL');
		mailParametres.put('email', emailContact);
		mailParametres.put('idClient',idClient);
		mailParametres.put('NOM', nameContact);
		mailParametres.put('PRENOM', firstNameContact);
		mailParametres.put('CIVILITEHAPPE', title);
		mailParametres.put('energie', energy);
   
		HP_UTIL_MailSmsEnvoi.envoiSync(mailParametres); 
        System.debug(emailContact);
        System.debug(idClient);
		if (!Test.isRunningTest()) HP_EM019_EmailMessage.createEmailMessage(emailContact, Integer.valueOf(idClient),sf,null);
	}
}