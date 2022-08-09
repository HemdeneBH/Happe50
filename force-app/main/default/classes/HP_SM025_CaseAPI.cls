/**
 * @File Name          : HP_SM025_CaseAPI.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 02-19-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/03/2020   Vincent Albiser     Initial Version
**/
public with sharing class HP_SM025_CaseAPI {

    public static void caseCreation(HP_WRP034_Case.Request req, HP_WRP022_SFResponse response){

        try{
            dataValidation(req, response);
            if(response.errors.isEmpty()){
                System.debug('req.context : '+req.context);
                System.debug('req.porteFeuilleContratXdataId : '+req.porteFeuilleContratXdataId);
                System.debug('req.contratXdataId : '+req.contratXdataId);
                System.debug('req.energie : '+req.energie);
                System.debug('req.contactInfo : '+req.contactInfo);

                Id contactId;
                if(req.context == 'Consentement' || req.context == 'Anomalie creation xdata Save2' || req.context == 'Coupure_ReductionPuissance'){
                    //contact matching
                    Contact co = HP_EM020_Contact.getContactByXdataId(req.contactInfo.xdataId);
                    contactId = co.Id;
                }else {
                    //contact matching
                    Contact co = HP_EM020_Contact.getContactByMail(req.contactInfo.email);
                    contactId = co != null ? co.Id : null;
                }

                Id souscription;
                if(req.context == 'Anomalie creation xdata Save2') {
                    List<HP_Souscription__c> enrolmentList = HP_EM005_Souscription.loadSouscriptionList(req.selfcareId);
                    if(enrolmentList.size() > 0) {
                        souscription = enrolmentList[0].Id;
                        HP_EM005_Souscription.changeStatus(souscription,'SAVE_2');
                    }
                }

                Id contratId;
                Id portefeuilleContratId;
                if(req.context == 'Coupure_ReductionPuissance') {
                    HP_Porte_Feuille_Contrat__c pfc = HP_EM024_PorteFeuilleContrat.getPortefeuilleContratByXdataId(String.valueOf(req.porteFeuilleContratXdataId));
                    portefeuilleContratId = pfc.Id;
                    HP_Contrat__c contrat = HP_EM023_Contrat.loadContratByXdataId(req.contratXdataId);
                    contratId = contrat.Id;
                }

                //case creation
                Case ca = HP_EM010_Case.createCaseFromAPI(contactId, req.context, req.description, req.contactInfo.firstname, req.contactInfo.lastname, req.contactInfo.email, souscription, portefeuilleContratId, contratId, req.pdl, req.energie, req.contactInfo.clientAide);
                response.addinfo('SM025-1', 'Case created, id : ' + ca.Id);

            }
            else{
                response.code = 400;
            }            	
        }
        catch(Exception e){
            response.addError(e.getMessage(), 'SM025-SF');
            response.code = 400;
		}  
    }
    
    public static void dataValidation(HP_WRP034_Case.Request req, HP_WRP022_SFResponse response){

        if(String.isBlank(req.context)) {
			response.addError('SM025-2','context is required');
        } else {
            switch on req.context {
                when 'Consentement' { 
                    if(String.isBlank(req.description)) {
                        response.addError('SM025-3','description is required');
                    }
                    if(req.contactInfo == null) {
                        response.addError('SM025-4','contactInfo is required');
                    } else {
                        if(req.contactInfo.xdataId == null){
                            response.addError('SM025-8','xdataId can\'t be null');
                        } else if (HP_EM020_Contact.getContactByXdataId(req.contactInfo.xdataId) == null) {
                            response.addError('SM025-9','Contact doesn\'t exist');
                        }  
                    }
                }
                when 'Case offline' {
                    if(String.isBlank(req.description)) {
                        response.addError('SM025-3','description is required');
                    }
                    if(req.contactInfo == null) {
                        response.addError('SM025-4','contactInfo is required');
                    } else {
                        if(String.isBlank(req.contactInfo.firstname)) {
                            response.addError('SM025-5','firstname is required');
                        }
                        if(String.isBlank(req.contactInfo.lastname)) {
                            response.addError('SM025-6','lastname is required');
                        }
                        if(String.isBlank(req.contactInfo.email)) {
                            response.addError('SM025-7','email is required');
                        }
                    }
                }
                when 'Anomalie creation xdata Save2' {
                    if(String.isBlank(req.description)) {
                        response.addError('SM025-3','description is required');
                    }
                    if(req.contactInfo == null) {
                        response.addError('SM025-4','contactInfo is required');
                    } else {
                        if(req.contactInfo.xdataId == null){
                            response.addError('SM025-8','xdataId can\'t be null');
                        } else if (HP_EM020_Contact.getContactByXdataId(req.contactInfo.xdataId) == null) {
                            response.addError('SM025-9','Contact doesn\'t exist');
                        }  
                    }
                    if(String.isBlank(req.selfcareId)) {
                        response.addError('SM025-11','selfcareId is required');
                    } else if(HP_EM005_Souscription.loadSouscriptionList(req.selfcareId).size() == 0) {
                        response.addError('SM025-12','Souscription doesn\'t exist');
                    }
                }
                when 'Coupure_ReductionPuissance' {
                    if(req.porteFeuilleContratXdataId == null) {
                        response.addError('SM025-14','porteFeuilleContratXdataId is required');
                    }
                    if(req.contratXdataId == null) {
                        response.addError('SM025-15','contratXdataId is required');
                    }
                    if(String.isBlank(req.energie)) {
                        response.addError('SM025-16','energie is required');
                    } else if( !(req.energie == 'Gas'||req.energie == 'Electricity') ) {
                        response.addError('SM025-16','energie none identified, possible values: [Electricity,Gas]');
                    }
                    if(String.isBlank(req.pdl)) {
                        response.addError('SM025-17','pdl is required');
                    }
                    if(req.contactInfo == null) {
                        response.addError('SM025-4','contactInfo is required');
                    } else {
                        if(req.contactInfo.xdataId == null) {
                            response.addError('SM025-8','xdataId can\'t be null');
                        } else if (HP_EM020_Contact.getContactByXdataId(req.contactInfo.xdataId) == null) {
                            response.addError('SM025-9','Contact doesn\'t exist');
                        }  
                        if(req.contactInfo.clientAide == null) {
                            response.addError('SM025-18','clientAide can\'t be null');
                        }
                    }
                }

                when else {
                    response.addError('SM025-10','Context none identified');
                }
            }
        }


    /* //Validation Code Before Changes//

        if(String.isBlank(req.context)) {
			response.addError('SM025-2','context is required');
        }else if(!req.context.equals('Consentement')  && !req.context.equals('Case offline') && !req.context.equals('Anomalie creation xdata Save2')){
            response.addError('SM025-10','Context none identified');
        }
        if(String.isBlank(req.description)) {
			response.addError('SM025-3','description is required');
        }
        if(req.contactInfo == null) {
			response.addError('SM025-4','contactInfo is required');
        }
        else{
            if(String.isBlank(req.contactInfo.firstname) && req.context == 'Case offline') {
                response.addError('SM025-5','firstname is required');
            }
            if(String.isBlank(req.contactInfo.lastname) && req.context == 'Case offline') {
                response.addError('SM025-6','lastname is required');
            }
            if(String.isBlank(req.contactInfo.email) && req.context == 'Case offline') {
                response.addError('SM025-7','email is required');
            }
            if(req.contactInfo.xdataId == null && (req.context == 'Consentement' || req.context == 'Anomalie creation xdata Save2')){
                response.addError('SM025-8','xdataId can\'t be null');
            }
            else if ((req.context == 'Consentement' || req.context == 'Anomalie creation xdata Save2') && HP_EM020_Contact.getContactByXdataId(req.contactInfo.xdataId) == null) {
                response.addError('SM025-9','Contact doesn\'t exist');
            }  
        }
        if(String.isBlank(req.selfcareId) && req.context == 'Anomalie creation xdata Save2') {
            response.addError('SM025-11','selfcareId is required');
        }
        else if(req.context == 'Anomalie creation xdata Save2' && HP_EM005_Souscription.loadSouscriptionList(req.selfcareId).size() == 0) {
            response.addError('SM025-12','Souscription doesn\'t exist');
        }
    */
	}
}