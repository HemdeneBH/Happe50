/**
 * @description  : 
 * @author       : Vincent Albiser
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   25-11-2020   Vincent Albiser   Initial Version
**/
@IsTest
public with sharing class HP_HDL002_Contact_TEST {

    @IsTest
	static void insertAccountTrigger(){
 
        Contact contact = (Contact)HP_UTIL_SmartFactory.createSObject('Contact', 'HP_Contact', new Map<String, Object>{
            'Id_Tiers__c' => 100166,
            'Salutation'=>'MR',
            'lastName' => 'testnicot',
            'firstName' => 'lenfant',
            'email' => 'user@example.com',
            'mobilePhone' => '0756543434',
            'Phone' => '0145454545',
            'No_Voie__c' => '22',
            'MailingStreet' => 'rue des bois',
            'MailingPostalCode' => '92160',
            'Complement_adresse__c' => 'REZID',
            'MailingCity' =>'ANTONY'
        }, null, null, null);
        insert contact;

        Contact contact2update = HP_EM020_Contact.getContactByXdataId(100166);
        contact2update.email = 'update@gmail.com';
        update contact2update;
    }

}