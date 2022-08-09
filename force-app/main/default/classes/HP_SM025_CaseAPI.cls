/**
 * @File Name          : HP_SM025_CaseAPI.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 03-17-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/03/2020   Vincent Albiser     Initial Version
**/
public with sharing class HP_SM025_CaseAPI {

    public static void caseCreation(HP_WRP034_Case.Request req, HP_WRP022_SFResponse response){

        try{
            dataValidation(req, response);
            if(response.errors.isEmpty()){
                Id contactId;
                if(req.context == 'Retablissement' || req.context == 'Consentement' || req.context == 'Anomalie creation xdata Save2' || req.context == 'Coupure_ReductionPuissance' || req.context == 'MAJCoupure_ReductionPuissance'){
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
                if(req.context == 'Retablissement' || req.context == 'Coupure_ReductionPuissance' || req.context == 'MAJCoupure_ReductionPuissance') {
                    HP_Porte_Feuille_Contrat__c pfc = HP_EM024_PorteFeuilleContrat.getPortefeuilleContratByXdataId(String.valueOf(req.porteFeuilleContratXdataId));
                    portefeuilleContratId = pfc.Id;
                    HP_Contrat__c contrat = HP_EM023_Contrat.loadContratByXdataId(req.contratXdataId);
                    contratId = contrat.Id;
                }

                
                if(req.context == 'MAJCoupure_ReductionPuissance') {
                    // MAJ: Case & Prestation
                    Prestation_distributeur__c prestation = HP_EM007_PrestationDistributeurManager.loadPrestationDistributeur(req.numeroAffaire);
                    Case c = HP_EM010_Case.loadCase(prestation.Case__c)[0];
                    traitementMAJCoupure(contactId, portefeuilleContratId, contratId, req.numeroAffaire, req.contactInfo.clientAide, req.energie, req.etat, req.objectCode, req.motifNonRealisationCode, req.motifCode, req.attestationPaiement, req.remiseChq, prestation, c);
                } else {
                //case creation
                    Case ca = HP_EM010_Case.createCaseFromAPI(contactId, req.context, req.description, req.contactInfo.firstname, req.contactInfo.lastname, req.contactInfo.email, souscription, portefeuilleContratId, contratId, req.pdl, req.energie, req.contactInfo.clientAide, req.montant_paiement);
                response.addinfo('SM025-1', 'Case created, id : ' + ca.Id);
                }

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
    
    private static void traitementMAJCoupure(Id contactId, Id portefeuilleContratId, Id contratId, String numeroAffaire, Boolean clientAide, String energie, 
                                Integer etat, String objectCode, String motifNonRealisationCode, String motifCode, Boolean attestationPaiement, Boolean remiseChq, 
                                Prestation_distributeur__c prestation, Case c) {
        
        
        //---------------------------------------------------------------------------------------//
        System.debug('contactId : '+contactId);                            
        System.debug('portefeuilleContratId : '+portefeuilleContratId);
        System.debug('contratId : '+contratId);
        System.debug('numeroAffaire : '+numeroAffaire);
        System.debug('clientAide : '+clientAide);
        System.debug('energie : '+energie);
        System.debug('etat : '+etat);
        System.debug('objectCode : '+objectCode);
        System.debug('motifNonRealisationCode : '+motifNonRealisationCode);
        System.debug('motifCode : '+motifCode);
        System.debug('attestationPaiement : '+attestationPaiement);
        System.debug('remiseChq : '+remiseChq);

        System.debug('prestation : '+prestation);
        System.debug('case : '+c);
        //---------------------------------------------------------------------------------------//

        switch on etat {
            when 1 {
                System.debug('nous sommes dans l\'etat : '+etat);
                c.Status = 'CLOSED';
                c.HP_Sous_type__c = 'Prestation réalisée';
                prestation.Statut__c = 'Terminé';

                if(energie == 'Electricity') {
                    if(objectCode == 'RPI' || objectCode == 'RET') {
                        c.HP_Comment__c = 'PDL {'+prestation.Numero_PDL_PCE__c+'} réduit le {'+ Date.today().format() +'} - {'+prestation.Numero_affaire_distributeur__c+'}';
                        // Mail A
                    } else if(objectCode == 'SAI') {
                        c.HP_Comment__c = 'PDL {'+prestation.Numero_PDL_PCE__c+'} coupé le {'+ Date.today().format() +'} - {'+prestation.Numero_affaire_distributeur__c+'}';

                        Case caseResiliation = new Case();
                        caseResiliation.ParentId = c.Id;
                        caseResiliation.recordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase');
                        caseResiliation.HP_Type__c = 'HP_Resiliation_fournisseur';
                        caseResiliation.Status = 'DELAYED_PROCESS';
                        caseResiliation.HP_TreatmentDate__c = Date.today().addDays(15);
                        caseResiliation.HP_TypePrestation__c = 'Coupure';
                        caseResiliation.ContactId = contactId;
                        caseResiliation.HP_Contrat__c = contratId;
                        caseResiliation.HP_PDL_PCE__c = prestation.Numero_PDL_PCE__c;
                        caseResiliation.HP_Energy__c = c.HP_Energy__c;
                        insert caseResiliation;
                        // Mail B
                    }
                }
                
                if(energie == 'Gas') {
                    Case caseResiliation = new Case();
                    caseResiliation.ParentId = c.Id;
                    caseResiliation.recordTypeId = HP_UTIL_RecordType.getRecordTypeId('Case','HP_ContractCancelationCase');
                    caseResiliation.HP_Type__c = 'HP_Resiliation_fournisseur'; // à vérifier
                    caseResiliation.Status = 'DELAYED_PROCESS';
                    caseResiliation.HP_TreatmentDate__c = Date.today().addDays(15);
                    caseResiliation.HP_TypePrestation__c = 'Coupure';
                    caseResiliation.ContactId = contactId;
                    caseResiliation.HP_Contrat__c = contratId;
                    caseResiliation.HP_PDL_PCE__c = prestation.Numero_PDL_PCE__c;
                    caseResiliation.HP_Energy__c = c.HP_Energy__c;
                    insert caseResiliation;
                    // Mail C
                }
            }
            when 2 {
                System.debug('nous sommes dans l\'etat : '+etat);
                prestation.Statut__c = 'Annulé';

                if(energie == 'Electricity') {
                    c.Status = 'TO_DO';
                    c.HP_Sous_type__c = 'Prestation non réalisée';
                    c.OwnerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1');

                    if(objectCode == 'RPI') {
                        c.HP_Comment__c = 'La demande de réduction de puissance n\'a pas été réalisée sur le PDL {'+prestation.Numero_PDL_PCE__c+'} - {'+prestation.Numero_affaire_distributeur__c+'} - {'+ Date.today().format()+'}';
                    } else if(objectCode == 'SAI') {
                        if(attestationPaiement) {
                            c.HP_Comment__c = 'Non réalisé - Remise attestation - {'+prestation.Numero_affaire_distributeur__c+'} - {'+ Date.today().format()+'}';
                        }
                        if(remiseChq) {
                            c.HP_Comment__c = 'Non réalisé - Remise Chèque - {'+prestation.Numero_affaire_distributeur__c+'} - {'+ Date.today().format()+'}';
                        }
                        if(attestationPaiement == false && remiseChq == false) {
                            c.HP_Comment__c = 'Prestation non réalisée sur le PDL {'+prestation.Numero_PDL_PCE__c+'} - {'+motifNonRealisationCode+'} - {'+prestation.Numero_affaire_distributeur__c+'} - {'+ Date.today().format()+'}';
                        }
                    }
                }
            }
            when 3 {
                System.debug('nous sommes dans l\'etat : '+etat);
                prestation.Statut__c = 'Annulé';

                if(energie == 'Electricity') {
                    c.Status = 'DELAYED_PROCESS';
                    c.HP_Sous_type__c = 'Réduction de puissance	';
                    c.HP_Comment__c = 'PDL {'+prestation.Numero_PDL_PCE__c+'} limité le {'+ Date.today().format()+'}';
                    c.HP_TreatmentDate__c = Date.today().addDays(10);
                }
            }
            when 4 {
                System.debug('nous sommes dans l\'etat : '+etat);
                prestation.Statut__c = 'Annulé';

                c.OwnerId = HP_UTIL_QueueManager.getQueueIdByName('HP_Niveau_1');
                c.Status = 'TO_DO';
                c.HP_Sous_type__c = 'Prestation annulée';
                c.HP_Comment__c = 'Prestation annulée par le distributeur le {'+ Date.today().format()+'} sur le PDL {'+prestation.Numero_PDL_PCE__c+'} - {'+motifCode+'} - {'+prestation.Numero_affaire_distributeur__c+'}';
            }
        }
        System.debug('***case to update owner***'+c.OwnerId);
        System.debug('***case to update***'+c);
        update prestation;
        update c;
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
                when 'MAJCoupure_ReductionPuissance' {
                    if(req.porteFeuilleContratXdataId == null) {
                        response.addError('SM025-14','porteFeuilleContratXdataId is required');
                    }
                    if(req.contratXdataId == null) {
                        response.addError('SM025-15','contratXdataId is required');
                    }
                    if(String.isBlank(req.numeroAffaire)) {
                        response.addError('SM025-21','numeroAffaire is required');
                    } else {
                        if(HP_EM007_PrestationDistributeurManager.loadPrestationDistributeur(req.numeroAffaire) == null) {
                            response.addError('SM025-22','Prestation Distributeur doesn\'t exist, search by numeroAffaire: '+req.numeroAffaire);
                        } else if(HP_EM007_PrestationDistributeurManager.loadPrestationDistributeur(req.numeroAffaire).Case__c == null) {
                            response.addError('SM025-23','No case associated to the Prestation Distributeur, search by numeroAffaire: '+req.numeroAffaire);
                        }
                    }
                    if(String.isBlank(req.energie)) {
                        response.addError('SM025-16','energie is required');
                    } else if( !(req.energie == 'Gas'||req.energie == 'Electricity') ) {
                        response.addError('SM025-16','energie none identified, possible values: [Electricity,Gas]');
                    }
                    if(req.etat == null) {
                        response.addError('SM025-24','etat is required');
                    } else if( !(req.etat == 1 || req.etat == 2 || req.etat == 3 || req.etat == 4)) {
                        response.addError('SM025-25','etat none identified, possible values: [1,2,3,4]');
                    }
                    if(req.contactInfo == null) {
                        response.addError('SM025-4','contactInfo is required');
                    } else {
                        if(req.contactInfo.xdataId == null) {
                            response.addError('SM025-8','xdataId can\'t be null');
                        } else if (HP_EM020_Contact.getContactByXdataId(req.contactInfo.xdataId) == null) {
                            response.addError('SM025-9','Contact doesn\'t exist');
                        }
                    }
                }
                when 'Retablissement'{
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
                    if(req.montant_paiement == null){
                        response.addError('SM025-26','montant_paiement can\'t be null');
                    }
                    if(String.isBlank(req.pdl) || req.pdl ==null) {
                        response.addError('SM025-17','pdl is required');
                    }
                }

                when else {
                    response.addError('SM025-10','Context none identified');
                }
            }
        }

	}
}