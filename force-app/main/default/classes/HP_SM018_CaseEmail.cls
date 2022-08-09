/**
 * @File Name          : HP_SM018_CaseEmail.cls
 * @Description        : HAPP-978 API Custom : intégrer une demande de recontact comme un mail dans Salesforce
 * @Author             : Colince FOTSO
 * @Group              :
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 09/02/2020 à 23:34:15
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    28/01/2020   Colince FOTSO     Initial Version
**/
public  class HP_SM018_CaseEmail implements Messaging.InboundEmailHandler{
	/**
	* @description
	* @author Colince FOTSO | 28/01/2020
	* @param Messaging.inboundEmail email
	* @param Messaging.InboundEnvelope env
	* @return Messaging.InboundEmailResult
	**/
	public Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){

	return HP_EM021_CaseEmail.createCaseEmailWithAttachements(email);

	}
}