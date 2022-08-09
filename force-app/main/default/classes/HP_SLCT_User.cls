/**
 * @File Name          : HP_SLCT_User.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 28/04/2020 à 06:42:26
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/04/2020   Vincent Albiser     Initial Version
**/
public with sharing class HP_SLCT_User {
	// get the information of the selected user
	@AuraEnabled
	public static User retriveUser(Id userId){
		User us = [SELECT ID, FirstName, LastName, Name, Title, Profile.Name, UserRole.Name, Email, Distributor_Login__c From User WHERE ID =: userId LIMIT 1];

		return us;
	}
}