/**
 * @File Name          : HP_PersonneService.cls
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda
 * @Last Modified On   : 11-22-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    13/12/2019   Mohamed Aamer     Initial Version
**/
public with sharing class HP_PersonneService{

    public static String ecrirePersonne(String infosPersonneJson) {
        HttpResponse httpResponse = handleResponse(infosPersonneJson);
        String location;
        if(httpResponse.getHeaderKeys().contains(HP_HttpUtils.HTTP_LOCATION)){
            location = httpResponse.getHeader(HP_HttpUtils.HTTP_LOCATION); 
        }else if(httpResponse.getHeaderKeys().contains(HP_HttpUtils.HTTP_LOCATION_APIGEE)){
            location = httpResponse.getHeader(HP_HttpUtils.HTTP_LOCATION_APIGEE);
        }
        return location.substringAfterLast(HP_HttpUtils.URI_SEP);
    }

    public static HttpResponse handleResponse(String infosPersonneJson) {

        HttpResponse httpResponse = HP_UTIL_HTTPUtils.calloutPost(HP_Constantes.XDATA_PERSONNE, infosPersonneJson);
        if (httpResponse.getStatusCode() == HP_HttpStatus.OK || httpResponse.getStatusCode() == HP_HttpStatus.CREATED) {
            return httpResponse;
        }
        return null;
    }

    public static Map<String, Object> loadPersonne(String personneId) {
        final HTTPResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_PERSONNE,  '/'+personneId);
        return (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
       
    }

    /**
    * @description charger les doublons
    * @author Slimene Belhaj Ali | 20/01/2020
    * @return list de contact 
    **/
    public static List<Contact> loadContactDoublonsList(Map<String,Object> currentContact) {
		
		String firstName = (String)currentContact.get('prenom');
		String lastName = (String)currentContact.get('nom');
		String email = (String)currentContact.get('email');
		String mobileTel = (String)currentContact.get('numeroMobile');
		String fixeTel = (String)currentContact.get('numeroFixe');
		String codePostal = (String)currentContact.get('codePostal');
		String ville = (String)currentContact.get('ville');
		String rue = (String)currentContact.get('voie');
		String numVoie = (String)currentContact.get('numVoie');
		String numvoiePlusVoie =numVoie + ' ' + numVoie;
		System.System.debug('@@ currentContact ' + currentContact);
		List<Contact> contactList = [select Id, FirstName, LastName 
										from Contact where (email = :email and email!= null)
										or (lastName = :lastName and MobilePhone like :mobileTel and MobilePhone != null)
										or (lastName = :lastName and Phone like :fixeTel and Phone != null)
										or (lastName = :lastName and MailingPostalCode = :codePostal and MailingCity = :ville and MailingStreet = :rue 
										and No_Voie__c = :numVoie and (MailingPostalCode != null or MailingCity != null or MailingStreet != null or No_Voie__c != null))
										or (lastName = :lastName and MailingPostalCode = :codePostal and MailingCity = :ville and MailingStreet = :numvoiePlusVoie
                                        and(MailingPostalCode != null or MailingPostalCode != null or MailingCity != null or MailingStreet != null))];

		return contactList;
    }
    
    public static boolean notifierAgilabModifContact(Decimal xdataContact) {
        final HTTPResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_CONTACT_NOTIFIER_MODIFICATION, 'id_client_xdata=' + Integer.valueOf(xdataContact));

        return (response.getStatusCode() == HP_HttpStatus.OK || response.getStatusCode() == 422);


    }

    public static List<Map<String, Object>>  getPersonneXdataId(String email) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        String str = 'Cet email n\'est pas associé à un id xdata dans la base agilab';

        final HTTPResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_PERSONNE_XDATA_ID	,  '?email='+email);
        System.System.debug('@@ response.getBody() ' + response.getBody());
        boolean hasNoIdXdata = response.getBody().contains(str);
        if(hasNoIdXdata){
            Map<String, Object> mapContains  =   (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            result.add(mapContains);
            return result;
        }

        List<Object> listIds = (List<Object>) JSON.deserializeUntyped(response.getBody());
               for (Object item : listIds) {
                Map<String, Object> itemMap =  (Map<String, Object>)item;
                result.add(itemMap);
               }
               return result;
    }

}