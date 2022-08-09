/**
 * @File Name          : HP_SendMailContratualizationService.cls
 * @Description        :
 * @Author             : Colince FOTSO
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 23/03/2020 à 15:10:16
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    17/01/2020   Colince FOTSO     Initial Version
 **/
public class HP_SendMailContratualizationService {
	public static final String SF12_VALUE = 'Annulation de votre demande';
	public static final String SF12 = 'SF12';
	public static final String PRINCING_PLAN_KEY = 'typecomptage';
	public static final String SF13 = 'SF13';
	public static final String SF13_VALUE = 'Confirmation transmission demande au distributeur';
	public static final String EMAIL = 'EMAIL';
	public static final String ID_CLIENT = 'idclient';
	public static final String NAME = 'NOM';
	public static final String SURNAME = 'PRENOM';
	public static final String CIVILITEHAPPE = 'CIVILITEHAPPE';
	public static final String SELLTYPECONST = 'typedemande';
	public static final String NUM_STREET = 'norue';
	public static final String STREET = 'rue';
	public static final String ADRESS_COMP = 'adressecomp1';
	public static final String ADRESS_CP = 'adresseCP';
	public static final String TOWN = 'ville';
	public static final String ENERGYCODE = 'energie';
	// public static final String MSGBODY = '<html><body><b>Message envoyé depuis Cabestan</b></body></html>';

	/**
	 * @description call WS Correspondance
	 * @author Sara El-Hannaoui | 22/01/2020
	 * @param HP_EnrolmentDetails__c enrolmentDetails
	 * @return void
	 **/
	public static EmailMessage sendMailViaCabestanSync(String code, HP_Contrat__c acontrat, HP_WRP022_SFResponse response){
		final ObjectToSend sender;
		if(code ==  SF12) {
			sender = new ObjectToSend(
				SF12_VALUE,
				acontrat.HP_Souscription__r.HP_Contact__r.Email,
				(Integer)acontrat.HP_Souscription__r.HP_Contact__r.Id_Tiers__c,
				acontrat.HP_Souscription__r.HP_Contact__r.Lastname,
				acontrat.HP_Souscription__r.HP_Contact__r.Salutation,
				acontrat.HP_Souscription__r.HP_Contact__r.Firstname,
				null,
				null,
				null,
				handlePricingPlan(acontrat),
				null,
				null,
				null,
				null
				);
		}else if (code == SF13) {
			sender = new ObjectToSend(
				SF13_VALUE,
				acontrat.HP_Souscription__r.HP_Contact__r.Email,
				(Integer)acontrat.HP_Souscription__r.HP_Contact__r.Id_Tiers__c,
				acontrat.HP_Souscription__r.HP_Contact__r.Lastname,
				acontrat.HP_Souscription__r.HP_Contact__r.Salutation,
				acontrat.HP_Souscription__r.HP_Contact__r.Firstname,
				acontrat.HP_Souscription__r.HP_type_Souscription__c == 'MOVING_IN' ? 'EM' : 'CHF',
				acontrat.HP_Souscription__r.HP_Numero_de_voie__c,
				acontrat.HP_Type_de_Compteur__c == 'GAS' ? 'Gaz' : 'Elec',
				null,
				acontrat.HP_Souscription__r.HP_Nom_de_rue__c,
				acontrat.HP_Souscription__r.HP_Complement_d_adresse__c,
				acontrat.HP_Souscription__r.HP_Code_postal__c,
				acontrat.HP_Souscription__r.HP_Nom_de_ville__c
				);
		}

		try{

									 Map<String, String> mailParametres = new Map<String, String>();
									 mailParametres.put('idFormulaireCode', code);
									 mailParametres.put('idFormulaireLibCourt', sender.idForm);
									 mailParametres.put('canalCommunicationLibCourt', 'Email');
									 mailParametres.put('canalCommunicationCode', 'EMAIL');
									 mailParametres.put('email', sender.emailContact);
									 mailParametres.put('idClient', String.valueOf(sender.idClient));
									 mailParametres.put('NOM', sender.name);
									 mailParametres.put('PRENOM', sender.firstName);
									 mailParametres.put('CIVILITEHAPPE', sender.title);
									 mailParametres.put('typedemande', sender.sellType);
									 mailParametres.put('norue', sender.numStreet);
									 mailParametres.put('energie',  sender.energy);
									 mailParametres.put('typecomptage', sender.pricingPlan);
									 mailParametres.put('rue', sender.street);
									 
									 if(!String.isBlank(sender.addressComp)) {
									 	mailParametres.put('adressecomp1', sender.addressComp);
									 }

									 mailParametres.put('adresseCP', sender.addressCp);
									 mailParametres.put('ville', sender.town);
								
									 HP_UTIL_MailSmsEnvoi.envoiSync(mailParametres);
									 EmailMessage em = HP_EM019_EmailMessage.createEmailMessage(sender.emailContact,code,null);
									 

			response.addInfo('Octopus Cabestan ' + sender.idForm, 'call WS Octopus Cabestan succeeded');
			return em;
		}catch(Exception e) {
			response.code = HP_HttpStatus.BAD_REQUEST;
			response.addError('Octopus Cabestan Error ' + sender.idForm, e.getMessage());
			return null;
		}

	}

	public static String handlePricingPlan(HP_Contrat__c contrat){
		if(contrat.HP_Souscription__r.HP_Type_Energie__c == 'COMBINED_GAS_AND_ELECTRICITY') {
			return 'HPHC';
		} else if((contrat.HP_Type_de_Compteur__c == 'GAS')
			  || (contrat.HP_Type_de_Compteur__c  == 'ELEC' &&  contrat.HP_Souscription__r.HP_Plan_de_Prix_electrique__c == HP_Constantes.BASE))
		{
			return 'BASE';
		} else if (contrat.HP_Type_de_Compteur__c  == 'ELEC' && contrat.HP_Souscription__r.HP_Plan_de_Prix_electrique__c ==  HP_Constantes.VARIABLE)
		{
			return 'HPHC';
		}
		return null;
	}


	@InvocableMethod(label='send contractualization Email via Cabestan')
	public static void sendMailViaCabestan(List<ObjectToSend> senderList){
		for (ObjectToSend sender : senderList) {
			if (System.IsBatch() == false  && System.isFuture() == false) {
				if (Trigger.isExecuting && sender.idForm == SF12_VALUE) {
					sendMail(SF12, SF12_VALUE, EMAIL, sender.emailContact, ID_CLIENT,
						 String.valueOf(sender.idClient), NAME, sender.name, SURNAME,  sender.firstName, CIVILITEHAPPE,  sender.title, SELLTYPECONST, null, NUM_STREET, sender.numStreet, ENERGYCODE, sender.energy, PRINCING_PLAN_KEY, sender.pricingPlan, STREET, sender.street, ADRESS_COMP,
						 sender.addressComp, ADRESS_CP,  sender.addressCp, TOWN, sender.town, null, null);
						
				} else {
					final String sellType = (sender.sellType == 'Emménagement') ? 'EM' : 'CHF';
					sendMail(SF13, SF13_VALUE, EMAIL, sender.emailContact, ID_CLIENT,
						 String.valueOf(sender.idClient), NAME, sender.name, SURNAME,  sender.firstName, CIVILITEHAPPE,  sender.title, SELLTYPECONST, sellType, NUM_STREET,  sender.numStreet, ENERGYCODE, sender.energy , PRINCING_PLAN_KEY, null, STREET, sender.street, ADRESS_COMP,
						 sender.addressComp, ADRESS_CP,  sender.addressCp, TOWN, sender.town, null, null);
					
				}
			}
		}
	}

	@future(Callout=true)
	public static void sendMail(String idFormKey, String idFormValue,  String emailKey, String emailValue, String idClientKey, String idClientValue, String nameKey, String nameValue,
				    String firstNameKey, String firstNameValue, String titleKey, String titleValue, String sellTypeKey, String sellTypeValue, String numStreetKey, String numStreetValue,
				    String energyKey, String energyValue, String princingPlanKey, String princingPlanValue, String streetKey, String streetValue, String adressCompKey, String addressCompValue, String addressCpKey, String addressCpValue, String townKey, String townValue, String indexResilKey, String indexResilValue){
										 Map<String, String> mailParametres = new Map<String, String>();
								 mailParametres.put('idFormulaireCode', idFormKey);
								 mailParametres.put('idFormulaireLibCourt', idFormValue);
								 mailParametres.put('canalCommunicationLibCourt', 'Email');
								 mailParametres.put('canalCommunicationCode', 'EMAIL');
								 mailParametres.put('email', emailValue);
								 mailParametres.put('idClient',idClientValue);
								 mailParametres.put('NOM', nameValue);
								 mailParametres.put('PRENOM', firstNameValue);
								 mailParametres.put('CIVILITEHAPPE', titleValue);
								 mailParametres.put('typedemande', sellTypeValue);
								 mailParametres.put('norue', numStreetValue);
								 mailParametres.put('energie', energyValue);
								 mailParametres.put('typecomptage', princingPlanValue);
								 mailParametres.put('rue', streetValue);
								 if(!String.isBlank(addressCompValue)) {
									 	mailParametres.put('adressecomp1', addressCompValue);
								 }

								 mailParametres.put('adresseCP', addressCpValue);
								 mailParametres.put('ville', townValue);
							
								 HP_UTIL_MailSmsEnvoi.envoiSync(mailParametres);            
								 HP_EM019_EmailMessage.createEmailMessage(emailValue, Integer.valueOf(idClientValue),idFormKey,null);
	}


	public class ObjectToSend {
		public String idForm;
		@InvocableVariable(required=true)
		public String emailContact;
		// public String adressContact;
		@InvocableVariable(required=true)
		public Integer idClient;
		@InvocableVariable(required=true)
		public String name;
		@InvocableVariable(required=true)
		public String title;
		@InvocableVariable(required=true)
		public String firstName;
		@InvocableVariable(required=true)
		public String sellType;         // EM or CHF
		@InvocableVariable(required=false)
		public String numStreet;
		// public String addressComplement;
		@InvocableVariable(required=true)
		public String energy;
		@InvocableVariable(required=false)
		public String pricingPlan;
		@InvocableVariable(required= false)
		public String street;
		@InvocableVariable(required=false)
		public String addressComp;
		@InvocableVariable(required=false)
		public String addressCp;
		@InvocableVariable(required=false)
		public String town;

		public ObjectToSend(){
		}

		public ObjectToSend(String idForm, String emailContact, Integer idClient, String name, String title, String firstName, String pricingPlan){
			this(idForm, emailContact, idClient, name, title, firstName, null, null, null, pricingPlan,null, null, null, null);
		}


		public ObjectToSend(String idForm, String emailContact, Integer idClient, String name, String title, String firstName, String sellType, String numStreet, String energy, String pricingPlan, String street, String addressComp, String addressCp, String town){
			this.idForm = idForm;
			this.emailContact = emailContact;
			this.idClient = idClient;
			this.name = name;
			this.title = title;
			this.firstName = firstName;
			this.sellType = sellType;
			this.numStreet = numStreet;
			this.energy = energy;
			this.pricingPlan = pricingPlan;
			this.street = street;
			this.addressComp = addressComp;
			this.addressCp = addressCp;
			this.town = town;

		}
	}
}